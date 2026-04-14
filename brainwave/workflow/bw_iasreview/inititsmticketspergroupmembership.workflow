<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmticketspergroupmembership" statictitle="inititsmticketspergroupmembership" scriptfile="/workflow/bw_iasreview/inititsmticketsperrepository.javascript" displayname="inititsmticketspergroupmembership" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="195" y="53" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1655219014095" action="executeview" viewname="bwiasr_itsms" append="false" attribute="itsmtype">
					<ViewParam name="P16552190140950" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219014095_1" attribute="bwr_remediation_itsmdef_type" variable="itsmtype"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="195" y="444" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1655219273375" priority="1" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;servicenow&apos;, false, true))" labelcustom="true" label="ServiceNow"/>
		<Component name="C1655219273375" type="callactivity" x="69" y="224" w="300" h="98" title="ServiceNow group membership remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketspergroupmembershipservicenow.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655281701283" variable="repository" content="repository"/>
				<Input name="A1656663057146" variable="debug" content="debug"/>
				<Input name="A1741811557858" variable="retrymode" content="retrymode"/>
			</Process>
		</Component>
		<Link name="L1655219282913" source="C1655219273375" target="CEND" priority="1"/>
		<Link name="L1655219343520" source="CSTART" target="C1655219273375_2" priority="3" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;jira&apos;, false, true))" labelcustom="true" label="Jira"/>
		<Component name="C1655219273375_1" type="callactivity" x="409" y="224" w="300" h="98" title="Mail group membership remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketspergroupmembershipmail.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655281701283" variable="repository" content="repository"/>
				<Input name="A1656663057146" variable="debug" content="debug"/>
			</Process>
		</Component>
		<Link name="L1662484023309" source="CSTART" target="C1655219273375_1" priority="2" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;mail&apos;, false, true))" labelcustom="true" label="Mail"/>
		<Link name="L1662484025271" source="C1655219273375_1" target="CEND" priority="1"/>
		<Component name="C1655219273375_2" type="callactivity" x="747" y="224" w="300" h="98" title="Jira group membership remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketspergroupmembershipjira.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655281701283" variable="repository" content="repository"/>
				<Input name="A1656663057146" variable="debug" content="debug"/>
				<Input name="A1743106034890" variable="retrymode" content="retrymode"/>
			</Process>
		</Component>
		<Link name="L1663056983441" source="C1655219273375_2" target="CEND" priority="1"/>
		<Link name="L1663056985646" source="CSTART" target="CEND" priority="4"/>
		<Component name="N1700228303238" type="note" x="406" y="51" w="300" h="50" title="Remediation strategy broker for each repository"/>
	</Definition>
	<Variables>
		<Variable name="A1655217226547" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552190140950" variable="itsmtype" displayname="itsmtype" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A1656663025652" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1741811551416" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
