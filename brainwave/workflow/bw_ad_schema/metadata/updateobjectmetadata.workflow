<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="updateobjectmetadata" displayname="Update object metadata" description="Update object metadata" scriptfile="/workflow/bw_ad_schema/metadata/updateobjectmetadata.javascript" statictitle="Update object metadata" publish="false" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="18" y="20" w="200" h="114" title="Start" compact="true">
			<Output name="output" ticketnumbervariable="ticketlog" ticketactionnumbervariable="ticketaction"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="status" attribute="ticketstatus"/>
			</Ticket>
			<Actions>
				<Action name="U1437988949694" action="update" attribute="ticketdescription" newvalue="update metadata on (&apos;{dataset.object.length}&apos;) object(s)"/>
			</Actions>
			<Candidates name="role" role="A1484063965330"/>
			<FormVariable name="A1437989366862" variable="object" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1437989372486" variable="description" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1437989377249" variable="managed" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="893" y="467" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1444222455485" type="scriptactivity" x="130" y="90" w="200" h="98" title="Process Update">
			<Script onscriptexecute="processUpdate"/>
		</Component>
		<Link name="L1444222470044" source="CSTART" target="C1444222455485" priority="2"/>
		<Component name="C1444225941064" type="updatepermissioninfoactivity" x="499" y="276" w="200" h="98" title="Update the metadata">
			<PermissionInfo name="perminfo" update="whattoupdate" managed="resultingManaged" description="resultingDescription" permission="resultingUids"/>
		</Component>
		<Link name="L1444225958082" source="C1444225941064" target="CEND" priority="1"/>
		<Component name="N1444230132222" type="note" x="28" y="396" w="269" h="140" title="Notes&#xA;&#xA;- Workflow receives multivalued variables&#xA;"/>
		<Component name="C1444232855613" type="ticketreviewactivity" x="499" y="88" w="200" h="98" title="Write the tickets">
			<TicketReview ticketaction="ticketaction" expression="(dataset.equals(&apos;createReviewTickets&apos;, &apos;true&apos;, false, true))">
				<Permission permissionvariable="resultingUids"/>
				<Attribute name="comment" attribute="ticket_descriptions"/>
			</TicketReview>
		</Component>
		<Link name="L1444234058253" source="C1444222455485" target="C1444232855613" priority="1"/>
		<Link name="L1444234072755" source="C1444232855613" target="C1444225941064" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1437988414131" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1437988437527" variable="managed" displayname="managed" editortype="Default" type="Boolean" multivalued="true" visibility="in" description="Input: Managed" notstoredvariable="false"/>
		<Variable name="A1437988656376" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="OBJECTMETADATA" notstoredvariable="false" description="OBJECTMETADATA"/>
		<Variable name="A1437988671470" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1437988809253" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1444225117989" variable="whattoupdate" displayname="whattoupdate" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used in javascript"/>
		<Variable name="A1444227903424" variable="resultingUids" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="output, calculated in javascript"/>
		<Variable name="A1444227937304" variable="resultingManaged" displayname="resultingManaged" editortype="Default" type="Boolean" multivalued="true" visibility="local" notstoredvariable="false" description="output, calculated in javascript"/>
		<Variable name="A1444227950137" variable="resultingDescription" displayname="resultingDescription" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="output, calculated in javascript"/>
		<Variable name="A1444233051422" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444233900846" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444234477149" variable="createReviewTickets" displayname="createReviewTickets" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="false" description="Default: true&#xA;"/>
		<Variable name="A1444234604064" variable="ticket_descriptions" displayname="ticket_descriptions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="Ouput ticket descriptions&#xA;"/>
		<Variable name="A1484063214369" variable="object" displayname="object" editortype="Default" type="String" multivalued="true" visibility="in" description="Input: object uid&#xA;" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1484063965330" displayname="secuopit" description="secuopit">
			<Rule name="A1484063987804" rule="ad_secu_op_it" description="ad_secu_op_it"/>
		</Role>
	</Roles>
</Workflow>
