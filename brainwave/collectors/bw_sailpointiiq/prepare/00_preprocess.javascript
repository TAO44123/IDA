import '../utils.javascript'
/* CSV file related vars */
var /*Array*/ header = null;
var /*String*/ siloFile = config.siloIteratedFileFullname;
var /*Boolean*/ mapperHere = false;
var /*String*/ fileName = siloFile.substring(0, siloFile.lastIndexOf("/")) + "/accounts_flat_attributes.csv";
var FileWriter = java.io.FileWriter;
var BufferedWriter = java.io.BufferedWriter;
var fw = new FileWriter(fileName);
var bw = new BufferedWriter(fw);
var /*Array*/ uniqueValues = [];
/* mapper file related vars */
var mapper = new java.util.HashMap();

// Check if a file exists
function fileExists( /*String*/ filePath ) {
	print( 'Calling: fileExists( ' + filePath + ')' );
	try {
		var /*java.io.File*/ theFile = new java.io.File( filePath );
		if ( theFile.canRead() ) {
			print( 'File does exist:' + filePath );
			return true;
		}
	} catch ( e ) {
		print( 'Error while opening file:' + filePath );
	}
	print( 'File does not exist:' + filePath );
	return false;
}

// read and load the mapping file in a Java HashMap
function read_mapper(){
	print( 'reading and loading mapper in memory' );
	mapperHere = fileExists(config.bw_sailpointiiq_mapper+"/bw_sailpointiiq_mapper/iiq_mapping.csv");
	if(mapperHere){
		// create a CSV parser
		var /*FileParser*/ csvParser = null;
    	csvParser = provisioning.getFileParser("CSV");
    	csvParser.separator = ',';
    	csvParser.textseparator = '"';
    	csvParser.encoding = 'UTF-8';
    	csvParser.open(config.bw_sailpointiiq_mapper+"/bw_sailpointiiq_mapper/iiq_mapping.csv");
    	// read header
   		header = csvParser.readHeader();
   		var /*Array*/ line = csvParser.readLine();
   		if(line == null){
   			// no line besides header ?
   			print( 'Mapper file is empty' );
   		}
   		while(line != null){
   			mapper.put(line[0]+"<$$>"+line[2], line[3]);
   			print('value: ' + line[3]+'  key'+ line[0]+'<$$>'+line[2]);
   			line = csvParser.readLine();
   		}
   		print( 'mapper loaded in memory' )
   		// Extract unique values for the header
		var /*HashMap*/ seen = {};
		var /* Array */ keys = mapper.keySet();
		for each (var key in keys.toArray()) {
		    var value = mapper.get(key.toString());
		    if (!seen[value] && value) {
		    	print('Value ' + value + ' added to header');
		        uniqueValues.push(value.toString());
		        seen[value] = true;
		    }
		}
		uniqueValues.sort();
		bw.write("account_id," + "app_id," + uniqueValues.join(","));
		bw.newLine();
		csvParser.close();
		print('Flat file written to ' + fileName);
	}
}

function iiq_to_brainwave(){
	var /* String */ appschema = dataset.appschema;
	var /* String */ account_id = dataset.id;
	var /* String */ app_id = dataset._app_id;
	
	var /* boolean */ written = false;
	if(appschema.toString()){
		var /* Array */ csvLine = new Array(uniqueValues.length + 2);
		print( 'parsing:'+appschema );
		appschema = parseSchema(String(appschema.toString()));
		var /* Array */ keys = mapper.keySet();
		csvLine[0] = '"' + account_id + '"';
		csvLine[1] = '"' + app_id + '"';
		for each (var key in keys.toArray()) {
		    if (appschema[key.toString().split("<$$>")[1]] !== undefined && app_id == key.toString().split("<$$>")[0]) {
		        var headerValue = mapper[key].toString().trim();
		        var headerPos = uniqueValues.indexOf(headerValue);
		        var mapped_attr = appschema[key.toString().split("<$$>")[1]];
		        if (Object.prototype.toString.call(mapped_attr) === '[object Array]') {
		        	csvLine[headerPos + 2] = '"' + flatten(mapped_attr) + '"';
		        } else {
		        	csvLine[headerPos + 2] = '"' + mapped_attr + '"';
		        }
		        print('writing: ' + appschema[key.toString().split("<$$>")[1]]);
		        written = true;
		    }
		}
		if(written){
			bw.write(csvLine.join(","));
			bw.newLine();
			bw.flush();
		}
	} else{
		print( 'no "appschema", skipping line' );
	}	
}

function dispose(){
	try {
		fw.close();
	} catch (e) {
	    print("file stream was already closed: " + e);
	}
	try {
		bw.close();
	} catch (e) {
	    print("buffer stream was already closed: " + e);
	}
	print('Flat file written to ' + fileName);
	print('mapper was present ' + mapperHere);
	print('looked here: ' + config.bw_sailpointidnow_mapper+"/bw_sailpointidnow_mapper/idnow_mapping.csv")
}