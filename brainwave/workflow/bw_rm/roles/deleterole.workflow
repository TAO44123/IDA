<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwpm_deleterole" statictitle="delete role" description="delete role" scriptfile="/workflow/bw_rm/roles/rm_workflows.javascript" displayname="delete role {dataset.in_rolecode}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="177" y="14" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
			</Ticket>
			<Output name="output" ticketlogrecorduidvariable="ticketaction"/>
			<Candidates name="role" role="A1521810643330"/>
			<Actions>
				<Action name="U1521811373699" action="executeview" viewname="bwpm_roledetails_md" append="false" attribute="rolerecorduid">
					<ViewParam name="P15218113736990" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1521811373699_1" attribute="recorduid" variable="rolerecorduid"/>
				</Action>
				<Action name="U1521819094577" action="executeview" viewname="getrolecontenttickets_md" append="false" attribute="ticketrecorduids">
					<ViewParam name="P15218190945770" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1521819094577_1" attribute="recorduid" variable="ticketrecorduids"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="619" y="132" w="200" h="98" title="End" compact="true"/>
		<Component name="C1582125696066" type="variablechangeactivity" x="51" y="107" w="300" h="98" title="Search main role" outexclusive="true">
			<Actions function="resolveRoleMetadataUID">
			</Actions>
		</Component>
		<Link name="L1582125710606" source="CSTART" target="C1582125696066" priority="2"/>
		<Component name="C1582126033028" type="metadataactivity" x="51" y="385" w="300" h="98" title="Delete children metadata items">
			<Metadata action="D" metadatauid="existingrolecontentmetadata"/>
		</Component>
		<Component name="C1582126207581" type="metadataactivity" x="493" y="240" w="300" h="98" title="Delete main role metadata">
			<Metadata action="D" metadatauid="rolemetadatauid"/>
		</Component>
		<Link name="L1582126915157" source="C1582125696066" target="CEND" priority="1" expression="(dataset.isEmpty(&apos;rolemetadatauid&apos;))" labelcustom="true" label="No role found"/>
		<Component name="C1582125696066_1" type="variablechangeactivity" x="51" y="240" w="300" h="98" title="Search children" outexclusive="true">
			<Actions>
				<Action name="U1582126025401" action="executeview" viewname="bwrm_getrolecontentmetadata_fromcode" append="false" attribute="existingrolecontentmetadata">
					<ViewParam name="P15821260254010" param="rolecode" paramvalue="{dataset.in_rolecode.get()}"/>
					<ViewAttribute name="P1582126025401_1" attribute="rolecontent_uid" variable="existingrolecontentmetadata"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1582127104109" source="C1582125696066" target="C1582125696066_1" priority="2"/>
		<Link name="L1582127137177" source="C1582125696066_1" target="C1582126207581" priority="1" expression="(dataset.isEmpty(&apos;existingrolecontentmetadata&apos;))" labelcustom="true" label="No children found"/>
		<Link name="L1582127170713" source="C1582125696066_1" target="C1582126033028" priority="2"/>
		<Link name="L1582127187290" source="C1582126207581" target="CEND" priority="1"/>
		<Link name="L1582127188762" source="C1582126033028" target="C1582126207581" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1521810347092" variable="in_rolecode" displayname="role code" editortype="Default" type="String" multivalued="false" visibility="in" description="role code" notstoredvariable="false"/>
		<Variable name="A1521810455010" variable="TICKETLOG" displayname="ticket log" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ROLEMANAGEMENT" notstoredvariable="false"/>
		<Variable name="A1521811332158" variable="rolerecorduid" displayname="rolerecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1521819049586" variable="ticketrecorduids" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1582125964344" variable="existingrolecontentmetadata" displayname="existingrolecontentmetadata" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1582126140083" variable="in_rolemetadata_uid" displayname="in_rolemetadata_uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1582126251744" variable="rolemetadatauid" displayname="rolemetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1521810643330" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1521810653582" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
