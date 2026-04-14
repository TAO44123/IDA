<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_bulkaddaccounttag" statictitle="bulk add account tag" description="add a new tag for a series of accounts" scriptfile="workflow/bw_fragments/tags/add/bulkaddaccounttag.javascript" displayname="bulk add account tag" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="210" y="76" w="200" h="114" title="Start - bwa_bulkaddaccounttag" compact="true">
			<Ticket create="true"/>
			<Actions function="filter">
				<Action name="U1608657985272" action="executeview" viewname="bwa_accountwithtag" append="false" attribute="accountswithtag">
					<ViewParam name="P16086579852720" param="tag" paramvalue="{dataset.tag.get()}"/>
					<ViewAttribute name="P1608657985272_1" attribute="uid" variable="accountswithtag"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1608634332546"/>
			<FormVariable name="A1608657446695" variable="tag" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1608657452660" variable="uids" action="input" mandatory="true" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="210" y="366" w="200" h="98" title="End - bwa_bulkaddaccounttag" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1608630832654" priority="1"/>
		<Component name="C1608630832654" type="metadataactivity" x="84" y="198" w="300" h="98" title="bulk add a new tag">
			<Metadata action="C" schema="bwa_accounttags">
				<Data subkey="tags" string1="tags"/>
				<Account account="uids"/>
			</Metadata>
		</Component>
		<Link name="L1608630876695" source="C1608630832654" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1608630742699" variable="uids" displayname="uids" editortype="Ledger Account" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608630762063" variable="tag" displayname="tag" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608630777426" variable="tags" displayname="tags" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1608631080077" variable="accountswithtag" displayname="accounts with the tag" editortype="Ledger Account" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1608634332546" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1608634341967" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
