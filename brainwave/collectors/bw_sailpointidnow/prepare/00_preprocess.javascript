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

// Parses SailPoint's format and puts the key-values in a native JS object
function parseAttributes(str) {
    var i = 0, len = str.length, obj = {};
    str = str.trim();
    if (str.charAt(0) === '{' && str.charAt(str.length - 1) === '}') {
        str = str.substring(1, str.length - 1);
    }
    while (i < str.length) {
        while (i < len && (str.charAt(i) === ',' || /\s/.test(str.charAt(i)))) i++;
        var key = "";
        if (str.charAt(i) === "'") {
            i++;
            while (i < len && str.charAt(i) !== "'") {
                key += str.charAt(i++);
            }
            i++;
        } else if (str.charAt(i) === '"') {
            i++;
            while (i < len && str.charAt(i) !== '"') {
                key += str.charAt(i++);
            }
            i++;
        }
        while (i < len && /\s/.test(str.charAt(i))) i++;
        if (str.charAt(i) === ':') i++;
        while (i < len && /\s/.test(str.charAt(i))) i++;
        var value, vStart = i;
        if (/^(None|False|True|null|true|false)/.test(str.substring(i))) {
            if (/^None/.test(str.substring(i)))      { value = "null";    i += 4; }
            else if (/^null/.test(str.substring(i))) { value = "null";    i += 4; }
            else if (/^False/.test(str.substring(i))){ value = "false";   i += 5; }
            else if (/^false/.test(str.substring(i))){ value = "false";   i += 5; }
            else if (/^True/.test(str.substring(i))) { value = "true";    i += 4; }
            else if (/^true/.test(str.substring(i))) { value = "true";    i += 4; }
        }
        else if (str.charAt(i) === '"' && str.charAt(i + 1) === '"') {
            i += 2;
            var val = "";
            while (i < len && !(str.charAt(i) === '"' && str.charAt(i+1) === '"')) {
                val += str.charAt(i++);
            }
            i += 2;
            value = val;
        }
        else if (str.charAt(i) === "'") {
            i++;
            var val = "";
            while (i < len && str.charAt(i) !== "'") {
                val += str.charAt(i++);
            }
            i++;
            value = val;
        }
        else {
            var val = "";
            while (i < len && !/[,}]/.test(str.charAt(i))) {
                val += str.charAt(i++);
            }
            value = val.trim();
        }
        if (value === "null") obj[key] = null;
        else if (value === "true") obj[key] = "true";
        else if (value === "false") obj[key] = "false";
        else if (value.charAt(0) == '"' && value.charAt(value.length - 1) == '"') obj[key] = value.substring(1, value.length -1);
        else obj[key] = value;
        while (i < len && (/\s/.test(str.charAt(i)) || str.charAt(i) === ',')) i++;
    }
    return obj;
}

// read and load the mapping file in a Java HashMap
function read_mapper(){
	print( 'reading and loading mapper in memory' );
	mapperHere = fileExists(config.bw_sailpointidnow_mapper+"/bw_sailpointidnow_mapper/idnow_mapping.csv");
	if(mapperHere){
		// create a CSV parser
		var /*FileParser*/ csvParser = null;
    	csvParser = provisioning.getFileParser("CSV");
    	csvParser.separator = ',';
    	csvParser.textseparator = '"';
    	csvParser.encoding = 'UTF-8';
    	csvParser.open(config.bw_sailpointidnow_mapper+"/bw_sailpointidnow_mapper/idnow_mapping.csv");
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
		bw.write("account_id," + "source_id," + uniqueValues.join(","));
		bw.newLine();
		csvParser.close();
		print('Flat file written to ' + fileName);
	}
}

function idnow_to_brainwave(){
	var /* String */ attributes = dataset.attributes;
	var /* String */ account_id = dataset.id;
	var /* String */ source_id = dataset.sourceid;
	
	var /* boolean */ written = false;
	if(attributes.toString()){
		var /* Array */ csvLine = new Array(uniqueValues.length + 2);
		print( 'parsing:'+attributes );
		attributes = parseAttributes(String(attributes.toString()));
		var /* Array */ keys = mapper.keySet();
		csvLine[0] = '"' + account_id + '"';
		csvLine[1] = '"' + source_id + '"';
		for each (var key in keys.toArray()) {
		    if (attributes[key.toString().split("<$$>")[1]] !== undefined && source_id == key.toString().split("<$$>")[0]) {
		        var headerValue = mapper[key].toString().trim();
		        var headerPos = uniqueValues.indexOf(headerValue);
		        csvLine[headerPos + 2] = '"' + attributes[key.toString().split("<$$>")[1]] + '"';
		        print('writing: ' + attributes[key.toString().split("<$$>")[1]]);
		        written = true;
		    }
		}
		if(written){
			bw.write(csvLine.join(","));
			bw.newLine();
			bw.flush();
		}
	} else{
		print( 'no "attributes", skipping line' );
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