
function calculateDelay() {
	dataset.delayInMinutes.set(0,0);	
	
	// If a timestamp is received
	if ( dataset.isEmpty( "execute_timestamp") ){
		return;
	}
	
	print ("Calculating Delay in Minutes");
	var ldapTstamp = dataset.execute_timestamp.get();
	var userldlapTstamp = dataset.user_timestamp.get();
	
	// Parse target timestamp
	print ("Received user timestamp is " + userldlapTstamp );
	print ("Received execution timestamp is " + ldapTstamp );
	var target = new Date ( 0 );
	
	// Parse date an time
	target.setFullYear( Number(ldapTstamp.substr(0,4)) , Number(ldapTstamp.substr(4,2))-1, Number(ldapTstamp.substr(6,2)) );
	target.setHours( Number(ldapTstamp.substr(8,2)), Number(ldapTstamp.substr(10,2)), Number(ldapTstamp.substr(12,2)), 0 );
	
	// Parse the timezone offset
	var zi = userldlapTstamp.indexOf('-')>=0?userldlapTstamp.indexOf('-'):userldlapTstamp.indexOf('+');
	if ( zi >= 0 ){
		print ("    Z: " + userldlapTstamp.substr(zi,1) + " " + userldlapTstamp.substr(zi+1,2) + " " + userldlapTstamp.substr(zi+3,2) );
		var zoffset = Number(userldlapTstamp.substr(zi+1,2))*60 + Number(userldlapTstamp.substr(zi+3,2));
		zoffset= Number(userldlapTstamp.substr(zi,1)+"1")*zoffset*-1;
		print ("    zoffset " + zoffset );
		print ("    current offset " + target.getTimezoneOffset());
		var offsetDiff = zoffset - target.getTimezoneOffset();
		print ("    offsetDiff " + offsetDiff );
		target = target.add("m", offsetDiff);
		print ("    Received execution timestamp in local time " + target.toString());
	}
	print ("Execution timestamp is " + target.toUTCString() );

	// Parse current date
	var current = new Date();
	print ("Current time is " + current.toUTCString() );
	
	// Calculate the diff
	var delay = target.diff( current , "m");
	if (delay <= 0) {
		delay = 0;
	}
	print ("The delay is " + delay + " minutes ");
	dataset.delayInMinutes.set(0, delay);
}
