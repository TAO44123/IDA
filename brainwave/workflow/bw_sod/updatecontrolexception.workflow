<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwsod_updatecontrolexception" statictitle="updatecontrolexception" scriptfile="/workflow/bw_sod/empty.javascript">
		<Component name="CSTART" type="startactivity" x="210" y="45" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1758180188722"/>
			<Actions>
				<Action name="U1758637302797" action="update" attribute="controlcode" newvalue="{dataset.incontrolcodes.get()}"/>
				<Action name="U1758637313490" action="update" attribute="controlresulttype" newvalue="{dataset.incontrolresulttypes.get()}"/>
				<Action name="U1758637343250" action="update" attribute="entity" newvalue="{dataset.inentities.get()}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="209" y="354" w="200" h="98" title="End" compact="true"/>
		<Component name="C1758621544173" type="writeexceptionactivity" x="83" y="176" w="300" h="98" title="Delete exception">
			<WriteException name="writeexception" controlcode="controlcode" resulttype="controlresulttype" entityuid="entity" issuername="issuerfullname" begindate="exceptionbegindate" enddate="exceptionexpirationdate" reason="exceptionreason" custom1="exceptioncomment"/>
			<Output name="output"/>
		</Component>
		<Link name="L1758622369253" source="C1758621544173" target="CEND" priority="1"/>
		<Link name="L1758622428540" source="CSTART" target="C1758621544173" priority="2"/>
	</Definition>
	<Roles>
		<Role name="A1758180188722" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1758180213937" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1758276188864" variable="controlcode" displayname="controlcode" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758622357859" variable="controlresulttype" displayname="controlresulttype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758637140592" variable="entity" displayname="entity" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1758637243718" variable="incontrolcodes" displayname="incontrolcodes" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758637253375" variable="incontrolresulttypes" displayname="incontrolresulttypes" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758637273774" variable="inentities" displayname="inentities" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758713915479" variable="exceptionbegindate" displayname="exceptionbegindate" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758713926100" variable="exceptionexpirationdate" displayname="exceptionexpirationdate" editortype="Default" type="Date" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758713937080" variable="exceptionreason" displayname="exceptionreason" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758713951032" variable="exceptioncomment" displayname="exceptioncomment" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1758713973927" variable="issuerfullname" displayname="issuerfullname" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
