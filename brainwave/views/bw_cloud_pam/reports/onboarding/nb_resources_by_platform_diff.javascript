
allplatforms = null;
allplatformsts = null;
resourcescurrentts = null;
resourcesparentts = null;

function init() {
	allplatforms = [];
	allplatformsts = {};
	resourcescurrentts = {};
	resourcesparentts = {};
}

function read() {
	
	var record = businessview.getNextRecord();
	
	if ( record == null ) {
		var current = allplatforms.pop();
		if ( current == null ) { return null; }
		var currentds = new DataSet();
		currentds.platform = current;
		currentds.nb_resources = resourcescurrentts[ current ];
		if ( current in resourcesparentts ) {
			currentds.nb_resources_parent = resourcesparentts[ current ];
		}
		else {
			currentds.nb_resources_parent = 0;
		}
		currentds.diff = currentds.nb_resources - currentds.nb_resources_parent;
		return currentds;
	}
	
	if (!(record.platform.get() in  allplatformsts )) {
		allplatforms.push ( record.platform.get() ) ;
		allplatformsts[record.platform.get()] = record.timeslotuid;
	}
	
	if ( dataset.ts.get() == record.timeslotuid.get() ) {
		resourcescurrentts [record.platform.get()] = record.nb_resources.get()
	}
	
	if ( dataset.parent_ts.get() == record.timeslotuid.get() ) {
		resourcesparentts [record.platform.get()] = record.nb_resources.get()
	}
	
	return new DataSet();
	
}
