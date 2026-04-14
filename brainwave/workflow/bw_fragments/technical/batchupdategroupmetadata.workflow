<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_batchupdategroupmetadata" statictitle="Batch Update group classification" scriptfile="/workflow/bw_fragments/empty.javascript" displayname="Batch update group classification" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="177" y="179" w="200" h="114" title="Start - bwf_batchupdategroupmetadata" compact="true">
			<Ticket create="true" createaction="true"/>
			<Candidates name="role" role="A1696857563467"/>
		</Component>
		<Component name="CEND" type="endactivity" x="803" y="180" w="200" h="98" title="End - bwf_batchupdategroupmetadata" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1696857278035" priority="1"/>
		<Component name="C1696857278035" type="callactivity" x="368" y="154" w="300" h="98" title="updategroupmetadata">
			<Process workflowfile="/workflow/bw_fragments/metadata/updategroupmetadata.workflow">
				<Input name="A1696858099975" variable="description" content="description"/>
				<Input name="A1696858106523" variable="ismanaged" content="managed"/>
				<Input name="A1696858112882" variable="sensitivitylevel" content="sensitivitylevel"/>
				<Input name="A1696858119393" variable="sensitivityreason" content="sensitivityreason"/>
				<Input name="A1696858358846" variable="uid" content="group"/>
			</Process>
			<Iteration listvariable="group"/>
		</Component>
		<Link name="L1696857318795" source="C1696857278035" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1696857563467" displayname="owners" description="owners" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png">
			<Rule name="A1696863700604" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1696857828348" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1696857881025" variable="managed" displayname="managed" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Input: Managed" notstoredvariable="false"/>
		<Variable name="A1696857927828" variable="group" displayname="group" editortype="Ledger Group" type="String" multivalued="true" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696857973808" variable="groupname" displayname="groupname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1696858025256" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1696858061148" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1696858596318" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" description="internal, used for the ticketlog" initialvalue="in progress" notstoredvariable="false"/>
	</Variables>
</Workflow>
