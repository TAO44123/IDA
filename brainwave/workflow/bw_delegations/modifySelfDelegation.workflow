<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="br_modifySelfDelegation" displayname="Modify delegation for {dataset.delegator_fullname.get()}" scriptfile="/workflow/bw_delegations/delegations.javascript" technical="true" statictitle="Modify delegation in self-service mode" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="416" y="48" w="200" h="114" title="Start" compact="true">
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
			<Output name="output" startidentityvariable="requestor" ticketactionnumbervariable="ticketAction"/>
			<Actions>
				<Action name="U1527015107039" action="executeview" viewname="br_identityDetail" append="false" attribute="delegator_fullname">
					<ViewParam name="P15270151070390" param="uid" paramvalue="{dataset.delegator.get()}"/>
					<ViewAttribute name="P1527015107039_1" attribute="fullname" variable="delegator_fullname"/>
				</Action>
				<Action name="U1566565843411" action="update" attribute="description" newvalue="Modify delegation from {dataset.delegator_fullname.get()} to {dataset.delegate_fullname.get()}"/>
				<Action name="U1756719188975" action="update" attribute="endDate" newvalue="{ dataset.endDate.get().toLDAPString().substring( 0, &apos;yyyyMMdd&apos;.length ) + &apos;235959&apos; }" condition="(! dataset.isEmpty(&apos;endDate&apos;))"/>
			</Actions>
			<FormVariable name="A1527017803070" variable="beginDate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017808220" variable="comment" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017823343" variable="delegate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017830363" variable="delegator" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017835971" variable="endDate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017846757" variable="label" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017852699" variable="processDefinitions" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1527017859579" variable="roles" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="416" y="568" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1403537946202" priority="1"/>
		<Component name="C1403537946202" type="updatedelegationactivity" x="340" y="153" w="200" h="98" title="Modify delegation">
			<Delegation name="delegation" delegationrecordnumber="delegationRecordUid" requestor="requestor" begindate="beginDate" enddate="endDate" label="label" comment="comment" rolelist="roles" procdeflist="processDefinitions" delegatee="delegate"/>
		</Component>
		<Link name="L1403537982903" source="C1403537946202" target="C1566565976470" priority="1"/>
		<Component name="C1526637635699_1" type="mailnotificationactivity" x="340" y="422" w="200" h="98" title="Send email to delegate">
			<Notification name="mail" mail="A1527014548203" ignoreerror="true"/>
		</Component>
		<Link name="L1527014307095" source="C1526637635699_1" target="CEND" priority="1"/>
		<Component name="C1566565976470" type="ticketreviewactivity" x="290" y="282" w="300" h="98" title="Create ticket for audit logs">
			<TicketReview ticketaction="ticketAction">
				<Attribute name="comment" attribute="description"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegator_fullname"/>
				<Attribute name="custom3" attribute="delegate"/>
				<Attribute name="custom4" attribute="delegate_fullname"/>
				<Attribute name="custom6" attribute="comment"/>
				<Attribute name="custom8" attribute="beginDate"/>
				<Attribute name="custom9" attribute="endDate"/>
				<Identity identityvariable="delegator"/>
			</TicketReview>
		</Component>
		<Link name="L1566565982407" source="C1566565976470" target="C1526637635699_1" priority="1"/>
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
		<Variable name="A1527014470691" variable="delegate" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" description="" notstoredvariable="true" displayname="  "/>
		<Variable name="A1527014713358" variable="delegator_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527015171673" variable="delegator" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527015288973" variable="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="DELEGATION" notstoredvariable="true"/>
		<Variable name="A1566565752938" variable="ticketAction" displayname="Ticket Action" editortype="Default" type="Number" multivalued="false" visibility="local" description="Start action ticket number" notstoredvariable="true"/>
		<Variable name="A1566565762241" variable="description" displayname="Description" editortype="Default" type="String" multivalued="false" visibility="local" description="Description" notstoredvariable="true"/>
		<Variable name="A1566565773177" variable="delegate_fullname" displayname="Delegate Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegate Fullname" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1403538372855" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ProcessRole" description="Process role">
			<Rule name="A1403538389375" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1527014342984" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="Delegate" description="Delegate">
			<Variable name="A1527014470691" variable="delegate"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1527014548203" torole="A1527014342984" displayname="delegation notification" notifyrule="delegation_notification">
			<Param name="start_date" variable="beginDate"/>
			<Param name="end_date" variable="endDate"/>
			<Param name="comment" variable="comment"/>
			<Param name="delegateuid" variable="delegate"/>
			<Param name="delegator" variable="delegator_fullname"/>
		</Mail>
	</Mails>
</Workflow>
