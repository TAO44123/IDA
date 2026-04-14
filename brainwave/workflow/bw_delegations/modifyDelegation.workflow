<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="br_modifyDelegation" displayname="Modify delegation for {dataset.delegator_fullname.get()}" scriptfile="workflow/bw_delegations/delegations.javascript" technical="true" description="Delegator and delegate cannot be modified. Only start / end date and delegation scope can be modified." statictitle="Modify delegation in administration mode" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="423" y="48" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1403538372855"/>
			<Page name="modifyDelegation"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="description" attribute="description"/>
				<Attribute name="externalreference" attribute="label"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegate"/>
				<Attribute name="custom3" attribute="beginDate"/>
				<Attribute name="custom4" attribute="endDate"/>
			</Ticket>
			<Output name="output" startidentityvariable="requestor" startdisplaynamevariable="requestor_fullname" ticketactionnumbervariable="ticketAction"/>
			<FormVariable name="A1527531888061" variable="delegate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531894478" variable="delegator" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531901661" variable="beginDate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531907443" variable="endDate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531912683" variable="label" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531918799" variable="comment" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531928121" variable="delegationRecordUid" action="display" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531935094" variable="processDefinitions" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527531940171" variable="roles" action="input" mandatory="false" longlist="false"/>
			<Actions>
				<Action name="U1527532011053" action="executeview" viewname="br_identityDetail" append="false" attribute="delegator_fullname">
					<ViewParam name="P15275320110530" param="uid" paramvalue="{dataset.delegator.get()}"/>
					<ViewAttribute name="P1527532011053_1" attribute="fullname" variable="delegator_fullname"/>
					<ViewAttribute name="P1527532011053_2" attribute="mail" variable="delegator_email"/>
				</Action>
				<Action name="U1566565492243" action="update" attribute="description" newvalue="Modify delegation from {dataset.delegator_fullname.get()} to {dataset.delegate_fullname.get()} by admin {dataset.requestor_fullname.get()}"/>
				<Action name="U1756719162990" action="update" attribute="endDate" newvalue="{ dataset.endDate.get().toLDAPString().substring( 0, &apos;yyyyMMdd&apos;.length ) + &apos;235959&apos; }" condition="(! dataset.isEmpty(&apos;endDate&apos;))"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="423" y="569" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1403537946202" priority="1"/>
		<Component name="C1403537946202" type="updatedelegationactivity" x="347" y="145" w="200" h="98" title="Modify delegation">
			<Delegation name="delegation" delegationrecordnumber="delegationRecordUid" requestor="requestor" begindate="beginDate" enddate="endDate" label="label" comment="comment" rolelist="roles" procdeflist="processDefinitions"/>
		</Component>
		<Link name="L1403537982903" source="C1403537946202" target="C1566565417954" priority="1"/>
		<Component name="C1527531829579" type="mailnotificationactivity" x="347" y="423" w="200" h="98" title="Notify everybody">
			<Notification name="mail" mail="A1527530980704" ignoreerror="true"/>
		</Component>
		<Link name="L1527531835088" source="C1527531829579" target="CEND" priority="1"/>
		<Component name="C1566565417954" type="ticketreviewactivity" x="297" y="284" w="300" h="98" title="Create ticket for audit logs">
			<TicketReview ticketaction="ticketAction">
				<Identity identityvariable="delegator"/>
				<Attribute name="comment" attribute="description"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegator_fullname"/>
				<Attribute name="custom3" attribute="delegate"/>
				<Attribute name="custom4" attribute="delegate_fullname"/>
				<Attribute name="custom6" attribute="comment"/>
				<Attribute name="custom8" attribute="beginDate"/>
				<Attribute name="custom9" attribute="endDate"/>
			</TicketReview>
		</Component>
		<Link name="L1566565423566" source="C1566565417954" target="C1527531829579" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1403538178952" variable="delegationRecordUid" displayname="Delegation Record UID" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403538225724" variable="requestor" displayname="Requestor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403538266591" variable="beginDate" displayname="Begin date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403538285426" variable="endDate" displayname="End date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403538327245" variable="label" displayname="Label" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403538349750" variable="comment" displayname="Comment" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403599474895" variable="roles" displayname="Roles" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403599525866" variable="processDefinitions" displayname="Process definitions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527530671064" variable="delegate" displayname="delegate" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527530683712" variable="delegator" displayname="delegator" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527530706531" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="DELEGATION" notstoredvariable="true"/>
		<Variable name="A1527530727374" variable="delegator_fullname" displayname="delegator_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527531783087" variable="requestor_fullname" displayname="requestor_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527532027037" variable="delegator_email" displayname="delegator_email" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1566565348693" variable="ticketAction" displayname="Ticket Action" editortype="Default" type="Number" multivalued="false" visibility="local" description="Ticket Action" notstoredvariable="true"/>
		<Variable name="A1566565460956" variable="description" displayname="Description" editortype="Default" type="String" multivalued="false" visibility="local" description="Description" notstoredvariable="true"/>
		<Variable name="A1566565507780" variable="delegate_fullname" displayname="Delegate Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegate Fullname" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1403538372855" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ProcessRole" description="Process role">
			<Rule name="A1403538389375" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1527530759168" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="delegate" description="delegate for notification">
			<Variable name="A1527530671064" variable="delegate"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1527530980704" notifyrule="delegation_admin_notification" torole="A1527530759168" displayname="delegation_notification">
			<Param name="delegator" variable="delegator_fullname"/>
			<Param name="start_date" variable="beginDate"/>
			<Param name="end_date" variable="endDate"/>
			<Param name="comment" variable="comment"/>
			<Param name="delegateuid" variable="delegate"/>
			<Param name="delegator_email" variable="delegator_email"/>
			<Param name="administrator_fullname" variable="requestor_fullname"/>
		</Mail>
	</Mails>
</Workflow>
