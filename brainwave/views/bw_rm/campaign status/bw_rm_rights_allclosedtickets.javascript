var /*Array*/ results = null;
var /*Integer*/ current = 0;
var /*Array*/ timeslots = new Array();
var /*Integer*/ t = 0;

var /*java.util.HashMap*/ params = new java.util.HashMap();

function init() {
	params.put("code", dataset.code.get());	
	var r = businessview.executeView(null, "bw_rm_prevcampaigninstances", params);
	for(var i=0;i<r.length;i++) {
	    var /*java.util.Map*/ item = r[i];
	    tsuid = item.get("timeslotuid");
	    timeslots.push(tsuid);
	}
}

function read() {
	if(results == null) {
		// toute premiere fois	
		if(t>=timeslots.length) // il n'y a aucune timeslot, on sort
			return null;
		
		// on récupère le timeslot
		var timeslot = timeslots[t++];
		
		// on initialise la vue
		results = businessview.executeView(timeslot, "bw_rm_rights_closedremediationtickets", params);
		current = 0;
	}


	while(current>=results.length) {
		// on passe au timeslot suivant si besoin	

		if(t>=timeslots.length) // il n'y a plus de timeslots
			return null;
		
		// on récupère le timeslot
		var timeslot = timeslots[t++];
		
		// on initialise la vue
		results = businessview.executeView(timeslot, "bw_rm_rights_closedremediationtickets", params);
		current = 0;
	}


    var /*java.util.Map*/ item = results[current++];

    var /*DataSet*/ record = new DataSet();
	addAttribute(record, "reviewstatus", item.get("reviewstatus"));
	addAttribute(record, "reviewcomment", item.get("reviewcomment"));
	addAttribute(record, "reviewbyname", item.get("reviewbyname"));
	addAttribute(record, "requestedon", item.get("requestedon"));
	addAttribute(record, "campaigninstancetitle", item.get("campaigninstancetitle"));
	addAttribute(record, "accountlogin", item.get("accountlogin"));
	addAttribute(record, "accountusername", item.get("accountusername"));
	addAttribute(record, "repositorydisplayname", item.get("repositorydisplayname"));
	addAttribute(record, "permissioncode", item.get("permissioncode"));
	addAttribute(record, "permissiondisplayname", item.get("permissiondisplayname"));
	addAttribute(record, "applicationcode", item.get("applicationcode"));
	addAttribute(record, "applicationdisplayname", item.get("applicationdisplayname"));

	addAttribute(record, "remediationsubmissiondate", item.get("remediationsubmissiondate"));
	addAttribute(record, "remediationclosedate", item.get("remediationclosedate"));
	addAttribute(record, "remediationstatus", item.get("remediationstatus"));
	addAttribute(record, "remediationexternalreference", item.get("remediationexternalreference"));

    return record;
}

function dispose() {
}

function addAttribute(record, name, value) {
    var /*Attribute<String>*/ attribute = record.add(name, "String", false);
    attribute.set(value);
    return attribute;
}