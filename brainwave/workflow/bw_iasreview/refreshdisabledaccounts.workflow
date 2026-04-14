<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_refreshdisabledaccounts" statictitle="refreshdisabledaccounts" scriptfile="/workflow/bw_iasreview/refreshdisabledaccounts.javascript" technical="true">
		<Component name="CSTART" type="startactivity" x="214" y="55" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1655727525254" action="executeview" viewname="bwiasr_pendingdisabledaccountsperrepo" append="false" attribute="remediationrecorduid">
					<ViewAttribute name="P1655727525254_0" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655727525254_1" attribute="newremediationstatus" variable="newremediationstatus"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1655727583808"/>
		</Component>
		<Component name="CEND" type="endactivity" x="214" y="389" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1655727536041" priority="1"/>
		<Component name="C1655727536041" type="updateticketreviewactivity" x="88" y="195" w="300" h="98" title="change closed status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="custom2" attribute="newremediationstatus"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1655727560638" source="C1655727536041" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A16557275252540" variable="remediationrecorduid" displayname="remediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16557275252541" variable="newremediationstatus" displayname="newremediationstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
	</Variables>
	<Roles>
		<Role name="A1655727583808" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655727593273" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
