<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwiasr_accountsremediationrequest" statictitle="accounts remediation request" description="Use this workflow to initiate accounts remediation request&#xA;This will create all the corresponding &amp; needed ticketreview for the change to occur" scriptfile="/workflow/bw_iasremediation/accountsremediationrequest.javascript" displayname="accounts remediation request" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="255" y="54" w="200" h="114" title="Start - bwiasr_accountsremediationrequest" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="TICKETACTION" startidentityvariable="processowner"/>
			<Actions function="init">
				<Action name="U1658907746684" action="empty" attribute="labels"/>
				<Action name="U1658907757448" action="empty" attribute="identitypositionkeys"/>
				<Action name="U1658907767301" action="empty" attribute="reviewersorigin"/>
				<Action name="U1658907776865" action="empty" attribute="remediationtype"/>
				<Action name="U1658907806065" action="multiresize" attribute="accountuid" attribute1="labels" attribute2="identitypositionkeys" attribute3="reviewersorigin" attribute4="remediationtype" attribute5="accountableuid"/>
				<Action name="U1658907821167" action="multireplace" attribute="labels" newvalue="-"/>
				<Action name="U1658907844410" action="multireplace" attribute="identitypositionkeys" newvalue="$$"/>
				<Action name="U1658907874783" action="multireplace" attribute="reviewersorigin" newvalue="default"/>
				<Action name="U1658907899286" action="multireplace" attribute="remediationtype" newvalue="account"/>
				<Action name="U1658909317206" action="multireplace" attribute="accountableuid" newvalue="{dataset.isEmpty(&apos;accountableuid&apos;)?dataset.processowner.get():dataset.accountableuid.get()}"/>
			</Actions>
			<Candidates name="role" role="A1658909116957"/>
			<FormVariable name="A1666789910561" variable="accountuid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1666789919491" variable="comment" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1670338280317" variable="status_ticketreview" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="255" y="960" w="200" h="98" title="End - bwiasr_accountsremediationrequest" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1626342140458_1" priority="1"/>
		<Component name="C1626342140458_1" type="ticketreviewactivity" x="129" y="158" w="300" h="98" title="init review tickets">
			<TicketReview ticketaction="TICKETACTION" ticketaccountables="accountableuid" ticketactors="accountableuid">
				<Right/>
				<Attribute name="status" attribute="status_ticketreview"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="custom1" attribute="labels"/>
				<Attribute name="custom2" attribute="identitypositionkeys"/>
				<Attribute name="custom3" attribute="reviewersorigin"/>
				<Account accountvariable="accountuid"/>
				<Attribute name="custom4" attribute="remediationtype"/>
			</TicketReview>
			<Output name="output" ticketreviewnumbervariable="ticketreview"/>
		</Component>
		<Component name="C1658907935413" type="callactivity" x="129" y="660" w="300" h="98" title="init remediation tickets">
			<Process workflowfile="/workflow/bw_access360/createRemediationTickets.workflow">
				<Input name="A1658908965945" variable="accountableuid" content="remediation_accountableuid"/>
				<Input name="A1658908971311" variable="actiondate" content="remediation_actiondate"/>
				<Input name="A1658908990362" variable="comment" content="remediation_comment"/>
				<Input name="A1658909002889" variable="status" content="remediation_status"/>
				<Input name="A1658909013425" variable="ticketclosed" content="remediation_ticketclosed"/>
				<Input name="A1658909025396" variable="ticketlabel" content="remediation_ticketlabel"/>
				<Input name="A1658909032217" variable="ticketreviewrecorduid" content="remediation_ticketreviewrecorduid"/>
				<Input name="A1658909038537" variable="tickettype" content="remediation_tickettype"/>
			</Process>
		</Component>
		<Component name="C1658908550027" type="variablechangeactivity" x="129" y="487" w="300" h="98" title="get review tickets infos for remediation">
			<Actions>
				<Action name="U1658908751232" action="executeview" viewname="bwiasr_getticketreviewinfos" append="false" attribute="remediation_ticketreviewrecorduid">
					<ViewParam name="P16589087512320" param="ticketreviews" paramvalue="{dataset.ticketreview}"/>
					<ViewParam name="P16589087512321" param="status_remediation" paramvalue="{dataset.status_remediation.get()}"/>
					<ViewAttribute name="P1658908751232_2" attribute="recorduid" variable="remediation_ticketreviewrecorduid"/>
					<ViewAttribute name="P1658908751232_3" attribute="accountableuid" variable="remediation_accountableuid"/>
					<ViewAttribute name="P1658908751232_4" attribute="actiondate" variable="remediation_actiondate"/>
					<ViewAttribute name="P1658908751232_5" attribute="comment" variable="remediation_comment"/>
					<ViewAttribute name="P1658908751232_6" attribute="closed" variable="remediation_ticketclosed"/>
					<ViewAttribute name="P1658908751232_7" attribute="displayname" variable="remediation_ticketlabel"/>
					<ViewAttribute name="P1658908751232_8" attribute="remediationtype" variable="remediation_tickettype"/>
					<ViewAttribute name="P1658908751232_9" attribute="remediation_status" variable="remediation_status"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1658908952250" source="C1658908550027" target="C1658907935413" priority="1"/>
		<Link name="L1658908953181" source="C1658907935413" target="C1666100300971" priority="1"/>
		<Component name="N1658909050589" type="note" x="535" y="87" w="300" h="71" title="WARNING&#xA;Limited to a maximum of 1000 entries per call&#xA;due to database engine limitation"/>
		<Component name="N1658922509787" type="note" x="542" y="193" w="300" h="50" title="Entries with pending or on-going remediation will be automatically ignored"/>
		<Component name="C1666100300971" type="callactivity" x="129" y="810" w="300" h="98" title="update latest review ticket status">
			<Process workflowfile="/workflow/bw_access360/markLatestAccountReviewStatus.workflow">
				<Input name="A1666100339791" variable="accountuid" content="accountuid"/>
			</Process>
		</Component>
		<Link name="L1666100349993" source="C1666100300971" target="CEND" priority="1"/>
		<Component name="C1673010472444" type="callactivity" x="129" y="320" w="300" h="98" title="getDummyMetadata">
			<Process workflowfile="/workflow/bw_iasremediation/getDummyMetadata.workflow"/>
		</Component>
		<Link name="L1673010475642" source="C1626342140458_1" target="C1673010472444" priority="1"/>
		<Link name="L1673010476371" source="C1673010472444" target="C1658908550027" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1658906875335" variable="accountuid" displayname="accounts" editortype="Ledger Account" type="String" multivalued="true" visibility="in" description="Accounts to remediate" notstoredvariable="true"/>
		<Variable name="A1658906934650" variable="comment" displayname="comments" editortype="Default" type="String" multivalued="true" visibility="in" description="remediation comments" notstoredvariable="true"/>
		<Variable name="A1658906979597" variable="accountableuid" displayname="accountable" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" description="optional: The one requesting for this change to occur&#xA;defaults to current process owner" notstoredvariable="true"/>
		<Variable name="A1658907103963" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ADHOC_REMEDIATION" notstoredvariable="true"/>
		<Variable name="A1658907159911" variable="TICKETACTION" displayname="TICKETACTION" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1658907258597" variable="ticketreview" displayname="ticketreview" editortype="Default" type="Number" multivalued="true" visibility="local" description="ticket review created" notstoredvariable="true"/>
		<Variable name="A1658907630779" variable="labels" displayname="labels" editortype="Default" type="String" multivalued="true" visibility="local" description="empty when manual remediation request" notstoredvariable="true"/>
		<Variable name="A1658907653732" variable="identitypositionkeys" displayname="identitypositionkeys" editortype="Default" type="String" multivalued="true" visibility="local" description="empty when manual remediation request" notstoredvariable="true"/>
		<Variable name="A1658907666255" variable="remediationtype" displayname="remediationtype" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1658907692444" variable="reviewersorigin" displayname="reviewersorigin" editortype="Default" type="String" multivalued="true" visibility="local" description="empty when manual remediation request" notstoredvariable="true"/>
		<Variable name="A16589087512320" variable="remediation_ticketreviewrecorduid" displayname="remediation_ticketreviewrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16589087512321" variable="remediation_accountableuid" displayname="remediation_accountableuid" multivalued="true" visibility="local" type="String" editortype="Ledger Identity"/>
		<Variable name="A16589087512322" variable="remediation_actiondate" displayname="remediation_actiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16589087512323" variable="remediation_comment" displayname="remediation_comment" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16589087512324" variable="remediation_status" displayname="remediation_status" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16589087512325" variable="remediation_ticketclosed" displayname="remediation_ticketclosed" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16589087512326" variable="remediation_ticketlabel" displayname="remediation_ticketlabel" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16589087512327" variable="remediation_tickettype" displayname="remediation_tickettype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1658909213456" variable="processowner" displayname="processowner" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1670336052545" variable="status_ticketreview" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" displayname="Ticket Review Status" description="Ticket Review Status" initialvalue="revoke"/>
		<Variable name="A1670336063257" variable="status_remediation" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" displayname="Remediation ticket status" description="Remediation ticket status" initialvalue="new"/>
	</Variables>
	<Roles>
		<Role name="A1658909116957" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1658909135418" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
