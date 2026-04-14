<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwf_updaterepositorymanager" displayname="Update repository manager {dataset.repositorydisplayname} {dataset.action} {!dataset.isEmpty(&apos;managerfullname&apos;)?dataset.managerfullname.get():&apos;&apos;}" description="Update repository manager&#xA;&#xA;Important&#xA;In order to use this workflow the following domains of expertise must be added during the data collection phase:&#xA;- businessowner&#xA;- technicalowner&#xA;&#xA;If you wish to use your own expertise domains please modify the managertype variable." scriptfile="workflow/bw_fragments/empty.javascript" statictitle="Update repository manager" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART_1" type="startactivity" x="152" y="25" w="200" h="114" title="Start - bwf_updaterepositorymanager" compact="true" outexclusive="true" inexclusive="true">
			<FormVariable name="A1587390806510" variable="repository" action="input" mandatory="true" longlist="false"/>
			<Candidates name="role" role="A1435858866632"/>
			<FormVariable name="A1435904784676" variable="manager" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1444927956477" variable="managertype" action="input" mandatory="true" longlist="false"/>
			<Actions>
				<Action name="U1586451606328" action="default" attribute="managertype" newvalue="businessowner"/>
				<Action name="U1436014223203" action="executeview" viewname="br_identityDetail" attribute="managerhrcode">
					<ViewParam name="P14360142232030" param="uid" paramvalue="{dataset.manager.get()}"/>
					<ViewAttribute name="P1436014223203_1" attribute="hrcode" variable="managerhrcode"/>
					<ViewAttribute name="P1436014223203_2" attribute="fullname" variable="managerfullname"/>
				</Action>				
				<Action name="U1598364181707" action="executeview" viewname="bwf_managerfromlink" append="false" attribute="deletemanagerfullname">
					<ViewParam name="P15983641817070" param="recorduid" paramvalue="{dataset.managerLink.get()}"/>
					<ViewAttribute name="P1598364181707_1" attribute="fullname" variable="deletemanagerfullname"/>
				</Action>
				<Action name="U1598364219574" action="default" attribute="managerfullname" newvalue="{dataset.deletemanagerfullname.get()}"/>
				<Action name="U1587391220266" action="executeview" viewname="br_repositoryDetail" append="false" attribute="repositorycode">
					<ViewParam name="P15873912202660" param="uid" paramvalue="{dataset.repository.get()}"/>
					<ViewAttribute name="P1587391220266_1" attribute="code" variable="repositorycode"/>
					<ViewAttribute name="P1587391220266_2" attribute="displayname" variable="repositorydisplayname"/>
				</Action>
				<Action name="U1436014795240" action="update" attribute="ticketdescription" newvalue="{dataset.action.get()} {dataset.managertype.get()} on {dataset.repositorycode.get()}.{!dataset.isEmpty(&apos;managerfullname&apos;)?(&apos; new manager set to &apos;+dataset.managerhrcode.get()+&apos;-&apos;+dataset.managerfullname.get()):&apos;&apos;}. {!dataset.isEmpty(&apos;comments&apos;)?dataset.comments.get():&apos;&apos;}" condition="(! dataset.isEmpty(&apos;action&apos;))"/>
				<Action name="U1586502279675" action="multifilter" structname="" attribute="initialManager" oldname="manager" remove="true" attribute1="iniitalDelegation" attribute2="initialComment" attribute3="initialDelegationbegindate" attribute4="initialDelegationenddate" attribute5="initialDelegationreason" attribute6="initialExpertisedomain" attribute7="initialPriority" attribute8="initialRepositories" condition=""/>
				<Action name="U1587020713222" action="multireplace" attribute="iniitalDelegation" newvalue="{dataset.isEmpty(&apos;iniitalDelegation&apos;)?&apos;0&apos;:(dataset.iniitalDelegation.get().toLowerCase().equals(&apos;true&apos;)||dataset.iniitalDelegation.get().toLowerCase().equals(&apos;1&apos;))?&apos;1&apos;:&apos;0&apos;}"/>
			</Actions>
			<Ticket create="true" createaction="true">
				<Attribute name="tickettype" attribute="TICKETTYPE"/>
				<Attribute name="status" attribute="status"/>
				<Attribute name="custom2" attribute="manager"/>
				<Attribute name="description" attribute="ticketdescription"/>
				<Attribute name="custom1" attribute="repository"/>
			</Ticket>
			<Output name="output" ticketactionnumbervariable="ticketaction"/>
			<FormVariable name="A1586504698578" variable="comments" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586504712370" variable="action" action="input" mandatory="true" longlist="false"/>
			<FormVariable name="A1586504720226" variable="delegation" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586504728953" variable="delegationbegindate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586504733854" variable="delegationenddate" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586504739108" variable="delegationpriority" action="input" mandatory="false" longlist="false"/>
			<FormVariable name="A1586504745688" variable="delegationreason" action="input" mandatory="false" longlist="false"/>
		</Component>
		<Component name="CEND_1" type="endactivity" x="152" y="694" w="200" h="98" title="End - bwf_updaterepositorymanager" compact="true" inexclusive="true">
			<Actions>
				<Action name="U1444925106570" action="update" attribute="status" newvalue="done"/>
			</Actions>
		</Component>
		<Component name="C1444907469698_1" type="writemanageractivity" x="76" y="301" w="200" h="98" title="set new owners">
			<WriteManager name="writemanager" entitytype="R" entityuid="initialRepositories" domaincode="initialExpertisedomain" identityvariable="initialManager" comment="initialComment" delegflag="iniitalDelegation" delegpriority="initialPriority" delegreason="initialDelegationreason" begindate="initialDelegationbegindate" enddate="initialDelegationenddate" action="A"/>
		</Component>
		<Component name="C1444917358555_1" type="ticketreviewactivity" x="76" y="556" w="200" h="98" title="ticket review" inexclusive="true">
			<TicketReview ticketaction="ticketaction" expression="(! dataset.isEmpty(&apos;action&apos;))">
				<Application/>
				<Attribute name="comment" attribute="ticketdescription"/>
            <Attribute name="custom1" attribute="managerfullname"/>				
				<Attribute name="validfrom" attribute="delegationbegindate"/>
				<Attribute name="validto" attribute="delegationenddate"/>
				<Attribute name="status" attribute="action"/>
				<Attribute name="custom2" attribute="managertype"/>
				<Repository repositoryvariable="repository"/>
			</TicketReview>
		</Component>
		<Component name="N1494333701389_2" type="note" x="669" y="48" w="300" h="177" title="Important&#xA;&#xA;In order to use this workflow the following domains of expertise must be added during the data collection phase:&#xA;- businessowner&#xA;- technicalowner&#xA;&#xA;If you wish to use your own expertise domains please modify the managertype variable."/>
		<Component name="C1586528010292_1" type="variablechangeactivity" x="74" y="133" w="204" h="98" title="add new entry to the list">
			<Actions>
				<Action name="U1586502359974" action="multiadd" structname="" attribute="initialManager" oldname="manager" duplicates="false" condition=""/>
				<Action name="U1586502359975" action="multiadd" structname="" attribute="initialExpertisedomain" oldname="managertype" duplicates="false" condition=""/>
				<Action name="U1586502359976" action="multiadd" structname="" attribute="initialRepositories" oldname="repository" duplicates="false" condition=""/>
				<Action name="U1586502359977" action="multiadd" structname="" attribute="initialComment" oldname="comments" duplicates="false" condition=""/>
				<Action name="U1586502359978" action="multiadd" structname="" attribute="initialDelegationbegindate" oldname="delegationbegindate" duplicates="false" condition=""/>
				<Action name="U1586502359979" action="multiadd" structname="" attribute="initialDelegationenddate" oldname="delegationenddate" duplicates="false" condition=""/>
				<Action name="U1586502359980" action="multiadd" structname="" attribute="initialDelegationreason" oldname="delegationreason" duplicates="false" condition=""/>
				<Action name="U1586502359981" action="multiadd" structname="" attribute="initialPriority" oldname="delegationpriority" duplicates="false" condition=""/>
				<Action name="U1586502359982" action="multiadd" structname="" attribute="iniitalDelegation" oldname="delegation" duplicates="false" condition=""/>
				<Action name="U1587020747995" action="multireplace" attribute="iniitalDelegation" newvalue="{dataset.isEmpty(&apos;iniitalDelegation&apos;)?&apos;0&apos;:(dataset.iniitalDelegation.get().toLowerCase().equals(&apos;true&apos;)||dataset.iniitalDelegation.get().toLowerCase().equals(&apos;1&apos;))?&apos;1&apos;:&apos;0&apos;}"/>
			</Actions>
		</Component>
		<Link name="L1586528141141_1" source="CSTART_1" target="C1586528010292_1" priority="1" expression="(dataset.equals(&apos;action&apos;, &apos;create&apos;, false, true))" labelcustom="true" label="create"/>
		<Link name="L1444925089301_1" source="C1444907469698_1" target="C1444917358555_1" priority="1"/>
		<Link name="L1444917372446_1" source="C1444917358555_1" target="CEND_1" priority="1"/>
		<Component name="C1591357635688" type="writemanageractivity" x="448" y="301" w="300" h="98" title="Delete">
			<WriteManager name="writemanager" delete="managerLink"/>
		</Component>
		<Link name="L1591357666519" source="C1591357635688" target="C1444917358555_1" priority="1"/>
		<Link name="L1591357690197" source="C1586528010292_1" target="C1444907469698_1" priority="1"/>
		<Link name="L1444913689551_1" source="CSTART_1" target="C1591357635688" priority="2" expression="(dataset.equals(&apos;action&apos;, &apos;delete&apos;, false, true))" labelcustom="true" label="delete"/>
	</Definition>
	<Variables>
		<Variable name="A1435829483156" variable="action" displayname="action" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="false" description="defines the action to perform, can be either:&#xA;delete&#xA;create&#xA;modify">
			<StaticValue name="delete"/>
			<StaticValue name="create"/>
			<StaticValue name="modify"/>
		</Variable>
		<Variable name="A1435829523776" variable="manager" displayname="manager" editortype="Ledger Identity" type="String" multivalued="false" visibility="in" notstoredvariable="false" description="The new manager UID"/>
		<Variable name="A1435929633314" variable="DELEGATIONFLAG" displayname="delegation flag" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="0" notstoredvariable="false"/>
		<Variable name="A1436014095041" variable="managerhrcode" displayname="manager hrcode" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436014105812" variable="managerfullname" displayname="manager fullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436014511173" variable="TICKETTYPE" displayname="ticket type" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false" initialvalue="REPOSITORYMANAGER"/>
		<Variable name="A1436014613796" variable="ticketdescription" displayname="ticket description" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436163502208" variable="repository" displayname="repository" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436163693848" variable="repositorycode" displayname="repository code" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436163715894" variable="repositorydisplayname" displayname="repository displayname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1436340819362" variable="status" displayname="status" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="in progress" notstoredvariable="false">
			<StaticValue name="in progress"/>
			<StaticValue name="done"/>
		</Variable>
		<Variable name="A1436780414401" variable="managertype" displayname="manager type" editortype="Default" type="String" multivalued="false" visibility="in" description="Can be either businessowner or technical owner&#xA;Add these values as an expertise domains during &#xA;the data collection phase.&#xA;Or edit the values to match existing expertise domains." notstoredvariable="false">
			<StaticValue name="businessowner"/>
			<StaticValue name="technicalowner"/>
		</Variable>
		<Variable name="A1436780528448" variable="comments" displayname="comments" editortype="Default" type="String" multivalued="false" visibility="in" description="Comments are optional, if provided they are added at the end of the ticketlog description field." notstoredvariable="false"/>
		<Variable name="A1444924355043" variable="ticketaction" displayname="ticketaction" editortype="Default" type="Number" multivalued="false" visibility="local" notstoredvariable="false"/>
		<Variable name="A1586501581125" variable="initialRepositories" displayname="repositories" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501603953" variable="initialExpertisedomain" displayname="initial expertise domain" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501614721" variable="initialManager" displayname="initial manager" editortype="Ledger Identity" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501742100" variable="initialComment" displayname="initial comment" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501767877" variable="iniitalDelegation" displayname="initial delegation" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501798169" variable="initialPriority" displayname="initial priority" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501839744" variable="initialDelegationbegindate" displayname="initial delegation begin date" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501858089" variable="initialDelegationenddate" displayname="initial delegation end date" editortype="Default" type="Date" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586501875360" variable="initialDelegationreason" displayname="initial delegation reason" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1586503318674" variable="delegation" displayname="delegation" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="false"/>
		<Variable name="A1586503402468" variable="delegationpriority" displayname="delegationpriority" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="0"/>
		<Variable name="A1586503412623" variable="delegationbegindate" displayname="delegationbegindate" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="19700101000000"/>
		<Variable name="A1586503421918" variable="delegationenddate" displayname="delegationenddate" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue="20991231000000"/>
		<Variable name="A1586503432769" variable="delegationreason" displayname="delegationreason" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true" initialvalue=" "/>
		<Variable name="A1586525784088" variable="empty" displayname="empty" editortype="Ledger Identity" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1591357625332" variable="managerLink" editortype="Default" type="Number" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1598364086013" variable="deletemanagerfullname" displayname="deletemanagerfullname" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
	</Variables>
	<Roles>
		<Role name="A1435858866632" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owners" description="people who can start this process">
			<Rule name="A1436163457775" rule="updaterepositorymanagerstart" description="People who can start an update on a repository manager workflow"/>
		</Role>
	</Roles>
</Workflow>
