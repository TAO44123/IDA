
var /*String*/ lastCampaignTimeslotUid = null; 
var foundRecord = false ;  
var firstRecord = null; // for previous timeslot 

function onInit() {
	
	// find last campaign timeslot
	var /*Array*/ results;
	// try last campaign instance timeslot
    var /*String*/ reviewdefmduid = dataset.def_uid.get();
    results = businessview.executeView(null, "bwr_campaigntimeslots",  { def_uid: reviewdefmduid } ); 
    if (results.length > 0 ) {
    	lastCampaignTimeslotUid =  results[0].get("timeslotuid");
    } 
}

function onRead() {
	var record; 
	//rint("lastCampaignTimeslotUid="+lastCampaignTimeslotUid);
	// case 1: campaign has a previous instance timeslot, check that it exists 
    if (lastCampaignTimeslotUid !== null) { 
    	if (!foundRecord){
    		// read until we find a matching record
    		record = businessview.getNextRecord();	
	    	while (record !== null && !lastCampaignTimeslotUid.equals(record.get("timeslotuid"))){	
	    	  record = businessview.getNextRecord();	
	    	}
	    	foundRecord = true;
	    	return record; 
    	} 
    	else {
    	  // already found, stop
    	  return null; 	
    	}
    }
    // case 2: campaign does not have a previous timeslot
    //  fallback to previous ref timeslot or previous timeslot if none 
    else {
    	if (!foundRecord){
    		// read until we find a matching record that has a reference or exit 
    		record = businessview.getNextRecord();	
    		firstRecord = record; 
	    	while (record !== null && record.isEmpty("reference") ){
	    	  record = businessview.getNextRecord();	
	    	}
	    	foundRecord = true;
	    	// either we have a ref record, or we didn't find any, then return previousTimeslot 
	    	if (record !== null)
	    	  return record ;	
	    	else 
	    	  return firstRecord; 	
    	} 
    	else 
    	  // already found, stop
    	  return null; 	
    }  
    return null; 
}



