<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_batchupdatepermissionmetadata" displayname="Batch update permission classification" description="Batch Update permission classification" scriptfile="workflow/bw_fragments/empty.javascript" statictitle="Batch Update permission classification" publish="false" type="builtin-technical-workflow" technical="true">
		<Component name="CEND" type="endactivity" x="782" y="142" w="200" h="98" title="End - bwf_batchupdatepermissionmetadata" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="CSTART" type="startactivity" x="107" y="142" w="200" h="114" title="Start - bwf_batchupdatepermissionmetadata" compact="true">
			<Output name="output"/>
			<Ticket create="true" createaction="true">
			</Ticket>
			<Actions>
			</Actions>
			<Candidates name="role" role="A1437989337599"/>
		</Component>
		<Component name="C1633338976639" type="callactivity" x="334" y="117" w="300" h="98" title="update metadata">
			<Process workflowfile="/workflow/bw_fragments/metadata/updatepermissionmetadata.workflow">
				<Input name="A1633339059595" variable="description" content="description"/>
				<Input name="A1633339064379" variable="managed" content="managed"/>
				<Input name="A1633339069114" variable="permission" content="permission"/>
				<Input name="A1633339074101" variable="sensitivitylevel" content="sensitivitylevel"/>
				<Input name="A1633339079319" variable="sensitivityreason" content="sensitivityreason"/>
			</Process>
			<Iteration listvariable="permission" distinctvalues="false"/>
		</Component>
		<Link name="L1633338983543" source="CSTART" target="C1633338976639" priority="1"/>
		<Link name="L1633339846750" source="C1633338976639" target="CEND" priority="1"/>
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
