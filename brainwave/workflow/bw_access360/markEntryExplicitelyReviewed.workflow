<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_markEntryExplicitelyReviewed" statictitle="mark Entry as Explicitely Reviewed" description="mark Entries as Explicitely Reviewed&#xA;custom5 = 1&#xA;custom6 = entry explicitely reviewed by (name)&#xA;custom7 = entry explicitely reviewed on date)" scriptfile="/workflow/bw_access360/markEntryExplicitelyReviewed.javascript" displayname="mark Entry as Explicitely Reviewed">
		<Component name="CSTART" type="startactivity" x="227" y="11" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1698050180756"/>
			<Output name="output" startidentityvariable="processowner"/>
			<Actions function="entriesReviewed">
				<Action name="U1698403030953" action="default" attribute="currentreviewer" newvalue="{dataset.processowner.get()}"/>
				<Action name="U1698402762550" action="executeview" viewname="bwf_identityDetail" append="false" attribute="reviewerfullname">
					<ViewParam name="P16984027625500" param="uid" paramvalue="{dataset.currentreviewer.get()}"/>
					<ViewAttribute name="P1698402762550_1" attribute="fullname" variable="reviewerfullname"/>
				</Action>
			</Actions>
			<FormVariable name="A1698057599359" variable="campaignid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1698057605038" variable="currentreviewer" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1698415538655" variable="forcemarkentry" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="230" y="413" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1729148338257" priority="1"/>
		<Component name="C1698050597954" type="updateticketreviewactivity" x="104" y="254" w="300" h="98" title="mark entries as explicitely reviewed">
			<UpdateTicketReview ticketreviewnumbervariable="ticketrecorduids">
				<Attribute name="custom5" attribute="allstatus"/>
				<Attribute name="custom6" attribute="reviewers"/>
				<Attribute name="custom7" attribute="allreviewdate"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1698050861108" source="C1698050597954" target="CEND" priority="1"/>
		<Component name="N1698057380012" type="note" x="524" y="43" w="374" h="156" title="Mark already reviewed entries as being explicitely reviewed by the reviewer"/>
		<Component name="C1729148338257" type="variablechangeactivity" x="100" y="109" w="300" h="98" title="Update variable">
			<Actions>
				<Action name="U1729148489020" action="update" attribute="reviewedon" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1698050522115" action="multiresize" attribute="ticketrecorduids" attribute1="allreviewdate" attribute2="allstatus" attribute3="reviewers"/>
				<Action name="U1698050540922" action="multireplace" attribute="allreviewdate" newvalue="{dataset.reviewedon.get()}"/>
				<Action name="U1698050562521" action="multireplace" attribute="allstatus" newvalue="{dataset.isreviewed.get()}"/>
				<Action name="U1698050582868" action="multireplace" attribute="reviewers" newvalue="{dataset.reviewerfullname.get()}"/>			
			</Actions>
		</Component>
		<Link name="L1729148369203" source="C1729148338257" target="C1698050597954" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1698050180756" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1698050193229" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1698050220740" variable="campaignid" displayname="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" description="campaign id" notstoredvariable="true"/>
		<Variable name="A1698050241306" variable="isreviewed" displayname="is reviewed status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="1" notstoredvariable="true"/>
		<Variable name="A1698050272002" variable="reviewerfullname" displayname="reviewerfullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698050302539" variable="reviewedon" displayname="reviewedon" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698050377211" variable="ticketrecorduids" displayname="ticketrecorduids" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698050451561" variable="reviewers" displayname="reviewers" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698050471440" variable="allstatus" displayname="allstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698050481417" variable="allreviewdate" displayname="allreviewdate" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1698051549507" variable="currentreviewer" displayname="currentreviewer" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="current reviewer (will only consider entries where the reviewer is accountable for)&#xA;defaults to the process owner" notstoredvariable="true"/>
		<Variable name="A1698221894788" variable="reviewtickets" displayname="reviewtickets" editortype="Default" type="Number" multivalued="true" visibility="in" description="OPTIONAL review tickets to explicitely mark" notstoredvariable="true"/>
		<Variable name="A1698402835298" variable="forcemarkentry" displayname="forcemarkentry" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="Default behavior is to only mark entries where the current reviewer is accountable for, unless this value is set to True" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1698403000797" variable="processowner" displayname="processowner" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
