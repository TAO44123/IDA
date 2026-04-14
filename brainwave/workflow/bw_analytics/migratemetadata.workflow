<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_migratemetadata" statictitle="migrate metadata" scriptfile="/workflow/bw_analytics/migratemetadata.javascript" displayname="migrate metadata" description="migrate metadata" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="310" y="34" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1608818380238"/>
		</Component>
		<Component name="CEND" type="endactivity" x="312" y="504" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608818730494" priority="1"/>
		<Component name="C1608818730494" type="callactivity" x="184" y="120" w="300" h="98" title="groups">
			<Process workflowfile="/workflow/bw_analytics/migrategroupmetadata.workflow"/>
		</Component>
		<Component name="C1608818730494_1" type="callactivity" x="184" y="237" w="300" h="98" title="applications">
			<Process workflowfile="/workflow/bw_analytics/migrateapplicationmetadata.workflow"/>
		</Component>
		<Component name="C1608818730494_2" type="callactivity" x="184" y="359" w="300" h="98" title="permissions">
			<Process workflowfile="/workflow/bw_analytics/migratepermissionmetadata.workflow"/>
		</Component>
		<Link name="L1608818756478" source="C1608818730494" target="C1608818730494_1" priority="1"/>
		<Link name="L1608818757252" source="C1608818730494_1" target="C1608818730494_2" priority="1"/>
		<Link name="L1608818758675" source="C1608818730494_2" target="CEND" priority="1"/>
		<Component name="N1608819640972" type="note" x="515" y="34" w="333" h="91" title="Technical workflow used to migrate the legacy XXXinfos to the new metadatas&#xA;used for groups, applications and permissions"/>
	</Definition>
	<Roles>
		<Role name="A1608818380238" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608818487534" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
