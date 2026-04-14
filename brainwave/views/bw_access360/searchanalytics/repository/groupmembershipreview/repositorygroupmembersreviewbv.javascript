
function read() {
	return businessview.getNextRecord();
}

var /*jave.util.HashMap*/ identitycache = null;
var /*java.util.HashSet*/ unknownIdentityCache = null;
function getIdentityCache(hrcode) {
	if(identitycache==null)
		identitycache = new java.util.HashMap();
	if(unknownIdentityCache==null)
		unknownIdentityCache = new java.util.HashSet();
	
	var ret = identitycache.get(hrcode);
	if(ret!=null) // already in cache
		return ret;
		
	if(unknownIdentityCache.contains(hrcode))
		return null; // already not found
	
	var params = new java.util.HashMap(); // search for identity infos
	params.put('hrcode', hrcode);
	var res = businessview.executeView(null, 'br_identity', params);
	ret = null;
	if(res!=null && res.length>0) {
		ret = {};
		ret.uid = res[0].get('uid');		
		ret.hrcode = res[0].get('hrcode');		
		ret.fullname = res[0].get('fullname');		
		ret.mail = res[0].get('mail');		
		identitycache.put(hrcode, ret); // store in cache
	}
	else {
		unknownIdentityCache.add(hrcode); // store search failed
	}
	
	return ret;
}

function advancedReviewerFinding(/*DataSet*/ record) {
	// Variables accessibles in the javascript
	var repositoryowneruid = record.businessowneruid.get();
	var repositoryownerhrcode = record.businessownerhrcode.get();
	var repositoryownerfullname = record.businessownerfullname.get();
	var repositoryownermail = record.businessownermail.get();
	var groupowneruid = record.groupowneruid.get();
	var groupownerhrcode = record.groupownerhrcode.get();
	var groupownerfullname = record.groupownerfullname.get();
	var groupownermail = record.groupownermail.get();
	var accountowneruid = record.accountowneruid.get();
	var accountownerhrcode = record.accountownerhrcode.get();
	var accountownerfullname = record.accountownerfullname.get();
	var accountownermail = record.accountownermail.get();
	var linemanageruid = record.linemanageruid.get();
	var linemanagerhrcode = record.linemanagerhrcode.get();
	var linemanagerfullname = record.linemanagerfullname.get();
	var linemanagermail = record.linemanagermail.get();
	var identityuid = record.identityuid.get();
	var identityhrcode = record.identityhrcode.get();
	var identityfullname = record.identityfullname.get();
	var identitymail = record.identitymail.get();
	var defaultrevieweruid = record.defaultrevieweruid.get();
	var defaultreviewerhrcode = record.defaultreviewerhrcode.get();
	var defaultreviewerfullname = record.defaultreviewerfullname.get();
	var defaultreviewermail = record.defaultreviewermail.get();
	var accountuid = record.accountuid.get();
	var accountlogin = record.accountlogin.get();
	var repositoryname = record.repositorydisplayname.get();
	var accountmaxrisklevel = record.accountmaxrisklevel.get();
	var accountsensitivitylevel = record.accountsensitivitylevel.get();
	var accountnoownercode = record.reconnoownercode.get();
	var groupuid = record.groupguid.get();
	var groupcode = record.groupuid.get();
	var groupguid = record.groupuid.get();
	var groupsid = record.groupsid.get();
	var groupdynamic = record.groupdynamic.get();
	var grouptype = record.groupgrouptype.get();
	var repositoryuid = record.repositoryuid.get();
	var repositorycode = record.repositorycode.get();

	var groupcustom1 = record.groupcustom1.get();
	var groupcustom2 = record.groupcustom2.get();
	var groupcustom3 = record.groupcustom3.get();
	var accountcustom1 = record.accountcustom1.get();
	var accountcustom2 = record.accountcustom2.get();
	var accountcustom3 = record.accountcustom3.get();
	var repositorycustom1 = record.repositorycustom1.get();
	var repositorycustom2 = record.repositorycustom2.get();
	var repositorycustom3 = record.repositorycustom3.get();
	var identitycustom1 = record.identitycustom1.get();
	var identitycustom2 = record.identitycustom2.get();
	var identitycustom3 = record.identitycustom3.get();
	
	// account reconciliation type
	var /*String*/ accounttype = null;
	if("leave".equals(record.reconnoownercode.get()))
		accounttype = "leave";
	else if(record.reconnoownercode.get() != null)
		accounttype = "technical";
	else if(record.identityuid.get() != null)
		accounttype = "user";
	else
		accounttype = "orphan";

	// last login in nbdays
	var lastloginindays = 0;
	if(!record.isEmpty('accountlastloginday')) {
		var n = new Date();
		var nday = Math.round(n.getTime()/(1000*3600*24));
		var alld = record.accountlastloginday.get();
		lastloginindays = nday-alld; 
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////
	// will contain reviewer information for the current line
	var /*String*/ revieweruid = null;
	var /*String*/ reviewerhrcode = null;
	var /*String*/ reviewerfullname = null;
	var /*String*/ reviewermail = null;
	var /*String*/ reviewerorigin = '';

	// compute script
	var evalScript = dataset.reviewerscript.get();

	if(evalScript.indexOf('java.')!=-1 || evalScript.indexOf('eval(')!=-1) {
		// security check: It is forbidden to instanciate java classes or recursively call eval for security reasons
		print("SECURITY ALERT - Reviewer script contains java classes or eval call");
		return record;
	}

	var /*String*/ strategy = eval(evalScript);
	
	var strategies = strategy.split(',');
	
	for (var i=0;i<strategies.length;i++) {
		strategy = strategies[i].trim();
		if('linemanager'.equalsIgnoreCase(strategy)) {
			revieweruid = linemanageruid;
			reviewerhrcode = linemanagerhrcode;
			reviewerfullname = linemanagerfullname;
			reviewermail = linemanagermail;
			reviewerorigin = 'linemanager';
		}
		else if('repositoryowner'.equalsIgnoreCase(strategy)) {
			revieweruid = repositoryowneruid;
			reviewerhrcode = repositoryownerhrcode;
			reviewerfullname = repositoryownerfullname;
			reviewermail = repositoryownermail;
			reviewerorigin = 'repositoryowner';
		}
		else if('accountowner'.equalsIgnoreCase(strategy)) {
			revieweruid = accountowneruid;
			reviewerhrcode = accountownerhrcode;
			reviewerfullname = accountownerfullname;
			reviewermail = accountownermail;
			reviewerorigin = 'accountowner';
		}
		else if('groupowner'.equalsIgnoreCase(strategy)) {
			revieweruid = groupowneruid;
			reviewerhrcode = groupownerhrcode;
			reviewerfullname = groupownerfullname;
			reviewermail = groupownermail;
			reviewerorigin = 'groupowner';
		}
		else if('default'.equalsIgnoreCase(strategy)) {
			revieweruid = defaultrevieweruid;
			reviewerhrcode = defaultreviewerhrcode;
			reviewerfullname = defaultreviewerfullname;
			reviewermail = defaultreviewermail;
			reviewerorigin = 'default';
		}
		else if('myself'.equalsIgnoreCase(strategy)) {
			revieweruid = identityuid;
			reviewerhrcode = identityhrcode;
			reviewerfullname = identityfullname;
			reviewermail = identitymail;
			reviewerorigin = 'myself';
		}
		else { // we assume that it is a hrcode instead of a strategy
			var id = getIdentityCache(strategy);
			if(id!=null) {
				revieweruid = id.uid;
				reviewerhrcode = id.hrcode;
				reviewerfullname = id.fullname;
				reviewermail = id.mail;
				reviewerorigin = 'default';
			}			
		}
		// reviewer found		
		if(revieweruid!=null && reviewermail!=null)
			break;
	}
	
	// ///////////////////////////////////////////////////////////////////////////////////////////

	// Set reviewer
	if(revieweruid != null && reviewermail != null) {
		record.revieweruid.set(revieweruid);
		record.reviewerhrcode.set(reviewerhrcode);
		record.reviewerfullname.set(reviewerfullname);
		record.reviewermail.set(reviewermail);
		record.reviewerorigin.set(reviewerorigin);
	}

	return record;
}

function standardReviewerFinding(/*DataSet*/ record) {
	// will contain reviewer information for the current line
	var /*String*/ revieweruid = null;
	var /*String*/ reviewerhrcode = null;
	var /*String*/ reviewerfullname = null;
	var /*String*/ reviewermail = null;
	var /*String*/ reviewerorigin = '';

	// ///////////////////////////////////////////////////////////////////////////////////////////

	// check if the account is reconciled
	var /*Boolean*/ isUserAccount = !record.isEmpty('identityuid');

	var /*String*/ identityuid = null;
	var /*String*/ identityhrcode = null;
	var /*String*/ identityfullname = null;
	var /*String*/ identitymail = null;
	if(!record.isEmpty('identitymail')) {
		identityuid = record.identityuid.get();
		identityhrcode = record.identityhrcode.get();
		identityfullname = record.identityfullname.get();
		identitymail = record.identitymail.get();
	}

	// precomputing phase: get repository owner infos
	var /*String*/ businessowneruid = null;
	var /*String*/ businessownerhrcode = null;
	var /*String*/ businessownerfullname = null;
	var /*String*/ businessownermail = null;
	if(!record.isEmpty('businessownermail')) {
		businessowneruid = record.businessowneruid.get();
		businessownerhrcode = record.businessownerhrcode.get();
		businessownerfullname = record.businessownerfullname.get();
		businessownermail = record.businessownermail.get();
	}

	// precomputing phase: get group owner infos
	var /*String*/ groupowneruid = null;
	var /*String*/ groupownerhrcode = null;
	var /*String*/ groupownerfullname = null;
	var /*String*/ groupownermail = null;
	if(!record.isEmpty('groupownermail')) {
		groupowneruid = record.groupowneruid.get();
		groupownerhrcode = record.groupownerhrcode.get();
		groupownerfullname = record.groupownerfullname.get();
		groupownermail = record.groupownermail.get();
	}

	// precomputing phase: get line manager infos
	var /*String*/ linemanageruid = null;
	var /*String*/ linemanagerhrcode = null;
	var /*String*/ linemanagerfullname = null;
	var /*String*/ linemanagermail = null;
	if(!record.isEmpty('linemanagermail')) {
		linemanageruid = record.linemanageruid.get();
		linemanagerhrcode = record.linemanagerhrcode.get();
		linemanagerfullname = record.linemanagerfullname.get();
		linemanagermail = record.linemanagermail.get();
	}

	// precomputing phase: get default reviewer infos
	var /*String*/ defaultrevieweruid = null;
	var /*String*/ defaultreviewerhrcode = null;
	var /*String*/ defaultreviewerfullname = null;
	var /*String*/ defaultreviewermail = null;
	if(!record.isEmpty('defaultreviewermail')) {
		defaultrevieweruid = record.defaultrevieweruid.get();
		defaultreviewerhrcode = record.defaultreviewerhrcode.get();
		defaultreviewerfullname = record.defaultreviewerfullname.get();
		defaultreviewermail = record.defaultreviewermail.get();
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////

	// STEP 1: User accounts are reviewed by line managers
	if(linemanageruid!=null) {
		revieweruid = linemanageruid;
		reviewerhrcode = linemanagerhrcode;
		reviewerfullname = linemanagerfullname;
		reviewermail = linemanagermail;
		reviewerorigin = "linemanager";
	}

	// STEP 2: Tech. accounts & orphan accounts are reviewed by repository owner
	if(!isUserAccount) {
		revieweruid = businessowneruid;
		reviewerhrcode = businessownerhrcode;
		reviewerfullname = businessownerfullname;
		reviewermail = businessownermail;
		reviewerorigin = "repositoryowner";
	}

	// STEP 3: Tech. accounts & orphan accounts are reviewed by group owner
	if(dataset.forcegroupownerfortechaccounts.get().equals("1") && !isUserAccount) {
		revieweruid = groupowneruid;
		reviewerhrcode = groupownerhrcode;
		reviewerfullname = groupownerfullname;
		reviewermail = groupownermail;
		reviewerorigin = "groupowner";
	}
		
	// STEP 4: Option: All users accounts are reviewed by the user himself
	if(dataset.forcehimselfasreviewer.get().equals("1") && isUserAccount) {
		revieweruid = identityuid;
		reviewerhrcode = identityhrcode;
		reviewerfullname = identityfullname;
		reviewermail = identitymail;
		reviewerorigin = "myself";
	}

	// STEP 5: Option: All remaining accounts are reviewed by the repository owner
	if(dataset.forcebusinessownerforallotheraccounts.get().equals("1") && revieweruid==null) {
		revieweruid = businessowneruid;
		reviewerhrcode = businessownerhrcode;
		reviewerfullname = businessownerfullname;
		reviewermail = businessownermail;
		reviewerorigin = "repositoryowner";
	}

	// STEP 6: Option: All remaining members are reviewed by the group owner
	if(dataset.forcegroupownerforallotheraccounts.get().equals("1") && revieweruid==null) {
		revieweruid = groupowneruid;
		reviewerhrcode = groupownerhrcode;
		reviewerfullname = groupownerfullname;
		reviewermail = groupownermail;
		reviewerorigin = "groupowner";
	}
	
	// STEP 7: Option: All members are reviewed by the group owner
	if(dataset.forcegroupownerasreviewer.get().equals("1")) {
		revieweruid = groupowneruid;
		reviewerhrcode = groupownerhrcode;
		reviewerfullname = groupownerfullname;
		reviewermail = groupownermail;
		reviewerorigin = "groupowner";
	}	

	// STEP 8: Option: All accounts are reviewed by the repository owner
	if(dataset.forcebusinessownerasreviewer.get().equals("1")) {
		revieweruid = businessowneruid;
		reviewerhrcode = businessownerhrcode;
		reviewerfullname = businessownerfullname;
		reviewermail = businessownermail;
		reviewerorigin = "repositoryowner";
	}

	// STEP 9: All remaining accounts are reviewed by the default reviewer
	if(revieweruid==null) {
		revieweruid = defaultrevieweruid;
		reviewerhrcode = defaultreviewerhrcode;
		reviewerfullname = defaultreviewerfullname;
		reviewermail = defaultreviewermail;
		reviewerorigin = "default";
	}

	// STEP 10: All accounts are reviewed by the default reviewer
	if(dataset.forcedefaultreviewerasreviewer.get().equals("1")) {
		revieweruid = defaultrevieweruid;
		reviewerhrcode = defaultreviewerhrcode;
		reviewerfullname = defaultreviewerfullname;
		reviewermail = defaultreviewermail;
		reviewerorigin = "default";
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////

	// Set reviewer
	if(revieweruid != null) {
		record.revieweruid.set(revieweruid);
		record.reviewerhrcode.set(reviewerhrcode);
		record.reviewerfullname.set(reviewerfullname);
		record.reviewermail.set(reviewermail);
		record.reviewerorigin.set(reviewerorigin);
	}

	return record;
}

function setreviewer() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

	if(!dataset.isEmpty('reviewerscript')) // advanced mode
		return advancedReviewerFinding(record);
	else	// standard mode
		return standardReviewerFinding(record);

}

function initReviewColumns() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

 	var /*Attribute<String>*/ attribute = record.add('reviewstatus', 'String', false);
    attribute.set('');
    
 	attribute = record.add('reviewcomment', 'String', false);
    attribute.set('');

 	attribute = record.add('reviewactorfullname', 'String', false);
    attribute.set('');

 	attribute = record.add('reviewactiondate', 'Date', false);
    attribute.set(null);

	return record;	
}

function checkIdentityPosition() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

	var identitypositionkey = record.identitypositionkey.get();
	var reviewidentitypositionkey = record.reviewidentitypositionkey.get();
	
	// reset previous review status if identity position changed since the identity review
	if(identitypositionkey == null || reviewidentitypositionkey == null || !identitypositionkey.equals(reviewidentitypositionkey)) {
		record.reviewstatus.set('');
		record.reviewcomment.set('');
	}
	return record;
}