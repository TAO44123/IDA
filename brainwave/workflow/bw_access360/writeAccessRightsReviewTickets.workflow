<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_writeAccessRightsReviewTickets" statictitle="write Access Rights Review Tickets" description="update Access Rights Review Tickets for any type of review ( generic)" scriptfile="/workflow/bw_access360/writeAccessRightsReviewTickets.javascript" displayname="write Access Rights Review Tickets" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="613" y="28" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true" createaction="false">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="custom1" attribute="campaignId"/>
			</Ticket>
			<Output name="output" startidentityvariable="processactor"/>
			<Actions>
				<Action name="U1625130766582" action="multireplace" attribute="actiondate" newvalue="{new Date()}"/>
				<Action name="U1627316002218" action="multiresize" attribute="ticketreviewrecorduid" attribute1="responsible"/>
				<Action name="U1627316017399" action="multireplace" attribute="responsible" newvalue="{dataset.processactor.get()}"/>
			</Actions>
			<Candidates name="role" role="A1625131797349"/>
		</Component>
		<Component name="CEND" type="endactivity" x="598" y="390" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="C1626630644209" type="updateticketreviewactivity" x="92" y="185" w="300" h="98" title="update review ticket">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduid" ticketactors="processactor">
				<Attribute name="status" attribute="status"/>
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="actiondate" attribute="actiondate"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1626630703781" source="CSTART" target="C1626630644209" priority="1" expression="dataset.updatestatus.get() &amp;&amp; dataset.updatecomment.get()" labelcustom="true" label="status &amp; comment"/>
		<Link name="L1626630704589" source="C1626630644209" target="CEND" priority="1"/>
		<Component name="C1626630644209_1" type="updateticketreviewactivity" x="478" y="185" w="300" h="98" title="update review ticket status">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduid" ticketactors="processactor">
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="status" attribute="status"/>
			</UpdateTicketReview>
		</Component>
		<Component name="C1626630644209_2" type="updateticketreviewactivity" x="818" y="185" w="300" h="98" title="update review ticket comment">
			<UpdateTicketReview ticketreviewnumbervariable="ticketreviewrecorduid" ticketactors="processactor">
				<Attribute name="comment" attribute="comment"/>
				<Attribute name="actiondate" attribute="actiondate"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1627112215190" source="CSTART" target="C1626630644209_1" priority="2" expression="dataset.updatestatus.get() &amp;&amp; !dataset.updatecomment.get()" labelcustom="true" label="status only"/>
		<Link name="L1627112216134" source="C1626630644209_1" target="CEND" priority="1"/>
		<Link name="L1627112217342" source="CSTART" target="C1626630644209_2" priority="3" expression="!dataset.updatestatus.get() &amp;&amp; dataset.updatecomment.get()" labelcustom="true" label="comment only"/>
		<Link name="L1627112218617" source="C1626630644209_2" target="CEND" priority="1"/>
		<Link name="L1627112220979" source="CSTART" target="CEND" priority="4"/>
		<Component name="N1704382471405" type="note" x="95" y="46" w="220" h="50" title="generic workflow can be called for any type of review"/>
	</Definition>
	<Variables>
		<Variable name="A1625130389173" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1625130397891" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1625130702440" variable="actiondate" displayname="actiondate" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626630598666" variable="ticketreviewrecorduid" displayname="ticketreviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627112168134" variable="updatecomment" displayname="update comment" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1627112183495" variable="updatestatus" displayname="update status" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1627315929353" variable="processactor" editortype="Process Actor" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1627315978511" variable="responsible" displayname="responsible" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" description="set to processactor" notstoredvariable="true"/>
		<Variable name="A1716501316311" variable="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="REVIEW" notstoredvariable="true"/>
		<Variable name="A1716544108761" variable="campaignId" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1625131797349" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1625131814826" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
