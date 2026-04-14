
function init() {
}

function initJSONRecord() {
	var r = {};
	r.accountablefullname = null;
	r.accountablehrcode = null;
	r.accountablemail = null;
	r.accountableuid = null;
	r.campaignclosedate = null;	
	r.campaigndescription = null;
	r.campaignduedate = null;	
	r.campaignrecorduid = null;
	r.campaignreviewtype = null;
	r.campaignsubmissiondate = null;
	r.campaigntitle = null;
	r.discr = null;		
	r.finalized_closedate = null;
	r.finalized_description = null;
	r.finalized_key = null;
	r.finalized_recorduid = null;
	r.finalized_title = null;
	r.groupedby = null;	
	r.id = null;
	r.isheader = null;	
	r.itemid = null;
	r.key = null;
	r.parentid = null;	
	r.remediationactiondate = null;
	r.remediationactorfullname = null;
	r.remediationclosedstatus = null;
	r.remediationextticket = null;
	r.remediationhyperlink = null;
	r.remediationstatus = null;
	r.remediationtype = null;
	r.reviewactiondate = null;
	r.reviewactorfullname = null;
	r.reviewcomment = null;
	r.reviewerdelegated = null;
	r.reviewerfullname = null;
	r.reviewerhrcode = null;
	r.reviewerlabel = null;
	r.reviewermail = null;
	r.reviewerorigin = null;
	r.revieweruid = null;
	r.reviewlabel = null;
	r.reviewrecorduid = null;
	r.reviewstatus = null;	
	return r;
 }
 
 function fullfillRecord(record, r) {	
	record.accountablefullname.set(r.accountablefullname);
	record.accountablehrcode.set(r.accountablehrcode);
	record.accountablemail.set(r.accountablemail);
	record.accountableuid.set(r.accountableuid);
	record.campaignclosedate.set(r.campaignclosedate);	
	record.campaigndescription.set(r.campaigndescription);
	record.campaignduedate.set(r.campaignduedate);	
	record.campaignrecorduid.set(r.campaignrecorduid);
	record.campaignreviewtype.set(r.campaignreviewtype);
	record.campaignsubmissiondate.set(r.campaignsubmissiondate);	
	record.campaigntitle.set(r.campaigntitle);
	record.finalized_closedate.set(r.finalized_closedate);
	record.finalized_description.set(r.finalized_description);
	record.finalized_key.set(r.finalized_key);
	record.finalized_recorduid.set(r.finalized_recorduid);
	record.finalized_title.set(r.finalized_title);	
	record.id.set(r.id);	
	record.isheader.set(r.isheader);
	record.key.set(r.key);
	record.parentid.set(r.parentid);
	record.remediationactiondate.set(r.remediationactiondate);
	record.remediationactorfullname.set(r.remediationactorfullname);
	record.remediationclosedstatus.set(r.remediationclosedstatus);
	record.remediationextticket.set(r.remediationextticket);
	record.remediationhyperlink.set(r.remediationhyperlink);
	record.remediationstatus.set(r.remediationstatus);
	record.remediationtype.set(r.remediationtype);
	record.reviewactiondate.set(r.reviewactiondate);
	record.reviewactorfullname.set(r.reviewactorfullname);
	record.reviewcomment.set(r.reviewcomment);
	record.reviewerdelegated.set(r.reviewerdelegated);
	record.reviewerfullname.set(r.reviewerfullname);
	record.reviewerhrcode.set(r.reviewerhrcode);
	record.reviewerlabel.set(r.reviewerlabel);
	record.reviewermail.set(r.reviewermail);
	record.reviewerorigin.set(r.reviewerorigin);
	record.revieweruid.set(r.revieweruid);
	record.reviewlabel.set(r.reviewlabel);
	record.reviewrecorduid.set(r.reviewrecorduid);
	record.reviewstatus.set(r.reviewstatus);
 	return record;	
 }

function createReviewStatusJSONRecord(record) {
	var r = initJSONRecord(); 
	
	r.id = record.reviewstatus.get();
	if(r.id == null)
		r.id = '-';	
	r.reviewstatus = record.reviewstatus.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createReviewTypeJSONRecord(record) {
	var r = initJSONRecord(); 
	
	r.id = record.campaignreviewtype.get();
	if(r.id == null)
		r.id = '-';		
	r.campaignreviewtype = record.campaignreviewtype.get();	
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createReviewerJSONRecord(record) {
	var r = initJSONRecord(); 

	r.id = record.reviewerfullname.get();
	if(r.id == null)
		r.id = '-';		
	r.revieweruid = record.revieweruid.get();	
	r.reviewerhrcode = record.reviewerhrcode.get();
	r.reviewerfullname = record.reviewerfullname.get();
	r.reviewermail = record.reviewermail.get();	
	r.reviewerdelegated = record.reviewerdelegated.get();
	r.reviewerlabel = record.reviewerlabel.get();
	r.reviewerorigin = record.reviewerorigin.get();
	r.isheader = '1';
	r.discr = 'header';
	
	return r;	
}

function createReviewnameJSONRecord(record) {
	var r = initJSONRecord(); 
	
	r.id = record.campaigntitle.get();
	if(r.id == null)
		r.id = '-';			
	r.campaigntitle = record.campaigntitle.get();
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
		
		if(dataset.groupedby.get().equals("reviewername")) {
			var parentid = '';
			parentid = ''+record.reviewerfullname.get();
			record.parentid = parentid;
			if(parentid == null)
				parentid = record.revieweruid.get();
				record.parentid = parentid;
						
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createReviewerJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		if(dataset.groupedby.get().equals("reviewstatus")) {
			var parentid = '';
			parentid = ''+record.reviewstatus.get();
			record.parentid = parentid;
			if(parentid == null)
				parentid = record.reviewrecorduid.get();
				record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createReviewStatusJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		if(dataset.groupedby.get().equals("campaignreviewtype")) {
			var parentid = '';
			parentid = ''+record.campaignreviewtype.get();
			record.parentid = parentid;
			if(parentid == null)
				parentid = record.campaignreviewtype.get();
				record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createReviewTypeJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		else if(dataset.groupedby.get().equals("campaigntitle")) {
			var parentid = '';
			parentid = ''+record.campaigntitle.get();
			record.parentid = parentid;
			if(parentid == null)
				parentid = record.reviewrecorduid.get();
				record.parentid = parentid;
	
			if(!headerdedup.contains(parentid)) {
				headerdedup.add(parentid);
				var jsonrecord = createReviewnameJSONRecord(record);
				headerlist.push(jsonrecord);
			}
		}
		
		return record; 
	}
}

