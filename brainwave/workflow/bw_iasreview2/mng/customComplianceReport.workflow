<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="customComplianceReport" statictitle="customComplianceReport" scriptfile="/workflow/bw_iasreview2/mng/customComplianceReport.javascript">
		<Component name="CSTART" type="startactivity" x="32" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
		</Component>
		<Component name="CEND" type="endactivity" x="32" y="192" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
		<Component name="N1748850814113_1" type="note" x="133" y="79" w="260" h="110" title="This workflow is a placeholder.&#xA;Call you own custom workflow from here."/>
	</Definition>
	<Variables>
		<Variable name="A1749737911304" variable="campaignid" displayname="campaign id" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1749737957335" variable="delegationtext" displayname="delegation text" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1749737982015" variable="lang" displayname="lang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1749737995432" variable="generalComment" displayname="generalComment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
