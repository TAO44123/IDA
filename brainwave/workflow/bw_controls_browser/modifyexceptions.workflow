<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="modifyexceptions" displayname="Modify exceptions" scriptfile="workflow/bw_controls_browser/empty.javascript" statictitle="Modify exceptions" description="Modify exceptions" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="142" y="166" w="200" h="114" title="Start - modifyexceptions" compact="true">
			<Candidates name="role" role="A1449674158528"/>
			<Ticket create="true">
				<Attribute name="tickettype" attribute="tickettype"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom1" attribute="controlcode"/>
			</Ticket>
			<FormVariable name="A1666698406167" variable="controlcode" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1666698411995" variable="targetuids" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1666698502956" variable="begindate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1666698506554" variable="enddate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1666698509909" variable="issuerName" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1666698513293" variable="reason" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1666698517751" variable="targettype" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="776" y="166" w="200" h="98" title="End - modifyexceptions" compact="true">
			<Actions>
				<Action name="U1449674343963" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1637679173567" type="callactivity" x="298" y="141" w="300" h="98" title="modifyexception">
			<Process workflowfile="/workflow/bw_controls_browser/modifyexception.workflow">
				<Input name="A1637681036666" variable="begindate" content="begindate"/>
				<Input name="A1637681040404" variable="controlcode" content="controlcode"/>
				<Input name="A1637681044123" variable="enddate" content="enddate"/>
				<Input name="A1637681047366" variable="issuerName" content="issuerName"/>
				<Input name="A1637681051525" variable="reason" content="reason"/>
				<Input name="A1637681055093" variable="targettype" content="targettype"/>
				<Input name="A1637681067373" variable="uploadsession" content="uploadsession"/>
				<Input name="A1637681173829" variable="targetuids" content="targetuids"/>
			</Process>
			<Iteration listvariable="targetuids">
			</Iteration>
		</Component>
		<Link name="L1637679176699" source="CSTART" target="C1637679173567" priority="1"/>
		<Link name="L1637679177541" source="C1637679173567" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1449674097380" variable="controlcode" displayname="controlcode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674111228" variable="targettype" displayname="targettype" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674118068" variable="targetuids" displayname="targetuid" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449674201781" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="in progress"/>
		<Variable name="A1449674251201" variable="tickettype" displayname="tickettype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="EX_MODIFY" notstoredvariable="false"/>
		<Variable name="A1449682697580" variable="reason" displayname="reason" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449682714252" variable="begindate" displayname="begindate" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449682726535" variable="enddate" displayname="enddate" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449682738367" variable="issuerName" displayname="issuerName" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1449740945960" variable="uploadsession" displayname="uploadsession" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1449674158528" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone" description="everyone">
			<Rule name="A1449674174198" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
