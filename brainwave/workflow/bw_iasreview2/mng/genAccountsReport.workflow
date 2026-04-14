<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_finalizeAccountsReview" statictitle="finalizeAccountsReview" scriptfile="/workflow/bw_iasreview2/mng/genReport.javascript" displayname="{dataset.campaignid}" releaseontimeout="true" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="189" y="79" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
				<Attribute name="description" attribute="generalComment"/>
			</Ticket>
			<Candidates name="role" role="A1626879261678"/>
			<Actions>
				<Action name="U1666364319530" action="executeview" viewname="bwiasr_listcampaignaccountrepositories" append="false" attribute="repositoryuids">
					<ViewParam name="P16663643195300" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1666364319530_1" attribute="uid" variable="repositoryuids"/>
					<ViewAttribute name="P1666364319530_2" attribute="currentdate" variable="currentdates"/>
					<ViewAttribute name="P1666364319530_3" attribute="ownerfullname" variable="ownerfullnames"/>
					<ViewAttribute name="P1666364319530_4" attribute="recorduid" variable="campaignrecorduids"/>
					<ViewAttribute name="P1666364319530_5" attribute="submissiondate" variable="submissiondates"/>
					<ViewAttribute name="P1666364319530_6" attribute="ticketnumber" variable="ticketnumbers"/>
					<ViewAttribute name="P1666364319530_7" attribute="title" variable="campaigntitles"/>
					<ViewAttribute name="P1666364319530_8" attribute="isafullreview" variable="isafullreview"/>
				</Action>
				<Action name="U1666451970290" action="executeview" viewname="bwiasr_campaignaccount_nbnotreviewed" append="false" attribute="nbnotreviewed">
					<ViewParam name="P16664519702900" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1666451970290_1" attribute="nb" variable="nbnotreviewed"/>
				</Action>
				<Action name="U1683196273439" action="executeview" viewname="bwr_getcampaigninstanceadditionalinfos" append="false" attribute="parentmduid">
					<ViewParam name="P16831962734390" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1683196273439_1" attribute="parent_uid" variable="parentmduid"/>
					<ViewAttribute name="P1683196070807_2" attribute="info" variable="info"/>
					<ViewAttribute name="P1683196070807_3" attribute="num" variable="num"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="189" y="702" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="N1626879575821" type="note" x="440" y="77" w="431" h="163" title="Finalize the review campaign:&#xA;"/>
		<Link name="L1627290916197" source="CSTART" target="C1666094619788" priority="1"/>
		<Component name="C1666094619788" type="callactivity" x="62" y="356" w="300" h="98" title="Mark review tickets as the latest ones" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/markLatestAccountReviewStatus.workflow">
				<Input name="A1666094681350" variable="campaignid" content="campaignid"/>
			</Process>
		</Component>
		<Link name="L1666094642667" source="C1666094619788" target="C1666364347216" priority="1" expression="(dataset.isEmpty(&apos;nbnotreviewed&apos;) || dataset.nbnotreviewed.get()==0) &amp;&amp; dataset.isafullreview.get(0).equalsIgnoreCase(&apos;true&apos;)" labelcustom="true" label="Everything has been reviewed"/>
		<Component name="C1666364347216" type="metadataactivity" x="64" y="511" w="300" h="98" title="mark repositories as reviewed (compliant)">
			<Metadata action="C" schema="bwr_repositoryaccountreviewstatus">
				<Repository repository="repositoryuids"/>
				<Data integer3="ticketnumbers" string3="campaigntitles" string4="ownerfullnames" integer1="campaignrecorduids" date2="submissiondates" date1="currentdates"/>
			</Metadata>
		</Component>
		<Link name="L1666364381484" source="C1666364347216" target="CEND" priority="1"/>
		<Link name="L1666452041651" source="C1666094619788" target="CEND" priority="2" labelcustom="true" label="Some entries have not been reviewed"/>
	</Definition>
	<Roles>
		<Role name="A1626879261678" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626879276542" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1626879300618" variable="campaignid" displayname="campaignid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626879328392" variable="TICKETLOG" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="ADHOC_UAR_COMPLIANCE"/>
		<Variable name="A1629982827554" variable="lang" displayname="lang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="en"/>
		<Variable name="A1631289924313" variable="delegationtext" displayname="delegation text" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1645170538684" variable="generalComment" displayname="generalComment" editortype="Default" type="String" multivalued="false" visibility="in" description="general campaign comments" notstoredvariable="true"/>
		<Variable name="A1662041403643" variable="currentstatus" displayname="curentstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="closed" notstoredvariable="true"/>
		<Variable name="A16663643195300" variable="repositoryuids" displayname="repository uids" multivalued="true" visibility="local" type="String" editortype="Ledger Repository"/>
		<Variable name="A16663643195301" variable="currentdates" displayname="current dates" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16663643195302" variable="ownerfullnames" displayname="owner fullnames" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16663643195303" variable="campaignrecorduids" displayname="campaign recorduids" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16663643195304" variable="submissiondates" displayname="submission dates" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16663643195305" variable="ticketnumbers" displayname="ticket numbers" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16663643195306" variable="campaigntitles" displayname="campaign titles" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16664519702900" variable="nbnotreviewed" displayname="nbnotreviewed" multivalued="false" visibility="local" type="Number" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16663643195307" variable="isafullreview" displayname="isafullreview" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1683196219416" variable="parentmduid" displayname="parentmduid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563765805" variable="info" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563773865" variable="num" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<ComplianceReport reportfile="reports/bw_access360/accountsreviewperrepository_compliance.rptdesign" format="PDF" exportname="ComplianceReport_{dataset.campaigntitles.get().replace( &apos;[/\\:?&lt;&gt;&quot;|* ]&apos; ,&quot;_&quot;,&quot;g&quot;)}_{new Date().toLDAPString().substring(0, 8)}" locale="{dataset.lang.get()}">
		<Parameter name="1403" key="campaignid" macrovalue="{dataset.campaignid.get()}"/>
		<Parameter name="1732" key="delegationtext" macrovalue="{dataset.delegationtext.get()}"/>
		<Parameter name="1733" key="generalComment" macrovalue="{dataset.generalComment.get()}"/>
	</ComplianceReport>
</Workflow>
