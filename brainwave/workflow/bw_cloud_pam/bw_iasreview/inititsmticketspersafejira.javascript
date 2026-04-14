import "../../../webportal/pages/resources/security.javascript"
import "../../bw_servicenow/servicenow.javascript"

function replaceNullByEmpty(str) {
	if(str==null)
		return '';
	else
		return str;		
}

function putCommaSeparatedParameterInMultivaluedAttribute(/*String*/ param, /*Attribute*/ attribute) {
	attribute.clear();
	if(!dataset.isEmpty(param) && dataset.get(param).get().trim().length>0) {
		var allvals = dataset.get(param).get().split(',');
		attribute.clear();
		for(var i=0;i<allvals.length;i++)
			attribute.add(allvals[i].trim())
	}
}

function createChangeInfos() {
	// decrypt all fields except password/token
	var fields = [
					"itsmurl",
					"itsmlogin",
					"itsmtickettype",
					"itsmprojectkey",
					"itsmassignee",
					"itsmtags",
					"itsmclosedstatesid",
					"itsmcancelledstatesid"
				];
	decryptFields(fields);
	
	// parse tags
	putCommaSeparatedParameterInMultivaluedAttribute('itsmtags', dataset.tagslist);

	// parse closed status
	putCommaSeparatedParameterInMultivaluedAttribute('itsmclosedstatesid', dataset.closedstateslist);

	// parse cancelled status
	putCommaSeparatedParameterInMultivaluedAttribute('itsmcancelledstatesid', dataset.cancelledtaskslist);

	dataset.changedescription.clear();
	
	var actions = "see attachment";
	var actionscsv = "status,identifier,login,repository,application,vault,permissioncode,permissionname,comment,requestedon,requestedby\n";
	
	for(var i=0;i<dataset.reviewstatus.length;i++) {
		var status = dataset.reviewstatus.get(i);
		var identifier = '"'+dataset.accountidentifier.get(i)+'"';
		var login = dataset.accountlogin.get(i);
		var repository = dataset.repositorydisplayname.get(i);

		var application = dataset.applicationdisplayname.get(i);
		var vault = dataset.vaultdisplayname.get(i);
		var permissioncode = dataset.permissioncode.get(i);
		var permissiondisplayname = replaceNullByEmpty(dataset.permissiondisplayname.get(i));

		var comment = replaceNullByEmpty(dataset.reviewcomment.get(i));
		var on = replaceNullByEmpty(dataset.reviewactiondate.get(i));
		var by = replaceNullByEmpty(dataset.reviewerfullname.get(i));
		
		if(permissiondisplayname==null) permissiondisplayname = '';
		if(comment==null) comment = '';
		
		var str1 = "";
		//if(reviewtype.equalsIgnoreCase("account"))
		//	str1 = status+" "+reviewtype+" for account "+login+" from repository "+repository+((comment.length>0)?" ("+comment+") ":"")+" requested on "+on+" by "+by+"\n";
		//else
		//	str1 = status+" "+reviewtype+" for account "+login+", permission "+permissioncode+" ("+permissionname+") from application "+applicationname+" from repository "+repository+((comment.length>0)?" ("+comment+") ":"")+" requested on "+on+" by "+by+"\n";

		var str2 = status+","+identifier+","+login+","+repository+","+application+","+vault+","+permissioncode+","+permissiondisplayname.replace(",", "", "g")+","+comment.replace(",", "", "g")+","+on+","+by+"\n";		
		
		actions = actions+str1;
		actionscsv = actionscsv + str2;
	}
	
	dataset.changedescription = actions;
	dataset.changecsv = actionscsv;
}

function computeStatus() {
	dataset.closedstatus.set('0');
	var status = dataset.status.get();

	// ticket closed
	if(!dataset.isEmpty('closedstateslist')) {
		for(var i=0;i<dataset.closedstateslist.length;i++) {
			var /*String*/ closedstate = dataset.closedstateslist.get(i);
			if(closedstate.equals(status)) {
				dataset.closedstatus.set('1');
				break;	
			}
		}
	}

	// ticket cancelled
	if(!dataset.isEmpty('cancelledtaskslist')) {
		for(var i=0;i<dataset.cancelledtaskslist.length;i++) {
			var /*String*/ cancelledstate = dataset.cancelledtaskslist.get(i);
			if(cancelledstate.equals(status)) {
				dataset.cancelledstate.set('2');
				break;	
			}
		}
	}
}
