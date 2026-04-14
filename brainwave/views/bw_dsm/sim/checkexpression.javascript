function init() {
}
function prepare() {
	var code = dataset.code.get();
	var expression = dataset.expression.get();

	// get all column names
	var records = new java.util.HashMap();
	var params = new java.util.HashMap();
	var cache = new java.util.HashMap();
	
	params.put('code', code);
	var results = businessview.executeView(businessview.timeslotuid, 'bw_getdatasourceallcolumns' , params);
	if(results!=null) {
		for(var i=0;i<results.length;i++) {
			var record = results[i];
			var columnname = record.get('bw_datasourcecolumn_name'); 			
			records.put(''+columnname, 'DUMMYDUMMYDUMMYDUMMYDUMMYDUMMY');	
		}
	}
	
	var result = null;
	var error = ''
	try {
		var result = businessview.executeMacro(expression, records, false, cache);
		if(result==null)
			error = cache.get('error');
	}
	catch(e) {
		error = e.toString();
	}
	
	record = new DataSet();
	var /*Attribute<String>*/ attribute = record.add("message", "String", false);
    attribute.set(error);

	error = error.substring(0 , error.indexOf('\n'));
	attribute = record.add("error", "String", false);
    attribute.set(error);
    
    return record;
}

var sent = false;
function read() {
	if(sent)
		return null;
	sent = true;

	var /*DataSet*/ record = prepare();
		
	return record;
}

function dispose() {
}