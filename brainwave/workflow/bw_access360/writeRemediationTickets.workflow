<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_writeRemediationTickets" statictitle="writeRemediationTickets" scriptfile="/workflow/bw_access360/writeRemediationTickets.javascript" publish="true" technical="true" releaseontimeout="true" type="Scheduled">
		<Component name="CSTART" type="startactivity" x="181" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1627202588654"/>
			<Actions function="init">
				<Action name="U1627202681340" action="multireplace" attribute="actiondate" newvalue="{dataset.isEmpty(&apos;actiondate&apos;)?dataset.actiondate.set(new Date().toLDAPString()):dataset.actiondate.get()}"/>
				<Action name="U1627318354664" action="multiresize" attribute="remediationticketrecorduid" attribute1="reviewers"/>
				<Action name="U1627318369378" action="multireplace" attribute="reviewers" newvalue="{dataset.processactor.get()}"/>
			</Actions>
			<Output name="output" startidentityvariable="processactor"/>
		</Component>
		<Component name="CEND" type="endactivity" x="181" y="325" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1627202689073" priority="1"/>
		<Component name="C1627202689073" type="updateticketreviewactivity" x="55" y="137" w="300" h="98" title="update remediation tickets">
			<UpdateTicketReview ticketreviewnumbervariable="remediationticketrecorduid" ticketactors="reviewers">
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom2" attribute="ticketclosed"/>
				<Attribute name="custom4" attribute="timeslot"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1627202739452" source="C1627202689073" target="CEND" priority="1"/>
		<Component name="N1627203650419" type="note" x="460" y="89" w="180" h="119" title="new&#xA;work in progress&#xA;done&#xA;won&apos;t fix"/>
	</Definition>
	<Variables>
		<Variable name="A1627202241595" variable="remediationticketrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627202249205" variable="status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="new&#xA;work in progress&#xA;done&#xA;won&apos;t fix"/>
		<Variable name="A1627202263118" variable="comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627202282783" variable="actiondate" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627202788288" variable="processactor" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627318317099" variable="reviewers" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627461919833" variable="ticketclosed" displayname="ticket is closed" editortype="Default" type="String" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true" description="0 - no&#xA;1 - yes, done&#xA;2 - yes, cancel"/>
		<Variable name="A1629737773070" variable="timeslot" displayname="timeslot" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1627202588654" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1627202598061" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
