
function computeSubkey() {
	var /*String*/ applicationcode = dataset.code.get();
	
	for(var i=0;i<dataset.name.length;i++) {
		var /*String*/ name = dataset.name.get(i);
		var /*String*/ subkey = applicationcode+'$$'+name;
		dataset.SUBKEY.set(i, subkey);	
	}
}
