<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwsod_designer_savepair" statictitle="Save SoD pair" scriptfile="/workflow/bw_sod/empty.javascript" displayname="Save SoD pair : {dataset.permissioncode1.get()} x {dataset.permissioncode2.get()} ">
		<Component name="CSTART" type="startactivity" x="391" y="37" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1762417772503" action="executeview" viewname="bwsod_designer_permissiondetails" append="false" attribute="applicationcode1">
					<ViewParam name="P17624177725030" param="permissionuid" paramvalue="{dataset.permission1.get()}"/>
					<ViewAttribute name="P1762417772503_1" attribute="applicationcode" variable="applicationcode1"/>
					<ViewAttribute name="P1762417772503_2" attribute="permissioncode" variable="permissioncode1"/>
				</Action>
				<Action name="U1762417804609" action="executeview" viewname="bwsod_designer_permissiondetails" append="false" attribute="applicationcode2">
					<ViewParam name="P17624178046090" param="permissionuid" paramvalue="{dataset.permission2.get()}"/>
					<ViewAttribute name="P1762417804609_1" attribute="applicationcode" variable="applicationcode2"/>
					<ViewAttribute name="P1762417804609_2" attribute="permissioncode" variable="permissioncode2"/>
				</Action>
				<Action name="U1764778407140" action="update" attribute="uniqueKey" newvalue="{dataset.matrixcode.get()}_{dataset.toxicKey.get()}"/>
			</Actions>
			<Candidates name="role" role="A1762417672808"/>
		</Component>
		<Component name="CEND" type="endactivity" x="386" y="363" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1762360242630_1" priority="1"/>
		<Component name="C1762360242630_1" type="metadataactivity" x="262" y="166" w="300" h="98" title="Set matrix pairs">
			<Metadata action="C" schema="bwsod_toxic_pairs">
				<Permission permission1="permission1" permission2="permission2"/>
				<Data string3="matrixcode" string4="matrixname" string5="permissioncode1" string6="permissioncode2" string7="applicationcode1" string8="applicationcode2" integer1="risklevel" boolean="enabled" subkey="matrixcode"/>
			</Metadata>
		</Component>
		<Link name="L1762417926024" source="C1762360242630_1" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1762417516748" variable="permissioncode1" displayname="permissioncode1" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762417522663" variable="permissioncode2" displayname="permissioncode2" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762417533996" variable="applicationcode1" displayname="applicationcode1" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762417546080" variable="applicationcode2" displayname="applicationcode2" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762417579184" variable="permission2" displayname="permission2" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1762417588412" variable="risklevel" displayname="risklevel" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1762417597466" variable="matrixcode" displayname="matrixcode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1762417628679" variable="matrixname" displayname="matrixname" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1762419282899" variable="permission1" displayname="permission1" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1762419440647" variable="toxicKey" displayname="toxicKey" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1764256690604" variable="enabled" displayname="enabled" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1764778206949" variable="uniqueKey" displayname="uniqueKey" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1762417672808" displayname="owner">
			<Rule name="A1762417681711" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
