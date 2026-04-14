/*
	filename = Input { mandatory: True }
	matrixcode = Output{ type:String multivalued:True }
	permission1 = Output{ type:String multivalued:True }
	application1 = Output{ type:String multivalued:True }
	permission2 = Output{ type:String multivalued:True }
	application2 = Output{ type:String multivalued:True }
	matrixenabled = Output { type:Boolean multivalued:True }
	risklevels = Output{ type:Integer multivalued:True }
*/

function parseFile() {
	var /*String*/ columns = [
		'matrixcode', 
		'permission1', 
		'permission1_displayname', 
		'application1', 
		'application1displayname', 
		'permission2', 
		'permission2_displayname', 
		'application2', 
		'application2displayname', 
		'matrixenabled', 
		'risklevels'];
		
	var /*String*/ filename = dataset.filename.get();
	var parser = connector.getFileParser('XLSX');
	parser.open(filename);
	
	var headers = parser.readHeader();
	var line = null;
	while((line=parser.readLine())!=null) {
		for(var i=0;i<columns.length;i++) {
			var /*String*/ column = columns[i];	
			var /*String*/ val = pickValue(headers, line, column);
			var /*Attribute*/ attr = dataset.get(column);
			if(attr!=null){
			   attr.add(val);	
			}
		}
	}
	parser.close();
}

function pickValue(headers, line, /*String*/ columnname) {
	for(var i=0;i<headers.length;i++) {
		var /*String*/ header = headers[i];
		if(columnname.equalsIgnoreCase(header)) {
			return line[i];
		}
	}
	return '';
}