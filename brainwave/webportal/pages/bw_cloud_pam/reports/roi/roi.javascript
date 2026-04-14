function getDate() {
	var /*String*/ currentDateStr = dataset.get('currentdate').get();
	var /*java.text.SimpleDateFormat*/ sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmss"); 
	var /*Date*/ currentDate = sdf.parse(currentDateStr);
	var /*Number*/ nbDays = dataset.get('nbdays').get();

	currentDate = currentDate.add('d', -nbDays);

	return currentDate.toLDAPString();	
}

function getRemainingUserCount() {
	var /*Number*/ nbUsers = dataset.get('nbusers').get();
	var /*Number*/ maxUsers = dataset.get('maxusers').get();

	if (nbUsers >= maxUsers) {
		return 0;
	}
	return maxUsers - nbUsers;
}
