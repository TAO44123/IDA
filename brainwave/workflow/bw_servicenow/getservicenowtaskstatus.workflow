<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="getservicenowtaskstatus" displayname="Get a ServiceNow task status" description="Get a ServiceNow task status" scriptfile="/workflow/bw_servicenow/getservicenowtaskstatus.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="43" y="120" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1445536956580"/>
		</Component>
		<Component name="CEND" type="endactivity" x="542" y="120" w="200" h="98" title="End" compact="true"/>
		<Component name="C1445621549362" type="scriptactivity" x="227" y="95" w="200" h="98" title="get ServiceNow ticket status">
			<Script onscriptexecute="getServiceNowTicketStatus"/>
		</Component>
		<Link name="L1445621565647" source="C1445621549362" target="CEND" priority="1"/>
		<Link name="L1445621563613" source="CSTART" target="C1445621549362" priority="1"/>
		<Component name="N1656069736648" type="note" x="176" y="23" w="300" h="50" title="Handle both Incident and ChangeRequest"/>
	</Definition>
	<Roles>
		<Role name="A1445536956580" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1445536990127" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1445612127304" variable="domain" displayname="ServiceNow DNS domain" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow domain in the form of dev13745.service-now.com" notstoredvariable="false"/>
		<Variable name="A1445612244784" variable="login" displayname="the ServiceNow login" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow login to access the platform" notstoredvariable="false"/>
		<Variable name="A1445612260137" variable="password" displayname="the ServiceNow password" editortype="Default" type="String" multivalued="false" visibility="in" description="the ServiceNow password to access the platform" notstoredvariable="false"/>
		<Variable name="A1445612526321" variable="debug" displayname="debug API calls" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="debug API calls through the console" initialvalue="false" notstoredvariable="false"/>
		<Variable name="A1445612562370" variable="result" displayname="result" editortype="Default" type="Boolean" multivalued="false" visibility="out" description="true if the call succeed, false otherwise" notstoredvariable="false"/>
		<Variable name="A1445612638184" variable="resultdescription" displayname="result description" editortype="Default" type="String" multivalued="false" visibility="out" description="in case of an error (see result), text associated with the error &#xA;(try the &apos;debug&apos; parameter to gain more information on the console)" notstoredvariable="false"/>
		<Variable name="A1445612697598" variable="ticketnumber" displayname="ServiceNow ticket number" editortype="Default" type="String" multivalued="true" visibility="out" description="ServiceNow incident generated ticket number (fancy number displayed to the user such as INC0010018)" notstoredvariable="false"/>
		<Variable name="A1445612754092" variable="ticketid" displayname="ServiceNow ticket ID" editortype="Default" type="String" multivalued="true" visibility="in" description="ServiceNow internal incident ticket ID (sys_id) generated, this id must be used for further ticket references through API calls" notstoredvariable="false" initialvalue="b96360ee1bc01110b56f42e4cc4bcbd5">
		</Variable>
		<Variable name="A1445621445357" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="out" description="ticket status as a string with a number:&#xA; * 1 New&#xA; * 2 Active&#xA; * 3 Awaiting Problem&#xA; * 4 Awaiting User Info&#xA; * 5 Awaiting Evidence&#xA; * 6 Resolved &#xA; * 7 Closed" notstoredvariable="false"/>
		<Variable name="A1571679729946" variable="oauth_access_token" displayname="OAuth2 Access Token" editortype="Default" type="String" multivalued="false" visibility="inout" description="This variable contains the OAuth2 Access Token used to execute requests" notstoredvariable="true"/>
		<Variable name="A1571679780384" variable="oauth_creation_date" displayname="OAuth2 Token Creation Date" editortype="Default" type="Date" multivalued="false" visibility="inout" description="This variable contains the creation date of Access Token" notstoredvariable="true"/>
		<Variable name="A1571679843649" variable="oauth_expires_in" displayname="OAuth2 Expires in (unit: second)" editortype="Default" type="Number" multivalued="false" visibility="inout" description="This variable contains the number of seconds the token is valid" notstoredvariable="true"/>
		<Variable name="A1571679913989" variable="oauth_refresh_token" displayname="OAuth 2 Refresh Token" editortype="Default" type="String" multivalued="false" visibility="inout" description="This variable contains OAuth2 Refresh Token if access token has expired" notstoredvariable="true"/>
		<Variable name="A1655362105135" variable="statusStr" displayname="statusStr" editortype="Default" type="String" multivalued="true" visibility="out" description="status as a pretty string" notstoredvariable="false"/>
		<Variable name="A1655364048219" variable="externalid" displayname="externalid" editortype="Default" type="Number" multivalued="true" visibility="in" description="external id associated with the servicenow ticketid&#xA;can be for instance a ticketreview or a ticketlog recorduid, used to update the status accordingly&#xA;&#xA;This parameter is not mandatory" notstoredvariable="true"/>
		<Variable name="A1655365247552" variable="ticketupdatedatetime" displayname="ticketupdatedatetime" editortype="Default" type="String" multivalued="true" visibility="out" description="date&amp;time the ticket status was retrieved (yyyMMddHHmmss format)" notstoredvariable="false"/>
		<Variable name="A1655366362375" variable="statusclosed" displayname="statusclosed" editortype="Default" type="String" multivalued="true" visibility="out" description="0 = ticket is still open&#xA;1 = ticket is closed, action has been done&#xA;2 = ticket is closed, action has been cancelled" notstoredvariable="false"/>
		<Variable name="A1655371107218" variable="retticketid" displayname="retticketid" editortype="Default" type="String" multivalued="true" visibility="out" notstoredvariable="false"/>
		<Variable name="A1656078816987" variable="inticketnumber" displayname="inticketnumber" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455041944" variable="authentication_type" displayname="Authentication type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The type of authentication used to connect to the SN instance (Basic, OAuth, OAuth from conf)"/>
		<Variable name="A1746455454068" variable="oauth_client_id" displayname="OAuth2 Client ID" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The ClientID used to connect with OAuth"/>
		<Variable name="A1746455466842" variable="oauth_client_secret_password" displayname="OAuth2 Client secret" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The secret of the ClientID used to connect with OAuth"/>
		<Variable name="A1746455473977" variable="oauth_grant_type" displayname="OAuth2 token grant type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The token grant type used with OAuth (password, refresh_token)"/>
		<Variable name="A1746455481795" variable="oauth_scope" displayname="OAuth2 scope" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The scope for OAuth"/>
		<Variable name="A1746455494262" variable="oauth_expiration_date" displayname="OAuth2 refresh token expiration date" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true" description="The expiration date of the refresh token used with OAuth"/>
	</Variables>
</Workflow>
