
function read() {
	return businessview.getNextRecord();
}

function setreviewer() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;

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

	// precomputing phase: get safe owner infos
	var /*String*/ safeowneruid = null;
	var /*String*/ safeownerhrcode = null;
	var /*String*/ safeownerfullname = null;
	var /*String*/ safeownermail = null;
	if(!record.isEmpty('safeownermail')) {
		safeowneruid = record.safeowneruid.get();
		safeownerhrcode = record.safeownerhrcode.get();
		safeownerfullname = record.safeownerfullname.get();
		safeownermail = record.safeownermail.get();
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

	// STEP 2: Tech. accounts & orphan accounts are reviewed by safe owner
	if(!isUserAccount) {
		revieweruid = safeowneruid;
		reviewerhrcode = safeownerhrcode;
		reviewerfullname = safeownerfullname;
		reviewermail = safeownermail;
		reviewerorigin = "safeowner";
	}
	
	// STEP 3: Option: All users accounts are reviewed by the user himself
	if(dataset.forcehimselfasreviewer.get().equals("1") && isUserAccount) {
		revieweruid = identityuid;
		reviewerhrcode = identityhrcode;
		reviewerfullname = identityfullname;
		reviewermail = identitymail;
		reviewerorigin = "myself";
	}

	// STEP 4: Option: All remaining accounts are reviewed by the safe owner
	if(dataset.forcesafeownerforallotheraccounts.get().equals("1") && revieweruid==null) {
		revieweruid = safeowneruid;
		reviewerhrcode = safeownerhrcode;
		reviewerfullname = safeownerfullname;
		reviewermail = safeownermail;
		reviewerorigin = "safeowner";
	}

	// STEP 5: Option: All accounts are reviewed by the app owner
	if(dataset.forcesafeownerasreviewer.get().equals("1")) {
		revieweruid = safeowneruid;
		reviewerhrcode = safeownerhrcode;
		reviewerfullname = safeownerfullname;
		reviewermail = safeownermail;
		reviewerorigin = "safeowner";
	}

	// STEP 6: All remaining accounts are reviewed by the default reviewer
	if(revieweruid==null) {
		revieweruid = defaultrevieweruid;
		reviewerhrcode = defaultreviewerhrcode;
		reviewerfullname = defaultreviewerfullname;
		reviewermail = defaultreviewermail;
		reviewerorigin = "default";
	}

	// STEP 7: All remaining accounts are reviewed by the default reviewer
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
