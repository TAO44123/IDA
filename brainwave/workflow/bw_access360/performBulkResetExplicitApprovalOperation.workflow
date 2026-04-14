<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkResetExplicitApprovalOperation" statictitle="Perform Bulk Reset Explicit Approval Operation" scriptfile="/workflow/bw_access360/performBulkResetExplicitApprovalOperation.javascript" displayname="Perform Bulk Reset Explicit Approval Operation for campaign {dataset.campaignId}">
		<Component name="CSTART" type="startactivity" x="366" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignId"/>
			</Ticket>
			<Candidates name="role" role="A1717079965942"/>
		</Component>
		<Component name="CEND" type="endactivity" x="366" y="468" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1717110230219" priority="1"/>
		<Component name="C1717110230219" type="callactivity" x="240" y="145" w="300" h="98" title="resetExplicitApproval">
			<Process workflowfile="/workflow/bw_access360/resetExplicitApproval.workflow">
				<Input name="A1717110343466" variable="ticketsrecorduid" content="ticketreviewrecorduid"/>
			</Process>
		</Component>
		<Component name="C1717110259053" type="callactivity" x="240" y="297" w="300" h="98" title="writeAccessRightsReviewTickets">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1717110376889" variable="actiondate" content="actiondate"/>
				<Input name="A1717110388961" variable="comment" content="comment"/>
				<Input name="A1717110396298" variable="status" content="status"/>
				<Input name="A1717110402248" variable="ticketreviewrecorduid" content="ticketreviewrecorduid"/>
				<Input name="A1717110407875" variable="updatecomment" content="updatecomment"/>
				<Input name="A1717110413823" variable="updatestatus" content="updatestatus"/>
			</Process>
		</Component>
		<Link name="L1717110275939" source="C1717110230219" target="C1717110259053" priority="1"/>
		<Link name="L1717110277485" source="C1717110259053" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1717076717318" variable="TICKETTYPE" displayname="Ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REVIEW" notstoredvariable="true"/>
		<Variable name="A1717076958407" variable="actiondate" displayname="Action date" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717076974196" variable="campaignId" displayname="Campaign identifier" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717076995162" variable="comment" displayname="Review comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717077347103" variable="status" displayname="Review status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717077371978" variable="ticketreviewrecorduid" displayname="Ticket review recorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717077395272" variable="updatecomment" displayname="Update comment" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717077417209" variable="updatestatus" displayname="Update status" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1717079965942" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1717079975272" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
