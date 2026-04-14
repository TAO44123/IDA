<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_migrateapplicationmetadata" statictitle="migrate application metadata" description="used to migrate application metadata" scriptfile="/workflow/bw_analytics/migrateapplicationmetadata.javascript" displayname="migrate application metadata" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="183" y="39" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1608816185877"/>
			<Actions>
				<Action name="U1608817171475" action="executeview" viewname="bwa_migrateapplicationsensitivitylevel" append="false" attribute="category">
					<ViewAttribute name="P1608817171475_0" attribute="newcategory" variable="category"/>
					<ViewAttribute name="P1608817171475_1" attribute="uid" variable="application"/>
					<ViewAttribute name="P1608817171475_2" attribute="newdescription" variable="description"/>
					<ViewAttribute name="P1608817171475_3" attribute="newsensitivitylevel" variable="sensitivitylevel"/>
					<ViewAttribute name="P1608817171475_4" attribute="newsensitivityreason" variable="sensitivityreason"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="183" y="296" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608816750939" priority="1"/>
		<Component name="C1608816750939" type="metadataactivity" x="57" y="147" w="300" h="98" title="migrate application metadata">
			<Metadata action="C" schema="bwa_applicationmetadata">
				<Application application="application"/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" string3="category"/>
			</Metadata>
		</Component>
		<Link name="L1608816771611" source="C1608816750939" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1608816185877" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608816207570" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608816324250" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608816565894" variable="category" displayname="category" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608816579489" variable="sensitivityreason" displayname="sensitivityreason" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608816589848" variable="sensitivitylevel" displayname="sensitivitylevel" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608816601339" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
