import "../commons/JSON.javascript"

var rolemap = {}

function fillRoleMap () {
	rolemap = new Object();
	var results = workflow.executeView(null, "bwrm_rolecodemapping")
	for ( var i=0 ; i < results.length ; i++ ) {
		rolemap [ results[i].get('code')  ] = results[i].get('uid');
	}
}

function importConfig(){
	var filePath = dataset.in_importFile.get(); 
	var orgsUidByCode = buildOrgReconMap(); 
    var identityUidsByCode = builIdentitiesReconMap();
    var permUidsByKey = buildPermissionsReconMap();  // key = appcode/permcode
    
    importRoles(filePath, orgsUidByCode, identityUidsByCode);
    
}

function statusByDisplay() {
	var allstatus = {};
	allstatus["disabled"] = 0;
	allstatus["design"] = 1;
	allstatus["production"] = 2;
	return allstatus;
}

function importRoles(){
	
    var filePath = dataset.in_importFile.get();
	var orgsUidByCode = buildOrgReconMap(); 
    var identityUidsByCode = builIdentitiesReconMap();
    
    dataset.r_codes.clear();
	dataset.r_names.clear();
 	dataset.r_descriptions.clear();
  	dataset.r_statuses.clear();
  	dataset.r_colors.clear();
	dataset.r_orguids.clear();
	dataset.r_owner_uids.clear();
	dataset.r_jsons.clear();
	dataset.r_category.clear();
	 
	var parser = workflow.getFileParser('XLSX');
	
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
	identityruletitle : 13
	*/
	parser.skiplines = 1;
	parser.sheetname = "ROLES";
    parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var /*Array*/line , 
      /*String*/ role_code , 
      /*String*/ org_code, 
      /*String*/ org_uid,
      /*String */ owner_uid,
      /*String*/ owner_hrcode,
      /*String*/ category,
      /*Integer*/ status_code,
      statusmap;  
      
    statusmap = statusByDisplay();
    while ( (line = parser.readLine()) != null){
    	 
    	role_code = line[0];
        // first, recon orgs
 		org_code = line[8];
 		owner_hrcode = line[6];
 		category = line.length > 10 ? line[11] : "";
		org_uid = orgsUidByCode[org_code]; 
		owner_uid = identityUidsByCode[owner_hrcode];
		status_code = statusmap[line[3]];
		if (owner_uid == null) {
			// try to find by fullname
			owner_uid = identityUidsByCode[line[7]];
		}
		if (org_uid != null  && owner_uid != null ) {
			
			if (org_uid == "$GLOBAL$") {
				org_uid = null;
			}
			
		   	dataset.r_codes.add(role_code);
	    	dataset.r_names.add(line[1]);
	     	dataset.r_descriptions.add(line[2]);
	      	dataset.r_statuses.add(status_code);
	      	dataset.r_colors.add(line[4]);
			dataset.r_orguids.add(org_uid);	
			dataset.r_owner_uids.add(owner_uid);
			dataset.r_category.add(category);
			var newRole = new Object();
			newRole.code = role_code;
			newRole.name = line[1];
			newRole.description = line[2];
			newRole.status = status_code;
			newRole.color = line[4];
			newRole.owner = owner_uid;
			newRole.category = category;
			dataset.r_jsons.add(JSON.stringify(newRole));
		}      	   	
    }   
    parser.close();  
   
}

function importGlobalRolesIdentities(){
	
    var filePath = dataset.in_importFile.get();
    
	dataset.r_codes.clear();
	dataset.r_identityrules.clear();
	dataset.r_globals.clear();
	dataset.r_parent_metadata.clear();
	dataset.r_identityruleser.clear();
	dataset.r_identityruletitle.clear();
	fillRoleMap ()
	 
	var parser = workflow.getFileParser('XLSX');
	
	parser.skiplines = 1;
	parser.sheetname = "ROLES";
    parser.open(filePath);
    parser.readLine(); // skip header,  TODO check header 
    var   /*Array*/line , 
          /*String*/ org_code,
          /*String*/ role_code,
	      /*String*/ identityruleser,
	      /*String*/ identityruletitle;
    while ( (line = parser.readLine()) != null){
    	
    	org_code = line[8];
    	role_code = line[0];
 		identity_rules = line[10];
		parent_metadata = rolemap[role_code];
 		identityruleser = line.length > 11 ? line[12] : "";
 		identityruletitle = line.length > 12 ? line[13] : "";
		
		if (org_code == "$GLOBAL$"  && identity_rules != null && parent_metadata != null  ) {
		   	dataset.r_codes.add(role_code);
			dataset.r_parent_metadata.add( parent_metadata );
			dataset.r_identityrules.add ( identity_rules );
			dataset.r_globals.add(true);
			dataset.r_identityruleser.add(identityruleser);
			dataset.r_identityruletitle.add(identityruletitle);
		}      	   	
    }   
    parser.close();  
   
}

function importRolesIdentities(){

	var filePath = dataset.in_importFile.get(); 
    var identityUidsByCode = builIdentitiesReconMap();
    	
   	dataset.r_codes.clear();
	dataset.r_identity_uids.clear();
	dataset.r_identityrules.clear();
	dataset.r_globals.clear();
	dataset.r_parent_metadata.clear();
	fillRoleMap ()
			    
	var parser = workflow.getFileParser('XLSX');
	
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
    var /*Array*/line , 
      /*String*/ role_code ,
      /*String */ identity_uid,
      /*String*/ identity_hrcode;
    var i=3;   
    while ( (line = parser.readLine()) != null){
    	 
    	role_code = line[0];
 		identity_hrcode = line[4];
		identity_uid = identityUidsByCode[identity_hrcode];
		parent_metadata = rolemap[role_code];
		if (identity_uid == null) {
			// try to find by fullname
			identity_uid = identityUidsByCode[line[5]];
		}
		if (identity_uid != null && parent_metadata != null  ) {
		   	dataset.r_codes.add(role_code);
			dataset.r_identity_uids.add(identity_uid);
			dataset.r_parent_metadata.add( parent_metadata );
			dataset.r_identityrules.add(null);
			dataset.r_globals.add(false);
		}    	  	   	
    }   
    parser.close();  
}

function importRolesPermissions(){
 
	var filePath = dataset.in_importFile.get(); 
    var permUidsByKey = buildPermissionsReconMap();  // key = appcode/permcode
     
    dataset.r_codes.clear();
	dataset.r_permissions_uids.clear();
	dataset.r_parent_metadata.clear();
	dataset.r_permissionactive.clear();
	fillRoleMap ()
			
	var parser = workflow.getFileParser('XLSX');
	
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
    var /* Array */line ; 
    var  /* String */ role_code ; 
    var  /* String */ permission_uid;
    var  /* String */ permission_key;    
    while ( (line = parser.readLine()) != null){
    	 
    	role_code = line[0];
        // first, recon orgs
 		permission_key = line[6]+ '/' +line[4] ;
		permission_uid = permUidsByKey[permission_key]; 
		parent_metadata = rolemap[role_code];
		if (permission_key != null && parent_metadata != null  ) {
		   	dataset.r_codes.add(role_code);
			dataset.r_permissions_uids.add(permission_uid);
			dataset.r_parent_metadata.add ( parent_metadata );
			dataset.r_permissionactive.add(true);
		}    	  	   	
    }   
    parser.close();  
}


/* appelé depuis sub_import_role_identities workflow */
function importPermissionAnnotations(){

	var filePath = dataset.in_importFile.get(); 
    var permUidsByKey = buildPermissionsReconMap();  // key = appcode/permcode
    	
 	dataset.pr_perms.clear();
	dataset.pr_authors.clear();
	dataset.pr_comments.clear();
	dataset.pr_dates.clear();
	      	  
	var parser = workflow.getFileParser('XLSX');
	
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
    while ( (line = parser.readLine()) != null){
    	 
    	permission_key = line[2]+ '/' +line[0] ;   	// APP/PERM
		permission_uid = permUidsByKey[permission_key]; 	
		if (permission_uid != null ) {
		   	dataset.pr_perms.add(permission_uid);
		   	dataset.pr_authors.add(line[6]);
	    	dataset.pr_comments.add(line[4]);
	      	dataset.pr_dates.add(line[5]);
		}    	  	   	
    }   
    parser.close();  
}


function buildOrgReconMap(){
	var code, uid , i, n; 	
    var  orgUidsByCode = {};
 	var result = workflow.executeView(null, "bwrm_orgsrecon" );   // uid, code   
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
    var result = workflow.executeView(null, "bwrm_identitiesrecon" );  //uid, hrcode
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
    var result = workflow.executeView(null, "bwrm_perm_recon" );  //uid, key
    n = result.length;
	for (i=0; i< n; i++){
       key = result[i].get("key");
       uid = result[i].get("uid");
       permUidsByKey[key] = uid; 
	}
	return permUidsByKey;	
} 
 
 

