var columns = null;

function discover() {

	var filename = dataset.file.get();

	var encoding = dataset.encoding.get();
	var delimiter = dataset.delimiter.get();
	var separator = dataset.separator.get();
	var fielddelimiter = dataset.delimiter.get();
	var booleanformat = dataset.booleanformat.get();
	var dateformat = dataset.dateformat.get();
		
	// open the file for analysis
	var parser = workflow.getFileParser('CSV');
	parser.encoding = encoding;	
	parser.separator = separator;	
	parser.textseparator = fielddelimiter;	
	parser.open(filename);

	var headers = parser.readHeader();
	if(headers == null) {
		parser.close();
		return;	
	}
	
	// get the headers
	columns = new Array();
	for(var i=0;i<headers.length;i++) {
		var column = {};
		column.name = ''+headers[i];
		column.type = 'String';
		column.mandatory = true;
		column.unique = true;
		column.fillfactor = 0;

		column.canbemail = true;
		column.canbeboolean = true;
		column.canbenumeric = true;
		column.canbedate = true;
		column.notnullcounter = 0;
		column.valset = new java.util.HashSet();

		columns.push(column);
	}
	
	// prepare valid values for boolean
	var /*java.util.HashSet*/ validboolean = new java.util.HashSet();
	var t = booleanformat.split(';');
	for(var i=0;i<t.length;i++) {
		var tt = t[i].split(',');
		for(var j=0;j<tt.length;j++) {
			var /*String*/ v = tt[j].trim();
			v = v.toLowerCase();
			validboolean.add(''+v);			
		}	
	}

	// prepare date parser
	var /*java.text.SimpleDateFormat*/ dateparser = new java.text.SimpleDateFormat(dateformat);
	dateparser.setLenient(false);

	// prepare email parser
	var /*String*/ emailregex = "\\s*(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\\s*";
	var emailchecker = new RegExp(emailregex);
		
	// analyse file content
	var line = 0;
	var /*Number*/ nblines = 0;
	while ( (line=parser.readLine())!=null) {
		// check if this is not an empty line
		var empty = true;
		for(var i=0;i<line.length;i++) {
			if(line[i].trim().length>0) {
				empty = false;
				break;	
			}
		}
		// empty line? just skip it
		if(empty)
			continue;
		
		nblines++;	
		for(var i=0;i<columns.length;i++) {
			// get column/value
			var column = columns[i];
			var /*String*/ val = line[i];
			
			if(val == null || val.trim().length==0) {
				// no values
				column.mandatory = false;
				continue;
			}
			else {
				column.notnullcounter++;
			}
			
			val = '' + val;
//			val = val.replace("(^\\h*)|(\\h*$)","g"); // super clever way of trimming a string, including unbreakable spaces...
 
			// not a boolean value
			if(!validboolean.contains(val)){
				column.canbeboolean = false;
			}
			
			// not a numeric value
			if(!val.isNumeric()){
				column.canbenumeric = false;
			}
			
			// not an email
			if(!emailchecker.test(val)) {
				column.canbemail = false;
			}
			
			// not a date value
			try {
				var /*java.text.ParsePosition*/ parseposition = new java.text.ParsePosition(0);
				var date = dateparser.parse(val, parseposition);
				if(date==null)
					column.canbedate = false;
				else if(parseposition.getIndex()==0)
					column.canbedate = false;
			}
			catch(e) {
				column.canbedate = false;
			}
			
			// not a unique value
			if(column.valset.contains(val)) {
				column.unique = false;
			}
			else {
				column.valset.add(val);
			}
		}
	
	}
	
	parser.close();

	// guess column definition from CSV file content
	for(var i=0;i<columns.length;i++) {
		// get column/value
		var column = columns[i];
		
		if(column.notnullcounter==0) {
			column.type = 'String';
			column.unique = false;
		}
		else {
			if(column.canbemail) {
				column.type = 'Email';
				column.unique = false;
			} 
			else if(column.canbedate) {
				column.type = 'Date';
				column.unique = false;
			} 
			else if(column.canbeboolean) {
				column.type = 'Boolean'; 
				column.unique = false;
			} 
			else if(column.canbenumeric) {
				column.type = 'Number'; 
				column.unique = false;
			}
			// String
			else if(!column.mandatory && nblines>0) {
				var fillfactor = 0;
				fillfactor = 100*column.notnullcounter/nblines;
				fillfactor = fillfactor>=20?fillfactor-20:0;
				column.fillfactor = Math.floor(fillfactor);
			} 
		}

		// clean up memory
		column.valset.clear();
		column.valset = null;
	}
}

function execute() {
	discover();


	// prepare workflow variables to update columns metadata
	dataset.columnorder.clear();
	dataset.columnname.clear();
	dataset.columntype.clear();
	dataset.columnformat.clear();
	dataset.columnformatdescription.clear();
	dataset.columnmandatory.clear();
	dataset.columnisunique.clear();
	dataset.columnfillfactor.clear();
	dataset.columncomputedexpression.clear();
	dataset.columniscomputed.clear();
	dataset.columnsubkey.clear();

	// no columns found? abort!
	if(columns==null)
		return;
	
	for(var i=0;i<columns.length;i++) {
		var column = columns[i];
		
		dataset.columnorder.add(i+1);
		dataset.columnname.add(column.name);
		dataset.columntype.add(column.type);
		dataset.columnformat.add('');
		dataset.columnformatdescription.add('');
		dataset.columnmandatory.add(column.mandatory);
		dataset.columnisunique.add(column.unique?"Yes":"No");
		dataset.columnfillfactor.add(column.fillfactor);
		dataset.columniscomputed.add(0);
		dataset.columncomputedexpression.add('');
		dataset.columnsubkey.add(dataset.code.get()+'$$'+column.name);
		dataset.columnparentmetadata.add(dataset.parentmetadatauid.get());
	}
	
	// prepare workflow variables to update mappings
	dataset.mappingsubkey.clear();
	dataset.mappingparentmetadatauid.clear();
	dataset.mappingmapped.clear();
	for(var i=0;i<dataset.mappingname.length;i++) {
		var name = ''+dataset.mappingname.get(i);
		var type = ''+dataset.mappingtype.get(i);
		// dynamic mapping if mapping name = column name
		var notfound = true;
		for(var j=0;j<columns.length;j++) {
			var column = columns[j];
			var columnname= ''+column.name;
			var columntype= ''+column.type;
			
			if(columntype.equalsIgnoreCase('EMail')) // EMail is considered as a String in the mappings
				columntype = 'String';

			// perfect mapping = same name AND same type			
			if(name.equalsIgnoreCase(columnname)) {
				if(type.equalsIgnoreCase(columntype)) {
					dataset.mappingmapped.add(columnname);
					notfound = false;
					break;
				}
			}
		}
		if(notfound)
			dataset.mappingmapped.add(null);
		
		// add missing technical columns
		dataset.mappingparentmetadatauid.add(dataset.parentmetadatauid.get());
		dataset.mappingsubkey.add(dataset.code.get()+'$$'+name);
	}	
}
