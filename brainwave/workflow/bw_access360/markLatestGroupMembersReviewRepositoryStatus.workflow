<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_markLatestGroupMembersReviewRepositoryStatus" statictitle="markLatestGroupMembersReviewRepositoryStatus" description="attach a metadata to the repository groups which have been reviewed at least once" scriptfile="/workflow/bw_access360/markLatestAccountReviewRepositoryStatus.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="163" y="52" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1666521380340"/>
			<Actions>
				<Action name="U1666541079176" action="executeview" viewname="bwiasr_listlatestcompletedcampaigns" append="false" attribute="latestcampaignrecorduids">
					<ViewParam name="P16665410791760" param="filterpartialcampaigns" paramvalue="{dataset.filterpartialcampaigns.get()}"/>
					<ViewParam name="P16665410791761" param="reviewtype" paramvalue="groupmembers"/>
					<ViewAttribute name="P1666541079176_2" attribute="recorduid" variable="latestcampaignrecorduids"/>
				</Action>
				<Action name="U1666521699225" action="executeview" viewname="bwiar_listlatestcampaignpergroup" append="false" attribute="closedate">
					<ViewParam name="P16665216992250" param="campaignids" paramvalue="{dataset.latestcampaignrecorduids}"/>
					<ViewAttribute name="P1666521699225_1" attribute="closedate" variable="closedate"/>
					<ViewAttribute name="P1666521699225_2" attribute="recorduid" variable="recorduid"/>
					<ViewAttribute name="P1666521699225_3" attribute="submissiondate" variable="submissiondate"/>
					<ViewAttribute name="P1666521699225_4" attribute="ticketnumber" variable="ticketnumber"/>
					<ViewAttribute name="P1666521699225_5" attribute="title" variable="title"/>
					<ViewAttribute name="P1666521699225_6" attribute="ownerfullname" variable="ownerfullname"/>
					<ViewAttribute name="P1666521699225_7" attribute="uid" variable="groupuid"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="163" y="348" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1666521715675" priority="1"/>
		<Component name="C1666521715675" type="metadataactivity" x="37" y="173" w="300" h="98" title="repository groups review metadata">
			<Metadata action="C" schema="bwr_repositorygroupmembersreviewstatus">
				<Data date1="closedate" date2="submissiondate" integer3="ticketnumber" string3="title" string4="ownerfullname" integer1="recorduid"/>
				<Application/>
				<Group group1="groupuid"/>
			</Metadata>
		</Component>
		<Link name="L1666521967942" source="C1666521715675" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1666521377154" variable="filterpartialcampaigns" displayname="filter partial campaigns" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="filter partial campaigns (not reviewed &gt; 0)" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A16665216992250" variable="closedate" displayname="closedate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16665216992251" variable="recorduid" displayname="recorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16665216992252" variable="submissiondate" displayname="submissiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16665216992253" variable="ticketnumber" displayname="ticketnumber" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16665216992254" variable="title" displayname="title" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16665216992256" variable="ownerfullname" displayname="ownerfullname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16665410791760" variable="latestcampaignrecorduids" displayname="latestcampaignrecorduids" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A1698222889089" variable="groupuid" displayname="groupuid" editortype="Ledger Group" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1666521380340" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1666521387326" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
