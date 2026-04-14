<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_rm_detail" statictitle="Role Mining by organisation" description="detail" scriptfile="workflow/bw_rm/campaign/detail.javascript" displayname="Role mining {dataset.org_displayname.get()}" releaseontimeout="true" infopage="bw_rm_rolemining" errorpage="bw_rm_rolemining" reportpage="bw_rm_rolemining">
		<Component name="CSTART" type="startactivity" x="391" y="47" w="200" h="114" title="Start" compact="true" duedatevariable="campaigndeadline" priorityvariable="prioritylevel" progressvariable="mining_currentprogress" progresstotalvariable="mining_totalprogress" outexclusive="true">
			<Actions>
				<Action name="U1522655500095" action="executeview" viewname="bw_rm_organisation_masterview" append="false" attribute="org_displayname" workflowtimeslot="false">
					
					
					
					
					<ViewParam name="P15226555000950" param="uid" paramvalue="{dataset.org_uid.get()}"/>
					<ViewAttribute name="P1522655500095_1" attribute="displayname" variable="org_displayname"/>
					<ViewAttribute name="P1522655500095_2" attribute="code" variable="org_code"/>
				</Action>
				<Action name="U1540486618081" action="executeview" viewname="bwpm_totalrightsperorg" append="false" workflowtimeslot="false" attribute="mining_totalprogress">
					<ViewParam name="P15404866180810" param="uid" paramvalue="{dataset.org_uid.get()}"/>
					<ViewAttribute name="P1540486618081_1" attribute="nbrights" variable="mining_totalprogress"/>
				</Action>
				<Action name="U1522830294163" action="update" attribute="manualtasktitle" newvalue="Role mining &quot;{dataset.org_displayname.get()}&quot;"/>
			</Actions>
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="org_displayname"/>
				<Attribute name="custom2" attribute="org_uid"/>
			</Ticket>
			<Output name="output" ticketlogrecorduidvariable="ticketlog" processidvariable="processIdentifier"/>
			<Candidates name="role" role="A1522580300247"/>
			<Page name="bw_rm_detail_start" template="/library/pagetemplates/workflow/startProcess.pagetemplate"/>
			<FormVariable name="A1540558775926" variable="org_uid" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="394" y="509" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="C1522580384838" type="manualactivity" x="685" y="316" w="300" h="114" title="Role mining {dataset.org_displayname.get()}" duedate="{dataset.campaigndeadline.get()}" outexclusive="true">
			<Candidates name="role" role="A1522580300247">
				<Reminder name="reminder" alternateduedate="()}" number="0" periodformat="b" period="10"/>
			</Candidates>
			<Escalation name="escalation" includetaskrole="true" mail="A1522850628085">
				<Start name="start" delay="10" delayformat="b"/>
				<Reminder name="reminder" number="1" periodformat="b" period="1" delay="1" delayformat="b" mail="A1522850644427"/>
			</Escalation>
			
			<Page name="bw_rm_rolemining" template="/library/pagetemplates/workflow/manualActivity.pagetemplate"/>
			<TicketAction create="true"/>
			<Output name="output" ticketactionnumbervariable="mining_ticketaction"/>
		</Component>
		<Component name="C1524224227918" type="routeactivity" x="177" y="47" w="300" h="50" compact="true" title="Route 2"/>
		<Component name="C1524224227918_1" type="routeactivity" x="177" y="511" w="300" h="50" compact="true" title="Route 2"/>
		<Link name="L1524224236465" source="CSTART" target="C1524224227918" priority="2" labelcustom="true" label="nothing to mine"/>
		<Link name="L1524224237681" source="C1524224227918" target="C1524224227918_1" priority="1"/>
		<Link name="L1524224239698" source="C1524224227918_1" target="CEND" priority="1"/>
		<Link name="CLINK" source="CSTART" target="C1584722952080" priority="1" expression="dataset.mining_totalprogress.get()&gt;0" labelcustom="true" label="something to mine"/>
		<Component name="C1584722952080" type="callactivity" x="685" y="22" w="300" h="98" title="Prepare mining scope">
			<Process workflowfile="/workflow/bw_rm/scope/preparescopedata.workflow">
				<Input name="A1584723100568" variable="organisationuid" content="org_uid"/>
				<Input name="A1584976631760" variable="processIdentifier" content="processIdentifier"/>
				<Output name="A1584978740009" variable="metadataUid" content="metadataUid"/>
			</Process>
		</Component>
		<Link name="L1584723045677" source="C1584722952080" target="C1585059573708" priority="1"/>
		<Link name="L1584723047643" source="C1522580384838" target="C1584978257886" priority="1"/>
		<Component name="C1584978257886" type="metadataactivity" x="685" y="484" w="300" h="98" title="Delete mining scope">
			<Metadata action="D" metadatauid="metadataUid"/>
		</Component>
		<Link name="L1584978272913" source="C1584978257886" target="CEND" priority="1"/>
		<Component name="C1585059573708" type="variablechangeactivity" x="685" y="168" w="300" h="98" title="onInitialize">
			<Actions function="onInitialize"/>
		</Component>
		<Link name="L1585059655638" source="C1585059573708" target="C1522580384838" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1522578515450" variable="campaignid" displayname="campaign id" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false" description="id de la campagne"/>
		<Variable name="A1522578527221" variable="compaignduration" displayname="duration" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="false" initialvalue="10"/>
		<Variable name="A1522578539227" variable="campaigndeadline" displayname="deadline" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="false" initialvalue="20190101"/>
		<Variable name="A1522578551932" variable="org_uid" displayname="uid" editortype="Ledger Organisation" type="String" multivalued="false" visibility="in" notstoredvariable="false" description="uid de l&apos;organisation"/>
		<Variable name="A1522578588715" variable="prioritylevel" displayname="priority level" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="false" initialvalue="1"/>
		<Variable name="A1522579951781" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="bw_rm_detail" notstoredvariable="false"/>
		<Variable name="A1522758543117" variable="mining_ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522759296097" variable="mining_currentprogress" displayname="current progress" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="false"/>
		<Variable name="A1522759310377" variable="mining_totalprogress" displayname="total progress" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="false" description="mono valuée ( multi pour remplir avec une vue)"/>
		<Variable name="A1522766696132" variable="masterticketlog" displayname="master ticketlog" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1522775796047" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522830262225" variable="manualtasktitle" displayname="manual task title" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1531917908934" variable="previouscampaignrecorduid" displayname="previous campaign recorduid" editortype="Default" type="Number" multivalued="false" visibility="in" description="previous campaign recorduid" notstoredvariable="false"/>
		<Variable name="A1539952269736" variable="org_displayname" displayname="Organisation" editortype="Default" type="String" multivalued="false" visibility="local" description="Organisation" notstoredvariable="true"/>
		<Variable name="A1539952371924" variable="org_code" displayname="Code" editortype="Default" type="String" multivalued="false" visibility="local" description="Code" notstoredvariable="true"/>
		<Variable name="S1542027462409" variable="role_reviews" multivalued="true" visibility="local" editortype="Structure" type="String" description="liste des roles revus" notstoredvariable="false"/>
		<Variable name="A1542027509477" variable="rolereview_codes" displayname="role codes" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1542027462409" notstoredvariable="true"/>
		<Variable name="A1542027545489" variable="rolereview_actoruids" displayname="actor uids" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1542027462409" notstoredvariable="true"/>
		<Variable name="A1542027586458" variable="rolereview_actorfullnames" displayname="reviewer full name" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1542027462409" notstoredvariable="true"/>
		<Variable name="A1542027612808" variable="rolereview_comments" displayname="review comments" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1542027462409" notstoredvariable="true"/>
		<Variable name="A1542027646277" variable="rolereview_statuses" displayname="review statuses" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1542027462409" notstoredvariable="true"/>
		<Variable name="A1552654292912" variable="perm_rulenames" displayname="perm_rulenames" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="false"/>
		<Variable name="A1584976510282" variable="processIdentifier" displayname="processIdentifier" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1584978679393" variable="metadataUid" displayname="metadataUid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1680107596731" variable="initActor" editortype="Process Actor" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1522580300247" displayname="miners" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" description="role miners">
			<Variable name="A1680107601807" variable="initActor"/>
		</Role>
		<Role name="A1522580333696" displayname="escalation" description="role miners managers" icon="/reports/icons/48/people/personal_red_48.png" smallicon="/reports/icons/16/people/personal_red_16.png">
			<Rule name="A1522580348913" rule="bw_rm_miners_escalation" description="escalation {uid}">
				<Param name="uid" variable="org_uid"/>
			</Rule>
		</Role>
		<Role name="A1542017324197" icon="/reports/icons/48/people/personal_48.png" displayname="reviewers" description="role reviewers" smallicon="/reports/icons/16/people/personal_16.png">
			<Rule name="A1542017356337" rule="bw_rm_rolereviewers" description="reviewers {uid}">
				<Param name="uid" variable="org_uid"/>
			</Rule>
		</Role>
	</Roles>
	<ComplianceReport format="PDF" locale="en" exportname="{process.title.normalize().toLowerCase()}.pdf">
		<Parameter name="958" key="recorduid" macrovalue="{dataset.ticketlog.get()}"/>
	</ComplianceReport>
	<Mails>
		<Mail name="A1522850592468" displayname="notification" description="notification" toaddtaskrole="true" notifyrule="bw_rm_notification" workflowtimeslot="true"/>
		<Mail name="A1522850614541" displayname="reminder" description="reminder" notifyrule="bw_rm_reminder"/>
		<Mail name="A1522850628085" displayname="escalation" description="escalation" notifyrule="bw_rm_escalation"/>
		<Mail name="A1522850644427" displayname="escalationreminder" description="escalation reminder" notifyrule="bw_rm_escalationreminder"/>
		<Mail name="A1522850758096" displayname="reassignation" description="reassignation" notifyrule="bw_rm_reassignation"/>
		<Mail name="A1542039430071" notifyrule="bw_rm_review" displayname="review" description="review of mined roles" torole="A1542017324197"/>
	</Mails>
</Workflow>
