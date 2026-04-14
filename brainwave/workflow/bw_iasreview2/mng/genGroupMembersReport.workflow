<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_finalizeGroupMembersReview" statictitle="Finalize Group Members Review" scriptfile="workflow/bw_iasreview2/mng/genReport.javascript" technical="true" type="builtin-technical-workflow" displayname="{dataset.campaignid}" releaseontimeout="true">
		<Component name="CSTART" type="startactivity" x="220" y="81" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
				<Attribute name="description" attribute="generalComment"/>
			</Ticket>
			<Candidates name="role" role="A1698050727649"/>
			<Actions>
				<Action name="U1698052677246" action="executeview" viewname="bwiasr_listcampaigngroupmembersrepositories" append="false" attribute="isafullreview">
					<ViewParam name="P16980526772460" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1698052677246_1" attribute="isafullreview" variable="isafullreview"/>
					<ViewAttribute name="P1698052677246_2" attribute="ownerfullname" variable="ownerfullnames"/>
					<ViewAttribute name="P1698052677246_3" attribute="submissiondate" variable="submissiondates"/>
					<ViewAttribute name="P1698052677246_4" attribute="ticketnumber" variable="ticketnumbers"/>
					<ViewAttribute name="P1698052677246_5" attribute="title" variable="campaigntitles"/>
					<ViewAttribute name="P1698052677246_6" attribute="recorduid" variable="campaignrecorduids"/>
					<ViewAttribute name="P1698052677246_7" attribute="currentdate" variable="currentdates"/>
					<ViewAttribute name="P1698052677246_8" attribute="uid" variable="groupuids"/>
				</Action>
				<Action name="U1698053609480" action="executeview" viewname="bwiasr_campaignaccount_nbnotreviewed" append="false" attribute="nbnotreviewed">
					<ViewParam name="P16980536094800" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1698053609480_1" attribute="nb" variable="nbnotreviewed"/>
				</Action>
				<Action name="U1698053720477" action="executeview" viewname="bwr_getcampaigninstanceadditionalinfos" append="false" attribute="parentmduid">
					<ViewParam name="P16980537204770" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1698053720477_1" attribute="parent_uid" variable="parentmduid"/>
					<ViewAttribute name="P1683196070807_2" attribute="info" variable="info"/>
					<ViewAttribute name="P1683196070807_3" attribute="num" variable="num"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="220" y="685" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="N1626879575821_1" type="note" x="443" y="82" w="431" h="163" title="Finalize the group membership review campaign&#xA;"/>
		<Component name="C1698050374020" type="callactivity" x="94" y="360" w="300" h="98" title="Make review tickets as the latest ones" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/markLatestGroupMembersReviewStatus.workflow">
				<Input name="A1698066509502" variable="campaignid" content="campaignid"/>
			</Process>
		</Component>
		<Component name="C1698050387369" type="metadataactivity" x="94" y="517" w="300" h="98" title="Mark repository groups as reviewed (compliance)">
			<Metadata action="C" schema="bwr_repositorygroupmembersreviewstatus">
				<Repository/>
				<Data integer1="campaignrecorduids" date1="currentdates" date2="submissiondates" integer3="ticketnumbers" string3="campaigntitles" string4="ownerfullnames"/>
				<Group group1="groupuids"/>
			</Metadata>
		</Component>
		<Link name="L1698050400903" source="C1698050374020" target="C1698050387369" priority="1" labelcustom="true" label="Everything as been reviewed" expression="(dataset.isEmpty(&apos;nbnotreviewed&apos;) || dataset.nbnotreviewed.get()==0) &amp;&amp; dataset.isafullreview.get(0).equalsIgnoreCase(&apos;true&apos;)"/>
		<Link name="L1698050402430" source="C1698050387369" target="CEND" priority="1"/>
		<Link name="L1698050452720" source="C1698050374020" target="CEND" priority="2" labelcustom="true" label="Some entries have not been reviewed"/>
		<Link name="L1718043769788" source="CSTART" target="C1698050374020" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1698050727649" displayname="owner" description="owner">
			<Rule name="A1698050749102" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1698050805027" variable="TICKETLOG" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ADHOC_UAR_COMPLIANCE" notstoredvariable="true"/>
		<Variable name="A1698050821912" variable="campaignid" displayname="campaignid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698050861103" variable="campaignrecorduids" displayname="campaign recorduids" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698050907440" variable="campaigntitles" displayname="campaign titles" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698050955543" variable="currentdates" displayname="current dates" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698051027790" variable="currentstatus" displayname="currentstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="closed"/>
		<Variable name="A1698051078347" variable="delegationtext" displayname="delegation text" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698051118784" variable="generalComment" displayname="generalComment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="general campaign comments"/>
		<Variable name="A1698051163696" variable="isafullreview" displayname="isafullreview" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698051255736" variable="lang" displayname="lang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="en"/>
		<Variable name="A1698051300048" variable="nbnotreviewed" displayname="nbnotreviewed" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true" description="nb of entries not reviewed"/>
		<Variable name="A1698051338952" variable="ownerfullnames" displayname="owner fullnames" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698051364398" variable="parentmduid" displayname="parentmduid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698051459893" variable="submissiondates" displayname="submission dates" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698051503442" variable="ticketnumbers" displayname="ticket numbers" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698224174307" variable="groupuids" displayname="group uids" editortype="Ledger Group" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563765805" variable="info" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563773865" variable="num" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<ComplianceReport format="PDF" exportname="ComplianceReport_{dataset.campaigntitles.get().replace( &apos;[/\\:?&lt;&gt;&quot;|* ]&apos; ,&quot;_&quot;,&quot;g&quot;)}_{new Date().toLDAPString().substring(0, 8)}" reportfile="reports/bw_access360/groupmembersreviewperrepository_compliance.rptdesign" locale="{dataset.lang.get()}">
		<Parameter name="989" key="campaignid" macrovalue="{dataset.campaignid.get()}"/>
		<Parameter name="990" key="delegationtext" macrovalue="{dataset.delegationtext.get()}"/>
		<Parameter name="991" key="generalComment" macrovalue="{dataset.generalComment.get()}"/>
	</ComplianceReport>
</Workflow>
