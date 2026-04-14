<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_campaign_scheduler" statictitle="campaign scheduler" scriptfile="/workflow/bw_iasreview2/svc/campaign_scheduler.javascript" description="This workflow:&#xA;- reads and parse the campaign definitons + latest instance, &#xA;- computes the next scheduled for each campaign&#xA;- launches the campaign if the date &gt; today&#xA;- send early notifcations to campaign owner if enabled&#xA;- send start notifcations to campaign owner if enabled&#xA;- send init notif to reviewers &#xA;- send remindex" displayname="Campaign Scheduler">
		<Component name="CSTART" type="startactivity" x="240" y="37" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions function="computeTasksToRun">
				<Action name="U1714425582639" action="executeview" viewname="get_current_timeslot_uid" append="false" attribute="timeslotuid">
					<ViewAttribute name="P1714425582639_0" attribute="uid" variable="timeslotuid"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1702911759654"/>
			<FormVariable name="A1703084874060" variable="simulateNow" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1703084881526" variable="simulate" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="240" y="980" w="200" h="98" title="End" compact="true" inexclusive="true">
			<Actions>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1703550854305" priority="1"/>
		<Component name="C1703084975037" type="callactivity" x="159" y="683" w="210" h="98" title="launch campaigns (iterated)">
			<Process workflowfile="/workflow/bw_iasreview2/mng/startReviewInstance.workflow" standalone="true" detachedprocess="true" currenttimeslot="false">
				<Input name="A1703085092538" variable="reviewdefmduid" content="campaignUids"/>
				<Input name="A1714425635875" variable="timeslotuid" content="timeslotuid"/>
			</Process>
			<Iteration listvariable="campaignUids" sequential="true">
				<Variable name="A1703085113114" variable="campaignLabels"/>
				<Variable name="A1703085117760" variable="campaignNextDates"/>
			</Iteration>
		</Component>
		<Link name="L1703085006308" source="C1703084975037" target="C1703175368579" priority="1"/>
		<Link name="L1703089604291" source="C1703779968389" target="C1703175368579" priority="2" linecustom="true" style="dot" expression="dataset.simulate.get()"/>
		<Component name="C1703175368579" type="variablechangeactivity" x="184" y="844" w="159" h="98" title="set out vars" inexclusive="true">
			<Actions>
				<Action name="U1703191014136" action="update" attribute="runTasks" newvalue="{dataset.runTasks.get()}"/>
			</Actions>
		</Component>
		<Link name="L1703190969655" source="C1703175368579" target="CEND" priority="1"/>
		<Component name="C1703283015246" type="mailnotificationactivity" x="167" y="269" w="194" h="98" title="send start notif to owner" outexclusive="true">
			<Notification name="mail" mail="A1703342014475" ignoreerror="true"/>
			<Iteration listvariable="notifyStartOwnerUids" sequential="false">
				<Variable name="A1703342134481" variable="notifyStartCampaignLabels"/>
				<Variable name="A1703342139668" variable="notifyStartCampaignDueDates"/>
			</Iteration>
		</Component>
		<Link name="L1703283034987" source="C1703779968389" target="C1703084975037" priority="1" expression="!dataset.simulate.get()"/>
		<Component name="C1703550854305" type="mailnotificationactivity" x="161" y="126" w="206" h="98" title="send before start notifs to owner">
			<Iteration listvariable="notifyBeforeStartOwnerUids" sequential="false">
				<Variable name="A1703550890036" variable="notifyBeforeStartCampaignLabels"/>
				<Variable name="A1703550897717" variable="notifyBeforeStartCampaignStartDates"/>
				<Variable name="A1703598524727" variable="notifyBeforeStartNbDays"/>
			</Iteration>
			<Notification name="mail" mail="A1703341405890" ignoreerror="true"/>
		</Component>
		<Link name="L1703550949372" source="C1703550854305" target="C1703283015246" priority="1"/>
		<Component name="C1703779968389" type="mailnotificationactivity" x="163" y="549" w="203" h="98" title="send reminders to reviewers" outexclusive="true">
			<Notification name="mail" mail="A1703719357908" ignoreerror="true"/>
			<Iteration listvariable="nrReviewerUids" sequential="false">
				<Variable name="A1703780040048" variable="nrCampaignNames"/>
				<Variable name="A1703780049291" variable="nrCampaignDescriptions"/>
				<Variable name="A1703780057579" variable="nrCampaignDeadlines"/>
				<Variable name="A1703843296761" variable="nrCampaignIds"/>
				<Variable name="A1703872184904" variable="nrMailSubjects"/>
				<Variable name="A1703872189977" variable="nrMailContents"/>
				<Variable name="A1704199838920" variable="nrReviewerMails"/>
				<Variable name="A1705356052864" variable="nrMailBCCs"/>
				<Variable name="A1705356061956" variable="nrMailCC"/>
				<Variable name="A1718180778758" variable="nrDelegatorActives"/>
				<Variable name="A1718180794283" variable="nrDelegatorFullnames"/>
				<Variable name="A1718180802722" variable="nrDelegatorHrCodes"/>
				<Variable name="A1718180810594" variable="nrDelegatorMails"/>
				<Variable name="A1718180816843" variable="nrDelegatorPreferredLanguages"/>
				<Variable name="A1718180835923" variable="nrDelegatorUids"/>
			</Iteration>
			<Output name="output" okmailvariable="nrSentEmails"/>
		</Component>
		<Link name="L1703780093553" source="C1703283015246" target="C1705244722338" priority="1"/>
		<Component name="C1705244722338" type="mailnotificationactivity" x="183" y="408" w="164" h="98" title="send finalize to owner">
			<Notification name="mail" mail="A1705242171890" ignoreerror="true"/>
			<Iteration listvariable="ndOwnerUids" sequential="false">
				<Variable name="A1705244816540" variable="ndCampaignLabels"/>
				<Variable name="A1705244823601" variable="ndCampaignDeadlines"/>
			</Iteration>
		</Component>
		<Link name="L1705244897313" source="C1705244722338" target="C1703779968389" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1702911759654" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="launchers" description="launchers">
			<Rule name="A1702911786744" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1703083714192" variable="simulateNow" displayname="simulateNow" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1703084289318" variable="campaignUids" editortype="Default" type="String" multivalued="true" visibility="local" description="Uids of the campaign definitions to start" notstoredvariable="true" syncname="S1703084421336"/>
		<Variable name="A1703084410548" variable="campaignLabels" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" syncname="S1703084421336"/>
		<Variable name="S1703084421336" variable="startedCampaigns" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false" description="Campaigns to start"/>
		<Variable name="A1703084597269" variable="simulate" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="if set to true, the campaigns are not started" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1703084643913" variable="campaignNextDates" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1703084421336" notstoredvariable="true"/>
		<Variable name="A1703150862118" variable="runTasks" editortype="Default" type="String" multivalued="false" visibility="out" description="Descriptions des taches qui ont été démarrées" notstoredvariable="false"/>
		<Variable name="A1703266631786" variable="notifyStartCampaignDueDates" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="true" displayname="campaign due date" syncname="S1703341528540"/>
		<Variable name="A1703341115217" variable="notifyStartOwnerUids" editortype="Default" type="String" multivalued="true" visibility="local" description="list of uids of campaign owners to send start notification.&#xA;if disabled, this list will be empty" notstoredvariable="true" syncname="S1703341528540"/>
		<Variable name="A1703341173902" variable="notifyBeforeStartOwnerUids" editortype="Default" type="String" multivalued="true" visibility="local" description="list of uids of campaign owners to send before start notification.&#xA;if disabled, this list will be empty" notstoredvariable="true" syncname="S1703341327543"/>
		<Variable name="S1703341327543" variable="notifyBeforeStart" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false" description="fields for sending notifications before start to campaign owners"/>
		<Variable name="A1703341393868" variable="notifyBeforeStartCampaignLabels" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703341327543" notstoredvariable="true"/>
		<Variable name="S1703341528540" variable="notifyStart" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false" description="fields for sending notifications after start to campaign owners"/>
		<Variable name="A1703341604226" variable="notifyStartCampaignLabels" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703341528540" notstoredvariable="true"/>
		<Variable name="A1703549569960" variable="notifyBeforeStartCampaignStartDates" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1703341327543" notstoredvariable="true"/>
		<Variable name="A1703598501214" variable="notifyBeforeStartNbDays" displayname="notifyBeforeStartNbDays" editortype="Default" type="Number" multivalued="true" visibility="local" syncname="S1703341327543" notstoredvariable="true"/>
		<Variable name="S1703712811926" variable="notifyReminders" multivalued="true" visibility="local" editortype="Structure" type="String" description="Remininder for all campaigns &amp; remaining reviewers" notstoredvariable="false"/>
		<Variable name="A1703719598564" variable="nrCampaignIds" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703719686083" variable="nrCampaignNames" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703719723007" variable="nrCampaignDescriptions" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703719765960" variable="nrCampaignDeadlines" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703781340177" variable="nrSentEmails" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1703788187845" variable="nrMailSubjects" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703788213371" variable="nrMailContents" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1703842897353" variable="nrReviewerUids" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1704194819053" variable="nrReviewerMails" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="S1705241603027" variable="notifyDeadline" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>		
		<Variable name="A1705241671244" variable="ndOwnerUids" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1705241603027" notstoredvariable="true"/>				
		<Variable name="A1705242119058" variable="ndCampaignLabels" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1705241603027" notstoredvariable="true"/>
		<Variable name="A1705242135577" variable="ndCampaignDeadlines" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1705241603027" notstoredvariable="true"/>
		<Variable name="A1705348957454" variable="nrMailCC" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1705348983327" variable="nrMailBCCs" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1714425532190" variable="timeslotuid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1718096977536" variable="nrDelegatorUids" displayname="delegator uid" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1718097015405" variable="nrDelegatorHrCodes" displayname="delegator hrcode" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1718097044794" variable="nrDelegatorMails" displayname="delegator mail" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1718097066415" variable="nrDelegatorFullnames" displayname="delegator full name" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1718099077216" variable="nrDelegatorActives" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1718100399825" variable="nrDelegatorPreferredLanguages" displayname="delegator preferred language" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1755004777355" variable="nrMailSubjectsFR" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1755004800040" variable="nrMailSubjectsES" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1755004825687" variable="nrMailContentsFR" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
		<Variable name="A1755004838558" variable="nrMailContentsES" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1703712811926" notstoredvariable="true"/>
	</Variables>
	<Mails>
		<Mail name="A1703341405890" displayname="campaignBeforeStart" notifyrule="bwr_campaignbeforestart" description="campaignBeforeStart" tolist="notifyBeforeStartOwnerUids">
			<Param name="owneruid" variable="notifyBeforeStartOwnerUids"/>
			<Param name="campaignname" variable="notifyBeforeStartCampaignLabels"/>
			<Param name="campaignstart" variable="notifyBeforeStartCampaignStartDates"/>
			<Param name="nbdaysbefore" variable="notifyBeforeStartNbDays"/>
		</Mail>
		<Mail name="A1703342014475" displayname="campaignStart" tolist="notifyStartOwnerUids" description="campaignStart" notifyrule="bwr_campaignstart">
			<Param name="owneruid" variable="notifyStartOwnerUids"/>
			<Param name="campaignname" variable="notifyStartCampaignLabels"/>
			<Param name="campaigndeadline" variable="notifyStartCampaignDueDates"/>
		</Mail>
		<Mail name="A1703719357908" displayname="reminders" notifyrule="bwr_review_generic" description="reminders" tolist="nrReviewerUids">
			<Param name="campaignname" variable="nrCampaignNames"/>
			<Param name="campaigndescription" variable="nrCampaignDescriptions"/>
			<Param name="campaigndeadline" variable="nrCampaignDeadlines"/>
			<Param name="reviewtitle" variable="nrMailSubjects"/>
			<Param name="reviewmessage" variable="nrMailContents"/>
			<Param name="emailcc" variable="nrMailCC"/>
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
		<Mail name="A1705242171890" tolist="ndOwnerUids" displayname="campaignDeadline" notifyrule="bwr_campaigndeadline" description="campaign deadline">
			<Param name="owneruid" variable="ndOwnerUids"/>
			<Param name="campaignname" variable="ndCampaignLabels"/>
			<Param name="campaigndeadline" variable="ndCampaignDeadlines"/>
		</Mail>
	</Mails>
</Workflow>
