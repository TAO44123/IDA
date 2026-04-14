
function setTS () {
	if ( dataset.isEmpty("ts") ) {
		var results = workflow.executeView(null, "bwcontrol_controlexecutioncurrentts");
		if ( results.length > 0 ) {
			var ts = results[0].get("uid");	
			dataset.ts.clear();
			dataset.ts.set (ts);
		}
	}
}

function controlExecution() {
	dataset.ticket_status.set("executing");
	workflow.writeControlResults(dataset.ts.get(), dataset.controlid.get());
}
