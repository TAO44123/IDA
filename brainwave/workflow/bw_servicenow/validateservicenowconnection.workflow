<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_validateservicenowconnection" scriptfile="workflow/bw_servicenow/validateservicenowconnection.javascript" displayname="Create a test ServiceNow ticket and attach a file" description="Create a test ServiceNow ticket and attach a file">
		<Component name="CSTART" type="startactivity" x="510" y="34" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="process_tickettype"/>
				<Attribute name="custom1" attribute="serverReachable"/>
				<Attribute name="custom2" attribute="ticketTableReadable"/>
				<Attribute name="custom3" attribute="attachmentTableReadable"/>
				<Attribute name="custom4" attribute="ticketCreated"/>
				<Attribute name="custom5" attribute="attachmentCreated"/>
				<Attribute name="custom6" attribute="ticketnumber"/>
				<Attribute name="custom7" attribute="errormessage_ping"/>
				<Attribute name="custom8" attribute="errormessage_ticket_type"/>
				<Attribute name="custom9" attribute="errormessage_attachment"/>
			</Ticket>
			<Candidates name="role" role="A1681224823449"/>
			<Actions>
			</Actions>
		</Component>
		<Component name="CEND_1" type="endactivity" x="510" y="509" w="200" h="98" title="End" compact="true" inexclusive="true">
		</Component>
		<Component name="C1657213080222_1" type="variablechangeactivity" x="748" y="106" w="300" h="98" title="Attachment content and name">
			<Actions>
				<Action name="U1657213215165" action="update" attribute="changefilename" newvalue="Changerequest.csv"/>
				<Action name="U1681480825445" action="update" attribute="changecsv" newvalue="Mock content for ServiceNow"/>
			</Actions>
		</Component>
		<Component name="C1655449520979_1" type="routeactivity" x="510" y="131" w="300" h="50" compact="true" title="Route 2" inexclusive="false" outexclusive="true"/>
		<Component name="C1655282499443_2" type="callactivity" x="40" y="294" w="300" h="98" title="create incident" outexclusive="true">
			<Process workflowfile="/workflow/bw_servicenow/createservicenowincident.workflow">
				<Input name="A1655282560878" variable="domain" content="domain"/>
				<Input name="A1655282569491" variable="login" content="login"/>
				<Input name="A1655282578549" variable="password" content="password"/>
				<Input name="A1655282623309" variable="short_description" content="changetitle"/>
				<Input name="A1655282634446" variable="comments" content="changedescription"/>
				<Input name="A1655282647426" variable="debug" content="debug"/>
				<Output name="A1655282684966" variable="ticketid" content="ticketid"/>
				<Output name="A1655282697597" variable="ticketnumber" content="ticketnumber"/>
				<Output name="A1655282705413" variable="result" content="ticketCreated"/>
				<Input name="A1655389667500" variable="caller" content="callersysid"/>
				<Input name="A1655390271452" variable="assignment_group" content="assignmentgroupsysid"/>
				<Output name="A1681222805094" variable="resultdescription" content="errormessage_ticket_type"/>
				<Input name="A1746458614204" variable="authentication_type" content="authentication_type"/>
				<Input name="A1746458626933" variable="oauth_client_id" content="oauth_client_id"/>
				<Input name="A1746458632803" variable="oauth_client_secret_password" content="oauth_client_secret_password"/>
				<Input name="A1746458648320" variable="oauth_grant_type" content="oauth_grant_type"/>
				<Input name="A1746458659589" variable="oauth_refresh_token" content="oauth_refresh_token"/>
				<Input name="A1746458670857" variable="oauth_expiration_date" content="oauth_expiration_date"/>
				<Input name="A1746458708858" variable="oauth_expires_in" content="oauth_expires_in"/>
			</Process>
		</Component>
		<Component name="C1657213098824_1" type="variablechangeactivity" x="40" y="106" w="300" h="98" title="Attachment content and name">
			<Actions>
				<Action name="U1657213197377" action="update" attribute="changefilename" newvalue="Incident.csv"/>
				<Action name="U1681222092131" action="update" attribute="changecsv" newvalue="Mock content for ServiceNow"/>
			</Actions>
		</Component>
		<Component name="C1655282499443_3" type="callactivity" x="748" y="294" w="300" h="98" title="Create change request" outexclusive="true">
			<Process workflowfile="/workflow/bw_servicenow/createservicenowchangerequest.workflow">
				<Input name="A1655282560878" variable="domain" content="domain"/>
				<Input name="A1655282569491" variable="login" content="login"/>
				<Input name="A1655282578549" variable="password" content="password"/>
				<Input name="A1655282623309" variable="short_description" content="changetitle"/>
				<Input name="A1655282634446" variable="comments" content="changedescription"/>
				<Input name="A1655282647426" variable="debug" content="debug"/>
				<Output name="A1655282684966" variable="ticketid" content="ticketid"/>
				<Output name="A1655282697597" variable="ticketnumber" content="ticketnumber"/>
				<Output name="A1655282705413" variable="result" content="ticketCreated"/>
				<Input name="A1655389667500" variable="caller" content="callersysid"/>
				<Input name="A1655390271452" variable="assignment_group" content="assignmentgroupsysid"/>
				<Output name="A1681481040422" variable="resultdescription" content="errormessage_ticket_type"/>
				<Input name="A1746458614204" variable="authentication_type" content="authentication_type"/>
				<Input name="A1746458626933" variable="oauth_client_id" content="oauth_client_id"/>
				<Input name="A1746458632803" variable="oauth_client_secret_password" content="oauth_client_secret_password"/>
				<Input name="A1746458648320" variable="oauth_grant_type" content="oauth_grant_type"/>
				<Input name="A1746458659589" variable="oauth_refresh_token" content="oauth_refresh_token"/>
				<Input name="A1746458670857" variable="oauth_expiration_date" content="oauth_expiration_date"/>
				<Input name="A1746458708858" variable="oauth_expires_in" content="oauth_expires_in"/>
			</Process>
		</Component>
		<Component name="C1655283825990_2" type="callactivity" x="40" y="484" w="300" h="98" title="Add attachment">
			<Process workflowfile="/workflow/bw_servicenow/addservicenowincidenttextattachement.workflow">
				<Input name="A1655283908764" variable="domain" content="domain"/>
				<Input name="A1655283914472" variable="login" content="login"/>
				<Input name="A1655283921086" variable="password" content="password"/>
				<Input name="A1655283938828" variable="attachmentcontent" content="changecsv"/>
				<Input name="A1655283948685" variable="attachmentfilename" content="changefilename"/>
				<Input name="A1655283957385" variable="ticketid" content="ticketid"/>
				<Input name="A1655283965667" variable="debug" content="debug"/>
				<Output name="A1681223796924" variable="result" content="attachmentCreated"/>
				<Output name="A1681223807112" variable="ticketnumber" content="attachmentnumber"/>
				<Input name="A1746458614204" variable="authentication_type" content="authentication_type"/>
				<Input name="A1746458626933" variable="oauth_client_id" content="oauth_client_id"/>
				<Input name="A1746458632803" variable="oauth_client_secret_password" content="oauth_client_secret_password"/>
				<Input name="A1746458648320" variable="oauth_grant_type" content="oauth_grant_type"/>
				<Input name="A1746458659589" variable="oauth_refresh_token" content="oauth_refresh_token"/>
				<Input name="A1746458670857" variable="oauth_expiration_date" content="oauth_expiration_date"/>
				<Input name="A1746458708858" variable="oauth_expires_in" content="oauth_expires_in"/>
			</Process>
		</Component>
		<Component name="C1655283825990_3" type="callactivity" x="748" y="484" w="300" h="98" title="Add attachment">
			<Process workflowfile="/workflow/bw_servicenow/addservicenowchangerequesttextattachement.workflow">
				<Input name="A1655283908764" variable="domain" content="domain"/>
				<Input name="A1655283914472" variable="login" content="login"/>
				<Input name="A1655283921086" variable="password" content="password"/>
				<Input name="A1655283938828" variable="attachmentcontent" content="changecsv"/>
				<Input name="A1655283948685" variable="attachmentfilename" content="changefilename"/>
				<Input name="A1655283957385" variable="ticketid" content="ticketid"/>
				<Input name="A1655283965667" variable="debug" content="debug"/>
				<Output name="A1681481009434" variable="result" content="attachmentCreated"/>
				<Output name="A1681481028276" variable="ticketnumber" content="attachmentnumber"/>
				<Input name="A1746458614204" variable="authentication_type" content="authentication_type"/>
				<Input name="A1746458626933" variable="oauth_client_id" content="oauth_client_id"/>
				<Input name="A1746458632803" variable="oauth_client_secret_password" content="oauth_client_secret_password"/>
				<Input name="A1746458648320" variable="oauth_grant_type" content="oauth_grant_type"/>
				<Input name="A1746458659589" variable="oauth_refresh_token" content="oauth_refresh_token"/>
				<Input name="A1746458670857" variable="oauth_expiration_date" content="oauth_expiration_date"/>
				<Input name="A1746458708858" variable="oauth_expires_in" content="oauth_expires_in"/>
			</Process>
		</Component>
		<Link name="L1657213092265_1" source="C1657213080222_1" target="C1655282499443_3" priority="1"/>
		<Link name="L1655449556458_1" source="C1655449520979_1" target="C1657213098824_1" priority="2" expression="(dataset.equals(&apos;process_tickettype&apos;, &apos;bwr_validateservicenowconnection_incident&apos;, false, true))" labelcustom="true" label="test incident"/>
		<Link name="L1656063830435_1" source="C1655449520979_1" target="C1657213080222_1" priority="3" expression="(dataset.equals(&apos;process_tickettype&apos;, &apos;bwr_validateservicenowconnection_changerequest&apos;, false, true))" labelcustom="true" label="test change request"/>
		<Link name="L1507032744612_2" source="C1655282499443_2" target="C1655283825990_2" priority="1" expression="dataset.ticketCreated.get()" labelcustom="true" label="Ticket created"/>
		<Link name="L1655224077815_1" source="C1655282499443_2" target="CEND_1" priority="2"/>
		<Link name="L1657213106526_1" source="C1657213098824_1" target="C1655282499443_2" priority="1"/>
		<Link name="L1656063790758_1" source="C1655282499443_3" target="C1655283825990_3" priority="1" expression="dataset.ticketCreated.get()" labelcustom="true" label="Ticket created"/>
		<Link name="L1656063810004_1" source="C1655282499443_3" target="CEND_1" priority="2"/>
		<Link name="L1681220924236" source="CSTART" target="C1655449520979_1" priority="1"/>
		<Link name="L1681222312105" source="C1655449520979_1" target="C1746606377057" priority="1" expression="(dataset.equals(&apos;process_tickettype&apos;, &apos;bwr_validateservicenowconnection_ping&apos;, false, true))" labelcustom="true" label="Ping ServiceNow and read tables"/>
		<Link name="L1681223704590" source="C1655283825990_2" target="CEND_1" priority="1"/>
		<Link name="L1681223705881" source="C1655283825990_3" target="CEND_1" priority="1"/>
		<Component name="C1746606377057" type="scriptactivity" x="384" y="294" w="300" h="98" title="Request the ServiceNow instance and try to read the ticket and attachment table">
			<Script onscriptexecute="testServiceNow"/>
		</Component>
		<Link name="L1746607082929" source="C1746606377057" target="CEND_1" priority="1"/>
		<Link name="L1746611212135" source="C1655449520979_1" target="CEND_1" priority="4" labelcustom="true" label="Safety exit"/>
	</Definition>
	<Variables>
		<Variable name="A1681221069994" variable="code" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221079078" variable="name" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221083082" variable="type" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221161061" variable="domain" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="domain"/>
		<Variable name="A1681221168266" variable="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="ticket type"/>
		<Variable name="A1681221171470" variable="login" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="login"/>
		<Variable name="A1681221175067" variable="password" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="password"/>
		<Variable name="A1681221179054" variable="callersysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="caller"/>
		<Variable name="A1681221183518" variable="assignmentgroupsysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="assignment group"/>
		<Variable name="A1681221235377" variable="changefilename" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221286564" variable="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" displayname="debug API calls" description="debug API calls" initialvalue="false"/>
		<Variable name="A1681221563854" variable="changetitle" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" description="ticket title"/>
		<Variable name="A1681221584998" variable="changedescription" editortype="Default" type="String" multivalued="false" visibility="local" description="ticket description" notstoredvariable="true"/>
		<Variable name="A1681221805852" variable="ticketid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221811708" variable="ticketnumber" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681221821285" variable="ticketCreated" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="false"/>
		<Variable name="A1681221889296" variable="changecsv" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681222777390" variable="resultdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681223400023" variable="status" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681223764606" variable="attachmentnumber" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681223773035" variable="attachmentid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1681223778703" variable="attachmentCreated" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="false"/>
		<Variable name="A1746455041944" variable="authentication_type" displayname="Authentication type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455454068" variable="oauth_client_id" displayname="OAuth2 Client ID" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455466842" variable="oauth_client_secret_password" displayname="OAuth2 Client secret" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455473977" variable="oauth_grant_type" displayname="OAuth2 token grant type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455481795" variable="oauth_scope" displayname="OAuth2 scope" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1746455494262" variable="oauth_expiration_date" displayname="OAuth2 refresh token expiration date" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1571679913989" variable="oauth_refresh_token" displayname="OAuth 2 Refresh Token" editortype="Default" type="String" multivalued="false" visibility="inout" description="This variable contains OAuth2 Refresh Token if access token has expired" notstoredvariable="true"/>
		<Variable name="A1746537058718" variable="oauth_expires_in" displayname="OAuth2 Expires in (unit: second)" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="true"/>
		<Variable name="A1746538919925" variable="process_tickettype" displayname="process_tickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1746606305213" variable="serverReachable" displayname="serverReachable" editortype="Default" type="Boolean" multivalued="false" visibility="out" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1746606330977" variable="ticketTableReadable" displayname="ticketTableReadable" editortype="Default" type="Boolean" multivalued="false" visibility="out" notstoredvariable="true" initialvalue="false"/>
		<Variable name="A1746606344493" variable="attachmentTableReadable" displayname="attachmentTableReadable" editortype="Default" type="Boolean" multivalued="false" visibility="out" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1746606513891" variable="errormessage_attachment" displayname="errormessage_attachment" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1746606533886" variable="errormessage_ticket_type" displayname="errormessage_ticket_type" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1746606549736" variable="errormessage_ping" displayname="errormessage_ping" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1746611981779" variable="oauth_access_token" displayname="OAuth2 Access Token" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="true"/>
		<Variable name="A1746612051175" variable="oauth_creation_date" displayname="OAuth2 Token Creation Date" editortype="Default" type="Date" multivalued="false" visibility="inout" notstoredvariable="true" description="This variable contains the creation date of Access Token"/>
	</Variables>
	<Roles>
		<Role name="A1681224823449" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655123101354" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
