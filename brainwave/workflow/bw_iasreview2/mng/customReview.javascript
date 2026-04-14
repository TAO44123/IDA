function setDatasetCustomCampaignValues(/*String*/ reviewtype) {
  switch (reviewtype) {
  	/*case "yourcustomcampaingtype":
  	  dataset.statuspage.set("yourcustomstatuspage");
      dataset.reviewpage.set("yourcustomreviewpage");
      break;*/
    default:
      throw new java.lang.RuntimeException("unknow review type:" + dataset.reviewType.get());
      break;
  }
}

function prepareRemovedItemsCustom(/*String*/ reviewtype) {
switch (reviewtype) {
  	/*case "yourcustomcampaingtype":
  	  removedItemsViewId = "bwaccess360_applicationaccessrightsremovedforcampaign";
	  comment = "access rights removed during campaign";
	  return [removedItemsViewId, comment];*/
    default:
      throw new java.lang.RuntimeException("unknow review type:" + dataset.reviewType.get());
      break;
  }
}

function prepareRemediationTicketsCustom(/*String*/ reviewtype) {
switch (reviewtype) {
  	/*case "yourcustomcampaingtype":
  	  ticketsToRemediateViewId = "bwaccess360_repositorygroupmembersreviewcampaignsentries"; 
	  remediationItemsViewId = "bwaccess360_repositorygroupmembersreviewcampaignsentriestoremediate"; 
	  return [ticketsToRemediateViewId, remediationItemsViewId];*/
    default:
    	throw new java.lang.RuntimeException("unknow review type:" + dataset.reviewType.get());
      break;
  }
}