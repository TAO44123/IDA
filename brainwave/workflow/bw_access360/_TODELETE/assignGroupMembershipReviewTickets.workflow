<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_assignGroupMembershipReviewTickets" statictitle="Assign Group Membership Review Tickets" scriptfile="/workflow/bw_access360/_TODELETE/assignGroupMembershipReviewTickets.javascript" description="assign group review tickets&#xA;marked as &quot;to be reviewed&quot;, &#xA;accountable is the reviewer by default (marked as well as responsible)" technical="true" type="builtin-technical-workflow" displayname="{dataset.reviewname}">
		<Component name="CSTART" type="startactivity" x="140" y="85" w="200" h="114" title="Start" compact="true" duedatevariable="deadline" priorityvariable="prioritylevel">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="reviewdescription"/>
				<Attribute name="custom1" attribute="reviewtype"/>
				<Attribute name="custom2" attribute="timeslotuid"/>
				<Attribute name="custom3" attribute="statuspage"/>
				<Attribute name="custom4" attribute="reviewpage"/>
				<Attribute name="custom5" attribute="finalizepage"/>
				<Attribute name="custom6" attribute="offlinemode"/>
				<Attribute name="custom7" attribute="selfdelegation"/>
				<Attribute name="custom8" attribute="isafullreview"/>
			</Ticket>
			<Candidates name="role" role="A1697539371395"/>
			<Actions>
				<Action name="U1697546766936" action="multireplace" attribute="status" newvalue="{dataset.isEmpty(&apos;status&apos;)?&apos;to be reviewed&apos;:dataset.status.get()}"/>
				<Action name="U1699625260913" action="multiresize" attribute="status" attribute1="signofstate"/>
				<Action name="U1699625274533" action="multireplace" attribute="signofstate" newvalue="0"/>
			</Actions>
			<Output name="output" ticketactionnumbervariable="TICKETACTION" ticketlogrecorduidvariable="ticketlogrecorduid"/>
		</Component>
		<Component name="CEND" type="endactivity" x="140" y="1059" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1697546436975" priority="1"/>
		<Component name="N1627047051318_1" type="note" x="417" y="102" w="554" h="378" title="Create a new ad-hoc review campaign&#xA;custom1 = review type&#xA;custom2 = review timeslotuid&#xA;custom3 = statuspage&#xA;custom4 = reviewpage&#xA;custom5 = finalizepage&#xA;custom6 = offlinemode&#xA;custom7 = selfdelegation&#xA;custom8 = isafullreview (everything is reviewed)&#xA;currentstatus = init, active, pause, finalizing, closed, cancelled&#xA;&#xA;- add metadata to the ticketreviews&#xA;ticketnumber = unique campaign id&#xA;custom1 = printable label&#xA;custom2 = identity characteristics (for later incremental review checks: do not review if already reviewed AND identity position did not changed)&#xA;custom3 = reviewer origin (linemanager, groupowner, accountowner, repositoryowner, default)&#xA;custom4 = what is reviewed: account, right, ...&#xA;custom5 = entry explicitely reviewed (2 explicitely reviewed and validated, 1 if explicitely reviewed waiting for campaign owner validation,0 or empty otherwise)&#xA;custom6 = entry explicitely reviewed by (name)&#xA;custom7 = entry explicitely reviewed on date)&#xA;&#xA;&#xA;"/>
		<Component name="C1697546436975" type="metadataactivity" x="14" y="197" w="300" h="98" title="add campaign instance additional infos">
			<Metadata action="C" master="reviewdefmduid" schema="bwr_campaigninstance">
				<Data subkey="ticketlogrecorduid" string3="currentstatus"/>
			</Metadata>
		</Component>
		<Component name="C1697546458486" type="ticketreviewactivity" x="14" y="378" w="300" h="98" title="init review tickets">
			<TicketReview ticketaction="TICKETACTION" ticketactors="reviewers" ticketaccountables="reviewers">
				<AccountGroup parentgroupvariable="groups" accountvariable="accounts"/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="grouplabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signofstate"/>
			</TicketReview>
		</Component>
		<Component name="C1697546484242" type="callactivity" x="14" y="552" w="300" h="98" title="getDummyMetadata">
			<Process workflowfile="/workflow/bw_iasremediation/getDummyMetadata.workflow"/>
		</Component>
		<Component name="C1697546509026" type="variablechangeactivity" x="14" y="725" w="300" h="98" title="change current status variable">
			<Actions>
				<Action name="U1697547899910" action="update" attribute="currentstatus" newvalue="active"/>
			</Actions>
		</Component>
		<Component name="C1697546531846" type="metadataactivity" x="14" y="889" w="300" h="98" title="update campaign instance additional infos">
			<Metadata action="C" master="reviewdefmduid" schema="bwr_campaigninstance">
				<Data subkey="ticketlogrecorduid" string3="currentstatus"/>
			</Metadata>
		</Component>
		<Link name="L1697546627374" source="C1697546436975" target="C1697546458486" priority="1"/>
		<Link name="L1697546631297" source="C1697546458486" target="C1697546484242" priority="1"/>
		<Link name="L1697546633979" source="C1697546484242" target="C1697546509026" priority="1"/>
		<Link name="L1697546636765" source="C1697546509026" target="C1697546531846" priority="1"/>
		<Link name="L1697546638335" source="C1697546531846" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1697539371395" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1697539403431" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1697539440336" variable="TICKETACTION" displayname="TICKETACTION" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1697539472662" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="ADHOC_UAR"/>
		<Variable name="A1697539501056" variable="accounts" displayname="accounts" editortype="Ledger Account" type="String" multivalued="true" visibility="in" description="accounts to review&#xA;" notstoredvariable="true"/>
		<Variable name="A1697539550459" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="true" visibility="in" description="default review comment" notstoredvariable="true"/>
		<Variable name="A1697539598528" variable="currentstatus" displayname="currentstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="init" notstoredvariable="true"/>
		<Variable name="A1697539645786" variable="deadline" displayname="deadline" editortype="Default" type="Date" multivalued="false" visibility="local" description="review expected end date" notstoredvariable="true"/>
		<Variable name="A1697539675835" variable="finalizepage" displayname="finalizepage" editortype="Default" type="String" multivalued="false" visibility="in" description="dynamic page called to finalize the review" notstoredvariable="true"/>
		<Variable name="A1697539722342" variable="identitypositionkeys" displayname="identitypositionkeys" editortype="Default" type="String" multivalued="true" visibility="in" description="a key representing the identity position: internalstatus$$joborg&#xA;useful when identifying at a later time if the identity status/position changed since the review" notstoredvariable="true"/>
		<Variable name="A1697539756365" variable="isafullreview" displayname="isafullreview" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="is a full (compliant) review" notstoredvariable="true"/>
		<Variable name="A1697539795623" variable="offlinemode" displayname="offline mode" editortype="Default" type="String" multivalued="false" visibility="in" description="can be the review be run in offline mode (by sending an attachment)&#xA;RESTRICTED TO RIGHTS REVIEWS FOR NOW&#xA;0 = No&#xA;1 = Yes" notstoredvariable="true" initialvalue="0"/>
		<Variable name="A1697539885917" variable="groups" displayname="groups" editortype="Ledger Group" type="String" multivalued="true" visibility="in" description="groups to review" notstoredvariable="true"/>
		<Variable name="A1697539942881" variable="prioritylevel" displayname="priority level" editortype="Default" type="Number" multivalued="false" visibility="in" description="review priority level" notstoredvariable="true"/>
		<Variable name="A1697540020799" variable="remediationtype" displayname="remediationtype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="groupmembers" notstoredvariable="true"/>
		<Variable name="A1697540074273" variable="reviewdefmduid" displayname="Review Definition MD uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1697540105676" variable="reviewdescription" displayname="review description" editortype="Default" type="String" multivalued="false" visibility="in" description="review description" notstoredvariable="true"/>
		<Variable name="A1697540140705" variable="reviewers" displayname="reviewers" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="reviewers"/>
		<Variable name="A1697540244187" variable="reviewersorigin" displayname="reviewers origin" editortype="Default" type="String" multivalued="true" visibility="in" description="reviewers origin:&#xA;&#x9;linemanager&#xA;&#x9;groupowner&#xA;&#x9;accountowner&#xA;&#x9;repositoryowner&#xA;&#x9;default&#xA;" notstoredvariable="true"/>
		<Variable name="A1697540275429" variable="reviewname" displayname="review name" editortype="Default" type="String" multivalued="false" visibility="in" description="review name" notstoredvariable="true"/>
		<Variable name="A1697540310368" variable="reviewpage" displayname="review page" editortype="Default" type="String" multivalued="false" visibility="in" description="dynamic page, called to perform the review" notstoredvariable="true"/>
		<Variable name="A1697540330037" variable="reviewtype" displayname="review type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1697540404694" variable="grouplabels" displayname="group labels" editortype="Default" type="String" multivalued="true" visibility="in" description="A printable label for the ticket review target, useful when the group no longer exists but you want to display a &quot;full&quot; list of the tickets created at the starting phase of the review" notstoredvariable="true"/>
		<Variable name="A1697540449048" variable="selfdelegation" displayname="selfdelegation" editortype="Default" type="String" multivalued="false" visibility="in" description="Reviewer can self-delegate its entries to stake holders" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1697540482378" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="in" description="default review status" notstoredvariable="true"/>
		<Variable name="A1697540517450" variable="statuspage" displayname="status page" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="bwaccess360_groupmembersreviewmanagementdetail"/>
		<Variable name="A1697540677560" variable="ticketlogrecorduid" displayname="ticketlogrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1697540704597" variable="timeslotuid" displayname="timeslotuid" editortype="Default" type="String" multivalued="false" visibility="in" description="timeslot on which the review has started" notstoredvariable="true"/>
		<Variable name="A1699625192645" variable="signofstate" displayname="signofstate" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
