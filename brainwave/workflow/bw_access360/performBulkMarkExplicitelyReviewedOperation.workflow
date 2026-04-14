<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_performBulkMarkExplicitelyReviewedOperation" statictitle="Perform Bulk Mark Explicitely Reviewed Operation" scriptfile="/workflow/bw_access360/performBulkMarkExplicitelyReviewedOperation.javascript">
		<Component name="CSTART" type="startactivity" x="411" y="39" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignid"/>
			</Ticket>
			<Candidates name="role" role="A1717106858278"/>
		</Component>
		<Component name="CEND" type="endactivity" x="411" y="321" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1717106946636" priority="1"/>
		<Component name="C1717106946636" type="callactivity" x="285" y="156" w="300" h="98" title="markEntryExplicitelyReviewed">
			<Process workflowfile="/workflow/bw_access360/markEntryExplicitelyReviewed.workflow">
				<Input name="A1717107027041" variable="campaignid" content="campaignid"/>
				<Input name="A1717107032595" variable="currentreviewer" content="currentreviewer"/>
				<Input name="A1717107037465" variable="forcemarkentry" content="forcemarkentry"/>
				<Input name="A1717107044289" variable="reviewtickets" content="reviewtickets"/>
			</Process>
		</Component>
		<Link name="L1717106999655" source="C1717106946636" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1698050220740" variable="campaignid" displayname="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" description="campaign id" notstoredvariable="true"/>
		<Variable name="A1698051549507" variable="currentreviewer" displayname="currentreviewer" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="current reviewer (will only consider entries where the reviewer is accountable for)&#xA;defaults to the process owner" notstoredvariable="true"/>
		<Variable name="A1698221894788" variable="reviewtickets" displayname="reviewtickets" editortype="Default" type="Number" multivalued="true" visibility="in" description="OPTIONAL review tickets to explicitely mark" notstoredvariable="true"/>
		<Variable name="A1698402835298" variable="forcemarkentry" displayname="forcemarkentry" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Default behavior is to only mark entries where the current reviewer is accountable for, unless this value is set to True" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1717106912226" variable="TICKETTYPE" displayname="Ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REVIEW" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1717106858278" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1717106868129" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
