<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="controlexecutionondemand" statictitle="Control Execution on Demand" scriptfile="/workflow/bw_portaluar_base/controlexecutionondemand.javascript" type="builtin-technical-workflow" displayname="Executing control on demand: {dataset.controldisplayname.get()}" description="Execute control on demand (via the webportal)" technical="true">
		<Component name="CSTART" type="startactivity" x="74" y="46" w="200" h="114" title="Start - controlexecutionondemand" compact="true">
			<Ticket create="true" createaction="false">
				<Attribute name="tickettype" attribute="ticket"/>
				<Attribute name="status" attribute="ticket_status"/>
				<Attribute name="custom1" attribute="controlid"/>
				<Attribute name="custom2" attribute="controldisplayname"/>
			</Ticket>
			<Candidates name="role" role="A1589899084028"/>
			<Output name="output" ticketactionnumbervariable="action"/>
			<Init>
				<Actions function="setTS"/>
			</Init>
		</Component>
		<Component name="CEND" type="endactivity" x="591" y="46" w="200" h="98" title="End - controlexecutionondemand" compact="true">
			<Actions>
				<Action name="U1589901045312" action="update" attribute="ticket_status" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1589899344679" type="scriptactivity" x="205" y="21" w="300" h="98" title="Control execution">
			<Script onscriptexecute="controlExecution"/>
			<Iteration distinctvalues="false">
			</Iteration>
		</Component>
		<Link name="L1589968291536" source="CSTART" target="C1589899344679" priority="1"/>
		<Link name="L1589968292991" source="C1589899344679" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1589899035063" variable="ticket" displayname="ticket" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="CONTROL_EXECUTION_ONDEMAND" notstoredvariable="true"/>
		<Variable name="A1589899070878" variable="ticket_status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="scheduled" notstoredvariable="true"/>
		<Variable name="A1589899191852" variable="action" displayname="action" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1589899312880" variable="ts" displayname="ts" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1589899503249" variable="controldisplayname" displayname="controldisplayname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" syncname=""/>
		<Variable name="A1589966967342" variable="controlid" displayname="controlid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1667831119773" variable="controlCode" displayname="Control Code" editortype="Default" type="String" multivalued="false" visibility="in" description="Control Code" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1589899084028" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1589899109304" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
