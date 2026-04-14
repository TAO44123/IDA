

datefrom = null;
dateto = null

function init() {
}

function read() {
	var record = businessview.getNextRecord();
	
	if ( record == null ) {
		if ( datefrom == null ) { return null; }
		var current = new DataSet();
		current.from = datefrom;
		current.to = dateto;
		datefrom = null;
		dateto = null;
		return current;
	}
	
	if ( datefrom == null ) {
		datefrom = record.date.get();
	}
	else {
		if ( dateto == null ) {
			dateto = record.date.get();
		}
	}
	
	return record;
}
