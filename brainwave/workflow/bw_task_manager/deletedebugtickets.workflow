<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_deletedebugtickets" displayname="delete debug tickets" description="delete debug tickets" scriptfile="/workflow/bw_task_manager/deletedebugtickets.javascript" statictitle="delete debug tickets" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="40" y="93" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="TICKETTITLE"/>
			</Ticket>
			<Actions>
				<Action name="U1475596810136" action="executeview" viewname="bw_grabdebugticketlogs" append="false" attribute="ticketlogs">
					<ViewAttribute name="P1475596810136_0" attribute="recorduid" variable="ticketlogs"/>
				</Action>
				<Action name="U1475596829639" action="executeview" viewname="bw_grabdebugticketactions" append="false" attribute="ticketactions">
					<ViewAttribute name="P1475596829639_0" attribute="recorduid" variable="ticketactions"/>
				</Action>
				<Action name="U1475596855493" action="executeview" viewname="bw_grabdebugticketreviews" append="false" attribute="ticketreviews">
					<ViewAttribute name="P1475596855493_0" attribute="recorduid" variable="ticketreviews"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1475596529259"/>
		</Component>
		<Component name="CEND" type="endactivity" x="1034" y="93" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1475596723631" priority="1"/>
		<Component name="C1475596723631" type="deleteticketactivity" x="163" y="68" w="200" h="98" title="review">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="ticketreviews"/>
		</Component>
		<Component name="C1475596725486" type="deleteticketactivity" x="439" y="68" w="200" h="98" title="action">
			<DeleteTicket name="deleteticket" tickettype="TicketAction" ticketrecordnumber="ticketactions"/>
		</Component>
		<Component name="C1475596727087" type="deleteticketactivity" x="731" y="68" w="200" h="98" title="log">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="ticketlogs"/>
		</Component>
		<Link name="L1475596743479" source="C1475596723631" target="C1475596725486" priority="1"/>
		<Link name="L1475596744010" source="C1475596725486" target="C1475596727087" priority="1"/>
		<Link name="L1475596745783" source="C1475596727087" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1475596529259" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="anyone" description="anyone">
			<Rule name="A1475596549590" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1475596580782" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="PURGELOG-PURGE-DEBUG" notstoredvariable="false"/>
		<Variable name="A1475596591475" variable="TICKETTITLE" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" displayname="Purge all tickets in debug mode"/>
		<Variable name="A1475596602439" variable="ticketlogs" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1475596611209" variable="ticketactions" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1475596619716" variable="ticketreviews" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
	</Variables>
</Workflow>
