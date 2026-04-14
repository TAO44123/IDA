<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwpm_updaterolecontent" statictitle="updaterolecontent" scriptfile="/workflow/bw_rm/roles/rm_workflows.javascript" displayname="update role content {dataset.in_rolecode}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="153" y="7" w="200" h="114" title="Start" compact="true">
			<Actions function="resolveRoleMetadataUID">
				<Action name="U1521815785891" action="executeview" viewname="bwpm_roledetails_md" append="false" attribute="rolerecorduid" workflowtimeslot="false">
					<ViewParam name="P15218157858910" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1521815785891_1" attribute="recorduid" variable="rolerecorduid"/>
					<ViewAttribute name="P1521815785891_2" attribute="organisationUid" variable="organisation"/>
					<ViewAttribute name="P1521815785891_3" attribute="name" variable="rolename"/>
				</Action>
				<Action name="U1521816005152" action="executeview" viewname="getrolecontenttickets_md" append="false" attribute="formertickets">
					<ViewParam name="P15218160051520" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1521816005152_1" attribute="recorduid" variable="formertickets"/>
				</Action>
			</Actions>
			<Ticket create="true" createaction="true"/>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<Candidates name="role" role="A1521814997218"/>
			<FormVariable name="in_rolecode1678289403445" action="input" variable="in_rolecode" mandatory="true" longlist="false"/>
			<FormVariable name="A1729690765861" variable="in_permissions" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1729690855991" variable="in_identities" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="153" y="683" w="200" h="98" title="End" compact="true" inexclusive="false"/>
		<Component name="C1582106633395" type="variablechangeactivity" x="27" y="83" w="300" h="98" title="Prepare variables for metadata creation" outexclusive="true">
			<Actions>
				<Action name="U1582108920146" action="executeview" viewname="bwrm_getrolecontentmetadata_fromcode" append="false" attribute="existingrolecontentmetadata">
					<ViewParam name="P15821089201460" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1582108920146_1" attribute="rolecontent_uid" variable="existingrolecontentmetadata"/>
				</Action>
				<Action name="U1582110978324" action="multiadd" structname="S1582109206397" attribute="in_permissions_uid" oldname="in_permissions" duplicates="false" condition="(! dataset.isEmpty(&apos;in_permissions&apos;))"/>
				<Action name="U1582112743371" action="multiadd" structname="S1582112578096" attribute="in_identities_uid" oldname="in_identities" duplicates="false" condition="(! dataset.isEmpty(&apos;in_identities&apos;))"/>
				<Action name="U1582203300924" action="multiadd" structname="S1582112578096" attribute="in_identities_rulename" oldname="in_identitiesrulename" duplicates="false" condition="(! dataset.isEmpty(&apos;in_identitiesrulename&apos;))"/>
			</Actions>
		</Component>
		<Link name="L1582107084477" source="CSTART" target="C1582106633395" priority="2"/>
		<Component name="C1582107092799" type="metadataactivity" x="417" y="187" w="260" h="98" title="Wipe existing metadata children">
			<Metadata action="D" metadatauid="existingrolecontentmetadata"/>
		</Component>
		<Component name="C1582107146697" type="metadataactivity" x="412" y="354" w="271" h="98" title="Create metadata rolecontent permissions">
			<Metadata action="C" schema="bwrm_role_permissions" master="in_permissions_parentmetadata">
				<Data subkey="in_permissions_subkey" boolean="in_permissions_active"/>
				<Permission permission1="in_permissions_uid"/>
			</Metadata>
		</Component>
		<Component name="C1582112759463" type="metadataactivity" x="416" y="531" w="263" h="98" title="Create metadata rolecontent identities">
			<Metadata action="C" master="in_identities_parentmetadata" schema="bwrm_role_identities">
				<Data subkey="in_identities_subkey" boolean="in_identities_rulebased" string1="in_identities_rulename" string3="in_identities_rulecontent" string4="in_identities_ruletitle"/>
				<Identity identity="in_identities_uid"/>
			</Metadata>
		</Component>
		<Link name="L1582118647404" source="C1582106633395" target="C1582107092799" priority="1" expression="(! dataset.isEmpty(&apos;existingrolecontentmetadata&apos;))" labelcustom="true" label="Role content found"/>
		<Component name="C1582118858618" type="routeactivity" x="153" y="296" w="234" h="98" compact="true" title="Route 1" inexclusive="false" outexclusive="true"/>
		<Link name="L1582118869602" source="C1582106633395" target="C1582118858618" priority="2"/>
		<Link name="L1582118875509" source="C1582107092799" target="C1582118858618" priority="1"/>
		<Link name="L1582118895234" source="C1582118858618" target="C1582107146697" priority="1" expression="(! dataset.isEmpty(&apos;in_permissions_uid&apos;))" labelcustom="true" label="Role has permissions"/>
		<Link name="L1582118897549" source="C1729678733777" target="C1582112759463" priority="1" expression="(! dataset.isEmpty(&apos;in_identities_uid&apos;)) || (! dataset.isEmpty(&apos;in_identities_rulename&apos;))" labelcustom="true" label="Role has identities"/>
		<Link name="L1582118932927" source="C1582107146697" target="C1729678733777" priority="1"/>
		<Link name="L1582118936931" source="C1729678733777" target="CEND" priority="2"/>
		<Component name="C1729678733777" type="routeactivity" x="153" y="451" w="300" h="50" compact="true" title="Route 2" outexclusive="true" inexclusive="false"/>
		<Link name="L1729678782615" source="C1582112759463" target="CEND" priority="1"/>
		<Link name="L1729678994390" source="C1582118858618" target="C1729678733777" priority="2"/>
	</Definition>
	<Roles>
		<Role name="A1521814997218" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1521815015899" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1521815616059" variable="in_identities" displayname="identities with the role" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" description="identities with the role" notstoredvariable="false"/>
		<Variable name="A1521815687590" variable="in_rolecode" displayname="role code" editortype="Default" type="String" multivalued="false" visibility="in" description="role code" notstoredvariable="false"/>
		<Variable name="A1521815715088" variable="rolerecorduid" displayname="role recorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521815735507" variable="organisation" displayname="organisation" editortype="Ledger Organisation" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521815798077" variable="rolename" displayname="rolename" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521815857338" variable="TRTYPE" displayname="TRTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLECONTENT" notstoredvariable="false"/>
		<Variable name="A1521815938801" variable="formertickets" displayname="formertickets" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521816054436" variable="in_owner" displayname="owner" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="owner" notstoredvariable="false"/>
		<Variable name="A1521816098790" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521818959746" variable="in_permissions" displayname="permissions in the role" editortype="Ledger Permission" type="String" multivalued="true" visibility="in" description="permissions in the role" notstoredvariable="false"/>
		<Variable name="A1546648277649" variable="PERMTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="permission" notstoredvariable="false"/>
		<Variable name="A1546648294562" variable="IDENTITYTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="identity" notstoredvariable="false"/>
		<Variable name="A1582108401150" variable="rolemetadatauid" displayname="rolemetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582108783362" variable="existingrolecontentmetadata" displayname="existingrolecontentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="S1582109206397" variable="in_permissions_struct" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1582109308159" variable="in_permissions_subkey" displayname="in_permissions_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582109206397" defaultinsertvalue="{dataset.in_rolecode.get()}" notstoredvariable="true"/>
		<Variable name="A1582110148212" variable="in_permissions_parentmetadata" displayname="in_permissions_parentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582109206397" defaultinsertvalue="{dataset.rolemetadatauid.get()}" notstoredvariable="true"/>
		<Variable name="A1582110934501" variable="in_permissions_uid" displayname="in_permissions_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582109206397" notstoredvariable="true"/>
		<Variable name="A1582111283915" variable="in_permissions_active" displayname="in_permissions_active" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1582109206397" defaultinsertvalue="true" notstoredvariable="true"/>
		<Variable name="A1582111563025" variable="in_rolemetadata_uid" displayname="in_rolemetadata_uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="S1582112578096" variable="in_identities_struct" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1582112608456" variable="in_identities_rulebased" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1582112578096" defaultinsertvalue="{!dataset.isEmpty(&apos;in_identitiesrulename&apos;)}" notstoredvariable="true" displayname="in_identities_rulebased"/>
		<Variable name="A1582112638538" variable="in_identities_parentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" defaultinsertvalue="{dataset.rolemetadatauid.get()}" notstoredvariable="true" displayname="in_identities_parentmetadata"/>
		<Variable name="A1582112668199" variable="in_identities_subkey" displayname="in_identities_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" defaultinsertvalue="{dataset.in_rolecode.get()}" notstoredvariable="true"/>
		<Variable name="A1582112711120" variable="in_identities_uid" displayname="in_identities_uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" notstoredvariable="true"/>
		<Variable name="A1582112892073" variable="in_identities_rulename" displayname="in_identities_rulename" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" notstoredvariable="true"/>
		<Variable name="A1582202871805" variable="in_identitiesrulename" displayname="in_identitiesrulename" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1678286490434" variable="in_identitiesrulecontent" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1678286739711" variable="in_identities_rulecontent" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" notstoredvariable="true" defaultinsertvalue="{dataset.in_identitiesrulecontent.get()}"/>
		<Variable name="A1687939372829" variable="in_identitiesruletitle" displayname="in_identitiesruletitle" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1687939458415" variable="in_identities_ruletitle" displayname="in_identities_ruletitle" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1582112578096" defaultinsertvalue="{dataset.in_identitiesruletitle.get()}" notstoredvariable="true"/>
	</Variables>
</Workflow>
