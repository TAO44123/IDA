
function initBounds() {
	
		var currentDate = new Date();
		currentDate.setHours(23, 59, 59);
		dataset.highdate.set(currentDate);

		var offset = dataset.NBDAYSBACK.get();
		offset = offset+1;
		var lowdate = currentDate.add('d', -offset);
		dataset.lowdate.set(lowdate);
}
