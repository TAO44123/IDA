<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkResetOperation" statictitle="Perform Bulk Reset Operation" scriptfile="/workflow/bw_access360/performBulkResetOperation.javascript" displayname="Perform Bulk Reset Operation for campaign {dataset.campaignId}">
		<Component name="CSTART" type="startactivity" x="279" y="26" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignId"/>
			</Ticket>
			<Candidates name="role" role="A1717079965942"/>
		</Component>
		<Component name="CEND" type="endactivity" x="279" y="494" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1717104921279" priority="1" expression="dataset.delegatedticketreviewrecorduid.length &gt; 0" labelcustom="true" label="Delegated entries found"/>
		<Component name="C1717104921279" type="callactivity" x="153" y="146" w="300" h="98" title="resetDelegationAccessRightReviewTickets" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/resetDelegationAccessRightReviewTickets.workflow">
				<Input name="A1717105032174" variable="ticketrecorduid" content="delegatedticketreviewrecorduid"/>
			</Process>
		</Component>
		<Component name="C1717104935366" type="callactivity" x="153" y="318" w="300" h="98" title="writeAccessRightsReviewTickets" inexclusive="true">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1717105106599" variable="actiondate" content="actiondate"/>
				<Input name="A1717105131200" variable="comment" content="comment"/>
				<Input name="A1717105139625" variable="status" content="status"/>
				<Input name="A1717105146959" variable="ticketreviewrecorduid" content="ticketreviewrecorduid"/>
				<Input name="A1717105152840" variable="updatecomment" content="updatecomment"/>
				<Input name="A1717105159337" variable="updatestatus" content="updatestatus"/>
			</Process>
		</Component>
		<Link name="L1717104949854" source="C1717104921279" target="C1717104935366" priority="1" labelcustom="false"/>
		<Link name="L1717104951216" source="C1717104935366" target="CEND" priority="1"/>
		<Component name="C1717105585854" type="routeactivity" x="605" y="171" w="300" h="50" compact="true" title="Route 1"/>
		<Link name="L1717105590903" source="CSTART" target="C1717105585854" priority="2"/>
		<Link name="L1717105592846" source="C1717105585854" target="C1717104935366" priority="1"/>
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
		<Variable name="A1717104807045" variable="delegatedticketreviewrecorduid" displayname="Delegated ticket review recorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1717079965942" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1717079975272" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
