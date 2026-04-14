<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_setdatasourceformat" statictitle="setdatasourceformat" scriptfile="workflow/bw_dsm/setdatasourceformat.javascript" displayname="setdatasourceformat" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="195" y="49" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1610727953643"/>
			<Actions>
				<Action name="U1620653111404" action="executeview" viewname="bwdsm_getdatasource_def_mduid" append="false" attribute="metadatauid">
					<ViewParam name="P16206531114040" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1620653111404_1" attribute="uid" variable="metadatauid"/>
				</Action>
			</Actions>
			<FormVariable name="A1661955488175" variable="code" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1661955502683" variable="encoding" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1661955509791" variable="delimiter" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="195" y="282" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1610728046320" priority="1"/>
		<Component name="C1610728046320" type="metadataactivity" x="69" y="148" w="300" h="98" title="add datasource format metadata">
			<Metadata action="C" schema="bw_datasourceformat" master="metadatauid">
				<Application/>
				<Data string1="separator" string2="delimiter" string3="encoding" string4="booleanformat" string5="dateformat" integer1="minimumnblines" integer2="errornbdays" integer3="warningnbdays" boolean="checkfilesizevariation" integer4="filesizevariation" subkey="code"/>
			</Metadata>
		</Component>
		<Link name="L1610728213841" source="C1610728046320" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1610727953643" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1610727972295" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1610727989532" variable="separator" displayname="separator" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610727996138" variable="delimiter" displayname="delimiter" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610728003352" variable="booleanformat" displayname="booleanformat" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610728007945" variable="dateformat" displayname="dateformat" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610728025129" variable="minimumnblines" displayname="minimumnblines" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610728119234" variable="encoding" displayname="encoding" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610822311087" variable="errornbdays" displayname="errornbdays" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1610822321863" variable="warningnbdays" displayname="warningnbdays" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1611233341247" variable="checkfilesizevariation" displayname="check file size variation" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1611233368907" variable="filesizevariation" displayname="filesizevariation" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620652842363" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620653040174" variable="metadatauid" displayname="applicationmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
