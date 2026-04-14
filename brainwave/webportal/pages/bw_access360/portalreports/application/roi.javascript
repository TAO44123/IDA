function getDate() {
	var /*String*/ currentDateStr = dataset.get("currentdate");
	
	var /*SimpleDateFormat*/ sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmss"); 
	var /*Date*/ currentDate = sdf.parse(currentDateStr);

	var /*Number*/ nbdays = dataset.get('nbdays');

	currentDate = currentDate.add('d', -nbdays);

	return currentDate.toLDAPString();	
}