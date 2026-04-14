<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_batchupdategroupmanager" statictitle="Batch Update group manager" scriptfile="/workflow/bw_fragments/empty.javascript" displayname="Batch update group manager" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="187" y="188" w="200" h="114" title="Start - bwf_batchupdategroupmanager" compact="true">
			<Ticket create="true" createaction="true"/>
			<Candidates name="role" role="A1696863560227"/>
		</Component>
		<Component name="CEND" type="endactivity" x="785" y="189" w="200" h="98" title="End - bwf_batchupdategroupmanager" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1696863826198" priority="1"/>
		<Component name="C1696863826198" type="callactivity" x="339" y="160" w="300" h="98" title="Update Group Manager">
			<Process workflowfile="/workflow/bw_fragments/managers/updategroupmanager.workflow">
				<Input name="A1696864748377" variable="action" content="action"/>
				<Input name="A1696864776642" variable="delegation" content="delegation"/>
				<Input name="A1696864832394" variable="comments" content="comments"/>
				<Input name="A1696864856870" variable="delegationbegindate" content="delegationbegindate"/>
				<Input name="A1696864867607" variable="delegationenddate" content="delegationenddate"/>
				<Input name="A1696864875659" variable="delegationpriority" content="delegationpriority"/>
				<Input name="A1696864883276" variable="delegationreason" content="delegationreason"/>
				<Input name="A1696864892638" variable="group" content="group"/>
				<Input name="A1696864916614" variable="managertype" content="managertype"/>
				<Input name="A1696865206006" variable="manager" content="manager"/>
				<Input name="A1696865355778" variable="managerLink" content="managerlink"/>
			</Process>
			<Iteration listvariable="group"/>
		</Component>
		<Link name="L1696863835280" source="C1696863826198" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1696863560227" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owners" description="owners">
			<Rule name="A1696863741166" rule="updategroupmanagerstart" description="People who can start an update on a group manager workflow"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1696864252678" variable="group" displayname="group" editortype="Ledger Group" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1696864294866" variable="groupname" displayname="groupname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1696864332614" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" description="internal, used for the ticketlog" notstoredvariable="false" initialvalue="in progress"/>
		<Variable name="A1696864424382" variable="managertype" displayname="manager type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864486687" variable="action" displayname="action" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864549269" variable="delegation" displayname="delegation" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864566348" variable="delegationbegindate" displayname="delegationbegindate" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864589965" variable="delegationenddate" displayname="delegationenddate" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864654634" variable="delegationpriority" displayname="delegationpriority" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864667531" variable="delegationreason" displayname="delegationreason" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1696864808089" variable="comments" displayname="comments" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696864953082" variable="manager" displayname="manager" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696865283982" variable="managerlink" displayname="managerlink" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
