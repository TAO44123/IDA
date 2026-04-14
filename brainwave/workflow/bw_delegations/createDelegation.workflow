<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="br_createDelegation" displayname="Create delegation for {dataset.delegator_fullname.get()}" description="Workflow for delegation creation initiated by an administrator" scriptfile="workflow/bw_delegations/delegations.javascript" technical="true" statictitle="Create delegation in administration mode" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="453" y="44" w="200" h="114" title="Start" compact="true">
			<FormVariable name="A1408631157812" variable="delegator" action="input" mandatory="true" longlist="false"/>
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
			<Output name="output" startidentityvariable="requestor" startdisplaynamevariable="requestor_fullname" ticketactionnumbervariable="ticketAction"/>
			<Actions>
				<Action name="U1529047174634" action="executeview" viewname="br_identityDetail" append="false" attribute="delegator_email">
					<ViewParam name="P15290471746340" param="uid" paramvalue="{dataset.delegator.get()}"/>
					<ViewAttribute name="P1529047174634_1" attribute="mail" variable="delegator_email"/>
					<ViewAttribute name="P1529047174634_2" attribute="fullname" variable="delegator_fullname"/>
				</Action>
				<Action name="U1566564861861" action="update" attribute="description" newvalue="Create delegation from {dataset.delegator_fullname.get()} to {dataset.delegate_fullname.get()} by admin {dataset.requestor_fullname.get()}"/>
				<Action name="U1756719134180" action="update" attribute="endDate" newvalue="{ dataset.endDate.get().toLDAPString().substring( 0, &apos;yyyyMMdd&apos;.length ) + &apos;235959&apos; }" condition="(! dataset.isEmpty(&apos;endDate&apos;))"/>
			</Actions>
		</Component>
		<Component  name="CEND" type="endactivity" x="453" y="604" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1403527901415" priority="1"/>
		<Component name="C1403527901415" type="createdelegationactivity" x="377" y="143" w="200" h="98" title="Create delegation">
			<Delegation name="delegation" requestor="requestor" delegator="delegator" delegatee="delegate" label="label" comment="comment" begindate="beginDate" enddate="endDate" rolelist="roles" procdeflist="processDefinitions"/>
		</Component>
		<Link name="L1403527915933" source="C1403527901415" target="C1566561804452" priority="1"/>
		<Component name="C1404333413801" type="mailnotificationactivity" x="377" y="467" w="200" h="98" title="Notify delegate">
			<Notification name="mail" mail="A1430128183326" ignoreerror="true"/>
		</Component>
		<Link name="L1404333427675" source="C1404333413801" target="CEND" priority="1"/>
		<Component name="C1566561804452" type="ticketreviewactivity" x="327" y="297" w="300" h="98" title="Create ticket for audit logs">
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
		<Link name="L1566561815915" source="C1566561804452" target="C1404333413801" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1403528089181" variable="requestor" displayname="Requestor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528147465" variable="delegator" displayname="Delegator" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528163527" variable="delegate" displayname="Delegatee" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528194442" variable="label" displayname="Label" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528208438" variable="comment" displayname="Comment" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528235221" variable="beginDate" displayname="Begin date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528250170" variable="endDate" displayname="End date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528275681" variable="roles" displayname="Roles" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1403528297266" variable="processDefinitions" displayname="Process definitions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1404337279447" variable="delegator_fullname" displayname="delegator_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1430128817699" variable="requestor_fullname" displayname="requestor_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1566561883350" variable="ticketAction" displayname="Ticket Action" editortype="Default" type="Number" multivalued="false" visibility="local" description="Start activity ticket action number" notstoredvariable="true"/>
		<Variable name="A1566561955602" variable="tickettype" displayname="Ticket Type" editortype="Default" type="String" multivalued="false" visibility="local" description="Ticket Type" initialvalue="DELEGATION" notstoredvariable="true"/>
		<Variable name="A1566562335219" variable="delegate_fullname" displayname="Delegate Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegate Fullname" notstoredvariable="true"/>
		<Variable name="A1430128375224" variable="delegator_email" displayname="delegator_email" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1566564834736" variable="description" displayname="Description" editortype="Default" type="String" multivalued="false" visibility="local" description="Ticket description" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1403528326567" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ProcessRole" description="Process role">
			<Rule name="A1403528401959" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1404336706136" displayname="delegate" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png">
			<Variable name="A1403528163527" variable="delegate"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1430128183326" displayname="delegate_admin_notification" description="delegate_admin_notification" notifyrule="delegation_admin_notification" torole="A1404336706136">
			<Param name="delegator" variable="delegator_fullname"/>
			<Param name="comment" variable="comment"/>
			<Param name="delegator_email" variable="delegator_email"/>
			<Param name="administrator_fullname" variable="requestor_fullname"/>
			<Param name="delegateuid" variable="delegate"/>
			<Param name="start_date" variable="beginDate"/>
			<Param name="end_date" variable="endDate"/>
		</Mail>
	</Mails>
</Workflow>
