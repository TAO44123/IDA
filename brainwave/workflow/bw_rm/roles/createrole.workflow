<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwpm_createrole" statictitle="createrole" description="create role" scriptfile="/workflow/bw_rm/roles/rm_workflows.javascript" displayname="create role {dataset.in_rolecode}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="184" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Candidates name="role" role="A1521810643330"/>
			<FormVariable name="in_rolecode1678288358369" action="input" variable="in_rolecode" mandatory="false" longlist="false"/>
			<FormVariable name="in_rolename1678288362676" action="input" variable="in_rolename" mandatory="false" longlist="false"/>
			<FormVariable name="in_attachedorg1678288382983" action="input" variable="in_attachedorg" mandatory="false" longlist="false"/>
			<FormVariable name="in_setcontent1678288662802" action="input" variable="in_setcontent" mandatory="true" longlist="false"/>
			<FormVariable name="in_identityrule1678288374537" action="input" variable="in_identityrule" mandatory="false" longlist="false"/>
			<FormVariable name="in_identityrulecontent1678288376120" action="input" variable="in_identityrulecontent" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="585" y="293" w="200" h="98" title="End" compact="true"/>
		<Component name="C1582044494418" type="metadataactivity" x="58" y="268" w="300" h="98" title="Create role metadata" outexclusive="true">
			<Metadata action="C" schema="bwrm_role" owner="in_owner" outmetadatauid="createdmetadatauids">
				<Data subkey="in_rolecode" description="in_roledescription" string1="in_rolename" integer1="in_color" details="roledetailsjson" double1="in_roleversion" integer2="in_status" string2="in_category"/>
				<Organisation organisation="in_attachedorg"/>
			</Metadata>
		</Component>
		<Link name="L1582044506207" source="CSTART" target="C1582044524545" priority="2"/>
		<Component name="C1582044524545" type="scriptactivity" x="58" y="118" w="300" h="98" title="Prepare role content">
			<Script onscriptexecute="prepareContent"/>
		</Component>
		<Link name="L1582044560460" source="C1582044524545" target="C1582044494418" priority="1"/>
		<Link name="L1582044562755" source="C1582044494418" target="CEND" priority="2" expression="!dataset.in_setcontent.get()"/>
		<Component name="C1539784227066_1" type="callactivity" x="459" y="422" w="300" h="98" title="updaterolecontent">
			<Process workflowfile="/workflow/bw_rm/roles/updaterolecontent.workflow">
				<Input name="A1539784474828" variable="in_rolecode" content="in_rolecode"/>
				<Input name="A1539784486420" variable="in_identities" content="in_identities"/>
				<Input name="A1539784493910" variable="in_owner" content="in_owner"/>
				<Input name="A1539784499209" variable="in_permissions" content="in_permissions"/>
				<Input name="A1582120168167" variable="in_rolemetadata_uid" content="createdmetadatauid"/>
				<Input name="A1582203650463" variable="in_identitiesrulename" content="in_identityrule"/>
				<Input name="A1678286541984" variable="in_identitiesrulecontent" content="in_identityrulecontent"/>
				<Input name="A1687939656162" variable="in_identitiesruletitle" content="in_identityruletitle"/>
			</Process>
		</Component>
		<Link name="L1582106285659" source="C1582044494418" target="C1582122465340" priority="1" expression="dataset.in_setcontent.get()"/>
		<Link name="L1582106306681" source="C1539784227066_1" target="CEND" priority="1"/>
		<Component name="C1582122465340" type="variablechangeactivity" x="58" y="422" w="300" h="98" title="Get role metadata uid">
			<Actions>
				<Action name="U1582122572030" action="update" attribute="createdmetadatauid" newvalue="{dataset.createdmetadatauids.get()}" condition="!dataset.isEmpty(&apos;createdmetadatauids&apos;)"/>
			</Actions>
		</Component>
		<Link name="L1582122650435" source="C1582122465340" target="C1539784227066_1" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1521810314250" variable="in_owner" displayname="role owner" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="role owner" notstoredvariable="false"/>
		<Variable name="A1521810327898" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521810347092" variable="in_rolecode" displayname="role code" editortype="Default" type="String" multivalued="false" visibility="in" description="role code" notstoredvariable="false"/>
		<Variable name="A1521810365958" variable="in_rolename" displayname="role name" editortype="Default" type="String" multivalued="false" visibility="in" description="role name" notstoredvariable="false"/>
		<Variable name="A1521810385656" variable="in_roledescription" displayname="role description" editortype="Default" type="String" multivalued="false" visibility="in" description="role description" notstoredvariable="false"/>
		<Variable name="A1521810367864" variable="in_category" displayname="role category" editortype="Default" type="String" multivalued="false" visibility="in" description="role category" notstoredvariable="false"/>
		<Variable name="A1521810411732" variable="in_attachedorg" displayname="attached organisation" editortype="Default" type="String" multivalued="false" visibility="in" description="attached organisation" notstoredvariable="false"/>
		<Variable name="A1521810455010" variable="TICKETLOG" displayname="ticket log" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLEMANAGEMENT" notstoredvariable="false"/>
		<Variable name="A1521810601414" variable="TRTYPE" displayname="TICKET REVIEW TYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLE" notstoredvariable="false"/>
		<Variable name="A1539608306267" variable="in_color" displayname="Color" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1539784287992" variable="in_identities" displayname="Identities" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1539784358828" variable="in_permissions" displayname="permissions" editortype="Ledger Permission" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1539784438923" variable="in_setcontent" displayname="set content" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="false"/>
		<Variable name="A1550681501469" variable="in_identityrule" displayname="identityrule" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1552857718694" variable="in_status" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1582047693539" variable="roledetailsjson" displayname="roledetailsjson" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582048622921" variable="in_roleversion" displayname="in_roleversion" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1582120101856" variable="createdmetadatauid" displayname="createdmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582122524920" variable="createdmetadatauids" displayname="createdmetadatauids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1678286179769" variable="in_identityrulecontent" displayname="Identity Rule mode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true">
		</Variable>
		<Variable name="A1687938360270" variable="in_identityruletitle" displayname="in_identityruletitle" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1521810643330" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1521810653582" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
