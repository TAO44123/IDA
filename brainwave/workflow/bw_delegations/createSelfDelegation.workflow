<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="br_createSelfDelegation" displayname="Create delegation for {dataset.delegator_fullname.get()}" description="Workflow for delegation creation" scriptfile="workflow/bw_delegations/delegations.javascript" technical="true" statictitle="Create delegation in self-service mode" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="223" y="44" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1403528326567"/>
			<FormVariable name="A1403528504985" variable="delegate" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1403528527116" variable="label" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1403528535488" variable="beginDate" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1403528542869" variable="endDate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1403528570749" variable="comment" action="input" mandatory="false" longlist="false"/>
			<Page name="createDelegation" template="/library/pagetemplates/workflow/startProcess.pagetemplate"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="description" attribute="description"/>
				<Attribute name="externalreference" attribute="label"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegate"/>
				<Attribute name="custom3" attribute="beginDate"/>
				<Attribute name="custom4" attribute="endDate"/>
			</Ticket>
			<Output name="output" startidentityvariable="requestor" ticketactionnumbervariable="ticketAction" startdisplaynamevariable="requestor_fullname"/>
			<Actions>
				<Action name="U1527015026182" action="executeview" viewname="br_identityDetail" append="false" attribute="delegator_fullname">
					<ViewParam name="P15270150261820" param="uid" paramvalue="{dataset.delegator.get()}"/>
					<ViewAttribute name="P1527015026182_1" attribute="fullname" variable="delegator_fullname"/>
				</Action>
				<Action name="U1566564969919" action="update" attribute="description" newvalue="Create delegation from {dataset.delegator_fullname.get()} to {dataset.delegate_fullname.get()} "/>
				<Action name="U1756718492910" action="update" attribute="endDate" newvalue="{ dataset.endDate.get().toLDAPString().substring( 0, &apos;yyyyMMdd&apos;.length ) + &apos;235959&apos; }" condition="(! dataset.isEmpty(&apos;endDate&apos;))"/>
			</Actions>
			<FormVariable name="A1527017784787" variable="delegator" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="223" y="602" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1403527901415" priority="1"/>
		<Component name="C1403527901415" type="createdelegationactivity" x="147" y="126" w="200" h="98" title="Create delegation">
			<Delegation name="delegation" requestor="requestor" delegatee="delegate" label="label" comment="comment" begindate="beginDate" enddate="endDate" rolelist="roles" procdeflist="processDefinitions" delegator="delegator"/>
		</Component>
		<Link name="L1403527915933" source="C1403527901415" target="C1566563475922" priority="1"/>
		<Component name="C1526637635699" type="mailnotificationactivity" x="147" y="428" w="200" h="98" title="Send email to delegate">
			<Notification name="mail" mail="A1526582618665" ignoreerror="true"/>
		</Component>
		<Link name="L1526637642985" source="C1526637635699" target="CEND" priority="1"/>
		<Component name="C1566563475922" type="ticketreviewactivity" x="97" y="283" w="300" h="98" title="Create ticket for audit logs">
			<TicketReview ticketaction="ticketAction">
				<Attribute name="comment" attribute="description"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegator_fullname"/>
				<Attribute name="custom3" attribute="delegate"/>
				<Attribute name="custom4" attribute="delegate_fullname"/>
				<Attribute name="custom8" attribute="beginDate"/>
				<Attribute name="custom9" attribute="endDate"/>
				<Identity identityvariable="delegator"/>
				<Attribute name="custom6" attribute="comment"/>
			</TicketReview>
		</Component>
		<Link name="L1566563483422" source="C1566563475922" target="C1526637635699" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1403528089181" variable="requestor" displayname="Requestor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528163527" variable="delegate" displayname="Delegate" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528194442" variable="label" displayname="Label" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528208438" variable="comment" displayname="Comment" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528235221" variable="beginDate" displayname="Begin date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528250170" variable="endDate" displayname="End date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528275681" variable="roles" displayname="Roles" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1403528297266" variable="processDefinitions" displayname="Process definitions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1526636055876" variable="delegator_fullname" displayname="delegator_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1526636121839" variable="tickettype" displayname="Delegation Ticket Type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="DELEGATION" notstoredvariable="false"/>
		<Variable name="A1527014901528" variable="delegator" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1566563443226" variable="ticketAction" displayname="Ticket Action" editortype="Default" type="Number" multivalued="false" visibility="local" description="Start ticket action number" notstoredvariable="true"/>
		<Variable name="A1566563458978" variable="delegate_fullname" displayname="Delegate fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegate fullname" notstoredvariable="true"/>
		<Variable name="A1566563707268" variable="requestor_fullname" displayname="Requestor Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Requestor Fullname" notstoredvariable="true"/>
		<Variable name="A1566564906766" variable="description" displayname="Description" editortype="Default" type="String" multivalued="false" visibility="local" description="Description" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1403528326567" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ProcessRole" description="Process role">
			<Rule name="A1403528401959" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1526582837102" smallicon="/reports/icons/16/people/personal_16.png" displayname="Delegate" icon="/reports/icons/48/people/personal_48.png" description="Delegate">
			<Variable name="A1403528163527" variable="delegate"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1526582618665" displayname="Delegation notification" description="Delegation notification&#x9;" notifyrule="delegation_notification" torole="A1526582837102">
			<Param name="comment" variable="comment"/>
			<Param name="delegateuid" variable="delegate"/>
			<Param name="start_date" variable="beginDate"/>
			<Param name="delegator" variable="delegator_fullname"/>
			<Param name="end_date" variable="endDate"/>
		</Mail>
	</Mails>
</Workflow>
