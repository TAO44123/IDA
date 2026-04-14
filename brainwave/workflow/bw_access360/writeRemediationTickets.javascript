
function init() {
	var /*String*/ timeslotuid = workflow.timeslot;
	var /*Number*/ len = dataset.status.length;
	
	dataset.timeslot.clear();
	for(var i=0;i<len;i++) {
		dataset.timeslot.add(timeslotuid);
	}
}
