const ROLE_UID_PREFIX = "ROLE_";

function generateRoleIdentifier ( /*String*/ roleName ) {
	var newUID = ROLE_UID_PREFIX;
	var randomString = Math.random().toString(36).substring(2,12) + Math.random().toString(36).substring(2,12);
	roleName = roleName + randomString.substring(0,10)
	newUID += roleName.replace(/[^\w]/gi, '').substring(0,10).toUpperCase();
	newUID += '_' + randomString.substring(10,20).toUpperCase();
	// TODO: check if does not exists
	return newUID;
}