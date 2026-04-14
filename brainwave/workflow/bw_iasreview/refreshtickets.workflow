<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_refreshtickets" statictitle="refresh tickets" scriptfile="/workflow/bw_iasreview/refreshtickets.javascript" displayname="refresh tickets" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="227" y="72" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
			</Ticket>
			<Candidates name="role" role="A1655726104459"/>
		</Component>
		<Component name="CEND" type="endactivity" x="227" y="477" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655726223657" priority="1"/>
		<Component name="C1655726223657" type="callactivity" x="101" y="186" w="300" h="98" title="refreshitmstickets">
			<Process workflowfile="/workflow/bw_iasreview/refreshitmstickets.workflow"/>
		</Component>
		<Link name="L1655726250498" source="C1655726223657" target="C1655727606723" priority="1"/>
		<Component name="C1655727606723" type="callactivity" x="101" y="323" w="300" h="98" title="refreshdisabledaccounts">
			<Process workflowfile="/workflow/bw_iasreview/refreshdisabledaccounts.workflow"/>
		</Component>
		<Link name="L1655727621913" source="C1655727606723" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655726104459" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655726113149" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655726176251" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REMEDIATION_REFRESHTICKETS" notstoredvariable="true"/>
	</Variables>
</Workflow>
