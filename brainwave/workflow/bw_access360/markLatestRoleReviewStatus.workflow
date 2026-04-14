<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwa_markLatestGroupMembersReviewStatus_1" statictitle="mark Latest Group Members Review Status" scriptfile="/workflow/bw_access360/markLatestGroupReviewStatus.javascript" technical="true" type="builtin-technical-workflow">
		<Component name="CSTART" type="startactivity" x="255" y="47" w="200" h="114" title="Start - bwa_markLatestGroupMembersReviewStatus" compact="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1666088750078"/>
		</Component>
		<Component name="CEND" type="endactivity" x="255" y="847" w="200" h="98" title="End - bwa_markLatestGroupMembersReviewStatus" compact="true"/>
		<Component name="C1666092326450" type="updateticketreviewactivity" x="129" y="360" w="300" h="98" title="reset previous tickets">
			<UpdateTicketReview ticketreviewnumbervariable="entriestoreset">
				<Attribute name="custom19" attribute="resetvalues"/>
			</UpdateTicketReview>
		</Component>
		<Component name="C1666092326450_1" type="updateticketreviewactivity" x="129" y="522" w="300" h="98" title="mark new tickets as the latest ones">
			<UpdateTicketReview ticketreviewnumbervariable="entriestoset">
				<Attribute name="custom19" attribute="setvalues"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1666092997794" source="C1666092326450" target="C1666092326450_1" priority="1"/>
		<Component name="C1698056680941" type="variablechangeactivity" x="126" y="180" w="308" h="98" title="compute tickets to update">
			<Actions function="computeTicketsToUpdate">
				<Action name="U1698242028467" action="executeview" viewname="bwa_roleswithmarkedlatestreview" append="false" attribute="resetvalues">
					<ViewParam name="P16982420284670" param="campaignid" paramvalue="{dataset.campaignid.get()}"/>
					<ViewAttribute name="P1698242028467_1" attribute="resetvalue" variable="resetvalues"/>
					<ViewAttribute name="P1698242028467_2" attribute="ticket3recorduid" variable="entriestoreset"/>
				</Action>
				<Action name="U1698242969912" action="executeview" viewname="bwa_computeroleslatestsstatus" append="false" attribute="entriestoset">
					<ViewParam name="P16982429699120" param="campaignid" paramvalue="{dataset.campaignid}"/>
					<ViewAttribute name="P1698242969912_1" attribute="recorduid" variable="entriestoset"/>
					<ViewAttribute name="P1698242969912_2" attribute="setvalue" variable="setvalues"/>
				</Action>
			</Actions>
		</Component>
		<Link name="L1698056696170" source="CSTART" target="C1698056680941" priority="1"/>
		<Link name="L1698056697132" source="C1698056680941" target="C1666092326450" priority="1"/>
		<Link name="L1698243074112" source="C1666092326450_1" target="CEND" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1666088750078" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1666088760765" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A1666092271030" variable="resetvalues" displayname="resetvalues" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092281505" variable="setvalues" displayname="setvalues" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1666092389834" variable="campaignid" displayname="campaignid" editortype="Default" type="String" multivalued="false" visibility="in" description="update a given account campaign" notstoredvariable="true"/>
		<Variable name="A1698240689662" variable="entriestoreset" displayname="entriestoreset" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="false"/>
		<Variable name="A1698240783308" variable="entriestoset" displayname="entriestoset" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
