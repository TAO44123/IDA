
function forceDisabled() {
	var record = businessview.getNextRecord();
	if(record!=null) {
		var status = record.status.get();
		if(status != null) {
			// If the account has been removed, we force its disabled status flag to true to avoid any misunderstanding
			if("Removed".equals(status)) {
				record.accountdisabled = true;
			}			
		}
	}
	return record;
}
