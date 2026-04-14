
function limit() {
	// limit the number of remediation to proceed to 2000 to avoid SQL issues
	var limit = config.ias_sqlinlimitvalue;
	if(limit== null || limit <= 0) {
		limit = 2100;
	}
	while(dataset.revokeupdaterecorduids.length>=limit) {
		dataset.revokeupdaterecorduids.remove(0);	
	}
}
