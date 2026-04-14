/*
	filename = Input { mandatory: True}
	campaignId = Input { type: String mandatory: True }
	reviewstatus = Output{ type:String multivalued:True }
	reviewcomment = Output{ type:String multivalued:True }
	reviewrecorduid = Output{ type:String multivalued:True }
	invalidReview = Output { type: Boolean }
*/

function parseFile() {
	var /*String*/ columns = ['reviewstatus','reviewcomment','reviewrecorduid'] ;
		
	var /*String*/ filename = dataset.filename.get();
	var /*Number*/ campaignId = dataset.campaignId.get(); 
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
			   if (column=="reviewrecorduid"){
			   	  var reviewid = val.split("-")[0];
			   	  if (reviewid != campaignId){
			   	  	dataset.invalidReview.set(true);
			   	  }
			   }	
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