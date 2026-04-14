<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwdsm_save_datasource_def" statictitle="save or update ds cfg" scriptfile="workflow/bw_dsm/dsm_workflow.javascript" technical="true" displayname="save or update ds cfg {dataset.name}">
		<Component name="CSTART" type="startactivity" x="225" y="53" w="200" h="114" title="Start" compact="true">
			<Ticket create="false"/>
			<Candidates name="role" role="A1656054939364"/>
			<FormVariable name="A1661955103625" variable="name" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1661955109150" variable="id" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1661955114078" variable="connector" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="225" y="318" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1656055032686" priority="1"/>
		<Component name="C1656055032686" type="metadataactivity" x="156" y="139" w="185" h="98" title="save cfg">
			<Metadata schema="bw_datasource_def" action="C">
				<Data subkey="name" string1="connector" integer1="id" string3="sourcePath" string4="destPathVar" string5="filePattern" boolean="multifile" details="options" string2="collector" string6="destDir"/>
			</Metadata>
		</Component>
		<Link name="L1656055041777" source="C1656055032686" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1655980057607" variable="name" displayname="name" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655980071166" variable="connector" displayname="connector" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1661952895242" variable="id" displayname="id" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662060466853" variable="sourcePath" displayname="Source Path" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662060486286" variable="destPathVar" displayname="dest Path" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662060524616" variable="filePattern" displayname="File Pattern" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662279111905" variable="multifile" displayname="multifile" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662374275807" variable="options" displayname="json options" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662379551839" variable="collector" displayname="collector facet" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1671631381989" variable="destDir" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1656054939364" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1656054992117" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
