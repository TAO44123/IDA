
function read() {
	var item = businessview.getNextRecord();
	
	if (item != null ) {
		if  ( !item.isEmpty('ongoing_controlid') ) {
			item.status = "Executing";
			if ( item.isEmpty('controlcode')  ) {
				item.controldisplayname = item.available_displayname
			}
		}
		else {
			item.status = "Done";
			if ( !item.isEmpty('last_controlid') ) {
				item.lastexecutiondate = item.last_closedate
			}
			else {
				item.lastexecutiondate = dataset.defaultdate
			}
		}
	}
	return item
}
