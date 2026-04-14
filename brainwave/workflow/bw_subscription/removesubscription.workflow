<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bw_subscription_removesubscription" statictitle="remove subscription" scriptfile="/workflow/bw_subscription/removesubscription.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="32" y="130" w="200" h="114" title="Start" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1638802445459"/>
		</Component>
		<Component name="CEND" type="endactivity" x="588" y="130" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1638796337925" priority="1"/>
		<Component name="C1638796337925" type="metadataactivity" x="163" y="105" w="300" h="98" title="delete metadatas">
			<Metadata action="D" metadatauid="metadatauid"/>
		</Component>
		<Link name="L1638796360620" source="C1638796337925" target="CEND" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1638796331902" variable="metadatauid" displayname="metadatauid" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1638802445459" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1638802455053" rule="bwd_control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
