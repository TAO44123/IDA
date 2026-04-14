<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwir_customReview" statictitle="IAP Custom Review launcher" scriptfile="/workflow/bw_iasreview2/mng/customReview.javascript" displayname="Launching custom review {dataset.reviewname.get()} #{dataset.inst_num.get()}" description="Custom review launcher placeholder">
		<Component name="CSTART" type="startactivity" x="339" y="32" w="200" h="114" title="bwir_customReview - Start" compact="true">
			<Ticket create="true"/>
		</Component>
		<Component name="CEND" type="endactivity" x="339" y="307" w="200" h="98" title="bwir_customReview - End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
		<Component name="N1748850814113" type="note" x="461" y="132" w="260" h="110" title="This workflow is a placeholder.&#xA;Call you own custom workflow from here."/>
	</Definition>
	<Variables>
		<Variable name="A1748361967872" variable="reviewdefmduid" displayname="Review definition metadata uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="Uid of the metadata holding the review definition"/>
		<Variable name="A1748362005858" variable="timeslotuid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" displayname="Campaign Timeslotuid" description="Timeslotuid of the campaign"/>
		<Variable name="A1748362197885" variable="inst_num" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true" displayname="Instance number" description="Campaign instance number (autoincrement)"/>
		<Variable name="A1748362460123" variable="reviewpage" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" displayname="Review Page" description="Identifier of the review page"/>
		<Variable name="A1748425582453" variable="ticketActionNumber" displayname="Ticket Action Number" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true" description="Ticket Action Number of the main launch process"/>
		<Variable name="A1748425637772" variable="ticketlogrecorduid" displayname="Ticketlog recorduid" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true" description="Recorduid of the main process"/>
		<Variable name="A1748426234215" variable="isafullreview" displayname="Is A Full Review?" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" description="True if this is a full review"/>
		<Variable name="A1748426285824" variable="offlinemode" displayname="Offline mode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="True (&quot;1&quot;) if offline mode is enabled"/>
		<Variable name="A1748426310402" variable="selfdelegation" displayname="Self delegation" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="True (&quot;1&quot;) if self delefation is enabled"/>
		<Variable name="A1748850595553" variable="reviewname" displayname="Review Name" editortype="Default" type="String" multivalued="false" visibility="in" description="Name of the review" notstoredvariable="true"/>
	</Variables>
</Workflow>
