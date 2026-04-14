<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_reassignAccessRightsReviewTickets" statictitle="reassign Access Rights Review Tickets" scriptfile="workflow/bw_access360/reassignAccessRightsReviewTickets.javascript" technical="true" type="builtin-technical-workflow" displayname="reassign Access Rights Review Tickets">
		<Component name="CSTART" type="startactivity" x="349" y="75" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1627314959775"/>
			<Actions>
				<Action name="U1627315044440" action="multiresize" attribute="ticketreviewrecorduids" attribute1="reviewers"/>
				<Action name="U1627315060221" action="multireplace" attribute="reviewers" newvalue="{dataset.reviewer.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="349" y="458" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1627315065725" priority="1" expression="!dataset.updateAccountable.get()" labelcustom="true" label="responsible only"/>
		<Component name="C1627315065725" type="updateticketreviewactivity" x="33" y="226" w="300" h="98" title="update responsible">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduids" ticketactors="reviewers"/>
		</Component>
		<Link name="L1627315092953" source="C1627315065725" target="CEND" priority="1"/>
		<Component name="C1627315065725_1" type="updateticketreviewactivity" x="429" y="226" w="300" h="98" title="update responsible&amp;accountable">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduids" ticketactors="reviewers" ticketaccountables="reviewers"/>
		</Component>
		<Link name="L1698655350950" source="CSTART" target="C1627315065725_1" priority="2" labelcustom="true" label="all"/>
		<Link name="L1698655351904" source="C1627315065725_1" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1627314959775" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1627314968488" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1627314992812" variable="reviewer" displayname="reviewer" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627315012083" variable="ticketreviewrecorduids" displayname="ticketreviewrecorduids" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627315023151" variable="reviewers" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698655329064" variable="updateAccountable" displayname="updateAccountable" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="True to update as well accountable. By default, only the responsible is updated." initialvalue="false" notstoredvariable="true"/>
	</Variables>
</Workflow>
