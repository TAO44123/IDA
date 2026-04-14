import "../../../../webportal/pages/resources/security.javascript"

function getDecryptedFieldValueView(record, fieldName) {
	if(record.isEmpty(fieldName))
		return '';	

	var str = ''+record.get(fieldName);
	
	var encStr = decipher(str);
	return encStr;
}

function processView(record, fieldName) {
	var encStr = getDecryptedFieldValueView(record, fieldName);
	if(encStr!=null && encStr.length>0)
		record.get(fieldName).set(encStr);
}

function read() {
	var record = businessview.getNextRecord();
	if(record==null)
		return record;
	
	var fields = [
					"bwr_remediation_itsmdef_string4",
					"bwr_remediation_itsmdef_string5",
					"bwr_remediation_itsmdef_string6",
					//"bwr_remediation_itsmdef_string7", // SNOW password, Jira token
					"bwr_remediation_itsmdef_string8",
					"bwr_remediation_itsmdef_string9",
					"bwr_remediation_itsmdef_string10",
					"bwr_remediation_itsmdef_string11",
					"bwr_remediation_itsmdef_string12",
					"bwr_remediation_itsmdef_string13",
					//"bwr_remediation_itsmdef_string14", // SNOW client secret for oauth2
					"bwr_remediation_itsmdef_string15",
					"bwr_remediation_itsmdef_string16",
					"bwr_remediation_itsmdef_string17",
					"bwr_remediation_itsmdef_string18",
					"bwr_remediation_itsmdef_string19",
					"bwr_remediation_itsmdef_string20"
				];	
	
	for (var i=0; i<fields.length;i++) {
		processView(record, fields[i]);	
	}
	
	return record;
}
