<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_test_reviewerscript" statictitle="test reviewerscript" scriptfile="/workflow/bw_iasreview2/utils/test_reviewerscript.javascript">
		<Component name="CSTART" type="startactivity" x="32" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1708958343840"/>
			<FormVariable name="A1708958431287" variable="script" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="32" y="192" w="200" h="98" title="End" compact="true">
			<Actions function="test"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1708958304495" variable="script" displayname="script" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1708958323604" variable="lineNumber" editortype="Default" type="Number" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1708958335513" variable="errMsg" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1708958343840" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1708958360806" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
