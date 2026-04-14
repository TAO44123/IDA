
function read() {
	var result = null;
	var rec = null;
	while((record = businessview.getNextRecord())!=null) {
		if(rec == null)
			rec = record;
			
		var val = record.tag.get();
		if(result == null)
			result = val;
		else
			result = result + ', ' + val;
	}
	
	if(rec!=null) {
		rec.tag.set(result);
	}
		
	return rec;
}
