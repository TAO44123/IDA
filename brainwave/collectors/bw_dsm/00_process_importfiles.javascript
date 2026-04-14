/* adapted from  views/bw_datasourcemanagement/transcodeandsave.javascript 
to be used inside a collector (uses provisioning instead of businessview) */



/*

process all the files for a given datasource.

  input:
  code
  sourcepath
  destpath
  filepattern
  
  output:
  error
  message
  
*/

function processDatasourceFiles() {

	var /*String*/ code = dataset.code.get();	
	var /*String*/ destpathvar = dataset.destpathvar.get();
	var /*String*/ filepattern = dataset.filepattern.get();
	var /*Boolean*/ multifile = dataset.multifile.get();
	var /*String*/ destdirpath = dataset.destdir.get(); 
	var /*String*/ sourcepath = config.bwdsm_sourcepath + "/"+ code;
	var /*String*/ destpath = config[destpathvar]+ "/" + code;
	
	var errorcounter = 0;
	
	// create result variables
	var /*Attribute<String>*/ code_attr = dataset.add("codes", "String", true);
	var /*Attribute<String>*/ filename_attr = dataset.add("filename", "String", true);	
	var /*Attribute<String>*/ sourcefile_attr = dataset.add("sourcefile", "String", true);
	var /*Attribute<String>*/ sourcehash_attr = dataset.add("sourcehash", "String", true);	
	var /*Attribute<Number>*/ size_attr = dataset.add("size", "Number", true);
	var /*Attribute<Number>*/ nbrows_attr = dataset.add("nbrows", "Number", true);
	var /*Attribute<Number>*/ uploaddate_attr = dataset.add("uploaddate", "Number", true);
	var /*Attribute<String>*/ by_attr = dataset.add("by", "String", true);
	var /*Attribute<String>*/ destfile_attr = dataset.add("destfile", "String", true);
	var /*Attribute<String>*/ desthash_attr = dataset.add("desthash", "String", true);
	var /*Attribute<String>*/ error_attr = dataset.add("error", "String", true);
	
	var /*java.io.File*/ sourceDir = new java.io.File(sourcepath);	
	
	if (destdirpath !== null){
		var /*String*/ importfiles = config.importfiles ; 
		var /*java.io.File*/ destDir = new java.io.File(importfiles , destdirpath);	
		if (sourceDir.exists()){
		  org.apache.commons.io.FileUtils.copyDirectory(sourceDir, destDir);
		  print( "Import file processing for datasource "+ code + " copied entire directory to destination");		
		}
		return;
	}
	
	/*get previous execution values for comparison 
	if not multi file, we take the first value.
	if multi-file, we compare each file with the same name (path)
	*/
	var previousSizeMap = new java.util.HashMap();
	var previousSize = 0;
	var /*String*/ activeTs = getActiveTimeslotUid();
	if (activeTs != null){
		var params = new java.util.HashMap();
		params.put("code", code );
		var res = provisioning.executeView(activeTs, "bwdsm_listfiles_ds" , params);
		if (res != null){
			for (var i=0; i<res.length;i++){
				var row = res[i];
				previousSize = row.get('size');
				previousSizeMap.put( row.get('filename'), previousSize );				
			}	
		}
	}
		
	var /*java.text.SimpleDateFormat*/ ldapdateformat = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
	// traverse source directory 
	var nbfiles=0;
	var /*java.io.File[]*/ files = sourceDir.listFiles();
	
	if (files !== null){
		for(var i=0;i<files.length;i++) {
			var /*java.io.File*/ file = files[i];
			if(!file.isDirectory()){
				var filename = file.getName();
				// use same matcher class than silo 
				if (com.brainwave.iaudit.database.tools.WildcardMatcher.wildcardMatch(filename,filepattern )) {
					nbfiles++;
					if (multifile){
					  previousSize = previousSizeMap.get(filename);	
					}
	            	var sourcefile = file.getCanonicalPath();             	
	            	var /*String*/ destinationFile = new java.io.File( destpath, filename).getCanonicalPath() ; 
	            	var /*java.util.Date*/ lastModified = new java.util.Date(file.lastModified());
	            	var /*String*/ dateStr = ldapdateformat.format(lastModified);
	            	// check file and format
	            	var res = checkFile(code, sourcefile,  previousSize, multifile );  // null if no error
	            	var nbrows = res.nbrows;
	            	var sha = res.sha;
	            	var error = res.error;            	
		            if (error == null) {
		               error = transcodeFile(code, sourcefile, destinationFile );
		               if(error != null) {
		               		throw new java.lang.RuntimeException('Error encountered when transcoding ' + sourcefile + ' for ' + code + ' : ' + error); 
		               }
		            } 
		            else { 
		            	errorcounter++;
		            	throw new java.lang.RuntimeException('Error encountered during validation of ' + sourcefile + ' for ' + code + ' : ' + error); 
		            }          		
	            	// transcode
	            	// write result attributes, make sure to always write all attributes
	            	code_attr.add(code);
	            	filename_attr.add(filename);
	            	sourcefile_attr.add(sourcefile) ;
	            	sourcehash_attr.add(sha);
	            	size_attr.add(file.length()); 
	            	nbrows_attr.add(nbrows);	            	
	            	uploaddate_attr.add(dateStr); 
	            	by_attr.add("controller");
	            	destfile_attr.add(destinationFile);
	            	desthash_attr.add(error == null ? sha256(destinationFile): '' );
	            	error_attr.add(error);      	         	
	            }
			}
		}			
	}
	print( "Import file processing for datasource "+ code + " processed "+ nbfiles+" file(s) and ended with "+errorcounter+ " error(s) : " + error);
}

/* checks file
peforms various checks:
- check size variation
- check for mapping constraints ( uniqueness, etc) 
- check size variations if defined
performs various stats:  
- sha256 of file
- nb lines 

if no configuration found, returns OK 

if no configuration found, we make the minimum checks
returns: { sha: xxx, nbrows: nnn, error: xxx } 
*/
function checkFile( /*String*/ code, /*String*/ sourcefile ,/*Number*/ previoussize, /*boolean*/ multifile ) {
	var checker = new com.brainwave.utils.CSVFormatChecker();
	var sha256 = checker.getFileHash(sourcefile);	
	var nbrows = null;
	var error = null; 
	try {
			
		// get general configuration
		var params = new java.util.HashMap();
	  	params.put("code", code );
	  	var res = provisioning.executeView(null, "bw_getdatasourceconfig" , params);
	  	if(res == null || res.length == 0) {
	  		// no config, return what we have
			return { sha: sha256, nbrows: nbrows , error: error}; 
	  	}
	  	
		var separator = res[0].get("bw_datasourceformat_separator").toString();
		var delimiter = res[0].get("bw_datasourceformat_delimiter").toString();
		var encoding = res[0].get("bw_datasourceformat_encoding").toString();
		var booleanformat = res[0].get("bw_datasourceformat_booleanformat").toString();
		var dateformat = res[0].get("bw_datasourceformat_dateformat").toString();
		var minimumnblines = (res[0].get("bw_datasourceformat_minimumnblines")!=null)?res[0].get("bw_datasourceformat_minimumnblines").intValue():0;

		var checksize = (res[0].get("bw_datasourceformat_checkfilesizevariation")!=null)?res[0].get("bw_datasourceformat_checkfilesizevariation").booleanValue():false;
		var checksizevariation = (res[0].get("bw_datasourceformat_filesizevariation")!=null)?res[0].get("bw_datasourceformat_filesizevariation").intValue():0;

		checker.setEncoding(encoding);
		checker.setDelimiter(delimiter);
		checker.setSeparator(separator);
		checker.setMinrowsize(minimumnblines);
		checker.setDateformat(dateformat);
		checker.setBooleanFormat(booleanformat);
	
		// get columns definition
	  	res = provisioning.executeView( null, "bw_getdatasourcecolumns" , params);
	  	if(res == null || res.length == 0) {
			return { sha: sha256, nbrows: nbrows, error: "No columns defined. You MUST declare at least ONE column in the file configuration"};
	  	}
	
		for(var i=0;i<res.length;i++) {
			var name = res[i].get("bw_datasourcecolumn_name").toString();
			var type = res[i].get("bw_datasourcecolumn_type").toString();
			var isunique = (res[i].get("bw_datasourcecolumn_mustbeunique")!=null)?res[i].get("bw_datasourcecolumn_mustbeunique").toString():"No";
			var format = (res[i].get("bw_datasourcecolumn_format")!=null)?res[i].get("bw_datasourcecolumn_format").toString():'';
			var formatstr = (res[i].get("bw_datasourcecolumn_formatprettystring")!=null)?res[i].get("bw_datasourcecolumn_formatprettystring").toString():'';
			var /*String*/ mandatory = res[i].get("bw_datasourcecolumn_mandatory").toString();
			mandatory = mandatory.equalsIgnoreCase('true')?'Yes':'No';	
			var /*Number*/ fillfactor = Number(res[i].get("bw_datasourcecolumn_minimumfillfactor").toString());
			if(isNaN(fillfactor))
				fillfactor = 0;

			checker.addColumn(name, type, format, formatstr, mandatory, isunique, fillfactor);
		}

		// --------------------------------------
		// check the file size
		if(checksize) {	
			if(previoussize>0 && checksizevariation>0) {
				var gap = previoussize*checksizevariation/100;
				var low = previoussize-gap; 
				var high = previoussize+gap; 
	
				var /*java.io.File*/ f = new java.io.File(sourcefile);
				var currentsize = f.length();
				
				if(currentsize<low || currentsize>high) {
					error = "The current file size is inconsistent as compared with the previous one. Current file size is "+currentsize+" previous file size is "+previoussize+" variation threshold is set to +/- "+checksizevariation+"%"
				}
			}
		}
	
		// --------------------------------------
		// performs the check with previous parameters
		var result = checker.check(sourcefile);
		
		if(result!=null && result.length>0) {
			return { sha: sha256, nbrows: nbrows, error: "Validation failed. First error is: " + result[0]};
		}
		nbrows = checker.getTotalNbOfRecords();
		// return whatever we have, may be an error
		return {  
			sha: sha256, nbrows: nbrows, error: error
		} ; 
	}
	catch(e) {
		return { sha: sha256, nbrows: nbrows, error:"Unkown system error while checking the file"};
	}	
}


/*
  dataset columns:
  code
  sourcefile
  destinationfile
  
*/
// ////////////////////////////////////////////////

// ///////////////////////////////////////////////////////
// Read the source file and transcode it in pivot format
// return null if OK or error string
var truevalues = new Array();
var defaultDateFormat = '';
var linecounter = 0;

function transcodeFile( /*String*/ code, /*String*/ sourcefilepath, /*String*/  destfilepath ) {

    // make sure dest directory exists
    var destFile = new java.io.File(destfilepath);
    destFile.getParentFile().mkdirs();
	// 2. Get source file definition (format & columns)
	var params = new java.util.HashMap();
	params.put('code', code);
	var res = provisioning.executeView(null, 'bw_getdatasourceconfig', params);
	if(res==null || res.length==0) {
		// no config, just copy the file
		return copyFile(sourcefilepath, destfilepath);		
	}
	var record = res[0];
	var /*String*/ separator = record.get('bw_datasourceformat_separator');  
	var /*String*/ delimiter = record.get('bw_datasourceformat_delimiter');  
	var /*String*/ encoding = record.get('bw_datasourceformat_encoding');  
	var /*String*/ booleanformat = record.get('bw_datasourceformat_booleanformat');  
	var /*String*/ dateformat = record.get('bw_datasourceformat_dateformat');  

	// parse allowed boolean values for true	
	if(booleanformat!=null && booleanformat.length>0) {
		var trueelements = booleanformat.split(";");
		if(trueelements!=null && trueelements.length>0) {
			trueelements = trueelements[0];
			trueelements = trueelements.split(",");
			if(trueelements!=null && trueelements.length>0) {
				for(var i=0;i<trueelements.length;i++) {
					var /*String*/ trueelement = trueelements[i];
					trueelement = trueelement.trim();
					trueelement = trueelement.toLowerCase();
					truevalues.push(trueelement);
				}
			}		
		}
	}
	if(truevalues.length==0) { // default values for True if booleanformat parsing failed
		truevalues.push('1');
		truevalues.push('true');
		truevalues.push('yes');
		truevalues.push('oui');
	}
	// set default date format
	defaultDateFormat = dateformat;
	if(defaultDateFormat == null || defaultDateFormat.trim().length==0) {
		defaultDateFormat = 'dd/MM/yyyy HH:mm:ss'; // european format as a default format if nothing is provided
	}
	
	var /*java.util.HashMap*/ columns = new Array();
	var /*java.util.HashMap*/ columnsMap = new java.util.HashMap();
	var res = provisioning.executeView(null, 'bw_getdatasourceallcolumns', params);
	if(res==null || res.length==0) {
		return 'No CSV columns declared in the configuration' ;
	}
	
	for(var i=0;i<res.length;i++) {
		record = res[i];
		
		var /*String*/ name = record.get('bw_datasourcecolumn_name');	
		var /*String*/ type = record.get('bw_datasourcecolumn_type');	
		var /*String*/ format = record.get('bw_datasourcecolumn_format');	
		var /*Boolean*/ iscomputed = record.get('bw_datasourcecolumn_iscomputed');	
		var /*String*/ computedexpression = record.get('bw_datasourcecolumn_computedexpression');	
	
		var column = {};
		column.name = name;
		column.type = type;
		column.format = format;
		column.iscomputed = iscomputed;
		column.computedexpression = computedexpression;

		columns.push(name);
		columnsMap.put(''+name, column);
	}
	
	
	// 4. Get destination file format & mapping
	var /*java.util.HashMap*/ mappingsMap = new java.util.HashMap();
	var /*Array*/ mappings = new Array();
	var res = provisioning.executeView(null, 'bw_getdatasourcemapping', params);
	if(res==null || res.length==0) {
		return 'No column mapping declared in the configuration' ;
	}
	
	for(var i=0;i<res.length;i++) {
		record = res[i];
		
		var /*String*/ name = record.get('name');	
		var /*String*/ type = record.get('type');	
		var /*String*/ column = record.get('column');	
	
		// only considering mapped columns
		if(column !=null && column.length>0) {
			var mapping = {};
			mapping.name = name;
			mapping.type = type;
			mapping.column = column;
			
			mappingsMap.put(''+name, mapping);
			mappings.push(name);
		}
	}
	
	
	// ////////////////////////////////////////////////
	// read and transcode file CSV file
	
	// init the destination file
	var handle = csvFile_Create(destfilepath,mappings);
	var fileparser = provisioning.getFileParser('CSV');	
	
	try {
	
		// prepare the 'encoding' parameter with a value compatible with 'provisioning.getFileParser'
		if(encoding == null || encoding.length==0)
			encoding = 'UTF-8'; // defaults to UTF-8
		else if(encoding.equals('windows-1252'))
			encoding = 'CP1252';
		else if(encoding.equals('ascii'))
			encoding = 'IBM850';
		
		// parse the source file
		fileparser.separator = separator;
		fileparser.textseparator = delimiter;
		fileparser.encoding = encoding;
		fileparser.open(sourcefilepath);
		
		var /*Array*/ headers = fileparser.readHeader();
		
		var /*Array*/ line = null;
		var /*java.util.HashMap*/ lineMap = new java.util.HashMap();
		var /*java.util.HashMap*/ cache = new java.util.HashMap();
		while((line=fileparser.readLine())!=null) {
			linecounter++;
			// En 3 temps 
	
			// 1. on lit les valeurs de la ligne du CSV et on crée une map, on transcode sur la base de la configuration (Date, Boolean, ...)
			lineMap.clear();
			for(var i=0;i<headers.length;i++) {
				var /*String*/ name = headers[i];
				var /*String*/ val = line[i];
				val = evalValue(name, val, columnsMap);
				lineMap.put(''+name, ''+val);
	
				var obj = columnsMap.get(''+name);
			}
			// 2. on liste les colonnes calculées, on calcule les valeurs et on enrichie la map au fur et a mesure
			for(var i=0;i<columns.length;i++) {
				var /*String*/ name = columns[i];
				var obj = columnsMap.get(''+name);
				var iscomputed = obj.iscomputed;
				if(iscomputed!=null && iscomputed==1) {
					var /*String*/ expression = obj.computedexpression;
					var /*String*/ val = compute(expression, lineMap);
					lineMap.put(''+name, ''+val);
				}
			}
	
			// 3. on itere sur les 'mappings' pour identifier les infos a ecrire
			cache.clear();
			for(var i=0;i<mappings.length;i++) {
				var mapping = mappings[i];
				var map = mappingsMap.get(''+mapping);
				var desttype = map.type;
				var column = map.column;
				var value = lineMap.get(''+column);
				var name = map.name;
	
				value = checkFormat(value, desttype); // double check that we write data in the expected format, otherwise remove string (to avoid any problem in the collect line)
	
				cache.put(''+name, ''+value);
			}
			
			// On sauvegarde la ligne dans le fichier de destination
			csvFile_addLine(handle,cache);
			
		}
	}
	catch(/*java.lang.Exception*/ e){
		return e.getMessage() ;
	}
	finally {
		// everything is done, let's wrap up
		csvFile_close(handle);
		fileparser.close();		
	}
	return null; 

}

function getActiveTimeslotUid(){
   var res=provisioning.executeView(null, "bwdsm_activetimeslot" )	;
   if (res != null && res.length>0){
   	  return res[0].get("uid");
   }
   return null;
}

/**
 * transcode transcode the value depending on its type
 * 
 * @param name the column name
 * @param val the value to transcode
 * @param definition a HashMap containing the definition for all columns
 * @return the transcoded value as a String
 */
function evalValue(/*String*/ name, /*String*/ val, /*java.util.HashMap*/ definition) {
	var column = definition.get(''+name);
	var type = column.type;
	
	if('Boolean'.equals(type)) {
		val = transcodeBoolean(val);	
	}
	else if('Date'.equals(type)) {
		var format = defaultDateFormat;		
		val = transcodeDate(val, format);
	}
	else if('Customdate'.equals(type)) {
		var format = column.format;
		if(format == null || format.trim().length==0)
			format = defaultDateFormat; // fall back to default date format if no format is provided		
		val = transcodeDate(val, format);
	}

	return val;	
}

function transcodeBoolean(/*String*/ val) {
	if(val==null)
		return '';
	val = val.toLowerCase();
	val = val.trim();
	if(val.length==0)
		return '';
		
	for(var i=0;i<truevalues.length;i++) {
		if(truevalues[i].equals(val))
			return '1';	
	}
	return '0';
}

var datecache = new java.util.HashMap();
function transcodeDate(/*String*/ val, /*String*/ dateFormat) {
	if(val == null || val.trim().length==0)
		return '';
	var /*java.text.SimpleDateFormat*/ parser = datecache.get(''+dateFormat); 
	if(parser == null) { // save the parser in cache
		parser = new java.text.SimpleDateFormat(dateFormat);
		datecache.put(''+dateFormat, parser);
	}
	try {
		// parse the date
		var /*java.util.Date*/ date = parser.parse(val);
		var year = date.getYear()+1900;
		var month = date.getMonth()+1;
		var day = date.getDate();
		var hour = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();
		
		year = ''+year;
		month = ('0'+month).right(2); 
		day = ('0'+day).right(2); 
		hour = ('0'+hour).right(2); 
		minutes = ('0'+minutes).right(2); 
		seconds = ('0'+seconds).right(2);
		
		// return it as a string in LDAP format
		var ret = year+month+day+hour+minutes+seconds;		
		return ret; 
	}
	catch(e) {
		throw new java.lang.RuntimeException( '[line '+linecounter+'] Cannot parse date ['+val+'] '+e);	
	}
	return '##ERROR##';
}

/**
 * compute process a computed column
 * 
 * @param expression the expression to compute
 * @param records a HashMap containing all the records needed for expression
 * @return the value
 */
var /*java.util.HashMap*/ computecache = new java.util.HashMap(); 
var /*java.text.SimpleDateFormat*/ ldapdateformat = null;

function compute(/*String*/ expression, /*java.util.HashMap*/ records, /*String*/ outputType) {
	var myCache = computecache; 
	var /*String*/ key = ''+expression;
	var cache = computecache.get(key);
	if(cache == null) {
		cache = new java.util.HashMap();
		computecache.put(key, cache);
	}
	var /*String*/ val = provisioning.executeMacro(expression, records, false, cache);
	var /*String*/ err = cache.get('error');
	if(err!=null) {
		throw new java.lang.RuntimeException( '[line '+linecounter+']. Cannot compute expression ['+expression+'] '+err.left(err.indexOf('\n'))); 	
	}
	
	return val;
}


function checkFormat(/*String*/ val, /*String*/ outputType) {
	// double-check output format as in case of a computed column
	// if it is an invalid value, we return an empty string instead
	if(val!=null) {
		if('Boolean'.equals(outputType)) {
			// must be either 0 or 1
			if(!val.equals('0') && !val.equals('1'))
				val = ''; 
		}
		else if('Number'.equals(outputType)) {
			// parse the value
			try {
				var v = val.match('^[0-9]+$');
				if(v==null || v.length==0)
					val = '';
			}catch(e) {
				val = '';
			}
		}
		else if('Date'.equals(outputType)) {
			if(ldapdateformat == null) {
				ldapdateformat = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
				ldapdateformat.setLenient(false);
			}
			
			try {
				var testdate = ldapdateformat.parse(val);
				if(testdate == null)
					val = '';
			}catch(e) {
				val = '';
			}
		}
	}
	
	return val;
}

// ///////////////////////////////////////////////////////////////////////////////////
// Utilities

/**
 * csvFile_Create create CSV file
 * 
 * @param filepath where to write the file 
 * @param headers as a String Array
 * @return handle used for other calls
 */
function csvFile_Create(filepath,/*Array*/ headers) {
	var /* java.io.Writer */ out = new java.io.BufferedWriter(new java.io.OutputStreamWriter(new java.io.FileOutputStream(filepath), "UTF-8"));	

	for(var i=0;i<headers.length;i++) {
		if(i>0)
			out.write(';');	
		out.write(headers[i]);	
	}
	out.write('\n');	

	var handle = {};
	handle.out = out;
	handle.headers = headers;
	
	return handle;
}

/**
 * csvFile_addLine add a new line in the CSV file
 * 
 * @param handle used to retrieve the context
 * @param line the line as a HashMap 
 */
function csvFile_addLine(handle, /*java.util.HashMap*/ line) {
	var /* java.io.Writer */ out = handle.out;
	var /*Array*/ headers = handle.headers;
	
	for(var i=0;i<headers.length;i++) {
		// pick line value
		var /*String*/ header = headers[i];
		var val = line.get(''+header);

		// process special situations
		if(val == null) val = '';
		var surroundbydoublequote = false;
		if(val.indexOf('"')!=-1) {
			val.replace('"', '""' , 'g');
			surroundbydoublequote = true;	
		}
		if(val.indexOf(';')!=-1)
			surroundbydoublequote = true;	
		if(val.indexOf('\n')!=-1)
			surroundbydoublequote = true;	
		if(surroundbydoublequote)	
			val = '""'+val+'""';

		// append value
		if(i>0)
			out.write(';');
		out.write(val);
	}
	// next line
	out.write('\n');
}

/**
 * csvFile_close close the file
 * 
 * @param handle used to retrieve the context
 */
function csvFile_close(handle) {
	if(handle == null)
		return;
	
	var /* java.io.Writer */ out = handle.out;
	if(out == null)
		return;
	
	out.close();
	handle.out = null;
}

/**
 * sha256 compute a SHA256 of a given file
 * 
 * @return SHA256 as a string
 */
function sha256(/*String*/ filepath ) {
	try {
		var checker = new com.brainwave.utils.CSVFormatChecker();
		var str = checker.getFileHash(filepath);
		return str;
	}catch(e) {
		return '';
	}
}


function copyFile( srcFile, destFile){
	var /*java.nio.file.Path*/ srcPath = java.nio.file.Paths.get(srcFile );
	var /*java.nio.file.Path*/ destPath = java.nio.file.Paths.get(destFile );
	try {
		java.nio.file.Files.copy(srcPath, destPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
		return null;
	} catch (/*java.io.IOException*/ e) {
		return "Error copying file to "+destFile+ " : " +e ; 
	}
}
