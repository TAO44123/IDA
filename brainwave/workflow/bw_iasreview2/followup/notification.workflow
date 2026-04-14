<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwir_followUpNotification" statictitle="Follow up Notification" description="Follow up Notification" scriptfile="/workflow/bw_iasreview2/followup/notification.javascript" displayname="Follow up Notification for campaign {dataset.campaignname.get()}">
		<Component name="CSTART" type="startactivity" x="403" y="69" w="200" h="114" title="bwir_followUpNotification - Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1759931105658"/>
			<Actions>
				<Action name="U1759997423765" action="executeview" viewname="bwaccess360_accessreviewreviewersforcampaignbv" append="false" attribute="reviewersOrDelegates">
					<ViewParam name="P17599974237650" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewParam name="P17599974237651" param="filterbyreviewstatus" paramvalue="{dataset.filterbyreviewstatus.get()}"/>
					<ViewParam name="P17599974237652" param="filternotsignedofonly" paramvalue="{dataset.filternotsignedofonly.get()}"/>
					<ViewParam name="P17599974237653" param="revieweruids" paramvalue="{dataset.reviewerUids}"/>
					<ViewAttribute name="P1759997423765_4" attribute="uid" variable="reviewersOrDelegates"/>
				</Action>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="403" y="352" w="200" h="98" title="bwir_followUpNotification - End" compact="true">
			<Actions>
				<Action name="U1759996238925" action="update" attribute="issuedEmails" newvalue="{ dataset.isEmpty( &apos;issuedEmails&apos; ) ? 0 : dataset.issuedEmails.length }"/>
				<Action name="U1759996261342" action="update" attribute="nbNotIssuedEmails" newvalue="{ dataset.isEmpty( &apos;notIssuedEmails&apos; ) ? 0 : dataset.notIssuedEmails.length }"/>
				<Action name="U1759996281711" action="update" attribute="nbMissingEmailAddress" newvalue="{ dataset.isEmpty( &apos;missingEmailAddress&apos; ) ? 0 : dataset.missingEmailAddress.length }"/>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1759931365668" priority="1"/>
		<Component name="C1759931365668" type="mailnotificationactivity" x="277" y="184" w="300" h="98" title="Notify reviewers">
			<Notification name="mail" mail="A1759931341700" ignoreerror="false"/>
			<Output name="output" okmailvariable="issuedEmails" errormailvariable="notIssuedEmails" uidnomailvariable="missingEmailAddress"/>
		</Component>
		<Link name="L1759931394722" source="C1759931365668" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1759930844128" variable="reviewerUids" displayname="Reviewer uids" editortype="Process Actor" type="String" multivalued="true" visibility="in" description="Reviewer uids" notstoredvariable="true"/>
		<Variable name="A1759930869933" variable="reviewtitle" displayname="Review Title" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Title" notstoredvariable="true"/>
		<Variable name="A1759930886658" variable="reviewmessage" displayname="Review Message" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Message" notstoredvariable="true"/>
		<Variable name="A1759930869934" variable="reviewtitle_en" displayname="Review Title" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Title" notstoredvariable="true"/>
		<Variable name="A1759930886659" variable="reviewmessage_en" displayname="Review Message" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Message" notstoredvariable="true"/>
		<Variable name="A1759930869935" variable="reviewtitle_fr" displayname="Review Title" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Title" notstoredvariable="true"/>
		<Variable name="A1759930886660" variable="reviewmessage_fr" displayname="Review Message" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Message" notstoredvariable="true"/>
		<Variable name="A1759930869936" variable="reviewtitle_es" displayname="Review Title" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Title" notstoredvariable="true"/>
		<Variable name="A1759930886661" variable="reviewmessage_es" displayname="Review Message" editortype="Default" type="String" multivalued="false" visibility="in" description="Review Message" notstoredvariable="true"/>
		<Variable name="A1759930907964" variable="campaignid" displayname="Campaign Id" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign Id" notstoredvariable="true"/>
		<Variable name="A1759930924564" variable="campaignname" displayname="Campaign Name" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign Name" notstoredvariable="true"/>
		<Variable name="A1759930941243" variable="campaigndescription" displayname="Campaign Description" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign Description" notstoredvariable="true"/>
		<Variable name="A1759930958062" variable="campaigndeadline" displayname="Campaign Deadline" editortype="Default" type="Date" multivalued="false" visibility="in" description="Campaign Deadline" notstoredvariable="true"/>
		<Variable name="A1759930980830" variable="isoffline" displayname="Offline Review" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Offline Review" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1759930996692" variable="campaignpriority" displayname="Campaign Priority" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign Priority" notstoredvariable="true"/>
		<Variable name="A1759931013508" variable="emailcc" displayname="Email CC" editortype="Default" type="String" multivalued="false" visibility="in" description="emailcc" notstoredvariable="true"/>
		<Variable name="A1759931028536" variable="emailbcc" displayname="Email BCC" editortype="Default" type="String" multivalued="false" visibility="in" description="Email BCC" notstoredvariable="true"/>
		<Variable name="A1759931044489" variable="reportname" displayname="Report Name" editortype="Default" type="String" multivalued="false" visibility="in" description="Report Name" notstoredvariable="true"/>
		<Variable name="A1759931062297" variable="filterbyreviewstatus" displayname="Filter by Review Status" editortype="Default" type="String" multivalued="false" visibility="in" description="Filter by Review Status" notstoredvariable="true"/>
		<Variable name="A1759931082866" variable="filternotsignedofonly" displayname="Filter signed off only" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Filter signed off only" notstoredvariable="true"/>
		<Variable name="A1759933379423" variable="campaigntype" displayname="Campaign type" editortype="Default" type="String" multivalued="false" visibility="in" description="Campaign type" notstoredvariable="true"/>
		<Variable name="A1759933418493" variable="mailstrategy" displayname="Mail strategy" editortype="Default" type="String" multivalued="false" visibility="in" description="Mail strategy" notstoredvariable="true"/>
		<Variable name="A1759933568568" variable="offlinemode" displayname="Offline mode" editortype="Default" type="String" multivalued="false" visibility="in" description="Offline mode" notstoredvariable="true"/>
		<Variable name="A1759996025570" variable="issuedEmails" displayname="Issued emails notifications" editortype="Default" type="String" multivalued="true" visibility="out" description="Issued emails notifications" notstoredvariable="true"/>
		<Variable name="A1759996053528" variable="notIssuedEmails" displayname="Emails notifications not issues" editortype="Default" type="String" multivalued="true" visibility="out" description="Emails notifications not issues" notstoredvariable="true"/>
		<Variable name="A1759996078136" variable="missingEmailAddress" displayname="Missing email addresses" editortype="Process Actor" type="String" multivalued="true" visibility="out" description="Missing email addresses" notstoredvariable="true"/>
		<Variable name="A1759996152849" variable="nbIssuedEmails" displayname="Number of issues emails" editortype="Default" type="Number" multivalued="false" visibility="out" description="Number of issues emails" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1759996170722" variable="nbNotIssuedEmails" displayname="Number of not issues emails" editortype="Default" type="Number" multivalued="false" visibility="out" description="Number of not issues emails" notstoredvariable="true"/>
		<Variable name="A1759996189020" variable="nbMissingEmailAddress" displayname="Number of missing email addresses" editortype="Default" type="Number" multivalued="false" visibility="out" description="Number of missing email addresses" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1759997312653" variable="reviewersOrDelegates" displayname="Reviewers or delegates if any" editortype="Process Actor" type="String" multivalued="true" visibility="local" description="Reviewers or delegates if any" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1759931105658" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="All active identities">
			<Rule name="A1759931118432" rule="bwdc_active_identities" description="active identities"/>
		</Role>
		<Role name="A1759931196749" displayname="reviewers" description="Reviewers to notify">
			<Variable name="A1759931204161" variable="reviewerUids"/>
		</Role>
		<Role name="A1759997440134" displayname="reviewersOrDelegates" description="Reviewers or their delegates if there are active delegations">
			<Variable name="A1759997458723" variable="reviewersOrDelegates"/>
		</Role>
	</Roles>
	<Mails>
		<Mail name="A1759931147651" displayname="reviewNotificationWithoutReport" description="Review notification without report" torole="A1759997440134" notifyrule="bwaccess360r_accessreviewtoselectedreviewerworeport">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<PolicyMail name="A1759931341700" displayname="notify" description="Notify reviewers">
			<ConditionalMail name="A1759931354609" mail="A1759931147651" expression="dataset.mailstrategy.get() == 2 || &apos;2&apos;.equalsIgnoreCase( dataset.mailstrategy.get() )"/>
			<ConditionalMail name="A1759934217821" mail="A1759932304563" expression="&apos;right&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1759934237042" mail="A1759932399329" expression="&apos;account&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1759934252196" mail="A1759932517594" expression="&apos;groupmembers&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1759934262537" mail="A1759932586457" expression="&apos;safe&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1760082921894" mail="A1760082835340" expression="&apos;servers&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1767954230876" mail="A1767954117414" expression="&apos;roles&apos;.equalsIgnoreCase( dataset.campaigntype.get() )"/>
			<ConditionalMail name="A1759934700229" mail="A1759931147651" expression="true"/>
		</PolicyMail>
		<Mail name="A1759932304563" displayname="accessReviewNotificationWithReport" description="Rights review with report" torole="A1759997440134" notifyrule="bwaccess360r_accessreviewtoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<Mail name="A1759932399329" displayname="accountsReviewNotificationWithReport" description="Accounts review with report" torole="A1759997440134" notifyrule="bwaccess360r_accountsreviewnotiftoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<Mail name="A1759932517594" displayname="groupsReviewNotificationWithReport" description="Groups review notification with report" torole="A1759997440134" notifyrule="bwaccess360r_groupmembersreviewnotiftoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<Mail name="A1759932586457" displayname="safeReviewNotificationWithReport" description="Safe review notification with report" torole="A1759997440134" notifyrule="bwir_accessreviewpersafenotiftoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<Mail name="A1760082835340" displayname="serverNotificationWithReport" description="Server review notification with report" torole="A1759997440134" notifyrule="bwaccess360r_serverreviewnotiftoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
		<Mail name="A1767954117414" displayname="roleContentNotificationWithReport" description="Role Content review notification with report" torole="A1759997440134" notifyrule="bwaccess360r_roleContentReviewnotiftoselectedreviewer">
			<Param name="campaignid" variable="campaignid"/>
			<Param name="revieweruids" variable="reviewerUids"/>
			<Param name="campaignname" variable="campaignname"/>
			<Param name="campaigndescription" variable="campaigndescription"/>
			<Param name="campaigndeadline" variable="campaigndeadline"/>
			<Param name="campaignpriority" variable="campaignpriority"/>
			<Param name="reviewtitle" variable="reviewtitle"/>
			<Param name="reviewmessage" variable="reviewmessage"/>
			<Param name="reportname" variable="reportname"/>
			<Param name="filterbyreviewstatus" variable="filterbyreviewstatus"/>
			<Param name="emailcc" variable="emailcc"/>
			<Param name="emailbcc" variable="emailbcc"/>
			<Param name="filternotsignedofonly" variable="filternotsignedofonly"/>
			<Param name="isoffline" variable="isoffline"/>
			<Param name="reviewtitle_en" variable="reviewtitle_en"/>
			<Param name="reviewtitle_fr" variable="reviewtitle_fr"/>
			<Param name="reviewtitle_es" variable="reviewtitle_es"/>
			<Param name="reviewmessage_en" variable="reviewmessage_en"/>
			<Param name="reviewmessage_fr" variable="reviewmessage_fr"/>
			<Param name="reviewmessage_es" variable="reviewmessage_es"/>
		</Mail>
	</Mails>
</Workflow>
