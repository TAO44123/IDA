<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inittickets" statictitle="init tickets" scriptfile="/workflow/bw_iasreview/inittickets.javascript" description="Launch pending remediations" displayname="init tickets" technical="true">
		<Component name="CSTART" type="startactivity" x="168" y="34" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
			</Ticket>
			<Candidates name="role" role="A1655456313230"/>
			<FormVariable name="A1700154241961" variable="filterbytickets" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="168" y="627" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655456418134" priority="1"/>
		<Component name="C1655456418134" type="callactivity" x="42" y="139" w="300" h="98" title="init embedded tickets">
			<Process workflowfile="/workflow/bw_iasreview/initembeddedtickets.workflow">
				<Input name="A1700155099459" variable="filterbytickets" content="filterbytickets"/>
			</Process>
		</Component>
		<Component name="C1655456450663" type="callactivity" x="42" y="479" w="300" h="98" title="init itsm&amp;mail tickets">
			<Process workflowfile="/workflow/bw_iasreview/inititsmtickets.workflow">
				<Input name="A1700160314044" variable="filterbytickets" content="filterbytickets"/>
				<Input name="A1741890477688" variable="retrymode" content="retrymode"/>
			</Process>
		</Component>
		<Link name="L1655456463775" source="C1655456418134" target="C1655456418134_1" priority="1"/>
		<Link name="L1655456464901" source="C1655456450663" target="CEND" priority="1"/>
		<Component name="N1655456488799" type="note" x="243" y="37" w="300" h="50" title="Activate pending remediation tickets&#xA;(remediation tickets with closedstatus=-1)"/>
		<Component name="C1655456418134_1" type="callactivity" x="39" y="306" w="300" h="98" title="init radiantone tickets">
			<Process workflowfile="/workflow/bw_iasreview/initradiantonetickets.workflow">
				<Input name="A1700155099459" variable="filterbytickets" content="filterbytickets"/>
			</Process>
		</Component>
		<Link name="L1703165625354" source="C1655456418134_1" target="C1655456450663" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655456313230" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655456392819" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655714189608" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REMEDIATION_INITTICKETS" notstoredvariable="true"/>
		<Variable name="A1700154001681" variable="filterbytickets" displayname="filterbytickets" editortype="Default" type="Number" multivalued="true" visibility="in" description="OPTIONAL: Filter by remediation tickets" notstoredvariable="true"/>
		<Variable name="A1741890446489" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="false" notstoredvariable="true"/>
	</Variables>
</Workflow>
