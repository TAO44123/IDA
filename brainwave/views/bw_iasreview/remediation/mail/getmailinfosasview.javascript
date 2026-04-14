
function init() {
}

var done = false;
function read() {
	if(!done) {
		done = true;	
		var /*DataSet*/ record = new DataSet();
        var /*String*/ name = dataset.name.get();
        var /*String*/ mail = dataset.mail.get();
        if(name==null || mail == null)
        	return null;
        var /*Attribute<String>*/ attribute = record.add("name", "String", false);
        attribute.set(name);
        attribute = record.add("mail", "String", false);
        attribute.set(mail);
        attribute = record.add("uid", "String", false);
        attribute.set('##1');

	    return record;
	}
	else {
		return null;	
	}
}

function dispose() {
}
