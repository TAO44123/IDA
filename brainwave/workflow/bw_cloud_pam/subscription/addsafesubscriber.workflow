<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwpam_notification_addsafesubscriber" statictitle="add safe owner subscriber" scriptfile="workflow/bw_cloud_pam/subscription/addsafesubscriber.javascript" displayname="add safe owner subscriber" technical="true">
		<Component name="CSTART" type="startactivity" x="73" y="157" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1662132249556" action="update" attribute="safeslistuid" newvalue="{dataset.insafes}"/>
				<Action name="U1638796070644" action="multiresize" attribute="insafes" attribute1="reportids" attribute2="subscribed" attribute3="subscribers"/>
				<Action name="U1638796107401" action="multireplace" attribute="reportids" newvalue="{dataset.reportid.get()}"/>
				<Action name="U1643105028126" action="multireplace" attribute="subscribed" newvalue="{true}"/>
				<Action name="U1661780151296" action="multireplace" attribute="subscribers" newvalue="{dataset.subscriber.get()}"/>
			</Actions>
			<Candidates name="role" role="A1638802410306"/>
			<FormVariable name="A1662372406615" variable="reportid" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1662372414112" variable="subscriber" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1662372495593" variable="insafes" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="621" y="157" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1638796122736" priority="1"/>
		<Component name="C1638796122736" type="metadataactivity" x="227" y="132" w="300" h="98" title="create metadata">
			<Metadata action="C" schema="bwpam_notification_safes">
				<Identity identity="subscribers"/>
				<Data subkey="reportids" boolean="subscribed" string3="safeslistuid"/>
				<ValueApplication application_value="insafes"/>
			</Metadata>
		</Component>
		<Link name="L1638796137030" source="C1638796122736" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1638795912827" variable="subscriber" displayname="subscriber" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" description="Subscriber" notstoredvariable="true"/>
		<Variable name="A1638795944663" variable="reportid" displayname="reportid" editortype="Default" type="String" multivalued="false" visibility="in" initialvalue="My Safes Synthesis" notstoredvariable="true" description="Report identifier"/>
		<Variable name="A1638796021630" variable="insafes" displayname="insafes" editortype="Ledger Application" type="String" multivalued="true" visibility="in" description="internal variable" notstoredvariable="true"/>
		<Variable name="A1638796035232" variable="reportids" displayname="reportids" editortype="Default" type="String" multivalued="true" visibility="local" description="internal variable" notstoredvariable="true"/>
		<Variable name="A1638957484883" variable="subscribed" displayname="subscribed" editortype="Default" type="Boolean" multivalued="true" visibility="local" description="INTERNAL VALUE TO FULFILL THE METADATA " initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1661780055602" variable="subscribers" displayname="subscribers" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662132499326" variable="safeslistuid" displayname="safeslistuid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true" description="Initial safes list UID"/>
	</Variables>
	<Roles>
		<Role name="A1638802410306" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1638802432118" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
