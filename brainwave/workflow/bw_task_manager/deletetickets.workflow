<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_deletetickets" displayname="Purge ticket" description="delete tickets" scriptfile="/workflow/bw_task_manager/deletetickets.javascript" technical="true" statictitle="Purge ticket" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="46" y="89" w="200" h="114" title="Start" compact="true">
			<Actions>
				<Action name="U1475595489905" action="executeview" viewname="bw_getticketlog" append="false" attribute="tickettitle">
					<ViewParam name="P14755954899050" param="recorduid" paramvalue="{dataset.ticketlog.get()}"/>
					<ViewAttribute name="P1475595489905_1" attribute="title" variable="tickettitle"/>
					<ViewAttribute name="P1475595489905_2" attribute="ticketnumber" variable="ticketnumber"/>
				</Action>
				<Action name="U1475595553446" action="update" attribute="TICKETTITLE" newvalue="Purge ticket {dataset.ticketnumber.get()}: &quot;{dataset.tickettitle.get()}&quot;"/>
				<Action name="U1475594818364" action="executeview" viewname="bw_grabticketslogs" append="false" attribute="ticketlogs">
					<ViewParam name="P14755948183640" param="ticketlog" paramvalue="{dataset.ticketlog.get()}"/>
					<ViewAttribute name="P1475594818364_1" attribute="recorduid" variable="ticketlogs"/>
				</Action>
				<Action name="U1475594833329" action="multiadd" attribute="ticketlogs" oldname="ticketlog" duplicates="false"/>
				<Action name="U1475594939037" action="executeview" viewname="bw_grabticketactions" append="false" attribute="ticketactions">
					<ViewParam name="P14755949390370" param="ticketlogs" paramvalue="{dataset.ticketlogs.get()}"/>
					<ViewAttribute name="P1475594939037_1" attribute="recorduid" variable="ticketactions"/>
				</Action>
				<Action name="U1475595044472" action="executeview" viewname="grabticketreviews" append="false" attribute="ticketreviews">
					<ViewParam name="P14755950444720" param="ticketactions" paramvalue="{dataset.ticketactions.get()}"/>
					<ViewAttribute name="P1475595044472_1" attribute="recorduid" variable="ticketreviews"/>
				</Action>
				<Action name="U1475595364179" action="executeview" viewname="bw_grabticketremediations" append="false" attribute="ticketremediations">
					<ViewParam name="P14755953641790" param="ticketreviews" paramvalue="{dataset.ticketreviews.get()}"/>
					<ViewAttribute name="P1475595364179_1" attribute="recorduid" variable="ticketremediations"/>
				</Action>
			</Actions>
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="TICKETTITLE"/>
			</Ticket>
			<Candidates name="role" role="A1475596077188"/>
			<FormVariable name="A1475596107134" variable="ticketlog" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="1161" y="89" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1475595618456" priority="1"/>
		<Component name="C1475595618456" type="deleteticketactivity" x="137" y="64" w="200" h="98" title="remediation">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="ticketremediations"/>
		</Component>
		<Component name="C1475595621004" type="deleteticketactivity" x="414" y="64" w="200" h="98" title="review">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="ticketreviews"/>
		</Component>
		<Component name="C1475595623162" type="deleteticketactivity" x="691" y="64" w="200" h="98" title="action">
			<DeleteTicket name="deleteticket" tickettype="TicketAction" ticketrecordnumber="ticketactions"/>
		</Component>
		<Component name="C1475595624972" type="deleteticketactivity" x="932" y="64" w="200" h="98" title="log">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="ticketlogs"/>
		</Component>
		<Link name="L1475595647236" source="C1475595618456" target="C1475595621004" priority="1"/>
		<Link name="L1475595647913" source="C1475595621004" target="C1475595623162" priority="1"/>
		<Link name="L1475595648562" source="C1475595623162" target="C1475595624972" priority="1"/>
		<Link name="L1475595649292" source="C1475595624972" target="CEND" priority="1"/>
		<Component name="N1475595702639" type="note" x="133" y="173" w="200" h="50" title="delete a ticketlog and all its subtickets"/>
	</Definition>
	<Variables>
		<Variable name="A1475594622701" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" description="ticketlog recorduid" notstoredvariable="false"/>
		<Variable name="A1475594635601" variable="ticketlogs" displayname="ticketlogs" editortype="Default" type="Number" multivalued="true" visibility="local" description="ticketlogs to remove&#xA;" notstoredvariable="false"/>
		<Variable name="A1475594650207" variable="ticketreviews" displayname="ticketreviews" editortype="Default" type="Number" multivalued="true" visibility="local" description="ticketreviews to remove" notstoredvariable="false"/>
		<Variable name="A1475594660886" variable="ticketactions" displayname="ticketactions" editortype="Default" type="Number" multivalued="true" visibility="local" description="ticketactions to remove" notstoredvariable="false"/>
		<Variable name="A1475594687739" variable="ticketremediations" displayname="ticketremediations" editortype="Default" type="Number" multivalued="true" visibility="local" description="ticketremediations to remove" notstoredvariable="false"/>
		<Variable name="A1475595410004" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="TICKETLOG-PURGE" notstoredvariable="false"/>
		<Variable name="A1475595432507" variable="tickettitle" displayname="tickettitle" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1475595441536" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1475595512917" variable="TICKETTITLE" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1475596077188" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="anyone" description="anyone">
			<Rule name="A1475596090118" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
