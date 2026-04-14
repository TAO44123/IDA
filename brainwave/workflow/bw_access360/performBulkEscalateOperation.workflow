<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkEscalateOperation" statictitle="Perform Bulk Escalate Operation" scriptfile="/workflow/bw_access360/performBulkEscalateOperation.javascript" displayname="Perform Bulk Escalate Operation for {dataset.campaignId}">
		<Component name="CSTART" type="startactivity" x="204" y="40" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignId"/>
			</Ticket>
			<Candidates name="role" role="A1717103499787"/>
		</Component>
		<Component name="CEND" type="endactivity" x="204" y="347" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1717103023810" priority="1"/>
		<Component name="C1717103023810" type="callactivity" x="78" y="170" w="300" h="98" title="escalateAccessRightsReviewTickets">
			<Process workflowfile="/workflow/bw_access360/escalateAccessRightsReviewTickets.workflow">
				<Input name="A1717103203527" variable="ticketreviewrecorduids" content="ticketreviewrecorduids"/>
			</Process>
		</Component>
		<Link name="L1717103043430" source="C1717103023810" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1717103058497" variable="campaignId" displayname="Campaign identifier" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717103072474" variable="TICKETTYPE" displayname="Ticket type" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="REVIEW"/>
		<Variable name="A1717103177573" variable="ticketreviewrecorduids" displayname="Ticket review record uids" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1717103499787" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1717103509837" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
