<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_automateProceedSignof" statictitle="automate Proceed Signof for review tickets" description="Technical workflow: Automate processing sign-of for signed-of entries" scriptfile="/workflow/bw_access360/automateProceedSignof.javascript" displayname="automate Proceed Signof for review tickets" type="builtin-technical-workflow">
		<Component name="CEND" type="endactivity" x="448" y="823" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="N1699615596363" type="note" x="689" y="79" w="386" h="111" title="Proceed all signed of pending access rights review tickets"/>
		<Component name="C1699615610285" type="routeactivity" x="72" y="-116" w="300" h="50" compact="true" title="Route 1"/>
		<Component name="C1699615614744" type="routeactivity" x="72" y="426" w="300" h="50" compact="true" title="Route 2"/>
		<Link name="L1699615620670" source="C1699615610285" target="C1699615614744" priority="1"/>
		<Link name="L1699615621597" source="C1699615614744" target="CEND" priority="1"/>
		<Component name="C1699615713924" type="variablechangeactivity" x="322" y="164" w="300" h="98" title="prepare attributes for remediation" outexclusive="true">
			<Actions>
				<Action name="U1699626791890" action="executeview" viewname="bwaccess360_accessreviewcampaignsentriestoremediate" append="false" attribute="action_recorduid">
					<ViewParam name="P16996267918900" param="ticketreviewrecorduids" paramvalue="{dataset.revokeupdaterecorduids}"/>
					<ViewAttribute name="P1699626791890_1" attribute="recorduid" variable="action_recorduid"/>
					<ViewAttribute name="P1699626791890_2" attribute="remediationstatus" variable="action_remediationstatus"/>
					<ViewAttribute name="P1699626791890_3" attribute="remediationclosed" variable="action_remediationclosed"/>
					<ViewAttribute name="P1699626791890_4" attribute="comment" variable="action_comment"/>
					<ViewAttribute name="P1699626791890_5" attribute="label" variable="action_label"/>
					<ViewAttribute name="P1699626791890_6" attribute="remediationtype" variable="action_remediationtype"/>
				</Action>
				<Action name="U1689626791891" action="executeview" viewname="bwaccess360_repositoryaccountsreviewcampaignsentriestoremediate" append="true" attribute="action_recorduid">
					<ViewParam name="P16996267918900" param="ticketreviewrecorduids" paramvalue="{dataset.revokeupdaterecorduids}"/>
					<ViewAttribute name="P1699626791890_1" attribute="recorduid" variable="action_recorduid"/>
					<ViewAttribute name="P1699626791890_2" attribute="remediationstatus" variable="action_remediationstatus"/>
					<ViewAttribute name="P1699626791890_3" attribute="remediationclosed" variable="action_remediationclosed"/>
					<ViewAttribute name="P1699626791890_4" attribute="comment" variable="action_comment"/>
					<ViewAttribute name="P1699626791890_5" attribute="label" variable="action_label"/>
					<ViewAttribute name="P1699626791890_6" attribute="remediationtype" variable="action_remediationtype"/>
				</Action>
				<Action name="U1697626791892" action="executeview" viewname="bwaccess360_repositorygroupmembersreviewcampaignsentriestoremediate" append="true" attribute="action_recorduid">
					<ViewParam name="P16996267918900" param="ticketreviewrecorduids" paramvalue="{dataset.revokeupdaterecorduids}"/>
					<ViewAttribute name="P1699626791890_1" attribute="recorduid" variable="action_recorduid"/>
					<ViewAttribute name="P1699626791890_2" attribute="remediationstatus" variable="action_remediationstatus"/>
					<ViewAttribute name="P1699626791890_3" attribute="remediationclosed" variable="action_remediationclosed"/>
					<ViewAttribute name="P1699626791890_4" attribute="comment" variable="action_comment"/>
					<ViewAttribute name="P1699626791890_5" attribute="label" variable="action_label"/>
					<ViewAttribute name="P1699626791890_6" attribute="remediationtype" variable="action_remediationtype"/>
				</Action>
				<Action name="U2699628161425" action="multiresize" attribute="action_recorduid" attribute1="action_date" attribute2="action_accountable"/>
				<Action name="U2699628189646" action="multireplace" attribute="action_date" newvalue="{new Date()}"/>
			</Actions>
		</Component>
		<Component name="C1699615713924_1" type="variablechangeactivity" x="322" y="453" w="300" h="98" title="get all pending entries" inexclusive="true" outexclusive="true">
			<Actions>
				<Action name="U1699627997907" action="executeview" viewname="bwa_allentriesexplicitelyapprovedsofar" append="false" attribute="allrecorduids">
					<ViewParam name="P16996279979070" param="filterbydelay" paramvalue="{dataset.delay.get()}"/>
					<ViewAttribute name="P1699627997907_1" attribute="recorduid" variable="allrecorduids"/>
				</Action>
			</Actions>
		</Component>
		<Component name="C1699615766738" type="callactivity" x="322" y="626" w="300" h="98" title="mark all entries as processed">
			<Process workflowfile="/workflow/bw_access360/markEntryExplicitelyProcessed.workflow">
				<Input name="A1699628347827" variable="reviewrecorduids" content="allrecorduids"/>
			</Process>
		</Component>
		<Component name="C1699615766738_1" type="callactivity" x="322" y="315" w="300" h="98" title="initiate remediation">
			<Process workflowfile="/workflow/bw_access360/createRemediationTickets.workflow">
				<Input name="A1699626848715" variable="ticketreviewrecorduid" content="action_recorduid"/>
				<Input name="A1699626906106" variable="status" content="action_remediationstatus"/>
				<Input name="A1699626927012" variable="ticketclosed" content="action_remediationclosed"/>
				<Input name="A1699626935619" variable="ticketlabel" content="action_label"/>
				<Input name="A1699626951647" variable="tickettype" content="action_remediationtype"/>
				<Input name="A1699628221890" variable="comment" content="action_comment"/>
				<Input name="A1699628258390" variable="accountableuid" content="action_accountable"/>
				<Input name="A1699628299283" variable="actiondate" content="action_date"/>
			</Process>
		</Component>
		<Link name="L1699615853938" source="C1699615713924" target="C1699615766738_1" priority="1" labelcustom="false"/>
		<Link name="L1699615854648" source="C1699615766738_1" target="C1699615713924_1" priority="1"/>
		<Link name="L1699615856271" source="C1699615713924_1" target="C1699615766738" priority="1" expression="dataset.allrecorduids.length&gt;0" labelcustom="true" label="Pending entries to proceed?"/>
		<Link name="L1699615857207" source="C1699615766738" target="CEND" priority="1"/>
		<Component name="CSTART" type="startactivity" x="448" y="-116" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1701255037358" action="update" attribute="delay" newvalue="{config.ias_reviewproceedsignedentriesdelay}" condition="dataset.delay.get()==314159256"/>
				<Action name="U1699626452824" action="multiclean" attribute="actionstatus" emptyvalues="true" duplicates="false"/>
				<Action name="U1699626477280" action="multiadd" attribute="actionstatus" newvalue="revoke" duplicates="false"/>
				<Action name="U1699626486857" action="multiadd" attribute="actionstatus" newvalue="update" duplicates="false"/>
			</Actions>
			<Candidates name="role" role="A1699628827645"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1699615713924_2" priority="1" labelcustom="true" label="Automation enabled?" expression="&quot;1&quot;.equals(config.ias_reviewautomateproceedsignedentries) || &quot;true&quot;.equalsIgnoreCase(config.ias_reviewautomateproceedsignedentries)"/>
		<Link name="L1699615619760" source="CSTART" target="C1699615610285" priority="2"/>
		<Link name="L1699630199844" source="C1699615713924_2" target="C1699615713924_1" priority="2"/>
		<Component name="C1699615713924_2" type="variablechangeactivity" x="324" y="5" w="300" h="98" title="get recorduids with remediation actions" outexclusive="true">
			<Actions function="limit">
				<Action name="U1699627828652" action="executeview" viewname="bwa_allentriesexplicitelyapprovedsofar" append="false" attribute="revokeupdaterecorduids">
					<ViewParam name="P16996278286520" param="status" paramvalue="{dataset.actionstatus}"/>
					<ViewParam name="P16996278286521" param="filterbydelay" paramvalue="{dataset.delay.get()}"/>
					<ViewAttribute name="P1699627828652_2" attribute="recorduid" variable="revokeupdaterecorduids"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1701353866713" source="C1699615713924_2" target="C1699615713924" priority="1" expression="dataset.revokeupdaterecorduids.length&gt;0" labelcustom="true" label="remediations to launch?"/>
		<Link name="L1701354162069" source="C1699615713924_1" target="CEND" priority="2"/>
	</Definition>
	<Variables>
		<Variable name="A1699626432142" variable="actionstatus" displayname="actionstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A16996267918900" variable="action_recorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16996267918901" variable="action_remediationstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16996267918902" variable="action_remediationclosed" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16996267918903" variable="action_comment" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16996267918904" variable="action_label" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16996267918905" variable="action_remediationtype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16996278286520" variable="revokeupdaterecorduids" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A16996279979070" variable="allrecorduids" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A1699628092835" variable="action_date" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1699628113278" variable="action_accountable" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1699628766973" variable="delay" displayname="delay" editortype="Default" type="Number" multivalued="false" visibility="in" description="Grace Delay (number of days) to consider when selecting signed-of tickets.&#xA;This is an optional parameter, the config parameter value is used by default.&#xA;(314159256 is a magic number here to ignore the value)" notstoredvariable="true" initialvalue="314159256"/>
	</Variables>
	<Roles>
		<Role name="A1699628827645" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1699628837621" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
