<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_uploadAccessRightsReviewTickets" statictitle="upload Access Rights Review Tickets" description="upload Access Rights Review Tickets" scriptfile="/workflow/bw_access360/writeAccessRightsReviewTickets.javascript" displayname="upload Access Rights Review Tickets" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="625" y="28" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="false" createaction="false"/>
			<Output name="output"/>
			<Actions function="prepareRecorduid">
			</Actions>
			<Candidates name="role" role="A1625131797349"/>
		</Component>
		<Component name="CEND" type="endactivity" x="625" y="348" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="L1627112220979" source="CSTART" target="C1630422555118" priority="1" expression="dataset.currentcampaignid.get().equals(dataset.loadedcampaignid.get())" labelcustom="true" label="File corresponds to the current campaign"/>
		<Component name="C1630422555118" type="callactivity" x="499" y="160" w="300" h="98" title="writeAccessRightsReviewTickets">
			<Process workflowfile="/workflow/bw_access360/writeAccessRightsReviewTickets.workflow">
				<Input name="A1630422575893" variable="comment" content="comment"/>
				<Input name="A1630422580493" variable="status" content="status"/>
				<Input name="A1630422589925" variable="updatecomment" content="updatecomment"/>
				<Input name="A1630422594598" variable="updatestatus" content="updatestatus"/>
				<Input name="A1630422599142" variable="ticketreviewrecorduid" content="ticketreviewrecorduid"/>
				<Input name="A1630423114439" variable="actiondate" content="actiondate"/>
			</Process>
		</Component>
		<Link name="L1630422607721" source="C1630422555118" target="CEND" priority="1"/>
		<Link name="L1630422974018" source="CSTART" target="CEND" priority="2" labelcustom="true" label="skip otherwise"/>
	</Definition>
	<Variables>
		<Variable name="A1625130389173" variable="status" displayname="status" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1625130397891" variable="comment" displayname="comment" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1626630598666" variable="ticketreviewrecorduid" displayname="ticketreviewrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1627112168134" variable="updatecomment" displayname="update comment" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1627112183495" variable="updatestatus" displayname="update status" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1630422633258" variable="currentcampaignid" displayname="currentcampaignid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1630422650121" variable="ticketreviewitem" displayname="ticketreviewitem" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1630422842650" variable="loadedcampaignid" displayname="loadedcampaignid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1630423093532" variable="actiondate" displayname="actiondate" editortype="Default" type="Date" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1625131797349" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1625131814826" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
