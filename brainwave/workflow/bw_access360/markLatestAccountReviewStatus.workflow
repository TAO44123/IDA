<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_markLatestAccountReviewStatus" statictitle="mark Latest Account Review Status" scriptfile="/workflow/bw_access360/markLatestAccountReviewStatus.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="255" y="47" w="200" h="114" title="Start - bwa_markLatestAccountReviewStatus" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1666088750078"/>
		</Component>
		<Component name="CEND" type="endactivity" x="255" y="847" w="200" h="98" title="End - bwa_markLatestAccountReviewStatus" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1666088770091" priority="1"/>
		<Component name="C1666088770091" type="variablechangeactivity" x="129" y="196" w="300" h="98" title="compute tickets to update">
			<Actions function="computeTicketsToUpdate">
				<Action name="U1666092203167" action="executeview" viewname="bwa_accountswithmarkedlatestreview" append="false" attribute="ticketstoreset">
					<ViewParam name="P16660922031670" param="campaignid" paramvalue="{dataset.campaignid}"/>
					<ViewParam name="P16660922031671" param="accountuid" paramvalue="{dataset.accountuid}"/>
					<ViewParam name="P16660922031672" param="workflowcampaignid" paramvalue="{dataset.workflowcampaignid}"/>
					<ViewAttribute name="P1666092203167_3" attribute="recorduid" variable="ticketstoreset"/>
					<ViewAttribute name="P1666092203167_4" attribute="resetvalue" variable="resetvalues"/>
				</Action>
				<Action name="U1666092960926" action="executeview" viewname="bwa_computeaccountslatestsstatus" append="false" attribute="ticketstoupdate">
					<ViewParam name="P16660929609260" param="campaignid" paramvalue="{dataset.campaignid}"/>
					<ViewParam name="P16660929609261" param="accountuid" paramvalue="{dataset.accountuid}"/>
					<ViewParam name="P16660929609262" param="workflowcampaignid" paramvalue="{dataset.workflowcampaignid}"/>
					<ViewAttribute name="P1666092960926_3" attribute="recorduid" variable="ticketstoupdate"/>
					<ViewAttribute name="P1666092960926_4" attribute="setvalue" variable="setvalues"/>
					<ViewAttribute name="P1666092960926_5" attribute="uid" variable="accountsuid"/>
					<ViewAttribute name="P1666092960926_6" attribute="accountablefullname" variable="accountablefullname"/>
					<ViewAttribute name="P1666092960926_7" attribute="actorfullname" variable="actorfullname"/>
					<ViewAttribute name="P1666092960926_8" attribute="actiondate" variable="actiondate"/>
					<ViewAttribute name="P1666092960926_9" attribute="comment" variable="comment"/>
					<ViewAttribute name="P1666092960926_10" attribute="status" variable="status"/>
				</Action>
			</Actions>
		</Component>
		<Component name="C1666092326450" type="updateticketreviewactivity" x="129" y="360" w="300" h="98" title="reset previous tickets">
			<UpdateTicketReview ticketreviewnumbervariable="ticketstoreset">
				<Attribute name="custom19" attribute="resetvalues"/>
			</UpdateTicketReview>
		</Component>
		<Component name="N1666092576456" type="note" x="569" y="126" w="438" h="135" title="optional parameter: &#xA;- workflow review campaign id to limit update to a given account review campaign&#xA;- IAP review campaign id to limit update to a given account review campaign&#xA;- account uids to limit update to a given account set&#xA;otherwise ALL ACCOUNTS review status will be updated"/>
		<Component name="C1666092326450_1" type="updateticketreviewactivity" x="129" y="522" w="300" h="98" title="mark new tickets as the latest ones">
			<UpdateTicketReview ticketreviewnumbervariable="ticketstoupdate">
				<Attribute name="custom19" attribute="setvalues"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1666092997171" source="C1666088770091" target="C1666092326450" priority="1"/>
		<Link name="L1666092997794" source="C1666092326450" target="C1666092326450_1" priority="1"/>
		<Link name="L1666092998523" source="C1666092326450_1" target="C1666188580056" priority="1"/>
		<Component name="C1666188580056" type="metadataactivity" x="128" y="680" w="300" h="98" title="attach the latest review status to the account">
			<Metadata schema="bwr_accountreviewstatus" action="C">
				<Account account="accountsuid"/>
				<Data string1="status" string3="comment" string4="actorfullname" string5="accountablefullname" date1="actiondate" integer3="ticketstoupdate"/>
			</Metadata>
		</Component>
		<Link name="L1666188768260" source="C1666188580056" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1666088750078" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1666088760765" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1666088843259" variable="ticketstoupdate" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666088868035" variable="ticketslateststatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092173636" variable="ticketstoreset" displayname="tickets to reset" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092271030" variable="resetvalues" displayname="resetvalues" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092281505" variable="setvalues" displayname="setvalues" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092389834" variable="campaignid" displayname="campaignid" editortype="Default" type="String" multivalued="false" visibility="in" description="update a given account campaign" notstoredvariable="true"/>
		<Variable name="A1666093510426" variable="accountuid" displayname="account uid" editortype="Ledger Account" type="String" multivalued="true" visibility="in" description="update a given set of accounts (input)" notstoredvariable="true"/>
		<Variable name="A16660929609262" variable="accountsuid" displayname="accountsuid" multivalued="true" visibility="local" type="String" editortype="Ledger Account" description="Account uids returned by the view" notstoredvariable="false"/>
		<Variable name="A16660929609263" variable="accountablefullname" displayname="accountablefullname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16660929609264" variable="actorfullname" displayname="actorfullname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16660929609265" variable="actiondate" displayname="actiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16660929609266" variable="comment" displayname="comment" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16660929609267" variable="status" displayname="status" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1666794312292" variable="workflowcampaignid" displayname="workflow campaignid" editortype="Default" type="String" multivalued="false" visibility="in" description="workflow campaignid" notstoredvariable="true"/>
		<Variable name="A1672936067353" variable="nbTicketsToUpdate" displayname="Number of Ticket to Update" editortype="Default" type="Number" multivalued="false" visibility="local" description="Number of Ticket to Update" notstoredvariable="true"/>
	</Variables>
</Workflow>
