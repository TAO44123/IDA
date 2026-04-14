<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_escalateAccessRightsReviewTickets" statictitle="escalate Access Rights Review Tickets" scriptfile="/workflow/bw_access360/escalateAccessRightsReviewTickets.javascript" displayname="escalate Access Rights Review Tickets" technical="true" type="builtin-technical-workflow">
		<Component name="CEND" type="endactivity" x="159" y="458" w="200" h="98" title="End" compact="true"/>
		<Component name="C1627315065725" type="updateticketreviewactivity" x="33" y="226" w="300" h="98" title="escalate">
			<UpdateTicketReview ticketreviewnumbervariable="ticketstoupdate" ticketactors="newresponsible"/>
		</Component>
		<Link name="L1627315092953" source="C1627315065725" target="CEND" priority="1"/>
		<Component name="CSTART" type="startactivity" x="159" y="75" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1627314959775"/>
			<Actions>
				<Action name="U1679934457716" action="executeview" viewname="bwiasr_computeescalatedreviewer" append="false" attribute="newresponsible">
					<ViewParam name="P16799344577160" param="recorduids" paramvalue="{dataset.ticketreviewrecorduids}"/>
					<ViewAttribute name="P1679934457716_1" attribute="manageruid" variable="newresponsible"/>
					<ViewAttribute name="P1679934457716_2" attribute="recorduid" variable="ticketstoupdate"/>
				</Action>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1627315065725" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1627314959775" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1627314968488" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1627315012083" variable="ticketreviewrecorduids" displayname="ticketreviewrecorduids" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1679934364154" variable="ticketstoupdate" displayname="ticketstoupdate" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1679934378979" variable="newresponsible" displayname="newresponsible" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
