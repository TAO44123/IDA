<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="createservicenowincident" displayname="Create a ServiceNow incident" description="Create a ServiceNow incident" scriptfile="/workflow/bw_servicenow/createservicenowincident.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="43" y="120" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1445536956580"/>
			<FormVariable name="A1445613874275" variable="domain" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613877982" variable="login" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613882880" variable="password" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613886769" variable="short_description" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613892588" variable="impact" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613895901" variable="urgency" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613901831" variable="caller" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445710007277" variable="assigned_to" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445710012620" variable="assignment_group" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613905105" variable="due_date" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613909602" variable="comments" action="input" mandatory="false" longlist="false"/>
			<Init>
				<Actions>
				</Actions>
			</Init>
		</Component>
		<Component name="CEND" type="endactivity" x="542" y="120" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1445537018976" priority="1"/>
		<Component name="C1445537018976" type="scriptactivity" x="211" y="95" w="200" h="98" title="Create a ServiceNow incident">
			<Script onscriptexecute="createServiceNowIncident"/>
		</Component>
		<Link name="L1445537035530" source="C1445537018976" target="CEND" priority="1"/>
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
		<Variable name="A1445612319421" variable="short_description" displayname="short description" editortype="Default" type="String" multivalued="false" visibility="in" description="short description of the incident" notstoredvariable="false"/>
		<Variable name="A1445612335326" variable="impact" displayname="incident impact" editortype="Default" type="String" multivalued="false" visibility="in" description="incident impact as a numerical value (string) (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1445612362471" variable="urgency" displayname="incident urgency" editortype="Default" type="String" multivalued="false" visibility="in" description="incident urgency as a numerical value (string) (null to ignore this parameter) " notstoredvariable="false"/>
		<Variable name="A1445612384246" variable="due_date" displayname="incident due date" editortype="Default" type="Date" multivalued="false" visibility="in" description="incident due date as a Date  (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1445612428877" variable="caller" displayname="incident caller" editortype="Default" type="String" multivalued="false" visibility="in" description="the individual who delcared the incident (email address) (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1445612449194" variable="comments" displayname="incident comments" editortype="Default" type="String" multivalued="false" visibility="in" description="additional comments that could be seen by the customer (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1445612526321" variable="debug" displayname="debug API calls" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="debug API calls through the console" initialvalue="false" notstoredvariable="false"/>
		<Variable name="A1445612562370" variable="result" displayname="result" editortype="Default" type="Boolean" multivalued="false" visibility="out" description="true if the call succeed, false otherwise" notstoredvariable="false"/>
		<Variable name="A1445612638184" variable="resultdescription" displayname="result description" editortype="Default" type="String" multivalued="false" visibility="out" description="in case of an error (see result), text associated with the error &#xA;(try the &apos;debug&apos; parameter to gain more information on the console)" notstoredvariable="false"/>
		<Variable name="A1445612697598" variable="ticketnumber" displayname="ServiceNow ticket number" editortype="Default" type="String" multivalued="false" visibility="out" description="ServiceNow incident generated ticket number (fancy number displayed to the user such as INC0010018)" notstoredvariable="false"/>
		<Variable name="A1445612754092" variable="ticketid" displayname="ServiceNow ticket ID" editortype="Default" type="String" multivalued="false" visibility="out" description="ServiceNow internal incident ticket ID (sys_id) generated, this id must be used for further ticket references through API calls" notstoredvariable="false"/>
		<Variable name="A1445709961444" variable="assigned_to" displayname="incident assigned to" editortype="Default" type="String" multivalued="false" visibility="in" description="the individual on which this incident is assigned (email address) (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1445709991045" variable="assignment_group" displayname="incident assignment group" editortype="Default" type="String" multivalued="false" visibility="in" description="the group on which this incident is assigned (null to ignore this parameter)" notstoredvariable="false"/>
		<Variable name="A1474997452530" variable="customattributenames" displayname="custom attribute names" editortype="Default" type="String" multivalued="true" visibility="in" description="custom attribute names to add to the incident" notstoredvariable="false"/>
		<Variable name="A1474997475029" variable="customattributevalues" displayname="custom attribute values" editortype="Default" type="String" multivalued="true" visibility="in" description="custom attribute values to add to the ticket" notstoredvariable="false"/>
		<Variable name="A1564650438455" variable="oauth_access_token" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Access Token" description="This variable contains the OAuth2 Access Token used to execute requests"/>
		<Variable name="A1564650454549" variable="oauth_refresh_token" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth 2 Refresh Token" description="This variable contains OAuth2 Refresh Token if access token has expired"/>
		<Variable name="A1564650477767" variable="oauth_expires_in" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Expires in (unit: second)" description="This variable contains the number of seconds the token is valid"/>
		<Variable name="A1564650554530" variable="oauth_creation_date" editortype="Default" type="Date" multivalued="false" visibility="inout" notstoredvariable="true" displayname="OAuth2 Token Creation Date" description="This variable contains the ceation date of Access Token"/>
		<Variable name="A1746455041944" variable="authentication_type" displayname="Authentication type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The type of authentication used to connect to the SN instance (Basic, OAuth, OAuth from conf)"/>
		<Variable name="A1746455454068" variable="oauth_client_id" displayname="OAuth2 Client ID" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The ClientID used to connect with OAuth"/>
		<Variable name="A1746455466842" variable="oauth_client_secret_password" displayname="OAuth2 Client secret" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The secret of the ClientID used to connect with OAuth"/>
		<Variable name="A1746455473977" variable="oauth_grant_type" displayname="OAuth2 token grant type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The token grant type used with OAuth (password, refresh_token)"/>
		<Variable name="A1746455481795" variable="oauth_scope" displayname="OAuth2 scope" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The scope for OAuth"/>
		<Variable name="A1746455494262" variable="oauth_expiration_date" displayname="OAuth2 refresh token expiration date" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true" description="The expiration date of the refresh token used with OAuth"/>
	</Variables>
</Workflow>
