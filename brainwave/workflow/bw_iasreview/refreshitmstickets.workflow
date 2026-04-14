<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_refreshitmstickets" statictitle="refreshitmstickets" scriptfile="/workflow/bw_iasreview/refreshitmstickets.javascript" displayname="refresh itms tickets" technical="true">
		<Component name="CSTART" type="startactivity" x="298" y="77" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
			</Ticket>
			<Candidates name="role" role="A1655367126601"/>
			<Actions>
				<Action name="U1655367382651" action="executeview" viewname="bwiasr_pendingaccountsperrepo" append="false" attribute="repository">
					<ViewParam name="P16553673826510" param="filterbyremediationsintance" paramvalue="{dataset.filterbyremediationsintance.get()}"/>
					<ViewAttribute name="P1655367382651_1" attribute="repositoryuid" variable="repository"/>
					<ViewAttribute name="P1655367382651_2" attribute="repositorybwr_remediation_repository_instancecode" variable="remediationinstancecode"/>
				</Action>
				<Action name="U1655367432449" action="multiclean" attribute="repository" emptyvalues="true" duplicates="true" attribute1="remediationinstancecode"/>
				<Action name="U1707154909182" action="executeview" viewname="bwiasr_pendinggroupsperrepo" append="false" attribute="grouprepository">
					<ViewParam name="P17071549091820" param="filterbyremediationsintance" paramvalue="{dataset.filterbyremediationsintance.get()}"/>
					<ViewAttribute name="P1707154909182_1" attribute="repositoryuid" variable="grouprepository"/>
					<ViewAttribute name="P1707154909182_2" attribute="repositorybwr_remediation_repository_instancecode" variable="groupremediationinstancecode"/>
				</Action>
				<Action name="U1707155027308" action="multiclean" attribute="grouprepository" emptyvalues="true" duplicates="true" attribute1="groupremediationinstancecode"/>
				<Action name="U1656603120824" action="executeview" viewname="bwiasr_pendingrightsperappli" append="false" attribute="application">
					<ViewParam name="P16566031208240" param="filterbyremediationsintance" paramvalue="{dataset.filterbyremediationsintance.get()}"/>
					<ViewAttribute name="P1656603120824_1" attribute="applicationuid" variable="application"/>
					<ViewAttribute name="P1656603120824_2" attribute="applicationbwr_remediation_application_instancecode" variable="applicationremediationinstancecode"/>
				</Action>
				<Action name="U1656603175932" action="multiclean" attribute="application" emptyvalues="true" duplicates="true" attribute1="applicationremediationinstancecode"/>
				<Action name="U1656663896551" action="update" attribute="debug" newvalue="{(config.sndebug!=null&amp;&amp;&apos;true&apos;.equalsIgnoreCase(config.sndebug))?true:false}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="298" y="644" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655369959407" priority="1"/>
		<Component name="C1655369959407" type="callactivity" x="172" y="192" w="300" h="98" title="refreshitsmticketsperaccountrepository">
			<Process workflowfile="/workflow/bw_iasreview/refreshitsmticketsperrepository.workflow">
				<Input name="A1655369990057" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1655369993864" variable="repository" content="repository"/>
				<Input name="A1656664026170" variable="debug" content="debug"/>
			</Process>
			<Iteration listvariable="repository" sequential="true">
				<Variable name="A1655370008966" variable="remediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1655369973858" source="C1655369959407" target="C1655369959407_2" priority="1"/>
		<Component name="C1655369959407_1" type="callactivity" x="172" y="485" w="300" h="98" title="refreshitsmticketsperapplication">
			<Process workflowfile="/workflow/bw_iasreview/refreshitsmticketsperapplication.workflow">
				<Input name="A1655369990057" variable="remediationinstancecode" content="applicationremediationinstancecode"/>
				<Input name="A1656602803838" variable="application" content="application"/>
				<Input name="A1656664016415" variable="debug" content="debug"/>
			</Process>
			<Iteration listvariable="application" sequential="true">
				<Variable name="A1656602786054" variable="applicationremediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1656602729521" source="C1655369959407_1" target="CEND" priority="1"/>
		<Component name="C1655369959407_2" type="callactivity" x="172" y="338" w="300" h="98" title="refreshitsmticketspergrouprepository">
			<Process workflowfile="/workflow/bw_iasreview/refreshitsmticketspergrouprepository.workflow">
				<Input name="A1707155531042" variable="debug" content="debug"/>
				<Input name="A1707155538748" variable="remediationinstancecode" content="groupremediationinstancecode"/>
				<Input name="A1707155544537" variable="repository" content="grouprepository"/>
			</Process>
			<Iteration listvariable="grouprepository" sequential="true">
				<Variable name="A1707155565883" variable="groupremediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1707155456455" source="C1655369959407_2" target="C1655369959407_1" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655367126601" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655367135441" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655367178651" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655367195641" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655469754441" variable="filterbyremediationsintance" displayname="filterbyremediationsintance" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655714125328" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REMEDIATION_REFRESHITSMTICKETS" notstoredvariable="true"/>
		<Variable name="A1656602757545" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1656602771187" variable="applicationremediationinstancecode" displayname="applicationremediationinstancecode" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1656663769700" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1707154580626" variable="grouprepository" displayname="grouprepository" editortype="Ledger Repository" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1707154758177" variable="groupremediationinstancecode" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
