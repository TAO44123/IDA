<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwir_start_review_instance" statictitle="Start a review instance" scriptfile="/workflow/bw_iasreview2/mng/startReviewInstance.javascript" description="assign review tickets&#xA;marked as &quot;to be reviewed&quot;, &#xA;accountable is the reviewer by default (marked as well as responsible)&#xA;params: &#xA;- reviewdefmduid:  uid of the review campaign to start&#xA;- timeslotuid: timeslot to resolve the perimeter only ( pass null for current timeslot)" displayname="{dataset.reviewname.get()} #{dataset.inst_num.get()}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="418" y="-9" w="200" h="114" title="bwir_start_review_instance - Start" compact="true" duedatevariable="deadline" priorityvariable="prioritylevel">
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
				<Attribute name="custom9" attribute="reviewdefmduid"/>
				<Attribute name="custom10" attribute="stickyTimeslot"/>
				<Attribute name="custom11" attribute="stickyTimeslotLabel"/>
			</Ticket>
			<Candidates name="role" role="A1626341667430"/>
			<Output name="output" ticketactionnumbervariable="ticketActionNumber" ticketlogrecorduidvariable="ticketlogrecorduid" startdatevariable="startDate"/>
			<Actions function="init">
			</Actions>
			<FormVariable name="A1701617131260" variable="timeslotuid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1701630332319" variable="reviewdefmduid" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="421" y="908" w="200" h="98" title="bwir_start_review_instance - End" compact="true" inexclusive="true">
			<Actions function="incrementStickyCampaignUsageCounter"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1662038875374" priority="1"/>
		<Component name="C1626342140458" type="ticketreviewactivity" x="-32" y="329" w="300" h="98" title="init review tickets safe, server and rights">
			<TicketReview ticketaction="ticketActionNumber" ticketaccountables="reviewers" ticketactors="reviewers">
				<Right accountvariable="accounts" permissionvariable="permissions" perimetervariable="perimeters"/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="rightlabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signoffstate"/>
				<Attribute name="custom10" attribute="ai_preapproved"/>
				<Attribute name="custom11" attribute="ai_anomalous"/>
				<Attribute name="custom12" attribute="ai_clustersid"/>				
				<Attribute name="custom13" attribute="ai_firstclusterid"/>
				<Attribute name="custom14" attribute="ai_maxclusterid"/>
			</TicketReview>
		</Component>
		<Link name="L1626342292138" source="C1626342140458" target="C1673008376159" priority="1"/>
		<Component name="N1627047051318" type="note" x="1002" y="83" w="554" h="490" title="ticketlogrecorduid is the recorduid of the campaign instance&#xA;&#xA;Create a new ad-hoc review campaign&#xA;custom1 = review type&#xA;custom2 = review timeslotuid&#xA;custom3 = statuspage&#xA;custom4 = reviewpage&#xA;custom5 = finalizepage&#xA;custom6 = offlinemode&#xA;custom7 = selfdelegation&#xA;custom8 = isafullreview (everything is reviewed)&#xA;custom9 = review def uid&#xA;custom10 = sticky timeslot&#xA;custom11 = stick timeslot label&#xA;currentstatus = init, active, pause, finalizing, closed, cancelled&#xA;&#xA;- add metadata to the ticketreviews&#xA;ticketnumber = unique campaign id&#xA;custom1 = printable label&#xA;custom2 = identity characteristics (for later incremental review checks: do not review if already reviewed AND identity position did not changed)&#xA;custom3 = reviewer origin (linemanager, applicationowner,  permissionowner, groupowner, accountowner, repositoryowner, default)&#xA;custom4 = what is reviewed: account, right, ...&#xA;custom5 = entry explicitely reviewed (2 explicitely reviewed and validated, 1 if explicitely reviewed waiting for campaign owner validation,0 or empty otherwise)&#xA;custom6 = entry explicitely reviewed by (name)&#xA;custom7 = entry explicitely reviewed on date)&#xA;&#xA;custom10 = ai_preprocessed ( P|A| &apos;&apos;)&#xA;custom11 = ai_anomalous ( L|D| &apos;&apos; )&#xA;custom12 = ai_clustersId ( string, comma separated list of clusters&#xA;custom13 = ai_firstclusterId ( string)&#xA;custom14 = ai_maxclusterId ( string)&#xA;&#xA;&#xA;&#xA;"/>
		<Component name="C1662038875374" type="metadataactivity" x="279" y="61" w="329" h="98" title="add campaign instance additional infos with init status">
			<Metadata action="C" schema="bwr_campaigninstance" master="reviewdefmduid">
				<Data subkey="ticketlogrecorduid" string3="currentstatus" integer1="inst_num" details="inst_info" integer2="ticketlogrecorduid"/>
			</Metadata>
		</Component>
		<Link name="L1662038933202" source="C1662038875374" target="C1701630926475" priority="1"/>
		<Component name="C1662038875374_1" type="metadataactivity" x="290" y="637" w="300" h="98" title="update campaign instance status" outexclusive="true">
			<Metadata action="C" schema="bwr_campaigninstance" master="reviewdefmduid">
				<Data subkey="ticketlogrecorduid" string3="currentstatus" integer1="inst_num" details="inst_info" integer2="ticketlogrecorduid"/>
			</Metadata>
		</Component>
		<Component name="C1673008376159" type="callactivity" x="291" y="490" w="300" h="98" title="getDummyMetadata" inexclusive="true">
			<Process workflowfile="/workflow/bw_iasremediation/getDummyMetadata.workflow" standalone="false"/>
		</Component>
		<Link name="L1673008404702" source="C1673008376159" target="C1662038875374_1" priority="1"/>
		<Component name="C1701630926475" type="scriptactivity" x="292" y="183" w="300" h="98" title="compute review params" outexclusive="true">
			<Script onscriptexecute="computeReviewParams"/>
		</Component>
		<Link name="L1701630984414" source="C1701630926475" target="C1626342140458" priority="3" expression="(dataset.equals(&apos;reviewtype&apos;, &apos;right&apos;, false, true) || dataset.equals(&apos;reviewtype&apos;, &apos;servers&apos;, false, true) || dataset.equals(&apos;reviewtype&apos;, &apos;safe&apos;, false, true))" labelcustom="true" label="right, server, safe review"/>
		<Link name="L1704200666578" source="C1662038875374_1" target="C1718193212623" priority="1" expression="dataset.sendNotifications.get()"/>
		<Component name="C1626342140458_1" type="ticketreviewactivity" x="665" y="329" w="300" h="98" title="init review tickets groups links">
			<TicketReview ticketaction="ticketActionNumber" ticketaccountables="reviewers" ticketactors="reviewers">
				<Right/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="rightlabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signoffstate"/>
				<AccountGroup accountvariable="accounts" parentgroupvariable="groups"/>
			</TicketReview>
		</Component>
		<Link name="L1713449215218" source="C1701630926475" target="C1626342140458_1" priority="1" expression="(dataset.equals(&apos;reviewtype&apos;, &apos;groupmembers&apos;, false, true))" labelcustom="true" label="group link review"/>
		<Link name="L1713449217973" source="C1626342140458_1" target="C1673008376159" priority="1"/>
		<Component name="C1626342140458_2" type="ticketreviewactivity" x="295" y="329" w="300" h="98" title="init review tickets account">
			<TicketReview ticketaction="ticketActionNumber" ticketaccountables="reviewers" ticketactors="reviewers">
				<Right/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="rightlabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signoffstate"/>
				<AccountGroup accountvariable="accounts" parentgroupvariable="groups"/>
				<Account accountvariable="accounts"/>
			</TicketReview>
		</Component>
		<Link name="L1713450926015" source="C1701630926475" target="C1626342140458_2" priority="2" expression="(dataset.equals(&apos;reviewtype&apos;, &apos;account&apos;, false, true))" labelcustom="true" label="account review"/>
		<Link name="L1713450927555" source="C1626342140458_2" target="C1673008376159" priority="1"/>
		<Link name="L1703859685258" source="C1718193212623" target="CEND" priority="1"/>
		<Component name="C1718193212623" type="callactivity" x="330" y="777" w="227" h="98" title="send initial notifications to reviewers">
			<Process workflowfile="/workflow/bw_iasreview2/mng/sendNotificationToReviewers.workflow">
				<Input name="A1718193280232" variable="campaignId" content="ticketlogrecorduid"/>
			</Process>
		</Component>
		<Link name="L1718205517021" source="C1662038875374_1" target="CEND" priority="2"/>
		<Component name="C1748355895708" type="callactivity" x="-713" y="330" w="300" h="98" title="Custom Review">
			<Process workflowfile="/workflow/bw_iasreview2/mng/customReview.workflow">
				<Input name="A1748362406867" variable="inst_num" content="inst_num"/>
				<Input name="A1748362420487" variable="reviewdefmduid" content="reviewdefmduid"/>
				<Input name="A1748362491031" variable="timeslotuid" content="timeslotuid"/>
				<Input name="A1748362518791" variable="reviewpage" content="reviewpage"/>
				<Input name="A1748426537665" variable="isafullreview" content="isafullreview"/>
				<Input name="A1748426547866" variable="offlinemode" content="offlinemode"/>
				<Input name="A1748426559931" variable="selfdelegation" content="selfdelegation"/>
				<Input name="A1748426583616" variable="ticketActionNumber" content="ticketActionNumber"/>
				<Input name="A1748426591005" variable="ticketlogrecorduid" content="ticketlogrecorduid"/>
				<Input name="A1748850620134" variable="reviewname" content="reviewname"/>
			</Process>
		</Component>
		<Link name="L1748356015078" source="C1701630926475" target="C1748355895708" priority="5" labelcustom="true" label="Custom reviews"/>
		<Link name="L1748356018976" source="C1748355895708" target="C1673008376159" priority="1"/>
		<Component name="C1764670657629" type="ticketreviewactivity" x="-383" y="328" w="300" h="98" title="init review ticket role">
		<TicketReview ticketaction="ticketActionNumber" ticketaccountables="reviewers" ticketactors="reviewers">
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="rightlabels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Attribute name="custom4" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="signoffstate"/>
			<RawPermLink perimetervariable="perimeters" permissionvariable="permissions" parentpermissionvariable="parent_permissions"/>
		</TicketReview>
		</Component>
		<Link name="L1764670694191" source="C1701630926475" target="C1764670657629" priority="4" expression="dataset.equals(&apos;reviewtype&apos;, &apos;roles&apos;, false, true)" labelcustom="true" label="role review"/>
		<Link name="L1764670696558" source="C1764670657629" target="C1673008376159" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1626448878105" variable="timeslotuid" displayname="timeslotuid" editortype="Default" type="String" multivalued="false" visibility="in" description="timeslot on which the review has started" notstoredvariable="true"/>
		<Variable name="A1626341398710" variable="reviewers" displayname="reviewers" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="reviewers" syncname="S1701616665841"/>
		<Variable name="A1626341414594" variable="accounts" displayname="accounts" editortype="Ledger Account" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="accounts to review" syncname="S1701616665841"/>
		<Variable name="A1626341482669" variable="permissions" displayname="permissions" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="permissions to review" syncname="S1701616665841"/>
		<Variable name="A1626341519045" variable="deadline" displayname="deadline" editortype="Default" type="Date" multivalued="false" visibility="local" description="review expected end date" notstoredvariable="true"/>
		<Variable name="A1626341569386" variable="reviewdescription" displayname="review description" editortype="Default" type="String" multivalued="false" visibility="local" description="review description" notstoredvariable="true"/>
		<Variable name="A1626341664458" variable="TICKETTYPE" displayname="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ADHOC_UAR" notstoredvariable="true"/>
		<Variable name="A1626341711597" variable="ticketActionNumber" displayname="ticketActionNumber" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1626341825508" variable="prioritylevel" displayname="priority level" editortype="Default" type="Number" multivalued="false" visibility="local" description="review priority level" notstoredvariable="true"/>
		<Variable name="A1626349473434" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="local" description="default review status" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1626349491240" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="true" visibility="local" description="default review comment" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1626446934370" variable="reviewtype" displayname="reviewtype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627291521177" variable="identitypositionkeys" displayname="identitypositionkeys" editortype="Default" type="String" multivalued="true" visibility="local" description="a key representing the identity position: internalstatus$$joborg&#xA;useful when identifying at a later time if the identity status/position changed since the review" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1627291586800" variable="rightlabels" displayname="right labels" editortype="Default" type="String" multivalued="true" visibility="local" description="A printable label for the ticket review target, useful when the access right no longer exists but you want to display a &quot;full&quot; list of the tickets created at the starting phase of the review" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1627396001041" variable="perimeters" displayname="perimeters" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="perimeters to review&#xA;" syncname="S1701616665841"/>
		<Variable name="A1627563585136" variable="reviewersorigin" displayname="reviewers origin" editortype="Default" type="String" multivalued="true" visibility="local" description="reviewers origin:&#xA;&#x9;linemanager&#xA;&#x9;applicationowner&#xA;&#x9;permissionowner&#xA;&#x9;groupowner&#xA;&#x9;accountowner&#xA;&#x9;repositoryowner&#xA;&#x9;default&#xA;" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1630306860645" variable="reviewname" displayname="review name" editortype="Default" type="String" multivalued="false" visibility="local" description="review name" notstoredvariable="true"/>
		<Variable name="A1645039822072" variable="statuspage" displayname="status page" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1645181489263" variable="reviewpage" displayname="reviewpage" editortype="Default" type="String" multivalued="false" visibility="local" description="dynamic page, called to perform the review" notstoredvariable="true"/>
		<Variable name="A1645181551692" variable="finalizepage" displayname="finalizepage" editortype="Default" type="String" multivalued="false" visibility="local" description="dynamic page called to finalize the review" notstoredvariable="true"/>
		<Variable name="A1645181733927" variable="offlinemode" displayname="offline mode" editortype="Default" type="String" multivalued="false" visibility="local" description="can be the review be run in offline mode (by sending an attachment)&#xA;RESTRICTED TO RIGHTS REVIEWS FOR NOW&#xA;0 = No&#xA;1 = Yes" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1647846828727" variable="selfdelegation" displayname="selfdelegation" editortype="Default" type="String" multivalued="false" visibility="local" description="Reviewer can self-delegate its entries to stake holders" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1647870373929" variable="remediationtype" displayname="remediationtype" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="right" notstoredvariable="true"/>
		<Variable name="A1662038828103" variable="ticketlogrecorduid" displayname="ticketlogrecorduid" editortype="Default" type="Number" multivalued="false" visibility="out" notstoredvariable="false"/>
		<Variable name="A1662038976867" variable="currentstatus" displayname="currentstatus" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="init" notstoredvariable="true"/>
		<Variable name="A1666532683084" variable="isafullreview" displayname="isafullreview" editortype="Default" type="Boolean" multivalued="false" visibility="local" description="is a full (compliant) review" notstoredvariable="true"/>
		<Variable name="A1682863219381" variable="reviewdefmduid" displayname="Review Definition MD uid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="uid of the review definition metadata"/>

		<Variable name="S1701616665841" variable="infos" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false" description="review tickets informations"/>
		<Variable name="A1701785254892" variable="startDate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1702508377542" variable="inst_num" displayname="next Instance number" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1702563423866" variable="inst_info" editortype="Default" type="String" multivalued="false" visibility="local" description="Instance info json (notifications)" notstoredvariable="true"/>
		<Variable name="A1711105181284" variable="signoffstate" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1705586444250" variable="ai_preapproved" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" syncname="S1701616665841"/>
		<Variable name="A1705586470158" variable="ai_anomalous" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1705586561577" variable="ai_firstclusterid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1713449967958" variable="groups" displayname="groups" editortype="Ledger Group" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1715199702965" variable="ai_clustersid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1715199733754" variable="ai_maxclusterid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
		<Variable name="A1718205482433" variable="sendNotifications" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1736781549838" variable="stickyTimeslot" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1737121349322" variable="stickyTimeslotLabel" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1764672470138" variable="parent_permissions" displayname="parent permissions" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" syncname="S1701616665841" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1626341667430" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626341683716" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Mails>
	</Mails>
</Workflow>
