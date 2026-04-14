<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwir_sendreviewersnotifs" statictitle="Send notifications to reviewers" scriptfile="workflow/bw_iasreview2/mng/sendNotificationToReviewers.javascript" description="send notifications to an existing review" technical="true" type="builtin-technical-workflow" displayname="Send notifications to reviewers for campaign {dataset.campaignId.get()}">
		<Component name="CSTART" type="startactivity" x="172" y="40" w="200" h="114" title="bwir_sendreviewersnotifs - Start" compact="true">
			<Ticket create="true" createaction="false">
			</Ticket>
			<Candidates name="role" role="A1626341667430"/>
			<Output name="output"/>
			<Actions function="computeReviewersAndNotifications">
			</Actions>
			<FormVariable name="A1718180054575" variable="campaignId" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="172" y="244" w="200" h="98" title="bwir_sendreviewersnotifs - End" compact="true"/>
		<Component name="C1703856388075" type="mailnotificationactivity" x="71" y="118" w="251" h="98" title="send initial notifications to reviewers">
			<Notification name="mail" mail="A1704184968444" ignoreerror="true"/>
			<Iteration listvariable="nrReviewerUids">
				<Variable name="A1703871882831" variable="nrCampaignIds"/>
				<Variable name="A1703871888532" variable="nrCampaignNames"/>
				<Variable name="A1703871896802" variable="nrCampaignDescriptions"/>
				<Variable name="A1703871907832" variable="nrCampaignDeadlines"/>
				<Variable name="A1703874552338" variable="nrNotSignedoffOnly"/>
				<Variable name="A1703874562496" variable="nrMailSubjects"/>
				<Variable name="A1703874569155" variable="nrMailContents"/>
				<Variable name="A1704200692865" variable="nrReviewerMails"/>
				<Variable name="A1705356114054" variable="nrMailCCs"/>
				<Variable name="A1705356118575" variable="nrMailBCCs"/>
				<Variable name="A1705356126326" variable="nrOffline"/>
				<Variable name="A1718180778758" variable="nrDelegatorActives"/>
				<Variable name="A1718180794283" variable="nrDelegatorFullnames"/>
				<Variable name="A1718180802722" variable="nrDelegatorHrCodes"/>
				<Variable name="A1718180810594" variable="nrDelegatorMails"/>
				<Variable name="A1718180816843" variable="nrDelegatorPreferredLanguages"/>
				<Variable name="A1718180835923" variable="nrDelegatorUids"/>
			</Iteration>
		</Component>
		<Link name="L1703859685258" source="C1703856388075" target="CEND" priority="1"/>
		<Link name="L1718180014531" source="CSTART" target="C1703856388075" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1703857270929" variable="nrReviewerUids" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703857303590" variable="nrMailSubjects" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703857322901" variable="nrMailContents" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703859853038" variable="nrCampaignIds" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703859878656" variable="nrCampaignNames" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703859891486" variable="nrCampaignDescriptions" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703859927945" variable="nrCampaignDeadlines" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1703871150586" variable="nrNotSignedoffOnly" editortype="Default" type="Boolean" multivalued="true" visibility="local" notstoredvariable="true" syncname="S1703871555043"/>
		<Variable name="S1703871555043" variable="notifyReviewers" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1704200617219" variable="nrReviewerMails" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1705348014321" variable="nrOffline" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1705355110310" variable="nrMailCCs" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1705355129632" variable="nrMailBCCs" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718179919834" variable="campaignId" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="566"/>
		<Variable name="A1718189694125" variable="offlinemode" editortype="Default" type="String" multivalued="false" visibility="local" description="can be the review be run in offline mode (by sending an attachment)&#xA;RESTRICTED TO RIGHTS REVIEWS FOR NOW&#xA;0 = No&#xA;1 = Yes" notstoredvariable="true"/>
		<Variable name="A1718189723532" variable="reviewtype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1718096977536" variable="nrDelegatorUids" displayname="delegator uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718097015405" variable="nrDelegatorHrCodes" displayname="delegator hrcode" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718097044794" variable="nrDelegatorMails" displayname="delegator mail" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718097066415" variable="nrDelegatorFullnames" displayname="delegator full name" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718099077216" variable="nrDelegatorActives" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1718100399825" variable="nrDelegatorPreferredLanguages" displayname="delegator preferred language" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1754919117359" variable="nrMailSubjectsFR" displayname="nrMailSubjectsFR" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1754919189870" variable="nrMailSubjectsES" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1754919213795" variable="nrMailContentsFR" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
		<Variable name="A1754919232317" variable="nrMailContentsES" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703871555043" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1626341667430" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1626341683716" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1703252121828" notifyrule="bwr_review_generic" displayname="accessreviewperapplication_noreport" description="accessreview per application no report " tolist="nrReviewerUids">
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="isoffline" variable="nrOffline"/>
			<Param name="emailcc" variable="nrMailCCs"/>
			<Param name="emailbcc" variable="nrMailBCCs"/>
			<Param name="delegatoruid" variable="nrDelegatorUids"/>
			<Param name="delegatormail" variable="nrDelegatorMails"/>
			<Param name="delegatorhrcode" variable="nrDelegatorHrCodes"/>
			<Param name="delegatorfullname" variable="nrDelegatorFullnames"/>
			<Param name="delegatoractive" variable="nrDelegatorActives"/>
			<Param name="delegatorpreferredlanguage" variable="nrDelegatorPreferredLanguages"/>
			<Param name="reviewtitleFR" variable="nrMailSubjectsFR"/>
			<Param name="reviewtitleES" variable="nrMailSubjectsES"/>
			<Param name="reviewmessageFR" variable="nrMailContentsFR"/>
			<Param name="reviewmessageES" variable="nrMailContentsES"/>
		</Mail>
		<PolicyMail name="A1704184968444" displayname="reviewers_policy" description="Notifications for reviewers, with or without excel report, &#xA;depending on offline mode">
			<ConditionalMail name="A1704185045125" mail="A1703252121828" expression="dataset.offlinemode.get() == &quot;0&quot;"/>
			<ConditionalMail name="A1704189321733" mail="A1704185130484" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;right&quot;"/>
			<ConditionalMail name="A1713961403027" mail="A1713961200755" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;account&quot;"/>
			<ConditionalMail name="A1713962623782" mail="A1713962321511" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;groupmembers&quot;"/>
			<ConditionalMail name="A1713966587606" mail="A1704185130484" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;safe&quot;"/>
			<ConditionalMail name="A1760357752824" mail="A1704185130484" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;servers&quot;"/>
			<ConditionalMail name="A1767192198017" mail="A1767192016243" expression="dataset.offlinemode.get() == &quot;1&quot; &amp;&amp; dataset.reviewtype.get() == &quot;roles&quot;"/>
		</PolicyMail>
		<Mail name="A1704185130484" displayname="accessreviewperapplication_report" notifyrule="bwaccess360r_accessreviewperapplication" description="notif with excel report on app review items" tolist="nrReviewerUids">
			<Param name="campaignid" variable="nrCampaignIds"/>
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="filternotsignedofonly" variable="nrNotSignedoffOnly"/>
			<Param name="emailcc" variable="nrMailCCs"/>
			<Param name="emailbcc" variable="nrMailBCCs"/>
			<Param name="isoffline" variable="nrOffline"/>
			<Param name="delegatoruid" variable="nrDelegatorUids"/>
			<Param name="delegatormail" variable="nrDelegatorMails"/>
			<Param name="delegatorhrcode" variable="nrDelegatorHrCodes"/>
			<Param name="delegatorfullname" variable="nrDelegatorFullnames"/>
			<Param name="delegatoractive" variable="nrDelegatorActives"/>
			<Param name="delegatorpreferredlanguage" variable="nrDelegatorPreferredLanguages"/>
			<Param name="reviewtitleFR" variable="nrMailSubjectsFR"/>
			<Param name="reviewtitleES" variable="nrMailSubjectsES"/>
			<Param name="reviewmessageFR" variable="nrMailContentsFR"/>
			<Param name="reviewmessageES" variable="nrMailContentsES"/>
		</Mail>
		<Mail name="A1713961200755" notifyrule="bwaccess360r_accountsreviewperrepository" description="notif with excel report on repository review item" displayname="accessreviewperrepository_report" tolist="nrReviewerUids">
			<Param name="campaignid" variable="nrCampaignIds"/>
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="filternotsignedofonly" variable="nrNotSignedoffOnly"/>
			<Param name="emailcc" variable="nrMailCCs"/>
			<Param name="emailbcc" variable="nrMailBCCs"/>
			<Param name="isoffline" variable="nrOffline"/>
			<Param name="delegatoruid" variable="nrDelegatorUids"/>
			<Param name="delegatormail" variable="nrDelegatorMails"/>
			<Param name="delegatorhrcode" variable="nrDelegatorHrCodes"/>
			<Param name="delegatorfullname" variable="nrDelegatorFullnames"/>
			<Param name="delegatoractive" variable="nrDelegatorActives"/>
			<Param name="delegatorpreferredlanguage" variable="nrDelegatorPreferredLanguages"/>
			<Param name="reviewtitleFR" variable="nrMailSubjectsFR"/>
			<Param name="reviewtitleES" variable="nrMailSubjectsES"/>
			<Param name="reviewmessageFR" variable="nrMailContentsFR"/>
			<Param name="reviewmessageES" variable="nrMailContentsES"/>
		</Mail>
		<Mail name="A1713962321511" notifyrule="bwaccess360r_groupmembersreviewperrepository" displayname="accessreviewpergroupmembers_report" description="notif with excel report on group members review items" tolist="nrReviewerUids">
			<Param name="campaignid" variable="nrCampaignIds"/>
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="filternotsignedofonly" variable="nrNotSignedoffOnly"/>
			<Param name="emailcc" variable="nrMailCCs"/>
			<Param name="emailbcc" variable="nrMailBCCs"/>
			<Param name="isoffline" variable="nrOffline"/>
			<Param name="delegatoruid" variable="nrDelegatorUids"/>
			<Param name="delegatormail" variable="nrDelegatorMails"/>
			<Param name="delegatorhrcode" variable="nrDelegatorHrCodes"/>
			<Param name="delegatorfullname" variable="nrDelegatorFullnames"/>
			<Param name="delegatoractive" variable="nrDelegatorActives"/>
			<Param name="delegatorpreferredlanguage" variable="nrDelegatorPreferredLanguages"/>
			<Param name="reviewtitleFR" variable="nrMailSubjectsFR"/>
			<Param name="reviewtitleES" variable="nrMailSubjectsES"/>
			<Param name="reviewmessageFR" variable="nrMailContentsFR"/>
			<Param name="reviewmessageES" variable="nrMailContentsES"/>
		</Mail>
		<Mail name="A1767192016243" displayname="roleContentWithReport" description="Role Content review notification with Report" toaddtaskrole="false" notifyrule="bwaccess360r_roleContentNotificationWithReport" tolist="nrReviewerUids">
			<Param name="campaignid" variable="nrCampaignIds"/>
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="filternotsignedofonly" variable="nrNotSignedoffOnly"/>
			<Param name="emailcc" variable="nrMailCCs"/>
			<Param name="emailbcc" variable="nrMailBCCs"/>
			<Param name="isoffline" variable="nrOffline"/>
			<Param name="delegatoruid" variable="nrDelegatorUids"/>
			<Param name="delegatormail" variable="nrDelegatorMails"/>
			<Param name="delegatorhrcode" variable="nrDelegatorHrCodes"/>
			<Param name="delegatorfullname" variable="nrDelegatorFullnames"/>
			<Param name="delegatoractive" variable="nrDelegatorActives"/>
			<Param name="delegatorpreferredlanguage" variable="nrDelegatorPreferredLanguages"/>
			<Param name="reviewtitleFR" variable="nrMailSubjectsFR"/>
			<Param name="reviewtitleES" variable="nrMailSubjectsES"/>
			<Param name="reviewmessageFR" variable="nrMailContentsFR"/>
			<Param name="reviewmessageES" variable="nrMailContentsES"/>
		</Mail>
	</Mails>
</Workflow>
