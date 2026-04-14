<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_refreshitsmticketspergroupreposervicenow" statictitle="refreshitsmticketspergrouprepo" scriptfile="workflow/bw_iasreview/refreshitsmticketsperrepositoryservicenow.javascript" displayname="refreshitsmticketspergrouprepo" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="225" y="-106" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions function="init">
				<Action name="U1655219668691" action="executeview" viewname="bwiasr_itsms" append="false" attribute="itsmurl">
					<ViewParam name="P16552196686910" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219668691_1" attribute="bwr_remediation_itsmdef_string4" variable="itsmurl"/>
					<ViewAttribute name="P1655219668691_2" attribute="bwr_remediation_itsmdef_string6" variable="itsmlogin"/>
					<ViewAttribute name="P1655219668691_3" attribute="bwr_remediation_itsmdef_string7" variable="itsmpassword"/>
					<ViewAttribute name="P1655219668691_4" attribute="bwr_remediation_itsmdef_string11" variable="itsmauthenticationtype"/>
					<ViewAttribute name="P1655219668691_5" attribute="bwr_remediation_itsmdef_string12" variable="itsmtokengranttype"/>
					<ViewAttribute name="P1655219668691_6" attribute="bwr_remediation_itsmdef_string13" variable="itsmclientid"/>
					<ViewAttribute name="P1655219668691_7" attribute="bwr_remediation_itsmdef_string14" variable="itsmclientsecret"/>
					<ViewAttribute name="P1655219668691_8" attribute="bwr_remediation_itsmdef_string15" variable="itsmrefreshtoken"/>
					<ViewAttribute name="P1655219668691_9" attribute="bwr_remediation_itsmdef_string16" variable="itsmtokenexpiresin"/>
					<ViewAttribute name="P1655219668691_10" attribute="bwr_remediation_itsmdef_string17" variable="itsmtokenexpirationdate"/>
					<ViewAttribute name="P1655219668691_11" attribute="bwr_remediation_itsmdef_string18" variable="itsmscope"/>
				</Action>
				<Action name="U1655368117141" action="executeview" viewname="bwiasr_pendinggroupsperrepo" append="false" attribute="remediationrecorduid">
					<ViewParam name="P16553681171410" param="repository" paramvalue="{dataset.repository.get()}"/>
					<ViewAttribute name="P1655368117141_1" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655368117141_2" attribute="remediationticketid" variable="remediationticketid"/>
					<ViewAttribute name="P1655368117141_3" attribute="remediationclosedstatus" variable="remediationclosedstatus"/>
					<ViewAttribute name="P1655368117141_4" attribute="remediationactiondate" variable="remediationactiondate"/>
					<ViewAttribute name="P1655368117141_5" attribute="remediationstatus" variable="remediationstatus"/>
					<ViewAttribute name="P1655368117141_6" attribute="remediationticketnumber" variable="remediationticketnumber"/>
				</Action>
				<Action name="U1655368191050" action="update" attribute="uniquerremediationticketid" newvalue="{dataset.remediationticketid}"/>
				<Action name="U1656083629606" action="update" attribute="uniqueremediationticketnumber" newvalue="{dataset.remediationticketnumber}"/>
				<Action name="U1655370225766" action="multiclean" attribute="uniquerremediationticketid" emptyvalues="true" duplicates="true" attribute1="uniqueremediationticketnumber"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="225" y="721" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="N1655284989441" type="note" x="468" y="197" w="279" h="191" title="SERVICENOW INCIDENT STATUS&#xA;&#xA;1 New&#xA;2 In Progress&#xA;3 On Hold&#xA;4 On Hold&#xA;5 On Hold&#xA;6 Resolved&#xA;7 Closed&#xA;8 Canceled"/>
		<Component name="N1655285741279" type="note" x="467" y="400" w="445" h="262" title="REMEDIATION TICKET&#xA;&#xA;recorduid&#x9;remediation internal unique identifier&#xA;status&#x9;remediation printable status&#xA;comment&#x9;remediation comment&#xA;actiondate&#x9;remediation last action date&#xA;custom1&#x9;remediation access right printable information&#xA;custom2&#x9;remediation closed status&#xA;0 = ticket open, 1 = ticket closed, done, 2 = ticket closed, cancel&#xA;custom3&#x9;remediation type (embedded / itsm)&#xA;custom4&#x9;timeslotuid when the last remediation ticket update has been made&#xA;custom5&#x9;External reference (Displayable Ticket Number)&#xA;custom6&#x9;External reference (internal infos)&#xA;custom7&#x9;External system instance&#xA;custom8&#x9;External system hyperlink&#xA;"/>
		<Component name="N1655285921120" type="note" x="924" y="637" w="300" h="132" title="https://xxx.service-now.com/nav_to.do?uri=incident.do?sysparm_query=number=INCXXXX&#xA;&#xA;https://xxx.service-now.com/task.do?sys_id=&lt;Sys id of your RITM or Incident&gt;"/>
		<Component name="C1655368217153" type="callactivity" x="99" y="110" w="300" h="98" title="get latest tickets status">
			<Process workflowfile="/workflow/bw_servicenow/getservicenowtaskstatus.workflow">
				<Input name="A1655368247270" variable="debug" content="debug"/>
				<Input name="A1655368255794" variable="domain" content="itsmurl"/>
				<Input name="A1655368261382" variable="login" content="itsmlogin"/>
				<Input name="A1655368268723" variable="password" content="itsmpassword"/>
				<Input name="A1655368315564" variable="ticketid" content="uniquerremediationticketid"/>
				<Output name="A1655368471924" variable="ticketupdatedatetime" content="res_ticketupdatedatetime"/>
				<Output name="A1655368480006" variable="statusStr" content="res_ticketstatusstr"/>
				<Output name="A1655370737439" variable="statusclosed" content="res_ticketclosed"/>
				<Output name="A1655371168787" variable="retticketid" content="res_ticketid"/>
				<Input name="A1656083787734" variable="inticketnumber" content="uniqueremediationticketnumber"/>
				<Input name="A1747040404190" variable="authentication_type" content="itsmauthenticationtype"/>
				<Input name="A1747040413514" variable="oauth_client_id" content="itsmclientid"/>
				<Input name="A1747040421761" variable="oauth_client_secret_password" content="itsmclientsecret"/>
				<Input name="A1747040432430" variable="oauth_grant_type" content="itsmtokengranttype"/>
				<Input name="A1747040442010" variable="oauth_refresh_token" content="itsmrefreshtoken"/>
				<Input name="A1747040448091" variable="oauth_expiration_date" content="itsmtokenexpirationdate"/>
				<Input name="A1747040454651" variable="oauth_expires_in" content="itsmtokenexpiresin"/>
				<Input name="A1747040463893" variable="oauth_scope" content="itsmscope"/>
			</Process>
		</Component>
		<Link name="L1655368599006" source="CSTART" target="C1656084673431" priority="1"/>
		<Component name="C1655368608770" type="scriptactivity" x="99" y="385" w="300" h="98" title="update dataset with latest status">
			<Script onscriptexecute="updateTicketStatus"/>
		</Component>
		<Component name="C1655368639860" type="updateticketreviewactivity" x="99" y="517" w="300" h="98" title="update tickets">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="remediationstatus"/>
				<Attribute name="actiondate" attribute="remediationactiondate"/>
				<Attribute name="custom2" attribute="remediationclosedstatus"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1655368655883" source="C1655368608770" target="C1655368639860" priority="1"/>
		<Link name="L1655368661552" source="C1655368639860" target="CEND" priority="1"/>
		<Component name="C1655371463984" type="variablechangeactivity" x="100" y="235" w="300" h="98" outexclusive="true" title="dummy"/>
		<Link name="L1655371469211" source="C1655368217153" target="C1655371463984" priority="1"/>
		<Link name="L1655371469947" source="C1655371463984" target="C1655368608770" priority="2"/>
		<Link name="L1655371855649" source="C1655371463984" target="CEND" priority="1" expression="(dataset.isEmpty(&apos;res_ticketid&apos;))" labelcustom="true" label="nothing to update"/>
		<Component name="C1656084673431" type="variablechangeactivity" x="100" y="-19" w="300" h="98" title="for debug only"/>
		<Link name="L1656084683233" source="C1656084673431" target="C1655368217153" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1655217226547" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552196686910" variable="itsmurl" displayname="itsmurl" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686912" variable="itsmlogin" displayname="itsmlogin" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686913" variable="itsmpassword" displayname="itsmpassword" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A1655224264884" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A16553681171410" variable="remediationrecorduid" displayname="remediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16553681171411" variable="remediationticketid" displayname="remediationticketid" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1655368137137" variable="uniquerremediationticketid" displayname="uniquerremediationticketid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655368410129" variable="res_ticketid" displayname="res_ticketid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655368428715" variable="res_ticketstatusstr" displayname="res_ticketstatusstr" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655368442286" variable="res_ticketclosed" displayname="res_ticketclosed" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655368458041" variable="res_ticketupdatedatetime" displayname="res_ticketupdatedatetime" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A16553681171412" variable="remediationclosedstatus" displayname="remediationclosedstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16553681171413" variable="remediationactiondate" displayname="remediationactiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16553681171414" variable="remediationstatus" displayname="remediationstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16553681171415" variable="remediationticketnumber" displayname="remediationticketnumber" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1656078997965" variable="uniqueremediationticketnumber" displayname="uniqueremediationticketnumber" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040227087" variable="itsmauthenticationtype" displayname="itsmauthenticationtype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040232080" variable="itsmtokengranttype" displayname="itsmtokengranttype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040239294" variable="itsmclientid" displayname="itsmclientid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040244521" variable="itsmclientsecret" displayname="itsmclientsecret" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040248778" variable="itsmrefreshtoken" displayname="itsmrefreshtoken" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040255877" variable="itsmtokenexpiresin" displayname="itsmtokenexpiresin" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040261331" variable="itsmtokenexpirationdate" displayname="itsmtokenexpirationdate" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1747040265923" variable="itsmscope" displayname="itsmscope" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
