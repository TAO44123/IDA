<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_dsmdiscovercolumns" statictitle="discovercolumns" scriptfile="workflow/bw_dsm/discovercolumns.javascript" description="automatically discover file columns and file mapping" type="builtin-technical-workflow" displayname="Datasource management : Discover columns for application {dataset.code.get()}">
		<Component name="CSTART" type="startactivity" x="226" y="42" w="200" h="114" title="Start - bw_dsmdiscovercolumns" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1620919611625"/>
			<Actions>
				<Action name="U1620921185774" action="executeview" viewname="bwdsm_getdatasource_def_mduid" append="false" attribute="parentmetadatauid">
					<ViewParam name="P16209211857740" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1620921185774_1" attribute="uid" variable="parentmetadatauid"/>
				</Action>
			</Actions>
			<FormVariable name="A1620921922210" variable="code" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1620921927032" variable="file" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1620921931146" variable="encoding" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1620921935871" variable="delimiter" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1620921939551" variable="separator" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005408540" variable="booleanformat" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005413908" variable="dateformat" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005210791" variable="mappingdescription" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005219009" variable="mappingexample" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005225295" variable="mappingmandatory" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005229757" variable="mappingmapped" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005235523" variable="mappingname" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005240671" variable="mappingorder" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1621005249909" variable="mappingtype" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="226" y="859" w="200" h="98" title="End - bw_dsmdiscovercolumns" compact="true" outexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1620919683434" priority="1"/>
		<Component name="C1620919666785" type="callactivity" x="100" y="287" w="300" h="98" title="delete mappings">
			<Process workflowfile="/workflow/bw_dsm/removedatasourcemapping.workflow">
				<Input name="A1661962258981" variable="code" content="code"/>
			</Process>
		</Component>
		<Component name="C1620919683434" type="callactivity" x="100" y="148" w="300" h="98" title="delete columns">
			<Process workflowfile="/workflow/bw_dsm/removedatasourcecolumn.workflow">
				<Input name="A1661961978878" variable="code" content="code"/>
			</Process>
		</Component>
		<Link name="L1620920365406" source="C1620919683434" target="C1620919666785" priority="1"/>
		<Component name="C1620920370431" type="scriptactivity" x="100" y="412" w="300" h="98" title="Discover file infos">
			<Script onscriptexecute="execute"/>
		</Component>
		<Link name="L1620920410428" source="C1620919666785" target="C1620920370431" priority="1"/>
		<Link name="L1620920411523" source="C1620920370431" target="C1610728348567_1" priority="1"/>
		<Component name="C1610728348567_1" type="metadataactivity" x="100" y="555" w="300" h="98" title="add columns">
			<Metadata action="C" schema="bw_datasourcecolumn" master="columnparentmetadata">
				<Data subkey="columnsubkey" string1="columnname" string2="columntype" string3="columnformat" boolean="columnmandatory" integer1="columnorder" string4="columnformatdescription" integer2="columnfillfactor" string5="columnisunique" string6="columncomputedexpression" integer3="columniscomputed"/>
				<Application/>
			</Metadata>
		</Component>
		<Link name="L1620920584645" source="C1610728348567_1" target="C1620377583123_1" priority="1"/>
		<Component name="C1620377583123_1" type="metadataactivity" x="100" y="705" w="300" h="98" title="add mappings">
			<Metadata action="C" schema="bw_datasourcemapping" master="mappingparentmetadatauid">
				<Application/>
				<Data string1="mappingname" string2="mappingtype" integer1="mappingorder" string3="mappingmapped" boolean="mappingmandatory" string4="mappingdescription" string5="mappingexample" subkey="mappingsubkey"/>
			</Metadata>
		</Component>
		<Link name="L1620926095955" source="C1620377583123_1" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1620919556090" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620919560621" variable="file" displayname="file" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620919567546" variable="delimiter" displayname="delimiter" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="&quot;"/>
		<Variable name="A1620919573518" variable="separator" displayname="separator" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue=";"/>
		<Variable name="A1620919593868" variable="encoding" displayname="encoding" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="UTF8"/>
		<Variable name="A1620920966264" variable="columnname" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620920973510" variable="columntype" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620920982770" variable="columnorder" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921007512" variable="columnsubkey" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921026993" variable="columnfillfactor" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921038003" variable="columnmandatory" editortype="Default" type="Boolean" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921049523" variable="columnformat" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921057036" variable="columnformatdescription" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921070820" variable="columniscomputed" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921089428" variable="columncomputedexpression" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921099241" variable="columnisunique" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921138576" variable="parentmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620921742084" variable="columnparentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620922120262" variable="booleanformat" displayname="booleanformat" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620922127986" variable="dateformat" displayname="dateformat" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925417525" variable="mappingorder" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925426938" variable="mappingname" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925437221" variable="mappingmandatory" editortype="Default" type="Boolean" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925448491" variable="mappingmapped" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925455233" variable="mappingdescription" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925464130" variable="mappingexample" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620925474425" variable="mappingtype" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620925514826" variable="mappingsubkey" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620925536107" variable="mappingparentmetadatauid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1620919611625" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1620919623038" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
