<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_rm_master" statictitle="Role Mining by organisation" description="Role Mining by organisation" scriptfile="workflow/bw_rm/campaign/master.javascript" displayname="Role Mining by organisation {dataset.campaignid.get()} {dataset.processStartDate.get().toDateString()}" releaseontimeout="true" type="REVIEW" errorpage="bw_rm_management" infopage="bw_rm_management" reportpage="bw_rm_management" campaignpage="">
		<Component name="CSTART" type="startactivity" x="145" y="27" w="200" h="114" title="Start" compact="true" priorityvariable="prioritylevel" duedatevariable="deadline" progressvariable="currentProgress" progresstotalvariable="totalProgress">
			<Candidates name="role" role="A1522514634767"/>
			<Page name="bwrm_campaign_config_wizard" template="/library/pagetemplates/workflow/startProcess.pagetemplate"/>
			<Actions function="init">
				<Action name="U1522577977534" action="update" attribute="totalProgress" newvalue="{dataset.uid.length}"/>
				<Action name="U1522577994437" action="update" attribute="currentProgress" newvalue="0"/>
			</Actions>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
			</Ticket>
			<FormVariable name="A1522578094869" variable="campaignid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1522578103501" variable="duration" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1522578113350" variable="prioritylevel" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1522578118625" variable="uid" action="input" mandatory="true" longlist="false"/>
			<Output name="output" startdatevariable="processStartDate" ticketactionnumbervariable="ticketaction" ticketlogrecorduidvariable="ticketlog" startidentityvariable="processActorUid"/>
		</Component>
		<Component name="CEND" type="endactivity" x="145" y="651" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1522747432973" priority="1"/>
		<Component name="C1522578676382" type="callactivity" x="67" y="245" w="204" h="98" title="Role Mining by organisation">
			<Process workflowfile="/workflow/bw_rm/campaign/detail.workflow" oncompletion="updateProgress">
				<Input name="A1522578787846" variable="campaigndeadline" content="deadline"/>
				<Input name="A1522578794077" variable="prioritylevel" content="prioritylevel"/>
				<Input name="A1522578802024" variable="compaignduration" content="duration"/>
				<Input name="A1522578808765" variable="campaignid" content="campaignid"/>
				<Input name="A1522578814055" variable="org_uid" content="uid"/>
				<Input name="A1522766711397" variable="masterticketlog" content="ticketlog"/>
				<Input name="A1531917925741" variable="previouscampaignrecorduid" content="previouscampaignrecorduid"/>
				<Input name="A1552654323894" variable="perm_rulenames" content="perm_rulenames"/>
				<Input name="A1680107874804" variable="initActor" content="processActorUid"/>
			</Process>
			<Iteration listvariable="uid"/>
		</Component>
		<Link name="L1522578692595" source="C1522578676382" target="C1522742948270" priority="1"/>
		
		<Component name="C1522742948270" type="routeactivity" x="67" y="382" w="204" h="98" title="no ticket for organisation"/>
		
		<Component name="C1522747432973" type="variablechangeactivity" x="67" y="111" w="204" h="98" title="Get campaign owner">
			<Actions>
				<Action name="U1522747519960" action="executeview" viewname="bw_rm_campaign_information" append="false" attribute="campaignowner">
					<ViewParam name="P15227475199600" param="recorduid" paramvalue="{dataset.ticketlog.get()}"/>
					<ViewAttribute name="P1522747519960_1" attribute="owneruid" variable="campaignowner"/>
					<ViewAttribute name="P1522747519960_2" attribute="recorduid" variable="campaigninstancerecorduid"/>
				</Action>
				<Action name="U1531917705716" action="executeview" viewname="bw_rm_getpreviouscampaigninstance" append="false" attribute="previouscampaignrecorduid">
					<ViewParam name="P15319177057160" param="campaignrecorduid" paramvalue="{dataset.campaigninstancerecorduid.get()}"/>
					<ViewParam name="P15319177057161" param="currentinstance" paramvalue="{dataset.ticketlog.get()}"/>
					<ViewAttribute name="P1531917705716_2" attribute="recorduid" variable="previouscampaignrecorduid"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1522747463629" source="C1522747432973" target="C1522578676382" priority="1"/>
		<Link name="L1604321515481" source="C1522742948270" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1522514634767" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everybody" description="everybody">
			<Rule name="A1522514649506" rule="control_activeidentities" description="Active Identities"/>
		</Role>
		<Role name="A1522747610821" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1522747637775" rule="identitypicker" description="identity picker by {uid}">
				<Param name="uid" variable="campaignowner"/>
				<Param name="localuid"/>
			</Rule>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1522514691339" variable="uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false" description="liste des organisations "/>
		<Variable name="A1522515199512" variable="prioritylevel" displayname="priority level" editortype="Default" type="Number" multivalued="false" visibility="local" description="priority level" notstoredvariable="false"/>
		<Variable name="A1522569249831" variable="campaignid" displayname="campaignid" editortype="Default" type="String" multivalued="false" visibility="local" description="review id" notstoredvariable="false"/>
		<Variable name="A1522569262362" variable="duration" displayname="duration" editortype="Default" type="Number" multivalued="false" visibility="local" description="duration" notstoredvariable="false"/>
		<Variable name="A1522577704444" variable="deadline" displayname="deadline" editortype="Default" type="Date" multivalued="false" visibility="local" description="deadline (computed in init script from duration)" notstoredvariable="false"/>
		<Variable name="A1522577939853" variable="currentProgress" displayname="current progress" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="false"/>
		<Variable name="A1522577957135" variable="totalProgress" displayname="total progress" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522578057258" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="bw_rm_master" notstoredvariable="false"/>
		<Variable name="A1522578178367" variable="processStartDate" displayname="process start date" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522743165689" variable="ticketaction" displayname="ticket action" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522743282013" variable="TICKETREVIEWSTATUS" displayname="ticket review status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REVIEWPERIMETER" notstoredvariable="false"/>
		<Variable name="A1522743378663" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1522747392295" variable="campaignowner" displayname="campaign owner" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1531915869030" variable="previouscampaignrecorduid" displayname="previouscampaignrecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" description="previous campaign recorduid" notstoredvariable="false"/>
		<Variable name="A1531917474903" variable="campaigninstancerecorduid" displayname="campaigninstancerecorduid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1552578830500" variable="perm_rulenames" displayname="permission rule names" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1680107786716" variable="processActorUid" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<ComplianceReport format="PDF" locale="en" exportname="{process.title.normalize().toLowerCase()}.pdf">
		<Parameter name="958" key="recorduid" macrovalue="{dataset.ticketlog.get()}"/>
	</ComplianceReport>
	<Mails>
		<Mail name="A1522747525235" displayname="campaign done" description="campaign done" notifyrule="bw_rm_campaign_done" workflowtimeslot="true" torole="A1522747610821"/>
	</Mails>
</Workflow>
