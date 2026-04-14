<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_deleteall_reviewdefinstancemd" statictitle="deleteall reviewdefinstancemd" scriptfile="/workflow/bw_iasreview2/utils/deleteall_reviewdefinstancemd.javascript" technical="true">
		<Component name="CSTART" type="startactivity" x="212" y="38" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1704642267763"/>
			<Actions>
				<Action name="U1704642364207" action="executeview" viewname="listallreviewmd" append="false" attribute="allmduids">
					<ViewAttribute name="P1704642364207_0" attribute="uid" variable="allmduids"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="212" y="319" w="200" h="98" title="End" compact="true"/>
		<Component name="C1704902915300" type="metadataactivity" x="114" y="158" w="243" h="98" title="delete all MDs">
			<Metadata action="D" metadatauid="allmduids"/>
		</Component>
		<Link name="L1704902948982" source="CSTART" target="C1704902915300" priority="1"/>
		<Link name="L1704902952012" source="C1704902915300" target="CEND" priority="1"/>
		<Component name="N1717755441461" type="note" x="370" y="43" w="300" h="50" title="DEBUG workflow (for removing unwanted MD)"/>
	</Definition>
	<Variables>
		<Variable name="A1704642253477" variable="allmduids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1704642267763" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1704642290642" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
