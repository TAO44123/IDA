<?xml version="1.0" encoding="UTF-8"?>
<Workflow version="1.0">
	<Definition name="bwr_initradiantonetickets" statictitle="init radiantone tickets" scriptfile="/workflow/bw_iasreview/initradiantonetickets.javascript" displayname="init radiantone tickets" type="builtin-technical-workflow" technical="true">
		<Component name="CSTART" type="startactivity" x="245" y="-257" w="200" h="114" title="Start" compact="true" outexclusive="true">
			<Ticket create="true"/>
			<Candidates name="role" role="A1655455409981"/>
		</Component>
		<Link name="L1655456154971" source="CSTART" target="C1703166068371" priority="1" labelcustom="true"/>
		<Component name="C1703166068371" type="variablechangeactivity" x="119" y="-149" w="300" h="98" title="get accounts to remediate" outexclusive="true">
			<Actions>
				<Action name="U1655455925851" action="executeview" viewname="bwiasr_initiddmaccountsperrepo" append="false" attribute="accountidentifier">
					<ViewAttribute name="P1655455925851_0" attribute="accountidentifier" variable="accountidentifier"/>
					<ViewAttribute name="P1655455925851_1" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1655455925851_2" attribute="repositorybwr_remediation_repository_type" variable="remediationtype"/>
					<ViewAttribute name="P1655455925851_3" attribute="repositoryrepositoryfamily" variable="accountrepositoryfamily"/>
					<ViewAttribute name="P1655455925851_4" attribute="repositorybwr_remediation_repository_instancecode" variable="accountrepositoryinstancecode"/>
				</Action>
				<Action name="U1703168972625" action="multiresize" attribute="accountidentifier" attribute1="actiondate" attribute2="ticketstatus" attribute3="ticketclosedstatus" attribute4="ticketfailed" attribute5="ticketopenstatus" attribute6="ticketerrorstatus"/>
				<Action name="U1712144901074" action="multireplace" attribute="ticketfailed" newvalue="IDDM Error"/>
				<Action name="U1703168988093" action="multireplace" attribute="ticketstatus" newvalue="Sent"/>
				<Action name="U1703168999389" action="multireplace" attribute="ticketclosedstatus" newvalue="1"/>
				<Action name="U1712144871177" action="multireplace" attribute="ticketopenstatus" newvalue="0"/>
				<Action name="U1712318509867" action="multireplace" attribute="ticketerrorstatus" newvalue="3"/>
				<Action name="U1703169015384" action="multireplace" attribute="actiondate" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1700154119233" action="multifilter" attribute="remediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="accountidentifier" attribute2="remediationtype" attribute3="accountrepositoryfamily" attribute4="accountrepositoryinstancecode" attribute5="ticketopenstatus" attribute6="ticketfailed" attribute7="ticketclosedstatus" attribute8="ticketstatus" attribute9="actiondate" attribute10="ticketerrorstatus"/>
			</Actions>
		</Component>
		<Component name="C1703166068371_1" type="variablechangeactivity" x="119" y="859" w="300" h="98" title="get groupmemberships to remediate" inexclusive="true" outexclusive="true">
			<Actions>
				<Action name="U1700217969604" action="executeview" viewname="bwiasr_initiddmgroupmembershipperrepo" append="false" attribute="remediationrecorduid">
					<ViewAttribute name="P1700217969604_0" attribute="remediationrecorduid" variable="remediationrecorduid"/>
					<ViewAttribute name="P1700217969604_1" attribute="accountidentifier" variable="accountidentifier"/>
					<ViewAttribute name="P1700217969604_2" attribute="groupcode" variable="groupcode"/>
					<ViewAttribute name="P1700217969604_3" attribute="bwr_remediation_repository_type" variable="remediationtype"/>
					<ViewAttribute name="P1700217969604_4" attribute="repositoryfamily" variable="grouprepositoryfamily"/>
				</Action>
				<Action name="U1703169153621" action="empty" attribute="ticketstatus"/>
				<Action name="U1703169163543" action="empty" attribute="ticketclosedstatus"/>
				<Action name="U1703169173053" action="empty" attribute="actiondate"/>
				<Action name="U1712145135462" action="empty" attribute="ticketfailed"/>
				<Action name="U1712145149266" action="empty" attribute="ticketopenstatus"/>
				<Action name="U1712318563517" action="empty" attribute="ticketerrorstatus"/>
				<Action name="U1703168972625" action="multiresize" attribute="accountidentifier" attribute1="actiondate" attribute2="ticketstatus" attribute3="ticketclosedstatus" attribute4="ticketfailed" attribute5="ticketopenstatus" attribute6="ticketerrorstatus"/>
				<Action name="U1703168988093" action="multireplace" attribute="ticketstatus" newvalue="Sent"/>
				<Action name="U1703168999389" action="multireplace" attribute="ticketclosedstatus" newvalue="1"/>
				<Action name="U1703169015384" action="multireplace" attribute="actiondate" newvalue="{new Date().toLDAPString()}"/>
				<Action name="U1712145191743" action="multireplace" attribute="ticketfailed" newvalue="IDDM Error"/>
				<Action name="U1712145223381" action="multireplace" attribute="ticketopenstatus" newvalue="0"/>
				<Action name="U1712318586879" action="multireplace" attribute="ticketerrorstatus" newvalue="3"/>
				<Action name="U2700154119233" action="multifilter" attribute="remediationrecorduid" oldname="filterbytickets" condition="(! dataset.isEmpty(&apos;filterbytickets&apos;))" remove="false" attribute1="accountidentifier" attribute2="groupcode" attribute3="remediationtype" attribute4="grouprepositoryfamily" attribute5="ticketopenstatus" attribute6="ticketfailed" attribute7="ticketclosedstatus" attribute8="ticketstatus" attribute9="actiondate" attribute10="ticketerrorstatus"/>
			</Actions>
		</Component>
		<Component name="CEND_1" type="endactivity" x="245" y="1806" w="200" h="98" title="End" compact="true" inexclusive="true"/>
		<Component name="C1703168081378" type="scriptactivity" x="119" y="13" w="300" h="98" title="Call IDDM for account remediation">
			<Script onscriptexecute="accountsRemediation"/>
		</Component>
		<Component name="C1703168081378_1" type="scriptactivity" x="119" y="1032" w="300" h="98" title="Call IDDM for group membership remediation">
			<Script onscriptexecute="groupmembershipsRemediation"/>
		</Component>
		<Component name="C1703168146903" type="updateticketreviewactivity" x="119" y="191" w="300" h="98" title="Close succeeded remediation">
			<UpdateTicketReview ticketreviewnumbervariable="success_remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Component name="C1703168146903_1" type="updateticketreviewactivity" x="119" y="1197" w="300" h="98" title="Close succeeded remediation">
			<UpdateTicketReview ticketreviewnumbervariable="success_remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1703168167754" source="C1703166068371" target="C1703168081378" priority="1" expression="dataset.accountidentifier.length&gt;0" labelcustom="true" label="Accounts to remediate"/>
		<Link name="L1703168168436" source="C1703168081378" target="C1703168146903" priority="1"/>
		<Link name="L1703168170233" source="C1703168146903" target="C1714753520629" priority="1"/>
		<Link name="L1703168171836" source="C1703166068371_1" target="C1703168081378_1" priority="1" labelcustom="true" label="Groups to remediate" expression="dataset.groupcode.length&gt;0"/>
		<Link name="L1703168172469" source="C1703168081378_1" target="C1703168146903_1" priority="1"/>
		<Link name="L1703168174019" source="C1703168146903_1" target="C1714753520629_1" priority="1"/>
		<Component name="N1703169314217" type="note" x="556" y="146" w="384" h="134" title="*** TODO ***&#xA;&#xA;IDDM Remediation API Calls&#xA;&#xA;Filter by tickets"/>
		<Component name="N1703169314217_1" type="note" x="559" y="326" w="384" h="134" title="WARNING - Can only handle &quot;Revoke&quot; actions"/>
		<Component name="C1703168146903_2" type="updateticketreviewactivity" x="121" y="703" w="300" h="98" title="Mark failed remediation">
			<UpdateTicketReview ticketreviewnumbervariable="failed_remediationrecorduid">
				<Attribute name="status" attribute="ticketfailed"/>
				<Attribute name="custom2" attribute="ticketerrorstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1712144716985" source="C1703168146903_2" target="C1703166068371_1" priority="1"/>
		<Component name="C1703168146903_3" type="updateticketreviewactivity" x="119" y="1636" w="300" h="98" title="Mark failed remediation">
			<UpdateTicketReview ticketreviewnumbervariable="failed_remediationrecorduid">
				<Attribute name="status" attribute="ticketfailed"/>
				<Attribute name="custom2" attribute="ticketopenstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1712145079920" source="C1703168146903_3" target="CEND_1" priority="1"/>
		<Link name="L1712317250362" source="C1703166068371" target="C1703166068371_1" priority="2"/>
		<Link name="L1712317254998" source="C1703166068371_1" target="CEND_1" priority="2"/>
		<Component name="C1714753520629" type="variablechangeactivity" x="117" y="372" w="300" h="98" title="warning status">
			<Actions>
				<Action name="U1714753573959" action="multireplace" attribute="ticketstatus" newvalue="warning"/>
			</Actions>
		</Component>
		<Component name="C1703168146903_4" type="updateticketreviewactivity" x="119" y="538" w="300" h="98" title="Close warning remediation">
			<UpdateTicketReview ticketreviewnumbervariable="warning_remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1714753653601" source="C1714753520629" target="C1703168146903_4" priority="1"/>
		<Link name="L1714753655153" source="C1703168146903_4" target="C1703168146903_2" priority="1"/>
		<Component name="C1714753520629_1" type="variablechangeactivity" x="115" y="1339" w="300" h="98" title="warning status">
			<Actions>
				<Action name="U1714753573959" action="multireplace" attribute="ticketstatus" newvalue="warning"/>
			</Actions>
		</Component>
		<Component name="C1703168146903_5" type="updateticketreviewactivity" x="119" y="1480" w="300" h="98" title="Close warning remediation">
			<UpdateTicketReview ticketreviewnumbervariable="warning_remediationrecorduid">
				<Attribute name="status" attribute="ticketstatus"/>
				<Attribute name="custom2" attribute="ticketclosedstatus"/>
				<Attribute name="actiondate" attribute="actiondate"/>
				<Attribute name="custom3" attribute="remediationtype"/>
			</UpdateTicketReview>
		</Component>
		<Link name="L1714753789288" source="C1714753520629_1" target="C1703168146903_5" priority="1"/>
		<Link name="L1714753790071" source="C1703168146903_5" target="C1703168146903_3" priority="1"/>
	</Definition>
	<Roles>
		<Role name="A1655455409981" icon="/reports/icons/48/people/personal_48.png" smallicon="/reports/icons/16/people/personal_16.png" displayname="owner" description="owner">
			<Rule name="A1655455418292" rule="bwdc_active_identities" description="active identities"/>
		</Role>
	</Roles>
	<Variables>
		<Variable name="A16554559258510" variable="accountidentifier" displayname="accountidentifier" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16554559258511" variable="remediationrecorduid" displayname="remediationrecorduid" multivalued="true" visibility="local" type="Number" editortype="Default"/>
		<Variable name="A17002179696042" variable="groupcode" displayname="groupcode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1703168876907" variable="ticketstatus" displayname="ticketstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1703168890748" variable="ticketclosedstatus" displayname="ticketclosedstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1703168900400" variable="actiondate" displayname="actiondate" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1703168913140" variable="remediationtype" displayname="remediationtype" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A16554559258513" variable="accountrepositoryfamily" displayname="accountrepositoryfamily" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A16554559258514" variable="accountrepositoryinstancecode" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1708678673773" variable="filterbytickets" displayname="filterbytickets" editortype="Default" type="Number" multivalued="true" visibility="in" notstoredvariable="true" description="OPTIONAL: filter by tickets"/>
		<Variable name="A17002179696044" variable="grouprepositoryfamily" displayname="grouprepositoryfamily" multivalued="true" visibility="local" type="String" editortype="Default"/>
		<Variable name="A1710423501216" variable="success_remediationrecorduid" displayname="success_remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1710423513222" variable="failed_remediationrecorduid" displayname="failed_remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1712144790569" variable="ticketfailed" displayname="ticketfailed" editortype="Default" type="String" multivalued="true" visibility="local" initialvalue="Error" notstoredvariable="true"/>
		<Variable name="A1712144819194" variable="ticketopenstatus" displayname="ticketopenstatus" editortype="Default" type="String" multivalued="true" visibility="local" initialvalue="0" notstoredvariable="true"/>
		<Variable name="A1712318488614" variable="ticketerrorstatus" displayname="ticketerrorstatus" editortype="Default" type="String" multivalued="true" visibility="local" notstoredvariable="true"/>
		<Variable name="A1714753359087" variable="warning_remediationrecorduid" displayname="warning_remediationrecorduid" editortype="Default" type="Number" multivalued="true" visibility="local" notstoredvariable="true"/>
	</Variables>
</Workflow>
