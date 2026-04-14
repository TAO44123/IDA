<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_reconciliation_owner" statictitle="update reconciliation" scriptfile="/workflow/bw_portaluar_base/reconciliation_owner.javascript" displayname="update reconciliation set {dataset.login}/{dataset.repositoryname} to {dataset.fullname}" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="49" y="234" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="custom1" attribute="account"/>
				<Attribute name="custom2" attribute="identity"/>
				<Attribute name="custom3" attribute="login"/>
				<Attribute name="custom4" attribute="repositoryname"/>
				<Attribute name="custom5" attribute="fullname"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketnumber"/>
			<Candidates name="role" role="A1529425433090"/>
			<Actions>
				<Action name="U1598367128775" action="executeview" viewname="br_accountDetail" append="false" attribute="login">
					<ViewParam name="P15983671287750" param="uid" paramvalue="{dataset.account.get()}"/>
					<ViewAttribute name="P1598367128775_1" attribute="login" variable="login"/>
					<ViewAttribute name="P1598367128775_2" attribute="repository_displayname" variable="repositoryname"/>
				</Action>
				<Action name="U1598367179466" action="executeview" viewname="br_identityDetail" append="false" attribute="fullname">
					<ViewParam name="P15983671794660" param="uid" paramvalue="{dataset.identity.get()}"/>
					<ViewAttribute name="P1598367179466_1" attribute="fullname" variable="fullname"/>
				</Action>
				<Action name="U1601793488227" action="update" attribute="TICKETCOMMENT" newvalue="Reconcile {dataset.login.get()} to {dataset.fullname.get()} {!dataset.isEmpty(&apos;comment&apos;)?(&apos; with the followingcomment: &apos;+dataset.comment.get()):&apos;&apos;}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="1040" y="234" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1529425886508" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1529425586178" priority="1"/>
		<Component name="C1529425586178" type="updatereconciliationactivity" x="254" y="209" w="300" h="98" title="Reconciliation">
			<Reconciliation name="reconciliation" accountrecordnumber="account" updateidentity="identity" updatecomment="comment"/>
		</Component>
		<Component name="C1529425623172" type="ticketreviewactivity" x="637" y="209" w="300" h="98" title="Ticket">
			<TicketReview ticketaction="ticketnumber" ticketactors="by" ticketaccountables="by">
				<Account accountvariable="account"/>
				<Attribute name="comment" attribute="TICKETCOMMENT"/>
				<Attribute name="status" attribute="TICKETSTATUS"/>
			</TicketReview>
		</Component>
		<Link name="L1529425635246" source="C1529425586178" target="C1529425623172" priority="1"/>
		<Link name="L1529425637192" source="C1529425623172" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1529425125449" variable="account" displayname="account" editortype="Ledger Account" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425140735" variable="identity" displayname="identity" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425157826" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425781864" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="RECONCILIATION"/>
		<Variable name="A1529425795590" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false"/>
		<Variable name="A1529425823817" variable="ticketdescription" displayname="ticketdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="MANUAL_RECON_OWNER"/>
		<Variable name="A1529426017572" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1598366797033" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1598366805184" variable="repositoryname" displayname="repositoryname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1598366822820" variable="fullname" displayname="fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1601792885996" variable="TICKETSTATUS" displayname="TICKETSTATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="reconciled-user" notstoredvariable="true"/>
		<Variable name="A1601793014011" variable="by" displayname="by" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="the one who has done the reconciliation" notstoredvariable="true"/>
		<Variable name="A1601793371606" variable="TICKETCOMMENT" displayname="TICKETCOMMENT" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1529425433090" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="Everybody" description="Everybody">
			<Rule name="A1529425440512" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
