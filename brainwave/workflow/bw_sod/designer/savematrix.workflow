<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwsod_designer_savematrix" statictitle="Save SoD matrix" scriptfile="workflow/bw_sod/empty.javascript" displayname="Save SoD matrix {dataset.matrixname.get()}">
		<Component name="CEND" type="endactivity" x="308" y="655" w="200" h="98" title="End" compact="true"/>
		<Component name="C1762360443834" type="variablechangeactivity" x="182" y="139" w="300" h="98" title="Replace permissions" outexclusive="true">
			<Actions>
				<Action name="U1764236248349" action="multireplace" attribute="permission1" newvalue="{dataset.permission1.get().replaceAll(&quot;\\${3}.*&quot;,&quot;&quot;)}"/>
				<Action name="U1764236380244" action="multireplace" attribute="permission2" newvalue="{dataset.permission2.get().replaceAll(&quot;.*\\${3}&quot;,&quot;&quot;)}"/>
				<Action name="U1765462087689" action="executeview" viewname="bwsod_designer_matrix_details" append="false" attribute="existingKeys">
					<ViewParam name="P17654620876890" param="matrix_code" paramvalue="{dataset.matrixname.get()}"/>
					<ViewAttribute name="P1765462087689_1" attribute="keys" variable="existingKeys"/>
					<ViewAttribute name="P1765462087689_2" attribute="bwsod_toxic_pairs_uid" variable="existingKeysUid"/>
				</Action>
				<Action name="U1765462152491" action="multifilter" attribute="existingKeys" oldname="toxicKeys_multi" remove="true" attribute1="existingKeysUid"/>
				<Action name="U1762419561030" action="multiresize" attribute="toxicKeys_multi" attribute1="riskLevels"/>
			</Actions>
		</Component>
		<Component name="C1762417944834" type="callactivity" x="182" y="458" w="300" h="98" title="Save SoD metadata pair" inexclusive="true">
			<Process workflowfile="/workflow/bw_sod/designer/savepair.workflow">
				<Input name="A1762417975420" variable="matrixcode" content="matrixname"/>
				<Input name="A1762417979289" variable="matrixname" content="matrixname"/>
				<Input name="A1762419519397" variable="toxicKey" content="toxicKeys_multi"/>
				<Input name="A1764236448202" variable="permission1" content="permission1"/>
				<Input name="A1764236452108" variable="permission2" content="permission2"/>
				<Input name="A1764256709771" variable="enabled" content="matrixenabled"/>
				<Input name="A1764951944456" variable="risklevel" content="riskLevels"/>
			</Process>
			<Iteration listvariable="toxicKeys_multi" sequential="true">
				<Variable name="A1764236457545" variable="permission1"/>
				<Variable name="A1764236459828" variable="permission2"/>
				<Variable name="A1764951957261" variable="riskLevels"/>
			</Iteration>
		</Component>
		<Link name="L1762418092717" source="C1762360443834" target="C1765461762490" priority="1" expression="(! dataset.isEmpty(&apos;existingKeysUid&apos;))" labelcustom="true" label="Some pairs must be deleted"/>
		<Link name="L1762418093508" source="C1762417944834" target="CEND" priority="1"/>
		<Component name="C1765461762490" type="metadataactivity" x="182" y="301" w="300" h="98" title="Delete metadatas">
			<Metadata action="D" metadatauid="existingKeysUid"/>
		</Component>
		<Link name="L1765461793742" source="C1765461762490" target="C1762417944834" priority="1"/>
		<Link name="L1765462210074" source="C1762360443834" target="C1762417944834" priority="2" expression="(dataset.isEmpty(&apos;existingKeysUid&apos;))" labelcustom="true" label=" "/>
		<Component name="CSTART" type="startactivity" x="308" y="16" w="200" h="114" title="Start" compact="true">
			<Ticket create="true">
				<Attribute name="custom1" attribute="matrixname"/>
			</Ticket>
			<Actions>
			</Actions>
			<Candidates name="role" role="A1760520233208"/>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1762360443834" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1760520233208" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1760520257745" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
	<ComplianceReport format="XLS" locale="en">
	</ComplianceReport>
	<Variables>
		<Variable name="A1760520445593" variable="export" displayname="export" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1760520464790" variable="toxickeys" displayname="toxickeys" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1760520484693" variable="matrixname" displayname="matrixname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762360426168" variable="permission1" displayname="permission1" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762360432860" variable="permission2" displayname="permissions2" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1762418059098" variable="toxicKeys_multi" displayname="toxicKeys_multi" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1764256661284" variable="matrixenabled" displayname="matrixenabled" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1764951901056" variable="riskLevels" displayname="riskLevels" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1765462032122" variable="existingKeys" displayname="existingKeys" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1765462095447" variable="existingKeysUid" displayname="existingKeysUid" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
