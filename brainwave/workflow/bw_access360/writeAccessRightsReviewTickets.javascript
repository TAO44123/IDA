
function prepareRecorduid() {
	dataset.ticketreviewrecorduid.clear();
	if(dataset.isEmpty('ticketreviewitem')) {
		return;	
	}
	
	var /*String*/ campaignid = dataset.ticketreviewitem.get();
	campaignid = campaignid.substring(0, campaignid.indexOf('-'));
	dataset.loadedcampaignid.set(campaignid);
	
	for(var i=0;i<dataset.ticketreviewitem.length;i++) {
		var /*String*/ item = dataset.ticketreviewitem.get(i);
		var /*String*/ recorduid = item.substring(item.indexOf('-')+1);
		dataset.ticketreviewrecorduid.add(parseInt(recorduid, 10));
	}
}
