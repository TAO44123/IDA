/**
 * ServiceNow incident javascript API wrapper
 * 
 * Copyright Brainwave
 */

import "restapi.javascript"
import "base64.javascript"
import "../../webportal/pages/resources/security.javascript"

/**
 * Create an object containing all the informations needed for the authentication
 * 
 * @param domain ServiceNow DNS domain
 * @param authentication_type Authentication used to connect to ServiceNow (password, OAuth or OAuth using the conf parameters)
 * @param login String ServiceNow account login
 * @param password String ServiceNow account password
 * @param token_grant_type String OAuth token grant type (password or refresh_token)
 * @param client_id String OAuth client identifier in ServiceNow
 * @param client_secret String OAuth client secret in ServiceNow
 * @param refresh_token String OAuth refreshToken, required if token_grant_type is refresh_token
 * @param refresh_token_expiration_date Date OAuth refreshToken expiration date
 * @param oauth_uri String Uri used for the OAuth authentication
 * 
 * @return authenticationProperties object
 * 
 */
function setAuthenticationProperties(domain, authentication_type, login, password, token_grant_type, client_id, client_secret, refresh_token, refresh_token_expiration_date, scope) {
    var authenticationProperties = {};

    if (domain != null) authenticationProperties.domain = '' + domain;
    if (authentication_type != null) authenticationProperties.authentication_type = '' + authentication_type;
    if (login != null) authenticationProperties.login = '' + login;
    if (password != null) authenticationProperties.password = '' + decipher(password);
    if (token_grant_type != null) authenticationProperties.token_grant_type = '' + token_grant_type;
    if (client_id != null) authenticationProperties.client_id = '' + client_id;
    if (client_secret != null) authenticationProperties.client_secret = '' + decipher(client_secret);
    if (refresh_token != null) authenticationProperties.refresh_token = '' + refresh_token;
    if (refresh_token_expiration_date != null) authenticationProperties.refresh_token_expiration_date = '' + refresh_token_expiration_date;
    if (scope != null) authenticationProperties.scope = '' + scope;
    authenticationProperties.oauth_uri = '/oauth_token.do';

    return authenticationProperties;
}

/**
 * Create a ServiceNow change request
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param short_description short description of the change request 
 * @param impact change request impact as a numerical value (string) (null to ignore this parameter)
 * @param priority change request urgency as a numerical value (string) (null to ignore this parameter) 
 * @param risk change request risk as a numerical value (string) (null to ignore this parameter) 
 * @param start_date change request start date as a date in yyyy-MM-dd format (string) (null to ignore this parameter)
 * @param end_date change request end date as a date in yyyy-MM-dd format (string) (null to ignore this parameter)
 * @param due_date change request due date as a date in yyyy-MM-dd format (string) (null to ignore this parameter)
 * @param caller the individual who is asking for the change (email address) (null to ignore this parameter)
 * @param assignment_group the group on which this change request is assigned (null to ignore this parameter)
 * @param assigned_to the individual on which this change request is assigned (email address) (null to ignore this parameter)
 * @param comments additional comments that could be seen by the customer (null to ignore this parameter)
 * @param cnames, cvalues additional attributes provided as two sync arrays
 * @return result as a JSON object. The ticket internal ID is stored on "object.result.sys_id", the ticket number is stored on "object.result.number", the ticket status is stored on "object.result.state" as a number, the ticket status is stored on "phase_state" as a string
 * phase_state is by default:
 * 1 Open
 * 2 Work in progress
 * 3 Closed Complete
 * 4 Closed Incomplete
 * 5 Closed Skipped
 */
function createChangeRequest(authenticationProperties, short_description, description, impact, priority, risk, start_date, end_date, due_date, caller, assignment_group, assigned_to, comments, /*String[]*/ cnames, /*String*/ cvalues) {
    var changerequest = {};
    changerequest.short_description = '' + short_description;
    changerequest.contact_type = 'email';
    if (description != null) changerequest.description = '' + description;
    if (impact != null) changerequest.impact = '' + impact;
    if (priority != null) changerequest.priority = '' + priority;
    if (risk != null) changerequest.risk = '' + risk;
    if (start_date != null) changerequest.start_date = '' + start_date;
    if (end_date != null) changerequest.end_date = '' + end_date;
    if (due_date != null) changerequest.due_date = '' + due_date;
    if (caller != null) changerequest.requested_by = '' + caller;
    if (assignment_group != null) changerequest.assignment_group = '' + assignment_group;
    if (assigned_to != null) changerequest.assigned_to = '' + assigned_to;
    if (comments != null) changerequest.comments = '' + comments;

    if (cnames != null && cvalues != null && cnames.length == cvalues.length) {
        for (var i = 0; i < cnames.length; i++) {
            changerequest[cnames[i]] = cvalues[i];
        }
    }

    res = httpPOST(authenticationProperties, '/api/now/table/change_request', changerequest);

    return res;
}

/**
 * Retrieve a ServiceNow change request
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param sysid the change request internal ID
 * @return result as a JSON object. The ticket internal ID is stored on "object.result.sys_id", the ticket number is stored on "object.result.number", the ticket status is stored on "object.result.change_state"
 * incident_state is by default:
 * 1 Open
 * 2 Work in progress
 * 3 Closed Complete
 * 4 Closed Incomplete
 * 5 Closed Skipped
 */
function getChangeRequest(authenticationProperties, sysid) {
    res = httpGET(authenticationProperties, '/api/now/table/change_request/' + sysid);

    return res;
}

/**
 * Create a ServiceNow incident
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param short_description short description of the incident 
 * @param impact incident impact as a numerical value (string) (null to ignore this parameter)
 * @param urgency incident urgency as a numerical value (string) (null to ignore this parameter) 
 * @param due_date incident due date as a date in yyy-MMdd format (string) (null to ignore this parameter)
 * @param caller the individual who is asking for the change (email address) (null to ignore this parameter)
 * @param assignment_group the group on which this change request is assigned (null to ignore this parameter)
 * @param assigned_to the individual on which this change request is assigned (email address) (null to ignore this parameter)
 * @param comments additional comments that could be seen by the customer (null to ignore this parameter)
 * @param cnames, cvalues additional attributes provided as two sync arrays
 * @return result as a JSON object. The ticket internal ID is stored on "object.result.sys_id", the ticket number is stored on "object.result.number", the ticket status is stored on "object.result.incident_state"
 * incident_state is by default:
 * 1 New
 * 2 Active
 * 3 Awaiting Problem
 * 4 Awaiting User Info
 * 5 Awaiting Evidence
 * 6 Resolved 
 * 7 Closed
 */
function createIncident(authenticationProperties, short_description, impact, urgency, due_date, caller, assignment_group, assigned_to, comments, /*String[]*/ cnames, /*String*/ cvalues) {
    var incident = {};
    incident.short_description = '' + short_description;
    incident.contact_type = 'email';
    if (impact != null) incident.impact = '' + impact;
    if (urgency != null) incident.urgency = '' + urgency;
    if (due_date != null) incident.due_date = '' + due_date;
    if (caller != null) incident.caller_id = '' + caller;
    if (assignment_group != null) incident.assignment_group = '' + assignment_group;
    if (assigned_to != null) incident.assigned_to = '' + assigned_to;
    if (comments != null) incident.comments = '' + comments;

    if (cnames != null && cvalues != null && cnames.length == cvalues.length) {
        for (var i = 0; i < cnames.length; i++) {
            incident[cnames[i]] = cvalues[i];
        }
    }

    res = httpPOST(authenticationProperties, '/api/now/table/incident', incident);

    return res;
}

/**
 * Retrieve a ServiceNow incident
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param sysid the incident internal ID
 * @return result as a JSON object. The ticket internal ID is stored on "object.result.sys_id", the ticket number is stored on "object.result.number", the ticket status is stored on "object.result.incident_state"
 * incident_state is by default:
 * 1 New
 * 2 Active
 * 3 Awaiting Problem
 * 4 Awaiting User Info
 * 5 Awaiting Evidence
 * 6 Resolved 
 * 7 Closed
 */
function getIncident(authenticationProperties, sysid) {
    res = httpGET(authenticationProperties, '/api/now/table/incident/' + sysid);

    return res;
}

/**
 * getChangeRequestClosedStatus
 * 
 * @param status status number as a string (-5, ..., 4) 
 * @return 0=ticket is still open, 1=ticket is closed action has been done, 2=ticket is closed action has been cancelled
 */
function getChangeRequestClosedStatus( /*String*/ status) {
    var res = '0';
    if ('3'.equals(status))
        res = '1';
    else if ('4'.equals(status))
        res = '2';

    return res;
}


/**
 * getIncidentClosedStatus
 * 
 * @param status status number as a string (1, ..., 8) 
 * @return 0=ticket is still open, 1=ticket is closed action has been done, 2=ticket is closed action has been cancelled
 */
function getIncidentClosedStatus( /*String*/ status) {
    var res = '0';
    if ('7'.equals(status))
        res = '1';
    else if ('8'.equals(status))
        res = '2';
    return res;
}

/**
 * getChangeRequestStatusLabel returns an incident status pretty string based on its number. This method uses only the default ServiceNow incident status mapping.
 
 * @param status status number as a string (-5, ..., 4) 
 * @return status pretty string (New, ..., Canceled)
 */
function getChangeRequestStatusLabel( /*String*/ status) {
    /*
    State	Description	State value
    New	Change request is not yet submitted for review and authorization. A change requester can save a change request as many times as necessary while building out the details of the change prior to submission.	-5
    Assess	Peer review and technical approval of the change details are performed during this state.	-4
    Authorize	Change Management and the CAB schedule the change and provide final authorization to proceed.	-3
    Scheduled	The change is fully scheduled and authorized, and is waiting for the planned start date. An email notification is sent to the user who requested the change.	-2
    Implement	The planned start date has approached and the actual work to implement the change is being conducted. An email notification is sent to the user, who requested the change.	-1
    Review	The work has been completed. The change requester determines whether the change was successful. A post-implementation review can be conducted during this state. An email notification is sent to the user who requested the change.
    Note: You cannot cancel the change request if it is in the Review state.
    0
    Closed	All review work is complete. The change is closed with no further action required.	3
    Canceled	A change can be canceled at any point when it is no longer required. However, a change cannot be canceled from a Closed state. An email notification is sent to the user who requested the change.
    */

    /*
    -5 New
    -4 Assess
    -3 Authorize
    -2 Scheduled
    -1 Implement
    0 Review
    3 Closed
    4 Canceled
    */
    var res = status;
    if (status.equals('-5'))
        res = 'New';
    else if (status.equals('-4'))
        res = 'Assess';
    else if (status.equals('-3'))
        res = 'Authorize';
    else if (status.equals('-2'))
        res = 'Scheduled';
    else if (status.equals('-1'))
        res = 'Implement';
    else if (status.equals('0'))
        res = 'Review';
    else if (status.equals('3'))
        res = 'Closed';
    else if (status.equals('4'))
        res = 'Canceled';

    return res;
}

/**
 * getIncidentStatusLabel returns an incident status pretty string based on its number. This method uses only the default ServiceNow incident status mapping.
 
 * @param status status number as a string (1, ..., 8) 
 * @return status pretty string (New, ..., Canceled)
 */
function getIncidentStatusLabel( /*String*/ status) {
    /*
    1 New
    2 In Progress
    3 On Hold
    4 On Hold
    5 On Hold
    6 Resolved
    7 Closed
    8 Canceled
    */
    var res = status;
    if (status.equals('1'))
        res = 'New';
    else if (status.equals('2'))
        res = 'In Progress';
    else if (status.equals('3'))
        res = 'On Hold';
    else if (status.equals('4'))
        res = 'On Hold';
    else if (status.equals('5'))
        res = 'On Hold';
    else if (status.equals('6'))
        res = 'Resolved';
    else if (status.equals('7'))
        res = 'Closed';
    else if (status.equals('8'))
        res = 'Canceled';
    return res;
}

/**
 * retrieve a ServiceNow sysid
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param table the table to search into
 * @param attributeName the attribute name used for the search
 * @param attributeValue the attribute value used for the search
 * @return the sys_id, null if the object is not found
 */
function getSysId(authenticationProperties, table, attributeName, attributeValue) {
    var /*String*/ uri = '/api/now/v1/table/' + table + '?' + encodeURI(attributeName) + '=' + encodeURI(attributeValue);
    res = httpGET(authenticationProperties, uri);
    if (res != null && 'result' in res) {
        var result = res.result;
        if (result.length > 0 && ('sys_id' in result[0]))
            return result[0].sys_id;
    } else {
        return null;
    }
}

/**
 * add an attachment to a ticket. The attachment is provided as a file on the local disk.
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param table table on which to attach the file
 * @param sysid ticket on which to attach the file
 * @param canonicalpath canonical path to the attachment
 * @return result as a JSON object, null if the file is not found
 */
function addTextfileAttachment(authenticationProperties, table, sysid, canonicalpath) {

    var endpoint = "/api/now/attachment/upload";

    var attachment = {};
    attachment.table_name = table;
    attachment.table_sys_id = sysid;

    res = httpPOST_FILE(authenticationProperties, endpoint, attachment, canonicalpath);

    return res;
}

/**
 * add an attachment to the ticket in the form of a text file whom content is provided as a string in this method
 * 
 * @param authenticationProperties object containing all the informations needed for the authentication (see setAuthenticationProperties())
 * @param table table on which to attach the file
 * @param sysid ticket on which to attach the file
 * @param filename the name of the file as it will appears in the interfaces
 * @param textdata content of the text file
 * @return ServiceNow result as a JSON object
 */
function addTextAttachment(authenticationProperties, table, sysid, filename, textdata) {

    var endpoint = "/api/now/attachment/file?table_name=" + table + "&table_sys_id=" + sysid + "&file_name=" + filename;

    res = httpPOST_textAttachment(authenticationProperties, endpoint, textdata);

    return res;
}

// ===========================================================================================

function getFilename(canonicalpath) {
    var file = new java.io.File(canonicalpath);
    var result = file.getName();
    return result;
}

function getFileContentType(canonicalpath) {
    var /*com.brainwave.utils.FileHelper*/ filehelper = new com.brainwave.utils.FileHelper();
    var /*String*/ result = filehelper.getContentType(canonicalpath);
    return result;
}

function getFileAsBase64(canonicalpath) {
    var /*com.brainwave.utils.FileHelper*/ filehelper = new com.brainwave.utils.FileHelper();
    var /*String*/ result = filehelper.getContentAsBase64(canonicalpath);
    return result;
}

function dateToString(date) {
    if (date == null)
        return null;
    var /*java.text.SimpleDateFormat*/ dateformat = new java.text.SimpleDateFormat('yyyy-MM-dd');
    strDate = dateformat.format(date);
    return strDate;
}