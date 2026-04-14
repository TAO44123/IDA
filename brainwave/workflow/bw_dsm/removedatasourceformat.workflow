<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_removedatasourceformat" statictitle="removedatasourceformat" scriptfile="workflow/bw_dsm/dsm_workflow.javascript" displayname="removedatasourceformat" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="138" y="59" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1610821127630"/>
			<Actions>
				<Action name="U1610821265457" action="executeview" viewname="bw_getdatasourceformatuid" append="false" attribute="metadatauid">
					<ViewParam name="P16108212654570" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1610821265457_1" attribute="uid" variable="metadatauid"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="135" y="305" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1610821270993" priority="1"/>
		<Component name="C1610821270993" type="metadataactivity" x="10" y="169" w="300" h="98" title="delete app config">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1610821293655" source="C1610821270993" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1610821127630" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1610821144708" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1610821187589" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620651092950" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
