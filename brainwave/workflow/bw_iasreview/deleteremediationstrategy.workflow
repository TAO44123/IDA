<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_deleteremediationstrategy" statictitle="deleteremediationstrategy" scriptfile="/workflow/bw_iasreview/deleteremediationstrategy.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="259" y="84" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655128135518"/>
			<Actions>
				<Action name="U1655135564154" action="multiclean" attribute="metadatauid" emptyvalues="true" duplicates="true"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="259" y="449" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655128180358" priority="1"/>
		<Component name="C1655128180358" type="metadataactivity" x="133" y="233" w="300" h="98" title="delete metadata">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1655128206075" source="C1655128180358" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655128135518" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655128143642" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655128163289" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
