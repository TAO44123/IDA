<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmticketsperrepositoryjira" statictitle="inititsmticketsperrepository" scriptfile="workflow/bw_iasreview/inititsmticketsperrepositoryjira.javascript" displayname="inititsmticketsperrepository" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="203" y="-406" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions function="createChangeInfos">
				<Action name="U1655219668691" action="executeview" viewname="bwiasr_itsms" append="false" attribute="itsmurl">
					<ViewParam name="P16552196686910" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219668691_1" attribute="bwr_remediation_itsmdef_string4" variable="itsmurl"/>
					<ViewAttribute name="P1655219668691_2" attribute="bwr_remediation_itsmdef_string6" variable="itsmlogin"/>
					<ViewAttribute name="P1655219668691_3" attribute="bwr_remediation_itsmdef_string7" variable="itsmpassword"/>
					<ViewAttribute name="P1655219668691_4" attribute="bwr_remediation_itsmdef_string5" variable="itsmtickettype"/>
					<ViewAttribute name="P1655219668691_5" attribute="bwr_remediation_itsmdef_string8" variable="itsmprojectkey"/>
					<ViewAttribute name="P1655219668691_6" attribute="bwr_remediation_itsmdef_string9" variable="itsmassignee"/>
					<ViewAttribute name="P1655219668691_7" attribute="bwr_remediation_itsmdef_string10" variable="itsmtags"/>
					<ViewAttribute name="P1655219668691_8" attribute="bwr_remediation_itsmdef_string11" variable="itsmclosedstatesid"/>
					<ViewAttribute name="P1655219668691_9" attribute="bwr_remediation_itsmdef_string12" variable="itsmcancelledstatesid"/>
				</Action>
				<Action name="U1655217131432" action="executeview" viewname="bwiasr_initaccountsperrepobv" append="false" attribute="accountidentifier">
					<ViewParam name="P16552171314320" param="repository" paramvalue="{dataset.repository.get()}"/>
					<ViewParam name="P16552171314321" param="retrymode" paramvalue="{dataset.retrymode.get()}"/>
					<ViewAttribute name="P1655217131432_2" attribute="accountidentifier" variable="accountidentifier"/>
					<ViewAttribute name="P1655217131432_3" attribute="accountlogin" variable="accountlogin"/>
					<ViewAttribute name="P1655217131432_4" attribute="accountusername" variable="accountusername"/>
					<ViewAttribute name="P1655217131432_5" attribute="repositorydisplayname" variable="repositorydisplayname"/>
					<ViewAttribute name="P1655217131432_6" attribute="reviewstatus" variable="reviewstatus"/>
					<ViewAttribute name="P1655217131432_7" attribute="reviewactiondate" variable="reviewactiondate"/>
					<ViewAttribute name="P1655217131432_8" attribute="reviewcomment" variable="reviewcomment"/>
					<ViewAttribute name="P1655217131432_9" attribute="reviewerfullname" variable="reviewerfullname"/>
					<ViewAttribute name="P1655217131432_10" attribute="reviewerhrcode" variable="reviewerhrcode"/>
					<ViewAttribute name="P1655217131432_11" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655217131432_12" attribute="repositorybwr_remediation_repository_type" variable="remediationtype"/>
				</Action>
				<Action name="U1655220598185" action="update" attribute="changetitle" newvalue="Changes are requested for repository {dataset.repositorydisplayname.get(0)}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="203" y="1073" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Link name="L1507032744612_1" source="C1663058747968" target="C1655283825990" priority="1" expression="dataset.ticketCreated.get()==true" labelcustom="true" label="Ticket created"/>
		<Link name="L1507032752198_1" source="C1655283825990" target="C1655283996202" priority="1"/>
		<Link name="L1655223801669" source="C1655283996202" target="C1655285039929" priority="1"/>
		<Component name="C1655282499443" type="callactivity" x="77" y="-140" w="300" h="98" title="create ticket" outexclusive="true">
			<Process workflowfile="/workflow/bw_jira/createIssue.workflow">
				<Input name="A1663056251559" variable="domain" content="itsmurl"/>
				<Input name="A1663056257742" variable="login" content="itsmlogin"/>
				<Input name="A1663056264655" variable="token" content="itsmpassword"/>
				<Input name="A1663056271170" variable="projectkey" content="itsmprojectkey"/>
				<Input name="A1663056295771" variable="summary" content="changetitle"/>
				<Input name="A1663056333639" variable="description" content="changedescription"/>
				<Input name="A1663056345797" variable="assignee" content="itsmassignee"/>
				<Input name="A1663056353604" variable="issueType" content="itsmtickettype"/>
				<Input name="A1663056360638" variable="tags" content="tagslist"/>
				<Output name="A1663056383733" variable="ticketCreated" content="ticketCreated"/>
				<Output name="A1663056390490" variable="ticketId" content="ticketid"/>
				<Output name="A1663056398979" variable="ticketNumber" content="ticketnumber"/>
				<Output name="A1743105022079" variable="errorMessage" content="resultdescription"/>
			</Process>
		</Component>
		<Component name="C1655283825990" type="callactivity" x="77" y="229" w="300" h="98" title="add attachment">
			<Process workflowfile="/workflow/bw_jira/addattachment.workflow">
				<Input name="A1655283908764" variable="domain" content="itsmurl"/>
				<Input name="A1655283914472" variable="login" content="itsmlogin"/>
				<Input name="A1655283957385" variable="ticketid" content="ticketid"/>
				<Input name="A1663056438902" variable="token" content="itsmpassword"/>
				<Input name="A1663056448958" variable="filename" content="changefilename"/>
				<Input name="A1663056459911" variable="filecontent" content="changecsv"/>
			</Process>
		</Component>
		<Component name="C1655283996202" type="callactivity" x="77" y="405" w="300" h="98" title="get ticket status">
			<Process workflowfile="/workflow/bw_jira/getstatus.workflow">
				<Input name="A1655284052375" variable="domain" content="itsmurl"/>
				<Input name="A1655284059873" variable="login" content="itsmlogin"/>
				<Input name="A1655284124942" variable="ticketid" content="ticketid"/>
				<Input name="A1663056502950" variable="token" content="itsmpassword"/>
				<Output name="A1663056534655" variable="statusid" content="status"/>
				<Output name="A1663056544007" variable="statuslabel" content="statusStr"/>
			</Process>
		</Component>
		<Component name="C1655285039929" type="variablechangeactivity" x="77" y="563" w="300" h="98" title="get status pretty string" inexclusive="true">
			<Actions function="computeStatus">
			</Actions>
		</Component>
		<Link name="L1655285152421" source="C1655285039929" target="C1655285039929_2" priority="1"/>
		<Component name="C1655285385163" type="updateticketreviewactivity" x="77" y="866" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="custom5" attribute="ticketextref1"/>
				<Attribute name="custom6" attribute="ticketextref2"/>
				<Attribute name="custom7" attribute="ticketextrefinstance"/>
				<Attribute name="custom8" attribute="ticketextrefurl"/>
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Component name="N1655285741279" type="note" x="771" y="565" w="445" h="262" title="REMEDIATION TICKET&#xA;&#xA;recorduid&#x9;remediation internal unique identifier&#xA;status&#x9;remediation printable status&#xA;comment&#x9;remediation comment&#xA;actiondate&#x9;remediation last action date&#xA;custom1&#x9;remediation access right printable information&#xA;custom2&#x9;remediation closed status&#xA;0 = ticket open, 1 = ticket closed, done, 2 = ticket closed, cancel&#xA;custom3&#x9;remediation type (embedded / itsm)&#xA;custom4&#x9;timeslotuid when the last remediation ticket update has been made&#xA;custom5&#x9;External reference (Displayable Ticket Number)&#xA;custom6&#x9;External reference (internal infos)&#xA;custom7&#x9;External system instance&#xA;custom8&#x9;External system hyperlink&#xA;"/>
		<Link name="L1655296149592" source="C1655285385163" target="CEND" priority="1"/>
		<Component name="N1656070964558" type="note" x="440" y="-302" w="300" h="174" title="Jira Cloud&#xA;string4 url&#xA;string5 issuetype&#xA;string6 login&#xA;string7 token&#xA;string8 projectkey&#xA;string9 assignee&#xA;string10 tags&#xA;string11 closedstatesid&#xA;string12 cancelledstatesid&#xA;"/>
		<Component name="C1655285039929_2" type="variablechangeactivity" x="77" y="731" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655286096596" action="update" attribute="shortlink" newvalue="https://{dataset.itsmurl.get()}/browse/{dataset.ticketnumber.get()}"/>
				<Action name="U1655295807040" action="multiresize" attribute="remediationrecorduid" attribute1="ticketextref1" attribute2="ticketextref2" attribute3="ticketextrefinstance" attribute4="ticketextrefurl" attribute5="ticketstatus" attribute6="ticketclosedstatus"/>
				<Action name="U1655295826647" action="multireplace" attribute="ticketextref1" newvalue="{dataset.ticketnumber.get()}"/>
				<Action name="U1655295840461" action="multireplace" attribute="ticketextref2" newvalue="{dataset.ticketid.get()}"/>
				<Action name="U1655295866101" action="multireplace" attribute="ticketextrefurl" newvalue="{dataset.shortlink.get()}"/>
				<Action name="U1655295905658" action="multireplace" attribute="ticketextrefinstance" newvalue="{dataset.remediationinstancecode.get()}"/>
				<Action name="U1655296086172" action="multireplace" attribute="ticketstatus" newvalue="{dataset.statusStr.get()}"/>
				<Action name="U1655297574445" action="multireplace" attribute="ticketclosedstatus" newvalue="{dataset.closedstatus.get()}"/>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
			</Actions>
		</Component>
		<Link name="L1656320419972" source="C1655285039929_2" target="C1655285385163" priority="1"/>
		<Component name="C1657213098824" type="variablechangeactivity" x="77" y="-300" w="300" h="98" title="attachment name">
			<Actions>
				<Action name="U1657213197377" action="update" attribute="changefilename" newvalue="incidents.csv"/>
			</Actions>
		</Component>
		<Link name="L1657213106526" source="C1657213098824" target="C1655282499443" priority="1"/>
		<Link name="L1663053334753" source="CSTART" target="C1657213098824" priority="1"/>
		<Component name="C1663058747968" type="variablechangeactivity" x="77" y="38" w="300" h="98" title="for debug only" outexclusive="true"/>
		<Link name="L1663058760317" source="C1655282499443" target="C1663058747968" priority="3"/>
		<Component name="C1655285385163_1" type="updateticketreviewactivity" x="426" y="866" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="comment" attribute="resultdescription"/>
				<Attribute name="custom10" attribute="remediationinstancecode"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1743104668039" source="C1655285385163_1" target="CEND" priority="1"/>
		<Component name="C1655285039929_6" type="variablechangeactivity" x="426" y="731" w="300" h="98" title="prepare tickets updates" inexclusive="true">
			<Actions>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1741617078445" action="update" attribute="ticketstatus" newvalue="error"/>
				<Action name="U1741635074654" action="update" attribute="ticketclosedstatus" newvalue="3"/>
			</Actions>
		</Component>
		<Link name="L1743105123816" source="C1655285039929_6" target="C1655285385163_1" priority="1"/>
		<Link name="L1743105132891" source="C1663058747968" target="C1655285039929_6" priority="2"/>
	</Definition>
	<Variables>
		<Variable name="A1655217226547" variable="repository" displayname="repository" editortype="Ledger Repository" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A1655218389344" variable="remediationinstancecode" displayname="remediationinstancecode" editortype="Default" type="String" multivalued="false" visibility="in" notstoredvariable="true"/>
		<Variable name="A16552196686910" variable="itsmurl" displayname="itsmurl" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686912" variable="itsmlogin" displayname="itsmlogin" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686913" variable="itsmpassword" displayname="itsmpassword" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552171314320" variable="accountidentifier" displayname="accountidentifier" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314321" variable="accountlogin" displayname="accountlogin" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314322" variable="accountusername" displayname="accountusername" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314323" variable="repositorydisplayname" displayname="repositorydisplayname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314324" variable="reviewstatus" displayname="reviewstatus" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314325" variable="reviewactiondate" displayname="reviewactiondate" multivalued="true" visibility="local" type="Date" editortype="Default"/>
		<Variable name="A16552171314326" variable="reviewcomment" displayname="reviewcomment" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314327" variable="reviewerfullname" displayname="reviewerfullname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552171314328" variable="reviewerhrcode" displayname="reviewerhrcode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1655220685558" variable="changetitle" displayname="changetitle" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655223458229" variable="changedescription" displayname="changedescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655223468053" variable="changecsv" displayname="changecsv" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224016630" variable="ticketid" displayname="ticketid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224026188" variable="ticketnumber" displayname="ticketnumber" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224033702" variable="ticketCreated" displayname="ticketCreated" editortype="Default" type="Boolean" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655224232644" variable="changefilename" displayname="change filename" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="changerequest.csv" notstoredvariable="true"/>
		<Variable name="A1655224264884" variable="debug" displayname="debug" editortype="Default" type="Boolean" multivalued="false" visibility="in" initialvalue="true" notstoredvariable="true"/>
		<Variable name="A1655224341996" variable="status" displayname="status" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655285020078" variable="statusStr" displayname="statusStr" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655285638269" variable="remediationrecorduid" displayname="remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655286005798" variable="shortlink" displayname="shortlink" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295727684" variable="ticketextref1" displayname="ticketextref1" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295733994" variable="ticketextref2" displayname="ticketextref2" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295744532" variable="ticketextrefurl" displayname="ticketextrefurl" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655295759078" variable="ticketextrefinstance" displayname="ticketextrefinstance" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655296052276" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655297281617" variable="closedstatus" displayname="closedstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655297519707" variable="ticketclosedstatus" displayname="ticketclosedstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655365599420" variable="currentdatetime" displayname="currentdatetime" editortype="Default" type="String" multivalued="false" visibility="local" description="current date time" notstoredvariable="true"/>
		<Variable name="A1655389419787" variable="usertable" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="sys_user" notstoredvariable="true"/>
		<Variable name="A1655389484062" variable="usersearchattr" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="user_name" notstoredvariable="true"/>
		<Variable name="A1656063936417" variable="itsmtickettype" displayname="itsmtickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="incident">
			<StaticValue name="incident"/>
			<StaticValue name="changerequest"/>
		</Variable>
		<Variable name="A165521713143210" variable="remediationtype" displayname="remediationtype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16552196686914" variable="itsmprojectkey" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686915" variable="itsmassignee" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686916" variable="itsmtags" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686917" variable="itsmclosedstatesid" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A16552196686918" variable="itsmcancelledstatesid" multivalued="false" visibility="local" type="String" editortype="Default" notstoredvariable="false"/>
		<Variable name="A1663055313848" variable="tagslist" displayname="tagslist" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1663055335927" variable="closedstateslist" displayname="closedstateslist" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1663055350942" variable="cancelledtaskslist" displayname="cancelledtaskslist" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1743104988674" variable="resultdescription" displayname="resultdescription" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1743105846777" variable="retrymode" displayname="retrymode" editortype="Default" type="Boolean" multivalued="false" visibility="in" notstoredvariable="true"/>
	</Variables>
</Workflow>
