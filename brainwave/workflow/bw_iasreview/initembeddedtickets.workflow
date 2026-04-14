<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_initembeddedtickets" statictitle="init embedded tickets" scriptfile="/workflow/bw_iasreview/initembeddedtickets.javascript" displayname="init embedded tickets" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="166" y="55" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655455409981"/>
			<Actions>
				<Action name="U1655455925851" action="executeview" viewname="bwiasr_initembeddedaccountsperrepo" append="false" attribute="remediationrecorduid">
					<ViewAttribute name="P1655455925851_0" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655455925851_1" attribute="repositorybwr_remediation_repository_type" variable="remediationtype"/>
				</Action>
				<Action name="U1657028717767" action="executeview" viewname="bwiasr_initembeddedrightsperappli" append="true" attribute="remediationrecorduid">
					<ViewAttribute name="P1657028717767_0" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1657028717767_1" attribute="applicationbwr_remediation_application_type" variable="remediationtype"/>
				</Action>
				<Action name="U1700217969604" action="executeview" viewname="bwiasr_initembeddedgroupmembershipperrepo" append="true" attribute="remediationrecorduid">
					<ViewAttribute name="P1700217969604_0" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1700217969604_1" attribute="bwr_remediation_repository_type" variable="remediationtype"/>
				</Action>
				<Action name="U1655455993329" action="multiresize" attribute="remediationrecorduid" attribute1="closedstatus" attribute2="status"/>
				<Action name="U1655456014886" action="multireplace" attribute="closedstatus" newvalue="0"/>
				<Action name="U1655456033059" action="multireplace" attribute="status" newvalue="New"/>
				<Action name="U1657295816482" action="multireplace" attribute="remediationtype" newvalue="{!dataset.isEmpty(&apos;remediationtype&apos;)?dataset.remediationtype.get():&apos;embedded&apos;}"/>
				<Action name="U1700154119233" action="multifilter" attribute="remediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="closedstatus" attribute2="remediationtype" attribute3="status"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="166" y="351" w="200" h="98" title="End" compact="true"/>
		<Component name="C1655456112817" type="updateticketreviewactivity" x="40" y="181" w="300" h="98" title="activate embedded remediations">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="status"/>
				<Attribute name="custom2" attribute="closedstatus"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1655456154971" source="CSTART" target="C1655456112817" priority="1"/>
		<Link name="L1655456155700" source="C1655456112817" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655455409981" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655455418292" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A16554559258510" variable="remediationrecorduid" displayname="remediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A1655455932864" variable="status" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655455942923" variable="closedstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A16554559258511" variable="remediationtype" displayname="remediationtype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1700154038318" variable="filterbytickets" displayname="filterbytickets" editortype="Default" type="Number" multivalued="true" visibility="in" description="OPTIONAL: filter by tickets" notstoredvariable="true"/>
	</Variables>
</Workflow>
