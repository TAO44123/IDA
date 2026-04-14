<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_bulkaddidentitytag" statictitle="bulk add identity tag" description="add a new tag for a series of identities" scriptfile="workflow/bw_fragments/tags/add/bulkaddidentitytag.javascript" displayname="bulk add identity tag" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="210" y="76" w="200" h="114" title="Start - bwa_bulkaddidentitytag" compact="true">
			<Ticket create="true"/>
			<Actions function="filteridentities">
				<Action name="U1608657985272" action="executeview" viewname="bwa_identitywithtag" append="false" attribute="identitieswithtag">
					<ViewParam name="P16086579852720" param="tag" paramvalue="{dataset.tag.get()}"/>
					<ViewAttribute name="P1608657985272_1" attribute="uid" variable="identitieswithtag"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1608634332546"/>
			<FormVariable name="A1608657446695" variable="tag" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1608657452660" variable="identities" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="210" y="366" w="200" h="98" title="End - bwa_bulkaddidentitytag" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608630832654" priority="1"/>
		<Component name="C1608630832654" type="metadataactivity" x="84" y="198" w="300" h="98" title="bulk add a new tag">
			<Metadata action="C" schema="bwa_identitytags">
				<Data subkey="tags" string1="tags"/>
				<Identity identity="identities"/>
			</Metadata>
		</Component>
		<Link name="L1608630876695" source="C1608630832654" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1608630742699" variable="identities" displayname="identities" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608630762063" variable="tag" displayname="tag" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608630777426" variable="tags" displayname="tags" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608631080077" variable="identitieswithtag" displayname="identities with the tag" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1608634332546" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608634341967" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
