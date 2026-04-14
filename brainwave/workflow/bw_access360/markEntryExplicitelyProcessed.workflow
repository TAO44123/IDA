<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_markEntryExplicitelyProcessed" statictitle="markEntryExplicitelyProcessed" scriptfile="/workflow/bw_access360/markEntryExplicitelyProcessed.javascript" displayname="markEntryExplicitelyProcessed">
		<Component name="CSTART" type="startactivity" x="177" y="46" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1698076781173"/>
			<Actions>
				<Action name="U1698076826326" action="multiresize" attribute="reviewrecorduids" attribute1="allstatus"/>
				<Action name="U1698076841834" action="multireplace" attribute="allstatus" newvalue="{dataset.processedstatus.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="177" y="330" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1698076849984" priority="1"/>
		<Component name="C1698076849984" type="updateticketreviewactivity" x="51" y="163" w="300" h="98" title="mark as processed">
			<UpdateTicketReview ticketreviewnumbervariable="reviewrecorduids">
				<Attribute name="custom5" attribute="allstatus"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1698076869852" source="C1698076849984" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1698076761035" variable="reviewrecorduids" displayname="reviewrecorduids" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698076777169" variable="processedstatus" displayname="processedstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="2" notstoredvariable="true"/>
		<Variable name="A1698076806919" variable="allstatus" displayname="allstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1698076781173" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1698076794224" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
