<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_markLatestReviewStatus" statictitle="mark Latest Review Status" description="Technical workflow used to mark latest review status tickets custom19=1&#xA;And metadata at an application and a repository level to attach latest review campaign infos&#xA;&#xA;much easier to query this info in reports" scriptfile="/workflow/bw_access360/markLatestReviewStatus.javascript" displayname="mark Latest Review Status" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="250" y="375" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1666098954574"/>
		</Component>
		<Component name="CEND" type="endactivity" x="1040" y="375" w="200" h="98" title="End" compact="true"/>
		<Component name="C1666098991105" type="callactivity" x="517" y="290" w="300" h="98" title="right review">
			<Process workflowfile="/workflow/bw_access360/markLatestRightReviewStatus.workflow"/>
		</Component>
		<Component name="C1666098991934" type="callactivity" x="517" y="163" w="300" h="98" title="account review">
			<Process workflowfile="/workflow/bw_access360/markLatestAccountReviewStatus.workflow"/>
		</Component>
		<Link name="L1666099020068" source="CSTART" target="C1666098991105" priority="1"/>
		<Link name="L1666099021347" source="C1666098991105" target="CEND" priority="1"/>
		<Link name="L1666099022664" source="CSTART" target="C1666098991934" priority="2"/>
		<Link name="L1666099024141" source="C1666098991934" target="CEND" priority="1"/>
		<Component name="C1666522106179" type="callactivity" x="517" y="431" w="300" h="98" title="markLatestAccountReviewRepositoryStatus">
			<Process workflowfile="/workflow/bw_access360/markLatestAccountReviewRepositoryStatus.workflow">
				<Input name="A1666541732363" variable="filterpartialcampaigns" content="filterpartialcampaigns"/>
			</Process>
		</Component>
		<Link name="L1666522130679" source="CSTART" target="C1666522106179" priority="4"/>
		<Link name="L1666522131690" source="C1666522106179" target="CEND" priority="1"/>
		<Component name="C1666522106179_1" type="callactivity" x="517" y="567" w="300" h="98" title="markLatestRightReviewApplicationStatus">
			<Process workflowfile="/workflow/bw_access360/markLatestRightReviewApplicationStatus.workflow">
				<Input name="A1666541732363" variable="filterpartialcampaigns" content="filterpartialcampaigns"/>
			</Process>
		</Component>
		<Link name="L1666541739241" source="CSTART" target="C1666522106179_1" priority="5"/>
		<Link name="L1666541740686" source="C1666522106179_1" target="CEND" priority="1"/>
		<Component name="C1666098991934_1" type="callactivity" x="517" y="-45" w="300" h="98" title="group members review">
			<Process workflowfile="/workflow/bw_access360/markLatestGroupMembersReviewStatus.workflow"/>
		</Component>
		<Link name="L1698222420412" source="CSTART" target="C1666098991934_1" priority="3"/>
		<Link name="L1698222422971" source="C1666098991934_1" target="CEND" priority="1"/>
		<Component name="C1666522106179_2" type="callactivity" x="517" y="794" w="300" h="98" title="markLatestGroupMembersReviewRepositoryStatus">
			<Process workflowfile="/workflow/bw_access360/markLatestGroupMembersReviewRepositoryStatus.workflow">
				<Input name="A1666541732363" variable="filterpartialcampaigns" content="filterpartialcampaigns"/>
			</Process>
		</Component>
		<Link name="L1698222514509" source="CSTART" target="C1666522106179_2" priority="6"/>
		<Link name="L1698222516399" source="C1666522106179_2" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1666098954574" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1666098967729" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1666541715745" variable="filterpartialcampaigns" displayname="filter partial campaigns" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="true"/>
	</Variables>
</Workflow>
