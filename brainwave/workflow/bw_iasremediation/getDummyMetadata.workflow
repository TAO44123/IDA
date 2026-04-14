<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwiasr_getDummyMetadata" statictitle="Get global Dummy Metadata" description="Get global Dummy Metadata to attach remediation review tickets to" scriptfile="/workflow/bw_iasremediation/empty.javascript" displayname="Get global Dummy Metadata" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="79" y="257" w="200" h="114" title="Start - bwiasr_getDummyMetadata" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions>
				<Action name="U1673007247427" action="executeview" viewname="bwaccess360r_dummymetadata" append="false" attribute="view_metadataUids">
					<ViewAttribute name="P1673007247427_0" attribute="uid" variable="view_metadataUids"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1673007024075"/>
		</Component>
		<Component name="CEND" type="endactivity" x="968" y="257" w="200" h="98" title="End - bwiasr_getDummyMetadata" compact="true"/>
		<Link name="CLINK" source="C1673007315045" target="CEND" priority="1"/>
		<Component name="C1673007315045" type="variablechangeactivity" x="588" y="232" w="300" h="98" title="Update MetadataUid variable" inexclusive="true">
			<Actions>
				<Action name="U1673007856856" action="update" attribute="metadataUid" newvalue="{dataset.view_metadataUids.get(0)}" condition="!dataset.isEmpty( &apos;view_metadataUids&apos; )"/>
				<Action name="U1673007879395" action="update" attribute="metadataUid" newvalue="{dataset.new_metadatUids.get(0)}" condition="!dataset.isEmpty( &apos;new_metadatUids&apos; )"/>
			</Actions>
		</Component>
		<Component name="C1673007369303" type="metadataactivity" x="216" y="353" w="300" h="98" title="Create Metadata">
			<Metadata outmetadatauid="new_metadatUids" schema="bwaccess360r_dummymetadata" action="C">
				<Data description="dummy" string1="dummy"/>
			</Metadata>
		</Component>
		<Component name="C1673007624863" type="routeactivity" x="216" y="89" w="300" h="98" compact="false" title="Route - bwiasr_getDummyMetadata - dummy metadata already exists"/>
		<Link name="L1673007733740" source="CSTART" target="C1673007624863" priority="1" expression="!dataset.isEmpty( &apos;view_metadataUids&apos; )" labelcustom="true" label="Metadata exists"/>
		<Link name="L1673007734801" source="C1673007624863" target="C1673007315045" priority="1"/>
		<Link name="L1673007736651" source="CSTART" target="C1673007369303" priority="2" labelcustom="true" label="Create metadata" expression="dataset.isEmpty( &apos;view_metadataUids&apos; )"/>
		<Link name="L1673007737555" source="C1673007369303" target="C1673007315045" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1673007024075" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="everyone" description="All active identities">
			<Rule name="A1673007036922" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1673007055467" variable="metadataUid" displayname="Metadata Uid" editortype="Default" type="String" multivalued="false" visibility="out" description="Metadata Uid" notstoredvariable="true"/>
		<Variable name="A1673007215957" variable="view_metadataUids" displayname="View Metadata Uids" editortype="Default" type="String" multivalued="true" visibility="local" description="View Metadata Uids - mutlivalued to be udpated via a view call.&#xA;Will contain only one value that will be passed to the metadataUid variable &#xA;if the metadata already exists" notstoredvariable="true"/>
		<Variable name="A1673007584558" variable="new_metadatUids" displayname="New Metadata Uids" editortype="Default" type="String" multivalued="true" visibility="local" description="New Metadata Uids&#xA;The variable filled by the workflow&apos;s metadata target&#xA;Used only if the metadata does not alreay exist.&#xA;Will be used to set the metataUid variable if not empty" notstoredvariable="true"/>
		<Variable name="A1673007674954" variable="dummy" displayname="Dummy" editortype="Default" type="String" multivalued="false" visibility="local" description="Dummy value required to trigger the metadata creation" initialvalue="dummy" notstoredvariable="true"/>
	</Variables>
</Workflow>
