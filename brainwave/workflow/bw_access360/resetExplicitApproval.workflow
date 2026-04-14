<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_resetExplicitApproval" statictitle="resetExplicitApproval" scriptfile="/workflow/bw_access360/resetExplicitApproval.javascript">
		<Component name="CSTART" type="startactivity" x="271" y="48" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1698070584111"/>
			<Actions>
				<Action name="U1698070696642" action="multiresize" attribute="ticketsrecorduid" attribute1="alldate" attribute2="allreviewer" attribute3="allstatus"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="271" y="332" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1698070744710" priority="1"/>
		<Component name="C1698070744710" type="updateticketreviewactivity" x="145" y="158" w="300" h="98" title="reset explicit approval">
			<UpdateTicketReview ticketreviewnumbervariable="ticketsrecorduid">
				<Attribute name="custom5" attribute="allstatus"/>
				<Attribute name="custom6" attribute="allreviewer"/>
				<Attribute name="custom7" attribute="alldate"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1698070797591" source="C1698070744710" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1698070584111" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1698070595214" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1698070609285" variable="ticketsrecorduid" displayname="ticketsrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698070634873" variable="allstatus" displayname="allstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698070644906" variable="alldate" displayname="alldate" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698070662190" variable="allreviewer" displayname="allreviewer" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
