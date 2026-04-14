<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_bulkremoveallapplicationtag" statictitle="bulk remove all application tags" description="bulk remove all application tags (or a specific tag if provided)" scriptfile="workflow/bw_fragments/empty.javascript" displayname="bulk remove all application tags" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="213" y="57" w="200" h="114" title="Start - bwa_bulkremoveallapplicationtag" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1608643295900" action="executeview" viewname="bwa_applicationfiltertagmetadata" append="false" attribute="metadatauids">
					<ViewParam name="P16086432959000" param="uids" paramvalue="{dataset.uids}"/>
					<ViewParam name="P16086432959001" param="tag" paramvalue="{dataset.tag.get()}"/>
					<ViewAttribute name="P1608643295900_2" attribute="metadatauid" variable="metadatauids"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1608635784031"/>
		</Component>
		<Component name="CEND" type="endactivity" x="213" y="308" w="200" h="98" title="End - bwa_bulkremoveallapplicationtag" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608643312908" priority="1"/>
		<Component name="C1608643312908" type="metadataactivity" x="87" y="159" w="300" h="98" title="delete applications tags">
			<Metadata action="D" metadatauid="metadatauids"/>
		</Component>
		<Link name="L1608644610653" source="C1608643312908" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1608635784031" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608635793043" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608635809668" variable="uids" displayname="uids" editortype="Ledger Application" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608635853846" variable="metadatauids" displayname="metadata uids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608647800281" variable="tag" displayname="tag" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
