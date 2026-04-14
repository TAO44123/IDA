/* Event service 
input:
	in_importFile :  chemin du fichier XLS
output: 
	out_errors : string avec la liste des erreurs
	out_ruleIds[] : identifiant des règles dynamiques
	out_ruleSerializedSearches[] : règles sérialisées 
*/
function checkErrorsAndGetRules(){
	var error_str = "";
	var ruleIds = new Attribute("ruleIds", "String", true);
	var ruleSerializedSearches = new Attribute("ruleSerializedSearches", "String", true);
	var ruleTitles = new Attribute("ruleTitles", "String", true);
	
	try {
		var filePath = dataset.in_importFile.get();
		var orgsUidByCode = buildOrgReconMap(); 
		var identityUidsByCode = builIdentitiesReconMap();
		var permUidsByKey = buildPermissionsReconMap();  // key = appcode/permcode

		error_str += checkRolesAndGetRules(filePath, orgsUidByCode, identityUidsByCode, ruleIds, ruleSerializedSearches, ruleTitles);
		error_str += checkRolesIdentities(filePath, orgsUidByCode, identityUidsByCode);
		error_str += checkRolesPermissions(filePath, orgsUidByCode, permUidsByKey) ;
		error_str += checkPermissionAnnotations(filePath, permUidsByKey);
	}
	catch( e){ 	
		// try catch ne detecte pas les erreurs de format, dommage 
		error_str = "Error while reading file: "+e ; 
	}
	
	// remove "OK" added by checkRoles if errors in other checks !
	if (error_str.startsWith("OK") && error_str.length > 2) {
		error_str = error_str.substr(2);
	}
	
	dataset.out_errors = error_str;
	dataset.out_ruleIds = ruleIds;
	dataset.out_ruleSerializedSearches = ruleSerializedSearches;
	dataset.out_ruleTitles = ruleTitles;
}

function checkRolesAndGetRules(filePath, orgsUidByCode, identityUidsByCode, /*Attribute*/ ruleIds, /*Attribute*/ ruleSerializedSearches, /*Attribute*/ ruleTitles) {
    
	var parser = connector.getFileParser('XLSX');
	var errors = [];
	// parse roles 
	/*
	code: 0
	name: 1
	description: 2
	status : 3
	color : 4 
	global (bool) : 5
	owner_hrcode : 6
	owner_fullname: 7
	org_key (code or $GLOBAL$) : 8 
	org_displayname (user) : 9
	identityrule : 10
	category : 11
	identityruleser : 12	
	identityruletitle : 12
	*/

	parser.skiplines = 1;
	parser.sheetname = "ROLES";
	//print("Verifying file: " + filePath);
	parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var /*Array*/line,
      /*String*/ role_code,
      /*String*/ role_name,
      /*String*/ role_status,      
      /*String*/ org_code,
      /*String*/ org_name,
      /*String*/ org_uid,
      /*String*/ owner_uid,
      /*String*/ owner_hrcode,
      /*String*/ owner_fullname,
      /*String*/ identityruleid,
      /*String*/ identityruleser,
      /*String*/ identityruletitle;
      
    var i=3;    
    while ( (line = parser.readLine()) != null){
    	role_code = line[0];
    	role_name = line[1];
    	role_status = line [3];
        // first, recon orgs
 		org_code = line[8];
 		org_name = line[9];
 		owner_hrcode = line[6];
 		owner_fullname = line[7];
		org_uid = orgsUidByCode[org_code];
		owner_uid = identityUidsByCode[owner_hrcode];
		if (role_status != 'disabled' && role_status != 'design' && role_status != 'production' )
    	  errors.push("line "+i+" : role status value not supported (" + role_status + ")");
        if (org_uid == null)
    	  errors.push("line "+i+" : org with code " + org_code + " (" + org_name + ") not found for role " + role_code + " (" + role_name +")");
        if (owner_uid == null) {
      	  // try by to find by fullname
      	  owner_uid = identityUidsByCode[owner_fullname];
          if (owner_uid == null)
    	    errors.push("line "+i+" : role owner identity with hrcode " + owner_hrcode + " (" + owner_fullname + ") not found for role " + role_code + " (" + role_name +")");
        }
        if (org_uid == "$GLOBAL$" && line.length > 11) {
        	// global role, try to load identity rule and identity serialized search
        	// TODO: global role with saved rule (not dynamic rule)
        	identityruleid = line[10];
        	identityruleser = line[12];
        	identityruletitle = line.length > 12 ? line[13] : "";
        	if (identityruleid.startsWith("DYN:")) {
        		ruleIds.add(identityruleid);
        		ruleSerializedSearches.add(identityruleser);
        		ruleTitles.add(identityruletitle);
        	}
        }
      	i++;
    }
    parser.close(); 
    //print("last line read="+i); 
    if (errors.length >0)
         return "Errors in ROLES :\n"+ errors.join("\n")+"\n\n";  
    else     
      return "OK";    
}

function checkRolesIdentities(filePath, orgsUidByCode, identityUidsByCode ){
	
	var parser = connector.getFileParser('XLSX');
	var errors = [];
	// parse role identities 
	/*
	code: 0
	name: 1
	color : 2
	org_key (code or $GLOBAL$) : 3 
	identity_hrcode : 4
	identity_fullname: 5
	
	*/
	parser.skiplines = 1;
	parser.sheetname = "ROLE_IDENTITIES";
    parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var /*Array*/ line,
      /*String*/ role_code,
      /*String*/ role_name,
      /*String*/ org_code,
      /*String*/ org_name,
      /*String*/ org_uid,
      /*String*/ identity_uid,
      /*String*/ identity_hrcode,
      /*String*/ identity_fullname;
    var i=3;   
    while ( (line = parser.readLine()) != null){
    	 
		role_code = line[0];
		role_name = line[1];
		// first, recon orgs
		org_code = line[3];
		org_name = line[7];
		identity_hrcode = line[4];
		identity_fullname = line[5];
		org_uid = orgsUidByCode[org_code]; 
		identity_uid = identityUidsByCode[identity_hrcode]; 
	    if (org_uid == null)
	    	errors.push("line "+i+" : org with code " + org_code + " (" + org_name + ") not found for role " + role_code + " (" + role_name +")");
        if (identity_uid == null) {
      	  // try by to find by fullname
      	  identity_uid = identityUidsByCode[identity_fullname];
	      if (identity_uid == null)
	    	errors.push("line "+i+" : identity with hrcode " + identity_hrcode + " (" + identity_fullname + ") not found for role " + role_code + " (" + role_name +")");
        }
        i++;
    }
    parser.close();  
    if (errors.length > 0)
      return "Errors in ROLE_IDENTITIES:\n"+ errors.join("\n")+"\n\n";  
    else
      return "";
}

/* appelé depuis sub_import_role_identities workflow */
function checkRolesPermissions(filePath, orgsUidByCode, permUidsByKey){
	
    var errors = [];
   
	var parser = connector.getFileParser('XLSX');
	
	// parse role permissions 
	/*
	code: 0
	name: 1
	color : 2
	org_key (code or $GLOBAL$) : 3 
	permission_code : 4
	perm_app_code: 6
	
	*/
	parser.skiplines = 1;
	parser.sheetname = "ROLE_PERMISSIONS";
    parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var /*Array*/ line,
      /*String*/ role_code,
	  /*String*/ role_name,
	  /*String*/ org_code,
	  /*String*/ org_name,
      /*String*/ org_uid,
      /*String*/ permission_uid,
      /*String*/ permission_name,
      /*String*/ permission_key; 
    var i=3;   
    while ( (line = parser.readLine()) != null){
    	 
    	role_code = line[0];
    	role_name = line[1];
        // first, recon orgs
 		org_code = line[3];
 		org_name = line[8];
 		permission_key = line[6]+ '/' +line[4];
 		permission_name = line[5];
		org_uid = orgsUidByCode[org_code]; 
		permission_uid = permUidsByKey[permission_key]; 
	    if (org_uid == null)
	    	errors.push("line "+i+" : org with code " + org_code + " (" + org_name + ") not found for role " + role_code + " (" + role_name +")");
	    if (permission_uid == null)
	    	errors.push("line "+i+" : permission with key " + permission_key + " (" + permission_name + ") not found for role " + role_code + " (" + role_name +")");
        i++;	  	   	
    }
    parser.close();  
    if (errors.length >0)
         return "Errors in ROLE_PERMISSIONS:\n"+ errors.join("\n")+"\n\n";  
    else 
        return "";
}


function checkPermissionAnnotations(filePath, permUidsByKey){
	
    var errors = [];
  
	var parser = connector.getFileParser('XLSX');
	
	// parse permissions annotations
	/*
	permission_code : 0
	perm_app_code: 2
    comment: 4
    date: 5 (LDAP)
    author_fullname: 6
	
	*/
	parser.skiplines = 1;
	parser.sheetname = "ANNOTATIONS";
    parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var /* Array */line ; 
    var  /* String */ permission_uid;
    var  /* String */ permission_key;    
    var i=3;   
    while ( (line = parser.readLine()) != null){
    	 
    	permission_key = line[2]+ '/' +line[0] ;   	// APP/PERM
		permission_uid = permUidsByKey[permission_key]; 	
        if (permission_uid == null)
        	errors.push("line "+i+" : permission with key " + permission_key + " not found " ); 
        i++;	  	   	
    }   
    parser.close();  
    if (errors.length >0)
         return "Errors in ANNOTATIONS:\n"+ errors.join("\n")+"\n\n";  
    else
         return ""; 
}


function buildOrgReconMap(){
	var code, uid , i, n; 	
    var  orgUidsByCode = {};
 	var result = connector.executeView(null, "bwrm_orgsrecon" );   // uid, code   
    n = result.length;
	for (i=0; i< n; i++){
       code = result[i].get("code");
       uid =  result[i].get("uid");
       orgUidsByCode[code] = uid; 
	}
	orgUidsByCode["$GLOBAL$"] = "$GLOBAL$";
	return orgUidsByCode;	
}

function builIdentitiesReconMap(){
	var hrcode, fullname, uid, i, n; 
    var identityUidsByCode = {};
    var result = connector.executeView(null, "bwrm_identitiesrecon" );  //uid, hrcode
    n = result.length;
	for (i=0; i< n; i++){
       hrcode = result[i].get("hrcode");
       fullname =result[i].get("fullname");
       uid = result[i].get("uid");
       identityUidsByCode[hrcode] = uid;
       identityUidsByCode[fullname] = uid;
	}
	return identityUidsByCode;
} 

/* used in sub_import_role_permissions workflow*/
function buildPermissionsReconMap(){
	
	var key, uid , i, n; 
    var permUidsByKey = {};
    var result = connector.executeView(null, "bwrm_perm_recon" );  //uid, key
    n = result.length;
	for (i=0; i< n; i++){
       key = result[i].get("key");
       uid = result[i].get("uid");
       permUidsByKey[key] = uid; 
	}
	return permUidsByKey;	
} 
 
 


function generateConfirmationCode()
{
	return  (Math.floor(Math.random()*90000) + 10000).toString();	
}

