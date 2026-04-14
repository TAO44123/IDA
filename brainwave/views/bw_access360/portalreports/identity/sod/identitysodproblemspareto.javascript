
var sum = 0;
var grandtotal = 0;

function init() {
	var /*java.util.HashMap*/ params = new java.util.HashMap();
	if(!dataset.isEmpty('identityuid')) {
		params.put('identityuid', dataset.identityuid.get());
	}
	if(!dataset.isEmpty('organisationuid')) {
		params.put('organisationuid', dataset.organisationuid.get());
	}
	if(!dataset.isEmpty('minimumRiskLevel')) {
		params.put('minimumRiskLevel', ''+dataset.minimumRiskLevel.get());
	}
	var v = businessview.executeView(null, "bwa360_identitysodproblemslist_bv" , params);
	grandtotal = v.length;
	//for(var i=0;i<v.length;i++) {
	//	var record = v[i];
	//	var val = record.get('nbidentity_all');
	//	if(val!=null) {
	//		var valint = parseInt(val, 10);	
	//		grandtotal += valint; 
	//	}
	//}
}

function read() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

	var val = record.nbidentity.get();
	sum += val;

	var runningsum = record.add("nbidentity_runningsum" , "Number", false);
	runningsum.set(0, sum);

	var gtotal = record.add("nbidentity_grandtotal" , "Number", false);
	gtotal.set(0, grandtotal);

	var runningpercent = record.add("nbidentity_runningpercent" , "Number", false);
	if(grandtotal>0) {
		var percent = Math.round((sum*100)/grandtotal);
		runningpercent.set(0, percent);
	}

	return record;	
}
