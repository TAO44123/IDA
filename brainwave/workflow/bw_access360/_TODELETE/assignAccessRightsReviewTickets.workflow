<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_assignAccessRightsReviewTickets" statictitle="assign Access Rights Review Tickets" scriptfile="/workflow/bw_access360/_TODELETE/assignAccessRightsReviewTickets.javascript" description="assign access rights review tickets&#xA;marked as &quot;to be reviewed&quot;, &#xA;accountable is the reviewer by default (marked as well as responsible)" displayname="{dataset.reviewname}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="262" y="101" w="200" h="114" title="Start" compact="true" duedatevariable="deadline" priorityvariable="prioritylevel">
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
			<Candidates name="role" role="A1626341667430"/>
			<Output name="output" ticketactionnumbervariable="TICKETACTION" ticketlogrecorduidvariable="ticketlogrecorduid"/>
			<Actions>
				<Action name="U1626349622017" action="multireplace" attribute="status" newvalue="{dataset.isEmpty(&apos;status&apos;)?&apos;to be reviewed&apos;:dataset.status.get()}"/>
				<Action name="U1699625260913" action="multiresize" attribute="status" attribute1="signofstate"/>
				<Action name="U1699625274533" action="multireplace" attribute="signofstate" newvalue="0"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="262" y="1072" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1662038875374" priority="1"/>
		<Component name="C1626342140458" type="ticketreviewactivity" x="136" y="390" w="300" h="98" title="init review tickets">
			<TicketReview ticketaction="TICKETACTION" ticketaccountables="reviewers" ticketactors="reviewers">
				<Right accountvariable="accounts" permissionvariable="permissions" perimetervariable="perimeters"/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="rightlabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signofstate"/>
			</TicketReview>
		</Component>
		<Link name="L1626342292138" source="C1626342140458" target="C1673008376159" priority="1"/>
		<Component name="N1627047051318" type="note" x="501" y="104" w="554" h="378" title="Create a new ad-hoc review campaign&#xA;custom1 = review type&#xA;custom2 = review timeslotuid&#xA;custom3 = statuspage&#xA;custom4 = reviewpage&#xA;custom5 = finalizepage&#xA;custom6 = offlinemode&#xA;custom7 = selfdelegation&#xA;custom8 = isafullreview (everything is reviewed)&#xA;currentstatus = init, active, pause, finalizing, closed, cancelled&#xA;&#xA;- add metadata to the ticketreviews&#xA;ticketnumber = unique campaign id&#xA;custom1 = printable label&#xA;custom2 = identity characteristics (for later incremental review checks: do not review if already reviewed AND identity position did not changed)&#xA;custom3 = reviewer origin (linemanager, applicationowner,  permissionowner, groupowner, accountowner, repositoryowner, default)&#xA;custom4 = what is reviewed: account, right, ...&#xA;custom5 = entry explicitely reviewed (2 explicitely reviewed and validated, 1 if explicitely reviewed waiting for campaign owner validation,0 or empty otherwise)&#xA;custom6 = entry explicitely reviewed by (name)&#xA;custom7 = entry explicitely reviewed on date)&#xA;&#xA;&#xA;"/>
		<Component name="C1662038875374" type="metadataactivity" x="136" y="211" w="300" h="98" title="add campaign instance additional infos">
			<Metadata action="C" schema="bwr_campaigninstance" master="reviewdefmduid">
				<Data subkey="ticketlogrecorduid" string3="currentstatus"/>
			</Metadata>
		</Component>
		<Link name="L1662038933202" source="C1662038875374" target="C1626342140458" priority="1"/>
		<Component name="C1662039001631" type="variablechangeactivity" x="136" y="715" w="300" h="98" title="change current status variable">
			<Actions>
				<Action name="U1662039028866" action="update" attribute="currentstatus" newvalue="active"/>
			</Actions>
		</Component>
		<Component name="C1662038875374_1" type="metadataactivity" x="136" y="880" w="300" h="98" title="update campaign instance additional infos">
			<Metadata action="C" schema="bwr_campaigninstance" master="reviewdefmduid">
				<Data subkey="ticketlogrecorduid" string3="currentstatus"/>
			</Metadata>
		</Component>
		<Link name="L1662039067803" source="C1662039001631" target="C1662038875374_1" priority="1"/>
		<Link name="L1662039068725" source="C1662038875374_1" target="CEND" priority="1"/>
		<Component name="C1673008376159" type="callactivity" x="136" y="557" w="300" h="98" title="getDummyMetadata">
			<Process workflowfile="/workflow/bw_iasremediation/getDummyMetadata.workflow"/>
		</Component>
		<Link name="L1673008404702" source="C1673008376159" target="C1662039001631" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1626341398710" variable="reviewers" displayname="reviewers" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="reviewers"/>
		<Variable name="A1626341414594" variable="accounts" displayname="accounts" editortype="Ledger Account" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="accounts to review"/>
		<Variable name="A1626341482669" variable="permissions" displayname="permissions" editortype="Ledger Permission" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="permissions to review"/>
		<Variable name="A1626341519045" variable="deadline" displayname="deadline" editortype="Default" type="Date" multivalued="false" visibility="local" description="review expected end date" notstoredvariable="true"/>
		<Variable name="A1626341569386" variable="reviewdescription" displayname="review description" editortype="Default" type="String" multivalued="false" visibility="in" description="review description" notstoredvariable="true"/>
		<Variable name="A1626341664458" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ADHOC_UAR" notstoredvariable="true"/>
		<Variable name="A1626341711597" variable="TICKETACTION" displayname="TICKETACTION" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1626341825508" variable="prioritylevel" displayname="priority level" editortype="Default" type="Number" multivalued="false" visibility="in" description="review priority level" notstoredvariable="true"/>
		<Variable name="A1626349473434" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="in" description="default review status" notstoredvariable="true"/>
		<Variable name="A1626349491240" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="true" visibility="in" description="default review comment" notstoredvariable="true"/>
		<Variable name="A1626446934370" variable="reviewtype" displayname="reviewtype" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626448878105" variable="timeslotuid" displayname="timeslotuid" editortype="Default" type="String" multivalued="false" visibility="in" description="timeslot on which the review has started" notstoredvariable="true"/>
		<Variable name="A1627291521177" variable="identitypositionkeys" displayname="identitypositionkeys" editortype="Default" type="String" multivalued="true" visibility="in" description="a key representing the identity position: internalstatus$$joborg&#xA;useful when identifying at a later time if the identity status/position changed since the review" notstoredvariable="true"/>
		<Variable name="A1627291586800" variable="rightlabels" displayname="right labels" editortype="Default" type="String" multivalued="true" visibility="in" description="A printable label for the ticket review target, useful when the access right no longer exists but you want to display a &quot;full&quot; list of the tickets created at the starting phase of the review" notstoredvariable="true"/>
		<Variable name="A1627396001041" variable="perimeters" displayname="perimeters" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="perimeters to review&#xA;"/>
		<Variable name="A1627563585136" variable="reviewersorigin" displayname="reviewers origin" editortype="Default" type="String" multivalued="true" visibility="in" description="reviewers origin:&#xA;&#x9;linemanager&#xA;&#x9;applicationowner&#xA;&#x9;permissionowner&#xA;&#x9;groupowner&#xA;&#x9;accountowner&#xA;&#x9;repositoryowner&#xA;&#x9;default&#xA;" notstoredvariable="true"/>
		<Variable name="A1630306860645" variable="reviewname" displayname="review name" editortype="Default" type="String" multivalued="false" visibility="in" description="review name" notstoredvariable="true"/>
		<Variable name="A1645039822072" variable="statuspage" displayname="status page" editortype="Default" type="String" multivalued="false" visibility="in" initialvalue="bwaccess360_accessreviewmanagementdetailright" notstoredvariable="true"/>
		<Variable name="A1645181489263" variable="reviewpage" displayname="reviewpage" editortype="Default" type="String" multivalued="false" visibility="in" description="dynamic page, called to perform the review" notstoredvariable="true"/>
		<Variable name="A1645181551692" variable="finalizepage" displayname="finalizepage" editortype="Default" type="String" multivalued="false" visibility="in" description="dynamic page called to finalize the review" notstoredvariable="true"/>
		<Variable name="A1645181733927" variable="offlinemode" displayname="offline mode" editortype="Default" type="String" multivalued="false" visibility="in" description="can be the review be run in offline mode (by sending an attachment)&#xA;RESTRICTED TO RIGHTS REVIEWS FOR NOW&#xA;0 = No&#xA;1 = Yes" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1647846828727" variable="selfdelegation" displayname="selfdelegation" editortype="Default" type="String" multivalued="false" visibility="in" description="Reviewer can self-delegate its entries to stake holders" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1647870373929" variable="remediationtype" displayname="remediationtype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="right" notstoredvariable="true"/>
		<Variable name="A1662038828103" variable="ticketlogrecorduid" displayname="ticketlogrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662038976867" variable="currentstatus" displayname="currentstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="init" notstoredvariable="true"/>
		<Variable name="A1666532683084" variable="isafullreview" displayname="isafullreview" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="is a full (compliant) review" notstoredvariable="true"/>
		<Variable name="A1682863219381" variable="reviewdefmduid" displayname="Review Definition MD uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1699625192645" variable="signofstate" displayname="signofstate" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1626341667430" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626341683716" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
