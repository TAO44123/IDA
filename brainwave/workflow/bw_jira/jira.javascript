import "../../webportal/pages/resources/security.javascript"

var javadependencies = JavaImporter(
	Packages.com.brainwave.itsm.JiraHelper
);

function createTicket() {
	with(javadependencies) {
		var /*com.brainwave.itsm.JiraHelper*/ jh = new JiraHelper();

		var /*String*/ domain = dataset.domain.get();
		var /*String*/ login = dataset.login.get();
		var /*String*/ token = dataset.token.get();
		// decipher token
		token = decipher(token);
		
		if(domain == null || login == null || token == null) {
			dataset.ticketCreated = false;
			return;	
		}
		
		var /*boolean*/ init = jh.setBaseUrl(domain).setLogin(login).setToken(token).init();
		if(!init) {
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
			dataset.ticketCreated = false;
			return;	
		}

		var /*String*/ projectkey = dataset.projectkey.get();
		if(projectkey!=null) projectkey = projectkey.trim(); 
		var /*String*/ summary = dataset.summary.get();
		if(summary!=null) summary = summary.trim(); 
		var /*String*/ description = dataset.description.get();
		if(description!=null) description = description.trim(); 
		var /*String*/ assignee = dataset.assignee.get();
		if(assignee!=null) assignee = assignee.trim(); 
		var /*String*/ issueType = dataset.issueType.get();
		if(issueType!=null) issueType = issueType.trim(); 
		var /*String*/ tags = null;
		if(dataset.tags.length>0) {
			tags = new Array();
			for (var tag in dataset.tags) {
				tags.push(tag);
			}
		}

		if(projectkey == null || summary == null || description == null) {
			dataset.ticketCreated = false;
			return;	
		}

		var issueInfos = jh.createIssue(projectkey, issueType, summary, description, assignee, tags);
		if(issueInfos==null) {
			var errormessage = jh.getError();
			if(errormessage!=null) {
				print(errormessage);
				dataset.errorMessage.set(errormessage);
			} else {
				dataset.errorMessage.set("Unknown error when creating the ticket");
			}
			dataset.ticketCreated = false;
			return;	
		}
		else {
			dataset.ticketCreated.set(true);
			dataset.ticketId.set(issueInfos[0]);
			dataset.ticketNumber.set(issueInfos[1]);
			return;	
		}
	}	
}

function addAttachment() {
	with(javadependencies) {
		dataset.attachmentdone = false;

		var /*com.brainwave.itsm.JiraHelper*/ jh = new JiraHelper();

		var /*String*/ ticketid = dataset.ticketid.get();	
		var /*String*/ domain = dataset.domain.get();
		var /*String*/ login = dataset.login.get();
		var /*String*/ token = dataset.token.get();
		// decipher token
		token = decipher(token);
		
		if(ticketid == null || domain == null || login == null || token == null) {
			return;	
		}
	
		var /*boolean*/ init = jh.setBaseUrl(domain).setLogin(login).setToken(token).init();
		if(!init) {
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
			return;	
		}
	
		var /*String*/ filename = dataset.filename.get();
		var /*String*/ filecontent = dataset.filecontent.get();
	
		var attachementDone = jh.addTextAttachment(ticketid, filename, filecontent);	
		
		if(attachementDone) {
			dataset.attachmentdone = true;
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
		}
		else
			dataset.attachmentdone = false;
	}
}

function getStatus() {
	with(javadependencies) {
		dataset.statusretrieved = false;
		dataset.statusid = null;
		dataset.statuslabel = null;

		var /*com.brainwave.itsm.JiraHelper*/ jh = new JiraHelper();

		var /*String*/ ticketid = dataset.ticketid.get();	
		var /*String*/ domain = dataset.domain.get();
		var /*String*/ login = dataset.login.get();
		var /*String*/ token = dataset.token.get();
		// decipher token
		token = decipher(token);
		
		if(ticketid == null || domain == null || login == null || token == null) {
			return;	
		}
	
		var /*boolean*/ init = jh.setBaseUrl(domain).setLogin(login).setToken(token).init();
		if(!init) {
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
			return;	
		}

		var issueStatus = jh.getIssueStatus(ticketid);
		if(issueStatus == null) {
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
			return;	
		}
		else {
			dataset.statusretrieved = true;
			dataset.statusid = issueStatus[0];
			dataset.statuslabel = issueStatus[1];
		}
	}
}

function isInList(attrListName, statusid) {
	if(!dataset.isEmpty(attrListName)) {
		var /*Attribute*/ attribute = dataset.get(attrListName);
		for(var i=0;i<attribute.length;i++) {
			var /*String*/ teststate = attribute.get(i);
			if(teststate.equals(statusid)) {
				return true;
			}
		}
	}
	return false;
}

function getAllStatus() {
	with(javadependencies) {
		dataset.outticketid.clear();
		dataset.outticketstatus.clear();
		dataset.outticketstatusid.clear();
		dataset.outticketupdatedatetime.clear();
		dataset.outticketclosedstatus.clear();

		var /*com.brainwave.itsm.JiraHelper*/ jh = new JiraHelper();

		var /*String*/ domain = dataset.domain.get();
		var /*String*/ login = dataset.login.get();
		var /*String*/ token = dataset.token.get();
		// decipher token
		token = decipher(token);
		
		if(dataset.isEmpty('ticketid') || domain == null || login == null || token == null) {
			return;	
		}
	
		var /*boolean*/ init = jh.setBaseUrl(domain).setLogin(login).setToken(token).init();
		if(!init) {
			var errormessage = jh.getError();
			if(errormessage!=null) print(errormessage);
			return;	
		}

		for(var ticketid in dataset.ticketid) {
			var issueStatus = jh.getIssueStatus(ticketid);
			if(issueStatus != null) {
				dataset.outticketid.add(ticketid);
				dataset.outticketstatusid.add(issueStatus[0]);
				dataset.outticketstatus.add(issueStatus[1]);
				var dt = new Date();
				dataset.outticketupdatedatetime.add(dt.toLDAPString());
				// check if ticket status is closed
				if(isInList('closedstateslist', issueStatus[0])) {
					dataset.outticketclosedstatus.add('1');
				}
				else if(isInList('cancelledstateslist', issueStatus[0])) {
					dataset.outticketclosedstatus.add('2');
				}
				else {
					dataset.outticketclosedstatus.add('0');
				}
			}
			else {
				var errormessage = jh.getError();
				if(errormessage!=null) print(errormessage);
			}
		}
	}
}