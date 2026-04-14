
var resources_count = null; 
var id = 0;

function init() {
	resources_count = {};
}

function read() {
	id += 1;
	var record = businessview.getNextRecord();
	
	if (record == null ) { return null };
	
	if ( record.isEmpty('nb_resources') ) {
		record.nb_resources = Number(0).toFixed(0);
	} 
	
	resources_count[ record.uid.get() ] = record.nb_resources.get();
	
	if ( record.parent_uid.get() in resources_count ) {
		record.diff_nb_resources = record.nb_resources.get() - resources_count[record.parent_uid.get()] ;
	}
	else {
		record.diff_nb_resources = 0
	}
	record.id = id;
	
	return record;
}
