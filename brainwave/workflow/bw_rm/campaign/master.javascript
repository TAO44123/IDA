
function init() {
	// compute the deadline
	var deadline = new Date();
	deadline.setHours(23,59,0,0);
	var duration = dataset.duration.get();
	if(isNaN(duration) || duration<=0) {
		deadline = deadline.add('d', 21);
	}
	else {
		deadline = deadline.add('d', duration);
	}
	dataset.deadline = deadline;
}

function updateProgress() {
	dataset.currentProgress = dataset.currentProgress.get()+1;
}
