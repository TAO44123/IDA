


var current_ds = {}

var recent_controller_ids = {}

function fillCurrentDS () {
	current_ds = new Object();
	var results = workflow.executeView(null, 'bwdsm_exportmetadata');
	dataset.md_to_delete.clear();
	for ( var i=0 ; i < results.length ; i++ ) {
		if (results[i].get('key') == 'bw_datasource_def' ) {
			current_ds [ results[i].get('subkey')  ] = results[i].get('uid');
		}
		if (results[i].get('parent_key') == 'bw_datasource_def' ) {
			dataset.md_to_delete.add( results[i].get('uid') );
		}
	}
}

function fillControllerIDs() {
	recent_controller_ids = new Object();
	var results = workflow.executeView(null, 'bwdsm_exportcontroller');
	for ( var i=0 ; i < results.length ; i++ ) {
		recent_controller_ids[results[i].get('name')] = results[i].get('id');
	}
}

function addToDataset ( prefix, line ) {
	dataset.get(prefix + 'key').add(line[0]);
	dataset.get(prefix + 'subkey').add(line[1]);
	dataset.get(prefix + 'parent_subkey').add(line[2]);
	dataset.get(prefix + 'parent_key').add(line[3]);
	dataset.get(prefix + 'value1string').add(line[4]);
	dataset.get(prefix + 'value2string').add(line[5]);
	dataset.get(prefix + 'value3string').add(line[6]);
	dataset.get(prefix + 'value4string').add(line[7]);
	dataset.get(prefix + 'value5string').add(line[8]);
	dataset.get(prefix + 'value6string').add(line[9]);
	dataset.get(prefix + 'value7string').add(line[10]);
	dataset.get(prefix + 'value8string').add(line[11]);
	dataset.get(prefix + 'value9string').add(line[12]);
	dataset.get(prefix + 'value10string').add(line[13]);
	dataset.get(prefix + 'value11string').add(line[14]);
	dataset.get(prefix + 'value12string').add(line[15]);
	dataset.get(prefix + 'value1integer').add(line[16]);
	dataset.get(prefix + 'value2integer').add(line[17]);
	dataset.get(prefix + 'value3integer').add(line[18]);
	dataset.get(prefix + 'value4integer').add(line[19]);
	dataset.get(prefix + 'value5integer').add(line[20]);
	dataset.get(prefix + 'value6integer').add(line[21]);
	dataset.get(prefix + 'value7integer').add(line[22]);
	dataset.get(prefix + 'value8integer').add(line[23]);
	dataset.get(prefix + 'value9integer').add(line[24]);
	dataset.get(prefix + 'value10integer').add(line[25]);
	dataset.get(prefix + 'value11integer').add(line[26]);
	dataset.get(prefix + 'value12integer').add(line[27]);
	dataset.get(prefix + 'valueboolean').add(line[28]);
	dataset.get(prefix + 'description').add(line[29]);
	dataset.get(prefix + 'details').add(line[30]);
	dataset.get(prefix + 'uid').add(current_ds[line[1]]);
	dataset.get(prefix + 'parent_uid').add(current_ds[line[2]]);
}

function clearDataset ( prefix ) {
	
	dataset.get(prefix + 'key').clear();
	dataset.get(prefix + 'subkey').clear();
	dataset.get(prefix + 'parent_subkey').clear();
	dataset.get(prefix + 'parent_key').clear();
	dataset.get(prefix + 'value1string').clear();
	dataset.get(prefix + 'value2string').clear();
	dataset.get(prefix + 'value3string').clear();
	dataset.get(prefix + 'value4string').clear();
	dataset.get(prefix + 'value5string').clear();
	dataset.get(prefix + 'value6string').clear();
	dataset.get(prefix + 'value7string').clear();
	dataset.get(prefix + 'value8string').clear();
	dataset.get(prefix + 'value9string').clear();
	dataset.get(prefix + 'value10string').clear();
	dataset.get(prefix + 'value11string').clear();
	dataset.get(prefix + 'value12string').clear();
	dataset.get(prefix + 'value1integer').clear();
	dataset.get(prefix + 'value2integer').clear();
	dataset.get(prefix + 'value3integer').clear();
	dataset.get(prefix + 'value4integer').clear();
	dataset.get(prefix + 'value5integer').clear();
	dataset.get(prefix + 'value6integer').clear();
	dataset.get(prefix + 'value7integer').clear();
	dataset.get(prefix + 'value8integer').clear();
	dataset.get(prefix + 'value9integer').clear();
	dataset.get(prefix + 'value10integer').clear();
	dataset.get(prefix + 'value11integer').clear();
	dataset.get(prefix + 'value12integer').clear();
	dataset.get(prefix + 'valueboolean').clear();
	dataset.get(prefix + 'description').clear();
	dataset.get(prefix + 'details').clear();
	dataset.get(prefix + 'uid').clear();
	dataset.get(prefix + 'parent_uid').clear();

}

function initWorkflow(){
	dataset.get('created_ds_uid').clear();
}

function loadImportFile () {
	
	fillCurrentDS();
	
	if ( dataset.isEmpty("created_ds_uid") == false ) {
		for ( i = 0; i < dataset.created_ds_uid.length; i++ ) {
			current_ds [ dataset.new_ds_subkey.get(i)  ] = dataset.created_ds_uid.get(i);
		}
	}
	
	fillControllerIDs();
	
	var filePath = dataset.in_importFile.get();
	
	var parser = workflow.getFileParser('XLSX');
	

	parser.skiplines = 1;
	parser.sheetname = "DATA";
    parser.open(filePath);
    parser.readLine(); // skip header
    
    var line,key,subkey,prefix;
    
    clearDataset('file_ds_');
    clearDataset('new_ds_');
    clearDataset('file_ds_col_');
    clearDataset('file_ds_fmt_');
    clearDataset('file_ds_map_');
    
    while ( (line = parser.readLine()) != null){
    	key = line[0];
    	subkey = line [1];
    	prefix = null;
    	
    	if (key == 'bw_datasource_def') {
    		prefix = 'file_ds_';
    		if ( line[1] in recent_controller_ids) {
    			line[16] = recent_controller_ids[line[1]];
    		}
    		if (!(subkey in current_ds) ){
    			addToDataset('new_ds_',line);
    		}
    	}
    	
    	if ( key == 'bw_datasourcecolumn') {
    		prefix = 'file_ds_col_';
    	}
    	
    	if ( key == 'bw_datasourceformat') {
    		prefix = 'file_ds_fmt_';
    	}
    	
    	if ( key == 'bw_datasourcemapping') {
    		prefix = 'file_ds_map_';
    	}
    	
    	if ( prefix != null ) {
    		addToDataset (prefix, line);
    	}
    }
    
    parser.close();
	
}