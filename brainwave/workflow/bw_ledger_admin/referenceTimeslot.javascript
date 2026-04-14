
function referenceTimeslot() {
	if (dataset.isEmpty("timeslot_reference")) {
		workflow.setReferenceTimeslot(dataset.timeslot_uid.get(), null);
	}
	else {
		workflow.setReferenceTimeslot(dataset.timeslot_uid.get(), dataset.timeslot_reference.get());
	}
}
