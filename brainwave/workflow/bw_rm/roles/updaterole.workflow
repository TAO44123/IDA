<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwpm_updaterole" statictitle="update role" description="update role" scriptfile="/workflow/bw_rm/roles/rm_workflows.javascript" displayname="update role {dataset.in_rolecode}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="155" y="21" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Candidates name="role" role="A1521810643330"/>
			<Actions>
			</Actions>
			<FormVariable name="A1521828719349" variable="in_rolecode" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1570540695210" variable="in_rolename" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1570540797303" variable="in_color" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1570540864627" variable="in_owner" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1570540892609" variable="in_identityrule" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1570540898615" variable="in_roledescription" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1570540928332" variable="in_force_update_rolecontents" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1570540964684" variable="in_attachedorg" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1570540997742" variable="in_status" action="input" mandatory="true" longlist="false"/>
			<Init>
				<Actions/>
			</Init>
		</Component>
		<Component name="CEND" type="endactivity" x="157" y="416" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="C1582044524545_1" type="scriptactivity" x="29" y="106" w="300" h="98" title="Prepare role content">
			<Script onscriptexecute="prepareContent"/>
		</Component>
		<Link name="L1582129230433" source="CSTART" target="C1582044524545_1" priority="2"/>
		<Component name="C1582044494418_1" type="metadataactivity" x="29" y="240" w="300" h="98" title="Update role metadata" outexclusive="true">
			<Metadata action="C" schema="bwrm_role" owner="in_owner" outmetadatauid="parentmetadata">
				<Data subkey="in_rolecode" description="in_roledescription" string1="in_rolename" integer1="in_color" details="roledetailsjson" double1="in_roleversion" integer2="in_status" string2="in_category"/>
				<Organisation organisation="in_attachedorg"/>
			</Metadata>
		</Component>
		<Link name="L1582129258522" source="C1582044524545_1" target="C1582044494418_1" priority="1"/>
		<Link name="L1582129261175" source="C1582044494418_1" target="CEND" priority="2"/>
		<Component name="C1582815484385" type="metadataactivity" x="524" y="240" w="300" h="98" title="Set identityrule">
			<Metadata schema="bwrm_role_identities" action="C" master="parentmetadata">
				<Data subkey="in_rolecode" string1="in_identityrule" boolean="trueval"/>
				<Identity identity="emptyvar"/>
			</Metadata>
		</Component>
		<Link name="L1582815502357" source="C1582044494418_1" target="C1582815484385" priority="1" expression="(! dataset.isEmpty(&apos;in_identityrule&apos;))" labelcustom="true" label="If identityrule is not empty"/>
		<Link name="L1582815545128" source="C1582815484385" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1521810314250" variable="in_owner" displayname="role owner" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="role owner" notstoredvariable="false"/>
		<Variable name="A1521810327898" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521810347092" variable="in_rolecode" displayname="role code" editortype="Default" type="String" multivalued="false" visibility="in" description="role code" notstoredvariable="false"/>
		<Variable name="A1521810365958" variable="in_rolename" displayname="role name" editortype="Default" type="String" multivalued="false" visibility="in" description="role name" notstoredvariable="false"/>
		<Variable name="A1521810385656" variable="in_roledescription" displayname="role description" editortype="Default" type="String" multivalued="false" visibility="in" description="role description" notstoredvariable="false"/>
		<Variable name="A1521810367567" variable="in_category" displayname="role category" editortype="Default" type="String" multivalued="false" visibility="in" description="role category" notstoredvariable="false"/>
		<Variable name="A1521810411732" variable="in_attachedorg" displayname="attached organisation" editortype="Ledger Organisation" type="String" multivalued="false" visibility="in" description="attached organisation" notstoredvariable="false"/>
		<Variable name="A1521810455010" variable="TICKETLOG" displayname="ticket log" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLEMANAGEMENT" notstoredvariable="false"/>
		<Variable name="A1521810601414" variable="TRTYPE" displayname="TICKET REVIEW TYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLE" notstoredvariable="false"/>
		<Variable name="A1539608681962" variable="in_color" displayname="Color" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1550679717311" variable="in_identityrule" displayname="identityrule" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1552857775692" variable="in_status" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1570528286661" variable="in_force_update_rolecontents" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="false" description="True to force upde of ROLECONTENT tickets event if name is not modified (usefull to repair a corrupted role)"/>
		<Variable name="A15705397345320" variable="identities" multivalued="true" visibility="local" type="String" editortype="Ledger Identity"/>
		<Variable name="A15705398211820" variable="permissions" multivalued="true" visibility="local" type="String" editortype="Ledger Permission"/>
		<Variable name="A1582129062856" variable="in_roleversion" displayname="in_roleversion" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1582129360393" variable="roledetailsjson" displayname="roledetailsjson" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582815753590" variable="emptyvar" displayname="emptyvar" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582815766547" variable="trueval" displayname="trueval" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1582815831250" variable="parentmetadata" displayname="parentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1521810643330" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1521810653582" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
