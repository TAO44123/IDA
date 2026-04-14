<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_removedatasourcemapping" statictitle="removedatasourcemapping" scriptfile="workflow/bw_dsm/removedatasourcemapping.javascript" type="builtin-technical-workflow" technical="true" displayname="Datasource management : delete mappings for application {dataset.code.get()}" description="Remove mappings for current application">
		<Component name="CSTART" type="startactivity" x="209" y="55" w="200" h="114" title="Start - bw_removedatasourcemapping" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1610729142643"/>
			<Actions>
				<Action name="U1610729435486" action="executeview" viewname="bw_getdatasourcemappinguids" append="false" attribute="metadatauid">
					<ViewParam name="P16107294354860" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewParam name="P16107294354861" param="concept_name" paramvalue="{dataset.name.get()}"/>
					<ViewAttribute name="P1610729435486_2" attribute="metadatauid" variable="metadatauid"/>
				</Action>
				<Action name="U1628853837844" action="update" attribute="nbMetadatas" newvalue="{ dataset.isEmpty(&apos;metadatauid&apos;) ? 0 : dataset.metadatauid.length }"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="209" y="308" w="200" h="98" title="End - bw_removedatasourcemapping" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1610729346105" priority="1" expression="dataset.nbMetadatas.get() &gt; 0" labelcustom="true" label="Delete metadatas"/>
		<Component name="C1610729346105" type="metadataactivity" x="83" y="162" w="300" h="98" title="delete mappings">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1610729387386" source="C1610729346105" target="CEND" priority="1"/>
		<Component name="C1628853785568" type="routeactivity" x="546" y="187" w="300" h="50" compact="true" title="Route - bw_removedatasourcemapping - Nothing to delete"/>
		<Link name="L1628853796649" source="CSTART" target="C1628853785568" priority="2" expression="dataset.nbMetadatas.get() &lt; 1" labelcustom="true" label="Nothing to delete"/>
		<Link name="L1628853797614" source="C1628853785568" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1610729142643" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1610729154610" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1610729333716" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620650894251" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610729179456" variable="name" displayname="name" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="Null to remove ALL mappings"/>
		<Variable name="A1628853814816" variable="nbMetadatas" displayname="Number of metadatas to delete" editortype="Default" type="Number" multivalued="false" visibility="local" description="Number of metadatas to delete" notstoredvariable="true"/>
	</Variables>
</Workflow>
