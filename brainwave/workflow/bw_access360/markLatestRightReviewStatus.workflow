<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_markLatestRightReviewStatus" statictitle="markLatestRightReviewStatus" scriptfile="/workflow/bw_access360/markLatestRightReviewStatus.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="264" y="66" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1666097022423"/>
		</Component>
		<Component name="CEND" type="endactivity" x="264" y="681" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1666097090910" priority="1"/>
		<Component name="C1666097090910" type="variablechangeactivity" x="138" y="162" w="300" h="98" title="prepare update">
			<Actions function="computeTicketsToUpdate">
				<Action name="U1666097137927" action="executeview" viewname="bwa_rightswithmarkedlatestreview" append="false" attribute="entriestoreset">
					<ViewParam name="P16660971379270" param="accountuid" paramvalue="{dataset.accountuid}"/>
					<ViewParam name="P16660971379271" param="campaignid" paramvalue="{dataset.campaignid}"/>
					<ViewParam name="P16660971379272" param="perimeteruid" paramvalue="{dataset.perimeteruid}"/>
					<ViewParam name="P16660971379273" param="permissionuid" paramvalue="{dataset.permissionuid}"/>
					<ViewParam name="P16660971379274" param="workflowcampaignid" paramvalue="{dataset.workflowcampaignid}"/>
					<ViewAttribute name="P1666097137927_5" attribute="recorduid" variable="entriestoreset"/>
					<ViewAttribute name="P1666097137927_6" attribute="resetvalue" variable="resetvalue"/>
				</Action>
				<Action name="U1666097552365" action="executeview" viewname="bwa_computerightsreviewstatus" append="false" attribute="entriestoset">
					<ViewParam name="P16660975523650" param="accountuid" paramvalue="{dataset.accountuid}"/>
					<ViewParam name="P16660975523651" param="campaignid" paramvalue="{dataset.campaignid}"/>
					<ViewParam name="P16660975523652" param="perimeteruid" paramvalue="{dataset.perimeteruid}"/>
					<ViewParam name="P16660975523653" param="permissionuid" paramvalue="{dataset.permissionuid}"/>
					<ViewParam name="P16660975523654" param="workflowcampaignid" paramvalue="{dataset.workflowcampaignid}"/>
					<ViewAttribute name="P1666097552365_5" attribute="recorduid" variable="entriestoset"/>
					<ViewAttribute name="P1666097552365_6" attribute="setvalue" variable="setvalue"/>
				</Action>
			</Actions>
		</Component>
		<Component name="C1666097564161" type="updateticketreviewactivity" x="138" y="336" w="300" h="98" title="reset entries">
			<UpdateTicketReview ticketreviewnumbervariable="entriestoreset">
				<Attribute name="custom19" attribute="resetvalue"/>
			</UpdateTicketReview>
		</Component>
		<Component name="C1666097565805" type="updateticketreviewactivity" x="138" y="502" w="300" h="98" title="set entries">
			<UpdateTicketReview ticketreviewnumbervariable="entriestoset">
				<Attribute name="custom19" attribute="setvalue"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1666097575301" source="C1666097090910" target="C1666097564161" priority="1"/>
		<Link name="L1666097575876" source="C1666097564161" target="C1666097565805" priority="1"/>
		<Link name="L1666097576710" source="C1666097565805" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1666097022423" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1666097031021" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A16660971379270" variable="entriestoreset" displayname="entriestoreset" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16660971379271" variable="resetvalue" displayname="resetvalue" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16660975523650" variable="entriestoset" displayname="entriestoset" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16660975523651" variable="setvalue" displayname="setvalue" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1666097864783" variable="campaignid" displayname="campaign id" editortype="Default" type="String" multivalued="false" visibility="in" description="limit update to a given right review campaign" notstoredvariable="true"/>
		<Variable name="A1666098075409" variable="perimeteruid" displayname="perimeteruid" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="limit the update perimeter"/>
		<Variable name="A1666098082516" variable="accountuid" displayname="accountuid" editortype="Ledger Account" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="limit the update perimeter"/>
		<Variable name="A1666098089298" variable="permissionuid" displayname="permissionuid" editortype="Ledger Permission" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="limit the update perimeter"/>
		<Variable name="A1666794802476" variable="workflowcampaignid" displayname="workflow campaignid" editortype="Default" type="String" multivalued="false" visibility="in" description="workflow campaignid" notstoredvariable="true"/>
	</Variables>
</Workflow>
