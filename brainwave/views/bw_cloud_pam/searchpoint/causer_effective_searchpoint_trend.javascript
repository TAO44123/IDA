
var bwa_accountanalytics_nbrisks = {}
var bwa_accountanalytics_riskrank = {}
var bw_pam_usermetrics_nb_safes = {}
var bw_pam_usermetrics_nb_safes_manage = {}
var bw_pam_usermetrics_nb_safes_use = {}
var bwa_accountanalytics_nbdirectgroup = {}
var bw_pam_usermetrics_nb_safes_cpm_inactive = {}
var bw_pam_usermetrics_nb_secrets = {}
var bw_pam_usermetrics_nb_secrets_cpm_inactive = {}


function init() {
	var /*Array*/ result = businessview.executeView(dataset.reftimeslotuid.get(), "br_causer_effective_searchpoint", null);	
	for(var i=0;i<result.length;i++) {
		var /*java.util.Map*/ data = result[i];
		bwa_accountanalytics_nbrisks [data.get("uid")] = data.get("bwa_accountanalytics_nbrisks")
		bwa_accountanalytics_riskrank [data.get("uid")] = data.get("bwa_accountanalytics_riskrank")
		bw_pam_usermetrics_nb_safes [data.get("uid")] = data.get("bw_pam_usermetrics_nb_safes")
		bw_pam_usermetrics_nb_safes_manage [data.get("uid")] = data.get("bw_pam_usermetrics_nb_safes_manage")
		bw_pam_usermetrics_nb_safes_use [data.get("uid")] = data.get("bw_pam_usermetrics_nb_safes_use")
		bwa_accountanalytics_nbdirectgroup [data.get("uid")] = data.get("bwa_accountanalytics_nbdirectgroup")
		bw_pam_usermetrics_nb_safes_cpm_inactive [data.get("uid")] = data.get("bw_pam_usermetrics_nb_safes_cpm_inactive")
		bw_pam_usermetrics_nb_secrets [data.get("uid")] = data.get("bw_pam_usermetrics_nb_secrets")
		bw_pam_usermetrics_nb_secrets_cpm_inactive [data.get("uid")] = data.get("bw_pam_usermetrics_nb_secrets_cpm_inactive")								
	}
}

function read() {
	var current = businessview.getNextRecord();
	if ( current == null ) {
		return null;
	}

	if ( current.uid in bwa_accountanalytics_nbrisks && current.isEmpty('bwa_accountanalytics_nbrisks') == false ) {		
		current.trend_bwa_accountanalytics_nbrisks = current.bwa_accountanalytics_nbrisks - bwa_accountanalytics_nbrisks[current.uid]
		}
		else {
		current.trend_bwa_accountanalytics_nbrisks = current.bwa_accountanalytics_nbrisks
	}

	if ( current.uid in bw_pam_usermetrics_nb_safes && current.isEmpty('bw_pam_usermetrics_nb_safes') == false ) {	
		current.trend_bwa_accountanalytics_riskrank = current.bwa_accountanalytics_riskrank - bwa_accountanalytics_riskrank[current.uid]
		}
		else {
		current.trend_bwa_accountanalytics_riskrank = current.bwa_accountanalytics_riskrank
	}


	if ( current.uid in bw_pam_usermetrics_nb_safes && current.isEmpty('bw_pam_usermetrics_nb_safes') == false ) {	
		current.trend_bw_pam_usermetrics_nb_safes = current.bw_pam_usermetrics_nb_safes - bw_pam_usermetrics_nb_safes[current.uid]
		}
		else {
		current.trend_bw_pam_usermetrics_nb_safes = current.bw_pam_usermetrics_nb_safes
	}
	
	if ( current.uid in bw_pam_usermetrics_nb_safes_manage && current.isEmpty('bw_pam_usermetrics_nb_safes_manage') == false ) {
		current.trend_bw_pam_usermetrics_nb_safes_manage = current.bw_pam_usermetrics_nb_safes_manage - bw_pam_usermetrics_nb_safes_manage[current.uid]
		}
		else {
		current.trend_bw_pam_usermetrics_nb_safes_manage = current.bw_pam_usermetrics_nb_safes_manage
	}

	
	if ( current.uid in bw_pam_usermetrics_nb_safes_use && current.isEmpty('bw_pam_usermetrics_nb_safes_use') == false ) {		
		current.trend_bw_pam_usermetrics_nb_safes_use = current.bw_pam_usermetrics_nb_safes_use - bw_pam_usermetrics_nb_safes_use[current.uid]
		}
		else {
		current.trend_bw_pam_usermetrics_nb_safes_use = current.bw_pam_usermetrics_nb_safes_use
	}

	if ( current.uid in bwa_accountanalytics_nbdirectgroup && current.isEmpty('bwa_accountanalytics_nbdirectgroup') == false ) {
		current.trend_bwa_accountanalytics_nbdirectgroup = current.bwa_accountanalytics_nbdirectgroup - bwa_accountanalytics_nbdirectgroup[current.uid]
		}
		else {
		current.trend_bwa_accountanalytics_nbdirectgroup = current.bwa_accountanalytics_nbdirectgroup
	}
	
	if ( current.uid in bw_pam_usermetrics_nb_safes_cpm_inactive && current.isEmpty('bw_pam_usermetrics_nb_safes_cpm_inactive') == false ) {
		current.trend_bw_pam_usermetrics_nb_safes_cpm_inactive = current.bw_pam_usermetrics_nb_safes_cpm_inactive - bw_pam_usermetrics_nb_safes_cpm_inactive[current.uid]
		}
		else {
		current.trend_bw_pam_usermetrics_nb_safes_cpm_inactive = current.bw_pam_usermetrics_nb_safes_cpm_inactive
	}
	
	if ( current.uid in bw_pam_usermetrics_nb_secrets && current.isEmpty('bw_pam_usermetrics_nb_secrets') == false ) {
		current.trend_bw_pam_usermetrics_nb_secrets = current.bw_pam_usermetrics_nb_secrets - bw_pam_usermetrics_nb_secrets[current.uid]
		}
		else {
		current.trend_bw_pam_usermetrics_nb_secrets = current.bw_pam_usermetrics_nb_secrets
	}
	
	if ( current.uid in bw_pam_usermetrics_nb_secrets_cpm_inactive && current.isEmpty('bw_pam_usermetrics_nb_secrets_cpm_inactive') == false ) {
		current.trend_bw_pam_usermetrics_nb_secrets_cpm_inactive = current.bw_pam_usermetrics_nb_secrets_cpm_inactive - bw_pam_usermetrics_nb_secrets_cpm_inactive[current.uid]
		}
		else {
			current.trend_bw_pam_usermetrics_nb_secrets_cpm_inactive = current.bw_pam_usermetrics_nb_secrets_cpm_inactive
	}								
	return current;
}
