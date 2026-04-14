<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="campaignsLauncher" description="Automatically launch campaigns that need to be launched&#xA;This technical workflow has to be called on a regular basis from a batch process" scriptfile="/workflow/bw_campaignmanager/campaignsLauncher.javascript" displayname="campaigns launcher" statictitle="campaigns launcher" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="51" y="156" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1500997762844"/>
			<Output name="output" startidentityvariable="processexecutor"/>
			<Actions function="initBounds"/>
		</Component>
		<Component name="CEND" type="endactivity" x="875" y="151" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1500998756581" priority="1"/>
		<Component name="C1500997837248" type="startcampaignactivity" x="508" y="130" w="300" h="98" title="launch campaigns if needed">
			<Campaign name="campaign" campaignids="code" campaignexecutor="processexecutor" campaignstatus="results"/>
		</Component>
		<Link name="L1500997853507" source="C1500997837248" target="CEND" priority="1"/>
		<Component name="C1500998756581" type="variablechangeactivity" x="157" y="126" w="300" h="98" title="get campaigns to launch">
			<Actions>
				<Action name="U1500998883225" action="executeview" viewname="bw_campaignsToLaunch" append="false" attribute="code">
					<ViewParam name="P15009988832250" param="lowdate" paramvalue="{dataset.lowdate.get()}"/>
					<ViewParam name="P15009988832251" param="highdate" paramvalue="{dataset.highdate.get()}"/>
					<ViewAttribute name="P1500998883225_2" attribute="code" variable="code"/>
				</Action>
				<Action name="U1500998908044" action="multiresize" attribute="code" attribute1="results"/>
			</Actions>
		</Component>
		<Link name="L1500998923909" source="C1500998756581" target="C1500997837248" priority="1"/>
		<Component name="N1500998946582" type="note" x="16" y="263" w="739" h="189" title="Launch campaigns automatically&#xA;Campaigns are launched if:&#xA;- They are active&#xA;- Their frequency is not &quot;ad-hoc&quot;&#xA;- They are not already in progress&#xA;- Their next execution date is between today and D-7 (you can modify this by updating the NBDAYSBACK workflow variable)&#xA;&#xA;You NEED to launch this process on a regular basis through a batch&#xA;&#xA;"/>
	</Definition>
	<Roles>
		<Role name="A1500997762844" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everybody" description="everybody">
			<Rule name="A1500997798543" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1500997987584" variable="processexecutor" displayname="process executor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1500998308540" variable="NBDAYSBACK" displayname="nb of days back to look for" editortype="Default" type="Number" multivalued="false" visibility="in" initialvalue="7" notstoredvariable="false"/>
		<Variable name="A1500998334059" variable="lowdate" displayname="low date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1500998343367" variable="highdate" displayname="high date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A15009988832250" variable="code" displayname="code" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1500998894344" variable="results" displayname="results" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
	</Variables>
</Workflow>
