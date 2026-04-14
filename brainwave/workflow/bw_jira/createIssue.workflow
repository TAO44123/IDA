<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_jiracreateIssue" statictitle="create a Jira issue" scriptfile="/workflow/bw_jira/jira.javascript" displayname="create a Jira issue" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="172" y="51" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1662974281692"/>
		</Component>
		<Component name="CEND" type="endactivity" x="172" y="324" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1662974307708" priority="1"/>
		<Component name="C1662974307708" type="scriptactivity" x="46" y="163" w="300" h="98" title="create Jira ticket">
			<Script onscriptexecute="createTicket"/>
		</Component>
		<Link name="L1662974324740" source="C1662974307708" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1662974135283" variable="summary" displayname="summary" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662974141887" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662974152901" variable="issueType" displayname="issueType" editortype="Default" type="String" multivalued="false" visibility="in" initialvalue="Task" notstoredvariable="true"/>
		<Variable name="A1662974166737" variable="tags" displayname="tags" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662974213506" variable="projectkey" displayname="projectkey" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662974225807" variable="assignee" displayname="assignee" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662974254826" variable="ticketCreated" displayname="ticketCreated" editortype="Default" type="Boolean" multivalued="false" visibility="out" notstoredvariable="false" initialvalue="false"/>
		<Variable name="A1662974263890" variable="ticketId" displayname="ticketId" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="false"/>
		<Variable name="A1662974274050" variable="ticketNumber" displayname="ticketNumber" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="false"/>
		<Variable name="A1662975744977" variable="domain" displayname="domain" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="in the form of https://brainwavegrc-sandbox-9999.atlassian.net"/>
		<Variable name="A1662975749893" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account login"/>
		<Variable name="A1662975755275" variable="token" displayname="token" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account token"/>
		<Variable name="A1743104178271" variable="errorMessage" displayname="errorMessage" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1662974281692" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1662974289938" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
