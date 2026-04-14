function computeDate() {
	var /*Integer*/ nbdays = dataset.nbdays.get();
	
	var /*Date*/ date = new Date();
	date = date.add('d', -nbdays);
	var /*String*/ ldapdate = date.toLDAPString();
	
	return ldapdate;
}