<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_updatecampaigninfos" statictitle="update campaign infos" description="update campaign infos" scriptfile="/workflow/bw_access360/updatecampaigninfos.javascript" displayname="update campaign infos" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="189" y="73" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1662039868142"/>
			<Actions>
				<Action name="U1765538086066" action="executeview" viewname="campaigntimeslot" append="false" attribute="__instance_timeslot__">
					<ViewParam name="P17655380860660" param="campaignId" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1765538086066_1" attribute="timeslotuid" variable="__instance_timeslot__"/>
				</Action>
				<Action name="U1683195718505" action="executeview" viewname="bwr_getcampaigninstanceadditionalinfos" append="false" attribute="parentmduid">
					<ViewParam name="P16831957185050" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1683195718505_1" attribute="parent_uid" variable="parentmduid"/>
					<ViewAttribute name="P1683195718505_2" attribute="info" variable="_info"/>
					<ViewAttribute name="P1683195718505_3" attribute="num" variable="_num"/>
					<ViewAttribute name="P1683195718505_4" attribute="currentstatus" variable="_currentstatus"/>
					<ViewAttribute name="P1683195718505_5" attribute="extradays" variable="_extradays"/>
				</Action>
				<Action name="U1705275010949" action="default" attribute="currentstatus" newvalue="{dataset._currentstatus.get()}"/>
				<Action name="U1705275036317" action="default" attribute="info" newvalue="{dataset._info.get()}"/>				
			</Actions>
			<FormVariable name="A1702566540971" variable="currentstatus" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1702566724598" variable="campaignid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1705275061441" variable="info" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="189" y="362" w="200" h="98" title="End" compact="true">
			<Actions function="incrementStickyCampaignUsageCounter"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1662039914473" priority="1"/>
		<Component name="N1627047051318_1" type="note" x="506" y="116" w="554" h="378" title="currentstatus = init, active, pause, finalizing, closed, cancelled"/>
		<Component name="C1662039914473" type="metadataactivity" x="63" y="196" w="300" h="98" title="update campaign infos">
			<Metadata schema="bwr_campaigninstance" action="C" master="parentmduid">
				<Data subkey="campaignid" string3="currentstatus" integer1="_num" details="info" integer2="campaignid"/>
			</Metadata>
		</Component>
		<Link name="L1662039976166" source="C1662039914473" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1662039742228" variable="campaignid" displayname="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662039751162" variable="currentstatus" displayname="current status" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true">
			<StaticValue name="init"/>
			<StaticValue name="active"/>
			<StaticValue name="pause"/>
			<StaticValue name="finalizing"/>
			<StaticValue name="closed"/>
			<StaticValue name="cancelled"/>
		</Variable>
		<Variable name="A1683195665253" variable="parentmduid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563647065" variable="_info" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563656813" variable="_num" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1705274866091" variable="_currentstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1705274877981" variable="info" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1705275310024" variable="_extradays" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1745325247442" variable="incrementCounter" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1745325380356" variable="stickyTimeslot" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1765537956702" variable="__instance_timeslot__" displayname="instance timeslot" editortype="Default" type="String" multivalued="false" visibility="local" description="This is a hack to force the timeslot to a different value!" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1662039868142" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1662039879329" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
