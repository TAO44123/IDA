<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="launchCampaign" statictitle="launchCampaign" scriptfile="/workflow/bw_campaignmanager/launchCampaign.javascript" description="technical workfow used to launch a campaign worflow through the command line" displayname="launch campaign {dataset.code}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="54" y="146" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="custom1" attribute="code"/>
				<Attribute name="custom2" attribute="results"/>
			</Ticket>
			<Output name="output" startidentityvariable="processexecutor"/>
			<Candidates name="role" role="A1548325686236"/>
		</Component>
		<Component name="CEND" type="endactivity" x="982" y="146" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1548320959727" priority="1"/>
		<Component name="C1548320959727" type="startcampaignactivity" x="179" y="121" w="300" h="98" title="launch campaign {dataset.code.get()}">
			<Campaign name="campaign" campaignids="code" campaignexecutor="processexecutor" campaignstatus="ret"/>
		</Component>
		<Link name="L1548320984129" source="C1548320959727" target="C1548321158870" priority="1"/>
		<Component name="C1548321158870" type="variablechangeactivity" x="571" y="121" w="300" h="98" title="save the status in the ticket">
			<Actions>
				<Action name="U1548321197520" action="update" attribute="results" newvalue="{dataset.ret.get()}"/>
			</Actions>
		</Component>
		<Link name="L1548321181023" source="C1548321158870" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1548320876877" variable="code" displayname="code" editortype="Default" type="String" multivalued="false" visibility="in" description="campaign code" notstoredvariable="false"/>
		<Variable name="A1548321053693" variable="processexecutor" displayname="processexecutor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1548321088858" variable="results" displayname="results" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1548321121740" variable="ret" displayname="ret" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1548325686236" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everybody" description="everybody">
			<Rule name="A1548325698148" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
