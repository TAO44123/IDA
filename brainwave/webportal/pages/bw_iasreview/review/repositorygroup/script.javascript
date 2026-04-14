function test() {
	// dummy values
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
	var repositoryowneruid = '';
	var repositoryownerhrcode = '';
	var repositoryownerfullname = '';
	var repositoryownermail = '';
	var accountmaxrisklevel = 0;
	var accountsensitivitylevel = 0;
	var accountnoownercode = '';
	var accounttype = '';
	var lastloginindays = 0;
	var repositorycustom1 = '';
	var repositorycustom2 = '';
	var repositorycustom3 = '';
	var accountcustom1 = '';
	var accountcustom2 = '';
	var accountcustom3 = '';
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