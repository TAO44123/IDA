<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwsod_updatecontrolsexceptions" statictitle="updatecontrolsexceptions" scriptfile="/workflow/bw_sod/empty.javascript">
		<Component name="CSTART" type="startactivity" x="187" y="35" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1758637040322"/>
			<Actions>
				<Action name="U1758714180955" action="executeview" viewname="br_identityDetail" append="false" attribute="issuerfullname">
					<ViewParam name="P17587141809550" param="uid" paramvalue="{dataset.issueruid.get()}"/>
					<ViewAttribute name="P1758714180955_1" attribute="fullname" variable="issuerfullname"/>
				</Action>
				<Action name="U1758720725643" action="update" attribute="exceptionbegindate" newvalue="{new Date()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="187" y="488" w="200" h="98" title="End" compact="true"/>
		<Component name="C1758637098343" type="callactivity" x="61" y="308" w="300" h="98" title="Update exception subprocess">
			<Process workflowfile="/workflow/bw_sod/updatecontrolexception.workflow">
				<Input name="A1758637590551" variable="incontrolcodes" content="controlcodes"/>
				<Input name="A1758637593843" variable="incontrolresulttypes" content="controlresulttypes"/>
				<Input name="A1758637597830" variable="inentities" content="entities"/>
				<Input name="A1758714191173" variable="issuerfullname" content="issuerfullname"/>
				<Input name="A1758714195858" variable="exceptionreason" content="exceptionreason"/>
				<Input name="A1758714209762" variable="exceptioncomment" content="exceptioncomment"/>
				<Input name="A1758714217663" variable="exceptionbegindate" content="exceptionbegindate"/>
				<Input name="A1758714240686" variable="exceptionexpirationdate" content="exceptionexpirationdate"/>
			</Process>
			<Iteration listvariable="entities">
				<Variable name="A1758637662489" variable="controlcodes"/>
				<Variable name="A1758637665076" variable="controlresulttypes"/>
			</Iteration>
		</Component>
		<Link name="L1758637602322" source="C1758637098343" target="CEND" priority="1"/>
		<Link name="L1758715736497" source="CSTART" target="C1758787594455" priority="1"/>
		<Component name="C1758787594455" type="variablechangeactivity" x="61" y="141" w="300" h="98" title="Cleanup multivalued variables">
			<Actions>
				<Action name="U1758787634081" action="multiclean" attribute="entities" emptyvalues="true" duplicates="false" attribute1="controlcodes" attribute2="controlresulttypes"/>
				<Action name="U1758787650835" action="multiclean" attribute="controlcodes" emptyvalues="true" duplicates="false" attribute1="controlresulttypes" attribute2="entities"/>
				<Action name="U1758787670759" action="multiclean" attribute="controlresulttypes" emptyvalues="true" duplicates="false" attribute1="controlcodes" attribute2="entities"/>
			</Actions>
		</Component>
		<Link name="L1758787676782" source="C1758787594455" target="C1758637098343" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1758637040322" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1758637049611" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1758637073526" variable="controlcodes" displayname="controlcodes" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758637089732" variable="entities" displayname="entities" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758637377727" variable="controlresulttypes" displayname="controlresulttypes" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758708480270" variable="exceptionbegindate" displayname="exceptionbegindate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758708491624" variable="exceptionexpirationdate" displayname="exceptionexpirationdate" editortype="Default" type="Date" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758708514922" variable="exceptionreason" displayname="exceptionreason" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758708537820" variable="issuerfullname" displayname="issuerfullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758708841168" variable="issueruid" displayname="issueruid" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758714203732" variable="exceptioncomment" displayname="exceptioncomment" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
