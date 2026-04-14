import "../../webportal/pages/resources/security.javascript"

function putCommaSeparatedParameterInMultivaluedAttribute(/*String*/ param, /*Attribute*/ attribute) {
	attribute.clear();
	if(!dataset.isEmpty(param) && dataset.get(param).get().trim().length>0) {
		var allvals = dataset.get(param).get().split(',');
		attribute.clear();
		for(var i=0;i<allvals.length;i++)
			attribute.add(allvals[i].trim())
	}
}

function init() {
	// decrypt all fields except password/token
	var fields = [
					"itsmurl",
					"itsmlogin",
					"itsmclosedstatesid",
					"itsmcancelledstatesid"
				];
	decryptFields(fields);

	// parse closed status
	putCommaSeparatedParameterInMultivaluedAttribute('itsmclosedstatesid', dataset.closedstateslist);
	// parse cancelled status
	putCommaSeparatedParameterInMultivaluedAttribute('itsmcancelledstatesid', dataset.cancelledtaskslist);
}

function initRemediationLatestInfos() {
	var /*java.util.HashMap*/ res = new java.util.HashMap();
	
	for(var i=0;i<dataset.res_ticketid.length;i++) {
		var /*String*/ ticketid = ''+dataset.res_ticketid.get(i);
		var /*String*/ ticketclosed = dataset.res_ticketclosed.get(i);
		var /*String*/ ticketstatusstr = dataset.res_ticketstatusstr.get(i);
		var /*String*/ ticketupdatedatetime = dataset.res_ticketupdatedatetime.get(i);

		var infos = {};
		infos.ticketclosed = ticketclosed;
		infos.ticketstatusstr = ticketstatusstr;
		infos.ticketupdatedatetime = ticketupdatedatetime;
	
		res.put(ticketid, infos);	
	}
	
	return res;
}

function updateTicketStatus() {
	var /*java.util.HashMap*/ cache = initRemediationLatestInfos();
	
	/*
	We have to do it this way because several remediations can be handled through a SINGLE itsm ticket...
	and we MUST avoid unecessary API calls
	*/
	for(var i=dataset.remediationrecorduid.length-1;i>=0;i--) {
		var /*String*/ remediationticketid = ''+dataset.remediationticketid.get(i);
		 	
		var infos = cache.get(remediationticketid);
		if(infos!=null) {
			// update attributes
			dataset.remediationstatus.set(i, infos.ticketstatusstr);
			dataset.remediationclosedstatus.set(i, infos.ticketclosed);
			dataset.remediationactiondate.set(i, infos.ticketupdatedatetime);
		}
		else {
			// not found? just remove the line to avoid unecessary ticket update
			dataset.remediationrecorduid.remove(i);
			dataset.remediationstatus.remove(i);
			dataset.remediationclosedstatus.remove(i);
			dataset.remediationactiondate.remove(i);
		}
	}

}
