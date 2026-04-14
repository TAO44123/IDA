<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_updategroupmetadata" statictitle="update group metadata" description="update group metadata" scriptfile="workflow/bw_fragments/empty.javascript" displayname="update group metadata" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="39" y="91" w="200" h="114" title="Start - bwf_updategroupmetadata" compact="true">
			<Ticket create="true" createaction="true">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="description" attribute="ticketdescription"/>
			</Ticket>
			<Candidates name="role" role="A1607353934190"/>
			<Actions>
				<Action name="U1607354453230" action="executeview" viewname="br_groupDetail" append="false" attribute="groupcode">
					<ViewParam name="P16073544532300" param="uid" paramvalue="{dataset.uid.get()}"/>
					<ViewAttribute name="P1607354453230_1" attribute="code" variable="groupcode"/>
					<ViewAttribute name="P1607354453230_2" attribute="displayname" variable="groupname"/>
					<ViewAttribute name="P1607354453230_3" attribute="repository_displayname" variable="repositoryname"/>
				</Action>
				<Action name="U1607361009117" action="update" attribute="ticketdescription" newvalue="Update metadata on {dataset.groupname.get()} / {dataset.repositoryname.get()}"/>
			</Actions>
			<Output name="output" startdisplaynamevariable="by" ticketactionnumbervariable="ticketaction"/>
		</Component>
		<Component name="CEND" type="endactivity" x="954" y="91" w="200" h="98" title="End - bwf_updategroupmetadata" compact="true">
			<Actions>
				<Action name="U1607360001487" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Link name="CLINK" source="CSTART" target="C1607360523176" priority="1"/>
		<Component name="C1607354546295" type="metadataactivity" x="575" y="66" w="300" h="98" title="group description">
			<Metadata action="C" schema="bwa_groupmetadata">
				<ValueGroup/>
				<Group group1="uid"/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" boolean="ismanaged"/>
			</Metadata>
		</Component>
		<Link name="L1607359752167" source="C1607354546295" target="CEND" priority="1"/>
		<Component name="C1607360523176" type="ticketreviewactivity" x="169" y="66" w="300" h="98" title="write the ticket">
			<TicketReview ticketaction="ticketaction">
				<Attribute name="custom1" attribute="description"/>
				<Attribute name="custom3" attribute="sensitivitylevel"/>
				<Attribute name="custom4" attribute="sensitivityreason"/>
				<Attribute name="status" attribute="REVIEWTYPE"/>
				<Attribute name="comment" attribute="ticketdescription"/>
				<Group groupvariable="uid"/>
				<Attribute name="custom2" attribute="ismanaged"/>
			</TicketReview>
		</Component>
		<Link name="L1607361248293" source="C1607360523176" target="C1607354546295" priority="1"/>
	</Definition>
	<Variables>
		<Variable name="A1607353660266" variable="description" displayname="description" editortype="Default" type="String" multivalued="false" visibility="in" description="description" notstoredvariable="false"/>
		<Variable name="A1607353690144" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="false" visibility="in" description="sensitivity reason" notstoredvariable="false"/>
		<Variable name="A1607353712333" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="false" visibility="in" description="sensitivity level" notstoredvariable="false"/>
		<Variable name="A1607353916560" variable="ismanaged" displayname="is managed" editortype="Default" type="Boolean" multivalued="false" visibility="in" description="is managed" notstoredvariable="false"/>
		<Variable name="A1607354048954" variable="uid" displayname="uid" editortype="Ledger Group" type="String" multivalued="false" visibility="in" description="group uid to update" notstoredvariable="false"/>
		<Variable name="A1607354067896" variable="groupcode" displayname="group code" editortype="Default" type="String" multivalued="false" visibility="local" description="group code" notstoredvariable="false"/>
		<Variable name="A1607354080954" variable="groupname" displayname="group name" editortype="Default" type="String" multivalued="false" visibility="local" description="group name" notstoredvariable="false"/>
		<Variable name="A1607354093083" variable="repositoryname" displayname="repository name" editortype="Default" type="String" multivalued="false" visibility="local" description="repository name" notstoredvariable="false"/>
		<Variable name="A1607359990964" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="true"/>
		<Variable name="A1607360031886" variable="by" displayname="by" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1607360557768" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1607360732453" variable="REVIEWTYPE" displayname="REVIEWTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="metadata update" notstoredvariable="true"/>
		<Variable name="A1607360831601" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1607353934190" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1607353949479" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
</Workflow>
