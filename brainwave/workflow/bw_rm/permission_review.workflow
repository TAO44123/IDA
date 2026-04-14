<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="rm_permission_review" statictitle="review permission" scriptfile="/workflow/bw_rm/permission_review.javascript" displayname="review permission {dataset.in_permissionuid}" technical="false" publish="false">
		<Component name="CSTART" type="startactivity" x="343" y="28" w="200" h="114" title="Start" compact="true" inexclusive="true" outexclusive="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TTYPE"/>
			</Ticket>
			<Init>
				<Actions>
				</Actions>
			</Init>
			<Candidates name="role" role="A1546463903800"/>
			<Output name="output" ticketactionnumbervariable="ticketaction" ticketnumbervariable="ticketlog" startdatevariable="action_date" startdisplaynamevariable="action_actor_fullname"/>
			<FormVariable name="A1546465851243" variable="in_action" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1546465866878" variable="in_permissionuid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1546465859667" variable="in_comment" action="input" mandatory="false" longlist="false"/>
			<Page name="rm_permission_review_start" template="/library/pagetemplates/workflow/startProcess.pagetemplate"/>
			<Actions>
				<Action name="U1546528360355" action="multiadd" attribute="tr_to_delete" oldname="in_tr_toreplace" duplicates="false"/>
			</Actions>
			<FormVariable name="A1546533721831" variable="in_tr_toreplace" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="151" y="546" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1546527628298" priority="2" expression="(dataset.isEmpty(&apos;tr_to_delete&apos;))"/>
		<Component name="C1546463477424" type="ticketreviewactivity" x="74" y="406" w="199" h="98" title="create new ticket">
			<TicketReview ticketaction="ticketaction" expression="(!dataset.equals(&apos;in_action&apos;, &apos;delete&apos;, true, true))">
				<Permission permissionvariable="in_permissionuid"/>
				<Attribute name="status" attribute="TTYPE"/>
				<Attribute name="comment" attribute="in_comment"/>
				<Attribute name="custom1" attribute="action_actor_fullname"/>
				<Attribute name="custom2" attribute="action_date"/>
			</TicketReview>
		</Component>
		<Component name="C1546463496934" type="deleteticketactivity" x="246" y="259" w="191" h="98" title="delete tickets" outexclusive="true">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="tr_to_delete"/>
		</Component>
		<Link name="L1546463506918" source="C1546463496934" target="C1546463477424" priority="2"/>
		<Link name="L1546463508877" source="C1546463477424" target="CEND" priority="1"/>
		<Component name="N1546509362496" type="note" x="643" y="27" w="300" h="132" title="actions:&#xA;add =&gt; add new ticket review on this permission, without deleting existing ones&#xA;replace =&gt; delete existing tickets (or ticket if passed), create new one&#xA;delete =&gt; delete existing tickets"/>
		<Link name="L1546522389851" source="CSTART" target="C1546463477424" priority="1" expression="(dataset.equals(&apos;in_action&apos;, &apos;add&apos;, false, true))"/>
		<Component name="C1546527628298" type="variablechangeactivity" x="204" y="131" w="207" h="98" title="retrieve ticket ids to delete">
			<Actions>
				<Action name="U1546527723003" action="executeview" viewname="rm_perm_review_ticket" append="false" workflowtimeslot="false" attribute="tr_to_delete">
					<ViewParam name="P15465277230030" param="permissionuid" paramvalue="{dataset.in_permissionuid.get()}"/>
					<ViewAttribute name="P1546527723003_1" attribute="recorduid" variable="tr_to_delete"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1546527853248" source="C1546527628298" target="C1546463496934" priority="1"/>
		<Link name="L1546528132594" source="CSTART" target="C1546463496934" priority="3" linecustom="false"/>
	</Definition>
	<Variables>
		<Variable name="A1546463660230" variable="in_action" displayname="action" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="add">
			<StaticValue name="add"/>
			<StaticValue name="replace"/>
			<StaticValue name="delete"/>
		</Variable>
		<Variable name="A1546463697179" variable="in_permissionuid" displayname="permissionuid" editortype="Ledger Permission" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1546463784716" variable="in_comment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" displayname="comment"/>
		<Variable name="A1546463821673" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1546463864748" variable="TTYPE" displayname="TTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="RM_PERM_REVIEW" notstoredvariable="true"/>
		<Variable name="A1546464419439" variable="tr_to_delete" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true" displayname="tr recorduis to delete"/>
		<Variable name="A1546466668535" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1546528300558" variable="in_tr_toreplace" displayname="tr recorduid to replace" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1549451517445" variable="action_actor_fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1549451541370" variable="action_date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1546463903800" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1546463939805" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
