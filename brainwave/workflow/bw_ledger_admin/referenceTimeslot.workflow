<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="reference_timeslot" statictitle="reference_timeslot" scriptfile="/workflow/bw_ledger_admin/referenceTimeslot.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="32" y="32" w="200" h="114" title="Start" compact="true">
			<Candidates name="role" role="A1533737972380"/>
			<Actions function="referenceTimeslot"/>
		</Component>
		<Component name="CEND" type="endactivity" x="32" y="192" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1533737972380" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everybody" description="everybody&#xA;">
			<Rule name="A1533737985155" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1533738031151" variable="timeslot_uid" displayname="timeslot_uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1533738039990" variable="timeslot_reference" displayname="timeslot_reference" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
</Workflow>
