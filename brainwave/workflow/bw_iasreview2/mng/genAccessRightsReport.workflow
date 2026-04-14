<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_finalizeAccessRightsReview" statictitle="finalizeAccessRightsReview" scriptfile="workflow/bw_iasreview2/mng/genReport.javascript" displayname="{dataset.campaignid}" releaseontimeout="true" technical="true" type="builtin-technical-workflow" description="WARNING: Instance Title MUST BE equal to campaignid">
		<Component name="CSTART" type="startactivity" x="207" y="79" w="200" h="114" title="bwaccess360_finalizeAccessRightsReview - Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
				<Attribute name="description" attribute="generalComment"/>
			</Ticket>
			<Candidates name="role" role="A1626879261678"/>
			<Actions>
				<Action name="U1666364319530" action="executeview" viewname="bwiasr_listcampaignrightapplications" append="false" attribute="currentdates">
					<ViewParam name="P16663643195300" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1666364319530_1" attribute="currentdate" variable="currentdates"/>
					<ViewAttribute name="P1666364319530_2" attribute="ownerfullname" variable="ownerfullnames"/>
					<ViewAttribute name="P1666364319530_3" attribute="recorduid" variable="campaignrecorduids"/>
					<ViewAttribute name="P1666364319530_4" attribute="submissiondate" variable="submissiondates"/>
					<ViewAttribute name="P1666364319530_5" attribute="ticketnumber" variable="ticketnumbers"/>
					<ViewAttribute name="P1666364319530_6" attribute="title" variable="campaigntitles"/>
					<ViewAttribute name="P1666364319530_7" attribute="isafullreview" variable="isafullreview"/>
					<ViewAttribute name="P1666364319530_8" attribute="uid" variable="applicationuids"/>
				</Action>
				<Action name="U1666451970290" action="executeview" viewname="bwiasr_campaignaccount_nbnotreviewed" append="false" attribute="nbnotreviewed">
					<ViewParam name="P16664519702900" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1666451970290_1" attribute="nb" variable="nbnotreviewed"/>
				</Action>
				<Action name="U1683196070807" action="executeview" viewname="bwr_getcampaigninstanceadditionalinfos" append="false" attribute="parentmduid">
					<ViewParam name="P16831960708070" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1683196070807_1" attribute="parent_uid" variable="parentmduid"/>
					<ViewAttribute name="P1683196070807_2" attribute="info" variable="info"/>
					<ViewAttribute name="P1683196070807_3" attribute="num" variable="num"/>
				</Action>
			</Actions>
			<FormVariable name="A1702566961032" variable="campaignid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1704827435711" variable="delegationtext" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1704827448895" variable="generalComment" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="207" y="767" w="200" h="98" title="bwaccess360_finalizeAccessRightsReview - End" compact="true" inexclusive="true"/>
		<Component name="N1626879575821" type="note" x="440" y="77" w="431" h="163" title="Finalize the review campaign:&#xA;"/>
		<Component name="C1666099464540" type="callactivity" x="81" y="357" w="300" h="98" title="mark tickets as the latest ones" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/markLatestRightReviewStatus.workflow">
				<Input name="A1666099519050" variable="campaignid" content="campaignid"/>
			</Process>
		</Component>
		<Link name="L1666099527908" source="C1666099464540" target="C1666364347216_1" priority="1" expression="(dataset.isEmpty(&apos;nbnotreviewed&apos;) || dataset.nbnotreviewed.get()==0) &amp;&amp; dataset.isafullreview.get(0).equalsIgnoreCase(&apos;true&apos;)" labelcustom="true" label="Everything has been reviewed"/>
		<Component name="C1666364347216_1" type="metadataactivity" x="81" y="566" w="300" h="98" title="mark applications as reviewed (compliant)">
			<Metadata action="C" schema="bwr_applicationrightreviewstatus">
				<Repository/>
				<Data integer3="ticketnumbers" string3="campaigntitles" string4="ownerfullnames" integer1="campaignrecorduids" date2="submissiondates" date1="currentdates"/>
				<Application application="applicationuids"/>
			</Metadata>
		</Component>
		<Link name="L1666533507580" source="C1666364347216_1" target="CEND" priority="1"/>
		<Link name="L1666533517795" source="C1666099464540" target="CEND" priority="2" labelcustom="true" label="Some entries have not been reviewed"/>
		<Link name="L1717764130421" source="CSTART" target="C1666099464540" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1626879261678" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626879276542" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1626879300618" variable="campaignid" displayname="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626879328392" variable="TICKETLOG" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="ADHOC_UAR_COMPLIANCE"/>
		<Variable name="A1629982827554" variable="lang" displayname="lang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="en"/>
		<Variable name="A1631289924313" variable="delegationtext" displayname="delegation text" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1645170538684" variable="generalComment" displayname="generalComment" editortype="Default" type="String" multivalued="false" visibility="in" description="general campaign comments" notstoredvariable="true"/>
		<Variable name="A1662041403643" variable="currentstatus" displayname="curentstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="closed" notstoredvariable="true"/>
		<Variable name="A16663643195301" variable="currentdates" displayname="current dates" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16663643195302" variable="ownerfullnames" displayname="owner fullnames" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16663643195303" variable="campaignrecorduids" displayname="campaign recorduids" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16663643195304" variable="submissiondates" displayname="submission dates" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16663643195305" variable="ticketnumbers" displayname="ticket numbers" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16663643195306" variable="campaigntitles" displayname="campaign titles" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1666532941666" variable="nbnotreviewed" displayname="nbnotreviewed" editortype="Default" type="Number" multivalued="false" visibility="local" description="nb of entries not reviewed" notstoredvariable="true"/>
		<Variable name="A16663643195307" variable="isafullreview" displayname="isafullreview" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1666533424499" variable="applicationuids" displayname="applicationuids" editortype="Ledger Application" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1683196007576" variable="parentmduid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563765805" variable="info" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702563773865" variable="num" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<ComplianceReport reportfile="reports/bw_access360/accessrightsreviewperapplication_compliance.rptdesign" format="PDF" locale="{dataset.lang.get()}" exportname="ComplianceReport_{dataset.campaigntitles.get().replace( &apos;[/\\:?&lt;&gt;&quot;|* ]&apos; ,&quot;_&quot;,&quot;g&quot;)}_{new Date().toLDAPString().substring(0, 8)}">
		<Parameter name="1403" key="campaignid" macrovalue="{&quot;&quot;+dataset.campaignid.get()}"/>
		<Parameter name="1732" key="delegationtext" macrovalue="{dataset.delegationtext.get()}"/>
		<Parameter name="1733" key="generalComment" macrovalue="{dataset.generalComment.get()}"/>
	</ComplianceReport>
</Workflow>
