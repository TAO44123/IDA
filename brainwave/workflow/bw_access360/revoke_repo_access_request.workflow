<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="revoke_access_repo_request" statictitle="Repository access revoke request" description="Repository access revoke request" scriptfile="workflow/bw_access360/revoke_access_request.javascript" type="Remediation process" publish="true" smallicon="/reports/icons/16/audit/application_16.png" largeicon="/reports/icons/48/audit/application_48.png" displayname="Repository access revoke request">
		<Component name="CSTART" type="startactivity" x="-58" y="330" w="200" h="114" title="Start" compact="true" inexclusive="true" description="repository access revoke request&#xA;" outexclusive="true">
			<Ticket create="true" createaction="false">
				<Attribute name="tickettype" attribute="ticketlog_title"/>
			</Ticket>
			<Candidates name="role" role="A1519725828821"/>
			<Output name="output" startidentityvariable="requester" startdisplaynamevariable="requestername" ticketlogrecorduidvariable="ticketlog"/>
			<Page template="/library/pagetemplates/workflow/startProcess.pagetemplate" name="selfrevokerepositoryrequest_start"/>
			<FormVariable name="A1522058209213" variable="repository" action="input" mandatory="true" longlist="false"/>
			<Init>
				<Actions/>
			</Init>
		</Component>
		<Component name="CEND" type="endactivity" x="1199" y="327" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="L1519729070167" source="CSTART" target="C1521730627949" priority="1" labelcustom="true" label="requester is not manager" expression="(! dataset.equals(&apos;requester&apos;, dataset.manager, false, true))"/>
		<Link name="L1519730282711" source="C1521730627949" target="C1522157257771" priority="2" expression="(dataset.equals(&apos;approvalstatus&apos;, &apos;deny&apos;, false, true))" labelcustom="true" label="Request denied" font="RGB{255,0,0}"/>
		<Component name="C1519739048001" type="manualactivity" x="401" y="110" w="224" h="114" title="Please revoke repository access" description="Repository manager to revoke the account access" outexclusive="true" inexclusive="true">
			<Candidates name="role" mail="A1521728028787" reassignmentmail="A1521728028787" role="A1521723832374" onrolescript="withoutRepositoryManager">
				<Reminder name="reminder" number="3" period="1" delay="0" mail="A1521728135506"/>
			</Candidates>
			<TicketAction create="true"/>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Iteration listvariable="repository"/>
			<Page template="/library/pagetemplates/workflow/manualActivity.pagetemplate" name="revokeactionrepository"/>
			<FormVariable name="A1520245149167" layoutelement="inserttitle" elementtitle="Please revoke access for the follow repository" jointeditionadd="false" jointeditionmodify="false" jointeditiondelete="false" jointeditionmultiple="false" action="input"/>
			<FormVariable name="A1520245218381" variable="requestername" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1521730221641" variable="repository" action="display" mandatory="false" longlist="true"/>
			<Expiration name="expiration"/>
		</Component>
		<Link name="L1519739141649" source="C1519739048001" target="C1519811499832" priority="1"/>
		<Link name="L1519739151829" source="C1521730627949" target="C1519739048001" priority="1" labelcustom="true" label="Request approved" expression="(dataset.equals(&apos;approvalstatus&apos;, &apos;approve&apos;, false, true))" font="RGB{0,128,0}"/>
		<Component name="C1519811499832" type="variablechangeactivity" x="716" y="119" w="188" h="98" title="enable revoke action">
			<Actions>
				<Action name="U1519812011159" action="update" attribute="revokeaction" newvalue="true"/>
			</Actions>
		</Component>
		<Link name="L1519811542417" source="C1519811499832" target="C1519829310875" priority="1"/>
		<Component name="N1519811565768" type="note" x="38" y="21" w="300" h="86" title="Workflow : Revoke Repository access request"/>
		<Component name="N1519811739096" type="note" x="155" y="430" w="242" h="86" title="Require approvement of direct manager "/>
		<Component name="N1519811871640" type="note" x="403" y="28" w="300" h="79" title="Require an action of Repository manager to really revoke access to this repository. Open request in ServiceNow for example.&#xA;Iteration on repository (multivaluated)"/>
		<Component name="N1519812523146" type="note" x="755" y="46" w="173" h="65" title="Force attribut revokeaction to True&#xA;"/>
		<Component name="C1519829310875" type="mailnotificationactivity" x="995" y="189" w="192" h="98" title="back status to requester" description="Inform the requester of the status request">
			<Output name="output" okmailvariable="email_requester"/>
			<Notification name="mail" mail="A1519830834976"/>
		</Component>
		<Link name="L1519832065773" source="C1519829310875" target="CEND" priority="1"/>
		<Component name="C1519832386091" type="mailnotificationactivity" x="724" y="295" w="211" h="98" title="request denied to requester" description="request denied to requester" inexclusive="true">
			<Notification name="mail" mail="A1519832451818"/>
			<Output name="output" okmailvariable="email_requester"/>
		</Component>
		<Link name="L1519832409960" source="C1519832386091" target="CEND" priority="1"/>
		<Component name="C1521730627949" type="manualactivity" x="150" y="297" w="218" h="114" title="Repository access revoke request.  Approval is required " outexclusive="true">
			<Candidates name="role" role="A1519737201205" mail="A1521728028787" reassignmentmail="A1521728028787">
				<Reminder name="reminder" mail="A1521728135506" number="3" period="1" delay="0"/>
			</Candidates>
			<FormVariable name="A1521731244481" variable="approvalstatus" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1521731255258" variable="requestername" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1521731264626" variable="repository" action="display" mandatory="true" longlist="false"/>
			<FormVariable name="A1521731301439" variable="organisationcode" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1521731313550" variable="organisationname" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1521731361558" variable="email_requester" action="display" mandatory="false" longlist="false"/>
			<TicketAction create="true">
				<Attribute name="custom1" attribute="requestername"/>
			</TicketAction>
			<Page template="/library/pagetemplates/workflow/manualActivity.pagetemplate" name="approvalaccessrequestrepository"/>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Expiration name="expiration" delay="10"/>
		</Component>
		<Component name="C1522157257771" type="routeactivity" x="507" y="296" w="300" h="50" compact="true" title="Route 1"/>
		<Component name="C1522157262386" type="routeactivity" x="512" y="391" w="300" h="50" compact="true" title="Route 2"/>
		<Link name="L1522157277288" source="C1522157257771" target="C1519832386091" priority="1"/>
		<Link name="L1522157282221" source="C1521730627949" target="C1522157262386" priority="3" errorlink="true" linecustom="true" color="255,0,0" labelcustom="true" label="On expiration"/>
		<Link name="L1522157286251" source="C1522157262386" target="C1519832386091" priority="1"/>
		<Link name="L1533113932794" source="CSTART" target="C1519739048001" priority="2" labelcustom="true" label="requester is manager" expression="(dataset.equals(&apos;requester&apos;, dataset.manager, false, true))"/>
	</Definition>
	<Roles>
		<Role name="A1519725828821" description="All active identities " icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone">
			<Rule name="A1519725865309" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1519737201205" displayname="directmanager" description="Direct manager" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png">
			<Rule name="A1520261548995" rule="E1520260710505_524" description="get manager from {uid}">
				<Param name="uid" variable="requester"/>
			</Rule>
			<Variable name="A1533113993763" variable="manager"/>
		</Role>
		<Role name="A1520354902353" displayname="OnlyRequester" description="Only requester">
			<Rule name="A1520354913466" rule="Onlyrequester" description="Onlyrequester for {uid}">
				<Param name="uid" variable="requester"/>
			</Rule>
		</Role>
		<Role name="A1521723832374" displayname="repositorymanager" description="Repository manager" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png">
			<Rule name="A1521801043478" rule="repositorymanager" description="repository manager of {repository}">
				<Param name="repository" variable="repository"/>
			</Rule>
		</Role>
		<Role name="A1525348441607" smallicon="/reports/icons/16/people/personal_16.png" displayname="defaultreviewer" description="Default reviewer">
			<Rule name="A1527427574020" rule="defaultreviewer" description="defaultreviewer"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1519728917833" variable="requester" displayname="requester" editortype="Process Actor" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519728948695" variable="requestername" displayname="requester name" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519736441808" variable="approvalstatus" displayname="approval status" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false">
			<StaticValue name="approve"/>
			<StaticValue name="deny"/>
		</Variable>
		<Variable name="A1519809579079" variable="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519809790370" variable="revokeaction" displayname="revokeaction" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="false" notstoredvariable="false"/>
		<Variable name="A1519830413596" variable="email_requester" displayname="email requester" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519830445269" variable="email_requester" displayname="email_requester" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519830478069" variable="email_requester" displayname="email_requester" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1519982327529" variable="ticketlog_title" editortype="Default" type="String" multivalued="false" visibility="inout" initialvalue="TKT_REVOKE_ACCESS_REPOSITORY" notstoredvariable="false"/>
		<Variable name="A1519982389804" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1520261930099" variable="organisationcode" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1520261952726" variable="organisationname" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1521727838310" variable="repository" editortype="Ledger Repository" type="String" multivalued="true" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1525361760272" variable="reviewers" displayname="reviewers" editortype="Process Actor" type="String" multivalued="true" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1533113986845" variable="manager" displayname="direct manager" editortype="Process Actors Organisation" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
	<Mails>
		<Mail name="A1519830731416" notifyrule="statusbacktorequester" displayname="statusbacktorequester" toaddtaskrole="true" description="Status back to requester" torole="A1520354902353">
		</Mail>
		<Mail name="A1519830834976" notifyrule="revokeactionbacktorequester" displayname="revokeactionbacktorequester" description="Revoke action status back to requester" torole="A1520354902353" toaddtaskrole="true">
		</Mail>
		<Mail name="A1519832451818" notifyrule="requestdenied" displayname="requestdeniedbacktorequester" description="Request denied by manager" toaddtaskrole="true" torole="A1520354902353">
		</Mail>
		<Mail name="A1521728028787" displayname="revokeaccessaccountrepository" torole="A1519737201205" notifyrule="revokeaccessaccountPending" description="Initial - Revoke access account repository"/>
		<Mail name="A1521728135506" displayname="revokeaccessaccountrepository_reminder" description="Reminder - Revoke access account repository" torole="A1519737201205" notifyrule="revokeaccessaccountReminder" toaddtaskrole="true"/>
	</Mails>
</Workflow>
