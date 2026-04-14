<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwdsm_data_import" statictitle="bwdsm_data_import" scriptfile="/workflow/bw_dsm/data_import.javascript">
		<Component name="CSTART" type="startactivity" x="517" y="24" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TLOG_TYPE"/>
			</Ticket>
			<Candidates name="role" role="A1691503021907"/>
			<Init>
			<Actions function="initWorkflow"/>
			</Init>
			<Actions function="loadImportFile"/>
		</Component>
		<Component name="CEND" type="endactivity" x="516" y="1366" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1691509940745" priority="1"/>
		<Component name="C1691509940745" type="metadataactivity" x="391" y="140" w="300" h="98" title="delete_children_metadata">
			<Metadata action="D" metadatauid="md_to_delete"/>
		</Component>
		<Link name="L1691509963828" source="C1691509940745" target="C1691510480566" priority="1"/>
		<Component name="C1691510480566" type="metadataactivity" x="392" y="308" w="300" h="98" title="create_new_ds">
			<Metadata action="C" schema="bw_datasource_def" outmetadatauid="created_ds_uid">
				<Data subkey="new_ds_subkey" description="new_ds_description" string1="new_ds_value1string" string2="new_ds_value2string" integer1="new_ds_value1integer" boolean="new_ds_valueboolean" string3="new_ds_value3string" string4="new_ds_value4string" string5="new_ds_value5string" string6="new_ds_value6string" details="new_ds_details"/>
			</Metadata>
		</Component>
		<Link name="L1691510496088" source="C1691510480566" target="C1691510645902" priority="1"/>
		<Component name="C1691510645902" type="scriptactivity" x="390" y="468" w="300" h="98" title="reload_data">
			<Script onscriptexecute="loadImportFile"/>
		</Component>
		<Link name="L1691510660447" source="C1691510645902" target="C1691511194906" priority="1"/>
		<Component name="C1691511194906" type="metadataactivity" x="389" y="659" w="300" h="98" title="update_ds_data">
			<Metadata action="C" schema="bw_datasource_def">
				<Data subkey="file_ds_subkey" description="file_ds_description" string1="file_ds_value1string" string2="file_ds_value2string" integer1="file_ds_value1integer" boolean="file_ds_valueboolean" string3="file_ds_value3string" string4="file_ds_value4string" string5="file_ds_value5string" string6="file_ds_value6string" details="file_ds_details"/>
			</Metadata>
		</Component>
		<Link name="L1691511207448" source="C1691511194906" target="C1691511965490" priority="1"/>
		<Component name="C1691511965490" type="metadataactivity" x="390" y="823" w="300" h="98" title="create_md_ds_col">
			<Metadata action="C" master="file_ds_col_parent_uid" schema="bw_datasourcecolumn">
				<Data subkey="file_ds_col_subkey" description="file_ds_col_description" string1="file_ds_col_value1string" string2="file_ds_col_value2string" integer1="file_ds_col_value1integer" integer2="file_ds_col_value2integer" boolean="file_ds_col_valueboolean" string3="file_ds_col_value3string" string4="file_ds_col_value4string" string5="file_ds_col_value5string" string6="file_ds_col_value6string" integer3="file_ds_col_value3integer"/>
			</Metadata>
		</Component>
		<Link name="L1691511984174" source="C1691511965490" target="C1691512613168" priority="1"/>
		<Component name="C1691512613168" type="metadataactivity" x="387" y="991" w="300" h="98" title="create_md_ds_fmt">
			<Metadata action="C" master="file_ds_fmt_parent_uid" schema="bw_datasourceformat">
				<Data subkey="file_ds_fmt_subkey" description="file_ds_fmt_description" string1="file_ds_fmt_value1string" string2="file_ds_fmt_value2string" integer2="file_ds_fmt_value2integer" integer1="file_ds_fmt_value1integer" boolean="file_ds_fmt_valueboolean" string3="file_ds_fmt_value3string" string4="file_ds_fmt_value4string" string5="file_ds_fmt_value5string" integer3="file_ds_fmt_value3integer" integer4="file_ds_fmt_value4integer"/>
			</Metadata>
		</Component>
		<Link name="L1691512634664" source="C1691512613168" target="C1691513519468" priority="1"/>
		<Component name="C1691513519468" type="metadataactivity" x="387" y="1177" w="300" h="98" title="create_md_ds_map">
			<Metadata action="C" master="file_ds_map_parent_uid" schema="bw_datasourcemapping">
				<Data subkey="file_ds_map_subkey" description="file_ds_map_description" string1="file_ds_map_value1string" string2="file_ds_map_value2string" integer1="file_ds_map_value1integer" boolean="file_ds_map_valueboolean" string3="file_ds_map_value3string" string4="file_ds_map_value4string" string5="file_ds_map_value5string"/>
			</Metadata>
		</Component>
		<Link name="L1691513531021" source="C1691513519468" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1691502853545" variable="in_importFile" displayname="in_importFile" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1691503988738" variable="TLOG_TYPE" displayname="TLOG_TYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="IMPORT_DSM_DATA" notstoredvariable="true"/>
		
		
		<Variable name="S1691505642938" variable="file_ds_" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1691505781912" variable="file_ds_key" displayname="key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781913" variable="file_ds_subkey" displayname="subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781941" variable="file_ds_parent_subkey" displayname="parent_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781942" variable="file_ds_parent_key" displayname="parent_key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781914" variable="file_ds_value1string" displayname="value1string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781915" variable="file_ds_value2string" displayname="value2string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781916" variable="file_ds_value3string" displayname="value3string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781917" variable="file_ds_value4string" displayname="value4string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781918" variable="file_ds_value5string" displayname="value5string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781919" variable="file_ds_value6string" displayname="value6string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781920" variable="file_ds_value7string" displayname="value7string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781921" variable="file_ds_value8string" displayname="value8string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781922" variable="file_ds_value9string" displayname="value9string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781923" variable="file_ds_value10string" displayname="value10string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781924" variable="file_ds_value11string" displayname="value11string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781925" variable="file_ds_value12string" displayname="value12string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781926" variable="file_ds_value1integer" displayname="value1integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781927" variable="file_ds_value2integer" displayname="value2integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781928" variable="file_ds_value3integer" displayname="value3integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781929" variable="file_ds_value4integer" displayname="value4integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781930" variable="file_ds_value5integer" displayname="value5integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781931" variable="file_ds_value6integer" displayname="value6integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781932" variable="file_ds_value7integer" displayname="value7integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781933" variable="file_ds_value8integer" displayname="value8integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781934" variable="file_ds_value9integer" displayname="value9integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781935" variable="file_ds_value10integer" displayname="value10integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781936" variable="file_ds_value11integer" displayname="value11integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781937" variable="file_ds_value12integer" displayname="value12integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781938" variable="file_ds_valueboolean" displayname="valueboolean" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781939" variable="file_ds_description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781940" variable="file_ds_details" displayname="details" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781941" variable="file_ds_uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		<Variable name="A1691505781942" variable="file_ds_parent_uid" displayname="parent_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642938" notstoredvariable="true"/>
		
		
		<Variable name="S1691505642138" variable="new_ds_" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1691505781112" variable="new_ds_key" displayname="key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781113" variable="new_ds_subkey" displayname="subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781141" variable="new_ds_parent_subkey" displayname="parent_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781142" variable="new_ds_parent_key" displayname="parent_key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781114" variable="new_ds_value1string" displayname="value1string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781115" variable="new_ds_value2string" displayname="value2string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781116" variable="new_ds_value3string" displayname="value3string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781117" variable="new_ds_value4string" displayname="value4string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781118" variable="new_ds_value5string" displayname="value5string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781119" variable="new_ds_value6string" displayname="value6string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781120" variable="new_ds_value7string" displayname="value7string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781121" variable="new_ds_value8string" displayname="value8string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781122" variable="new_ds_value9string" displayname="value9string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781123" variable="new_ds_value10string" displayname="value10string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781124" variable="new_ds_value11string" displayname="value11string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781125" variable="new_ds_value12string" displayname="value12string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781126" variable="new_ds_value1integer" displayname="value1integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781127" variable="new_ds_value2integer" displayname="value2integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781128" variable="new_ds_value3integer" displayname="value3integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781129" variable="new_ds_value4integer" displayname="value4integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781130" variable="new_ds_value5integer" displayname="value5integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781131" variable="new_ds_value6integer" displayname="value6integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781132" variable="new_ds_value7integer" displayname="value7integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781133" variable="new_ds_value8integer" displayname="value8integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781134" variable="new_ds_value9integer" displayname="value9integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781135" variable="new_ds_value10integer" displayname="value10integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781136" variable="new_ds_value11integer" displayname="value11integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781137" variable="new_ds_value12integer" displayname="value12integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781138" variable="new_ds_valueboolean" displayname="valueboolean" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781139" variable="new_ds_description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781140" variable="new_ds_details" displayname="details" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781141" variable="new_ds_uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		<Variable name="A1691505781142" variable="new_ds_parent_uid" displayname="parent_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642138" notstoredvariable="true"/>
		
		<Variable name="S1691505642238" variable="file_ds_col_" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1691505781212" variable="file_ds_col_key" displayname="key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781213" variable="file_ds_col_subkey" displayname="subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781241" variable="file_ds_col_parent_subkey" displayname="parent_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781242" variable="file_ds_col_parent_key" displayname="parent_key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781214" variable="file_ds_col_value1string" displayname="value1string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781215" variable="file_ds_col_value2string" displayname="value2string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781216" variable="file_ds_col_value3string" displayname="value3string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781217" variable="file_ds_col_value4string" displayname="value4string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781218" variable="file_ds_col_value5string" displayname="value5string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781219" variable="file_ds_col_value6string" displayname="value6string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781220" variable="file_ds_col_value7string" displayname="value7string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781221" variable="file_ds_col_value8string" displayname="value8string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781222" variable="file_ds_col_value9string" displayname="value9string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781223" variable="file_ds_col_value10string" displayname="value10string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781224" variable="file_ds_col_value11string" displayname="value11string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781225" variable="file_ds_col_value12string" displayname="value12string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781226" variable="file_ds_col_value1integer" displayname="value1integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781227" variable="file_ds_col_value2integer" displayname="value2integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781228" variable="file_ds_col_value3integer" displayname="value3integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781229" variable="file_ds_col_value4integer" displayname="value4integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781230" variable="file_ds_col_value5integer" displayname="value5integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781231" variable="file_ds_col_value6integer" displayname="value6integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781232" variable="file_ds_col_value7integer" displayname="value7integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781233" variable="file_ds_col_value8integer" displayname="value8integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781234" variable="file_ds_col_value9integer" displayname="value9integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781235" variable="file_ds_col_value10integer" displayname="value10integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781236" variable="file_ds_col_value11integer" displayname="value11integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781237" variable="file_ds_col_value12integer" displayname="value12integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781238" variable="file_ds_col_valueboolean" displayname="valueboolean" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781239" variable="file_ds_col_description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781240" variable="file_ds_col_details" displayname="details" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781241" variable="file_ds_col_uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		<Variable name="A1691505781242" variable="file_ds_col_parent_uid" displayname="parent_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642238" notstoredvariable="true"/>
		
		
		
		<Variable name="S1691505642338" variable="file_ds_fmt_" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1691505781312" variable="file_ds_fmt_key" displayname="key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781313" variable="file_ds_fmt_subkey" displayname="subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781341" variable="file_ds_fmt_parent_subkey" displayname="parent_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781342" variable="file_ds_fmt_parent_key" displayname="parent_key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781314" variable="file_ds_fmt_value1string" displayname="value1string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781315" variable="file_ds_fmt_value2string" displayname="value2string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781316" variable="file_ds_fmt_value3string" displayname="value3string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781317" variable="file_ds_fmt_value4string" displayname="value4string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781318" variable="file_ds_fmt_value5string" displayname="value5string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781319" variable="file_ds_fmt_value6string" displayname="value6string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781320" variable="file_ds_fmt_value7string" displayname="value7string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781321" variable="file_ds_fmt_value8string" displayname="value8string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781322" variable="file_ds_fmt_value9string" displayname="value9string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781323" variable="file_ds_fmt_value10string" displayname="value10string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781324" variable="file_ds_fmt_value11string" displayname="value11string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781325" variable="file_ds_fmt_value12string" displayname="value12string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781326" variable="file_ds_fmt_value1integer" displayname="value1integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781327" variable="file_ds_fmt_value2integer" displayname="value2integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781328" variable="file_ds_fmt_value3integer" displayname="value3integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781329" variable="file_ds_fmt_value4integer" displayname="value4integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781330" variable="file_ds_fmt_value5integer" displayname="value5integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781331" variable="file_ds_fmt_value6integer" displayname="value6integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781332" variable="file_ds_fmt_value7integer" displayname="value7integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781333" variable="file_ds_fmt_value8integer" displayname="value8integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781334" variable="file_ds_fmt_value9integer" displayname="value9integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781335" variable="file_ds_fmt_value10integer" displayname="value10integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781336" variable="file_ds_fmt_value11integer" displayname="value11integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781337" variable="file_ds_fmt_value12integer" displayname="value12integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781338" variable="file_ds_fmt_valueboolean" displayname="valueboolean" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781339" variable="file_ds_fmt_description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781340" variable="file_ds_fmt_details" displayname="details" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781341" variable="file_ds_fmt_uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		<Variable name="A1691505781342" variable="file_ds_fmt_parent_uid" displayname="parent_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642338" notstoredvariable="true"/>
		
		
		<Variable name="S1691505642438" variable="file_ds_map_" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1691505781412" variable="file_ds_map_key" displayname="key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781413" variable="file_ds_map_subkey" displayname="subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781441" variable="file_ds_map_parent_subkey" displayname="parent_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781442" variable="file_ds_map_parent_key" displayname="parent_key" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781414" variable="file_ds_map_value1string" displayname="value1string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781415" variable="file_ds_map_value2string" displayname="value2string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781416" variable="file_ds_map_value3string" displayname="value3string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781417" variable="file_ds_map_value4string" displayname="value4string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781418" variable="file_ds_map_value5string" displayname="value5string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781419" variable="file_ds_map_value6string" displayname="value6string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781420" variable="file_ds_map_value7string" displayname="value7string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781421" variable="file_ds_map_value8string" displayname="value8string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781422" variable="file_ds_map_value9string" displayname="value9string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781423" variable="file_ds_map_value10string" displayname="value10string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781424" variable="file_ds_map_value11string" displayname="value11string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781425" variable="file_ds_map_value12string" displayname="value12string" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781426" variable="file_ds_map_value1integer" displayname="value1integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781427" variable="file_ds_map_value2integer" displayname="value2integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781428" variable="file_ds_map_value3integer" displayname="value3integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781429" variable="file_ds_map_value4integer" displayname="value4integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781430" variable="file_ds_map_value5integer" displayname="value5integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781431" variable="file_ds_map_value6integer" displayname="value6integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781432" variable="file_ds_map_value7integer" displayname="value7integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781433" variable="file_ds_map_value8integer" displayname="value8integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781434" variable="file_ds_map_value9integer" displayname="value9integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781435" variable="file_ds_map_value10integer" displayname="value10integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781436" variable="file_ds_map_value11integer" displayname="value11integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781437" variable="file_ds_map_value12integer" displayname="value12integer" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781438" variable="file_ds_map_valueboolean" displayname="valueboolean" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781439" variable="file_ds_map_description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781440" variable="file_ds_map_details" displayname="details" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781441" variable="file_ds_map_uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		<Variable name="A1691505781442" variable="file_ds_map_parent_uid" displayname="parent_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1691505642438" notstoredvariable="true"/>
		
		
		<Variable name="A1691509865541" variable="md_to_delete" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1694094606341" variable="created_ds_uid" displayname="created_ds_uid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1691503021907" displayname="ADMIN" description="admin">
			<Rule name="A1691503037904" rule="control_activeidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
