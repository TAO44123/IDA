<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmticketsperapplication" statictitle="inititsmticketsperapplication" scriptfile="/workflow/bw_iasreview/inititsmticketsperapplication.javascript" displayname="inititsmticketsperapplication" type="builtin-technical-workflow" technical="true">
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
		<Component name="C1655219273375" type="callactivity" x="69" y="223" w="300" h="98" title="ServiceNow application remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketsperapplicationservicenow.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1656434986700" variable="application" content="application"/>
				<Input name="A1656663103730" variable="debug" content="debug"/>
				<Input name="A1741810430560" variable="retrymode" content="retrymode"/>
				<Input name="A1756198890252" variable="applicationtype" content="applicationtype"/>
			</Process>
		</Component>
		<Link name="L1655219282913" source="C1655219273375" target="CEND" priority="1"/>
		<Link name="L1655219343520" source="CSTART" target="C1655219273375_1" priority="2" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;mail&apos;, false, true))" labelcustom="true" label="Mail"/>
		<Component name="C1655219273375_1" type="callactivity" x="407" y="223" w="300" h="98" title="Mail application remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketsperapplicationmail.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1656434986700" variable="application" content="application"/>
				<Input name="A1656663103730" variable="debug" content="debug"/>
				<Input name="A1756204441510" variable="applicationtype" content="applicationtype"/>
			</Process>
		</Component>
		<Link name="L1662623370290" source="C1655219273375_1" target="CEND" priority="1"/>
		<Link name="L1662623371935" source="CSTART" target="C1655219273375_2" priority="3" expression="(dataset.equals(&apos;itsmtype&apos;, &apos;jira&apos;, false, true))" labelcustom="true" label="Jira"/>
		<Component name="C1655219273375_2" type="callactivity" x="764" y="223" w="300" h="98" title="Jira application remediation">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketsperapplicationjira.workflow">
				<Input name="A1655281696557" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1656434986700" variable="application" content="application"/>
				<Input name="A1656663103730" variable="debug" content="debug"/>
				<Input name="A1743106072691" variable="retrymode" content="retrymode"/>
				<Input name="A1756204486685" variable="applicationtype" content="applicationtype"/>
			</Process>
		</Component>
		<Link name="L1663155124198" source="C1655219273375_2" target="CEND" priority="1"/>
		<Link name="L1663155125889" source="CSTART" target="CEND" priority="4"/>
	</Definition>
	<Variables>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552190140950" variable="itsmtype" displayname="itsmtype" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A1656433890150" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1656663077058" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1741810379013" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1756198741265" variable="applicationtype" displayname="applicationtype" editortype="Default" type="String" multivalued="false" visibility="in" description="Application is Profile or Server" notstoredvariable="true"/>
	</Variables>
</Workflow>
