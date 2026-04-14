<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_finalizeCustomCampaign" statictitle="Finalize Custom Campaign" description="Finalize a Custom Campaign" scriptfile="/workflow/bw_iasreview2/mng/finalizeCustomCampaign.javascript" displayname="Finalize Custom Campaign {dataset.campaignid.get()}">
		<Component name="CSTART" type="startactivity" x="460" y="32" w="200" h="114" title="bwr_finalizeCustomCampaign - Start" compact="true">
			<Ticket create="true"/>
		</Component>
		<Component name="CEND" type="endactivity" x="460" y="404" w="200" h="98" title="bwr_finalizeCustomCampaign - End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
		<Component name="N1750165723634" type="note" x="581" y="156" w="346" h="81" title="This is a placeholder.&#xA;Call your own workflow(s) from here for custom review finalization if needed."/>
	</Definition>
	<Variables>
		<Variable name="A1750165081434" variable="campaignType" displayname="Review Type" editortype="Default" type="String" multivalued="false" visibility="out" description="Review Type" notstoredvariable="true"/>
		<Variable name="A1750165097426" variable="campaignid" displayname="Campaign ID" editortype="Default" type="Number" multivalued="false" visibility="in" description="Campaign ID" notstoredvariable="true"/>
		<Variable name="A1750165276919" variable="defaultStatus" displayname="Default Status" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="Not reviewed default status"/>
		<Variable name="A1750165307692" variable="defaultComment" displayname="Default Comment" editortype="Default" type="String" multivalued="false" visibility="in" description="Not reviewed default comment" notstoredvariable="true"/>
		<Variable name="A1750165332336" variable="generalComment" displayname="General Comment" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign finalization&apos;s general comment" notstoredvariable="true"/>
		<Variable name="A1750165353807" variable="lang_str" displayname="Language String" editortype="Default" type="String" multivalued="false" visibility="in" description="Finalization language string" notstoredvariable="true"/>
		<Variable name="A1750165379355" variable="onbehalfof_str" displayname="On Behalf of String" editortype="Default" type="String" multivalued="false" visibility="in" description="On Behalf of comment" notstoredvariable="true"/>
	</Variables>
</Workflow>
