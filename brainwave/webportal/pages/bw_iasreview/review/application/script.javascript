function test() {
	// dummy values
	var applicationowneruid = '';
	var applicationownerhrcode = '';
	var applicationownerfullname = '';
	var applicationownermail = '';
	var permissionowneruid = '';
	var permissionownerhrcode = '';
	var permissionownerfullname = '';
	var permissionownermail = '';
	var accountowneruid = '';
	var accountownerhrcode = '';
	var accountownerfullname = '';
	var accountownermail = '';
	var linemanageruid = '';
	var linemanagerhrcode = '';
	var linemanagerfullname = '';
	var linemanagermail = '';
	var identityuid = '';
	var identityhrcode = '';
	var identityfullname = '';
	var identitymail = '';
	var defaultrevieweruid = '';
	var defaultreviewerhrcode = '';
	var defaultreviewerfullname = '';
	var defaultreviewermail = '';
	var accountuid = '';
	var accountlogin = '';
	var repositoryname = '';
	var accountmaxrisklevel = 0;
	var accountsensitivitylevel = 0;
	var accountnoownercode = '';
	var permissionuid = '';
	var permissioncode = '';
	var permissionsensitivitylevel = 0;
	var applicationuid = '';
	var applicationcode = '';
	var accounttype = '';
	var lastloginindays = 0;
	var applicationcustom1 = '';
	var applicationcustom2 = '';
	var applicationcustom3 = '';
	var permissioncustom1 = '';
	var permissioncustom2 = '';
	var permissioncustom3 = '';
	var rightcustom1 = '';
	var rightcustom2 = '';
	var rightcustom3 = '';
	var rightperimetercustom1 = '';
	var rightperimetercustom2 = '';
	var rightperimetercustom3 = '';
	var accountcustom1 = '';
	var accountcustom2 = '';
	var accountcustom3 = '';
	var repositorycustom1 = '';
	var repositorycustom2 = '';
	var repositorycustom3 = '';
	var identitycustom1 = '';
	var identitycustom2 = '';
	var identitycustom3 = '';

	// test script
	var script = dataset.script.get();
	var errMsg = null;
	var lineNumber = null;
	try {
		var run = eval(script);
	}
	catch(e) {
		lineNumber = e.lineNumber;
		errMsg = e.message;
	}
	
	dataset.lineNumber = lineNumber;
	dataset.errMsg = errMsg;
}