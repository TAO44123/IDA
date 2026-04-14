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
	params.put('accountuid', accounts);
	params.put('remediationclosedstatus', closedstatus);

	// build a cache
	var keys = new java.util.HashSet();
	var results = workflow.executeView(null, "bwiasr_getrightremediationstatus", params);
	for(var i=0;i<results.length;i++) {
		var current = results[i];
		
		var account = current.get('accountuid');
		var permission = current.get('permissionuid');
		var perimeter = current.get('perimeteruid');
		if(perimeter==null)
			perimeter = '';
		var key = account + '$$' + permission + '$$' + perimeter;
		
		keys.add(key);
	}
	
	// dynamically remove them from the list if they are present
	for(var i=dataset.accountuid.length-1;i>=0;i--) {
		var currentaccount = dataset.accountuid.get(i);
		var currentpermission = dataset.permissionuid.get(i);
		var currentperimeter = dataset.perimeteruid.get(i);
		if(currentperimeter==null)
			currentperimeter = '';
		var currentkey = currentaccount + '$$' + currentpermission + '$$' + currentperimeter;
		
		if(keys.contains(currentkey)) {
			// remove the element...
			dataset.accountuid.remove(i);
			dataset.permissionuid.remove(i);
			dataset.perimeteruid.remove(i);
			dataset.status_ticketreview.remove(i);
			dataset.accountableuid.remove(i);
			dataset.comment.remove(i);
			dataset.labels.remove(i);
			dataset.identitypositionkeys.remove(i);
			dataset.reviewersorigin.remove(i);
			dataset.remediationtype.remove(i);
		} 	
	}
}
