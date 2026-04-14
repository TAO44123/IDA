var res = new Array();

function init() {
	var sumresult = dataset.sumresult.get();
	
	var /*Number*/ today = Math.floor((new Date()).getTime()/(1000*3600*24));
	var /*Number*/ start = today - 90;
	
	var params = new java.util.HashMap();
	var campaignid = dataset.campaignid.get();
	if(campaignid!=null)
		params.put("campaignid", campaignid);

	var allstart = new java.util.HashMap();
	var /*java.util.HashMap[]*/ result = businessview.executeView(null, "bwaccess360r_applicationnbremediationcreatedperday", params);
	for(var i=0;i<result.length;i++) {
		var /*java.util.HashMap*/ data = result[i];
		var submissionday = data.get("remediationsubmissionday");	
		var nbcreated = data.get("nbcreated");	
		allstart.put(''+submissionday, nbcreated);
	}

	var allclosed = new java.util.HashMap();
	result = businessview.executeView(null, "bwaccess360r_applicationnbremediationfinalizedperday", params);
	for(var i=0;i<result.length;i++) {
		var /*java.util.HashMap*/ data = result[i];
		var submissionday = data.get("actionday");	
		var nbfinalized = data.get("nbfinalized");	
		allclosed.put(''+submissionday, nbfinalized);
	}

	var /*Integer*/ sumcreated = 0;
	var /*Integer*/ sumclosed = 0;
	for(var i=start;i<=today;i++) {
		var /*String*/ date = new Date(i*1000*3600*24).toLDAPString().left(8);		
		date = date.left(4)+'/'+date.substring(4,6)+'/'+date.substring(6,8);
		var nbcreated = allstart.get(''+i);
		var nbclosed = allclosed.get(''+i);
		nbcreated==null?nbcreated = 0:nbcreated = parseInt(''+nbcreated,10);
		nbclosed==null?nbclosed = 0:nbclosed = parseInt(''+nbclosed,10);
		sumcreated += nbcreated;
		sumclosed += nbclosed;
		
		var record = {};
		record.date = date;
		record.day = i;
		record.category = "created";
		if(sumresult)
			record.nb = sumcreated;
		else
			record.nb = nbcreated;
		res.push(record);

		record = {};
		record.date = date;
		record.day = i;
		record.category = "closed";
		if(sumresult)
			record.nb = sumclosed;
		else
			record.nb = nbclosed;
		res.push(record);
	}

}

var index = 0;
function read() {
	if(index>=res.length)
		return null;
		
	var current = res[index++];
	
    var /*Attribute<String>*/ attribute = null;
    var /*DataSet*/ record = new DataSet();
    
    attribute = record.add("label", "String", false);
    attribute.set(current.date);
    attribute = record.add("day", "Number", false);
    attribute.set(current.day);
    attribute = record.add("category", "String", false);
    attribute.set(current.category);
    attribute = record.add("nb", "Number", false);
    attribute.set(current.nb);
    
    return record;
}

function dispose() {
}
