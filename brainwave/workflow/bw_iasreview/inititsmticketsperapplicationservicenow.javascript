import "../../webportal/pages/resources/security.javascript"
import "../bw_servicenow/servicenow.javascript"

function replaceNullByEmpty(str) {
	if(str==null)
		return '';
	else
		return str;		
}

function createChangeInfos() {
	// decrypt all fields except password/token
	var fields = [
					"itsmurl",
					"itsmlogin",
					// "itsmpassword",
					"itsmtickettype",
					"itsmcallerid",
					"itsmassignmentgroup",
					"itsmauthenticationtype",
					"itsmtokengranttype",
					"itsmclientid",
					// "itsmclientsecret",
					"itsmrefreshtoken",
					"itsmtokenexpiresin",
					"itsmtokenexpirationdate",
					"itsmscope"
				];
	decryptFields(fields);
	
	dataset.changedescription.clear();
	
	// By default is an application
	var applicationtype = "application";
	if (dataset.applicationtype.get() == "Server") {
		applicationtype = "server"
	}
	
	var actions = "see attachment";
	var actionscsv = "status,identifier,login,repository," + applicationtype + ",permissioncode,permissionname,perimetercode,perimetername,comment,requestedon,requestedby\n";
	
	for(var i=0;i<dataset.reviewstatus.length;i++) {
		var status = dataset.reviewstatus.get(i);
		var identifier = '"'+dataset.accountidentifier.get(i)+'"';
		var login = dataset.accountlogin.get(i);
		var repository = dataset.repositorydisplayname.get(i);

		var application = dataset.applicationdisplayname.get(i);
		var permissioncode = dataset.permissioncode.get(i);
		var permissiondisplayname = replaceNullByEmpty(dataset.permissiondisplayname.get(i));
		var perimetercode = replaceNullByEmpty(dataset.perimetercode.get(i));
		var perimeterdisplayname = replaceNullByEmpty(dataset.perimeterdisplayname.get(i));

		var comment = replaceNullByEmpty(dataset.reviewcomment.get(i));
		var on = replaceNullByEmpty(dataset.reviewactiondate.get(i));
		var by = replaceNullByEmpty(dataset.reviewerfullname.get(i));
		
		if(permissiondisplayname==null) permissiondisplayname = '';
		if(perimetercode==null) perimetercode = '';
		if(perimeterdisplayname==null) perimeterdisplayname = '';
		if(comment==null) comment = '';
		
		var str1 = "";
		//if(reviewtype.equalsIgnoreCase("account"))
		//	str1 = status+" "+reviewtype+" for account "+login+" from repository "+repository+((comment.length>0)?" ("+comment+") ":"")+" requested on "+on+" by "+by+"\n";
		//else
		//	str1 = status+" "+reviewtype+" for account "+login+", permission "+permissioncode+" ("+permissionname+") from application "+applicationname+" from repository "+repository+((comment.length>0)?" ("+comment+") ":"")+" requested on "+on+" by "+by+"\n";

		var str2 = status+","+identifier+","+login+","+repository+","+application+","+permissioncode+","+permissiondisplayname.replace(",", "", "g")+","+perimetercode.replace(",", "", "g")+","+perimeterdisplayname.replace(",", "", "g")+","+comment.replace(",", "", "g")+","+on+","+by+"\n";		
		
		actions = actions+str1;
		actionscsv = actionscsv + str2;
	}
	
	dataset.changedescription = actions;
	dataset.changecsv = actionscsv;
}

function getIncidentStatusStr() {
	var status = dataset.status.get();
	var closedstatus = getIncidentClosedStatus(status);
	dataset.closedstatus.set(closedstatus);
	var statusStr = getIncidentStatusLabel(status);
	dataset.statusStr.set(statusStr);
}

function getChangeRequestStatusStr() {
	var status = dataset.status.get();
	var closedstatus = getChangeRequestClosedStatus(status);
	dataset.closedstatus.set(closedstatus);
	var statusStr = getChangeRequestStatusLabel(status);
	dataset.statusStr.set(statusStr);
}
