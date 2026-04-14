import "servicenow.javascript"

function getDateTimeLDAPFormat() {
    var /*Date*/ date = new Date();
    return date.toLDAPString();
}

function getServiceNowTicketStatus() {
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

    var ticketids = new Array();
    var externalids = new Array();
    for (var i = 0; i < dataset.ticketid.length; i++) {
        var /*String*/ sysid = dataset.ticketid.get(i);
        ticketids.push(sysid);
        if (dataset.externalid.length > i)
            externalids.push(dataset.externalid.get(i));
        else
            externalids.push(-1);
    }

    dataset.retticketid.clear();
    dataset.externalid.clear();
    dataset.ticketnumber.clear();
    dataset.status.clear();
    dataset.statusStr.clear();
    dataset.ticketupdatedatetime.clear();
    dataset.statusclosed.clear();

    for (var i = 0; i < ticketids.length; i++) {
        var sysid = ticketids[i];
        var externalid = externalids[i];
        var res = getIncident(authenticationProperties, sysid);

        if (res != null && 'result' in res) {
            dataset.retticketid.add(sysid);
            dataset.externalid.add(externalid);
            dataset.ticketnumber.add(res.result.number);
            var status = res.result.incident_state;
            dataset.status.add(status);
            var statusStr = getIncidentStatusLabel(status);
            dataset.statusStr.add(statusStr);
            var closedStatus = getIncidentClosedStatus(status);
            dataset.statusclosed.add(closedStatus);
            var d = getDateTimeLDAPFormat();
            dataset.ticketupdatedatetime.add(d);

        } else {
            dataset.result.set(false);
            dataset.resultdescription.set('Warning: Nothing returned for ticket ' + sysid);
            continue;
        }
    }
    dataset.result.set(true);
}