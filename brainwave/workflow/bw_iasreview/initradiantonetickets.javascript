/**
 * IDDM API calls to revoke accounts
 * 
 * @return 
 */

import "../bw_servicenow/base64.javascript" 
import "../bw_servicenow/restapi.javascript"
 /**
 * accountsRemediation
 * 
 * @return 
 */
function accountsRemediation() {
	var /*java.util.HashMap*/ remediationrecorduidcache = new java.util.HashMap(); // keep a cache of remediationrecorduids
	var payload = new Array();
	for (var index = 0; index < dataset.accountidentifier.length; index++) {
		var dn = dataset.accountidentifier.get(index);
		var repositoryfamily = dataset.accountrepositoryfamily.get(index);
		var repositoryinstancecode = dataset.accountrepositoryinstancecode.get(index);
		if(repositoryfamily!=null && "AD".equals(repositoryfamily)) {
			payload.push(disableADaccount(dn));	
		}
		else {
			payload.push(disableLDAPaccount(dn, repositoryfamily, repositoryinstancecode));	
		}

		var remediationrecorduid = dataset.remediationrecorduid.get(index);
		remediationrecorduidcache.put(dn, ''+remediationrecorduid);

	}
	// send revocation order
	var res = sendAccountOrders(payload);
	
	// handle the answer
	// it is in the form of
	// {
	//    "failed": [],
	//    "warning": [],
	//    "updated": [
	//      "CN=alice,CN=Users,DC=ldapserver,DC=brainwave,DC=dev",
	//      "CN=frank,CN=Users,DC=ldapserver,DC=brainwave,DC=dev",
	//      "CN=jane,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//    ]
	// }
	dataset.success_remediationrecorduid.clear();
	dataset.failed_remediationrecorduid.clear();
	dataset.warning_remediationrecorduid.clear();
	if(res!=null) {
		// retrieve failed entries
		if(res.hasOwnProperty("failed")) {
			var /*Array*/ failedarray = res.failed;
			for(var i=0;i<failedarray.length;i++) {
				var identifier = failedarray[i];
				var sremediationrecorduid = remediationrecorduidcache.get(identifier);
				if(sremediationrecorduid!=null) {
					var remediationrecorduid = parseInt(sremediationrecorduid, 10);
					dataset.failed_remediationrecorduid.add(remediationrecorduid);
				}
			}		
		}	

		// retrieve warning entries
		if(res.hasOwnProperty("warning")) {
		var /*Array*/ warningarray = res.warning;
			for(var i=0;i<warningarray.length;i++) {
				var identifier = warningarray[i];
				var sremediationrecorduid = remediationrecorduidcache.get(identifier);
				if(sremediationrecorduid!=null) {
					var remediationrecorduid = parseInt(sremediationrecorduid, 10);
					dataset.warning_remediationrecorduid.add(remediationrecorduid);
				}
			}
		}		
		
		// retrieve succeeded entries
		if(res.hasOwnProperty("updated")) {
			var /*Array*/ successarray = res.updated;
			for(var i=0;i<successarray.length;i++) {
				var identifier = successarray[i];
				var sremediationrecorduid = remediationrecorduidcache.get(identifier);
				if(sremediationrecorduid!=null) {
					var remediationrecorduid = parseInt(sremediationrecorduid, 10);
					dataset.success_remediationrecorduid.add(remediationrecorduid);
				}
			}
		}		
	}
	else { // everything failed!
		for(var i=0;i<dataset.remediationrecorduid.length;i++) {
			var remediationrecorduid = dataset.remediationrecorduid.get(index);
			dataset.failed_remediationrecorduid.add(remediationrecorduid);
		}		
	}
}

/**
 * IDDM API calls to revoke group memberships
 * 
 * @return 
 */
function groupmembershipsRemediation() {
	var /*java.util.HashMap*/ remediationrecorduidcache = new java.util.HashMap(); // keep a cache of remediationrecorduids
	var payload = new Array();
	
	// Build payload grouped by group.
	var /*String*/ lastgroup = "";
	var /*String*/ lastrepositoryfamily = "";
	var accountlist = new Array();
	for (var index = 0; index < dataset.accountidentifier.length; index++) {
		var accountdn = dataset.accountidentifier.get(index);
		var groupdn = dataset.groupcode.get(index);
		var repositoryfamily = dataset.grouprepositoryfamily.get(index);

		var remediationrecorduid = dataset.remediationrecorduid.get(index);
		remediationrecorduidcache.put(groupdn+'$$'+accountdn, ''+remediationrecorduid);

		// --- New group bucket
		if(!groupdn.equals(lastgroup)) {
			// process the list
			if(accountlist.length>0) {
				payload.push(buildGroupmembershipRevoke(lastgroup, lastrepositoryfamily, accountlist));
			}
			// create a new list
			accountlist = new Array();
			accountlist.push(accountdn);
			lastgroup = groupdn;
			lastrepositoryfamily = (repositoryfamily!=null && "AD".equals(repositoryfamily))?"activedirectory":"ldap";
		}
		// --- Current group bucket
		else {
			accountlist.push(accountdn);
		}
	}
	// process the remaining entries
	if(accountlist.length>0) {
		payload.push(buildGroupmembershipRevoke(lastgroup, lastrepositoryfamily, accountlist));
	}

	// send revocation order
	var res = sendGroupOrders(payload);

	// handle the answer
	// it is in the form of
	// {
	//     "failed": {
	//         "CN=Finance,CN=Users,DC=ldapserver,DC=brainwave,DC=dev": [
	//             "CN=frank,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//         ]
	//     },
	//     "warning": {
	//         "CN=Finance,CN=Users,DC=ldapserver,DC=brainwave,DC=dev": [
	//             "CN=frank,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//         ]
	//     },
	//     "updated": {
	//         "CN=Finance,CN=Users,DC=ldapserver,DC=brainwave,DC=dev": [
	//             "CN=alice,CN=Users,DC=ldapserver,DC=brainwave,DC=dev",
	//             "CN=jane,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//         ],
	//         "CN=IT,CN=Users,DC=ldapserver,DC=brainwave,DC=dev": [
	//             "CN=alice,CN=Users,DC=ldapserver,DC=brainwave,DC=dev",
	//             "CN=jane,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//         ],
	//         "CN=Marketing,CN=Users,DC=ldapserver,DC=brainwave,DC=dev": [
	//             "CN=alice,CN=Users,DC=ldapserver,DC=brainwave,DC=dev",
	//             "CN=jane,CN=Users,DC=ldapserver,DC=brainwave,DC=dev"
	//         ]
	//     }
	// }	
	dataset.success_remediationrecorduid.clear();
	dataset.failed_remediationrecorduid.clear();
	dataset.warning_remediationrecorduid.clear();
	if(res!=null) {
		// retrieve failed entries
		if(res.hasOwnProperty("failed")) {
			var /*Array*/ failedarray = res.failed;
			for(var attr in failedarray) {
				var group_identifier = attr;
				var /*Array*/ a = failedarray[group_identifier];
				for(var i=0;i<a.length;i++) {
					var account_identifier = a[i];
					var key = group_identifier+'$$'+account_identifier;
					var sremediationrecorduid = remediationrecorduidcache.get(key);
					if(sremediationrecorduid!=null) {
						var remediationrecorduid = parseInt(sremediationrecorduid, 10);
						dataset.failed_remediationrecorduid.add(remediationrecorduid);
					}
				}
			}
		}		

		// retrieve warning entries
		if(res.hasOwnProperty("warning")) {
			var /*Array*/ warningarray = res.warning;
			for(var attr in warningarray) {
				var group_identifier = attr;
				var /*Array*/ a = warningarray[group_identifier];
				for(var i=0;i<a.length;i++) {
					var account_identifier = a[i];
					var key = group_identifier+'$$'+account_identifier;
					var sremediationrecorduid = remediationrecorduidcache.get(key);
					if(sremediationrecorduid!=null) {
						var remediationrecorduid = parseInt(sremediationrecorduid, 10);
						dataset.warning_remediationrecorduid.add(remediationrecorduid);
					}
				}
			}
		}		
		
		// retrieve succeeded entries
		if(res.hasOwnProperty("updated")) {
			var /*Array*/ successarray = res.updated;
			for(var attr in successarray) {
				var group_identifier = attr;
				var /*Array*/ a = successarray[group_identifier];
				for(var i=0;i<a.length;i++) {
					var account_identifier = a[i];
					var key = group_identifier+'$$'+account_identifier;
					var sremediationrecorduid = remediationrecorduidcache.get(key);
					if(sremediationrecorduid!=null) {
						var remediationrecorduid = parseInt(sremediationrecorduid, 10);
						dataset.success_remediationrecorduid.add(remediationrecorduid);
					}
				}
			}
		}		
	}
	else { // everything failed!
		for(var i=0;i<dataset.remediationrecorduid.length;i++) {
			var remediationrecorduid = dataset.remediationrecorduid.get(index);
			dataset.failed_remediationrecorduid.add(remediationrecorduid);
		}		
	}
}

function buildGroupmembershipRevoke(/*String*/ groupcode, /*String*/ lastrepositoryfamily, /*Array*/ accountlist) {
	var /*Array*/ members = new Array();
	for(var i=0;i<accountlist.length;i++) {
		var entry = {
			dn: accountlist[i]
		};
		members.push(entry);
	}
	
	var payload = {
		action: "remove_members",
		backend_type: lastrepositoryfamily,
		dn: groupcode,
		members: members		
	};
	
	return payload;
}

function extractor_api_url( /*String */part ) {	
	return config.bwdsm_extractor_url +"/"+ part; 
}

/**
 * disableADaccount
 * 
 * @param identifier 
 * @return 
 */
function disableADaccount(/*String*/ identifier) {
	var payload = { 
		action: "disable",
		backend_type: "activedirectory",
		dn: identifier
	};	
	return payload;
}

/**
 * disableLDAPaccount
 * 
 * @param identifier 
 * @param backendtype 
 * @param repositoryinstancecode 
 * @return 
 */
function disableLDAPaccount(/*String*/ identifier, /*String*/ backendtype, /* String*/ repositoryinstancecode) {
	var keypair = getAttrKeyPair(repositoryinstancecode);
	var payload = { 
		attributes: [
			{
				name: keypair.key,
				value: keypair.val				
			}
		],
		action: "disable",
		backend_type: backendtype!=null?backendtype:"ldap",
		dn: identifier
	};	
	return payload;
}


var /* java.util.HashMap */ cache = new java.util.HashMap();
function getAttrKeyPair(repositoryinstancecode) {
	// retreive the key/pair from the cache
	var /* java.util.HashMap */ result = cache.get(repositoryinstancecode);
	
	if(result == null) {
		// add the key/pair to the cache if needed
		var /* java.util.HashMap */ params = new java.util.HashMap();
		params.put("itsmcode", repositoryinstancecode);
		var results = workflow.executeView(null, "bwiasr_itsms", params);
		var key = "";
		var val = "";
		if(results!=null && results.length>0) {
			var /* java.util.HashMap */ entry = results[0];
			key = entry.get("bwr_remediation_itsmdef_string4");
			val = entry.get("bwr_remediation_itsmdef_string5");
		}
		result = new java.util.HashMap();
		result.put("key", key);
		result.put("val", val);
		cache.put(repositoryinstancecode, result);
	}	
		
	// return the key/pair
	var e = {
		key: result.get("key"),
		val: result.get("val")
	};
	return e;
}

function sendAccountOrders(payload) {
	print("sendAccountOrders: payload="+payload);
	
	var /*String*/ domain = config.bwdsm_extractor_url;
	if(domain==null) {
		print("Error: config.bwdsm_extractor_url_IS_EMPTY");
		return null;
	}
	else if (!domain.endsWith('/')) {
		domain = domain + '/';
	}
	
	setHttpDebug();
	var result = httpPUT(config.bwdsm_extractor_url, "anonymous", "password", "/write_back/iddm/accounts", payload)
	print("result="+result);
	return result; 
	
}

function sendGroupOrders(payload) {
	print("sendGroupOrders: payload="+payload);
	
	var /*String*/ domain = config.bwdsm_extractor_url;
	if(domain==null) {
		print("Error: config.bwdsm_extractor_url_IS_EMPTY");
		return null;
	}
	else if (!domain.endsWith('/')) {
		domain = domain + '/';
	}
	
	setHttpDebug();
	var result = httpPUT(config.bwdsm_extractor_url, "anonymous", "password", "/write_back/iddm/groups", payload)
	print("result="+result);
	return result; 
	
}
