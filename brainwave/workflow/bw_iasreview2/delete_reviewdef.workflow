<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_delete_reviewdef" statictitle="create reviewdef" scriptfile="/workflow/bw_iasreview2/create_reviewdef.javascript" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="216" y="32" w="200" h="114" title="Start" compact="true">
			<Ticket create="false"/>
			<Candidates name="role" role="A1679513137090"/>
		</Component>
		<Component name="CEND" type="endactivity" x="216" y="288" w="200" h="98" title="End" compact="true"/>
		<Link name="CLINK" source="CSTART" target="C1679512881969" priority="1"/>
		<Component name="C1679512881969" type="metadataactivity" x="149" y="115" w="182" h="98" title="delete review def md">
			<Metadata schema="bwr_reviewdef" action="D" metadatauid="uids">
				<Data/>
			</Metadata>
		</Component>
		<Link name="L1679513069584" source="C1679512881969" target="CEND" priority="1"/>
		<Component name="N1683148564273" type="note" x="362" y="40" w="218" h="67" title="TODO: remove also children MD, tickets and review tickets"/>
	</Definition>
	<Variables>
		<Variable name="A1683148617271" variable="uids" editortype="Default" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1679513137090" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="all" description="all">
			<Rule name="A1679513152605" rule="portaluar_allactiveidentities" description="allactiveidentities"/>
		</Role>
	</Roles>
</Workflow>
