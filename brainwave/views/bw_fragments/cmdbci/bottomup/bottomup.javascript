
var buffer = new Array();
var dedup = new java.util.HashSet();
var rec = null;

function init() {
	record = null;
	
	while( (record = businessview.getNextRecord()) != null) {
		if(rec == null)
			rec = record;
		 
		var ci1 = createCI(record.CI_uid.get(), record.CI_type.get(), record.CI_displayname.get(), record.CI_description.get(), '');
		var ci2 = createCI(record.CIT1_uid.get(), record.CIT1_type.get(), record.CIT1_displayname.get(), record.CIT1_description.get(), record.CIT1_semantic.get());

		buffer.push(createFirstEntry(ci1));	
		buffer.push(createEntry(ci1, ci2));
	}
	
	var debug = 0;
	debug = 1;
}

function createCI(uid, type, displayname, description, semantic) {
	var obj = {};
	obj.uid = uid;
	obj.type = type;
	obj.displayname = displayname;
	obj.description = description;
	obj.semantic = semantic;
	return obj;	
}

function createFirstEntry(obj) {
	
	var pair = {};
	pair.key = obj.uid;
	pair.uid = obj.uid; 
	pair.type = obj.type; 
	pair.displayname = obj.displayname; 
	pair.description = obj.description;
	pair.semantic = ''; 
	pair.parent = ''; 

	return pair;
}

function createEntry(from, to) {
	
	var pair = {};
	pair.key = from.uid + '$' + to.uid;
	pair.semantic = to.semantic; 
	pair.parent = from.uid; 
	pair.uid = to.uid; 
	pair.type = to.type; 
	pair.displayname = to.displayname; 
	pair.description = to.description;

	return pair;
}

var index = 0;
function read() {
	if(index>=buffer.length)
		return null;
	
	var entry = buffer[index];
	index = index + 1;
	
	rec.CI_uid.set(entry.uid);
	rec.CI_displayname.set(entry.displayname);
	rec.CI_type.set(entry.type);
	rec.CI_description.set(entry.description);
	rec.CI_parent.set(entry.parent);
	rec.CI_semantic.set(entry.semantic);

	return rec;
}
