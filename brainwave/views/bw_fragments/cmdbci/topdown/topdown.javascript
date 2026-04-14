
var buffer = new Array();
var dedup = new java.util.HashSet();
var rec = null;

function init() {
	record = null;
	
	while( (record = businessview.getNextRecord()) != null) {
		if(rec == null)
			rec = record;
		var stack = new Array();
		 
		stack.push(createCI(record.CI_uid.get(), record.CI_type.get(), record.CI_displayname.get(), record.CI_description.get(), ''));
		if(!record.isEmpty('CIT1_uid')) stack.push(createCI(record.CIT1_uid.get(), record.CIT1_type.get(), record.CIT1_displayname.get(), record.CIT1_description.get(), record.CIT1_semantic.get()));
		if(!record.isEmpty('CIT2_uid')) stack.push(createCI(record.CIT2_uid.get(), record.CIT2_type.get(), record.CIT2_displayname.get(), record.CIT2_description.get(), record.CIT2_semantic.get()));
		if(!record.isEmpty('CIT3_uid')) stack.push(createCI(record.CIT3_uid.get(), record.CIT3_type.get(), record.CIT3_displayname.get(), record.CIT3_description.get(), record.CIT3_semantic.get()));
		if(!record.isEmpty('CIT4_uid')) stack.push(createCI(record.CIT4_uid.get(), record.CIT4_type.get(), record.CIT4_displayname.get(), record.CIT4_description.get(), record.CIT4_semantic.get()));
		if(!record.isEmpty('CIT5_uid')) stack.push(createCI(record.CIT5_uid.get(), record.CIT5_type.get(), record.CIT5_displayname.get(), record.CIT5_description.get(), record.CIT5_semantic.get()));

		if(buffer.length==0) {
			buffer.push(createFirstEntry(stack[0]));	
		}

		while(stack.length>=2) {
			var pair = createEntry(stack[0], stack[1]);
			
			var key = pair.key;
			if(!dedup.contains(key)) {
				dedup.add(key);
				buffer.push(pair);	
			}
			
			stack.shift();
		}
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
