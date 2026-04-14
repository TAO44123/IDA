<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_batchupdatesafemetadata" displayname="Batch update safe classification" description="Batch Update permission classification" scriptfile="workflow/bw_portaluar_base/updateapplicationmetadata.javascript" statictitle="Batch Update Safe Classification" publish="false" type="builtin-technical-workflow" technical="true">
		<Component name="CEND" type="endactivity" x="782" y="142" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="CSTART" type="startactivity" x="107" y="142" w="200" h="114" title="Start" compact="true">
			<Output name="output"/>
			<Ticket create="true" createaction="true">
			</Ticket>
			<Actions>
			</Actions>
			<Candidates name="role" role="A1671447234157"/>
		</Component>
		<Component name="C1633338976639" type="callactivity" x="334" y="117" w="300" h="98" title="update metadata">
			<Process workflowfile="/workflow/bw_fragments/metadata/updateapplicationmetadata.workflow">
				<Input name="A1633339059595" variable="description" content="description"/>
				<Input name="A1633339074101" variable="sensitivitylevel" content="sensitivitylevel"/>
				<Input name="A1633339079319" variable="sensitivityreason" content="sensitivityreason"/>
				<Input name="A1671200086034" variable="application" content="safe"/>
				<Input name="A1671200165585" variable="category" content="category"/>
			</Process>
			<Iteration listvariable="safe" distinctvalues="false"/>
		</Component>
		<Link name="L1633338983543" source="CSTART" target="C1633338976639" priority="1"/>
		<Link name="L1633339846750" source="C1633338976639" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1437988414131" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1437988472472" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: sensitivity, ex: CTU" notstoredvariable="false"/>
		<Variable name="A1437988656376" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="SHAREDFOLDERMETADATA" notstoredvariable="false" description="SHAREDFOLDERMETADATA"/>
		<Variable name="A1437988671470" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1437988809253" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1444233051422" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444233900846" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444234477149" variable="createReviewTickets" displayname="createReviewTickets" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="false" description="Default: true&#xA;"/>
		<Variable name="A1444234604064" variable="ticket_descriptions" displayname="ticket_descriptions" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="Input Descriptions"/>
		<Variable name="A1587311418971" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1587311615172" variable="REVIEWTYPE" displayname="review type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="metadata update" notstoredvariable="true"/>
		<Variable name="A1598458110927" variable="applicationname" displayname="applicationname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1671199898544" variable="safe" displayname="safe" editortype="Ledger Application" type="String" multivalued="true" visibility="in" notstoredvariable="false"/>
		<Variable name="A1671200143990" variable="category" displayname="category" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1671447234157" description="owners">
			<Rule name="A1671447292544" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
