<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwrm_import_roles_main" statictitle="import roles" scriptfile="workflow/bw_rm/export/import_roles.javascript" displayname="Import roles (main)" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="299" y="24" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TLOGTYPE"/>
			</Ticket>
			<Init>
				<Actions>
				</Actions>
			</Init>
			<Candidates name="role" role="A1548411121638"/>
			<Output name="output" ticketactionnumbervariable="ticketaction" ticketlogrecorduidvariable="ticketlog"/>
			<Actions>
			</Actions>
			<FormVariable name="A1548843628091" variable="in_importFile" action="input" mandatory="true" longlist="false"/>
			<Validation>
			</Validation>
		</Component>
		<Component name="CEND" type="endactivity" x="299" y="1840" w="200" h="98" title="End" compact="true" inexclusive="true">
			<Actions/>
		</Component>
		<Component name="C1548608630124" type="deleteticketactivity" x="173" y="1610" w="300" h="98" title="delete existing tickets">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="existingroletickets"/>
		</Component>
		<Component name="C1550511511830" type="variablechangeactivity" x="173" y="121" w="300" h="98" title="prepare an import roles">
			<Actions function="importRoles">
				<Action name="U1550511552435" action="executeview" viewname="bwrm_annotationstickets" append="false" workflowtimeslot="false" attribute="existingroletickets">
					<ViewAttribute name="P1550511552435_0" attribute="recorduid" variable="existingroletickets"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1550588311196" source="CSTART" target="C1550511511830" priority="1"/>
		<Link name="L1550589145790" source="C1548608630124" target="CEND" priority="1"/>
		<Component name="C1521810495023_5" type="ticketreviewactivity" x="173" y="1469" w="300" h="98" title="create permission annotations">
			<TicketReview ticketaction="ticketaction">
				<Identity/>
				<Attribute name="status" attribute="TR_ANNOTATIONS"/>
				<Organisation/>
				<Permission permissionvariable="pr_perms"/>
				<Attribute name="comment" attribute="pr_comments"/>
				<Attribute name="custom1" attribute="pr_authors"/>
				<Attribute name="custom2" attribute="pr_dates"/>
			</TicketReview>
			<Output name="output"/>
		</Component>
		<Link name="L1550593504469" source="C1521810495023_5" target="C1548608630124" priority="1"/>
		<Component name="C1550594363996" type="scriptactivity" x="173" y="714" w="300" h="98" title="import roles identities">
			<Script onscriptexecute="importRolesIdentities"/>
		</Component>
		<Component name="C1550594363996_1" type="scriptactivity" x="173" y="999" w="300" h="98" title="import roles permissions">
			<Script onscriptexecute="importRolesPermissions"/>
		</Component>
		<Component name="C1550594363996_2" type="scriptactivity" x="173" y="1305" w="300" h="98" title="import perm annotations">
			<Script onscriptexecute="importPermissionAnnotations"/>
		</Component>
		<Link name="L1550594628978" source="C1550594363996_2" target="C1521810495023_5" priority="1"/>
		<Component name="C1583159492409" type="metadataactivity" x="173" y="264" w="300" h="98" title="Create roles">
			<Metadata action="C" owner="r_owner_uids" schema="bwrm_role">
				<Data subkey="r_codes" description="r_descriptions" string1="r_names" integer1="r_colors" details="r_jsons" integer2="r_statuses" string2="r_category"/>
				<Organisation organisation="r_orguids"/>
			</Metadata>
		</Component>
		<Link name="L1583160171740" source="C1550511511830" target="C1583159492409" priority="2"/>
		<Link name="L1583160177904" source="C1583159492409" target="C1550594363996_3" priority="1"/>
		<Component name="C1583163684056" type="metadataactivity" x="173" y="856" w="300" h="98" title="Create roles identities">
			<Metadata action="C" master="r_parent_metadata" schema="bwrm_role_identities">
				<Data subkey="r_codes" string1="r_identityrules" boolean="r_globals"/>
				<Identity identity="r_identity_uids"/>
			</Metadata>
		</Component>
		<Link name="L1583164141692" source="C1550594363996" target="C1583163684056" priority="2"/>
		<Link name="L1583164143712" source="C1583163684056" target="C1550594363996_1" priority="1"/>
		<Component name="C1583164155525" type="metadataactivity" x="173" y="1143" w="300" h="98" title="Create role permissions">
			<Metadata action="C" master="r_parent_metadata" schema="bwrm_role_permissions">
				<Data subkey="r_codes" boolean="r_permissionactive"/>
				<Permission permission1="r_permissions_uids"/>
			</Metadata>
		</Component>
		<Link name="L1583164183050" source="C1550594363996_1" target="C1583164155525" priority="2"/>
		<Link name="L1583164186180" source="C1583164155525" target="C1550594363996_2" priority="1"/>
		<Component name="C1550594363996_3" type="scriptactivity" x="173" y="412" w="300" h="98" title="import roles identities for global roles">
			<Script onscriptexecute="importGlobalRolesIdentities"/>
		</Component>
		<Component name="C1583163684056_1" type="metadataactivity" x="173" y="565" w="300" h="98" title="Create global roles identities">
			<Metadata action="C" master="r_parent_metadata" schema="bwrm_role_identities">
				<Data subkey="r_codes" string1="r_identityrules" boolean="r_globals" string3="r_identityruleser" string4="r_identityruletitle"/>
				<Identity/>
			</Metadata>
		</Component>
		<Link name="L1583166421778" source="C1550594363996_3" target="C1583163684056_1" priority="1"/>
		<Link name="L1583166423603" source="C1583163684056_1" target="C1550594363996" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1548265009369" variable="in_importFile" displayname="Import File Path" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="full path or XLSX file to import" initialvalue="C:/Temp/roles_data.xlsx"/>
		<Variable name="A1548608673189" variable="existingroletickets" displayname="existingroletickets" editortype="Default" type="Number" multivalued="true" visibility="local" description="role ticket recorduids" notstoredvariable="true"/>
		<Variable name="A1548687309319" variable="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1548694398273" variable="TLOGTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="IMPORT_ROLES" notstoredvariable="true"/>
		<Variable name="A1548940040071" variable="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="S1548426094964" variable="roles" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="true"/>
		<Variable name="A1548426162333" variable="r_codes" displayname="role codes" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426267429" variable="r_names" displayname="role names" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426298454" variable="r_category" displayname="role category" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426196111" variable="r_colors" displayname="role color" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426233600" variable="r_descriptions" displayname="role descriptions" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426321406" variable="r_statuses" displayname="role statuses" editortype="Default" type="Number" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426356191" variable="r_orguids" displayname="role org uids" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548426528937" variable="r_owner_uids" displayname="roles owner uids" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1548427565016" variable="r_globals" displayname="role globals" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>

		<Variable name="A1550511143373" variable="TR_ROLE" displayname="TR_ROLE" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="ROLE"/>
		<Variable name="A1550511236430" variable="TR_ROLECONTENT" displayname="TR_ROLECONTENT" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="ROLECONTENT"/>
		<Variable name="A1550593076972" variable="r_identity_uids" displayname="r_identity_uids" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1550593242314" variable="r_permissions_uids" displayname="r_permissions_uids" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1550593330564" variable="TR_ANNOTATIONS" displayname="TR_ANNOTATIONS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="RM_PERM_REVIEW" notstoredvariable="true"/>
		<Variable name="S1550593393170" variable="perm_reviews" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1550593417864" variable="pr_authors" displayname="pr_authors" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" syncname="S1550593393170" notstoredvariable="true"/>
		<Variable name="A1550593438477" variable="pr_comments" displayname="pr_comments" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1550593393170" notstoredvariable="true"/>
		<Variable name="A1550593457418" variable="pr_dates" displayname="pr_dates" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1550593393170" notstoredvariable="true"/>
		<Variable name="A1550593473941" variable="pr_perms" displayname="pr_perms" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" syncname="S1550593393170" notstoredvariable="true"/>
		<Variable name="A1551456031203" variable="r_identityrules" displayname="identity rules" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1583159829245" variable="r_jsons" displayname="r_jsons" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1583161629423" variable="role_metadata_uids" displayname="role_metadata_uids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1583162028213" variable="r_parent_metadata" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1583164287674" variable="r_permissionactive" displayname="r_permissionactive" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1687854020215" variable="r_identityruleser" displayname="r_identityruleser" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
		<Variable name="A1687942620226" variable="r_identityruletitle" displayname="r_identityruletitle" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1548426094964" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1548411121638" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ADMIN" description="platform admin">
			<Rule name="A1548411195556" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
