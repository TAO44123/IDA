<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="br_deleteDelegation" displayname="Delete delegation for {dataset.delegator_fullname.get()}" description="Deletion of a delegation" scriptfile="/workflow/bw_delegations/delegations.javascript" technical="true" statictitle="Delete delegation" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="450" y="39" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1403531629029"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="externalreference" attribute="delegationRecordUid"/>
				<Attribute name="description" attribute="description"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketAction" startidentityvariable="requestor" startdisplaynamevariable="requestor_fullname"/>
			<Actions>
				<Action name="U1566565028927" action="update" attribute="description" newvalue="Delete delegation from {dataset.delegator_fullname.get()} to {dataset.delegate_fullname.get()} by {dataset.requestor_fullname.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="450" y="475" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1403531531951" priority="1"/>
		<Component name="C1403531531951" type="deletedelegationactivity" x="374" y="150" w="200" h="98" title="Delete delegation">
			<Delegation name="delegation" delegationrecordnumber="delegationRecordUid"/>
		</Component>
		<Link name="L1403531553571" source="C1403531531951" target="C1566563762967" priority="1"/>
		<Component name="C1566563762967" type="ticketreviewactivity" x="324" y="303" w="300" h="98" title="Create ticket for audit logs">
			<TicketReview ticketaction="ticketAction">
				<Identity identityvariable="delegator"/>
				<Attribute name="custom1" attribute="delegator"/>
				<Attribute name="custom2" attribute="delegator_fullname"/>
				<Attribute name="custom3" attribute="delegate"/>
				<Attribute name="custom4" attribute="delegate_fullname"/>
				<Attribute name="comment" attribute="description"/>
				<Attribute name="custom6" attribute="comment"/>
				<Attribute name="custom8" attribute="beginDate"/>
				<Attribute name="custom9" attribute="endDate"/>
			</TicketReview>
		</Component>
		<Link name="L1566563768978" source="C1566563762967" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1403531601817" variable="delegationRecordUid" displayname="Delegation Record UID" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1527015436907" variable="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="DELEGATION" notstoredvariable="true"/>
		<Variable name="A1566563655575" variable="ticketAction" displayname="Ticket Action" editortype="Default" type="Number" multivalued="false" visibility="local" description="Start action ticket number" notstoredvariable="true"/>
		<Variable name="A1566563732430" variable="requestor" displayname="Requestor" editortype="Process Actor" type="String" multivalued="false" visibility="local" description="Requestor" notstoredvariable="true"/>
		<Variable name="A1566563741462" variable="requestor_fullname" displayname="Requestor Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Requestor Fullname" notstoredvariable="true"/>
		<Variable name="A1566564082993" variable="delegate" displayname="Delegate" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" description="Delegate" notstoredvariable="true"/>
		<Variable name="A1566564094856" variable="delegate_fullname" displayname="Delegate Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegate Fullname" notstoredvariable="true"/>
		<Variable name="A1566564108504" variable="delegator" displayname="Delegator" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" description="Delegator" notstoredvariable="true"/>
		<Variable name="A1566564121338" variable="delegator_fullname" displayname="Delegator Fullname" editortype="Default" type="String" multivalued="false" visibility="local" description="Delegator Fullname" notstoredvariable="true"/>
		<Variable name="A1566564137624" variable="beginDate" displayname="Begin Date" editortype="Default" type="Date" multivalued="false" visibility="local" description="Delegation begin date" notstoredvariable="true"/>
		<Variable name="A1566564149760" variable="endDate" displayname="End Date" editortype="Default" type="Date" multivalued="false" visibility="local" description="Delegation end date" notstoredvariable="true"/>
		<Variable name="A1566565001919" variable="description" displayname="Description" editortype="Default" type="String" multivalued="false" visibility="local" description="Description" notstoredvariable="true"/>
		<Variable name="A1566565131813" variable="comment" displayname="Comment" editortype="Default" type="String" multivalued="false" visibility="local" description="Comment" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1403531629029" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ProcessRole" description="Process role">
			<Rule name="A1403531654915" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
