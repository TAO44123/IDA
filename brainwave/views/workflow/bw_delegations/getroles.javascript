var /*Array*/ roles;
var /*Number*/ index = 0;
var /*Boolean*/ userRoleAdded = false;
var /*String*/ userRoleName = 'user';
var /*String*/ roleAttributeName = 'role';

function oninit() {
	roles = businessview.getPortalRoles(dataset.identityuid.get());
}

function onScriptRead() {
	var /*DataSet*/ ds = new DataSet();
	if (index < roles.length) {
		ds.role = roles[index++];
		return ds;
	} else if ( !userRoleAdded ) {
		// Add the 'user' role
		var /*Attribute*/ attr = ds.add( roleAttributeName, "String", false);
		attr.set( '' + userRoleName );
		userRoleAdded = true;
		return ds;
	}
	return null;
}
