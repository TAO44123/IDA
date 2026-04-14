<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_updaterepositorymetadata" displayname="Update repository classification for {dataset.repositoryname}" description="Update shared metadata" scriptfile="workflow/bw_fragments/empty.javascript" statictitle="Update repository classification" publish="false" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="55" y="152" w="200" h="114" title="Start - bwf_updaterepositorymetadata" compact="true">
			<Output name="output" ticketnumbervariable="ticketlog" ticketactionnumbervariable="ticketaction"/>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="status" attribute="ticketstatus"/>
			</Ticket>
			<Actions>
				<Action name="U1437988949694" action="update" attribute="ticketdescription" newvalue="Update metadata on (&apos;{dataset.repository.length}&apos;) repository(ies)"/>
				<Action name="U1598458341607" action="executeview" viewname="br_repositoryDetail" append="false" attribute="repositoryname">
					<ViewParam name="P15984583416070" param="uid" paramvalue="{dataset.repository.get()}"/>
					<ViewAttribute name="P1598458341607_1" attribute="displayname" variable="repositoryname"/>
				</Action>
			</Actions>
			<Candidates name="role" role="A1437989337599"/>
			<FormVariable name="A1608109231028" variable="repository" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1437989372486" variable="description" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1586453282424" variable="category" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586453287675" variable="sensitivitylevel" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586453292917" variable="sensitivityreason" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND" type="endactivity" x="1085" y="152" w="200" h="98" title="End - bwf_updaterepositorymetadata" compact="true">
			<Actions>
				<Action name="U1437988821040" action="update" attribute="ticketstatus" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="N1444230132222" type="note" x="57" y="261" w="267" h="104" title="Notes&#xA;&#xA;- Workflow receives multivalued variables"/>
		<Component name="C1444232855613" type="ticketreviewactivity" x="159" y="127" w="200" h="98" title="Write the tickets">
			<TicketReview ticketaction="ticketaction" expression="(dataset.equals(&apos;createReviewTickets&apos;, &apos;true&apos;, false, true))">
				<Permission/>
				<Attribute name="comment" attribute="ticketdescription"/>
				<Application/>
				<Attribute name="custom1" attribute="description"/>
				<Attribute name="custom2" attribute="category"/>
				<Attribute name="custom3" attribute="sensitivitylevel"/>
				<Attribute name="custom4" attribute="sensitivityreason"/>
				<Attribute name="status" attribute="REVIEWTYPE"/>
				<Repository repositoryvariable="repository"/>
			</TicketReview>
		</Component>
		<Link name="L1445361479401" source="CSTART" target="C1444232855613" priority="1"/>
		<Component name="C1586429770834" type="startsubactivity" x="411" y="152" w="300" h="50" compact="true" title="Subprocess start">
			<Iteration sequential="true" listvariable="repository">
				<Variable name="A1586429819827" variable="description"/>
				<Variable name="A1586429830554" variable="sensitivitylevel"/>
				<Variable name="A1586429835548" variable="sensitivityreason"/>
				<Variable name="A1586430336070" variable="category"/>
			</Iteration>
		</Component>
		<Component name="C1586429773718" type="endsubactivity" x="975" y="152" w="300" h="50" compact="true" title="Subprocess end"/>
		<Link name="L1586429797544" source="C1444232855613" target="C1586429770834" priority="1"/>
		<Link name="L1586429798643" source="C1586429770834" target="C1586429947489" priority="1"/>
		<Link name="L1586429800061" source="C1608037074833" target="C1586429773718" priority="1"/>
		<Link name="L1586429801347" source="C1586429773718" target="CEND" priority="1"/>
		<Component name="C1586429947489" type="variablechangeactivity" x="489" y="127" w="184" h="98" title="what to update">
			<Actions>
				<Action name="U1586429970378" action="update" attribute="whattoupdate" newvalue=""/>
				<Action name="U1586430090071" action="update" attribute="whattoupdate" newvalue="{dataset.whattoupdate.get()}D" condition="!dataset.isEmpty(&apos;description&apos;)"/>
				<Action name="U1586430169252" action="update" attribute="whattoupdate" newvalue="{dataset.whattoupdate.get()}R" condition="!dataset.isEmpty(&apos;sensitivityreason&apos;)"/>
				<Action name="U1586430218333" action="update" attribute="whattoupdate" newvalue="{dataset.whattoupdate.get()}L" condition="!dataset.isEmpty(&apos;sensitivitylevel&apos;)"/>
				<Action name="U1586430377346" action="update" attribute="whattoupdate" newvalue="{dataset.whattoupdate.get()}C" condition="!dataset.isEmpty(&apos;category&apos;)"/>
				<Action name="U1587402050931" action="default" attribute="category" newvalue=" "/>
				<Action name="U1587402078946" action="default" attribute="description" newvalue=" "/>
				<Action name="U1587402097676" action="default" attribute="sensitivitylevel" newvalue="0"/>
				<Action name="U1587402109907" action="default" attribute="sensitivityreason" newvalue=" "/>
			</Actions>
		</Component>
		<Link name="L1586430018376" source="C1586429947489" target="C1608037074833" priority="1"/>
		<Component name="C1608037074833" type="metadataactivity" x="739" y="127" w="181" h="98" title="Update metadata">
			<Metadata action="C" schema="bwa_repositorymetadata">
				<Application/>
				<Data string4="description" string5="sensitivityreason" integer1="sensitivitylevel" string3="category"/>
				<Repository repository="repository"/>
			</Metadata>
		</Component>
	</Definition>
	<Variables>
		<Variable name="A1437988414131" variable="description" displayname="description" editortype="Default" type="String" multivalued="true" visibility="in" description="Input: Description" notstoredvariable="false"/>
		<Variable name="A1437988472472" variable="sensitivityreason" displayname="sensitivity reason" editortype="Default" type="String" multivalued="true" visibility="in" description="Input: sensitivity, ex: CTU" notstoredvariable="false"/>
		<Variable name="A1437988656376" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="APPLICATIONMETADATA" notstoredvariable="false" description="APPLICATIONMETADATA"/>
		<Variable name="A1437988671470" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1437988809253" variable="ticketstatus" displayname="ticket status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false" description="internal, used for the ticketlog"/>
		<Variable name="A1444225117989" variable="whattoupdate" displayname="whattoupdate" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" description="internal, used in javascript" initialvalue="D"/>
		<Variable name="A1444233051422" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444233900846" variable="ticketlog" displayname="ticketlog" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false" description="internal"/>
		<Variable name="A1444234477149" variable="createReviewTickets" displayname="createReviewTickets" editortype="Default" type="Boolean" multivalued="false" visibility="local" initialvalue="true" notstoredvariable="false" description="Default: true&#xA;"/>
		<Variable name="A1444318225262" variable="category" displayname="category" editortype="Default" type="String" multivalued="true" visibility="in" description="Input: Category" notstoredvariable="false"/>
		<Variable name="A1586429680346" variable="sensitivitylevel" displayname="sensitivity level" editortype="Default" type="Number" multivalued="true" visibility="in" description="Input: sensitivity level" notstoredvariable="true"/>
		<Variable name="A1586430800907" variable="REVIEWTYPE" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="metadata update" notstoredvariable="true" description="metadata update"/>
		<Variable name="A1608109101172" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="true" visibility="in" notstoredvariable="true"/>
		<Variable name="A1608109125757" variable="repositoryname" displayname="repository name" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false"/>
	</Variables>
	<Roles>
		<Role name="A1437989337599" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owners" description="owners">
			<Rule name="A1445361267084" rule="control_activeidentities" description="Active Identities"/>
		</Role>
	</Roles>
</Workflow>
