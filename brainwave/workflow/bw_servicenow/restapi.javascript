/**
 * base HTTP requests with BasicCredentialsProvider and JSON response format 
 *
 * Copyright Brainwave
 */

import "JSON.javascript"
import "oauth.javascript";

var httpdebug = false;
var /*boolean*/ oauthEnabled = false;
var /*boolean*/ _proxyEnabled = false;
var /*boolean*/ _proxyAuthenticated = false;
var /*String*/ _proxyHost = '';
var /*String*/ _proxyUsername = '';
var /*String*/ _proxyPassword = '';
var /*String*/ _localServerHostname = '';
var /*String*/ _proxyAuthenticationDomain = '';
var _proxyPort;

// Authorization Header
var AUTHORIZATION = "Authorization";
// Token type to add in authorization header
var BEARER = "Bearer";
var JSON_CONTENT = "application/json";

/**
 * Java packages used by the HTTP methods
 */
var HttpClient = JavaImporter(
    Packages.org.apache.http.HttpException,
    Packages.org.apache.http.HttpHost,
    Packages.org.apache.http.auth.AuthScope,
    Packages.org.apache.http.auth.UsernamePasswordCredentials,
    Packages.org.apache.http.client.CredentialsProvider,
    Packages.org.apache.http.client.methods.CloseableHttpResponse,
    Packages.org.apache.http.client.methods.HttpGet,
    Packages.org.apache.http.client.methods.HttpPost,
    Packages.org.apache.http.client.methods.HttpPut,
    Packages.org.apache.http.client.methods.HttpPatch,
    Packages.org.apache.http.client.methods.HttpDelete,
    Packages.org.apache.http.impl.client.BasicCredentialsProvider,
    Packages.org.apache.http.impl.client.CloseableHttpClient,
    Packages.org.apache.http.impl.client.HttpClients,
    Packages.org.apache.http.entity.StringEntity,
    Packages.org.apache.http.entity.ContentType,
    Packages.org.apache.http.util.EntityUtils,
    Packages.org.apache.http.impl.client.HttpClientBuilder,
    Packages.org.apache.http.auth.Credentials,
    Packages.org.apache.http.auth.NTCredentials,
    Packages.org.apache.http.entity.mime.MultipartEntityBuilder,
    Packages.org.apache.http.entity.mime.MultipartEntity,
    Packages.org.apache.http.entity.mime.HttpMultipartMode,
    Packages.org.apache.http.entity.mime.content.FileBody,
    Packages.org.apache.http.entity.mime.content.StringBody,
    Packages.org.apache.http.entity.mime.content.ContentBody
);

function IniRestApi() {
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

function IniOAuthConditional(authenticationProperties) {
    if (httpdebug) print("Initializing the OAuth variables: " + authenticationProperties.authentication_type);
    if (authenticationProperties.authentication_type == 'OAuth') {
        oauthEnabled = true;
        // Initialize the OAuth configuration from the ITSM configured in the portal
        IniOAuthFromWorkflow(authenticationProperties);
    } else if (authenticationProperties.authentication_type.match(/^OAuth.*/)) {
        oauthEnabled = true;
        // Initialize the OAuth configuration from the project configuration variables
        IniOAuth();
    }
}

// Explicitely call the initialization function if using the library from a WebService 
IniRestApi();
if (config.sndebug) setHttpDebug();

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
 * enable debug mode: all requests will be printed to the console
 * 
 * @return 
 */
function setHttpDebug() {
    httpdebug = true;
}

/**
 * disable debug mode: nothing will be printed to the console
 * 
 * @return 
 */
function clearHttpDebug() {
    httpdebug = false;
}

/**
 * httpGET HTTP GET method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @return answer as a JSON object
 */
function httpGET(authenticationProperties, uri) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            // Call Service Now to get OAuth Token
            httpclient = httpClientBuilder.build();
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpGet*/ httpget = new HttpGet(domain + uri);

        httpget.setHeader("Accept", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            if (currentToken != null && undefined != typeof currentToken && currentToken.access_token != null && undefined != typeof currentToken.access_token) {
                httpget.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
            }
        }

        if (httpdebug) print("Executing request: " + httpget.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));

        var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpget);
        if (httpdebug) print("----------------------------------------");
        if (httpdebug) print(response.getStatusLine().toString());
        var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
        if (httpdebug) print(responseBody);
        response.close();
        httpclient.close();

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}

/**
 * httpPOST HTTP POST method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @param jrequest parameters as a JSON object
 * @return answer as a JSON object
 */
function httpPOST(authenticationProperties, uri, jrequest) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            httpclient = httpClientBuilder.build();
            // Call Service Now to get OAuth Token
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        // stringify the parameters
        var message = null;
        if (jrequest != null) {
            message = JSON.stringify(jrequest);
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpPost*/ httpPost = new HttpPost(domain + uri);
        httpPost.setHeader("Accept", JSON_CONTENT);
        httpPost.setHeader("Content-Type", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            if (currentToken != null && undefined != typeof currentToken && currentToken.access_token != null && undefined != typeof currentToken.access_token) {
                httpPost.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
            }
        }

        var entity = new org.apache.http.entity.StringEntity(message);
        httpPost.setEntity(entity);

        if (httpdebug) print("Executing request: " + httpPost.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        if (httpdebug) print("with: " + message);
        try {
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpPost);
            if (httpdebug) print("----------------------------------------");
            if (httpdebug) print(response.getStatusLine().toString());
            var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
            if (httpdebug) print(responseBody);
        } catch (e) {
            print('ERROR: could not do HTTP Post: ' + e.message);
            return e;
        } finally {
        	if (response != null) response.close();
            if (httpclient != null) httpclient.close();
        }

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}

/**
 * httpPOST_textAttachment HTTP POST TEXT ATTACHMENT method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @param filecontent raw content of the file
 * @return answer as a JSON object
 */
function httpPOST_textAttachment(authenticationProperties, uri, filecontent) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            httpclient = httpClientBuilder.build();
            // Call Service Now to get OAuth Token
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpPost*/ httpPost = new HttpPost(domain + uri);
        httpPost.setHeader("Accept", JSON_CONTENT);
        httpPost.setHeader("Content-Type", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            if (currentToken != null && undefined != typeof currentToken && currentToken.access_token != null && undefined != typeof currentToken.access_token) {
                httpPost.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
            }
        }

        var entity = new org.apache.http.entity.StringEntity(filecontent, org.apache.http.entity.ContentType.TEXT_PLAIN);
        httpPost.setEntity(entity);

        if (httpdebug) print("Executing request: " + httpPost.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        if (httpdebug) print("with: " + filecontent);
        try {
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpPost);
            if (httpdebug) print("----------------------------------------");
            if (httpdebug) print(response.getStatusLine().toString());
            var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
            if (httpdebug) print(responseBody);
        } catch (e) {
            print('ERROR: could not do HTTP Post: ' + e.message);
            return e;
        } finally {
        	if (response != null) response.close();
            if (httpclient != null) httpclient.close();
        }

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}

/**
 * httpPOST_FILE HTTP POST FILE method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @param jrequest parameters as a JSON object
 * @param canonicalpath attachment file path
 * @return answer as a JSON object
 */
function httpPOST_FILE(authenticationProperties, uri, jrequest, canonicalpath) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            httpclient = httpClientBuilder.build();
            // Call Service Now to get OAuth Token
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        // Create the multipart entity builder
        var /*org.apache.http.entity.mime.MultipartEntityBuilder*/ builder = MultipartEntityBuilder.create();
        builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);

        // Set the string parameters in the builder
        for (var key in jrequest) {
            builder.addTextBody(key, jrequest[key])
            if (httpdebug) print("Setting the body parameters : " + key + " - " + jrequest[key]);
        }

        // Attach the file in the builder 
        var /*File*/ file = new java.io.File(canonicalpath);
        try {
            if (file.canRead()) {
                if (httpdebug) print("File can be read");
            }
        } catch (e) {
            if (httpdebug) print("File can't be read : " + canonicalpath);
            return "Attachment file not found";
        }
        builder.addPart("file", new FileBody(file));

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpPost*/ httpPost = new HttpPost(domain + uri);
        httpPost.setHeader("Accept", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            if (currentToken != null && undefined != typeof currentToken && currentToken.access_token != null && undefined != typeof currentToken.access_token) {
                httpPost.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
            }
        }

        // Set the multipart entity builder in the request 
        var /*HttpEntity*/ entity = builder.build();
        httpPost.setEntity(entity);

        if (httpdebug) print("Executing request: " + httpPost.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        try {
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpPost);
            if (httpdebug) print("----------------------------------------");
            if (httpdebug) print(response.getStatusLine().toString());
            var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
            if (httpdebug) print(responseBody);
        } catch (e) {
            print('ERROR: could not do HTTP Post: ' + e.message);
            return e;
        } finally {
        	if (response != null) response.close();
            if (httpclient != null) httpclient.close();
        }

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}

/**
 * httpPUT HTTP PUT method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @param jrequest parameters as a JSON object
 * @return answer as a JSON object
 */
function httpPUT(authenticationProperties, uri, jrequest) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            // Call Service Now to get OAuth Token
            httpclient = httpClientBuilder.build();
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        // stringify the parameters
        var message = null;
        if (jrequest != null) {
            message = JSON.stringify(jrequest);
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /* org.apache.http.client.methods.HttpPut */ httpPut = new HttpPut(domain + uri);
        httpPut.setHeader("Accept", JSON_CONTENT);
        httpPut.setHeader("Content-Type", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            httpPut.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
        }
        var entity = new org.apache.http.entity.StringEntity(message);
        httpPut.setEntity(entity);

        if (httpdebug) print("Executing request: " + httpPut.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        if (httpdebug) print("with: " + message);
        var /* org.apache.http.client.methods.CloseableHttpResponse */ response = httpclient.execute(httpPut);
        if (httpdebug) print("----------------------------------------");
        if (httpdebug) print(response.getStatusLine().toString());
        var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
        if (httpdebug) print(responseBody);
        response.close();
        httpclient.close();

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}


/**
 * httpPATCH HTTP PATCH method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @param jrequest parameters as a JSON object
 * @return answer as a JSON object
 */
function httpPatch(authenticationProperties, uri, jrequest) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            // Call Service Now to get OAuth Token
            httpclient = httpClientBuilder.build();
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        // stringify the parameters
        var message = null;
        if (jrequest != null) {
            message = JSON.stringify(jrequest);
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpPatch*/ httpPatch = new HttpPatch(domain + uri);
        httpPatch.setHeader("Accept", JSON_CONTENT);
        httpPatch.setHeader("Content-Type", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            httpPatch.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
        }
        var entity = new org.apache.http.entity.StringEntity(message);
        httpPatch.setEntity(entity);

        if (httpdebug) print("Executing request " + httpPatch.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        if (httpdebug) print("with: " + message);
        var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpPatch);
        if (httpdebug) print("----------------------------------------");
        if (httpdebug) print(response.getStatusLine().toString());
        var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(response.getEntity());
        if (httpdebug) print(responseBody);
        response.close();
        httpclient.close();

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return resp;
    }
}


/**
 * httpDELETE HTTP DELETE method
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @return answer as a JSON object
 */
function httpDELETE(authenticationProperties, uri) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            // Call Service Now to get OAuth Token
            httpclient = httpClientBuilder.build();
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpDelete*/ httpDelete = new HttpDelete(domain + uri);
        httpDelete.setHeader("Accept", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            httpDelete.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
        }
        if (httpdebug) print("Executing request: " + httpDelete.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));
        var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpDelete);
        if (httpdebug) print("----------------------------------------");
        if (httpdebug) print(response.getStatusLine().toString());
        var responseJSON = {};
        var entity = response.getEntity();
        if (entity != null) {
            var /*String*/ responseBody = org.apache.http.util.EntityUtils.toString(entity);
            if (httpdebug) print(responseBody);

            try {
                responseJSON = JSON.parse(responseBody);
            } catch (e) {
                print("Error, invalid response: it is not a valid JSON document");
            }
        }

        response.close();
        httpclient.close();
        return responseJSON;
    }
}

/**
 * httpGETPing HTTP GET method without any authentification nor Uri to test if the server is reachable
 * 
 * @param domain DNS domain
 * @return response code, reason and body
 */
function httpGETPing(domain) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        httpclient = httpClientBuilder.build()

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpGet*/ httpget = new HttpGet(domain);

        httpget.setHeader("Accept", JSON_CONTENT);

        if (httpdebug) print("Executing request: " + httpget.getRequestLine());

        try {
            var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpget);

            var /*String*/ responseCode = response.getStatusLine().getStatusCode();
            var /*String*/ responseReason = response.getStatusLine().getReasonPhrase();
            var /*String*/ responseBody = EntityUtils.toString(response.getEntity(), 'UTF-8');

            if (httpdebug) print("----------------------------------------");
            if (httpdebug) print("Response code : " + responseCode);
            if (httpdebug) print("Response reason : " + responseReason);
            response.close();
            httpclient.close();
        } catch (e) {
            print('ERROR: could not do HTTP Get: ' + e.message);
            return e;
        } finally {
        	if (response != null) response.close();
            if (httpclient != null) httpclient.close();
        }

        return {code: responseCode, reason: responseReason, body: responseBody};
    }
}

/**
 * httpGETReadTables HTTP GET method to test is tables are at least readable
 * 
 * @param authenticationProperties object containing the domain and parameters needed for the authentication 
 * @param uri URI
 * @return response code, reason and body
 */
function httpGETReadTables(authenticationProperties, uri) {
    with(HttpClient) {
        var /*org.apache.http.impl.client.CloseableHttpClient*/ httpclient;
        var currentToken;

        var domain = authenticationProperties.domain;
        var login = authenticationProperties.login;
        var password = authenticationProperties.password;

        var /*org.apache.http.impl.client.HttpClientBuilder*/ httpClientBuilder = HttpClients.custom();
        setupHttpProxy(httpClientBuilder);

        IniOAuthConditional(authenticationProperties);
        if (oauthEnabled) {
            // Call Service Now to get OAuth Token
            httpclient = httpClientBuilder.build();
            try {
            	currentToken = getOrRefreshToken();
            }
            catch(e) {
            	return e;	
            }
        } else {
            var /*org.apache.http.impl.client.BasicCredentialsProvider*/ credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                new AuthScope(new org.apache.http.HttpHost(domain)),
                new UsernamePasswordCredentials(login, password));
            httpclient = httpClientBuilder.setDefaultCredentialsProvider(credsProvider).build();
        }

        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
            domain = 'https://' + domain;
        }
        var /*org.apache.http.client.methods.HttpGet*/ httpget = new HttpGet(domain + uri);

        httpget.setHeader("Accept", JSON_CONTENT);
        if (oauthEnabled) {
            // Add authorization header
            if (currentToken != null && undefined != typeof currentToken && currentToken.access_token != null && undefined != typeof currentToken.access_token) {
                httpget.setHeader(AUTHORIZATION, java.lang.String.format("%s %s", BEARER, currentToken.access_token));
            }
        }

        if (httpdebug) print("Executing request: " + httpget.getRequestLine());
        if (httpdebug && oauthEnabled) print('Using OAuth Token: ' + tokenString(currentToken));

        var /*org.apache.http.client.methods.CloseableHttpResponse*/ response = httpclient.execute(httpget);

        var /*String*/ responseCode = response.getStatusLine().getStatusCode();
        var /*String*/ responseReason = response.getStatusLine().getReasonPhrase();
        var /*String*/ responseBody = EntityUtils.toString(response.getEntity(), 'UTF-8');

        if (httpdebug) print("----------------------------------------");
        if (httpdebug) print("Response code : " + responseCode);
        if (httpdebug) print("Response reason : " + responseReason);
        response.close();
        httpclient.close();

        var resp = null
        try {
            resp = JSON.parse(responseBody);
        } catch (e) {
            print("Error, invalid response: it is not a valid JSON document");
        }

        return {code: responseCode, reason: responseReason, body: responseBody};
    }
}