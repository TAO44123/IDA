var done = false;

function init() {
}

function read() {
	if(!done) {
		done = true;
		
		var timeslotuid = businessview.timeslotuid;
		if(timeslotuid==null)
			return null;
			
		var params = new java.util.HashMap();
		params.put("uid", timeslotuid);
		var v = businessview.executeView(null , "br_base_gettimeslot", params);
		if(v.length==1) {
			var /*String*/ name = v[0].get("displayname");	
			if(name.equals('Setup')) {
				return null;
			}
		}
		
		var /*DataSet*/ record = new DataSet();
		record.add('timeslotuid', 'String', false);
		record.timeslotuid.set(timeslotuid); 
		
		return record;
	}
	else {
		return null;
	}
}

function dispose() {
}
