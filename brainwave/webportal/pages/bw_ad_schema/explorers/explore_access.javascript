

function groupPemissions ( ){
	
	// Get input 
	var adObjectUid = dataset.adObjectUid.get();
	var timeslot = dataset.timeslot.get();
	
	// Prepare output
	dataset.account_uid.clear();
	dataset.login.clear();
	dataset.r.clear();
	dataset.w.clear();
	dataset.l.clear();
	dataset.a.clear();
	dataset.d.clear();
	dataset.p.clear();
	
	// recon data
	dataset.iduid.clear();
	dataset.idname.clear();
	dataset.orguid.clear();
	dataset.orgname.clear();
	
	// Call a view
	var params = new java.util.HashMap();
 	params.put("uid", adObjectUid );
 	var res = connector.executeView( timeslot , "adacl_accounts" , params);
 	
 	var hashtbl = {};
 	
 	for ( i=0 ; i < res.length ; i ++){
 		var key = res[i].get("obj_uid") +"*"+ res[i].get("account_uid");
 		
 		if (!(key in hashtbl) ){
 			var contents = {};
 			contents["account_uid"] = res[i].get("account_uid");
 			contents["account_recorduid"] = res[i].get("account_recorduid");
	 		contents["login"] = res[i].get("domain_displayname") + " \\ " + res[i].get("account_login");
	 		contents["action"] = res[i].get("right_action");
	 		hashtbl[key] = contents;	 		
 		}
 		else {
 			hashtbl[key]["action"] = hashtbl[key]["action"] + res[i].get("right_action");
 		}
 	}
 	
 	for ( res in hashtbl ){
 		
 		dataset.account_uid.add ( hashtbl[res]["account_uid"] ); 

 		dataset.login.add (hashtbl[res]["login"]);
 		 		
 		dataset.r.add ( +(hashtbl[res]["action"].indexOf("R")>=0) );
 		hashtbl[res]["action"] = hashtbl[res]["action"].replace ( /R/gi,"");
 		
 		dataset.w.add ( +(hashtbl[res]["action"].indexOf("W")>=0) );
 		hashtbl[res]["action"] = hashtbl[res]["action"].replace ( /W/gi,"");
 		
 		dataset.l.add ( +(hashtbl[res]["action"].indexOf("L")>=0) );
 		hashtbl[res]["action"] = hashtbl[res]["action"].replace ( /L/gi,"");

 		dataset.a.add ( +(hashtbl[res]["action"].indexOf("A")>=0) );
 		hashtbl[res]["action"] = hashtbl[res]["action"].replace ( /A/gi,"");
 		
 		dataset.d.add ( +(hashtbl[res]["action"].indexOf("D")>=0) );
 		hashtbl[res]["action"] = hashtbl[res]["action"].replace ( /D/gi,"");
 		
 		hashtbl[res]["action"] = hashtbl[res]["action"].trim();
 		dataset.p.add ( +(hashtbl[res]["action"].length>0) );
 		
 		// Find recon data
 		var params = new java.util.HashMap();
 		params.put("recorduid", hashtbl[res]["account_recorduid"] );
 		var reconres = connector.executeView( timeslot , "identity_byaccount" , params);
 		
 		
 		
 		if ( reconres.length > 0 ) {
 			dataset.iduid.add	( reconres[0].get("id_uid"));
			dataset.idname.add	( reconres[0].get("id_fullname"));
			dataset.orguid.add  ( reconres[0].get("org_uid"));
			dataset.orgname.add	( reconres[0].get("org_shortname"));
 		}
 		else {
 			dataset.iduid.add	( "" );
			dataset.idname.add	( "" );
			dataset.orguid.add  ( "" );
			dataset.orgname.add	( "" );
 		}
 		
 	}
 	
}
