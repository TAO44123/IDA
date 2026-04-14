
allplatforms = null;
allplatformsts = null;
secretscurrentts = null;
secretsparentts = null;

function init() {
	allplatforms = [];
	allplatformsts = {};
	secretscurrentts = {};
	secretsparentts = {};
}

function read() {
	
	var record = businessview.getNextRecord();
	
	if ( record == null ) {
		var current = allplatforms.pop();
		if ( current == null ) { return null; }
		var currentds = new DataSet();
		currentds.platform = current;
		currentds.nb_secrets = secretscurrentts[ current ];
		if ( current in secretsparentts ) {
			currentds.nb_secrets_parent = secretsparentts[ current ];
		}
		else {
			currentds.nb_secrets_parent = 0;
		}
		currentds.diff = currentds.nb_secrets - currentds.nb_secrets_parent;
		return currentds;
	}
	
	if (!(record.platform.get() in  allplatformsts )) {
		allplatforms.push ( record.platform.get() ) ;
		allplatformsts[record.platform.get()] = record.timeslotuid;
	}
	
	if ( dataset.ts.get() == record.timeslotuid.get() ) {
		secretscurrentts [record.platform.get()] = record.nb_secrets.get()
	}
	
	if ( dataset.parent_ts.get() == record.timeslotuid.get() ) {
		secretsparentts [record.platform.get()] = record.nb_secrets.get()
	}
	
	return new DataSet();
	
}
