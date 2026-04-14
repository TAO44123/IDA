<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="delete_md_recurse" statictitle="delete md recurse" scriptfile="/workflow/bw_cloud_base/delete_md_recurse.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="150" y="66" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1619510698374" action="executeview" viewname="br_md_children" append="true" attribute="to_delete_md_uids">
					<ViewParam name="P16195106983740" param="uids" paramvalue="{dataset.md_uids}"/>
					<ViewAttribute name="P1619510698374_1" attribute="childmd_uid" variable="to_delete_md_uids"/>
				</Action>
				<Action name="U1619510749526" action="multiadd" attribute="to_delete_md_uids" oldname="md_uids" duplicates="false"/>
			</Actions>
			<Candidates name="role" role="A1619510766818"/>
			<FormVariable name="A1619510834428" variable="md_uids" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="139" y="323" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1619523963666" priority="1"/>
		<Component name="N1619523733368" type="note" x="316" y="52" w="300" h="62" title="Pour l&apos;instant, ne gère pas descente récursive , donc juste les enfants directs"/>
		<Component name="C1619523963666" type="metadataactivity" x="67" y="169" w="208" h="98" title="suppr md and child">
			<Metadata action="D" metadatauid="to_delete_md_uids" outmetadatauid="_deleted_md_uids"/>
		</Component>
		<Link name="L1619523994788" source="C1619523963666" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1619510277048" variable="md_uids" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1619510303771" variable="to_delete_md_uids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1619524049563" variable="_deleted_md_uids" editortype="Default" type="String" multivalued="true" visibility="out" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1619510766818" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1619510806571" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
