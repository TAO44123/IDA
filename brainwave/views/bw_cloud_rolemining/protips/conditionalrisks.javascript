
var allrisks = [];

function init() {
	
	/* Example of a conditional risk
	if ( dataset.PROTIP_RECONCILIATION_RATE.get() < 80 ) {
		allrisks.push ( "RK000_goto");
	}*/
	
	// Unconditional risks, to display all the time
	allrisks.push("RK001");
	allrisks.push("RK002");
	allrisks.push("RK003");
	allrisks.push("RK004");
	allrisks.push("RK005");
	allrisks.push("RK006");
	allrisks.push("RK007");
	
	// Risk 11
	if ( dataset.CURRENT_STATE.get() == 'readytomine' || dataset.CURRENT_STATE.get() == 'roledesigninit' || 
		dataset.CURRENT_STATE.get() == 'rolesavailable'  || dataset.CURRENT_STATE.get() == 'roleexport' ) {
		
		if ( ( !dataset.isEmpty('RISK_SCOPE_ACCOUNTS_TOTAL') && dataset.RISK_SCOPE_ACCOUNTS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_SCOPE_ORPHAN_ACCOUNTS_TOTAL.get() * 100) /  dataset.RISK_SCOPE_ACCOUNTS_TOTAL.get() ) >= 20 ) ) {
			allrisks.push("RK011_goto");
		}	
	}
	else {
		if ( ( !dataset.isEmpty('RISK_CUBE_ACCOUNTS_TOTAL') && dataset.RISK_CUBE_ACCOUNTS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_CUBE_ORPHAN_ACCOUNTS_TOTAL.get() * 100) /  dataset.RISK_CUBE_ACCOUNTS_TOTAL.get() ) >= 20 ) ) {
			allrisks.push("RK011_goto");
		}
	}
	
	// Risk 12
	if ( dataset.CURRENT_STATE.get() == 'readytomine' || dataset.CURRENT_STATE.get() == 'roledesigninit' || 
		dataset.CURRENT_STATE.get() == 'rolesavailable'  || dataset.CURRENT_STATE.get() == 'roleexport' ) {
		
		if ( ( !dataset.isEmpty('RISK_SCOPE_IDENTITIES_TOTAL') && dataset.RISK_SCOPE_IDENTITIES_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_SCOPE_CONTRACTORS_TOTAL.get() * 100) /  dataset.RISK_SCOPE_IDENTITIES_TOTAL.get() ) < 15 ) ) {
			allrisks.push("RK012_goto");
		}	
	}
	else {
		if ( ( !dataset.isEmpty('RISK_CUBE_IDENTITIES_TOTAL') && dataset.RISK_CUBE_IDENTITIES_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_CUBE_CONTRACTORS_TOTAL.get() * 100) /  dataset.RISK_CUBE_IDENTITIES_TOTAL.get() ) < 15 ) ) {
			allrisks.push("RK012_goto");
		}
	}
	
	//  Risk 10
	if ( dataset.CURRENT_STATE.get() == 'readytomine' || dataset.CURRENT_STATE.get() == 'roledesigninit' || 
		dataset.CURRENT_STATE.get() == 'rolesavailable'  || dataset.CURRENT_STATE.get() == 'roleexport' ) {
		
		if ( ( !dataset.isEmpty('RISK_SCOPE_PERMISSIONS_TOTAL') && dataset.RISK_SCOPE_PERMISSIONS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_SCOPE_PERMISSIONS_NODOC_TOTAL.get() * 100) /  dataset.RISK_SCOPE_PERMISSIONS_TOTAL.get() ) >= 20 ) ) {
			allrisks.push("RK010_goto");
		}	
	}
	else {
		if ( ( !dataset.isEmpty('RISK_CUBE_PERMISSIONS_TOTAL') && dataset.RISK_CUBE_PERMISSIONS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_CUBE_PERMISSIONS_NODOC_TOTAL.get() * 100) /  dataset.RISK_CUBE_PERMISSIONS_TOTAL.get() ) >= 20 ) ) {
			allrisks.push("RK010_goto");
		}
	}
	
	//  Risk 9
	if ( dataset.CURRENT_STATE.get() == 'readytomine' || dataset.CURRENT_STATE.get() == 'roledesigninit' || 
		dataset.CURRENT_STATE.get() == 'rolesavailable'  || dataset.CURRENT_STATE.get() == 'roleexport' ) {
		
		if ( ( !dataset.isEmpty('RISK_SCOPE_ORGS_TOTAL') && dataset.RISK_SCOPE_ORGS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_SCOPE_ORGS_NOMGR_TOTAL.get() * 100) /  dataset.RISK_SCOPE_ORGS_TOTAL.get() ) >= 3 ) ) {
			allrisks.push("RK009_goto");
		}	
	}
	else {
		if ( ( !dataset.isEmpty('RISK_CUBE_ORGS_TOTAL') && dataset.RISK_CUBE_ORGS_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_CUBE_ORGS_NOMGR_TOTAL.get() * 100) /  dataset.RISK_CUBE_ORGS_TOTAL.get() ) >= 3 ) ) {
			allrisks.push("RK009_goto");
		}
	}
	
	//  Risk 8
	if ( !(dataset.CURRENT_STATE.get() == 'readytomine' || dataset.CURRENT_STATE.get() == 'roledesigninit' || 
		dataset.CURRENT_STATE.get() == 'rolesavailable'  || dataset.CURRENT_STATE.get() == 'roleexport') ) {
		
		if ( ( !dataset.isEmpty('RISK_CUBE_IDENTITIES_TOTAL') && dataset.RISK_CUBE_IDENTITIES_TOTAL.get() != 0 ) && (  ( ( dataset.RISK_CUBE_IDENTITIES_NOORG_TOTAL.get() * 100) /  dataset.RISK_CUBE_IDENTITIES_TOTAL.get() ) >= 3 ) ) {
			allrisks.push("RK008_goto");
		}
	}
	
	
	
	
	
}

function read() {
	
	var currentRisk = allrisks.pop();
	
	if ( currentRisk != null ) {
		var ds = new DataSet();
		ds.riskcode = currentRisk;
		return ds;
	}
	else {
		return null;
	}
}
