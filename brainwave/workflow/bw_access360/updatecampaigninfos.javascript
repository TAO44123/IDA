function incrementStickyCampaignUsageCounter() {

	if (!dataset.isEmpty('stickyTimeslot') && dataset.incrementCounter.get()) {
		print("StickyReview>Increment after revert to active:"+dataset.stickyTimeslot.get());
		workflow.incrementReviewCounter(dataset.stickyTimeslot.get());
	}

}

/*

function updateCampaignInfoInTimeslot(){
  var values = new java.util.HashMap();
  values.put("action","C"); // create or update
  values.put( "schema","bwr_campaigninstance");  // name of the metadata  
  values.put( "subkey", dataset.campaignid.get().toString());
  values.put("master", dataset.parentmduid.get());
  // values
  values.put( "integer1", dataset._num.get());
  values.put( "integer2", dataset.campaignid.get());
  values.put( "integer3", dataset._extradays.get());
  values.put( "string3", dataset.currentstatus.get());
  values.put( "details", dataset.info.get());
  workflow.executeMetadata(dataset.startTimeslot.get(), values)	
}

function dumpWorkflow() {
  var ts = workflow.timeslot;
  var wk = workflow.path;
  print("Workflow UCI:"+ wk+ " TS="+ts);	
}

*/