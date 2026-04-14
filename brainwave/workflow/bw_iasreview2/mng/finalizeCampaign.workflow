<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_finalizeCampaign" statictitle="Finalize Campaign" scriptfile="workflow/bw_iasreview2/mng/finalizeCampaign.javascript" displayname="Finalize Campaign {dataset.campaignId.get()}" description="Finalizing a Campaign">
		<Component name="CSTART" type="startactivity" x="85" y="-91" w="200" h="114" title="bwr_finalizeCampaign - Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1704215609301"/>
			<Actions function="prepareNotReviewedItems">
			</Actions>
			<FormVariable name="A1704217070455" variable="campaignId" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1704389120343" variable="reviewType" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1704217081390" variable="notReviewedStatus" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1704217090006" variable="notReviewedComment" action="input" mandatory="false" longlist="false"/>
			<Output name="output" startidentityvariable="processActor" startdatevariable="processDate"/>
			<FormVariable name="A1718097813412" variable="finalizeLang" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1718097825070" variable="finalizeComment" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1718097836142" variable="finalizeOnBehalfOf" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1736953784888" variable="stickyTimeslot" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="85" y="1818" w="200" h="98" title="bwr_finalizeCampaign - End" compact="true" inexclusive="true">
			<Actions function="decrementStickyReviewUsageCounter"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1704215489447" priority="1" expression="(dataset.equals(&apos;reviewType&apos;, &apos;account&apos;, false, true)) || (dataset.equals(&apos;reviewType&apos;, &apos;right&apos;, false, true)) || (dataset.equals(&apos;reviewType&apos;, &apos;safe&apos;, false, true)) || (dataset.equals(&apos;reviewType&apos;, &apos;groupmembers&apos;, false, true)) || (dataset.equals(&apos;reviewType&apos;, &apos;servers&apos;, false, true)) || (dataset.equals(&apos;reviewType&apos;, &apos;roles&apos;, false, true))" labelcustom="true" label="IAP Reviews"/>
		<Component name="C1704215489447" type="callactivity" x="-41" y="-20" w="300" h="98" title="1 - Set campaign status to finalizing">
			<Process workflowfile="/workflow/bw_access360/updatecampaigninfos.workflow">
				<Input name="A1704215770113" variable="campaignid" content="campaignId"/>
				<Input name="A1704230375153" variable="currentstatus" content="FINALIZING_STATUS"/>
			</Process>
		</Component>
		<Link name="L1704215674533" source="C1704215489447" target="C1704230413502" priority="1"/>
		<Component name="C1704230413502" type="callactivity" x="-41" y="110" w="300" h="98" title="2b - Force not reviewed tickets to a default status" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1704233464500" variable="ticketreviewrecorduid" content="notReviewedRecorduids"/>
				<Input name="A1704233476764" variable="status" content="notReviewedStatuses"/>
				<Input name="A1704233497813" variable="comment" content="notReviewedComments"/>
				<Input name="A1704233505855" variable="actiondate" content="notReviewedActionDates"/>
			</Process>
		</Component>
		<Link name="L1704233428296" source="C1704230413502" target="C1704279505048" priority="2"/>
		<Component name="C1704273929076" type="callactivity" x="-41" y="255" w="300" h="98" title="3b - Reassign not reviewed entries to the campaign manager when we force the status (implicit delegation)">
			<Process workflowfile="/workflow/bw_access360/reassignAccessRightsReviewTickets.workflow">
				<Input name="A1704274356849" variable="ticketreviewrecorduids" content="notReviewedRecorduids"/>
				<Input name="A1704274823420" variable="reviewer" content="processActor"/>
			</Process>
		</Component>
		<Link name="L1704274858109" source="C1704230413502" target="C1704273929076" priority="1" expression="!dataset.notReviewedStatus.get() == &apos;not reviewed&apos;" labelcustom="true" label="Not reviewed entries status have been forced to Approved or Revoke"/>
		<Link name="L1704276152518" source="C1704273929076" target="C1704279505048" priority="1"/>
		<Component name="C1704279505048" type="variablechangeactivity" x="-41" y="394" w="300" h="98" title="5a - Prepare: mark entries removed since the beginning of the review as revoked" inexclusive="true">
			<Actions function="prepareRemovedItems">
			</Actions>
		</Component>
		<Link name="L1704279559619" source="C1704279505048" target="C1704230413502_1" priority="1"/>
		<Component name="C1704230413502_1" type="callactivity" x="-41" y="535" w="300" h="98" title="5b - Mark entries removed since the beginning of the review as revoked" outexclusive="true">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1704233464500" variable="ticketreviewrecorduid" content="notReviewedRecorduids"/>
				<Input name="A1704233476764" variable="status" content="notReviewedStatuses"/>
				<Input name="A1704233497813" variable="comment" content="notReviewedComments"/>
				<Input name="A1704233505855" variable="actiondate" content="notReviewedActionDates"/>
			</Process>
		</Component>
		<Link name="L1704298695672" source="C1704230413502_1" target="C1704300222517" priority="1"/>
		<Component name="C1704300222517" type="callactivity" x="-41" y="669" w="300" h="98" title="6 - Signoff tickets as reviewed ">
			<Process workflowfile="/workflow/bw_access360/markEntryExplicitelyReviewed.workflow">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704303680903" variable="forcemarkentry" content="TRUE"/>
				<Input name="A1704303756239" variable="currentreviewer" content="processActor"/>
			</Process>
		</Component>
		<Component name="N1626879575821_1" type="note" x="564" y="307" w="394" h="216" title="Finalize Access Rights review campaign&#xA;Single consolidated workflow&#xA;1- update campaign status =  finalizing&#xA;2 - force not reviewed ticket to default status&#xA;3 - reassign not reviewed ticket to campaign owner&#xA;5 - revoke entries removed during campaign&#xA;6 - force signoff by campaign owner for entries not signed off&#xA;7 - generate compliance report&#xA;8 - create remediation tickets from revoke and update entries&#xA;9 - mark all remaining entries as explicitely approved&#xA;10 - update campaign status =  closed&#xA;11 - send notification email to campaign owner&#xA;"/>
		<Component name="C1717928751398" type="variablechangeactivity" x="-41" y="1130" w="300" h="98" title="8a - Prepare: initialize remediation tickets for revoke and update status" inexclusive="true">
			<Actions function="prepareRemediationTickets"/>
		</Component>
		<Component name="C1704300222517_5" type="callactivity" x="-744" y="949" w="300" h="98" title="7b - Account compliance report">
			<Process workflowfile="/workflow/bw_iasreview2/mng/genAccountsReport.workflow" standalone="false">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704304151317" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1704304159990" variable="lang" content="finalizeLang"/>
				<Input name="A1704304224736" variable="generalComment" content="finalizeComment"/>
			</Process>
		</Component>
		<Component name="C1704300222517_6" type="callactivity" x="-349" y="951" w="300" h="98" title="7b - Group members report">
			<Process workflowfile="/workflow/bw_iasreview2/mng/genGroupMembersReport.workflow" standalone="false">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704304151317" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1704304159990" variable="lang" content="finalizeLang"/>
				<Input name="A1704304224736" variable="generalComment" content="finalizeComment"/>
			</Process>
		</Component>
		<Component name="C1704300222517_7" type="callactivity" x="-37" y="957" w="300" h="98" title="7b - App, server or safe rights compliance report">
			<Process workflowfile="/workflow/bw_iasreview2/mng/genAccessRightsReport.workflow" standalone="false">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704304151317" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1704304159990" variable="lang" content="finalizeLang"/>
				<Input name="A1704304224736" variable="generalComment" content="finalizeComment"/>
			</Process>
		</Component>
		<Component name="C1704395748119_1" type="routeactivity" x="-41" y="783" w="300" h="98" compact="false" title="7a - Prepare create a compliance report" outexclusive="true"/>
		<Component name="C1704300222517_8" type="callactivity" x="-41" y="1254" w="300" h="98" title="8 - Init remediation tickets">
			<Process workflowfile="/workflow/bw_access360/createRemediationTickets.workflow">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704321612097" variable="ticketreviewrecorduid" content="rt_recorduid"/>
				<Input name="A1704321712126" variable="status" content="rt_remediationstatus"/>
				<Input name="A1704321732605" variable="ticketclosed" content="rt_remediationclosed"/>
				<Input name="A1704321799694" variable="comment" content="rt_remediationcomment"/>
				<Input name="A1704321818725" variable="ticketlabel" content="rt_label"/>
				<Input name="A1704321837056" variable="tickettype" content="rt_remediationtype"/>
				<Input name="A1704322028222" variable="accountableuid" content="rt_accountableuid"/>
				<Input name="A1704322036310" variable="actiondate" content="rt_actionDate"/>
			</Process>
		</Component>
		<Link name="L1704395780113_1" source="C1704395748119_1" target="C1704300222517_7" priority="3" expression="(dataset.equals(&apos;reviewType&apos;, &apos;right&apos;, false, true) || dataset.equals(&apos;reviewType&apos;, &apos;servers&apos;, false, true) || dataset.equals(&apos;reviewType&apos;, &apos;safe&apos;, false, true))" labelcustom="true" label="right, server, safe review"/>
		<Link name="L1704395906365_1" source="C1704395748119_1" target="C1704300222517_5" priority="1" expression="(dataset.equals(&apos;reviewType&apos;, &apos;account&apos;, false, true))" labelcustom="true" label="account review"/>
		<Link name="L1704396328210_1" source="C1704395748119_1" target="C1704300222517_6" priority="2" expression="(dataset.equals(&apos;reviewType&apos;, &apos;groupmembers&apos;, false, true))" labelcustom="true" label="group review"/>
		<Link name="L1704395594676_1" source="C1704300222517" target="C1704395748119_1" priority="1"/>
		<Link name="L1717930813203" source="C1717928751398" target="C1704300222517_8" priority="1"/>
		<Link name="L1718043100482" source="C1704300222517_5" target="C1717928751398" priority="1"/>
		<Link name="L1718043102282" source="C1704300222517_6" target="C1717928751398" priority="1"/>
		<Link name="L1718043104442" source="C1704300222517_7" target="C1717928751398" priority="1"/>
		<Component name="C1718048593657" type="callactivity" x="-41" y="1387" w="300" h="98" title="9b - Mark all (remaining) entries as explicitely approved">
			<Process workflowfile="/workflow/bw_access360/markAllEntriesExplicitelyProcessed.workflow">
				<Input name="A1718048668397" variable="campaignid" content="campaignId"/>
			</Process>
		</Component>
		<Link name="L1718048672492" source="C1704300222517_8" target="C1718048593657" priority="1"/>
		<Component name="C1716537202092_10" type="callactivity" x="-41" y="1517" w="300" h="98" title="10b - Update campaign status closed">
			<Process workflowfile="/workflow/bw_access360/updatecampaigninfos.workflow">
				<Input name="A1716652693963" variable="currentstatus" content="CLOSED_STATUS"/>
				<Input name="A1718048863905" variable="campaignid" content="campaignId"/>
			</Process>
		</Component>
		<Link name="L1718048823165" source="C1718048593657" target="C1716537202092_10" priority="1"/>
		<Component name="C1716653234804_1" type="mailnotificationactivity" x="-41" y="1641" w="300" h="98" title="11 - Send notification email">
			<Notification name="mail" mail="A1718048930167" ignoreerror="true"/>
		</Component>
		<Link name="L1718048901517" source="C1716537202092_10" target="C1716653234804_1" priority="1"/>
		<Link name="L1718048902913" source="C1716653234804_1" target="CEND" priority="1"/>
		<Component name="C1749738172944" type="callactivity" x="660" y="954" w="300" h="98" title="7b - Custom compliance report">
			<Process workflowfile="/workflow/bw_iasreview2/mng/customComplianceReport.workflow">
				<Input name="A1749738234210" variable="campaignid" content="campaignId"/>
				<Input name="A1749738241767" variable="lang" content="finalizeLang"/>
				<Input name="A1749738248655" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1749738255207" variable="generalComment" content="finalizeComment"/>
			</Process>
		</Component>
		<Link name="L1749738292060" source="C1704395748119_1" target="C1749738172944" priority="5" labelcustom="true" label="custom review"/>
		<Link name="L1749738294174" source="C1749738172944" target="C1717928751398" priority="1"/>
		<Component name="C1745914877127_1" type="callactivity" x="887" y="-116" w="300" h="98" title="Custom Campaign Finalization">
			<Process workflowfile="/workflow/bw_iasreview2/mng/finalizeCustomCampaign.workflow">
				<Input name="A1750165648740" variable="campaignid" content="campaignId"/>
				<Input name="A1750165662280" variable="defaultComment" content="notReviewedComment"/>
				<Input name="A1750165670968" variable="defaultStatus" content="notReviewedStatus"/>
				<Input name="A1750165676900" variable="generalComment" content="finalizeComment"/>
				<Input name="A1750165682460" variable="lang_str" content="finalizeLang"/>
				<Input name="A1750165687052" variable="onbehalfof_str" content="finalizeOnBehalfOf"/>
			</Process>
		</Component>
		<Link name="L1750165406319" source="CSTART" target="C1745914877127_1" priority="2" labelcustom="true" label="Custom campaigns"/>
		<Component name="C1745914907877_1" type="routeactivity" x="1013" y="1818" w="300" h="50" compact="true" title="bwr_finalizeCampaign - Route custom types"/>
		<Link name="L1750165610644" source="C1745914907877_1" target="CEND" priority="1"/>
		<Link name="L1750165614559" source="C1745914877127_1" target="C1745914907877_1" priority="1"/>
		<Component name="C1704300222517_9" type="callactivity" x="286" y="934" w="300" h="98" title="7b - Role review Metadata">
			<Process workflowfile="/workflow/bw_iasreview2/mng/computeRoleMetadata.workflow" standalone="false">
				<Input name="A1704302578356" variable="campaignid" content="campaignId"/>
				<Input name="A1704304151317" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1704304159990" variable="lang" content="finalizeLang"/>
				<Input name="A1704304224736" variable="generalComment" content="finalizeComment"/>
				<Output name="A1765191783212" variable="campaigntitles" content="campaigntitle"/>
			</Process>
		</Component>
		<Link name="L1765185194462" source="C1704395748119_1" target="C1704300222517_9" priority="4" expression="(dataset.equals(&apos;reviewType&apos;, &apos;roles&apos;, false, true))" labelcustom="true" label="role review"/>
		<Component name="C1765186181670" type="callactivity" x="283" y="1038" w="300" h="98" title="7c - Generic Compliance Report">
			<Process workflowfile="/workflow/bw_iasreview2/mng/genGenericReport.workflow">
				<Input name="A1765191954191" variable="campaignid" content="campaignId"/>
				<Input name="A1765191964091" variable="campaigntitles" content="campaigntitle"/>
				<Input name="A1765191992802" variable="delegationtext" content="finalizeOnBehalfOf"/>
				<Input name="A1765192000222" variable="generalComment" content="finalizeComment"/>
				<Input name="A1765192007034" variable="lang" content="finalizeLang"/>
			</Process>
		</Component>
		<Link name="L1765192022963" source="C1704300222517_9" target="C1765186181670" priority="1"/>
		<Link name="L1765192024414" source="C1765186181670" target="C1717928751398" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1704378475233" variable="reviewType" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" displayname="Review Type" description="Review Type">
		</Variable>		
		<Variable name="A1704215566943" variable="campaignId" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true" displayname="Campaign Identifier" description="Campaign Identifier"/>
		<Variable name="A1704216046742" variable="notReviewedStatus" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" syncname="" displayname="Not Reviewed Status" description="Not Reviewed Status">
			<StaticValue name="not reviewed"/>
			<StaticValue name="ok"/>
			<StaticValue name="revoke"/>
		</Variable>
		<Variable name="A1704216067394" variable="notReviewedComment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" syncname="" initialvalue="Entry finalized by the campaign owner" displayname="Not Reviewed Comment" description="Not Reviewed Comment"/>
		<Variable name="A1704216109498" variable="notReviewedRecorduids" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true" syncname="S1704216117420"/>
		<Variable name="S1704216117420" variable="notReviewed" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1704216336546" variable="notReviewedActionDates" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1704216117420" notstoredvariable="true"/>
		<Variable name="A1704230138232" variable="notReviewedStatuses" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704216117420" notstoredvariable="true"/>
		<Variable name="A1704230226792" variable="notReviewedComments" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704216117420" notstoredvariable="true"/>
		<Variable name="A1704230366038" variable="FINALIZING_STATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="finalizing" notstoredvariable="true" displayname="Campaign Finalizing Status" description="Campaign Finalizing Status"/>
		<Variable name="A1704274497499" variable="processActor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true" displayname="Process Actor" description="Process Actor"/>
		<Variable name="A1704286639992" variable="processDate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true" displayname="Process Start Date" description="Process Start Date"/>
		<Variable name="A1704302722587" variable="TRUE" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="true"/>
		<Variable name="S1704321110114" variable="remediationTicket" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1704321157305" variable="rt_recorduid" editortype="Default" type="Number" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321185592" variable="rt_remediationstatus" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321211679" variable="rt_remediationclosed" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321236284" variable="rt_remediationcomment" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321251682" variable="rt_label" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321269970" variable="rt_remediationtype" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321897385" variable="rt_actionDate" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1704321942388" variable="rt_accountableuid" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" syncname="S1704321110114" notstoredvariable="true"/>
		<Variable name="A1717930719333" variable="finalizeComment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" displayname="Finalization Comment" description="Finalization Comment"/>
		<Variable name="A1717930755066" variable="finalizeLang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="en" displayname="Finalization Language" description="Finalization Language">
			<StaticValue name="en"/>
			<StaticValue name="fr"/>
		</Variable>
		<Variable name="A1717930793197" variable="finalizeOnBehalfOf" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue=" On behalf of " displayname="Finalization On Behalf Of" description="Finalization On Behalf Of label"/>
		<Variable name="A1718048788437" variable="CLOSED_STATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="closed" notstoredvariable="true" displayname="Campaign Closed Status" description="Campaign Closed Status"/>
		<Variable name="A1736944523458" variable="stickyTimeslot" displayname="sticky timeslot" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="The campaigns sticks to the timeslot it was launched on"/>
		<Variable name="A1765191766042" variable="campaigntitle" displayname="campaigntitle" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1704215609301" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1704215630065" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
		<Role name="A1718099746832" description="processactor" displayname="processactor">
			<Variable name="A1718099752790" variable="processActor"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1718048930167" displayname="Access Review Finalized" description="Access Review Finalized" torole="A1718099746832" notifyrule="bwaccess360r_accessreviewperapplicationfinalized" tolist=""/>
	</Mails>
</Workflow>
