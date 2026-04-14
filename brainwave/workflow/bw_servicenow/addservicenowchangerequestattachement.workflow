<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="addservicenowchangerequestattachement" displayname="add an attachment to a change request" description="add an attachment to a change request provided as a canonical file" scriptfile="/workflow/bw_servicenow/addservicenowchangerequestattachement.javascript" statictitle="add an attachment to a change request" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="44" y="65" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1474619161380"/>
		</Component>
		<Component name="CEND" type="endactivity" x="450" y="67" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1474617183869" priority="1"/>
		<Component name="C1474617183869" type="scriptactivity" x="179" y="41" w="200" h="98" title="add a text attachement">
			<Script onscriptexecute="addServiceNowTextAttachement"/>
		</Component>
		<Link name="L1474617488689" source="C1474617183869" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1445612127304" variable="domain" displayname="ServiceNow DNS domain" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow domain in the form of dev13745.service-now.com" notstoredvariable="false"/>
		<Variable name="A1445612244784" variable="login" displayname="the ServiceNow login" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow login to access the platform" notstoredvariable="false"/>
		<Variable name="A1445612260137" variable="password" displayname="the ServiceNow password" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow password to access the platform" notstoredvariable="false"/>
		<Variable name="A1445612319421" variable="short_description" displayname="short description" editortype="Default" type="String" multivalued="false" visibility="out" description="short description of the incident" notstoredvariable="false"/>
		<Variable name="A1445612526321" variable="debug" displayname="debug API calls" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="debug API calls through the console" initialvalue="false" notstoredvariable="false"/>
		<Variable name="A1445612562370" variable="result" displayname="result" editortype="Default" type="Boolean" multivalued="false" visibility="out" description="true if the call succeed, false otherwise" notstoredvariable="false"/>
		<Variable name="A1445612638184" variable="resultdescription" displayname="result description" editortype="Default" type="String" multivalued="false" visibility="out" description="in case of an error (see result), text associated with the error &#xA;(try the &apos;debug&apos; parameter to gain more information on the console)" notstoredvariable="false"/>
		<Variable name="A1445612697598" variable="ticketnumber" displayname="ServiceNow ticket number" editortype="Default" type="String" multivalued="false" visibility="out" description="ServiceNow incident generated ticket number (fancy number displayed to the user such as INC0010018)" notstoredvariable="false"/>
		<Variable name="A1445612754092" variable="ticketid" displayname="ServiceNow ticket ID" editortype="Default" type="String" multivalued="false" visibility="in" description="ServiceNow internal incident ticket ID (sys_id) generated, this id must be used for further ticket references through API calls" notstoredvariable="false"/>
		<Variable name="A1475328298337" variable="change_state" displayname="change state" editortype="Default" type="String" multivalued="false" visibility="out" description="ticket status as a string with a number:&#xA; * 1 New&#xA; * 2 Active&#xA; * 3 Awaiting Problem&#xA; * 4 Awaiting User Info&#xA; * 5 Awaiting Evidence&#xA; * 6 Resolved &#xA; * 7 Closed" notstoredvariable="false"/>
		<Variable name="A1475329298122" variable="attachmentcanonicalfile" displayname="attachment canonical file" editortype="Default" type="String" multivalued="false" visibility="in" description="attachment canonical file" notstoredvariable="false"/>
		<Variable name="A1571679935764" variable="oauth_access_token" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Access Token" description="This variable contains the OAuth2 Access Token used to execute requests"/>
		<Variable name="A1571679958555" variable="oauth_creation_date" editortype="Default" type="Date" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Token Creation Date" description="This variable contains the creation date of Access Token"/>
		<Variable name="A1571679980632" variable="oauth_expires_in" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Expires in (unit: second)" description="This variable contains the number of seconds the token is valid"/>
		<Variable name="A1571679998797" variable="oauth_refresh_token" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth 2 Refresh Token" description="This variable contains OAuth2 Refresh Token if access token has expired"/>
		<Variable name="A1746455041944" variable="authentication_type" displayname="Authentication type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The type of authentication used to connect to the SN instance (Basic, OAuth, OAuth from conf)"/>
		<Variable name="A1746455454068" variable="oauth_client_id" displayname="OAuth2 Client ID" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The ClientID used to connect with OAuth"/>
		<Variable name="A1746455466842" variable="oauth_client_secret_password" displayname="OAuth2 Client secret" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The secret of the ClientID used to connect with OAuth"/>
		<Variable name="A1746455473977" variable="oauth_grant_type" displayname="OAuth2 token grant type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The token grant type used with OAuth (password, refresh_token)"/>
		<Variable name="A1746455481795" variable="oauth_scope" displayname="OAuth2 scope" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The scope for OAuth"/>
		<Variable name="A1746455494262" variable="oauth_expiration_date" displayname="OAuth2 refresh token expiration date" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true" description="The expiration date of the refresh token used with OAuth"/>
	</Variables>
	<Roles>
		<Role name="A1474619161380" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1474619170228" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
