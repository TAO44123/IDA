<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_compute_account_identity_metadata" statictitle="compute account identity metadata" scriptfile="/workflow/bw_analytics/compute account identity metadata.javascript" displayname="compute account identity metadata" releaseontimeout="true" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="319" y="-122" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="description"/>
				<Attribute name="status" attribute="STATUS"/>
			</Ticket>
			<Candidates name="role" role="A1608143151275"/>
			<Actions>
				<Action name="U1608143410241" action="executeview" viewname="bwa_accountsensitivitylevelmetadata" append="false" attribute="metadatauid">
					<ViewAttribute name="P1608143410241_0" attribute="metadatauid" variable="metadatauid"/>
				</Action>
				<Action name="U1608143440033" action="executeview" viewname="bwa_identitysensitivitylevelmetadata" append="true" attribute="metadatauid">
					<ViewAttribute name="P1608143440033_0" attribute="metadatauid" variable="metadatauid"/>
				</Action>
				<Action name="U1608144999704" action="update" attribute="description" newvalue="refresh account&amp;identity metadata using {dataset.includeapplications.get()?&apos;applications&apos;:&apos;&apos;} {dataset.includefolders.get()?&apos;folders&apos;:&apos;&apos;} {dataset.includegroups.get()?&apos;groups&apos;:&apos;&apos;} {dataset.includepermissions.get()?&apos;permissions&apos;:&apos;&apos;} {dataset.includerepositories.get()?&apos;repositories&apos;:&apos;&apos;} {dataset.includeshares.get()?&apos;shares&apos;:&apos;&apos;}"/>
			</Actions>
			<Output name="output" startidentityvariable="issuer"/>
		</Component>
		<Component name="CEND" type="endactivity" x="319" y="1402" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1608145041677" action="update" attribute="STATUS" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1608143488484" type="variablechangeactivity" x="193" y="12" w="300" h="98" title="compute account metadata">
			<Actions>
				<Action name="U1608143623446" action="executeview" viewname="bwa_accountmaxsensitivitylevel" append="false" attribute="uid">
					<ViewParam name="P16081436234460" param="includeapplications" paramvalue="{dataset.includeapplications.get()}"/>
					<ViewParam name="P16081436234461" param="includefolders" paramvalue="{dataset.includefolders.get()}"/>
					<ViewParam name="P16081436234462" param="includegroups" paramvalue="{dataset.includegroups.get()}"/>
					<ViewParam name="P16081436234463" param="includepermissions" paramvalue="{dataset.includepermissions.get()}"/>
					<ViewParam name="P16081436234464" param="includerepositories" paramvalue="{dataset.includerepositories.get()}"/>
					<ViewParam name="P16081436234465" param="includeshares" paramvalue="{dataset.includeshares.get()}"/>
					<ViewAttribute name="P1608143623446_6" attribute="uid" variable="uid"/>
					<ViewAttribute name="P1608143623446_7" attribute="maxsensitivitylevel" variable="sensitivitylevel"/>
					<ViewAttribute name="P1608143623446_8" attribute="manualsensitivitylevel" variable="manualsensitivitylevel"/>
					<ViewAttribute name="P1608143623446_9" attribute="description" variable="descr"/>
					<ViewAttribute name="P1608143623446_10" attribute="sensitivityreason" variable="sensitivityreason"/>
					<ViewAttribute name="P1608143623446_11" attribute="metadatauid" variable="metadatauid"/>
				</Action>
			</Actions>
		</Component>
		<Component name="C1608143664109" type="metadataactivity" x="193" y="396" w="300" h="98" title="save account metadata">
			<Metadata action="C" schema="bwa_accountmetadata">
				<Account account="uid"/>
				<Data integer1="sensitivitylevel" boolean="manualsensitivitylevel" string4="descr" string5="sensitivityreason"/>
			</Metadata>
		</Component>
		<Component name="C1608143764912" type="variablechangeactivity" x="193" y="551" w="300" h="98" title="compute identity metadata">
			<Actions>
				<Action name="U1608143813204" action="empty" attribute="uid"/>
				<Action name="U1608143821996" action="empty" attribute="sensitivitylevel"/>
				<Action name="U1620141666852" action="empty" attribute="descr"/>
				<Action name="U1620141677006" action="empty" attribute="sensitivityreason"/>
				<Action name="U1620141693641" action="empty" attribute="manualsensitivitylevel"/>
				<Action name="U1620202829469" action="empty" attribute="metadatauid"/>
				<Action name="U1608143861697" action="executeview" viewname="bwa_identitymaxsensitivitylevel" append="false" attribute="uid">
					<ViewParam name="P16081438616970" param="includeorganisations" paramvalue="{dataset.includeorganisations.get()}"/>
					<ViewAttribute name="P1608143861697_1" attribute="uid" variable="uid"/>
					<ViewAttribute name="P1608143861697_2" attribute="maxsensitivitylevel" variable="sensitivitylevel"/>
					<ViewAttribute name="P1608143861697_3" attribute="manualsensitivitylevel" variable="manualsensitivitylevel"/>
					<ViewAttribute name="P1608143861697_4" attribute="description" variable="descr"/>
					<ViewAttribute name="P1608143861697_5" attribute="sensitivityreason" variable="sensitivityreason"/>
					<ViewAttribute name="P1608143861697_6" attribute="metadatauid" variable="metadatauid"/>
				</Action>
			</Actions>
		</Component>
		<Component name="C1608143962915" type="metadataactivity" x="193" y="1048" w="300" h="98" title="save identity metadata">
			<Metadata schema="bwa_identitymetadata" action="C">
				<Identity identity="uid"/>
				<Data integer1="sensitivitylevel" boolean="manualsensitivitylevel" string4="descr" string5="sensitivityreason"/>
			</Metadata>
		</Component>
		<Link name="L1608144346918" source="C1608143764912" target="C1620202710164_1" priority="1"/>
		<Link name="L1608144347720" source="C1608143962915" target="C1608198122661" priority="1"/>
		<Link name="L1608144348839" source="C1608143664109" target="C1608143764912" priority="1"/>
		<Link name="L1608144351899" source="C1608143488484" target="C1620202710164" priority="1"/>
		<Component name="C1608198122661" type="mailnotificationactivity" x="193" y="1215" w="300" h="98" title="Refresh done notification">
			<Notification name="mail" mail="A1608198078194" ignoreerror="true"/>
		</Component>
		<Link name="L1608198147361" source="C1608198122661" target="CEND" priority="1"/>
		<Component name="C1608143257471_1" type="metadataactivity" x="193" y="264" w="300" h="98" title="delete account metadata">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1620200731518" source="C1608143257471_1" target="C1608143664109" priority="1"/>
		<Link name="L1620200753508" source="CSTART" target="C1608143488484" priority="1"/>
		<Component name="C1620202710164" type="variablechangeactivity" x="193" y="140" w="300" h="98" title="cleanup metadatauid">
			<Actions>
				<Action name="U1620202737243" action="multiclean" attribute="metadatauid" emptyvalues="true" duplicates="true"/>
			</Actions>
		</Component>
		<Link name="L1620202755016" source="C1620202710164" target="C1608143257471_1" priority="1"/>
		<Component name="C1608143257471_2" type="metadataactivity" x="193" y="879" w="300" h="98" title="delete identity metadata">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1620205699638" source="C1608143257471_2" target="C1608143962915" priority="1"/>
		<Component name="C1620202710164_1" type="variablechangeactivity" x="193" y="721" w="300" h="98" title="cleanup metadatauid">
			<Actions>
				<Action name="U1620202737243" action="multiclean" attribute="metadatauid" emptyvalues="true" duplicates="true"/>
			</Actions>
		</Component>
		<Link name="L1620205784702" source="C1620202710164_1" target="C1608143257471_2" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1608143151275" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608143163041" rule="bwdc_active_identities" description="active identities"/>
		</Role>
		<Role name="A1608199815209" description="issuer" icon="/reports/icons/48/people/personal_yellow_48.png" smallicon="/reports/icons/16/people/personal_yellow_16.png" displayname="issuer">
			<Variable name="A1608200409867" variable="issuer"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1608143293013" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608143521893" variable="sensitivitylevel" displayname="sensitivitylevel" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608143527898" variable="uid" displayname="uid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608144389028" variable="TICKETTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="Compute account&amp;identity sensitivity level" notstoredvariable="true"/>
		<Variable name="A1608144716562" variable="includeapplications" displayname="include applications" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144730265" variable="includeshares" displayname="include shares" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144744941" variable="includerepositories" displayname="include repositories" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144775471" variable="includepermissions" displayname="include permissions" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144790678" variable="includefolders" displayname="include folders" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144841888" variable="includegroups" displayname="include groups" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A1608144871239" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608145026343" variable="STATUS" displayname="STATUS" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="true"/>
		<Variable name="A1608199798956" variable="issuer" displayname="issuer" editortype="Process Actor" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1610458044529" variable="includeorganisations" displayname="includeorganisations" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="true"/>
		<Variable name="A16081436234462" variable="manualsensitivitylevel" displayname="manual sensitivity level" multivalued="true" visibility="local" type="Boolean" editortype="Default"/>
		<Variable name="A1620141523551" variable="descr" displayname="descr" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1620141565095" variable="sensitivityreason" displayname="sensitivityreason" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Mails>
		<Mail name="A1608198078194" displayname="computingDone" description="Computing done" torole="A1608199815209" notifyrule="bwa_computesensitivitylevelsdone"/>
	</Mails>
</Workflow>
