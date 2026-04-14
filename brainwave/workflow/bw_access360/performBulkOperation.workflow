<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkOperation" statictitle="Perform Bulk Operation" scriptfile="/workflow/bw_access360/performBulkOperation.javascript" displayname="Perform Bulk Operation for campaign {dataset.campaignId}">
		<Component name="CSTART" type="startactivity" x="317" y="17" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignId"/>
			</Ticket>
			<Candidates name="role" role="A1717079965942"/>
		</Component>
		<Component name="CEND" type="endactivity" x="317" y="487" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1717077522191" priority="1"/>
		<Component name="C1717077522191" type="callactivity" x="191" y="133" w="300" h="98" title="writeAccessRightsReviewTickets">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1717077627180" variable="actiondate" content="actiondate"/>
				<Input name="A1717077637664" variable="comment" content="comment"/>
				<Input name="A1717077664547" variable="status" content="status"/>
				<Input name="A1717077669143" variable="ticketreviewrecorduid" content="ticketreviewrecorduid"/>
				<Input name="A1717077674748" variable="updatecomment" content="updatecomment"/>
				<Input name="A1717077681701" variable="updatestatus" content="updatestatus"/>
			</Process>
		</Component>
		<Component name="C1717077739825" type="callactivity" x="191" y="298" w="300" h="98" title="reassignAccessRightsReviewTickets">
			<Process workflowfile="/workflow/bw_access360/reassignAccessRightsReviewTickets.workflow">
				<Input name="A1717077768913" variable="reviewer" content="reviewer"/>
				<Input name="A1717077773137" variable="ticketreviewrecorduids" content="ticketreviewrecorduid"/>
				<Input name="A1717077778012" variable="updateAccountable" content="updateAccountable"/>
			</Process>
		</Component>
		<Link name="L1717077758000" source="C1717077522191" target="C1717077739825" priority="1"/>
		<Link name="L1717077759327" source="C1717077739825" target="CEND" priority="1"/>
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
		<Variable name="A1717077462079" variable="reviewer" displayname="Reviewer" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1717077500698" variable="updateAccountable" displayname="Update accountable" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1717079965942" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1717079975272" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
