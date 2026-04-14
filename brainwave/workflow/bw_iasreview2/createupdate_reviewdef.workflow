<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_createupdate_reviewdef" statictitle="create reviewdef" scriptfile="/workflow/bw_iasreview2/create_reviewdef.javascript" type="builtin-technical-workflow" technical="true" description="creates or update one or multiple review campaign definitions.&#xA;always pass a unique code for the review definitons to create, which will be the subkey of the metadata.&#xA;returns the uids of the created metadatas&#xA;">
		<Component name="CSTART" type="startactivity" x="216" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="false"/>
			<Candidates name="role" role="A1679513137090"/>
			<Actions function="computeTags"/>
			<FormVariable name="A1709136682661" variable="code" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1709136689733" variable="label" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1709136698776" variable="type" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1709136706284" variable="cfg" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="216" y="288" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1701545583045" action="update" attribute="uid" newvalue="{dataset.uids.get(0)}"/>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1679512881969" priority="1"/>
		<Component name="C1679512881969" type="metadataactivity" x="149" y="115" w="182" h="98" title="update review def md">
			<Metadata schema="bwr_reviewdef" action="C" outmetadatauid="uids">
				<Data details="cfg" string1="label" subkey="code" string2="type" string3="tags"/>
				<ValueIdentity identity_value="campaignowneruid"/>
			</Metadata>
		</Component>
		<Link name="L1679513069584" source="C1679512881969" target="CEND" priority="1"/>
		<Component name="N1716293838138" type="note" x="395" y="64" w="300" h="110" title="2 uses cases: accepte en entrée soit des valeurs simples pour créer ou mettre à jour une config de campaigne,&#xA;soit des valeurs multiples pour importer N campagnes"/>
	</Definition>
	<Variables>
		<Variable name="A1679512783528" variable="label" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1679512803991" variable="cfg" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="JSON configuration"/>
		<Variable name="A1679586772508" variable="code" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true" description="unique code of the review def"/>
		<Variable name="A1682014728568" variable="type" displayname="Review Type" editortype="Default" type="String" multivalued="true" visibility="in" description="Review type" notstoredvariable="true"/>
		<Variable name="A1701539008811" variable="uids" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1701545504841" variable="uid" editortype="Default" type="String" multivalued="false" visibility="out" notstoredvariable="true"/>
		<Variable name="A1709135851260" variable="tags" displayname="tags" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1712309524103" variable="campaignowneruid" editortype="Ledger Identity" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1679513137090" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1679513152605" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
