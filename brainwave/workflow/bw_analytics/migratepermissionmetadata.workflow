<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_migratepermissionmetadata" statictitle="migrate permission metadata" description="used to migrate permission metadata" scriptfile="/workflow/bw_analytics/migratepermissionmetadata.javascript" displayname="migrate permission metadata" publish="false" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="166" y="42" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1608815533635" action="executeview" viewname="bwa_migratepermissionsensitivitylevel" append="false" attribute="permission">
					<ViewAttribute name="P1608815533635_0" attribute="uid" variable="permission"/>
					<ViewAttribute name="P1608815533635_1" attribute="newdescription" variable="description"/>
					<ViewAttribute name="P1608815533635_2" attribute="newmanaged" variable="managed"/>
					<ViewAttribute name="P1608815533635_3" attribute="newsensitivitylevel" variable="sensitivitylevel"/>
					<ViewAttribute name="P1608815533635_4" attribute="newsensitivityreason" variable="sensitivityreason"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1608815209664"/>
		</Component>
		<Component name="CEND" type="endactivity" x="166" y="258" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608815670508" priority="1"/>
		<Component name="C1608815670508" type="metadataactivity" x="40" y="125" w="300" h="98" title="migrate permission metadata">
			<Metadata action="C" schema="bwa_permissionmetadata">
				<Permission permission1="permission"/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" boolean="managed"/>
			</Metadata>
		</Component>
		<Link name="L1608815766514" source="C1608815670508" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1608815209664" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608815218401" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608815277311" variable="permission" displayname="permission" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608815283985" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608815291693" variable="sensitivityreason" displayname="sensitivityreason" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608815300356" variable="sensitivitylevel" displayname="sensitivitylevel" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608815308670" variable="managed" displayname="managed" editortype="Default" type="Boolean" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
