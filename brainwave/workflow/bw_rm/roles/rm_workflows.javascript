import "../commons/JSON.javascript"

function prepareContent() {
	
	// Treat the case of global roles
	if ( dataset.in_attachedorg.get() == "$GLOBAL$" ){
		dataset.in_attachedorg.clear();
	}
	
	var newRole = new Object();
	
	newRole.code = dataset.in_rolecode.get();
	newRole.name = dataset.in_rolename.get();
	newRole.description = dataset.in_roledescription.get();
	newRole.status = dataset.in_status.get();
	newRole.color = dataset.in_color.get();
	newRole.version = dataset.in_roleversion.get();
	newRole.owner = dataset.in_owner.get();
	newRole.category = dataset.in_category.get();
	
	dataset.roledetailsjson = JSON.stringify(newRole);
}

function resolveRoleMetadataUID() {
	if ( dataset.isEmpty('in_rolemetadata_uid') ){
		var /*java.util.HashMap*/ params = new java.util.HashMap();
		params.put("rolecode", dataset.in_rolecode.get());
		var results = workflow.executeView(null, "bwrm_getrolemetadata_fromcode", params );
		if ( results !=null && results.length >0 ){
			dataset.rolemetadatauid = results[0].get("bwrm_role_uid");
		}
	}
	else {
		dataset.rolemetadatauid = dataset.in_rolemetadata_uid.get();
	}
}
