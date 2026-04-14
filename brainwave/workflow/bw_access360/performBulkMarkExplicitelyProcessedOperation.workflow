<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkMarkExplicitelyProcessedOperation" statictitle="Perform Bulk Mark Explicitely Processed Operation" scriptfile="/workflow/bw_access360/performBulkMarkExplicitelyProcessedOperation.javascript" displayname="Perform Bulk Mark Explicitely Processed Operation for campaign {dataset.campaignid}">
		<Component name="CSTART" type="startactivity" x="375" y="38" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignid"/>
			</Ticket>
			<Candidates name="role" role="A1698076781173"/>
		</Component>
		<Component name="CEND" type="endactivity" x="375" y="512" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1717146560717" priority="1"/>
		<Component name="C1717146560717" type="callactivity" x="249" y="160" w="300" h="98" title="createRemediationTickets">
			<Process workflowfile="/workflow/bw_access360/createRemediationTickets.workflow">
				<Input name="A1717146654916" variable="accountableuid" content="accountableuid"/>
				<Input name="A1717146659232" variable="actiondate" content="actiondate"/>
				<Input name="A1717146663291" variable="campaignid" content="campaignid"/>
				<Input name="A1717146667471" variable="comment" content="comment"/>
				<Input name="A1717146673284" variable="status" content="status"/>
				<Input name="A1717146678908" variable="ticketclosed" content="ticketclosed"/>
				<Input name="A1717146684116" variable="ticketlabel" content="ticketlabel"/>
				<Input name="A1717146689765" variable="ticketreviewrecorduid" content="ticketreviewrecorduid"/>
				<Input name="A1717146695086" variable="tickettype" content="tickettype"/>
			</Process>
		</Component>
		<Component name="C1717146596159" type="callactivity" x="249" y="335" w="300" h="98" title="markEntryExplicitelyProcessed">
			<Process workflowfile="/workflow/bw_access360/markEntryExplicitelyProcessed.workflow">
				<Input name="A1717146720685" variable="reviewrecorduids" content="reviewrecorduids"/>
			</Process>
		</Component>
		<Link name="L1717146620004" source="C1717146560717" target="C1717146596159" priority="1"/>
		<Link name="L1717146621368" source="C1717146596159" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1698076761035" variable="reviewrecorduids" displayname="reviewrecorduids" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043876059" variable="status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043884314" variable="comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043893235" variable="actiondate" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043934531" variable="ticketreviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627044311491" variable="accountableuid" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627044391598" variable="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627461049009" variable="ticketclosed" displayname="ticket is closed" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="0 - no&#xA;1 - yes, done&#xA;2 - yes, cancel"/>
		<Variable name="A1627461063036" variable="ticketlabel" displayname="ticket label" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627461212330" variable="tickettype" displayname="ticket type" editortype="Default" type="String" multivalued="true" visibility="in" description="manual&#xA;itsm:[instanceid]&#xA;..." notstoredvariable="true"/>
		<Variable name="A1717147354939" variable="TICKETTYPE" displayname="Ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REVIEW" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1698076781173" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1698076794224" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
