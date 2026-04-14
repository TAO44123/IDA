<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_removedatasourcecolumn" statictitle="removedatasourcecolumn" scriptfile="workflow/bw_dsm/dsm_workflow.javascript" technical="true" type="builtin-technical-workflow" displayname="Datasource management : delete columns for application {dataset.code.get()}" description="Delete columns for current application">
		<Component name="CSTART" type="startactivity" x="209" y="55" w="200" h="114" title="Start - bw_removedatasourcecolumn" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1610729142643"/>
			<Actions>
				<Action name="U1610729435486" action="executeview" viewname="bw_getdatasourcecolumnuid" append="false" attribute="metadatauid">
					<ViewParam name="P16107294354860" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewParam name="P16107294354861" param="column_name" paramvalue="{dataset.name.get()}"/>
					<ViewAttribute name="P1610729435486_2" attribute="uid" variable="metadatauid"/>
				</Action>
				<Action name="U1628853626477" action="update" attribute="nbMetadatas" newvalue="{ dataset.isEmpty(&apos;metadatauid&apos;) ? 0 : dataset.metadatauid.length }"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="209" y="308" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1610729346105" priority="1" labelcustom="true" label="Delete metadatas" expression="dataset.nbMetadatas.get() &gt; 0"/>
		<Component name="C1610729346105" type="metadataactivity" x="83" y="162" w="300" h="98" title="delete column">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1610729387386" source="C1610729346105" target="CEND" priority="1"/>
		<Component name="C1628853552241" type="routeactivity" x="578" y="187" w="300" h="50" compact="true" title="Route  - bw_removedatasourcecolumn - Nothing to delete"/>
		<Link name="L1628853555843" source="CSTART" target="C1628853552241" priority="2" expression="dataset.nbMetadatas.get() &lt; 1" labelcustom="true" label="Nothing to delete"/>
		<Link name="L1628853556984" source="C1628853552241" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1610729142643" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1610729154610" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1610729179456" variable="name" displayname="name" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="Null to delete ALL columns"/>
		<Variable name="A1610729333716" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620650894251" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1628853586245" variable="nbMetadatas" displayname="Number of metadatas to delete" editortype="Default" type="Number" multivalued="false" visibility="local" description="Number of metadatas to delete" notstoredvariable="true"/>
	</Variables>
</Workflow>
