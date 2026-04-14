
import "../collector/JSON.javascript" ;

function vaultSecretExists(/*String*/secret_key ){
	var result = businessview.sendHttpRequest("GET", config.bwdsm_vault_url +"/vault/"+secret_key , null, null);
	if ( result["message"] != null && result["message"].indexOf("not_found") >= 0 ){
		return false;
	}
	else {
		return true;
	}
}


function read() {
	var current = businessview.getNextRecord();
	while ( current != null ) {
		if (current.key == "bw_datasource_def" ) {
			
			if (!current.isEmpty("details")) {
				var details = JSON.parse(current.details);
				var secret_found = false;
				for (key in details) {
					if (details[key]!=null && details[key].toString().indexOf("$(") == 0 ) {
						current.secret_name = details[key].slice(2).slice(0, -1);
						current.secret_key = key;
						current.secret_invault = vaultSecretExists ( details[key].slice(2).slice(0, -1) );
						secret_found = true;
						break;
					}
				}
				if (secret_found) {
					break;
				}
			}
		}
		current = businessview.getNextRecord();
	}
	return current;
}
