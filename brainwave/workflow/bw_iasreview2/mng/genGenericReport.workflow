<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwaccess360_genGenericReport" statictitle="Generate Generic Compliance Report" scriptfile="workflow/bw_iasreview2/mng/genReport.javascript" technical="true" type="builtin-technical-workflow" displayname="{dataset.campaignid}" releaseontimeout="true">
		<Component name="CSTART" type="startactivity" x="220" y="81" w="200" h="114" title="bwaccess360_genGenericReport - Start" compact="true">
			<Ticket create="true">
				<Attribute name="tickettype" attribute="TICKETLOG"/>
				<Attribute name="description" attribute="generalComment"/>
			</Ticket>
			<Candidates name="role" role="A1698050727649"/>
			<Actions>
				<Action name="U1767363983400" action="update" attribute="campaignIdStr" newvalue="{dataset.campaignid.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="221" y="159" w="200" h="98" title="bwaccess360_genGenericReport - End" compact="true" inexclusive="true"/>
		<Link name="L1765186394949" source="CSTART" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1698050727649" displayname="owner" description="owner">
			<Rule name="A1698050749102" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1698050821912" variable="campaignid" displayname="campaignid" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698051078347" variable="delegationtext" displayname="delegation text" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1698051118784" variable="generalComment" displayname="generalComment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" description="general campaign comments"/>
		<Variable name="A1765186823870" variable="lang" displayname="lang" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="en"/>
		<Variable name="A1765187166952" variable="campaigntitles" displayname="campaigntitles" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1767362988725" variable="TICKETLOG" displayname="Ticket log type" editortype="Default" type="String" multivalued="false" visibility="local" description="Static: ADHOC_UAR_COMPLIANCE" initialvalue="ADHOC_UAR_COMPLIANCE" notstoredvariable="true"/>
		<Variable name="A1767363954016" variable="campaignIdStr" displayname="Campaign ID as String" editortype="Default" type="String" multivalued="false" visibility="local" description="Campaign id as string" notstoredvariable="true"/>
	</Variables>
	<ComplianceReport format="PDF" exportname="ComplianceReport_{dataset.campaigntitles.get().replace( &apos;[/\\:?&lt;&gt;&quot;|* ]&apos; ,&quot;_&quot;,&quot;g&quot;)}_{new Date().toLDAPString().substring(0, 8)}" reportfile="reports/bw_access360/generic_compliance_report.rptdesign" locale="{dataset.lang.get()}">
		<Parameter name="989" key="campaignid" macrovalue="{dataset.campaignIdStr.get()}"/>
		<Parameter name="990" key="delegationtext" macrovalue="{dataset.delegationtext.get()}"/>
		<Parameter name="991" key="generalComment" macrovalue="{dataset.generalComment.get()}"/>
	</ComplianceReport>
</Workflow>
