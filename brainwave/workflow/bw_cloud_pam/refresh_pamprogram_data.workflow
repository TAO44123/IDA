<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="refresh_pamprogram_data" statictitle="refresh pamprogram data" scriptfile="/workflow/bw_cloud_pam/refresh_pamprogram_data.javascript" displayname="refresh_pamprogram_data" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="229" y="47" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Init>
				<Actions function="setTS"/>
			</Init>
			<Candidates name="role" role="A1620731146991"/>
		</Component>
		<Component name="CEND" type="endactivity" x="229" y="347" w="200" h="98" title="End" compact="true"/>
		<Component name="C1620733922298" type="scriptactivity" x="103" y="167" w="300" h="98" title="Compute controls on non onboarded accounts">
			<Script onscriptexecute="executeControls"/>
		</Component>
		<Link name="L1620733984346" source="CSTART" target="C1620733922298" priority="1"/>
		<Link name="L1620733987336" source="C1620733922298" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1620731146991" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1620731162748" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1620734148764" variable="ts" displayname="ts" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
