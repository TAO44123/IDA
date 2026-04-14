
function init() {
}

function initJSONRecord() {
	var r = {};

	r.accountidentifier = null;
	r.accountlastlogindate = null;
	r.accountlogin = null;
	r.accountmaxrisklevel = null;
	r.accountnbrisks = null;
	r.accountriskrank = null;
	r.accountuid = null;
	r.accountusername = null;
	r.applicationcode = null;
	r.applicationdescription = null;
	r.applicationdisplayname = null;
	r.applicationsensitivitylevel = null;
	r.applicationsensitivityreason = null;
	r.applicationuid = null;
	r.campaigndescription = null;
	r.campaignduedate = null;
	r.campaignid = null;
	r.campaignpriority = null;
	r.campaignsubmissiondate = null;
	r.campaigntitle = null;
	r.filteraccount = null;
	r.filterapplication = null;
	r.filteridentity = null;
	r.filterpermission = null;
	r.groupedby = null;
	r.id = null;
	r.discr = null;
	r.identityactive = null;
	r.identityarrivaldate = null;
	r.identitydeparturedate = null;
	r.identityfullname = null;
	r.identityhrcode = null;
	r.identityinternal = null;
	r.identityjoborg = null;
	r.identitymail = null;
	r.identityuid = null;
	r.includedcampaigns = null;
	r.isheader = null;
	r.notreviewedonly = null;
	r.parentid = null;
	r.parentid = null;
	r.permissioncode = null;
	r.permissiondescription = null;
	r.permissiondisplayname = null;
	r.permissionsensitivitylevel = null;
	r.permissionuid = null;
	r.reconcomment = null;
	r.reconleavedate = null;
	r.reconnoownercode = null;
	r.reconuid = null;
	r.remediationrecorduid = null;
	r.repositorydisplayname = null;
	r.repositoryuid = null;
	r.reviewactiondate = null;
	r.reviewactorfullname = null;
	r.reviewcomment = null;
	r.reviewerfullname = null;
	r.reviewerhrcode = null;
	r.reviewermail = null;
	r.reviewerorigin = null;
	r.revieweruid = null;
	r.reviewrecorduid = null;
	r.reviewstatus = null;
	r.rightaction = null;
	r.rightlimit = null;
	r.rightperimetercode = null;
	r.rightperimeterdisplayname = null;
	r.rightperimeteruid = null;
	
	return r;
 }
 
 function fullfillRecord(record, r) {
 	record.accountidentifier.set(r.accountidentifier);
	record.accountlastlogindate.set(r.accountlastlogindate);
	record.accountlogin.set(r.accountlogin);
	record.accountmaxrisklevel.set(r.accountmaxrisklevel);
	record.accountnbrisks.set(r.accountnbrisks);
	record.accountriskrank.set(r.accountriskrank);
	record.accountuid.set(r.accountuid);
	record.accountusername.set(r.accountusername);
	record.applicationcode.set(r.applicationcode);
	record.applicationdescription.set(r.applicationdescription);
	record.applicationdisplayname.set(r.applicationdisplayname);
	record.applicationsensitivitylevel.set(r.applicationsensitivitylevel);
	record.applicationsensitivityreason.set(r.applicationsensitivityreason);
	record.applicationuid.set(r.applicationuid);
	record.campaigndescription.set(r.campaigndescription);
	record.campaignduedate.set(r.campaignduedate);
	record.campaignpriority.set(r.campaignpriority);
	record.campaignsubmissiondate.set(r.campaignsubmissiondate);
	record.campaigntitle.set(r.campaigntitle);
	record.id.set(r.id);
	record.identityactive.set(r.identityactive);
	record.identityarrivaldate.set(r.identityarrivaldate);
	record.identitydeparturedate.set(r.identitydeparturedate);
	record.identityfullname.set(r.identityfullname);
	record.identityhrcode.set(r.identityhrcode);
	record.identityinternal.set(r.identityinternal);
	record.identityjoborg.set(r.identityjoborg);
	record.identitymail.set(r.identitymail);
	record.identityuid.set(r.identityuid);
	record.isheader.set(r.isheader);
	record.parentid.set(r.parentid);
	record.permissioncode.set(r.permissioncode);
	record.permissiondescription.set(r.permissiondescription);
	record.permissiondisplayname.set(r.permissiondisplayname);
	record.permissionsensitivitylevel.set(r.permissionsensitivitylevel);
	record.permissionuid.set(r.permissionuid);
	record.reconcomment.set(r.reconcomment);
	record.reconleavedate.set(r.reconleavedate);
	record.reconnoownercode.set(r.reconnoownercode);
	record.reconuid.set(r.reconuid);
	record.remediationrecorduid.set(r.remediationrecorduid);
	record.repositorydisplayname.set(r.repositorydisplayname);
	record.repositoryuid.set(r.repositoryuid);
	record.reviewactiondate.set(r.reviewactiondate);
	record.reviewactorfullname.set(r.reviewactorfullname);
	record.reviewcomment.set(r.reviewcomment);
	record.reviewerfullname.set(r.reviewerfullname);
	record.reviewerhrcode.set(r.reviewerhrcode);
	record.reviewermail.set(r.reviewermail);
	record.reviewerorigin.set(r.reviewerorigin);
	record.revieweruid.set(r.revieweruid);
	record.reviewrecorduid.set(r.reviewrecorduid);
	record.reviewstatus.set(r.reviewstatus);
	record.rightaction.set(r.rightaction);
	record.rightlimit.set(r.rightlimit);
	record.rightperimetercode.set(r.rightperimetercode);
	record.rightperimeterdisplayname.set(r.rightperimeterdisplayname);
	record.rightperimeteruid.set(r.rightperimeteruid);
 
 	return record;	
 }
 
function createAccountJSONRecord(record) {
	var r = initJSONRecord(); 
	r.id = record.accountlogin.get();
	r.accountidentifier = record.accountidentifier.get();
	r.accountlogin = record.accountlogin.get();
	r.accountuid = record.accountuid.get();
	r.accountusername = record.accountusername.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createApplicationJSONRecord(record) {
	var r = initJSONRecord(); 

	r.id = record.applicationdisplayname.get();
	if(r.id == null)
		r.id = record.applicationcode.get();
	r.applicationcode = record.applicationcode.get();
	r.applicationdescription = record.applicationdescription.get();
	r.applicationdisplayname = record.applicationdisplayname.get();
	r.applicationsensitivitylevel = record.applicationsensitivitylevel.get();
	r.applicationsensitivityreason = record.applicationsensitivityreason.get();
	r.applicationuid = record.applicationuid.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createPermissionJSONRecord(record) {
	var r = initJSONRecord(); 

	r.id = record.permissiondisplayname.get();
	if(r.id == null)
		r.id = record.permissioncode.get();
	r.permissioncode = record.permissioncode.get();
	r.permissiondescription = record.permissiondescription.get();
	r.permissiondisplayname = record.permissiondisplayname.get();
	r.permissionsensitivitylevel = record.permissionsensitivitylevel.get();
	r.permissionuid = record.permissionuid.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createIdentityJSONRecord(record) {
	var r = initJSONRecord(); 

	r.id = record.identityfullname.get();
	if(r.id == null)
		r.id = '-';
	r.identityactive = record.identityactive.get();
	r.identityfullname = record.identityfullname.get();
	r.identityhrcode = record.identityhrcode.get();
	r.identityinternal = record.identityinternal.get();
	r.identityjoborg = record.identityjoborg.get();
	r.identitymail = record.identitymail.get();
	r.identityuid = record.identityuid.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function compare(a, b) {
	var first = a.id;	
	var second = b.id;
	
	return first.localeCompare(second);	
}

// grouped column infos
var cachedrecord = null;
var headerlist = new Array();
var /*java.util.HashSet*/ headerdedup = new java.util.HashSet();
var index = 0;
var sorted = false;

function read() {
	var record = businessview.getNextRecord();
	if(cachedrecord==null)
		cachedrecord = record;
	
	if(record == null) {
		// adding the dynamically built headers
		if(index>=headerlist.length)
			return null; // nothing left... goodbye
			
		if(!sorted)
			headerlist.sort(compare); // let's sort the headers first
		
		var jsonrecord = headerlist[index];
		fullfillRecord(cachedrecord, jsonrecord);
		index = index + 1;
		return cachedrecord;
	}		
	else {
		// crawling the content	
		
		if(dataset.groupedby.get().equals("account")) {
			var parentid = '';
			parentid = ''+record.accountlogin.get();
			record.parentid = parentid;
			
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createAccountJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		if(dataset.groupedby.get().equals("application")) {
			var parentid = '';
			parentid = record.applicationdisplayname.get();
			if(parentid == null)
				parentid = record.applicationcode.get();
			record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createApplicationJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		if(dataset.groupedby.get().equals("permission")) {
			var parentid = '';
			parentid = record.permissiondisplayname.get();
			if(parentid == null)
				parentid = record.permissioncode.get();
			record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createPermissionJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		else if(dataset.groupedby.get().equals("identity")) {
			var parentid = '';
			parentid = record.identityfullname.get();
			if(parentid == null)
				parentid = '-';
			record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createIdentityJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		
		return record; 
	}
}



// /////////////////////////////////////////////////////////////////////////

var val = -1;
function computereviewrecorduid() {
	var record = businessview.getNextRecord();
	if(record == null)
		return null;
	
	if(record.reviewrecorduid.get()==null) {
		record.reviewrecorduid = val;
		val = val - 1;
	}

	if(record.id.get()==null) {
		record.id = '-';
	}
	
	return record; 
}
