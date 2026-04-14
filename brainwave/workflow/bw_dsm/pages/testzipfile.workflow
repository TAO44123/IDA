<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwdsm_testzipfile" statictitle="workflow for testing pages zipfile script" scriptfile="webportal/pages/bw_dsm/services/services.javascript" technical="true">
		<Component name="CSTART" type="startactivity" x="32" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<FormVariable name="A1663054254693" variable="filepath" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1663054260765" variable="dir" action="input" mandatory="true" longlist="false"/>
			<Actions function="buildZipFile"/>
			<Candidates name="role" role="A1663054194520"/>
		</Component>
		<Component name="CEND" type="endactivity" x="32" y="192" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1663054145964" variable="filepath" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1663054154106" variable="dir" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1663054175449" variable="zipfilepath" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1663054194520" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1663054226268" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
