import "servicenow.javascript"

function createServiceNowChangeRequest() {
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

    var /*String*/ short_description = !dataset.isEmpty('short_description') ? dataset.short_description.get() : null;
    var /*String*/ description = !dataset.isEmpty('description') ? dataset.description.get() : null;
    var /*String*/ urgency = !dataset.isEmpty('urgency') ? dataset.urgency.get() : null;
    var /*String*/ impact = !dataset.isEmpty('impact') ? dataset.impact.get() : null;
    var /*String*/ risk = !dataset.isEmpty('risk') ? dataset.risk.get() : null;
    var /*Date*/ start_date = !dataset.isEmpty('start_date') ? dataset.start_date.get() : null;
    var /*Date*/ end_date = !dataset.isEmpty('end_date') ? dataset.end_date.get() : null;
    var /*Date*/ due_date = !dataset.isEmpty('due_date') ? dataset.due_date.get() : null;
    var /*String*/ caller = !dataset.isEmpty('caller') ? dataset.caller.get() : null;
    var /*String*/ assignment_group = !dataset.isEmpty('assignment_group') ? dataset.assignment_group.get() : null;
    var /*String*/ assigned_to = !dataset.isEmpty('assigned_to') ? dataset.assigned_to.get() : null;
    var /*String*/ comments = !dataset.isEmpty('comments') ? dataset.comments.get() : null;

    var cnames = [];
    var cvalues = [];

    if (!dataset.isEmpty('customattributenames') && !dataset.isEmpty('customattributevalues')) {
        if (dataset.customattributenames.length == dataset.customattributevalues.length) {
            for (var i = 0; i < dataset.customattributenames.length; i++) {
                cnames.push(dataset.customattributenames.get(i));
                cvalues.push(dataset.customattributevalues.get(i));
            }
        }
    }

    strstartdate = dateToString(start_date);
    strenddate = dateToString(end_date);
    strduedate = dateToString(due_date);

    //var res = createIncident('dev13745.service-now.com', 'admin', 'y9Yqt8Va5Tga', 'this is a short description', '1', '1', ' 2016-01-05', 'abel.tuter@example.com', 'here are my comments');
    var res = createChangeRequest(authenticationProperties, short_description, description, impact, urgency, risk, strstartdate, strenddate, strduedate, caller, assignment_group, assigned_to, comments, cnames, cvalues);
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