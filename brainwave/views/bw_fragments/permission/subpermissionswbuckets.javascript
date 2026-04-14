
var /*java.util.HashSet*/ list1 = new java.util.HashSet();
var /*java.util.HashSet*/ list2 = new java.util.HashSet();

function init() {
	var i;
	var uid;
	
	if(!dataset.isEmpty('list1uid')) {
		for(i=0;i<dataset.list1uid.length;i++) {
			uid = ''+dataset.list1uid.get(i);
			list1.add(uid);
		}
	}

	if(!dataset.isEmpty('list2uid')) {
		for(i=0;i<dataset.list2uid.length;i++) {
			uid = ''+dataset.list2uid.get(i);
			list2.add(uid);
		}
	}
}

function read() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

	var /*Attribute<Number>*/ isinlist = record.add("isinlist", "Number", false);
    isinlist.set(0, 0);
        		
	var uid = ''+record.uid.get();
	if(list1.contains(uid)) {
	    isinlist.set(0, 1);
	}
	else if(list2.contains(uid)) {
	    isinlist.set(0, 2);
	}
	
	return record;
}
