<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_scheduler" statictitle="Scheduler" scriptfile="workflow/bw_iasreview2/svc/scheduler.javascript" displayname="Scheduler Instance">
		<Component name="CSTART" type="startactivity" x="211" y="39" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="custom1" attribute="loopCounter"/>
				<Attribute name="custom2" attribute="lastExecutionDate"/>
				<Attribute name="custom3" attribute="initialScheduledDate"/>
			</Ticket>
			<FormVariable name="A1710156629538" variable="scheduleHourOfDay" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1710156652065" variable="scheduleMinute" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1703102977327" variable="simulate" action="input" mandatory="false" longlist="false"/>
			<Candidates name="role" role="A1703103015272"/>
			<Actions function="computeInitialSchedule"/>
			<Page name="bwr_schedulerStart" template="/library/pagetemplates/workflow/startProcess.pagetemplate"/>
		</Component>
		<Component name="CEND" type="endactivity" x="214" y="734" w="200" h="98" title="End" compact="true">
			<Actions/>
		</Component>
		<Component name="C1703102828795" type="callactivity" x="139" y="403" w="198" h="98" title="review campaign scheduler">
            <Process workflowfile="/workflow/bw_iasreview2/svc/campaign_scheduler.workflow" standalone="true" detachedprocess="true" currenttimeslot="true">
                <Input name="A1703103091659" variable="simulate" content="simulate"/>
                <Input name="A1703103097163" variable="simulateNow" content="simulateNow"/>
                <Output name="A1703191155564" variable="runTasks" content="reviewRunTasks"/>
            </Process>
        </Component>    
		<Link name="CLINK" source="CSTART" target="C1710156317812" priority="1"/>
		<Component name="C1710156317812" type="timeractivity" x="158" y="116" w="153" h="98" title="initialTimer">
			<Timer name="timer" delayformat="n" expirationdate="{dataset.initialScheduledDate.get()}"/>
		</Component>
		<Link name="L1710157130223" source="C1710156317812" target="C1710845470205" priority="1"/>
		<Component name="C1710157146086" type="timeractivity" x="140" y="517" w="195" h="98" title="1 day timer">
			<Timer name="timer" delay="1" delayformat="d"/>
		</Component>
		<Link name="L1710157165494" source="C1710157146086" target="C1710157285411" priority="1"/>
		<Component name="C1710157285411" type="routeactivity" x="214" y="643" w="300" h="50" compact="true" title="Route 2" outexclusive="true"/>
		<Link name="L1710157294164" source="C1710157285411" target="CEND" priority="2" expression="dataset.interrupted.get()"/>
		<Link name="L1710157403868" source="C1710157285411" target="C1710845470205" priority="1" expression="!dataset.interrupted.get()"/>
		<Component name="N1710157954107" type="note" x="444" y="135" w="137" h="50" title="never ending loop with daily timer"/>
		<Link name="L1703191470415" source="C1703102828795" target="C1710157146086" priority="1"/>
		<Link name="L1710157255423" source="C1710845470205" target="C1703102828795" priority="1"/>
		<Component name="C1710845470205" type="scriptactivity" x="172" y="247" w="136" h="98" title="loop iteration">
			<Script onscriptexecute="runLoop"/>
		</Component>
	</Definition>
	<Variables>
		<Variable name="A1703102898248" variable="simulate" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1703102914606" variable="simulateNow" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1703191124017" variable="reviewRunTasks" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1710156556920" variable="scheduleHourOfDay" editortype="Default" type="Number" multivalued="false" visibility="in" initialvalue="1" minvalue="0" maxvalue="23" notstoredvariable="true"/>
		<Variable name="A1710156577573" variable="scheduleMinute" editortype="Default" type="Number" multivalued="false" visibility="in" initialvalue="0" minvalue="0" maxvalue="59" notstoredvariable="true"/>
		<Variable name="A1710157487896" variable="initialScheduledDate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1710162447295" variable="loopCounter" editortype="Default" type="Number" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1710166013014" variable="interrupted" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="false" notstoredvariable="true"/>
		<Variable name="A1710845434926" variable="lastExecutionDate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1703103015272" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1703103049107" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
