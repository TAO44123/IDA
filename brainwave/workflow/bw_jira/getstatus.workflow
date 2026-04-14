<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_jiragetstatus" statictitle="get status" scriptfile="workflow/bw_jira/jira.javascript" displayname="get status" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="197" y="59" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1662992179994"/>
		</Component>
		<Component name="CEND" type="endactivity" x="197" y="403" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1662992129346" priority="1"/>
		<Component name="C1662992129346" type="scriptactivity" x="71" y="201" w="300" h="98" title="get ticket status">
			<Script onscriptexecute="getStatus"/>
		</Component>
		<Link name="L1662992143430" source="C1662992129346" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1662992179994" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1662992207420" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1662988940815" variable="ticketid" displayname="ticketid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662975744977" variable="domain" displayname="domain" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="in the form of https://brainwavegrc-sandbox-9999.atlassian.net"/>
		<Variable name="A1662975749893" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account login"/>
		<Variable name="A1662975755275" variable="token" displayname="token" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account token"/>
		<Variable name="A1662992591621" variable="statusretrieved" displayname="statusretrieved" editortype="Default" type="Boolean" multivalued="false" visibility="out" notstoredvariable="false"/>
		<Variable name="A1662992613968" variable="statuslabel" displayname="statuslabel" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="false"/>
		<Variable name="A1662992605870" variable="statusid" displayname="statusid" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="false"/>
	</Variables>
</Workflow>
