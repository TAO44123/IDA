<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_inititsmticketspergroupmembershipmail" statictitle="inititsmticketspergroupmembershipmail" scriptfile="workflow/bw_iasreview/inititsmticketsperrepositorymail.javascript" displayname="inititsmticketspergroupmembershipmail" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="244" y="66" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Actions function="init">
				<Action name="U1655219668691" action="executeview" viewname="bwiasr_itsms" append="false" attribute="sendto_name">
					<ViewParam name="P16552196686910" param="itsmcode" paramvalue="{dataset.remediationinstancecode.get()}"/>
					<ViewAttribute name="P1655219668691_1" attribute="bwr_remediation_itsmdef_string4" variable="sendto_name"/>
					<ViewAttribute name="P1655219668691_2" attribute="bwr_remediation_itsmdef_string5" variable="sendto_mail"/>
				</Action>
				<Action name="U1655217131432" action="executeview" viewname="bwiasr_initgroupmembershipperrepobv" append="false" attribute="accountidentifier">
					<ViewParam name="P16552171314320" param="repository" paramvalue="{dataset.repository.get()}"/>
					<ViewAttribute name="P1655217131432_1" attribute="accountidentifier" variable="accountidentifier"/>
					<ViewAttribute name="P1655217131432_2" attribute="accountlogin" variable="accountlogin"/>
					<ViewAttribute name="P1655217131432_3" attribute="accountusername" variable="accountusername"/>
					<ViewAttribute name="P1655217131432_4" attribute="reviewstatus" variable="reviewstatus"/>
					<ViewAttribute name="P1655217131432_5" attribute="reviewactiondate" variable="reviewactiondate"/>
					<ViewAttribute name="P1655217131432_6" attribute="reviewcomment" variable="reviewcomment"/>
					<ViewAttribute name="P1655217131432_7" attribute="reviewerfullname" variable="reviewerfullname"/>
					<ViewAttribute name="P1655217131432_8" attribute="reviewerhrcode" variable="reviewerhrcode"/>
					<ViewAttribute name="P1655217131432_9" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655217131432_10" attribute="groupcode" variable="groupcode"/>
					<ViewAttribute name="P1655217131432_11" attribute="groupdisplayname" variable="groupdisplayname"/>
					<ViewAttribute name="P1655217131432_12" attribute="grouprepositorydisplayname" variable="grouprepositorydisplayname"/>
					<ViewAttribute name="P1655217131432_13" attribute="repositorydisplayname" variable="repositorydisplayname"/>
					<ViewAttribute name="P1655217131432_14" attribute="repositorybwr_remediation_repository_type" variable="remediationtype"/>
				</Action>
				<Action name="U1655220598185" action="update" attribute="changetitle" newvalue="Changes are requested for repository {dataset.grouprepositorydisplayname.get(0)}"/>
			</Actions>
		</Component>
		<Component name="CEND" type="endactivity" x="244" y="839" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="C1655285385163" type="updateticketreviewactivity" x="118" y="582" w="300" h="98" title="update ticket number &amp; review status">
			<UpdateTicketReview ticketreviewnumbervariable="remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="currentdatetime"/>
				<Attribute name="custom3" attribute="remediationtype"/>
				<Attribute name="custom5" attribute="sendto_name"/>
				<Attribute name="custom6" attribute="sendto_mail"/>
				<Attribute name="custom7" attribute="remediationinstancecode"/>
			</UpdateTicketReview>
		</Component>
		<Component name="N1655285741279" type="note" x="632" y="263" w="445" h="262" title="REMEDIATION TICKET&#xA;&#xA;recorduid&#x9;remediation internal unique identifier&#xA;status&#x9;remediation printable status&#xA;comment&#x9;remediation comment&#xA;actiondate&#x9;remediation last action date&#xA;custom1&#x9;remediation access right printable information&#xA;custom2&#x9;remediation closed status&#xA;0 = ticket open, 1 = ticket closed, done, 2 = ticket closed, cancel&#xA;custom3&#x9;remediation type (embedded / itsm)&#xA;custom4&#x9;timeslotuid when the last remediation ticket update has been made&#xA;custom5&#x9;External reference (Displayable Ticket Number)&#xA;custom6&#x9;External reference (internal infos)&#xA;custom7&#x9;External system instance&#xA;custom8&#x9;External system hyperlink&#xA;"/>
		<Link name="L1655296149592" source="C1655285385163" target="C1662538677679" priority="1"/>
		<Component name="N1656070964558" type="note" x="625" y="57" w="300" h="174" title="string4 send to: name&#xA;string5 send to: mail"/>
		<Component name="C1655285039929_2" type="variablechangeactivity" x="118" y="438" w="300" h="98" title="prepare ticket update" inexclusive="true">
			<Actions>
				<Action name="U1655365636898" action="update" attribute="currentdatetime" newvalue="{new Date().toLDAPString()}"/>
			</Actions>
		</Component>
		<Link name="L1656320419972" source="C1655285039929_2" target="C1655285385163" priority="1"/>
		<Component name="C1662481348535" type="mailnotificationactivity" x="118" y="287" w="300" h="98" title="Send notifications" outexclusive="true">
			<Notification name="mail" mail="A1662483050908" ignoreerror="true"/>
			<Output name="output" okmailvariable="emailsent"/>
		</Component>
		<Link name="L1662483547164" source="CSTART" target="C1662538654815" priority="1"/>
		<Link name="L1662483685750" source="C1662481348535" target="C1655285039929_2" priority="1" expression="dataset.emailsent.length&gt;0" labelcustom="true" label="email sent"/>
		<Component name="C1662538654815" type="startsubactivity" x="244" y="177" w="300" h="50" compact="true" title="Subprocess start">
			<Iteration listvariable="accountidentifier">
				<Variable name="A1662481461856" variable="accountlogin"/>
				<Variable name="A1662481468685" variable="accountusername"/>
				<Variable name="A1662481475204" variable="repositorydisplayname"/>
				<Variable name="A1662481483258" variable="reviewstatus"/>
				<Variable name="A1662481492202" variable="reviewactiondate"/>
				<Variable name="A1662481499520" variable="reviewcomment"/>
				<Variable name="A1662481506502" variable="reviewerfullname"/>
				<Variable name="A1662481513388" variable="reviewerhrcode"/>
				<Variable name="A1662539040957" variable="remediationrecorduid"/>
				<Variable name="A1662539114679" variable="remediationtype"/>
				<Variable name="A1700229254542" variable="groupcode"/>
				<Variable name="A1700229261350" variable="groupdisplayname"/>
				<Variable name="A1700229265236" variable="grouprepositorydisplayname"/>
			</Iteration>
		</Component>
		<Link name="L1662538671540" source="C1662538654815" target="C1662481348535" priority="1"/>
		<Component name="C1662538677679" type="endsubactivity" x="244" y="730" w="300" h="50" compact="true" title="Subprocess end" inexclusive="true"/>
		<Link name="L1662538689036" source="C1662538677679" target="CEND" priority="1"/>
		<Link name="L1662538846583" source="C1662481348535" target="C1662538677679" priority="2" labelcustom="true" label="Error, mail not sent"/>
		<Component name="N1662641374282" type="note" x="317" y="144" w="300" h="139" title="*** WARNING ***&#xA;Send notifications does not work in debug mode in Analytics (always says that the mail has not been sent)"/>
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
		<Variable name="A1655296052276" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="Sent"/>
		<Variable name="A1655297281617" variable="closedstatus" displayname="closedstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655297519707" variable="ticketclosedstatus" displayname="ticketclosedstatus" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="1"/>
		<Variable name="A1655365599420" variable="currentdatetime" displayname="currentdatetime" editortype="Default" type="String" multivalued="false" visibility="local" description="current date time" notstoredvariable="true"/>
		<Variable name="A1655389419787" variable="usertable" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="sys_user" notstoredvariable="true"/>
		<Variable name="A1655389484062" variable="usersearchattr" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="user_name" notstoredvariable="true"/>
		<Variable name="A1655389508734" variable="itsmcallerid" displayname="itsmcallerid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="brainwave"/>
		<Variable name="A1655389573769" variable="callersysid" displayname="callersysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1655389903050" variable="grouptable" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="sys_user_group" notstoredvariable="true"/>
		<Variable name="A1655390002160" variable="groupsearchattr" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="name" notstoredvariable="true"/>
		<Variable name="A1655390098803" variable="itsmassignmentgroup" editortype="Default" type="String" multivalued="false" visibility="local" initialvalue="Service Desk" notstoredvariable="true"/>
		<Variable name="A1655390108850" variable="assignmentgroupsysid" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1656063936417" variable="itsmtickettype" displayname="itsmtickettype" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true" initialvalue="incident">
			<StaticValue name="incident"/>
			<StaticValue name="changerequest"/>
		</Variable>
		<Variable name="A165521713143210" variable="remediationtype" displayname="remediationtype" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1662483329680" variable="sendto_name" displayname="sendto_name" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662483335241" variable="sendto_mail" displayname="sendto_mail" editortype="Default" type="String" multivalued="false" visibility="local" notstoredvariable="true"/>
		<Variable name="A1662538788567" variable="emailsent" displayname="emailsent" editortype="Default" type="String" multivalued="true" visibility="local" description="to test if the email has been sent" notstoredvariable="true"/>
		<Variable name="A1662561796707" variable="sendto_id" editortype="Default" type="String" multivalued="true" visibility="local" initialvalue="##1" notstoredvariable="true"/>
		<Variable name="A165521713143211" variable="groupcode" displayname="groupcode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A165521713143212" variable="groupdisplayname" displayname="groupdisplayname" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A165521713143213" variable="grouprepositorydisplayname" displayname="grouprepositorydisplayname" multivalued="true" visibility="local" type="String" editortype="Default"/>
	</Variables>
	<Mails>
		<Mail name="A1662483050908" displayname="remediation mail" description="remediation mail" notifyrule="bwiasr_groupmembership_remediation" tolist="sendto_id">
			<Param name="accountidentifier" variable="accountidentifier"/>
			<Param name="accountlogin" variable="accountlogin"/>
			<Param name="accountusername" variable="accountusername"/>
			<Param name="repositorydisplayname" variable="repositorydisplayname"/>
			<Param name="reviewstatus" variable="reviewstatus"/>
			<Param name="reviewcomment" variable="reviewcomment"/>
			<Param name="reviewerfullname" variable="reviewerfullname"/>
			<Param name="reviewerhrcode" variable="reviewerhrcode"/>
			<Param name="reviewactiondate" variable="reviewactiondate"/>
			<Param name="sendto_mail" variable="sendto_mail"/>
			<Param name="sendto_name" variable="sendto_name"/>
			<Param name="groupcode" variable="groupcode"/>
			<Param name="groupdisplayname" variable="groupdisplayname"/>
			<Param name="grouprepositorydisplayname" variable="grouprepositorydisplayname"/>
		</Mail>
	</Mails>
</Workflow>
