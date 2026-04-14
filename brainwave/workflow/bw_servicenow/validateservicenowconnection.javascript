import "restapi.javascript"
import "servicenow.javascript"

var httpdebug = false;

var OK_REQUEST = '200';
var PING_FAILED = '000';
var JSON_CONTENT = 'application/json';

function testServiceNow() {
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

    var /*String*/ ticketType = dataset.tickettype.get();

    var /*String*/ code = null;
    var /*String*/ reason = null;
    var /*String*/ body = null;

    var /*String*/ result = null;

    if (ticketType == 'changerequest') {
        ticketType = 'change_request';
    }

    try {
        result = httpGETPing(domain);
        if (result == null) {
            code = PING_FAILED;
       		reason = "An error occured";
        }
        else if ('message' in result) {
        	code = PING_FAILED;
        	reason = result.message;
        }
        else if ('code' in result) {
        	code = result.code;
        	reason = result.reason;
        }
        else {
        	code = PING_FAILED;
       		reason = "An error occured";
        }
    } catch (e) {
        code = PING_FAILED;
        reason = "An error occured";
    }

    if (httpdebug) {
        print("Code: " + code);
    }
    if (httpdebug) {
        print("Reason: " + reason);
    }
    //if (httpdebug) { print("Body: " + body); }

    if (code == PING_FAILED) {
        dataset.serverReachable.set(false);
        dataset.errormessage_ping.set(reason);
        return null;
    } else {
        dataset.serverReachable.set(true);
    }

    try {
        result = httpGETReadTables(authenticationProperties, '/api/now/table/' + ticketType + '?sysparm_limit=1');
        if (result == null) {
            code = PING_FAILED;
       		reason = "An error occured";
        }
        else if ('message' in result) {
        	code = PING_FAILED;
        	reason = result.message;
        }
        else if ('code' in result) {
        	code = result.code;
        	reason = result.reason;
        }
        else {
        	code = PING_FAILED;
       		reason = "An error occured";
        }
    } catch (e) {
        code = PING_FAILED;
        reason = "An error occured";
    }

    if (httpdebug) {
        print("Code: " + code);
    }
    if (httpdebug) {
        print("Reason: " + reason);
    }
    
	if (code != OK_REQUEST) {
        dataset.ticketTableReadable.set(false);
        if (reason != null) {
            dataset.errormessage_ticket_type.set(reason);
        }
    } else {
        dataset.ticketTableReadable.set(true);
    }

    try {
        result = httpGETReadTables(authenticationProperties, '/api/now/attachment' + '?sysparm_limit=1');
        if (result == null) {
            code = PING_FAILED;
       		reason = "An error occured";
        }
        else if ('message' in result) {
        	code = PING_FAILED;
        	reason = result.message;
        }
        else if ('code' in result) {
        	code = result.code;
        	reason = result.reason;
        }
        else {
        	code = PING_FAILED;
       		reason = "An error occured";
        }
    } catch (e) {
        code = PING_FAILED;
        reason = "An error occured";
    }

    if (httpdebug) {
        print("Code: " + code);
    }
    if (httpdebug) {
        print("Reason: " + reason);
    }

    if (code != OK_REQUEST) {
        dataset.attachmentTableReadable.set(false);
        if (reason != null) {
            dataset.errormessage_attachment.set(reason);
        }
    } else {
        dataset.attachmentTableReadable.set(true);
    }
    return null;
}