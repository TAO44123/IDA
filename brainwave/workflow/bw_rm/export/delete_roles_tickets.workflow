<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwrm_delete_roles_tickets" statictitle="import roles" scriptfile="workflow/bw_rm/export/import_roles.javascript" displayname="Import roles (main)" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="302" y="24" w="200" h="114" title="Start" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TLOGTYPE"/>
			</Ticket>
			<Init>
				<Actions>
					<Action name="U1583170932840" action="executeview" viewname="bwrm_roletickets" append="false" attribute="allroletickets">
						<ViewAttribute name="P1583170932840_0" attribute="recorduid" variable="allroletickets"/>
					</Action>
					<Action name="U1583171663117" action="executeview" viewname="bwrm_roletickets_actions" append="false" attribute="allticketsactions">
						<ViewAttribute name="P1583171663117_0" attribute="recorduid" variable="allticketsactions"/>
					</Action>
					<Action name="U1583171679964" action="executeview" viewname="bwrm_roletickets_logs" append="false" attribute="allticketslogs">
						<ViewAttribute name="P1583171679964_0" attribute="recorduid" variable="allticketslogs"/>
					</Action>
				</Actions>
			</Init>
			<Candidates name="role" role="A1548411121638"/>
			<Actions>
			</Actions>
			<Validation>
			</Validation>
		</Component>
		<Component name="CEND" type="endactivity" x="302" y="706" w="200" h="98" title="End" compact="true" inexclusive="true">
			<Actions/>
		</Component>
		<Link name="L1583170705518" source="CSTART" target="C1583170939265" priority="1"/>
		<Component name="C1583170939265" type="deleteticketactivity" x="176" y="131" w="300" h="98" title="Delete role tickets v1 (review)">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="allroletickets"/>
		</Component>
		<Component name="C1583170939265_1" type="deleteticketactivity" x="176" y="305" w="300" h="98" title="Delete role tickets v1 (action)">
			<DeleteTicket name="deleteticket" tickettype="TicketAction" ticketrecordnumber="allticketsactions"/>
		</Component>
		<Component name="C1583170939265_2" type="deleteticketactivity" x="176" y="509" w="300" h="98" title="Delete role tickets v1 (log)">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="allticketslogs"/>
		</Component>
		<Link name="L1583171699299" source="C1583170939265_2" target="CEND" priority="1"/>
		<Link name="L1583171700778" source="C1583170939265_1" target="C1583170939265_2" priority="1"/>
		<Link name="L1583171702161" source="C1583170939265" target="C1583170939265_1" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1583170763750" variable="allroletickets" displayname="allroletickets" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1583170792321" variable="TLOGTYPE" displayname="TLOGTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="DELETE_ROLES_TICKETS" notstoredvariable="true"/>
		<Variable name="A1583171616397" variable="allticketsactions" displayname="allticketsactions" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1583171621454" variable="allticketslogs" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true" displayname="allticketslogs"/>
	</Variables>
	<Roles>
		<Role name="A1548411121638" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ADMIN" description="platform admin">
			<Rule name="A1548411195556" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
