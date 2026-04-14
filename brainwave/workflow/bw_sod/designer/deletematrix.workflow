<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwsod_designer_deletematrix" statictitle="Delete SoD matrix" scriptfile="/workflow/bw_sod/empty.javascript" displayname="Delete SoD matrix {dataset.matrixcode.get()}">
		<Component name="CSTART" type="startactivity" x="193" y="31" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1764237787826"/>
			<FormVariable name="A1765787796666" variable="matrixcode" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="193" y="457" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1764237934298" priority="1"/>
		<Component name="C1764237934298" type="variablechangeactivity" x="67" y="145" w="300" h="98" title="Get metadata uids">
			<Actions>
				<Action name="U1764238068147" action="executeview" viewname="bwsod_designer_matrix_details" append="false" attribute="metadatauids">
					<ViewParam name="P17642380681470" param="matrix_code" paramvalue="{dataset.matrixcode.get()}"/>
					<ViewAttribute name="P1764238068147_1" attribute="bwsod_toxic_pairs_uid" variable="metadatauids"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1764237976750" source="C1764237934298" target="C1765786937974" priority="1"/>
		<Component name="C1765786937974" type="metadataactivity" x="67" y="279" w="300" h="98" title="Delete metadatas">
			<Metadata action="D" metadatauid="metadatauids"/>
		</Component>
		<Link name="L1765786962417" source="C1765786937974" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1764237787826" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1764237811082" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1764237818807" variable="matrixcode" displayname="matrixcode" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1764237955835" variable="metadatauids" displayname="metadatauids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
