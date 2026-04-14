<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_deleteCampaign" statictitle="delete Campaign" scriptfile="/workflow/bw_access360/deleteCampaign.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="247" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1626703782589"/>
			<Actions>
				<Action name="U1626704950788" action="executeview" viewname="bwaccess360_accessreviewcampaigns" append="false" attribute="campaignrecorduid">
					<ViewParam name="P16267049507880" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1626704950788_1" attribute="recorduid" variable="campaignrecorduid"/>
				</Action>
				<Action name="U1626705106888" action="executeview" viewname="bwaccess360_accessreviewcampaignsentries" append="false" attribute="reviewrecorduid">
					<ViewParam name="P16267051068880" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1626705106888_1" attribute="recorduid" variable="reviewrecorduid"/>
					<ViewAttribute name="P1626705106888_2" attribute="ticketactionrecorduid" variable="ticketactionrecorduid"/>
				</Action>
				<Action name="U1626937702752" action="executeview" viewname="bwaccess360_accessreviewcampaignsfinalized" append="false" attribute="finalizedcampaignrecorduid">
					<ViewParam name="P16269377027520" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1626937702752_1" attribute="recorduid" variable="finalizedcampaignrecorduid"/>
				</Action>
				<Action name="U1627052405089" action="executeview" viewname="bwaccess360_accessreviewcampaignremediationentries" append="false" attribute="remediationreviewrecorduid">
					<ViewParam name="P16270524050890" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1627052405089_1" attribute="recorduid" variable="remediationreviewrecorduid"/>
					<ViewAttribute name="P1627052405089_2" attribute="remediationactionrecorduid" variable="remediationactionrecorduid"/>
					<ViewAttribute name="P1627052405089_3" attribute="remediationrecorduid" variable="remediationrecorduid"/>
				</Action>
				<Action name="U1662042542039" action="executeview" viewname="bwr_getcampaigninstanceadditionalinfos" append="false" attribute="campaignmetadatauid">
					<ViewParam name="P16620425420390" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1662042542039_1" attribute="uid" variable="campaignmetadatauid"/>
					<ViewAttribute name="P1662042542039_2" attribute="currentstatus" variable="campaignstatus"/>
				</Action>
			</Actions>
			<FormVariable name="A1705759742950" variable="campaignid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1744816984348" variable="stickyTimeslot" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="247" y="1484" w="200" h="98" title="End" compact="true">
			<Actions function="decrementStickyReviewUsageCounter"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1627052427413" priority="1"/>
		<Component name="C1626705120740" type="deleteticketactivity" x="121" y="727" w="300" h="98" title="delete review tickets">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="reviewrecorduid"/>
		</Component>
		<Component name="C1626705122073" type="deleteticketactivity" x="121" y="1021" w="300" h="98" title="delete ticket log">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="campaignrecorduid"/>
		</Component>
		<Component name="C1626705188137" type="deleteticketactivity" x="121" y="875" w="300" h="98" title="delete ticket action">
			<DeleteTicket name="deleteticket" tickettype="TicketAction" ticketrecordnumber="ticketactionrecorduid"/>
		</Component>
		<Link name="L1626705211500" source="C1626705120740" target="C1626705188137" priority="1"/>
		<Link name="L1626705212457" source="C1626705188137" target="C1626705122073" priority="1"/>
		<Link name="L1626705213388" source="C1626705122073" target="C1626937714419" priority="1"/>
		<Component name="C1626937714419" type="deleteticketactivity" x="121" y="1192" w="300" h="98" title="delete finalized ticket log">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="finalizedcampaignrecorduid"/>
		</Component>
		<Link name="L1626937736147" source="C1626937714419" target="C1662042546373" priority="1"/>
		<Component name="C1627052427413" type="deleteticketactivity" x="121" y="177" w="300" h="98" title="delete remediation review tickets">
			<DeleteTicket name="deleteticket" tickettype="TicketReview" ticketrecordnumber="remediationreviewrecorduid"/>
		</Component>
		<Component name="C1627052429542" type="deleteticketactivity" x="121" y="365" w="300" h="98" title="delete remediation action tickets">
			<DeleteTicket name="deleteticket" tickettype="TicketAction" ticketrecordnumber="remediationactionrecorduid"/>
		</Component>
		<Component name="C1627052431515" type="deleteticketactivity" x="121" y="533" w="300" h="98" title="delete remediation tickets">
			<DeleteTicket name="deleteticket" tickettype="TicketLog" ticketrecordnumber="remediationrecorduid"/>
		</Component>
		<Link name="L1627052461323" source="C1627052427413" target="C1627052429542" priority="1"/>
		<Link name="L1627052461914" source="C1627052429542" target="C1627052431515" priority="1"/>
		<Link name="L1627052463166" source="C1627052431515" target="C1626705120740" priority="1"/>
		<Component name="C1662042546373" type="metadataactivity" x="119" y="1338" w="300" h="98" title="remove campaign instance add. infos">
			<Metadata action="D" metadatauid="campaignmetadatauid"/>
		</Component>
		<Link name="L1662042615397" source="C1662042546373" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1626703782589" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626703792675" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1626703854189" variable="campaignid" displayname="campaign id" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626704851220" variable="campaignrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1626704862993" variable="reviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1626705163927" variable="ticketactionrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1626937657432" variable="finalizedcampaignrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627052313155" variable="remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627052322081" variable="remediationactionrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627052334270" variable="remediationreviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662042972084" variable="campaignmetadatauid" displayname="campaignmetadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1742571945067" variable="stickyTimeslot" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1744814593504" variable="campaignstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
