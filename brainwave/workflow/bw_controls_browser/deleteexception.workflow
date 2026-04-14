<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="deleteexception" displayname="Delete exception" scriptfile="workflow/bw_controls_browser/empty.javascript" statictitle="Delete exception" description="Delete exception" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="438" y="39" w="200" h="114" title="Start - deleteexception" compact="true">
			<Candidates name="role" role="A1449674158528"/>
			<Ticket create="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom1" attribute="controlcode"/>
				<Attribute name="custom2" attribute="targetuid"/>
			</Ticket>
			<FormVariable name="A1602767982473" variable="controlcode" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1602767992443" variable="targetuid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1602767999742" variable="targettype" action="input" mandatory="true" longlist="false"/>
			<Actions>
				<Action name="U1637686430212" action="update" attribute="targetuid" newvalue="{ dataset.targetuids.get(0) }" condition="(! dataset.isEmpty(&apos;targetuids&apos;))"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="438" y="344" w="200" h="98" title="End - deleteexception" compact="true">
			<Actions>
				<Action name="U1449674343963" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1449673983071" priority="1"/>
		<Component name="C1449673983071" type="writeexceptionactivity" x="312" y="161" w="300" h="98" title="Delete exception">
			<WriteException name="writeexception" controlcode="controlcode" resulttype="targettype" entityuid="targetuid"/>
			<Output name="output" writeexceptionstatusvariable="result"/>
		</Component>
		<Link name="L1641379494067" source="C1449673983071" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1449674097380" variable="controlcode" displayname="controlcode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674111228" variable="targettype" displayname="targettype" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674118068" variable="targetuid" displayname="targetuid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674201781" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="in progress"/>
		<Variable name="A1449674251201" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="EX_DELETE" notstoredvariable="false"/>
		<Variable name="A1637686390673" variable="targetuids" displayname="Target uids" editortype="Default" type="String" multivalued="true" visibility="in" description="Target uids (for use with multiple values)" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1449674158528" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone" description="everyone">
			<Rule name="A1449674174198" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
