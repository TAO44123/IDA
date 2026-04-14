import "../../webportal/pages/resources/security.javascript"

function replaceNullByEmpty(str) {
	if(str==null)
		return '';
	else
		return str;		
}

function init() {
	// decrypt all fields except password/token
	var fields = [
					"sendto_name",
					"sendto_mail",
				];
	decryptFields(fields);
}