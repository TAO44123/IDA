<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="getservicenowsysid" displayname="Get a ServiceNow sys_id for a given object" description="Get a ServiceNow sys_id value for a given object. You have to provide the table, the attribute name and the attribute value to search for.&#xA;If several results are found, the first object sys_id will be returned.&#xA;This is useful when updating reference values such as the caller, ..." scriptfile="/workflow/bw_servicenow/getservicenowsysid.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="43" y="120" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1445536956580"/>
			<FormVariable name="A1445613874275" variable="domain" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613877982" variable="login" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1445613882880" variable="password" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="542" y="120" w="200" h="98" title="End" compact="true"/>
		<Component name="C1445621549362" type="scriptactivity" x="227" y="95" w="200" h="98" title="get ServiceNow sys_id">
			<Script onscriptexecute="getServiceSysId"/>
		</Component>
		<Link name="L1445621563613" source="CSTART" target="C1445621549362" priority="1"/>
		<Link name="L1445621565647" source="C1445621549362" target="CEND" priority="1"/>
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
		<Variable name="A1474986917434" variable="sys_id" displayname="the servicenow object sys_id" editortype="Default" type="String" multivalued="false" visibility="out" description="the servicenow object sys_id" notstoredvariable="false"/>
		<Variable name="A1474986941099" variable="table" displayname="servicenow table" editortype="Default" type="String" multivalued="false" visibility="in" description="the servicenow table to query the sys_id for" notstoredvariable="false"/>
		<Variable name="A1474987068937" variable="attributeName" displayname="servicenow attribute name" editortype="Default" type="String" multivalued="false" visibility="in" description="the servicenow attribute name for the query" notstoredvariable="false"/>
		<Variable name="A1474987083483" variable="attributeValue" displayname="servicenow attribute value" editortype="Default" type="String" multivalued="false" visibility="in" description="the servicenow attribute value for the query" notstoredvariable="false"/>
		<Variable name="A1746455041944" variable="authentication_type" displayname="Authentication type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The type of authentication used to connect to the SN instance (Basic, OAuth, OAuth from conf)"/>
		<Variable name="A1746455454068" variable="oauth_client_id" displayname="OAuth2 Client ID" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The ClientID used to connect with OAuth"/>
		<Variable name="A1746455466842" variable="oauth_client_secret_password" displayname="OAuth2 Client secret" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The secret of the ClientID used to connect with OAuth"/>
		<Variable name="A1746455473977" variable="oauth_grant_type" displayname="OAuth2 token grant type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The token grant type used with OAuth (password, refresh_token)"/>
		<Variable name="A1746455481795" variable="oauth_scope" displayname="OAuth2 scope" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The scope for OAuth"/>
		<Variable name="A1746455494262" variable="oauth_expiration_date" displayname="OAuth2 refresh token expiration date" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true" description="The expiration date of the refresh token used with OAuth"/>
		<Variable name="A1746515165783" variable="oauth_refresh_token" displayname="OAuth 2 Refresh Token" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746515176635" variable="oauth_expires_in" displayname="OAuth2 Expires in (unit: second)" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
