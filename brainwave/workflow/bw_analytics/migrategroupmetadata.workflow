<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_migrategroupmetadata" statictitle="migrate group metadata" scriptfile="/workflow/bw_analytics/migrategroupmetadata.javascript" description="used to migrate group comments to the new metadata field" displayname="migrate group metadata" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="56" y="125" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1608810005693"/>
			<Actions>
				<Action name="U1608810090494" action="executeview" viewname="bwa_migrategroupsensitivitylevel" append="false" attribute="uid">
					<ViewAttribute name="P1608810090494_0" attribute="uid" variable="uid"/>
					<ViewAttribute name="P1608810090494_1" attribute="newmanaged" variable="managed"/>
					<ViewAttribute name="P1608810090494_2" attribute="newsensitivitylevel" variable="sensitivitylevel"/>
					<ViewAttribute name="P1608810090494_3" attribute="newsensitivityreason" variable="sensitivityreason"/>
					<ViewAttribute name="P1608810090494_4" attribute="newdescription" variable="description"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="581" y="125" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608810094037" priority="1"/>
		<Component name="C1608810094037" type="metadataactivity" x="197" y="100" w="300" h="98" title="migrate group metadata">
			<Metadata action="C" schema="bwa_groupmetadata">
				<Group group1="uid"/>
				<Data string4="description" string5="sensitivityreason" boolean="managed" integer1="sensitivitylevel"/>
			</Metadata>
		</Component>
		<Link name="L1608814107213" source="C1608810094037" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1608810005693" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608810014587" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608810042209" variable="uid" displayname="uid" editortype="Ledger Group" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608810050650" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608814066045" variable="sensitivitylevel" displayname="sensitivitylevel" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608814072114" variable="sensitivityreason" displayname="sensitivityreason" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608814079002" variable="managed" displayname="managed" editortype="Default" type="Boolean" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
