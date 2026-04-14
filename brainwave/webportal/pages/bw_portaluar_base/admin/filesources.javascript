function datediff() {
	var /*java.text.SimpleDateFormat*/ format = new java.text.SimpleDateFormat("yyyyMMddHHmmss");	
	var /*Date*/ date1 = format.parse(dataset.date1.get());
	var /*Date*/ date2 = null;
	if(dataset.isEmpty('date2')) {
		date2 = new Date();
		date2.setTime(0);
	}
	else
		date2 = format.parse(dataset.date2.get());
	
	var diff = date1.getTime()-date2.getTime();
	diff = diff / (1000*3600*24);

	diff = Math.floor(diff)+1;	
	
	return diff;
}