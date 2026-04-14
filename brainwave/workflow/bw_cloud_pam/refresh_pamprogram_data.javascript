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

function executeControls() {
	var ts = dataset.ts.get();
	workflow.writeDynamicRuleResults(ts, "bwcpam", null, null);
	workflow.writeControlResults(ts, "PAM_ACCOUNT01_orphans" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT02_leavers" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT03_orphans_passnoexp" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT04_service_passnoexp" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT05_user_passnoexp" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT06_user_passcantchange" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT07_passnotreq" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT08_contractors_noexp" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT09_user_oldpass" );
	workflow.writeControlResults(ts, "PAM_ACCOUNT10_unused" );

}

