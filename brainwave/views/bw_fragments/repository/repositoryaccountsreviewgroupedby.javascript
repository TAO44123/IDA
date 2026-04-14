
function init() {
}

function read() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;
	
	if(dataset.groupedby.get().equals("repository")) {
		var parentid = '';
		parentid = record.repositorydisplayname.get();
		if(parentid == null)
			parentid = record.repositorycode.get();
		record.parentid = parentid;
	}
	else if(dataset.groupedby.get().equals("identity")) {
		var parentid = '';
		parentid = record.identityfullname.get();
		if(parentid == null)
			parentid = '-';
		record.parentid = parentid;
	}
	
	return record; 
}

var val = -1;
function computereviewrecorduid() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;
	
	if(record.reviewrecorduid.get()==null) {
		record.reviewrecorduid = val;
		val = val - 1;
	}

	if(record.id.get()==null) {
		record.id = '-';
	}
	
	return record; 
}
