
var sum = 0;
var grandtotal = 0;

function init() {
	var /*java.util.HashMap*/ params = new java.util.HashMap();
	if(!dataset.isEmpty('applicationuid')) {
		params.put('applicationuid', dataset.applicationuid.get());
	}
	if(!dataset.isEmpty('role_uid')) {
		params.put('role_uid', dataset.role_uid.get());
	}
	if(!dataset.isEmpty('minimumRiskLevel')) {
		params.put('minimumRiskLevel', ''+dataset.minimumRiskLevel.get());
	}
	var v = businessview.executeView(null, "bwa360_rolessodproblems1" , params);
	for(var i=0;i<v.length;i++) {
		var record = v[i];
		var val = record.get('nbroles');
		if(val!=null) {
			var valint = parseInt(val, 10);	
			grandtotal += valint; 
		}
	}
}

function read() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

	var val = record.nbroles.get();
	sum += val;

	var runningsum = record.add("nbroles_runningsum" , "Number", false);
	runningsum.set(0, sum);

	var gtotal = record.add("nbroles_grandtotal" , "Number", false);
	gtotal.set(0, grandtotal);

	var runningpercent = record.add("nbroles_runningpercent" , "Number", false);
	if(grandtotal>0) {
		var percent = Math.round((sum*100)/grandtotal);
		runningpercent.set(0, percent);
	}

	return record;	
}
