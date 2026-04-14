<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_refreshitsmticketsperrepository" statictitle="refreshitsmticketsperrepository" scriptfile="/workflow/bw_iasreview/refreshitsmticketsperrepository.javascript" displayname="refreshitsmticketsperrepository" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="179" y="53" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1655219014095" action="executeview" viewname="bwiasr_itsms" append="false" attribute="itsmtype">
					<ViewParam name="P16552190140950" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219014095_1" attribute="bwr_remediation_itsmdef_type" variable="itsmtype"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="179" y="599" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1655219273375" priority="1" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;servicenow&apos;, false, true))" labelcustom="true" label="ServiceNow"/>
		<Component name="C1655219273375" type="callactivity" x="53" y="223" w="300" h="98" title="ServiceNow account repository polling">
			<Process workflowfile="/workflow/bw_iasreview/refreshitsmticketsperrepositoryservicenow.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655281701283" variable="repository" content="repository"/>
				<Input name="A1656663964103" variable="debug" content="debug"/>
			</Process>
		</Component>
		<Link name="L1655219343520" source="CSTART" target="C1655219273375_1" priority="2" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;jira&apos;, false, true))" labelcustom="true" label="Jira"/>
		<Component name="C1655219273375_1" type="callactivity" x="465" y="223" w="300" h="98" title="Jira account repository polling">
			<Process workflowfile="/workflow/bw_iasreview/refreshitsmticketsperrepositoryjira.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655281701283" variable="repository" content="repository"/>
				<Input name="A1656663964103" variable="debug" content="debug"/>
			</Process>
		</Component>
		<Link name="L1663092890807" source="CSTART" target="CEND" priority="3"/>
		<Link name="L1707155423555" source="C1655219273375" target="CEND" priority="1"/>
		<Link name="L1707155426333" source="C1655219273375_1" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1655217226547" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552190140950" variable="itsmtype" displayname="itsmtype" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A1656663923325" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
	</Variables>
</Workflow>
