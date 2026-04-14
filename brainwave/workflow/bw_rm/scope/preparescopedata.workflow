<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwrm_preparescopedata" statictitle="preparescopedata" scriptfile="/workflow/bw_rm/scope/rm_scope.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="404" y="24" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1584722434767"/>
		</Component>
		<Component name="CEND" type="endactivity" x="404" y="603" w="200" h="98" title="End" compact="true">
			<Actions>
				<Action name="U1584978654173" action="executeview" viewname="bwrm_getscopemetadatauid" append="false" attribute="metadataUid">
					<ViewParam name="P15849786541730" param="processIdentifier" paramvalue="{dataset.processIdentifier.get()}"/>
					<ViewAttribute name="P1584978654173_1" attribute="bwrm_scopedata_uid" variable="metadataUid"/>
				</Action>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1584717910307" priority="1"/>
		<Component name="C1584716847251" type="metadataactivity" x="278" y="375" w="300" h="98" title="Create scope data">
			<Metadata action="C" schema="bwrm_scopedata">
				<Data boolean="sd_indirect" date1="sd_lastdate" subkey="sd_subkey"/>
				<ValueIdentity identity_value="sd_identitiy"/>
				<ValuePermission permission_value="sd_permission"/>
			</Metadata>
		</Component>
		<Component name="C1584717910307" type="variablechangeactivity" x="278" y="185" w="300" h="98" title="Compute scopes">
			<Actions>
				<Action name="U1584722176604" structname="S1584720762097" action="executeview" viewname="bwpm_rights_id_perm_perorg_md" append="false" attribute="sd_permission">
					<ViewParam name="P15847221766040" param="uid" paramvalue="{dataset.organisationuid.get()}"/>
					<ViewParam name="P15847221766041" param="directOnly" paramvalue="0"/>
					<ViewParam name="P15847221766042" param="permRules" paramvalue="{dataset.permrule.get()}"/>
					<ViewAttribute name="P1584722176604_3" attribute="permissionuid" variable="sd_permission"/>
					<ViewAttribute name="P1584722176604_4" attribute="identityuid" variable="sd_identitiy"/>
					<ViewAttribute name="P1584722176604_5" attribute="indirect" variable="sd_indirect"/>
					<ViewAttribute name="P1584722176604_6" attribute="lastlogindate" variable="sd_lastdate"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1584720672734" source="C1584717910307" target="C1584716847251" priority="1"/>
		<Link name="L1584720674605" source="C1584716847251" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1584716791449" variable="organisationuid" displayname="organisationuid" editortype="Ledger Organisation" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="S1584720762097" variable="scopedata" multivalued="true" visibility="local" editortype="Structure" type="String" notstoredvariable="false"/>
		<Variable name="A1584720798284" variable="sd_permission" displayname="sd_permission" editortype="Ledger Permission" type="String" multivalued="true" visibility="local" syncname="S1584720762097" notstoredvariable="true"/>
		<Variable name="A1584720826302" variable="sd_identitiy" displayname="sd_identitiy" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" syncname="S1584720762097" notstoredvariable="true"/>
		<Variable name="A1584722265249" variable="sd_indirect" displayname="sd_indirect" editortype="Default" type="Boolean" multivalued="true" visibility="local" syncname="S1584720762097" notstoredvariable="true"/>
		<Variable name="A1584724037223" variable="sd_lastdate" displayname="sd_lastdate" editortype="Default" type="Date" multivalued="true" visibility="local" syncname="S1584720762097" notstoredvariable="true"/>
		<Variable name="A1584976555727" variable="processIdentifier" displayname="processIdentifier" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1584976764864" variable="sd_subkey" displayname="sd_subkey" editortype="Default" type="String" multivalued="true" visibility="local" syncname="S1584720762097" defaultinsertvalue="{dataset.processIdentifier.get()}" notstoredvariable="true"/>
		<Variable name="A1584978544812" variable="metadataUid" displayname="metadataUid" editortype="Default" type="String" multivalued="true" visibility="out" notstoredvariable="true"/>
		<Variable name="A1604322537407" variable="permrule" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1584722434767" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="ALL" description="ALL">
			<Rule name="A1584722465218" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
