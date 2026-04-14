<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="createupdate_mailtemplate" statictitle="createupdate mailtemplate" scriptfile="/workflow/bw_iasreview2/createupdate_mailtemplate.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="449" y="72" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1753090758005"/>
			<FormVariable name="A1753092792555" variable="code" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1753092810228" variable="template" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1753092824410" variable="label" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1753092838079" variable="type" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1753190288010" variable="review_type" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="447" y="277" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1753091192811" action="update" attribute="uid" newvalue="{dataset.uids.get(0)}"/>
			</Actions>
		</Component>
		<Component name="C1753090928777" type="metadataactivity" x="322" y="152" w="300" h="98" title="update mail template">
			<Metadata action="C" schema="bwr_mailtemplate" outmetadatauid="uids">
				<Data subkey="code" string1="label" string2="type" details="template" string3="review_type"/>
			</Metadata>
		</Component>
		<Link name="L1753090949524" source="CSTART" target="C1753090928777" priority="1"/>
		<Link name="L1753090951669" source="C1753090928777" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1753090377264" variable="template" displayname="mail template" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1753090406933" variable="code" displayname="code" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1753090430856" variable="label" displayname="label" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1753090454862" variable="type" displayname="review type" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1753091074951" variable="uids" displayname="uids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1753091150230" variable="uid" displayname="uid" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1753190265728" variable="review_type" displayname="review type" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1753090758005" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1753090768106" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
