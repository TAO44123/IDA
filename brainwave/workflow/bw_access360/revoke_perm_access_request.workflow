<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="revoke_access_perm_request" statictitle="access revoke request" description="access revoke request" scriptfile="workflow/bw_access360/revoke_access_request.javascript" type="Remediation process" publish="true" smallicon="/reports/icons/16/audit/application_16.png" largeicon="/reports/icons/48/audit/application_48.png" displayname="access revoke request">
		<Component name="CSTART" type="startactivity" x="-55" y="316" w="200" h="114" title="Start" compact="true" inexclusive="true" description="Access revoke request" outexclusive="true">
			<Ticket create="true" createaction="false">
				<Attribute name="tickettype" attribute="ticketlog_title"/>
			</Ticket>
			<Candidates name="role" role="A1519725828821"/>
			<Output name="output" startidentityvariable="requester" startdisplaynamevariable="requestername" ticketlogrecorduidvariable="ticketlog"/>
			<Page template="/library/pagetemplates/workflow/startProcess.pagetemplate" name="selfrevokepermrequest_start"/>
			<FormVariable name="A1521799195127" variable="permission" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="1191" y="317" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="L1519729070167" source="CSTART" target="C1519730270666" priority="1" labelcustom="true" label="manager is not requester" expression="(! dataset.equals(&apos;requester&apos;, dataset.manager, false, true))"/>
		<Component name="C1519730270666" type="manualactivity" x="162" y="283" w="206" h="114" title="access revoke request. approval is required " outexclusive="true">
			<Candidates name="role" role="A1519737201205" mail="A1521799290622" reassignmentmail="A1521799290622">
				<Reminder name="reminder" periodformat="b" delay="0" number="3" period="1" mail="A1521799358357"/>
			</Candidates>
			<TicketAction create="true">
				<Attribute name="custom1" attribute="requestername"/>
			</TicketAction>
			<FormVariable name="A1519747251889" variable="requestername" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1520261987571" variable="organisationcode" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1520261997183" variable="organisationname" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1519747241548" variable="approvalstatus" action="input" mandatory="true" longlist="false"/>
			<Page template="/library/pagetemplates/workflow/manualActivity.pagetemplate" name="approvalrequestpermission"/>
			<FormVariable name="A1520349947985" variable="email_requester" action="display" mandatory="false" longlist="false"/>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<FormVariable name="A1521799533704" variable="permission" action="display" mandatory="false" longlist="false"/>
			<Expiration name="expiration" delay="10"/>
		</Component>
		<Link name="L1519730282711" source="C1519730270666" target="C1522157382005" priority="2" expression="(dataset.equals(&apos;approvalstatus&apos;, &apos;deny&apos;, false, true))" labelcustom="true" label="Request denied" font="RGB{255,0,0}"/>
		<Component name="C1519739048001" type="manualactivity" x="401" y="110" w="224" h="114" title="Please revoke permission access" description="Application manager to revoke the permission access" outexclusive="true" inexclusive="true">
			<Candidates name="role" role="A1521799740714" mail="A1521799290622" reassignmentmail="A1521799290622">
				<Reminder name="reminder" number="3" period="1" delay="0" mail="A1521799358357"/>
			</Candidates>
			<TicketAction create="true"/>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Iteration listvariable="permission"/>
			<Page template="/library/pagetemplates/workflow/manualActivity.pagetemplate" name="revokeactionpermission"/>
			<FormVariable name="A1520245149167" layoutelement="inserttitle" elementtitle="Please revoke access for the follow permissions" jointeditionadd="false" jointeditionmodify="false" jointeditiondelete="false" jointeditionmultiple="false" action="input"/>
			<FormVariable name="A1520245218381" variable="requestername" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1521799895018" variable="permission" action="display" mandatory="false" longlist="true"/>
			<Expiration name="expiration"/>
		</Component>
		<Link name="L1519739141649" source="C1519739048001" target="C1519811499832" priority="1"/>
		<Link name="L1519739151829" source="C1519730270666" target="C1519739048001" priority="1" labelcustom="true" label="Request approved" expression="(dataset.equals(&apos;approvalstatus&apos;, &apos;approve&apos;, false, true))" font="RGB{0,128,0}"/>
		<Component name="C1519811499832" type="variablechangeactivity" x="716" y="119" w="188" h="98" title="enable revoke action">
			<Actions>
				<Action name="U1519812011159" action="update" attribute="revokeaction" newvalue="true"/>
			</Actions>
		</Component>
		<Link name="L1519811542417" source="C1519811499832" target="C1519829310875" priority="1"/>
		<Component name="N1519811565768" type="note" x="38" y="21" w="300" h="86" title="Workflow : Revoke permission access request"/>
		<Component name="N1519811739096" type="note" x="133" y="403" w="242" h="86" title="Require approvement of direct manager "/>
		<Component name="N1519811871640" type="note" x="403" y="28" w="300" h="79" title="Require an action of permission manager to really revoke access to this permission. Open request in ServiceNow for example.&#xA;Iteration on applications (multivaluated)"/>
		<Component name="N1519812523146" type="note" x="755" y="46" w="173" h="65" title="Force attribut revokeaction to True&#xA;"/>
		<Component name="C1519829310875" type="mailnotificationactivity" x="995" y="189" w="192" h="98" title="back status to requester" description="Inform the requester of the status request">
			<Output name="output" okmailvariable="email_requester"/>
			<Notification name="mail" mail="A1519830834976"/>
		</Component>
		<Link name="L1519832065773" source="C1519829310875" target="CEND" priority="1"/>
		<Component name="C1519832386091" type="mailnotificationactivity" x="723" y="295" w="211" h="98" title="request denied to requester" description="request denied to requester" inexclusive="true">
			<Notification name="mail" mail="A1519832451818"/>
			<Output name="output"/>
		</Component>
		<Link name="L1519832409960" source="C1519832386091" target="CEND" priority="1"/>
		<Component name="C1522157382005" type="routeactivity" x="509" y="284" w="300" h="50" compact="true" title="Route 1"/>
		<Component name="C1522157385384" type="routeactivity" x="514" y="382" w="300" h="50" compact="true" title="Route 2"/>
		<Link name="L1522157405453" source="C1522157382005" target="C1519832386091" priority="1"/>
		<Link name="L1522157409091" source="C1519730270666" target="C1522157385384" priority="3" errorlink="true" linecustom="true" color="255,0,0" labelcustom="true" label="On expiration"/>
		<Link name="L1522157412674" source="C1522157385384" target="C1519832386091" priority="1"/>
		<Link name="L1533113814023" source="CSTART" target="C1519739048001" priority="2" labelcustom="true" label="requester is manager" expression="(dataset.equals(&apos;requester&apos;, dataset.manager, false, true))"/>
	</Definition>
	<Roles>
		<Role name="A1519725828821" description="All active identities " icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone">
			<Rule name="A1519725865309" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1519737201205" displayname="directmanager" description="Direct manager" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png">
			<Rule name="A1520261548995" rule="E1520260710505_524" description="get manager from {uid}">
				<Param name="uid" variable="requester"/>
			</Rule>
			<Variable name="A1533113721991" variable="manager"/>
		</Role>
		<Role name="A1520354902353" displayname="OnlyRequester" description="Only requester">
			<Rule name="A1520354913466" rule="Onlyrequester" description="Onlyrequester for {uid}">
				<Param name="uid" variable="requester"/>
			</Rule>
		</Role>
		<Role name="A1521799740714" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="permissionmanager" description="Permission manager">
			<Rule name="A1521799810131" rule="permmanager" description="perm manager for {perm_uid}">
				<Param name="perm_uid" variable="permission"/>
			</Rule>
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
		<Variable name="A1519982327529" variable="ticketlog_title" editortype="Default" type="String" multivalued="false" visibility="inout" initialvalue="TKT_REVOKE_ACCESS_PERMISSION" notstoredvariable="false"/>
		<Variable name="A1519982389804" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1520261930099" variable="organisationcode" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1520261952726" variable="organisationname" editortype="Default" type="String" multivalued="false" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1521799107529" variable="permission" displayname="permission" editortype="Ledger Permission" type="String" multivalued="true" visibility="inout" notstoredvariable="false"/>
		<Variable name="A1533113711969" variable="manager" displayname="direct manager" editortype="Process Actors Organisation" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
	<Mails>
		<Mail name="A1519830731416" notifyrule="statusbacktorequester" displayname="statusbacktorequester" toaddtaskrole="true" description="Status back to requester" torole="A1520354902353">
		</Mail>
		<Mail name="A1519830834976" notifyrule="revokeactionbacktorequester" displayname="revokeactionbacktorequester" description="Revoke action status back to requester" torole="A1520354902353" toaddtaskrole="true">
		</Mail>
		<Mail name="A1519832451818" notifyrule="requestdenied" displayname="requestdeniedbacktorequester" description="Request denied by manager" toaddtaskrole="true" torole="A1520354902353">
		</Mail>
		<Mail name="A1521799290622" notifyrule="revokeaccesspermPending" displayname="revokeaccesspermission" description="Initial - Revoke access permission" torole="A1519737201205"/>
		<Mail name="A1521799358357" notifyrule="revokeaccesspermReminder" displayname="revokeaccesspermReminder" description="Reminder - Revoke access persmission" torole="A1519737201205"/>
	</Mails>
</Workflow>
