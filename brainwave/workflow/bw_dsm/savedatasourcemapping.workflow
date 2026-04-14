<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_savedatasourcemapping" statictitle="savedatasourcemapping" description="save datasource mapping" scriptfile="workflow/bw_dsm/savedatasourcemapping.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="208" y="68" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1620370686083"/>
			<Actions function="computeSubkey">
				<Action name="U1620652036868" action="executeview" viewname="bwdsm_getdatasource_def_mduid" append="false" attribute="parentmetadatauid">
					<ViewParam name="P16206520368680" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1620652036868_1" attribute="uid" variable="parentmetadatauid"/>
				</Action>
				<Action name="U1620377511130" action="executeview" viewname="bw_getdatasourcemappinguids" append="false" attribute="metadatauid">
					<ViewParam name="P16203775111300" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1620377511130_1" attribute="metadatauid" variable="metadatauid"/>
				</Action>
				<Action name="U1620378932891" action="empty" attribute="SUBKEY"/>
				<Action name="U1620378953824" action="multiresize" attribute="name" attribute1="SUBKEY"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="208" y="475" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1620377525014" priority="1"/>
		<Component name="C1620377525014" type="metadataactivity" x="82" y="166" w="300" h="98" title="delete previous mapping">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1620377554559" source="C1620377525014" target="C1620377583123" priority="1"/>
		<Component name="C1620377583123" type="metadataactivity" x="82" y="319" w="300" h="98" title="save mapping">
			<Metadata action="C" schema="bw_datasourcemapping" master="parentmetadatauid">
				<Application/>
				<Data string1="name" string2="type" integer1="order" string3="column" boolean="ismandatory" string4="description" string5="example" subkey="SUBKEY"/>
			</Metadata>
		</Component>
		<Link name="L1620377891954" source="C1620377583123" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1620370721270" variable="type" displayname="type" editortype="Default" type="String" multivalued="true" visibility="in" description="brainwave concept type" notstoredvariable="true"/>
		<Variable name="A1620370740808" variable="order" displayname="order" editortype="Default" type="Number" multivalued="true" visibility="in" description="brainwave concept order" notstoredvariable="true"/>
		<Variable name="A1620370754495" variable="name" displayname="name" editortype="Default" type="String" multivalued="true" visibility="in" description="brainwave concept name" notstoredvariable="true"/>
		<Variable name="A1620370769928" variable="column" displayname="column" editortype="Default" type="String" multivalued="true" visibility="in" description="csv file column" notstoredvariable="true"/>
		<Variable name="A1620377395564" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="local" description="former metadatauid to delete" notstoredvariable="true"/>
		<Variable name="A1620377740381" variable="ismandatory" displayname="ismandatory" editortype="Default" type="Boolean" multivalued="true" visibility="in" notstoredvariable="true" description="brainwave attribute is mandatory"/>
		<Variable name="A1620386135179" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="brainwave attribute description"/>
		<Variable name="A1620386143208" variable="example" displayname="example" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="brainwave attribute value sample"/>
		<Variable name="A1620651328100" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620651690300" variable="SUBKEY" displayname="SUBKEY" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620651993995" variable="parentmetadatauid" displayname="applicationmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1620370686083" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1620378353465" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
