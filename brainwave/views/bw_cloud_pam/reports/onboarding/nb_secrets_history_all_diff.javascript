
var secrets_count = null; 
var id = 0;

function init() {
	secrets_count = {};
}

function read() {
	id += 1;
	var record = businessview.getNextRecord();
	
	if (record == null ) { return null };
	
	if ( record.isEmpty('nb_secrets') ) {
		record.nb_secrets = Number(0).toFixed(0);
	} 
	
	secrets_count[ record.uid.get() ] = record.nb_secrets.get();
	
	if ( record.parent_uid.get() in secrets_count ) {
		record.diff_nb_secrets = record.nb_secrets.get() - secrets_count[record.parent_uid.get()] ;
	}
	else {
		record.diff_nb_secrets = 0
	}
	record.id = id;
	
	return record;
}
