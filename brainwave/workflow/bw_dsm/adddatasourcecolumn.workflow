<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_adddatasourcecolumn" statictitle="add datasource column" scriptfile="workflow/bw_dsm/adddatasourcecolumn.javascript" displayname="add datasource column" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="185" y="45" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1610728319392"/>
			<Actions>
				<Action name="U1620650474168" action="executeview" viewname="bwdsm_getdatasource_def_mduid" append="false" attribute="parentmetadatauid">
					<ViewParam name="P16206504741680" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1620650474168_1" attribute="uid" variable="parentmetadatauid"/>
				</Action>
				<Action name="U1620650529013" action="update" attribute="SUBKEY" newvalue="{dataset.code.get()}$${dataset.name.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="185" y="290" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1610728348567" priority="1"/>
		<Component name="C1610728348567" type="metadataactivity" x="59" y="130" w="300" h="98" title="add column">
			<Metadata action="C" schema="bw_datasourcecolumn" master="parentmetadatauid">
				<Data subkey="SUBKEY" string1="name" string2="type" string3="cformat" boolean="cmandatory" integer1="corder" string4="cformatprettystring" integer2="cfillfactor" string5="cmustbeunique" string6="computedexpression" integer3="iscomputed"/>
				<Application/>
			</Metadata>
		</Component>
		<Link name="L1610728405629" source="C1610728348567" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1610728286568" variable="name" displayname="name" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1610728290504" variable="type" displayname="type" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1610816216383" variable="cformat" displayname="cformat" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1610816226168" variable="cmandatory" displayname="cmandatory" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1610822838983" variable="corder" displayname="corder" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1611159647907" variable="cformatprettystring" displayname="cformatprettystring" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1611233268726" variable="cfillfactor" displayname="cfillfactor" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1611254995557" variable="cmustbeunique" displayname="must be unique" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620307215457" variable="iscomputed" displayname="is computed" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1620307224348" variable="computedexpression" displayname="computed expression" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620650075832" variable="code" displayname="application code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1620650170465" variable="SUBKEY" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620650434347" variable="parentmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1610728319392" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1610728338007" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
