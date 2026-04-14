<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_resetDelegationAccessRightReviewTickets" statictitle="resetDelegationAccessRightReviewTickets" scriptfile="/workflow/bw_access360/resetDelegationAccessRightReviewTickets.javascript" displayname="resetDelegationAccessRightReviewTickets" technical="true" releaseontimeout="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="367" y="44" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1630326862178" action="executeview" viewname="bwaccess360_getreviewticketaccountables" append="false" attribute="accountableuid">
					<ViewParam name="P16303268621780" param="recorduid" paramvalue="{dataset.ticketrecorduid}"/>
					<ViewAttribute name="P1630326862178_1" attribute="accountableuid" variable="accountableuid"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1630326503684"/>
		</Component>
		<Component name="CEND" type="endactivity" x="367" y="346" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1630326869192" priority="1"/>
		<Component name="C1630326869192" type="updateticketreviewactivity" x="241" y="185" w="300" h="98" title="reset responsible (set responsible = accountable)">
			<UpdateTicketReview ticketreviewnumbervariable="ticketrecorduid" ticketactors="accountableuid"/>
		</Component>
		<Link name="L1630326883172" source="C1630326869192" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1630326488674" variable="ticketrecorduid" displayname="ticketrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1630326539370" variable="accountableuid" displayname="accountableuid" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1630326503684" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1630326523376" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
