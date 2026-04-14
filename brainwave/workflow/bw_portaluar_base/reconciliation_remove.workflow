<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_reconciliation_remove" statictitle="delete reconciliation" scriptfile="/workflow/bw_portaluar_base/reconciliation_remove.javascript" displayname="delete reconciliation for {dataset.login}/{dataset.repositoryname}" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="49" y="234" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="custom1" attribute="account"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketnumber"/>
			<Candidates name="role" role="A1529425433090"/>
			<Actions>
				<Action name="U1598367337011" action="executeview" viewname="br_accountDetail" append="false" attribute="login">
					<ViewParam name="P15983673370110" param="uid" paramvalue="{dataset.account.get()}"/>
					<ViewAttribute name="P1598367337011_1" attribute="login" variable="login"/>
					<ViewAttribute name="P1598367337011_2" attribute="repository_displayname" variable="repositoryname"/>
				</Action>
				<Action name="U1601793655765" action="update" attribute="TICKETCOMMENT" newvalue="Delete reconciliation for {dataset.login.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="1040" y="234" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1529425886508" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1529425623172" type="ticketreviewactivity" x="637" y="209" w="300" h="98" title="Ticket">
			<TicketReview ticketaction="ticketnumber" ticketactors="by" ticketaccountables="by">
				<Account accountvariable="account"/>
				<Attribute name="status" attribute="TICKETSTATUS"/>
				<Attribute name="comment" attribute="TICKETCOMMENT"/>
			</TicketReview>
		</Component>
		<Link name="L1529425637192" source="C1529425623172" target="CEND" priority="1"/>
		<Component name="C1590661779140" type="deletereconciliationactivity" x="218" y="209" w="300" h="98" title="Remove recon">
			<Reconciliation name="reconciliation" accountrecordnumber="account"/>
		</Component>
		<Link name="L1590661784099" source="CSTART" target="C1590661779140" priority="1"/>
		<Link name="L1590661785619" source="C1590661779140" target="C1529425623172" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1529425125449" variable="account" displayname="account" editortype="Ledger Account" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425781864" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="RECONCILIATION"/>
		<Variable name="A1529425795590" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false"/>
		<Variable name="A1529425823817" variable="ticketdescription" displayname="ticketdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="MANUAL_RECON_REMOVE"/>
		<Variable name="A1529426017572" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1598367269283" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1598367276404" variable="repositoryname" displayname="repositoryname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1601793234259" variable="by" displayname="by" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="the one who removed the reconciliation" notstoredvariable="true"/>
		<Variable name="A1601793273485" variable="TICKETSTATUS" displayname="TICKETSTATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="reconciled-remove" notstoredvariable="true"/>
		<Variable name="A1601793621925" variable="TICKETCOMMENT" displayname="TICKETCOMMENT" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1529425433090" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="Everybody" description="Everybody">
			<Rule name="A1529425440512" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
