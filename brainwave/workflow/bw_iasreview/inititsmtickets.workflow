<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmtickets" statictitle="inititsmtickets" scriptfile="/workflow/bw_iasreview/inititsmtickets.javascript" displayname="inititsmtickets" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="301" y="58" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655215897427"/>
			<Actions>
				<Action name="U1655217131432" action="executeview" viewname="bwiasr_initaccountsperrepobv" append="false" attribute="repository">
					<ViewParam name="P16552171314320" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1655217131432_1" attribute="repositoryuid" variable="repository"/>
					<ViewAttribute name="P1655217131432_2" attribute="repositorybwr_remediation_repository_instancecode" variable="remediationinstancecode"/>
					<ViewAttribute name="P1655217131432_3" attribute="remediationrecorduid" variable="remediationrecorduid"/>
				</Action>
				<Action name="U1700159601047" action="multifilter" attribute="remediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="remediationinstancecode" attribute2="repository"/>
				<Action name="U1655217292365" action="multiclean" attribute="repository" emptyvalues="true" duplicates="true" attribute1="remediationinstancecode" attribute2="remediationrecorduid"/>
				<Action name="U1656433311382" action="executeview" viewname="bwiasr_initrightsperapplibv" append="false" attribute="application">
					<ViewParam name="P16564333113820" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1656433311382_1" attribute="applicationuid" variable="application"/>
					<ViewAttribute name="P1656433311382_2" attribute="applicationbwr_remediation_application_instancecode" variable="applicationremediationinstancecode"/>
					<ViewAttribute name="P1656433311382_3" attribute="remediationrecorduid" variable="applicationremediationrecorduid"/>
					<ViewAttribute name="P1656433311382_4" attribute="applicationapplicationtype" variable="applicationtype"/>
				</Action>
				<Action name="U1700160146476" action="multifilter" attribute="applicationremediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="application" attribute2="applicationremediationinstancecode" attribute3="applicationtype"/>
				<Action name="U1656434131595" action="multiclean" attribute="application" emptyvalues="true" duplicates="true" attribute1="applicationremediationinstancecode" attribute2="applicationremediationrecorduid" attribute3="applicationtype"/>
				<Action name="U1669041419239" action="executeview" viewname="bwiasr_initrightspersafebv" append="false" attribute="safe">
					<ViewParam name="P16690414192390" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1669041419239_1" attribute="safeuid" variable="safe"/>
					<ViewAttribute name="P1669041419239_2" attribute="safebwr_remediation_application_instancecode" variable="saferemediationinstancecode"/>
					<ViewAttribute name="P1669041419239_3" attribute="remediationrecorduid" variable="saferemediationrecorduid"/>
				</Action>
				<Action name="U1700160187465" action="multifilter" attribute="saferemediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="safe" attribute2="saferemediationinstancecode"/>
				<Action name="U1669041815520" action="multiclean" attribute="safe" emptyvalues="true" duplicates="true" attribute1="saferemediationinstancecode" attribute2="saferemediationrecorduid"/>
				<Action name="U1700219665960" action="executeview" viewname="bwiasr_initgroupmembershipperrepobv" append="false" attribute="groupmembershiprepository">
					<ViewParam name="P17002196659600" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1700219665960_1" attribute="repositoryuid" variable="groupmembershiprepository"/>
					<ViewAttribute name="P1700219665960_2" attribute="repositorybwr_remediation_repository_instancecode" variable="groupmembershipremediationinstancecode"/>
					<ViewAttribute name="P1700219665960_3" attribute="remediationrecorduid" variable="groupmembershipremediationrecorduid"/>
				</Action>
				<Action name="U1700219821468" action="multifilter" attribute="groupmembershipremediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="groupmembershiprepository" attribute2="groupmembershipremediationinstancecode"/>
				<Action name="U1700219694778" action="multiclean" attribute="groupmembershiprepository" emptyvalues="true" duplicates="true" attribute1="groupmembershipremediationinstancecode" attribute2="groupmembershipremediationrecorduid"/>
				<Action name="U1656663006509" action="update" attribute="debug" newvalue="{(config.sndebug!=null&amp;&amp;&apos;true&apos;.equalsIgnoreCase(config.sndebug))?true:false}"/>
			</Actions>
			<FormVariable name="A1700666052817" variable="filterbytickets" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="301" y="861" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655217249604" priority="1"/>
		<Component name="C1655217249604" type="callactivity" x="175" y="171" w="300" h="98" title="create itsm&amp;mail tickets per repository">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketsperrepository.workflow">
				<Input name="A1655217321696" variable="repository" content="repository"/>
				<Input name="A1655218439663" variable="remediationinstancecode" content="remediationinstancecode"/>
				<Input name="A1656663114047" variable="debug" content="debug"/>
				<Input name="A1741811490799" variable="retrymode" content="retrymode"/>
			</Process>
			<Iteration listvariable="repository" sequential="true">
				<Variable name="A1655218454673" variable="remediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1655217267571" source="C1655217249604" target="C1655217249604_3" priority="1"/>
		<Component name="C1655217249604_1" type="callactivity" x="175" y="495" w="300" h="98" title="create itsm&amp;mail tickets per application">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketsperapplication.workflow">
				<Input name="A1655218439663" variable="remediationinstancecode" content="applicationremediationinstancecode"/>
				<Input name="A1656434099528" variable="application" content="application"/>
				<Input name="A1656663119791" variable="debug" content="debug"/>
				<Input name="A1741810467263" variable="retrymode" content="retrymode"/>
				<Input name="A1756198866086" variable="applicationtype" content="applicationtype"/>
			</Process>
			<Iteration listvariable="application" sequential="true">
				<Variable name="A1656434160087" variable="applicationremediationinstancecode"/>
				<Variable name="A1756198814907" variable="applicationtype"/>
			</Iteration>
		</Component>
		<Link name="L1656433324278" source="C1655217249604_1" target="C1655217249604_2" priority="1"/>
		<Component name="C1655217249604_2" type="callactivity" x="176" y="659" w="300" h="98" title="create itsm&amp;mail tickets per safe">
			<Process workflowfile="/workflow/bw_cloud_pam/bw_iasreview/inititsmticketspersafe.workflow">
				<Input name="A1655218439663" variable="remediationinstancecode" content="saferemediationinstancecode"/>
				<Input name="A1656434099528" variable="application" content="safe"/>
				<Input name="A1656663119791" variable="debug" content="debug"/>
				<Input name="A1741811651054" variable="retrymode" content="retrymode"/>
			</Process>
			<Iteration sequential="true" listvariable="safe">
				<Variable name="A1669041891151" variable="saferemediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1669040722282" source="C1655217249604_2" target="CEND" priority="1"/>
		<Component name="C1655217249604_3" type="callactivity" x="175" y="325" w="300" h="98" title="create itsm&amp;mail tickets per group membership">
			<Process workflowfile="/workflow/bw_iasreview/inititsmticketspergroupmembership.workflow">
				<Input name="A1655217321696" variable="repository" content="groupmembershiprepository"/>
				<Input name="A1655218439663" variable="remediationinstancecode" content="groupmembershipremediationinstancecode"/>
				<Input name="A1656663114047" variable="debug" content="debug"/>
				<Input name="A1741811570084" variable="retrymode" content="retrymode"/>
			</Process>
			<Iteration listvariable="groupmembershiprepository" sequential="true">
				<Variable name="A1700219923273" variable="groupmembershipremediationinstancecode"/>
			</Iteration>
		</Component>
		<Link name="L1700219882733" source="C1655217249604_3" target="C1655217249604_1" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655215897427" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655215913616" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A16552171314320" variable="repository" displayname="repository" multivalued="true" visibility="local" type="String" editortype="Ledger Repository"/>
		<Variable name="A16552171314321" variable="remediationinstancecode" displayname="remediationinstancecode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16564333113820" variable="application" displayname="application" multivalued="true" visibility="local" type="String" editortype="Ledger Application"/>
		<Variable name="A16564333113821" variable="applicationremediationinstancecode" displayname="applicationremediationinstancecode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1656662906160" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1669041666751" variable="safe" displayname="safe" editortype="Ledger Application" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1669041706791" variable="saferemediationinstancecode" displayname="saferemediationinstancecode" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1700155479432" variable="filterbytickets" displayname="filterbytickets" editortype="Default" type="Number" multivalued="true" visibility="in" description="OPTIONAL: Filter for some remediations tickets only" notstoredvariable="true"/>
		<Variable name="A16552171314322" variable="remediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16564333113822" variable="applicationremediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16690414192392" variable="saferemediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A17002196659600" variable="groupmembershiprepository" displayname="groupmembershiprepository" multivalued="true" visibility="local" type="String" editortype="Ledger Repository"/>
		<Variable name="A17002196659601" variable="groupmembershipremediationinstancecode" displayname="groupmembershipremediationinstancecode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A17002196659602" variable="groupmembershipremediationrecorduid" displayname="groupmembershipremediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A1741790164961" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1756198609579" variable="applicationtype" displayname="applicationtype" editortype="Default" type="String" multivalued="true" visibility="local" description="Application is Profile or Server" notstoredvariable="true"/>
	</Variables>
</Workflow>
