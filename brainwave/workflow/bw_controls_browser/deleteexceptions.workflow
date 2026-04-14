<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="deleteexceptions" displayname="Delete exceptions" scriptfile="workflow/bw_controls_browser/empty.javascript" statictitle="Delete exceptions" description="Delete exceptions" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="142" y="191" w="200" h="114" title="Start - deleteexceptions" compact="true">
			<Candidates name="role" role="A1449674158528"/>
			<Ticket create="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom1" attribute="controlcode"/>
			</Ticket>
			<FormVariable name="A1602767982473" variable="controlcode" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1602767992443" variable="targetuids" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1602767999742" variable="targettype" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="765" y="191" w="200" h="98" title="End - deleteexceptions" compact="true">
			<Actions>
				<Action name="U1449674343963" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1637686347107" type="callactivity" x="330" y="166" w="300" h="98" title="deleteexception">
			<Process workflowfile="/workflow/bw_controls_browser/deleteexception.workflow">
				<Input name="A1637686439045" variable="controlcode" content="controlcode"/>
				<Input name="A1637686442330" variable="targettype" content="targettype"/>
				<Input name="A1637686447899" variable="targetuids" content="targetuids"/>
			</Process>
			<Iteration listvariable="targetuids"/>
		</Component>
		<Link name="L1637686350760" source="CSTART" target="C1637686347107" priority="1"/>
		<Link name="L1637686351639" source="C1637686347107" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1449674097380" variable="controlcode" displayname="controlcode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674111228" variable="targettype" displayname="targettype" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674118068" variable="targetuids" displayname="targetuid" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="false" description="Target uids"/>
		<Variable name="A1449674201781" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="in progress"/>
		<Variable name="A1449674251201" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="EX_DELETE" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1449674158528" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone" description="everyone">
			<Rule name="A1449674174198" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
