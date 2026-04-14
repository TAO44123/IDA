
var all_datasets = [];

function read() {
	return all_datasets.pop();
}

function init() {
	var parser = businessview.getFileParser('XLSX');

	parser.skiplines = 1;
	parser.sheetname = "DATA";
    parser.open(dataset.filepath.get());
    parser.readLine(); // skip header
    
    var line, ds;
    
    while ( (line = parser.readLine()) != null){
    	ds = new DataSet();
    	ds.key = line[0];
    	ds.subkey = line[1];
    	ds.parent_subkey = line[2];
    	ds.parent_key = line[3];
    	ds.value1string = line[4];
    	ds.value2string = line[5];
    	ds.value3string = line[6];
    	ds.value4string = line[7];
    	ds.value5string = line[8];
    	ds.value6string = line[9];
    	ds.value7string = line[10];
    	ds.value8string = line[11];
    	ds.value9string = line[12];
    	ds.value10string = line[13];
    	ds.value11string = line[14];
    	ds.value12string = line[15];
    	ds.value1integer = Number(line[16]).toFixed(0);
    	ds.value2integer = line[17];
    	ds.value3integer = line[18];
    	ds.value4integer = line[19];
    	ds.value5integer = line[20];
    	ds.value6integer = line[21];
    	ds.value7integer = line[22];
    	ds.value8integer = line[23];
    	ds.value9integer = line[24];
    	ds.value10integer = line[25];
    	ds.value11integer = line[26];
    	ds.value12integer = line[27];
    	ds.valueboolean = line[28];
    	ds.description = line[29];
    	ds.details = line[30];
    	ds.ctl_name = line[31];
    	ds.ctl_scheduling = line[32];
    	ds.ctl_id = Number(line[33]).toFixed(0);
    	ds.ctl_category = line[34];
    	ds.ctl_type = line[35];
    	ds.ctl_enabled = line[36];
    	ds.ctl_description = line[37];
    	
    	
    	all_datasets.push(ds);
    }
    
    parser.close();
    	
}
