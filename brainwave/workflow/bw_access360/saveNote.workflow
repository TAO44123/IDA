<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_saveNote" statictitle="save Note" scriptfile="/workflow/bw_access360/saveNote.javascript" description="save personal identity note" displayname="save Note" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="329" y="102" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1667924491820"/>
		</Component>
		<Component name="CEND" type="endactivity" x="329" y="386" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1667924515084" priority="1"/>
		<Component name="C1667924515084" type="metadataactivity" x="203" y="218" w="300" h="98" title="PERSONAL NOTE">
			<Metadata action="C" schema="bw_notes">
				<Identity identity="identity"/>
				<Data details="note"/>
			</Metadata>
		</Component>
		<Link name="L1667924586310" source="C1667924515084" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1667924491820" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="OWNER">
			<Rule name="A1667924501916" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1667924531961" variable="identity" displayname="identity" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1667924564795" variable="note" displayname="note" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
