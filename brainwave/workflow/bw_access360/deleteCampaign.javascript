function decrementStickyReviewUsageCounter() {
	//  we decrement sticky timeslot ref counter if the campaign is not already closed ( for example "pause") 
	if (!dataset.isEmpty('stickyTimeslot') && dataset.campaignstatus.get() !== "closed") {
		print("StickyReview>Decrement after deleting:"+dataset.stickyTimeslot.get());
		workflow.decrementReviewCounter(dataset.stickyTimeslot.get());
	}
}