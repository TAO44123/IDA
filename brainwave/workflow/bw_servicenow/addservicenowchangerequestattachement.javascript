import "servicenow.javascript"

function addServiceNowTextAttachement() {
    if (!dataset.isEmpty('debug') && dataset.debug.get())
        setHttpDebug();

    // Variables used for the authentication, set in an object
    var /*String*/ domain = dataset.domain.get();
    // Set Basic to authentication type if empty for non-regression purpose
    var /*String*/ authentication_type = !dataset.isEmpty('authentication_type')? dataset.authentication_type.get() : 'Basic';
    var /*String*/ login = dataset.login.get();
    var /*String*/ password = dataset.password.get();
    var /*String*/ token_grant_type = dataset.oauth_grant_type.get();
    var /*String*/ client_id = dataset.oauth_client_id.get();
    var /*String*/ client_secret = dataset.oauth_client_secret_password.get();
    var /*String*/ refresh_token = dataset.oauth_refresh_token.get();
    var /*String*/ refresh_token_expiration_date = !dataset.isEmpty('oauth_expiration_date') ? dataset.oauth_expiration_date.get().toLDAPString() : new Date().toLDAPString();
    var /*String*/ scope = dataset.oauth_scope.get();

    var authenticationProperties = setAuthenticationProperties(domain, authentication_type, login, password, token_grant_type, client_id, client_secret, refresh_token, refresh_token_expiration_date, scope);

    var /*String*/ sysid = dataset.ticketid.get();

    var /*String*/ attachmentcanonicalfile = dataset.attachmentcanonicalfile.get();

    var res = addTextfileAttachment(authenticationProperties, 'change_request', sysid, attachmentcanonicalfile);

    try {
        if (res == null) {
            dataset.result.set(false);
            dataset.resultdescription.set('Unknown error: Nothing returned');
            return;
        } else if ('result' in res) {
            dataset.result.set(true);
            dataset.ticketnumber.set(res.result.number);
            dataset.short_description.set(res.result.short_description);
            dataset.incident_state.set(res.result.incident_state);
        } else if ('message' in res) {
	        dataset.result.set(false);
        	dataset.resultdescription.set(res.message.replace(/^(\w*\.)*\w*\: ?/gi,""));
        } else {
            dataset.result.set(false);
            dataset.resultdescription.set(JSON.stringify(res));
            return;
        }
    }
    catch (e) {
    	print("Error caught in a child process, returned in the comment of the remediation");
        dataset.result.set(false);
        dataset.resultdescription.set(res.toString());
        return;
    }
}