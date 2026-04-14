<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_reconciliation_noowner" statictitle="update reconciliation noowner" scriptfile="/workflow/bw_portaluar_base/reconciliation_noowner.javascript" displayname="update reconciliation noowner {dataset.noownercode} {dataset.login}/{dataset.repositoryname}" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="49" y="234" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="custom1" attribute="account"/>
				<Attribute name="custom2" attribute="login"/>
				<Attribute name="custom3" attribute="repositoryname"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketnumber"/>
			<Candidates name="role" role="A1529425433090"/>
			<Actions>
				<Action name="U1529499693784" action="update" attribute="noownercode" newvalue="leave" condition="(! dataset.isEmpty(&apos;leaver&apos;))"/>
				<Action name="U1598366679506" action="executeview" viewname="br_accountDetail" append="false" attribute="login">
					<ViewParam name="P15983666795060" param="uid" paramvalue="{dataset.account.get()}"/>
					<ViewAttribute name="P1598366679506_1" attribute="login" variable="login"/>
					<ViewAttribute name="P1598366679506_2" attribute="repository_displayname" variable="repositoryname"/>
				</Action>
				<Action name="U1601793606654" action="update" attribute="TICKETCOMMENT" newvalue="Reconcile {dataset.login.get()} as no owner code: {dataset.noownercode.get()} {!dataset.isEmpty(&apos;comment&apos;)?(&apos; with the following comment: &apos;+dataset.comment.get()):&apos;&apos;}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="1040" y="234" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1529425886508" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1529425623172" type="ticketreviewactivity" x="637" y="209" w="300" h="98" title="Ticket" inexclusive="true">
			<TicketReview ticketaction="ticketnumber" ticketactors="by" ticketaccountables="by">
				<Account accountvariable="account"/>
				<Attribute name="comment" attribute="TICKETCOMMENT"/>
				<Attribute name="status" attribute="TICKETSTATUS"/>
			</TicketReview>
		</Component>
		<Link name="L1529425637192" source="C1529425623172" target="CEND" priority="1"/>
		<Component name="C1529499152103" type="noownerreconciliationactivity" x="246" y="341" w="300" h="98" title="Reconciliation noowner">
			<Reconciliation name="reconciliation" accountrecordnumber="account" reconnoownercode="noownercode" reconnoownercomment="comment"/>
		</Component>
		<Link name="L1529499236916" source="C1529499152103" target="C1529425623172" priority="1"/>
		<Component name="C1529499300180" type="leavereconciliationactivity" x="246" y="87" w="300" h="98" title="Reconciliation with a leaver">
			<Reconciliation name="reconciliation" accountrecordnumber="account" reconleaveidentity="leaverfullname"/>
		</Component>
		<Link name="L1529499419522" source="C1529499300180" target="C1529425623172" priority="1"/>
		<Link name="L1529499436841" source="CSTART" target="C1529499300180" priority="1" expression="(dataset.equals(&apos;noownercode&apos;, &apos;leave&apos;, false, true))" labelcustom="true" label="If noownercode = leave"/>
		<Link name="L1529499473835" source="CSTART" target="C1529499152103" priority="2" labelcustom="true" label="If noownercode is not leave" expression="(! dataset.equals(&apos;noownercode&apos;, &apos;leave&apos;, false, true))"/>
	</Definition>
	<Variables>
		<Variable name="A1529425125449" variable="account" displayname="account" editortype="Ledger Account" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425157826" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1529425781864" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="RECONCILIATION"/>
		<Variable name="A1529425795590" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false"/>
		<Variable name="A1529425823817" variable="ticketdescription" displayname="ticketdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="MANUAL_RECON_NOOWNER"/>
		<Variable name="A1529426017572" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1529499124520" variable="noownercode" displayname="noownercode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1590654992195" variable="leaverfullname" displayname="leaverfullname" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1598366592521" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1598366598912" variable="repositoryname" displayname="repositoryname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1601793089789" variable="TICKETSTATUS" displayname="TICKETSTATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="reconciled-noowner" notstoredvariable="true"/>
		<Variable name="A1601793110964" variable="by" displayname="by" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="the one who reconciled the account" notstoredvariable="true"/>
		<Variable name="A1601793508543" variable="TICKETCOMMENT" displayname="TICKETCOMMENT" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1529425433090" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="Everybody" description="Everybody">
			<Rule name="A1529425440512" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
