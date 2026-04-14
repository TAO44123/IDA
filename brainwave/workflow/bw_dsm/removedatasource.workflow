<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwdsm_removedatasource" statictitle="removedatasource" scriptfile="/workflow/bw_dsm/dsm_workflow.javascript" description="Remove datasource main metadata with all its children">
		<Component name="CSTART" type="startactivity" x="146" y="32" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="false"/>
			<Candidates name="role" role="A1661974419976"/>
			<Actions>
				<Action name="U1661974517012" action="executeview" viewname="bwdsm_getdatasource_def_mduid" append="false" attribute="mduids">
					<ViewParam name="P16619745170120" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1661974517012_1" attribute="uid" variable="mduids"/>
				</Action>
				<Action name="U1661974594810" action="executeview" viewname="bwdsm_list_datasource_allmd" append="true" attribute="mduids">
					<ViewParam name="P16619745948100" param="code" paramvalue="{dataset.code.get()}"/>
					<ViewAttribute name="P1661974594810_1" attribute="uid" variable="mduids"/>
				</Action>
				<Action name="U1662045536981" action="update" attribute="nbmd" newvalue="{dataset.mduids.length}"/>
			</Actions>
			<FormVariable name="A1661974907508" variable="code" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="143" y="315" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1661974327346" priority="1" expression="dataset.nbmd.get() &gt; 0"/>
		<Component name="C1661974327346" type="metadataactivity" x="75" y="144" w="196" h="98" title="delete all md">
			<Metadata action="D" metadatauid="mduids"/>
		</Component>
		<Link name="L1661974336747" source="C1661974327346" target="CEND" priority="1"/>
		<Component name="C1661974666458" type="routeactivity" x="488" y="185" w="300" h="50" compact="true" title="Route 1"/>
		<Link name="L1661974672027" source="CSTART" target="C1661974666458" priority="2" expression="dataset.nbmd.get() == 0" labelcustom="true" label="liste vide"/>
		<Link name="L1661974680143" source="C1661974666458" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1661974382900" variable="code" displayname="code" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1661974396737" variable="mduids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662045099548" variable="nbmd" editortype="Default" type="Number" multivalued="false" visibility="out" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1661974419976" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1661974431641" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
