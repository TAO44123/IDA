<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="virtual_timeslot" displayname="virtual_timeslot" publish="false" technical="true" scriptfile="workflow/bw_ledger_admin/manageTimeslot.javascript" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="32" y="144" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Candidates name="role" role="A1418830025652"/>
		</Component>
		<Component name="CEND" type="endactivity" x="953" y="144" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1418830005229" priority="1" expression="(dataset.isEmpty(&apos;execute_timestamp&apos;))" labelcustom="true" label="Execute now"/>
		<Component name="C1418830005229" type="timeslotactivity" x="531" y="118" w="200" h="98" title="Actions">
			<Timeslot name="timeslot" timeslotuid="timeslot_uid" timeslotaction="action_code" timeslotnewname="new_name"/>
		</Component>
		<Link name="L1418830010919" source="C1418830005229" target="CEND" priority="1"/>
		<Component name="C1532446692803" type="routeactivity" x="32" y="455" w="300" h="50" compact="true" title="Route 1"/>
		<Link name="L1532446714104" source="CSTART" target="C1532446692803" priority="2" expression="(! dataset.isEmpty(&apos;execute_timestamp&apos;))" labelcustom="true" label="Delay Execution"/>
		<Link name="L1532446733609" source="C1532446692803" target="C1532529622094" priority="1"/>
		<Component name="C1532447178339" type="timeractivity" x="481" y="429" w="300" h="98" title="Wait for execution">
			<Timer name="timer" delayformat="n" delay="{dataset.delayInMinutes.get()}"/>
		</Component>
		<Link name="L1532447194950" source="C1532447178339" target="C1418830005229" priority="1"/>
		<Component name="C1532529622094" type="variablechangeactivity" x="123" y="430" w="300" h="98" title="Calculate Delay" outexclusive="true">
			<Actions function="calculateDelay"/>
		</Component>
		<Link name="L1532529642105" source="C1532529622094" target="C1532447178339" priority="2" expression="(! dataset.equals(&apos;delayInMinutes&apos;, &apos;0&apos;, false, true))" labelcustom="true" label="Wait"/>
		<Link name="L1532624133006" source="C1532529622094" target="C1418830005229" priority="1" expression="(dataset.equals(&apos;delayInMinutes&apos;, &apos;0&apos;, false, true)) || (dataset.isEmpty(&apos;delayInMinutes&apos;))" labelcustom="true" label="Execute now"/>
	</Definition>
	<Roles>
		<Role name="A1418830025652" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="test_rule" description="test rule">
			<Rule name="A1418830038470" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1418830156879" variable="action_code" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" displayname="action"/>
		<Variable name="A1418830179774" variable="timeslot_uid" displayname="timeslot" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1418830766538" variable="new_name" displayname="new_name" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1532442857728" variable="execute_timestamp" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
		<Variable name="A1532529792060" variable="delayInMinutes" displayname="delayInMinutes" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="false"/>
		<Variable name="A1533137927473" variable="user_timestamp" displayname="user_timestamp" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
	</Variables>
</Workflow>
