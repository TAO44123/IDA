import 'JSON.javascript';
import "../../resources/security.javascript"

var httpdebug = false;

var OK_REQUEST = '200';
var PING_FAILED = '000';
var JSON_CONTENT = 'application/json';

var javadependencies = JavaImporter(
	Packages.com.brainwave.itsm.JiraHelper
);

var HttpClient = JavaImporter(
	Packages.org.apache.http.auth.AuthScope,
	Packages.org.apache.http.auth.UsernamePasswordCredentials,
	Packages.org.apache.http.client.methods.CloseableHttpResponse,
	Packages.org.apache.http.client.methods.HttpGet,
	Packages.org.apache.http.impl.client.BasicCredentialsProvider,
	Packages.org.apache.http.impl.client.CloseableHttpClient,
	Packages.org.apache.http.impl.client.HttpClients,
	Packages.org.apache.http.entity.StringEntity,
	Packages.org.apache.http.util.EntityUtils,
	Packages.org.apache.http.impl.client.HttpClientBuilder
);

function pingJira() {
	var /*String*/ domain = dataset.domain.get(); 
	var /*String*/ login = dataset.login.get(); 
	var /*String*/ token = dataset.token.get(); 
	
	with(javadependencies) {
		var /*com.brainwave.itsm.JiraHelper*/ jh = new JiraHelper();
		var /*boolean*/ ping = jh.setBaseUrl(domain).setLogin(login).setToken(token).ping();
		if(!ping) {
			dataset.isalive.set(false);
			var errormessage = jh.getError();
			if(errormessage!=null) {
				print(errormessage);
				dataset.errormessage.set(errormessage);
			}
		}
		else {
			dataset.isalive.set(true);
		}
	}	
}

/**
 * encryptFields encrypts ALL generic ITSM attributes in the database
 * @return 
 */
function encryptDecryptFields() {
	var fields = [
					"string4",
					"string5",
					"string6",
					"string7",
					"string8",
					"string9",
					"string10",
					"string11",
					"string12",
					"string13",
					"string14",
					"string15",
					"string16",
					"string17",
					"string18",
					"string19",
					"string20"
				];	
	
	for (var i=0; i<fields.length;i++) {
		process(fields[i], dataset.get('decrypt'));	
	}
}
