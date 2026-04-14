<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_attachremediationstrategy" statictitle="attach remediation strategy" description="attach remediation strategy on a resource (repository)" scriptfile="/workflow/bw_iasreview/attachremediationstrategy.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="413" y="75" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655127718279"/>
			<Actions>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="413" y="557" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="CLINK" source="CSTART" target="C1656337250151" priority="1" expression="dataset.repository.length&gt;0" labelcustom="true" label="attach to repos"/>
		<Component name="C1655127855904" type="metadataactivity" x="89" y="373" w="300" h="98" title="create or update repo itsm strategy">
			<Metadata action="C" schema="bwr_remediation_repository">
				<Repository repository="repository"/>
				<Data string1="types" string2="iid"/>
			</Metadata>
		</Component>
		<Link name="L1655127913784" source="C1655127855904" target="CEND" priority="1"/>
		<Component name="C1655127855904_1" type="metadataactivity" x="501" y="373" w="300" h="98" title="create or update app itsm strategy">
			<Metadata action="C" schema="bwr_remediation_application">
				<Repository/>
				<Data string1="types" string2="iid"/>
				<Application application="application"/>
			</Metadata>
		</Component>
		<Link name="L1656335923281" source="CSTART" target="C1656337250151_1" priority="2" expression="dataset.application.length&gt;0" labelcustom="true" label="attach to apps"/>
		<Link name="L1656335924307" source="C1655127855904_1" target="CEND" priority="1"/>
		<Link name="L1656335953822" source="CSTART" target="CEND" priority="3"/>
		<Component name="C1656337250151" type="variablechangeactivity" x="89" y="213" w="300" h="98" title="prepare values">
			<Actions>
				<Action name="U1656337274192" action="multiresize" attribute="repository" attribute1="iid" attribute2="types"/>
				<Action name="U1656337293978" action="multireplace" attribute="types" newvalue="{dataset.remediationtype.get()}"/>
				<Action name="U1656337312701" action="multireplace" attribute="iid" newvalue="{dataset.remediationinstanceid.get()}"/>
			</Actions>
		</Component>
		<Link name="L1656337332604" source="C1656337250151" target="C1655127855904" priority="1"/>
		<Component name="C1656337250151_1" type="variablechangeactivity" x="501" y="213" w="300" h="98" title="prepare values">
			<Actions>
				<Action name="U1656337274192" action="multiresize" attribute="application" attribute1="iid" attribute2="types"/>
				<Action name="U1656337293978" action="multireplace" attribute="types" newvalue="{dataset.remediationtype.get()}"/>
				<Action name="U1656337312701" action="multireplace" attribute="iid" newvalue="{dataset.remediationinstanceid.get()}"/>
			</Actions>
		</Component>
		<Link name="L1656337351654" source="C1656337250151_1" target="C1655127855904_1" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655127718279" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655127726829" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1655127751960" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655127785744" variable="remediationtype" displayname="remediation type" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true">
			<StaticValue name="embedded"/>
			<StaticValue name="itsm"/>
		</Variable>
		<Variable name="A1655127821621" variable="remediationinstanceid" displayname="remediation instance id" editortype="Default" type="String" multivalued="false" visibility="in" description="remediation instance id" notstoredvariable="true"/>
		<Variable name="A1655134650768" variable="types" displayname="types" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655134657462" variable="iid" displayname="iid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1656335891821" variable="application" displayname="application" editortype="Ledger Application" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
