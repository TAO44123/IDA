<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_updateapplicationmetadata" displayname="Update application classification for {dataset.applicationname}" description="Update shared metadata" scriptfile="workflow/bw_fragments/empty.javascript" statictitle="Update application classification" publish="false" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="55" y="148" w="200" h="114" title="Start - bwf_updateapplicationmetadata" compact="true">
			<Output name="output" ticketnumbervariable="ticketlog" ticketactionnumbervariable="ticketaction"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="status" attribute="ticketstatus"/>
			</Ticket>
			<Actions>
				<Action name="U1598458341607" action="executeview" viewname="br_applicationDetail" append="false" attribute="applicationname">
					<ViewParam name="P15984583416070" param="uid" paramvalue="{dataset.application.get()}"/>
					<ViewAttribute name="P1598458341607_1" attribute="displayname" variable="applicationname"/>
				</Action>
				<Action name="U1437988949694" action="update" attribute="ticketdescription" newvalue="Update metadata on {dataset.applicationname.get()}"/>
			</Actions>
			<Candidates name="role" role="A1437989337599"/>
			<FormVariable name="A1437989372486" variable="description" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1445361515503" variable="application" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1586453282424" variable="category" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586453287675" variable="sensitivitylevel" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586453292917" variable="sensitivityreason" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="693" y="148" w="200" h="98" title="End - bwf_updateapplicationmetadata" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1444232855613" type="ticketreviewactivity" x="159" y="123" w="200" h="98" title="Write the tickets">
			<TicketReview ticketaction="ticketaction" expression="(dataset.equals(&apos;createReviewTickets&apos;, &apos;true&apos;, false, true))">
				<Permission/>
				<Attribute name="comment" attribute="ticketdescription"/>
				<Application applicationvariable="application"/>
				<Attribute name="custom1" attribute="description"/>
				<Attribute name="custom2" attribute="category"/>
				<Attribute name="custom3" attribute="sensitivitylevel"/>
				<Attribute name="custom4" attribute="sensitivityreason"/>
				<Attribute name="status" attribute="REVIEWTYPE"/>
			</TicketReview>
		</Component>
		<Link name="L1445361479401" source="CSTART" target="C1444232855613" priority="1"/>
		<Component name="C1608037074833" type="metadataactivity" x="423" y="123" w="181" h="98" title="Update metadata">
			<Metadata action="C" schema="bwa_applicationmetadata">
				<Application application="application"/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" string3="category"/>
			</Metadata>
		</Component>
		<Link name="L1620210325710" source="C1608037074833" target="CEND" priority="1"/>
		<Link name="L1620210323031" source="C1444232855613" target="C1608037074833" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1437988414131" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1437988472472" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: sensitivity, ex: CTU" notstoredvariable="false"/>
		<Variable name="A1437988656376" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="APPLICATIONMETADATA" notstoredvariable="false" description="APPLICATIONMETADATA"/>
		<Variable name="A1437988671470" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1437988809253" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1444233051422" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444233900846" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444234477149" variable="createReviewTickets" displayname="createReviewTickets" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="false" description="Default: true&#xA;"/>
		<Variable name="A1444318225262" variable="category" displayname="category" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: Category" notstoredvariable="false"/>
		<Variable name="A1586429680346" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="false" visibility="in" description="Input: sensitivity level" notstoredvariable="true"/>
		<Variable name="A1586430800907" variable="REVIEWTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="metadata update" notstoredvariable="true" description="metadata update"/>
		<Variable name="A1445361246681" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="Input: application uid"/>
		<Variable name="A1598458303492" variable="applicationname" displayname="applicationname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1437989337599" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owners" description="owners">
			<Rule name="A1445361267084" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
