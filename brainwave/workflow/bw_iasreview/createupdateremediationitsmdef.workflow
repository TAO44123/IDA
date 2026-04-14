<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_createupdateremediationitsmdef" statictitle="create update remediation itsm definition" scriptfile="/workflow/bw_iasreview/createupdateremediationitsmdef.javascript" displayname="create update remediation itsm definition" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="346" y="69" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655123061983"/>
			<Actions/>
		</Component>
		<Component name="CEND" type="endactivity" x="346" y="355" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655111347236" priority="1"/>
		<Component name="C1655111347236" type="metadataactivity" x="220" y="183" w="300" h="98" title="update metadata">
			<Metadata action="C" schema="bwr_remediation_itsmdef">
				<Data subkey="code" description="name" string1="code" string2="type" string3="name" string4="stringpassword4" string6="stringpassword6" string7="stringpassword7" string5="stringpassword5" string8="stringpassword8" string9="stringpassword9" string10="stringpassword10" string11="stringpassword11" string12="stringpassword12" string13="stringpassword13" string14="stringpassword14" string15="stringpassword15" string16="stringpassword16" string17="stringpassword17" string18="stringpassword18" string19="stringpassword19" string20="stringpassword20"/>
			</Metadata>
		</Component>
		<Link name="L1655111359413" source="C1655111347236" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1655108661161" variable="code" displayname="ITSM instance code" editortype="Default" type="String" multivalued="false" visibility="in" description="ITSM instance code" notstoredvariable="true"/>
		<Variable name="A1655108677592" variable="type" displayname="ITSM type" editortype="Default" type="String" multivalued="false" visibility="in" description="ITSM type" notstoredvariable="true"/>
		<Variable name="A1655108703016" variable="name" displayname="ITSM pretty name" editortype="Default" type="String" multivalued="false" visibility="in" description="ITSM pretty name" notstoredvariable="true"/>
		<Variable name="A1655448033293" variable="stringpassword4" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033294" variable="stringpassword5" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033295" variable="stringpassword6" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033296" variable="stringpassword7" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033297" variable="stringpassword8" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033298" variable="stringpassword9" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033299" variable="stringpassword10" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033200" variable="stringpassword11" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033201" variable="stringpassword12" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033202" variable="stringpassword13" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033203" variable="stringpassword14" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033204" variable="stringpassword15" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033205" variable="stringpassword16" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033206" variable="stringpassword17" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033207" variable="stringpassword18" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033208" variable="stringpassword19" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655448033209" variable="stringpassword20" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1655123061983" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655123101354" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
