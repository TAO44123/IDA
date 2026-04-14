<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_updatepermissiontags" statictitle="update permission tags" description="update permission tags" scriptfile="workflow/bw_fragments/empty.javascript" type="builtin-technical-workflow" displayname="update permission tags" technical="true">
		<Component name="CSTART" type="startactivity" x="237" y="18" w="200" h="114" title="Start - bwa_updatepermissiontags" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1608287150800"/>
			<Actions>
				<Action name="U1619455916398" action="multiclean" attribute="tags" emptyvalues="true" duplicates="true"/>
				<Action name="U1608630236771" action="empty" attribute="permissions"/>
				<Action name="U1608630285096" action="multiresize" attribute="tags" attribute1="permissions"/>
				<Action name="U1608630303007" action="multireplace" attribute="permissions" newvalue="{dataset.uid.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="237" y="549" w="200" h="98" title="End - bwa_updatepermissiontags" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="C1608575051484" target="C1608287218219" priority="1" expression="dataset.tags.length&gt;0" labelcustom="true" label="Contains tags"/>
		<Component name="C1608287218219" type="metadataactivity" x="111" y="420" w="300" h="98" title="update tags">
			<Metadata schema="bwa_permissiontags" action="C">
				<Permission permission="permissions" permission1="permissions"/>
				<Data string1="tags" subkey="tags"/>
			</Metadata>
		</Component>
		<Link name="L1608287277105" source="C1608287218219" target="CEND" priority="1"/>
		<Component name="C1608575051484" type="metadataactivity" x="111" y="264" w="300" h="98" title="delete metadatas" outexclusive="true">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Component name="C1608575057008" type="variablechangeactivity" x="111" y="119" w="300" h="98" title="pick metadata uid">
			<Actions>
				<Action name="U1608575257973" action="executeview" viewname="bwf_permissiongetmetadatataguid" append="false" attribute="metadatauid">
					<ViewParam name="P16085752579730" param="uid" paramvalue="{dataset.uid.get()}"/>
					<ViewAttribute name="P1608575257973_1" attribute="uid" variable="metadatauid"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1608575077853" source="C1608575057008" target="C1608575051484" priority="1"/>
		<Link name="L1608628923825" source="CSTART" target="C1608575057008" priority="1"/>
		<Component name="C1608628946389" type="routeactivity" x="528" y="467" w="300" h="50" compact="true" title="Route 1"/>
		<Link name="L1608628951157" source="C1608575051484" target="C1608628946389" priority="2"/>
		<Link name="L1608628952899" source="C1608628946389" target="CEND" priority="1"/>
		<Component name="N1608628958910" type="note" x="451" y="136" w="300" h="50" title="Remove all Tag metadatas and create new ones if needed"/>
	</Definition>
	<Roles>
		<Role name="A1608287150800" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608287161570" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608287183528" variable="tags" displayname="tags" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608287194199" variable="uid" displayname="uid" editortype="Ledger Permission" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608575219271" variable="metadatauid" displayname="metadata uid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608630213295" variable="permissions" displayname="permissions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
