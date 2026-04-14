<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_jiraaddattachment" statictitle="add attachment" scriptfile="/workflow/bw_jira/jira.javascript" displayname="add attachment" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="253" y="52" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1662988912455"/>
		</Component>
		<Component name="CEND" type="endactivity" x="253" y="361" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1662989031043" priority="1"/>
		<Component name="C1662989031043" type="scriptactivity" x="127" y="178" w="300" h="98" title="add attachment">
			<Script onscriptexecute="addAttachment"/>
		</Component>
		<Link name="L1662991732488" source="C1662989031043" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1662988912455" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1662988925779" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1662988940815" variable="ticketid" displayname="ticketid" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662988967140" variable="filename" displayname="filename" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662988974265" variable="filecontent" displayname="filecontent" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1662975744977" variable="domain" displayname="domain" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="in the form of https://brainwavegrc-sandbox-9999.atlassian.net"/>
		<Variable name="A1662975749893" variable="login" displayname="login" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account login"/>
		<Variable name="A1662975755275" variable="token" displayname="token" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="account token"/>
		<Variable name="A1662989409375" variable="attachmentdone" displayname="attachment done" editortype="Default" type="Boolean" multivalued="false" visibility="out" notstoredvariable="false"/>
	</Variables>
</Workflow>
