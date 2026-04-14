<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_createRemediationTickets" statictitle="createRemediationTickets" scriptfile="/workflow/bw_access360/createRemediationTickets.javascript" displayname="{dataset.campaignid}" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="245" y="57" w="200" h="114" title="Start - bwaccess360_createRemediationTickets" compact="true" outexclusive="true">
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="MYTICKETTYPE"/>
			</Ticket>
			<Candidates name="role" role="A1627043938302"/>
			<Actions function="init">
				<Action name="U1642069338152" action="default" attribute="actiondate" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1698407780182" action="multiresize" attribute="ticketreviewrecorduid" attribute1="allstatus"/>
				<Action name="U1698407790880" action="multireplace" attribute="allstatus" newvalue="2"/>
			</Actions>
			<Output name="output" startidentityvariable="processactor" ticketactionnumbervariable="ticketaction"/>
		</Component>
		<Component name="CEND" type="endactivity" x="245" y="653" w="200" h="98" title="End - bwaccess360_createRemediationTickets" compact="true"/>
		<Link name="L1627048025165" source="CSTART" target="C1673010411684" priority="1"/>
		<Component name="C1627041080421_1" type="ticketreviewactivity" x="119" y="492" w="300" h="98" title="create remediation review tickets" inexclusive="true">
			<TicketReview ticketaction="ticketaction" ticketactors="processactor" ticketaccountables="accountableuid" parentticket="ticketreviewrecorduid">
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Account/>
				<Metadata metadatavariable="metadatauid"/>
				<Attribute name="custom1" attribute="ticketlabel"/>
				<Attribute name="custom2" attribute="ticketclosed"/>
				<Attribute name="custom3" attribute="tickettype"/>
				<Attribute name="custom4" attribute="timeslot"/>
			</TicketReview>
			<Iteration/>
		</Component>
		<Component name="N1627460880576_1" type="note" x="448" y="47" w="367" h="95" title="Remediation information is written in a review ticket&#xA;This ticket is associated to a &quot;dummy metadata&quot; and  therefore is not considered (displayed) as a decision in IAS Tabs"/>
		<Component name="N1627203650419_2" type="note" x="467" y="474" w="173" h="239" title="manual status values:&#xA;new&#xA;work in progress&#xA;done&#xA;won&apos;t fix"/>
		<Component name="N1627460347894_1" type="note" x="669" y="481" w="300" h="207" title="custom1 : printable label&#xA;custom2: -1 = remediation ready to be launched, 0 = ticket open, 1 = ticket closed, done, 2 = ticket closed, cancel&#xA;custom3: embedded / itsm&#xA;custom4: timeslotuid when the last remediation ticket update has been made&#xA;custom5&#x9;External reference (Displayable Ticket Number)&#xA;custom6&#x9;External reference (internal infos)&#xA;custom7&#x9;External system instance&#xA;custom8&#x9;External system hyperlink"/>
		<Component name="C1673010411684" type="callactivity" x="119" y="153" w="300" h="98" title="getDummyMetadata">
			<Process workflowfile="/workflow/bw_iasremediation/getDummyMetadata.workflow">
				<Output name="A1673010458668" variable="metadataUid" content="metadatauid"/>
			</Process>
		</Component>
		<Component name="C1698076849984_1" type="updateticketreviewactivity" x="119" y="321" w="300" h="98" title="mark review tickets as processed">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduid">
				<Attribute name="custom5" attribute="allstatus"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1698408152744" source="C1673010411684" target="C1698076849984_1" priority="1"/>
		<Link name="L1698408153548" source="C1698076849984_1" target="C1627041080421_1" priority="1"/>
		<Link name="L1698408154238" source="C1627041080421_1" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1627043876059" variable="status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043884314" variable="comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043893235" variable="actiondate" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627043934531" variable="ticketreviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627044311491" variable="accountableuid" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627044391598" variable="campaignid" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627048002108" variable="metadatauid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627461049009" variable="ticketclosed" displayname="ticket is closed" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="0 - no&#xA;1 - yes, done&#xA;2 - yes, cancel"/>
		<Variable name="A1627461063036" variable="ticketlabel" displayname="ticket label" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627461212330" variable="tickettype" displayname="ticket type" editortype="Default" type="String" multivalued="true" visibility="in" description="manual&#xA;itsm:[instanceid]&#xA;..." notstoredvariable="true"/>
		<Variable name="A1642069413181" variable="processactor" displayname="processactor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1642069434766" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1642069756423" variable="timeslot" displayname="timeslot" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1642069919442" variable="MYTICKETTYPE" displayname="MYTICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="ADHOC_REMEDIATION" notstoredvariable="true"/>
		<Variable name="A1698407757870" variable="allstatus" displayname="allstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1627043938302" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1627043948561" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
