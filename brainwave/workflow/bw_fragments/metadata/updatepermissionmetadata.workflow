<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_updatepermissionmetadata" displayname="Update permission classification for {dataset.permissionname}/{dataset.applicationname}" description="Update shared-folder metadata" scriptfile="workflow/bw_fragments/empty.javascript" statictitle="Update permission classification" publish="false" type="builtin-technical-workflow" technical="true">
		<Component name="CEND" type="endactivity" x="751" y="137" w="200" h="98" title="End - bwf_updatepermissionmetadata" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="N1444230132222" type="note" x="25" y="235" w="269" h="140" title="Notes&#xA;&#xA;- Workflow receives multivalued variables"/>
		<Component name="C1444232855613" type="ticketreviewactivity" x="192" y="112" w="200" h="98" title="Write the tickets">
			<TicketReview ticketaction="ticketaction" expression="(dataset.equals(&apos;createReviewTickets&apos;, &apos;true&apos;, false, true))">
				<Permission permissionvariable="permission"/>
				<Attribute name="comment" attribute="ticket_descriptions"/>
				<Attribute name="custom1" attribute="description"/>
				<Attribute name="custom3" attribute="sensitivitylevel"/>
				<Attribute name="custom4" attribute="sensitivityreason"/>
				<Attribute name="status" attribute="REVIEWTYPE"/>
				<Attribute name="custom2" attribute="managed"/>
			</TicketReview>
		</Component>
		<Component name="C1608037321900" type="metadataactivity" x="468" y="110" w="193" h="98" title="Update metadata">
			<Metadata action="C" schema="bwa_permissionmetadata">
				<Permission permission1="permission"/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" boolean="managed"/>
			</Metadata>
		</Component>
		<Link name="L1620212158377" source="C1444232855613" target="C1608037321900" priority="1"/>
		<Link name="L1620212159180" source="C1608037321900" target="CEND" priority="1"/>
		<Component name="CSTART" type="startactivity" x="60" y="137" w="200" h="114" title="Start - bwf_updatepermissionmetadata" compact="true">
			<Output name="output" ticketnumbervariable="ticketlog" ticketactionnumbervariable="ticketaction"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="status" attribute="ticketstatus"/>
			</Ticket>
			<Actions>
				<Action name="U1598458193139" action="executeview" viewname="br_permissionDetail" append="false" attribute="permissionname">
					<ViewParam name="P15984581931390" param="uid" paramvalue="{dataset.permission.get()}"/>
					<ViewAttribute name="P1598458193139_1" attribute="displayname" variable="permissionname"/>
					<ViewAttribute name="P1598458193139_2" attribute="application_displayname" variable="applicationname"/>
				</Action>
				<Action name="U1437988949694" action="update" attribute="ticketdescription" newvalue="update metadata on {dataset.permissionname.get()} / {dataset.applicationname.get()}"/>
			</Actions>
			<Candidates name="role" role="A1437989337599"/>
			<FormVariable name="A1445352315290" variable="permission" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1437989372486" variable="description" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1587311909712" variable="managed" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1587311472480" variable="sensitivitylevel" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1587311479861" variable="sensitivityreason" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Link name="L1444222470044" source="CSTART" target="C1444232855613" priority="2"/>
	</Definition>
	<Variables>
		<Variable name="A1437988414131" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1437988437527" variable="managed" displayname="managed" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Input: Managed" notstoredvariable="false"/>
		<Variable name="A1437988472472" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: sensitivity, ex: CTU" notstoredvariable="false"/>
		<Variable name="A1437988656376" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="SHAREDFOLDERMETADATA" notstoredvariable="false" description="SHAREDFOLDERMETADATA"/>
		<Variable name="A1437988671470" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1437988809253" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1444233051422" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444233900846" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444234477149" variable="createReviewTickets" displayname="createReviewTickets" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="false" description="Default: true&#xA;"/>
		<Variable name="A1444234604064" variable="ticket_descriptions" displayname="ticket_descriptions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="Input Descriptions"/>
		<Variable name="A1445352183805" variable="permission" displayname="permission" editortype="Ledger Permission" type="String" multivalued="true" visibility="in" notstoredvariable="false"/>
		<Variable name="A1587311418971" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1587311615172" variable="REVIEWTYPE" displayname="review type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="metadata update" notstoredvariable="true"/>
		<Variable name="A1598458103598" variable="permissionname" displayname="permissionname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1598458110927" variable="applicationname" displayname="applicationname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1437989337599" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owners" description="owners">
			<Rule name="A1445351634714" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
