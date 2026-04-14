
function entriesReviewed() {
	
	var campaignid = dataset.campaignid.get();
	var currentreviewer = dataset.currentreviewer.get();
	var reviewtickets = dataset.reviewtickets;
	var forcemarkentry = dataset.forcemarkentry.get();
	
	var /*Array*/ signedoffItems = new Array(); 
	var /*Array*/ blocRecorduids = new Array(); 
	if (reviewtickets.length == 0){
		signedoffItems = workflow.executeView( null, 'bwa_entriesreviewedsofar' , 
			{ campaignid: campaignid, currentreviewer: currentreviewer, reviewtickets: null , forcemarkentry: forcemarkentry } );	
	}
	else{	
	    for (var i=0;i<reviewtickets.length;i++) {
			blocRecorduids.push(reviewtickets.get(i));
			
			if (((i % 990 === 0) && (i > 0)) || (i == reviewtickets.length-1)) {
				print("blocRecorduids size: " + blocRecorduids.length);	
				var /*Array*/   blocItems = workflow.executeView( null, 'bwa_entriesreviewedsofar' , 
		  			{ campaignid: campaignid, currentreviewer: currentreviewer, reviewtickets: blocRecorduids, forcemarkentry: forcemarkentry } );
		   		signedoffItems=signedoffItems.concat(blocItems);
		   		blocRecorduids = new Array(); 
		   	}
		} 	
	}
	print("signedoffItems size: " + signedoffItems.length);			
	signedoffItems.forEach(  function( row ) {
		dataset.ticketrecorduids.add(row.recorduid);
	} ) ;		
}
