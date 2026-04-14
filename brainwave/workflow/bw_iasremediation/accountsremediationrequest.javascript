import '../bw_access360/_lib.javascript';

function init() {
	// get pending/active remediations
	var params = new java.util.HashMap();
	var accounts = new Array();
	for (var i=0;i<dataset.accountuid.length;i++)
		accounts.push(dataset.accountuid.get(i));
	var closedstatus = new Array();
	closedstatus.push('-1');
	closedstatus.push('0');
	params.put('uid', accounts);
	params.put('remediationclosedstatus', closedstatus);
	printDebug( 'bwiasr_accountsremediationrequest: init() -> number of accounts before cleanup: ' + dataset.accountuid.length );
	// build a cache
	var keys = new java.util.HashSet();
	printDebug( 'bwiasr_accountsremediationrequest: init() -> calling view: bwiasr_getaccountremediationstatus' );
	var results = workflow.executeView(null, "bwiasr_getaccountremediationstatus", params);
	printDebug( 'bwiasr_accountsremediationrequest: init() -> view: bwiasr_getaccountremediationstatus returned ' + results.length + ' results' );
	for(var i=0;i<results.length;i++) {
		var current = results[i];
		keys.add(''+current.get('accountuid'));
	}
	
	// dynamically remove them from the list if they are present
	for(var i=dataset.accountuid.length-1;i>=0;i--) {
		var currentaccount = ''+dataset.accountuid.get(i);
		
		if(keys.contains(currentaccount)) {
			// remove the element...
			dataset.accountuid.remove(i);
			dataset.status_ticketreview.remove(i);
			dataset.accountableuid.remove(i);
			dataset.comment.remove(i);
			dataset.labels.remove(i);
			dataset.identitypositionkeys.remove(i);
			dataset.reviewersorigin.remove(i);
			dataset.remediationtype.remove(i);
		} 	
	}
	printDebug( 'bwiasr_accountsremediationrequest: init() -> number of accounts left after cleanup: ' + dataset.accountuid.length );
}
