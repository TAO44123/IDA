<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_subscription_addapplicationsubscriber" statictitle="add application subscriber" scriptfile="/workflow/bw_subscription/addapplicationsubscriber.javascript" displayname="add application subscriber" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="73" y="157" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1638796070644" action="multiresize" attribute="subscriber" attribute1="applications" attribute2="reportids" attribute3="subscribed"/>
				<Action name="U1638796089463" action="multireplace" attribute="applications" newvalue="{dataset.application.get()}"/>
				<Action name="U1638796107401" action="multireplace" attribute="reportids" newvalue="{dataset.reportid.get()}"/>
				<Action name="U1643105028126" action="multireplace" attribute="subscribed" newvalue="{true}"/>
			</Actions>
			<Candidates name="role" role="A1638802410306"/>
		</Component>
		<Component name="CEND" type="endactivity" x="621" y="157" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1638796122736" priority="1"/>
		<Component name="C1638796122736" type="metadataactivity" x="227" y="132" w="300" h="98" title="create metadata">
			<Metadata action="C" schema="bw_subscription_application">
				<Identity identity="subscriber"/>
				<Data subkey="reportids" boolean="subscribed"/>
				<Application application="applications"/>
			</Metadata>
		</Component>
		<Link name="L1638796137030" source="C1638796122736" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1638795799837" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="false" visibility="in" description="Application to subscribe" notstoredvariable="true"/>
		<Variable name="A1638795912827" variable="subscriber" displayname="subscriber" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" description="Subscribers" notstoredvariable="true"/>
		<Variable name="A1638795944663" variable="reportid" displayname="reportid" editortype="Default" type="String" multivalued="false" visibility="in" initialvalue="Synthesis" notstoredvariable="true" description="Report identifier"/>
		<Variable name="A1638796021630" variable="applications" displayname="applications" editortype="Ledger Application" type="String" multivalued="true" visibility="local" description="internal variable" notstoredvariable="true"/>
		<Variable name="A1638796035232" variable="reportids" displayname="reportids" editortype="Default" type="String" multivalued="true" visibility="local" description="internal variable" notstoredvariable="true"/>
		<Variable name="A1638957484883" variable="subscribed" displayname="subscribed" editortype="Default" type="Boolean" multivalued="true" visibility="local" description="INTERNAL VALUE TO FULFILL THE METADATA " initialvalue="true" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1638802410306" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1638802432118" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
