/**
 * 
 * to configure oauth in servicenow https://docs.servicenow.com/fr-FR/bundle/quebec-platform-administration/page/administer/security/task/t_SettingUpOAuth.html
 * 
 * 
 * 
 */

import "JSON.javascript"

/*
 * Java packages used by the HTTP methods
 */
var HttpClient = JavaImporter(
    Packages.org.apache.http.HttpException,
    Packages.org.apache.http.HttpHost,
    Packages.org.apache.http.client.methods.CloseableHttpResponse,
    Packages.org.apache.http.client.methods.HttpGet,
    Packages.org.apache.http.client.methods.HttpPost,
    Packages.org.apache.http.impl.client.CloseableHttpClient,
    Packages.org.apache.http.impl.client.HttpClients,
    Packages.org.apache.http.entity.StringEntity,
    Packages.org.apache.http.util.EntityUtils,
    Packages.org.apache.http.message.BasicNameValuePair,
    Packages.org.apache.http.client.entity.UrlEncodedFormEntity,
    Packages.org.apache.http.protocol.HTTP,
    Packages.org.apache.http.HttpResponse,
    Packages.java.nio.charset.Charset,
    Packages.org.apache.http.impl.client.HttpClientBuilder,
    Packages.org.apache.http.auth.Credentials,
    Packages.org.apache.http.auth.UsernamePasswordCredentials,
    Packages.org.apache.http.impl.client.BasicCredentialsProvider,
    Packages.org.apache.http.auth.NTCredentials
);

/*
 * OAuth2 Constants  
 */
var GRANT_TYPE = "grant_type";
var ACCESS_TOKEN = "access_token";
var CLIENT_ID = "client_id";
var CLIENT_SECRET = "client_secret";
var REFRESH_TOKEN = "refresh_token";
var USERNAME = "username";
var PASSWORD = "password";
var SCOPE = "scope";
var GRANT_TYPE_PASSWORD = "password";
var GRANT_TYPE_REFRESH_TOKEN = "refresh_token";

/*
 * HTTP constants 
 */
var URL_ENCODED_CONTENT = "application/x-www-form-urlencoded";
var HTTP_OK = 200;
var HTTP_UNAUTHORIZED = 401;
var HTTP_SEND_REDIRECT = 302;
var HTTP_FORBIDDEN = 403;

var JSON_CONTENT = "application/json";

var /*Boolean*/ oauthEnabled = false;
var /*String*/ baseUrl = '';
var /*String*/ oauthUrl = '';
var /*String*/ username = '';
var /*String*/ password = '';
var /*String*/ clientId = '';
var /*String*/ clientSecret = '';
var /*String*/ scope = '';
var /*String*/ grantType = '';
var /*String*/ oauthRefreshToken = '';
var /*String*/ oauthEndpoint = '/oauth_token.do';
var /*Date*/ refreshExpirationDate = '';
var /*Boolean*/ debug = false;

var /*Boolean*/ _proxyEnabled = false;
var /*Boolean*/ _proxyAuthenticated = false;
var /*String*/ _proxyHost = '';
var /*String*/ _proxyUsername = '';
var /*String*/ _proxyPassword = '';
var /*String*/ _localServerHostname = '';
var /*String*/ _proxyAuthenticationDomain = '';
var _proxyPort = '';

// Initialize the OAuth with the config variables
function IniOAuth() {
    if (httpdebug) print("Initializing OAuth with the project config variables");

    if (config.snOAuthEnabled != null && config.snOAuthEnabled.length > 0) {
        oauthEnabled = 'true'.equalsIgnoreCase(config.snOAuthEnabled.trim());
    }
    if (config.snurl != null && config.snurl.length > 0) {
        baseUrl = 'https://' + config.snurl;
        // Remove trailing slash
        baseUrl = baseUrl.charAt(baseUrl.length - 1) == '/' ? baseUrl.left(baseUrl.length - 1) : baseUrl;
        oauthUrl = baseUrl + oauthEndpoint;
    }
    if (config.snlogin != null && config.snlogin.length > 0) {
        username = config.snlogin;
    }
    if (config.snpassword != null && config.snpassword.length > 0) {
        password = config.snpassword;
    }
    if (config.snOAuthClientId != null && config.snOAuthClientId.length > 0) {
        clientId = config.snOAuthClientId;
    }
    if (config.snOAuthClientSecretPassword != null && config.snOAuthClientSecretPassword.length > 0) {
        clientSecret = config.snOAuthClientSecretPassword;
    }
    if (config.snOAuthTokenGrantType != null && config.snOAuthTokenGrantType.length > 0) {
        grantType = config.snOAuthTokenGrantType;
    }
    if (config.snOAuthRefreshTokenpassword != null && config.snOAuthRefreshTokenpassword.length > 0) {
        oauthRefreshToken = config.snOAuthRefreshTokenpassword;
    }
    if (config.snOAuthScope != null && config.snOAuthScope.length > 0) {
        scope = config.snOAuthScope;
    }
    if (config.snOAuthRefreshExpirationDate != null && config.snOAuthRefreshExpirationDate.length > 0) {
        refreshExpirationDate = Date.fromLDAPString(config.snOAuthRefreshExpirationDate);
    }
    if (config.sndebug != null && config.sndebug.length > 0) {
        debug = 'true'.equalsIgnoreCase(config.sndebug.trim());
    }
    if (config.snProxyEnabled != null && config.snProxyEnabled.length > 0) {
        _proxyEnabled = 'true'.equalsIgnoreCase(config.snProxyEnabled.trim());
    }
    if (config.snProxyAuthenticated != null && config.snProxyAuthenticated.length > 0) {
        _proxyAuthenticated = 'true'.equalsIgnoreCase(config.snProxyAuthenticated.trim());
    }
    if (config.snProxyHost != null && config.snProxyHost.length > 0) {
        _proxyHost = config.snProxyHost;
    }
    if (config.snProxyUsername != null && config.snProxyUsername.length > 0) {
        _proxyUsername = config.snProxyUsername;
    }
    if (config.snProxyPassword != null && config.snProxyPassword.length > 0) {
        _proxyPassword = config.snProxyPassword;
    }
    if (config.snLocalServerHostname != null && config.snLocalServerHostname.length > 0) {
        _localServerHostname = config.snLocalServerHostname;
    }
    if (config.snProxyAuthenticationDomain != null && config.snProxyAuthenticationDomain.length > 0) {
        _proxyAuthenticationDomain = config.snProxyAuthenticationDomain;
    }
    if (config.snProxyPort != null && config.snProxyPort.length > 0) {
        _proxyPort = parseInt(config.snProxyPort, 10);
    }
    if (grantType == "refresh_token") createEmptyToken();
}

// Initialize the OAuth with the workflow variables, from the ITSM conf
function IniOAuthFromWorkflow(authenticationProperties) {
    if (httpdebug) print("Initializing OAuth with the workflow variables");
    oauthEnabled = true;

    baseUrl = authenticationProperties.domain;
    username = authenticationProperties.login;
    password = authenticationProperties.password;
    clientId = authenticationProperties.client_id;
    clientSecret = authenticationProperties.client_secret;
    grantType = authenticationProperties.token_grant_type;
    oauthRefreshToken = authenticationProperties.refresh_token;
    scope = authenticationProperties.scope;
    refreshExpirationDate = Date.fromLDAPString(authenticationProperties.refresh_token_expiration_date);
    oauthEndpoint = authenticationProperties.oauth_uri;

    // Remove slash
    baseUrl = baseUrl.charAt(baseUrl.length - 1) == '/' ? baseUrl.left(baseUrl.length - 1) : baseUrl;
    oauthEndpoint = oauthEndpoint.charAt(0) == '/' ? oauthEndpoint.right(oauthEndpoint.length - 1) : oauthEndpoint;

    // Build authentication URL
    oauthUrl = "https://" + baseUrl + "/" + oauthEndpoint;

    if (grantType == "refresh_token") createEmptyToken();

    // The Proxy configuration being used is still the one from the .configuration file, as well as the debug
    if (config.sndebug != null && config.sndebug.length > 0) {
        debug = 'true'.equalsIgnoreCase(config.sndebug.trim());
    }
    if (config.snProxyEnabled != null && config.snProxyEnabled.length > 0) {
        _proxyEnabled = 'true'.equalsIgnoreCase(config.snProxyEnabled.trim());
    }
    if (config.snProxyAuthenticated != null && config.snProxyAuthenticated.length > 0) {
        _proxyAuthenticated = 'true'.equalsIgnoreCase(config.snProxyAuthenticated.trim());
    }
    if (config.snProxyHost != null && config.snProxyHost.length > 0) {
        _proxyHost = config.snProxyHost;
    }
    if (config.snProxyUsername != null && config.snProxyUsername.length > 0) {
        _proxyUsername = config.snProxyUsername;
    }
    if (config.snProxyPassword != null && config.snProxyPassword.length > 0) {
        _proxyPassword = config.snProxyPassword;
    }
    if (config.snLocalServerHostname != null && config.snLocalServerHostname.length > 0) {
        _localServerHostname = config.snLocalServerHostname;
    }
    if (config.snProxyAuthenticationDomain != null && config.snProxyAuthenticationDomain.length > 0) {
        _proxyAuthenticationDomain = config.snProxyAuthenticationDomain;
    }
    if (config.snProxyPort != null && config.snProxyPort.length > 0) {
        _proxyPort = parseInt(config.snProxyPort, 10);
    }
}

// Current token (either initialized from Workflow variables or created/refreshed from Service Now)
var currentToken;

// Get Token value from Workflow variables
// 		When a new token is gathered from Service now, token values are set in Workflow variables
// 		in order to have persistant state in case of loop
if (!dataset.isEmpty('oauth_access_token')) {
	if(debug) print('Get token values from Workflow variables');

	// Create Token object
	currentToken = {};
	// Test values before setting (defensive approach)
	currentToken.access_token = (dataset.isEmpty('oauth_access_token'))?null:dataset.oauth_access_token.get();
	currentToken.refresh_token = (dataset.isEmpty('oauth_refresh_token'))?null:dataset.oauth_refresh_token.get();
	currentToken.expires_in = (dataset.isEmpty('oauth_expires_in'))?0:dataset.oauth_expires_in.get();
	currentToken.creationDate = (dataset.isEmpty('oauth_creation_date'))?null:dataset.oauth_creation_date.get();
}

function createEmptyToken() {
    if (debug) print('Create an empty token with the refresh token from the configuration');

    // Create Token object
    currentToken = {};
    currentToken.access_token = null;
    currentToken.refresh_token = oauthRefreshToken;
    currentToken.expires_in = 0;
    currentToken.creationDate = new Date();

    //validRefreshToken = new Date().diff(refreshExpirationDate, 's') < 0;
    //if (debug && validRefreshToken) print('The refresh token is still valid until the ' + refreshExpirationDate.toString());
}

function setupHttpProxy( /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder) {
    with(HttpClient) {
        if (_proxyEnabled) {
            if (debug) print("Proxy Enabled: http://" + _proxyHost + ":" + _proxyPort);
            var /*org.apache.http.HttpHost*/ proxy = new HttpHost(_proxyHost, _proxyPort);
            if (_proxyAuthenticated) {
                var /*org.apache.http.auth.NTCredentials*/ proxyCredentials = new NTCredentials(_proxyUsername, _proxyPassword, _localServerHostname, _proxyAuthenticationDomain);
                var /*org.apache.http.auth.AuthScope*/ proxyAuthScope = new AuthScope(_proxyHost, _proxyPort);
                var /*org.apache.http.client.CredentialsProvider*/ proxyCredsProvider = new BasicCredentialsProvider();
                proxyCredsProvider.setCredentials(proxyAuthScope, proxyCredentials);
                httpClientBuilder.setProxy(proxy).setDefaultCredentialsProvider(proxyCredsProvider);
            } else {
                httpClientBuilder.setProxy(proxy);
            }
        }
    }
}

/**
 * getOrRefreshToken: call Service Now to get a new token if current is empty (initial situation) or cannot be refreshed (refresh period reached).
 * A refreshed token is generated by calling Service Now if tokan age is between current token expiration time and refresh period
 * @return a OAuth Token object
 */
function getOrRefreshToken() {
    if (!oauthEnabled) {
        throw new Error("You cannot get/refresh token if OAuth2 authentication is not enabled");
    }
    
    //if (debug) print(String.format("Current token: %s", tokenString(currentToken)));
    try {
	    if (grantType == 'password') {
	        if (currentToken == null) {
	            if (debug) print('Current token is null => Create new token');
	            currentToken = getNewToken();
	            if (debug) print(String.format("New token created: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        } else if (isExpired(currentToken) && canRefresh(currentToken)) {
	            // Refresh Token
	            if (debug) print('Current token expired but not yet refreshed => Refresh current token');
	            currentToken = refreshToken(currentToken);
	            if (debug) print(String.format("Refreshed token: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        } else if (isExpired(currentToken) && !canRefresh(currentToken)) {
	            // Token has been refreshed and it is expired => ask for new token
	            if (debug) print('Refreshed token is expired => Create new token');
	            currentToken = getNewToken();
	            if (debug) print(String.format("New token created: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        } else {
	            if (debug) print(String.format("Token still valid: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        }
	    } else if (grantType == 'refresh_token') {
	        if (isExpired(currentToken)) {
	            // Refresh Token
	            if (debug) print('Current token expired but not yet refreshed => Refresh current token');
	            currentToken = refreshToken(currentToken);
	            if (debug) print(String.format("Refreshed token: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        } else {
	            if (debug) print(String.format("Token still valid: %s", tokenString(currentToken)));
	            updateTokenInWorkflow(currentToken);
	            return currentToken;
	        }
	    }
    }
    catch(e) {
    	throw e;
    }
}

/**
 * getNewToken: call Service Now to get a new token
 * @return a new OAuth Token object
 */
function getNewToken() {
    with(HttpClient) {
        var /*java.util.List*/ parametersBody = new java.util.ArrayList();

        parametersBody.add(new org.apache.http.message.BasicNameValuePair(GRANT_TYPE, GRANT_TYPE_PASSWORD));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(USERNAME, username));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(PASSWORD, password));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(CLIENT_ID, clientId));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(CLIENT_SECRET, clientSecret));
        if (isNotNull(scope)) {
            parametersBody.add(new org.apache.http.message.BasicNameValuePair(SCOPE, scope));
        }

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpClient = httpClientBuilder.build();

        try {
            var /*org.apache.http.client.methods.HttpPost*/ httpPost = new HttpPost(oauthUrl);
            if (debug) print("Requesting a new token on " + oauthUrl + " with the account " + username + " and the clientId " + clientId);
            var /*org.apache.http.client.entity.UrlEncodedFormEntity*/ entity = new org.apache.http.client.entity.UrlEncodedFormEntity(parametersBody);

            httpPost.setEntity(entity);
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpClient.execute(httpPost);

            return handleJsonResponse(response);
        } catch (e) {
            print('ERROR, could not get new Token: ' + e);
            throw e;
        } finally {
            if (httpClient != null) {
                httpClient.close();
            }
        }
    }
}

/**
 * refreshToken: call Service Now with current token to refresh
 * @param currentToken Current token
 * @return a refreshed OAuth Token object
 */
function refreshToken(currentToken) {
    if (currentToken == null) {
        return new Error("Unable to refresh token because no token was provided");
    }
    if (isBlankOrNull(currentToken.refresh_token)) {
        // Initial request returned no refresh token => Return same token
        return currentToken;
    }

    with(HttpClient) {
        var /*java.util.List*/ parametersBody = new java.util.ArrayList();

        parametersBody.add(new org.apache.http.message.BasicNameValuePair(GRANT_TYPE, GRANT_TYPE_REFRESH_TOKEN));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(REFRESH_TOKEN, currentToken.refresh_token));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(CLIENT_ID, clientId));
        parametersBody.add(new org.apache.http.message.BasicNameValuePair(CLIENT_SECRET, clientSecret));
        if (isNotNull(scope)) {
            parametersBody.add(new org.apache.http.message.BasicNameValuePair(SCOPE, scope));
        }

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpClient = httpClientBuilder.build();

        try {
            var /*org.apache.http.client.methods.HttpPost*/ httpPost = new HttpPost(oauthUrl);
            if (debug) print("Refreshing the token on " + oauthUrl + " with the clientId " + clientId);
            var /*org.apache.http.client.entity.UrlEncodedFormEntity*/ entity = new org.apache.http.client.entity.UrlEncodedFormEntity(parametersBody);

            httpPost.setEntity(entity);
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpClient.execute(httpPost);

            return handleJsonResponse(response);;
        } catch ( /*org.apache.http.client.ClientProtocolException*/ e) {
            throw e;
        } finally {
            if (httpClient != null) {
                httpClient.close();
            }
        }
    }
}

/**
 * handleJsonResponse: parse HTPP response (JSON object expected)
 * @param response Response from Service Now
 * @return a OAuth Token object (attributes: creationDate, access_token, refresh_token, expiresIn, scope, token_type)
 */
function handleJsonResponse( /*org.apache.http.HttpResponse*/ response) {
    var token;

    var httpResponseCode = response.getStatusLine().getStatusCode();
    if (debug) print('Response code from OAuth query: ' + httpResponseCode);
    with(HttpClient) {
        if (httpResponseCode != HTTP_OK) {
            var debugResponse = EntityUtils.toString(response.getEntity());
            print('Error ocurred during OAuth Token query. Cause: ' + httpResponseCode + '. Response: ' + debugResponse)
            throw new java.lang.RuntimeException('Error ocurred during OAuth Token query. Cause: ' + httpResponseCode + '. Response: ' + debugResponse);
        }

        // Protect against unavailable Web Service and HTML is responsed
        if (response.getEntity().getContentType() != null && response.getEntity().getContentType().getValue() != null) {
            var contentType = response.getEntity().getContentType().getValue();

            if (!contentType.contains(JSON_CONTENT)) {
                throw new java.lang.RuntimeException("Server response has wrong content type. Expected: application/json. Actual: " + contentType);
            }
        }

        try {
            var /*String*/ responseBody = EntityUtils.toString(response.getEntity());
            // JavaScript object (access_token, refresh_token, expires_in, scope, token_type)
            token = JSON.parse(responseBody);
            // Add creation date to manage token lifecycle
            token.creationDate = new Date();
        } catch ( /*Exception*/ e) {
            // Could not parse JSON response
            throw new java.lang.RuntimeException(e);
        }
    }

    return token;
}

function tokenString(token) {
    if (token == null) {
        return "[Token] Empty";
    }
    return java.lang.String.format("[Token] Created: %s, access_token: %s, refresh_token: %s, expiresIn: %s sec, scope:%s, token_type: %s",
        token.creationDate.toString(), token.access_token, token.refresh_token, token.expires_in, token.scope, token.token_type);
}

function isNotNull( /*java.lang.String*/ str) {
    return (str != null && str.trim().length > 0);
}

function isBlankOrNull( /*java.lang.String*/ str) {
    return (str == null || str.trim().length == 0);
}

function updateTokenInWorkflow( currentToken ) {
	if ( currentToken == null || undefined == typeof currentToken ) {
		return;	
	}
	if ( currentToken.access_token != null && undefined != currentToken.access_token ) {
		dataset.oauth_access_token.set( currentToken.access_token );
	}
	if ( currentToken.refresh_token != null && undefined != currentToken.refresh_token ) {
		dataset.oauth_refresh_token.set( currentToken.refresh_token );
	}
	if ( currentToken.expires_in != null && undefined != currentToken.expires_in ) {
		dataset.oauth_expires_in.set( currentToken.expires_in );
	}
	if ( currentToken.creationDate != null && undefined != currentToken.creationDate ) {
		dataset.oauth_creation_date.set( currentToken.creationDate );
	}
}

function isExpired(currentToken) {
    if (currentToken == null) {
        return true;
    }
    var elapsed = new Date().diff(currentToken.creationDate, 's');
    return elapsed >= currentToken.expires_in;
}

function canRefresh(currentToken) {
    return currentToken.refresh_token != null;
}