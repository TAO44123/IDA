<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_deleteremediationitsmdef" statictitle="delete remediation itsm definition" scriptfile="/workflow/bw_iasreview/deleteremediationitsmdef.javascript" description="delete remediation itsm definition" displayname="delete remediation itsm definition" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="355" y="111" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655124228131"/>
		</Component>
		<Component name="CEND" type="endactivity" x="355" y="456" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655124268663" priority="1"/>
		<Component name="C1655124268663" type="metadataactivity" x="229" y="265" w="300" h="98" title="delete metadata">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1655124314631" source="C1655124268663" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655124228131" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655124237589" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655124295729" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
