<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmticketsperrepositoryservicenow" statictitle="inititsmticketsperrepository" scriptfile="workflow/bw_iasreview/inititsmticketsperrepositoryservicenow.javascript" displayname="inititsmticketsperrepository" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="495" y="-540" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions function="createChangeInfos">
				<Action name="U1655219668691" action="executeview" viewname="bwiasr_itsms" append="false" attribute="itsmcallerid">
					<ViewParam name="P16552196686910" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219668691_1" attribute="bwr_remediation_itsmdef_string8" variable="itsmcallerid"/>
					<ViewAttribute name="P1655219668691_2" attribute="bwr_remediation_itsmdef_string9" variable="itsmassignmentgroup"/>
					<ViewAttribute name="P1655219668691_3" attribute="bwr_remediation_itsmdef_string4" variable="itsmurl"/>
					<ViewAttribute name="P1655219668691_4" attribute="bwr_remediation_itsmdef_string6" variable="itsmlogin"/>
					<ViewAttribute name="P1655219668691_5" attribute="bwr_remediation_itsmdef_string7" variable="itsmpassword"/>
					<ViewAttribute name="P1655219668691_6" attribute="bwr_remediation_itsmdef_string5" variable="itsmtickettype"/>
					<ViewAttribute name="P1655219668691_7" attribute="bwr_remediation_itsmdef_string11" variable="itsmauthenticationtype"/>
					<ViewAttribute name="P1655219668691_8" attribute="bwr_remediation_itsmdef_string12" variable="itsmtokengranttype"/>
					<ViewAttribute name="P1655219668691_9" attribute="bwr_remediation_itsmdef_string13" variable="itsmclientid"/>
					<ViewAttribute name="P1655219668691_10" attribute="bwr_remediation_itsmdef_string14" variable="itsmclientsecret"/>
					<ViewAttribute name="P1655219668691_11" attribute="bwr_remediation_itsmdef_string15" variable="itsmrefreshtoken"/>
					<ViewAttribute name="P1655219668691_12" attribute="bwr_remediation_itsmdef_string16" variable="itsmtokenexpiresin"/>
					<ViewAttribute name="P1655219668691_13" attribute="bwr_remediation_itsmdef_string17" variable="itsmtokenexpirationdate"/>
					<ViewAttribute name="P1655219668691_14" attribute="bwr_remediation_itsmdef_string18" variable="itsmscope"/>
				</Action>
				<Action name="U1655217131432" action="executeview" viewname="bwiasr_initaccountsperrepobv" append="false" attribute="accountidentifier">
					<ViewParam name="P16552171314320" param="repository" paramvalue="{dataset.repository.get()}"/>
					<ViewParam name="P16552171314321" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1655217131432_2" attribute="accountidentifier" variable="accountidentifier"/>
					<ViewAttribute name="P1655217131432_3" attribute="accountlogin" variable="accountlogin"/>
					<ViewAttribute name="P1655217131432_4" attribute="accountusername" variable="accountusername"/>
					<ViewAttribute name="P1655217131432_5" attribute="repositorydisplayname" variable="repositorydisplayname"/>
					<ViewAttribute name="P1655217131432_6" attribute="reviewstatus" variable="reviewstatus"/>
					<ViewAttribute name="P1655217131432_7" attribute="reviewactiondate" variable="reviewactiondate"/>
					<ViewAttribute name="P1655217131432_8" attribute="reviewcomment" variable="reviewcomment"/>
					<ViewAttribute name="P1655217131432_9" attribute="reviewerfullname" variable="reviewerfullname"/>
					<ViewAttribute name="P1655217131432_10" attribute="reviewerhrcode" variable="reviewerhrcode"/>
					<ViewAttribute name="P1655217131432_11" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655217131432_12" attribute="repositorybwr_remediation_repository_type" variable="remediationtype"/>
				</Action>
				<Action name="U1655220598185" action="update" attribute="changetitle" newvalue="Changes are requested for repository {dataset.repositorydisplayname.get(0)}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="493" y="1203" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="L1507032744612_1" source="C1655282499443" target="C1655283825990" priority="1" expression="dataset.ticketCreated.get()" labelcustom="true" label="Ticket created"/>
		<Link name="L1507032752198_1" source="C1655283825990" target="C1655283996202" priority="1"/>
		<Link name="L1655223801669" source="C1655283996202" target="C1655285039929" priority="1"/>
		<Link name="L1655223902430" source="CSTART" target="C1655389255894" priority="1" expression="(! dataset.isEmpty(&apos;itsmcallerid&apos;))" labelcustom="true" label="Get Caller SysId if defined"/>
		<Link name="L1655224077815" source="C1655282499443" target="C1655285039929_5" priority="2"/>
		<Component name="C1655282499443" type="callactivity" x="120" y="168" w="300" h="98" title="create incident" outexclusive="true">
			<Process workflowfile="/workflow/bw_servicenow/createservicenowincident.workflow">
				<Input name="A1655282560878" variable="domain" content="itsmurl"/>
				<Input name="A1655282569491" variable="login" content="itsmlogin"/>
				<Input name="A1655282578549" variable="password" content="itsmpassword"/>
				<Input name="A1655282623309" variable="short_description" content="changetitle"/>
				<Input name="A1655282634446" variable="comments" content="changedescription"/>
				<Input name="A1655282647426" variable="debug" content="debug"/>
				<Output name="A1655282684966" variable="ticketid" content="ticketid"/>
				<Output name="A1655282697597" variable="ticketnumber" content="ticketnumber"/>
				<Output name="A1655282705413" variable="result" content="ticketCreated"/>
				<Input name="A1655389667500" variable="caller" content="callersysid"/>
				<Input name="A1655390271452" variable="assignment_group" content="assignmentgroupsysid"/>
				<Input name="A1747043614325" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043621071" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043626687" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043634991" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043641450" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043649115" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043654457" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043660049" variable="oauth_scope" content="itsmscope"/>
				<Output name="A1741631044531" variable="resultdescription" content="resultdescription"/>
			</Process>
		</Component>
		<Component name="C1655283825990" type="callactivity" x="120" y="349" w="300" h="98" title="add attachment">
			<Process workflowfile="/workflow/bw_servicenow/addservicenowincidenttextattachement.workflow">
				<Input name="A1655283908764" variable="domain" content="itsmurl"/>
				<Input name="A1655283914472" variable="login" content="itsmlogin"/>
				<Input name="A1655283921086" variable="password" content="itsmpassword"/>
				<Input name="A1655283938828" variable="attachmentcontent" content="changecsv"/>
				<Input name="A1655283948685" variable="attachmentfilename" content="changefilename"/>
				<Input name="A1655283957385" variable="ticketid" content="ticketid"/>
				<Input name="A1655283965667" variable="debug" content="debug"/>
				<Input name="A1747043668345" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043675399" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043681081" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043690425" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043697903" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043704837" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043709770" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043715220" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Component name="C1655283996202" type="callactivity" x="120" y="525" w="300" h="98" title="get ticket status">
			<Process workflowfile="/workflow/bw_servicenow/getservicenowincident.workflow">
				<Input name="A1655284052375" variable="domain" content="itsmurl"/>
				<Input name="A1655284059873" variable="login" content="itsmlogin"/>
				<Input name="A1655284067486" variable="password" content="itsmpassword"/>
				<Input name="A1655284124942" variable="ticketid" content="ticketid"/>
				<Input name="A1655284134097" variable="debug" content="debug"/>
				<Output name="A1656071175432" variable="incident_state" content="status"/>
				<Input name="A1747043722918" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043729765" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043736751" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043744387" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043751669" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043758277" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043763548" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043768667" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Component name="N1655284989441" type="note" x="1380" y="319" w="279" h="191" title="SERVICENOW INCIDENT STATUS&#xA;&#xA;1 New&#xA;2 In Progress&#xA;3 On Hold&#xA;4 On Hold&#xA;5 On Hold&#xA;6 Resolved&#xA;7 Closed&#xA;8 Canceled"/>
		<Component name="C1655285039929" type="variablechangeactivity" x="120" y="683" w="300" h="98" title="get status pretty string" inexclusive="true">
			<Actions function="getIncidentStatusStr">
			</Actions>
		</Component>
		<Link name="L1655285152421" source="C1655285039929" target="C1655285039929_2" priority="1"/>
		<Component name="C1655285385163" type="updateticketreviewactivity" x="120" y="986" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="custom5" attribute="ticketextref1"/>
				<Attribute name="custom6" attribute="ticketextref2"/>
				<Attribute name="custom7" attribute="ticketextrefinstance"/>
				<Attribute name="custom8" attribute="ticketextrefurl"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="comment" attribute="emptycomment"/>
			</UpdateTicketReview>
		</Component>
		<Component name="N1655285741279" type="note" x="1321" y="528" w="445" h="262" title="REMEDIATION TICKET&#xA;&#xA;recorduid&#x9;remediation internal unique identifier&#xA;status&#x9;remediation printable status&#xA;comment&#x9;remediation comment&#xA;actiondate&#x9;remediation last action date&#xA;custom1&#x9;remediation access right printable information&#xA;custom2&#x9;remediation closed status&#xA;0 = ticket open, 1 = ticket closed, done, 2 = ticket closed, cancel&#xA;custom3&#x9;remediation type (embedded / itsm)&#xA;custom4&#x9;timeslotuid when the last remediation ticket update has been made&#xA;custom5&#x9;External reference (Displayable Ticket Number)&#xA;custom6&#x9;External reference (internal infos)&#xA;custom7&#x9;External system instance&#xA;custom8&#x9;External system hyperlink&#xA;"/>
		<Component name="N1655285921120" type="note" x="1790" y="531" w="300" h="132" title="https://xxx.service-now.com/nav_to.do?uri=incident.do?sysparm_query=number=INCXXXX&#xA;&#xA;https://xxx.service-now.com/task.do?sys_id=&lt;Sys id of your RITM or Incident&gt;"/>
		<Link name="L1655296149592" source="C1655285385163" target="CEND" priority="1"/>
		<Component name="C1655389255894" type="callactivity" x="369" y="-410" w="300" h="98" title="get caller sysid">
			<Process workflowfile="/workflow/bw_servicenow/getservicenowsysid.workflow">
				<Input name="A1655389345856" variable="domain" content="itsmurl"/>
				<Input name="A1655389352508" variable="login" content="itsmlogin"/>
				<Input name="A1655389359541" variable="password" content="itsmpassword"/>
				<Input name="A1655389533655" variable="table" content="usertable"/>
				<Input name="A1655389541231" variable="attributeName" content="usersearchattr"/>
				<Input name="A1655389551902" variable="attributeValue" content="itsmcallerid"/>
				<Input name="A1655389557145" variable="debug" content="debug"/>
				<Output name="A1655391680884" variable="sys_id" content="callersysid"/>
				<Input name="A1747043022196" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043027150" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043042008" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043058447" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043067158" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043073577" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043077363" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043082650" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Link name="L1655389629074" source="C1655389255894" target="C1655449517757" priority="1" labelcustom="false"/>
		<Component name="C1655389843892" type="callactivity" x="369" y="-130" w="300" h="98" title="get assignment group sysid">
			<Process workflowfile="/workflow/bw_servicenow/getservicenowsysid.workflow">
				<Input name="A1655389879449" variable="domain" content="itsmurl"/>
				<Input name="A1655389885510" variable="login" content="itsmlogin"/>
				<Input name="A1655389889971" variable="password" content="itsmpassword"/>
				<Input name="A1655389895875" variable="debug" content="debug"/>
				<Input name="A1655389922162" variable="table" content="grouptable"/>
				<Input name="A1655390127091" variable="attributeName" content="groupsearchattr"/>
				<Input name="A1655390134014" variable="attributeValue" content="itsmassignmentgroup"/>
				<Output name="A1655390143020" variable="sys_id" content="assignmentgroupsysid"/>
				<Input name="A1747043564520" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043570165" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043575729" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043582793" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043589545" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043593906" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043597816" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043602487" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Link name="L1655390168377" source="C1655389843892" target="C1655449520979" priority="1"/>
		<Component name="C1655449517757" type="routeactivity" x="495" y="-245" w="300" h="50" compact="true" title="Route 1" inexclusive="true" outexclusive="true"/>
		<Component name="C1655449520979" type="routeactivity" x="495" y="37" w="300" h="50" compact="true" title="Route 2" inexclusive="true" outexclusive="true"/>
		<Link name="L1655449554611" source="C1655449517757" target="C1655389843892" priority="1" expression="(! dataset.isEmpty(&apos;itsmassignmentgroup&apos;))" labelcustom="true" label="Get AssignmentGroup SysId if defined"/>
		<Link name="L1655449556458" source="C1655449520979" target="C1657213098824" priority="1" expression="(dataset.equals(&apos;itsmtickettype&apos;, &apos;incident&apos;, false, true))" labelcustom="true" label="incident"/>
		<Link name="L1655450262679" source="CSTART" target="C1655449517757" priority="2"/>
		<Link name="L1655450267202" source="C1655449517757" target="C1655449520979" priority="2"/>
		<Component name="C1655282499443_1" type="callactivity" x="633" y="168" w="300" h="98" title="create change request" outexclusive="true">
			<Process workflowfile="/workflow/bw_servicenow/createservicenowchangerequest.workflow">
				<Input name="A1655282560878" variable="domain" content="itsmurl"/>
				<Input name="A1655282569491" variable="login" content="itsmlogin"/>
				<Input name="A1655282578549" variable="password" content="itsmpassword"/>
				<Input name="A1655282623309" variable="short_description" content="changetitle"/>
				<Input name="A1655282634446" variable="comments" content="changedescription"/>
				<Input name="A1655282647426" variable="debug" content="debug"/>
				<Output name="A1655282684966" variable="ticketid" content="ticketid"/>
				<Output name="A1655282697597" variable="ticketnumber" content="ticketnumber"/>
				<Output name="A1655282705413" variable="result" content="ticketCreated"/>
				<Input name="A1655389667500" variable="caller" content="callersysid"/>
				<Input name="A1655390271452" variable="assignment_group" content="assignmentgroupsysid"/>
				<Input name="A1747043614325" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043621071" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043626687" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043634991" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043641450" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043649115" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043654457" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043660049" variable="oauth_scope" content="itsmscope"/>
				<Output name="A1741631057641" variable="resultdescription" content="resultdescription"/>
			</Process>
		</Component>
		<Component name="C1655283825990_1" type="callactivity" x="633" y="349" w="300" h="98" title="add attachment">
			<Process workflowfile="/workflow/bw_servicenow/addservicenowchangerequesttextattachement.workflow">
				<Input name="A1655283908764" variable="domain" content="itsmurl"/>
				<Input name="A1655283914472" variable="login" content="itsmlogin"/>
				<Input name="A1655283921086" variable="password" content="itsmpassword"/>
				<Input name="A1655283938828" variable="attachmentcontent" content="changecsv"/>
				<Input name="A1655283948685" variable="attachmentfilename" content="changefilename"/>
				<Input name="A1655283957385" variable="ticketid" content="ticketid"/>
				<Input name="A1655283965667" variable="debug" content="debug"/>
				<Input name="A1747043668345" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043675399" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043681081" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043690425" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043697903" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043704837" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043709770" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043715220" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Component name="C1655283996202_1" type="callactivity" x="633" y="525" w="300" h="98" title="get ticket status">
			<Process workflowfile="/workflow/bw_servicenow/getservicenowchangerequest.workflow">
				<Input name="A1655284052375" variable="domain" content="itsmurl"/>
				<Input name="A1655284059873" variable="login" content="itsmlogin"/>
				<Input name="A1655284067486" variable="password" content="itsmpassword"/>
				<Input name="A1655284124942" variable="ticketid" content="ticketid"/>
				<Input name="A1655284134097" variable="debug" content="debug"/>
				<Output name="A1656060887556" variable="change_state" content="status"/>
				<Input name="A1747043722918" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747043729765" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747043736751" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747043744387" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747043751669" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747043758277" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747043763548" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747043768667" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Component name="C1655285039929_1" type="variablechangeactivity" x="633" y="683" w="300" h="98" title="get status pretty string" inexclusive="true">
			<Actions function="getChangeRequestStatusStr">
			</Actions>
		</Component>
		<Component name="C1655285385163_1" type="updateticketreviewactivity" x="633" y="986" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="custom5" attribute="ticketextref1"/>
				<Attribute name="custom6" attribute="ticketextref2"/>
				<Attribute name="custom7" attribute="ticketextrefinstance"/>
				<Attribute name="custom8" attribute="ticketextrefurl"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="comment" attribute="emptycomment"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1656063790758" source="C1655282499443_1" target="C1655283825990_1" priority="1" expression="dataset.ticketCreated.get()" labelcustom="true" label="Ticket created"/>
		<Link name="L1656063792080" source="C1655283825990_1" target="C1655283996202_1" priority="1"/>
		<Link name="L1656063793580" source="C1655283996202_1" target="C1655285039929_1" priority="1"/>
		<Link name="L1656063794344" source="C1655285039929_1" target="C1655285039929_3" priority="1"/>
		<Link name="L1656063797569" source="C1655285385163_1" target="CEND" priority="1"/>
		<Link name="L1656063810004" source="C1655282499443_1" target="C1655285039929_6" priority="2"/>
		<Link name="L1656063830435" source="C1655449520979" target="C1657213080222" priority="2" expression="(dataset.equals(&apos;itsmtickettype&apos;, &apos;changerequest&apos;, false, true))" labelcustom="true" label="change request"/>
		<Link name="L1656063975792" source="C1655449520979" target="CEND" priority="3"/>
		<Component name="N1656070964558" type="note" x="717" y="-516" w="300" h="349" title="SERVICE NOW&#xA;&#xA;url - string 4&#xA;tickettype - string5&#xA;login - string 6&#xA;password - string 7&#xA;call userid - string 8&#xA;assignment group name - string 9&#xA;authentication type - string 11&#xA;token grant type - string 12&#xA;client ID - string13&#xA;client secret - string 14&#xA;refresh token - string 15&#xA;token expires in - string 16&#xA;token expiration date - string 17&#xA;scope - string 18"/>
		<Component name="N1656078420247" type="note" x="1389" y="115" w="300" h="185" title="SERVICENOW CHANGE REQUEST STATUS&#xA;&#xA;-5 New&#xA;-4 Assess&#xA;-3 Authorize&#xA;-2 Scheduled&#xA;-1 Implement&#xA;0 Review&#xA;3 Closed&#xA;4 Canceled"/>
		<Component name="C1655285039929_2" type="variablechangeactivity" x="116" y="842" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655286096596" action="update" attribute="shortlink" newvalue="https://{dataset.itsmurl.get()}/task.do?sys_id={dataset.ticketid.get()}"/>
				<Action name="U1655295807040" action="multiresize" attribute="remediationrecorduid" attribute1="ticketextref1" attribute2="ticketextref2" attribute3="ticketextrefinstance" attribute4="ticketextrefurl" attribute5="ticketstatus" attribute6="ticketclosedstatus"/>
				<Action name="U1655295826647" action="multireplace" attribute="ticketextref1" newvalue="{dataset.ticketnumber.get()}"/>
				<Action name="U1655295840461" action="multireplace" attribute="ticketextref2" newvalue="{dataset.ticketid.get()}"/>
				<Action name="U1655295866101" action="multireplace" attribute="ticketextrefurl" newvalue="{dataset.shortlink.get()}"/>
				<Action name="U1655295905658" action="multireplace" attribute="ticketextrefinstance" newvalue="{dataset.remediationinstancecode.get()}"/>
				<Action name="U1655296086172" action="multireplace" attribute="ticketstatus" newvalue="{dataset.statusStr.get()}"/>
				<Action name="U1655297574445" action="multireplace" attribute="ticketclosedstatus" newvalue="{dataset.closedstatus.get()}"/>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
			</Actions>
		</Component>
		<Link name="L1656320419972" source="C1655285039929_2" target="C1655285385163" priority="1"/>
		<Component name="C1655285039929_3" type="variablechangeactivity" x="634" y="848" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655286096596" action="update" attribute="shortlink" newvalue="https://{dataset.itsmurl.get()}/task.do?sys_id={dataset.ticketid.get()}"/>
				<Action name="U1655295807040" action="multiresize" attribute="remediationrecorduid" attribute1="ticketextref1" attribute2="ticketextref2" attribute3="ticketextrefinstance" attribute4="ticketextrefurl" attribute5="ticketstatus" attribute6="ticketclosedstatus"/>
				<Action name="U1655295826647" action="multireplace" attribute="ticketextref1" newvalue="{dataset.ticketnumber.get()}"/>
				<Action name="U1655295840461" action="multireplace" attribute="ticketextref2" newvalue="{dataset.ticketid.get()}"/>
				<Action name="U1655295866101" action="multireplace" attribute="ticketextrefurl" newvalue="{dataset.shortlink.get()}"/>
				<Action name="U1655295905658" action="multireplace" attribute="ticketextrefinstance" newvalue="{dataset.remediationinstancecode.get()}"/>
				<Action name="U1655296086172" action="multireplace" attribute="ticketstatus" newvalue="{dataset.statusStr.get()}"/>
				<Action name="U1655297574445" action="multireplace" attribute="ticketclosedstatus" newvalue="{dataset.closedstatus.get()}"/>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
			</Actions>
		</Component>
		<Link name="L1656320440529" source="C1655285039929_3" target="C1655285385163_1" priority="1"/>
		<Component name="C1657213080222" type="variablechangeactivity" x="639" y="55" w="300" h="98" title="attachment name">
			<Actions>
				<Action name="U1657213215165" action="update" attribute="changefilename" newvalue="changerequests.csv"/>
			</Actions>
		</Component>
		<Link name="L1657213092265" source="C1657213080222" target="C1655282499443_1" priority="1"/>
		<Component name="C1657213098824" type="variablechangeactivity" x="119" y="52" w="300" h="98" title="attachment name">
			<Actions>
				<Action name="U1657213197377" action="update" attribute="changefilename" newvalue="incidents.csv"/>
			</Actions>
		</Component>
		<Link name="L1657213106526" source="C1657213098824" target="C1655282499443" priority="1"/>
		<Component name="C1655285039929_5" type="variablechangeactivity" x="-244" y="842" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1741617078445" action="update" attribute="ticketstatus" newvalue="error"/>
				<Action name="U1741635074654" action="update" attribute="ticketclosedstatus" newvalue="3"/>
			</Actions>
		</Component>
		<Component name="C1655285385163_3" type="updateticketreviewactivity" x="-244" y="986" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="comment" attribute="resultdescription"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="custom10" attribute="remediationinstancecode"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1741613282412_1" source="C1655285039929_5" target="C1655285385163_3" priority="1"/>
		<Component name="C1655285039929_6" type="variablechangeactivity" x="971" y="848" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1741617078445" action="update" attribute="ticketstatus" newvalue="error"/>
				<Action name="U1741635061409" action="update" attribute="ticketclosedstatus" newvalue="3"/>
			</Actions>
		</Component>
		<Component name="C1655285385163_4" type="updateticketreviewactivity" x="971" y="986" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="comment" attribute="resultdescription"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="custom10" attribute="remediationinstancecode"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1741617122027_1" source="C1655285039929_6" target="C1655285385163_4" priority="1"/>
		<Link name="L1741630906475" source="C1655285385163_4" target="CEND" priority="1"/>
		<Link name="L1741630910522" source="C1655285385163_3" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1655217226547" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552196686910" variable="itsmurl" displayname="itsmurl" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686912" variable="itsmlogin" displayname="itsmlogin" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686913" variable="itsmpassword" displayname="itsmpassword" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552171314320" variable="accountidentifier" displayname="accountidentifier" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314321" variable="accountlogin" displayname="accountlogin" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314322" variable="accountusername" displayname="accountusername" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314323" variable="repositorydisplayname" displayname="repositorydisplayname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314324" variable="reviewstatus" displayname="reviewstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314325" variable="reviewactiondate" displayname="reviewactiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16552171314326" variable="reviewcomment" displayname="reviewcomment" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314327" variable="reviewerfullname" displayname="reviewerfullname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314328" variable="reviewerhrcode" displayname="reviewerhrcode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1655220685558" variable="changetitle" displayname="changetitle" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655223458229" variable="changedescription" displayname="changedescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655223468053" variable="changecsv" displayname="changecsv" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224016630" variable="ticketid" displayname="ticketid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224026188" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224033702" variable="ticketCreated" displayname="ticketCreated" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224232644" variable="changefilename" displayname="change filename" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="changerequest.csv" notstoredvariable="true"/>
		<Variable name="A1655224264884" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1655224341996" variable="status" displayname="status" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655285020078" variable="statusStr" displayname="statusStr" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655285638269" variable="remediationrecorduid" displayname="remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655286005798" variable="shortlink" displayname="shortlink" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295727684" variable="ticketextref1" displayname="ticketextref1" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295733994" variable="ticketextref2" displayname="ticketextref2" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295744532" variable="ticketextrefurl" displayname="ticketextrefurl" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295759078" variable="ticketextrefinstance" displayname="ticketextrefinstance" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655296052276" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655297281617" variable="closedstatus" displayname="closedstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655297519707" variable="ticketclosedstatus" displayname="ticketclosedstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655365599420" variable="currentdatetime" displayname="currentdatetime" editortype="Default" type="String" multivalued="false" visibility="local" description="current date time" notstoredvariable="true"/>
		<Variable name="A1655389419787" variable="usertable" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="sys_user" notstoredvariable="true"/>
		<Variable name="A1655389484062" variable="usersearchattr" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="user_name" notstoredvariable="true"/>
		<Variable name="A1655389508734" variable="itsmcallerid" displayname="itsmcallerid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="brainwave"/>
		<Variable name="A1655389573769" variable="callersysid" displayname="callersysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655389903050" variable="grouptable" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="sys_user_group" notstoredvariable="true"/>
		<Variable name="A1655390002160" variable="groupsearchattr" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="name" notstoredvariable="true"/>
		<Variable name="A1655390098803" variable="itsmassignmentgroup" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="Service Desk" notstoredvariable="true"/>
		<Variable name="A1655390108850" variable="assignmentgroupsysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1656063936417" variable="itsmtickettype" displayname="itsmtickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="incident">
			<StaticValue name="incident"/>
			<StaticValue name="changerequest"/>
		</Variable>
		<Variable name="A165521713143210" variable="remediationtype" displayname="remediationtype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1747042903547" variable="itsmauthenticationtype" displayname="itsmauthenticationtype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042908040" variable="itsmtokengranttype" displayname="itsmtokengranttype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042915822" variable="itsmclientid" displayname="itsmclientid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042921458" variable="itsmclientsecret" displayname="itsmclientsecret" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042927099" variable="itsmrefreshtoken" displayname="itsmrefreshtoken" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042933764" variable="itsmtokenexpiresin" displayname="itsmtokenexpiresin" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042939204" variable="itsmtokenexpirationdate" displayname="itsmtokenexpirationdate" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747042944344" variable="itsmscope" displayname="itsmscope" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1741631031762" variable="resultdescription" displayname="resultdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1741807176140" variable="emptycomment" displayname="emptycomment" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1741811429460" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
