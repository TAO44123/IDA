param
(
    [ValidateSet("Mixed-mode", "RestAPI-only", "EVD-only")][string]$mode = "Mixed-mode",
    [string]$vaultName,
    [string]$PVWAURL,
    [ValidateSet("cyberark", "ldap", "radius")][string]$AuthType = "cyberark",
    [ValidateSet("on-premise", "cloud")][string]$environment = "on-premise",
    [string]$Tenant_URL,
    [string]$credential,
    [string]$outputDirectory,
    $skipCertificateCheck = $true,
    $exportDetails = $true,
    [int]$limit = 1000,
    [string]$logDirectory,
    [Int]$retryCount = 5,
    [Int]$delaySecond = 5,
    [Int]$TimeoutSec = 0,
    [string]$LDAPConfigFile,
    [string]$GroupRecursiveSearch="false",
    [string]$EVD_location,
    [string]$EVD_config="vault.ini", 
    [string]$EVD_cred="user.ini",
    [Int]$logNumOfDays=45,
    [ValidateSet('Debug', 'Info', 'Warning', 'Error')][string]$logLevel = "Info",
    [ValidateSet('Continue', 'Ignore', 'Inquire', 'SilentlyContinue', 'Stop', 'Suspend')][string]$errAction = "SilentlyContinue",
    $apiGen,
    [string]$printLog = $true
)

# Global URLS
# -----------
if($PVWAURL.Contains("PasswordVault")){
    $URL_PVWAAPI =  $PVWAURL + "/api"    
}else{
    $URL_PVWAAPI =  $PVWAURL + "/PasswordVault/api"
}
if("cloud" -eq $environment){
    $URL_Logon = $Tenant_URL + "/oauth2/platformtoken"  
}else{
    $URL_Authentication = $URL_PVWAAPI + "/auth"
    $URL_Logon = $URL_Authentication + "/$AuthType/Logon"
}
$URL_Logoff = $URL_Authentication + "/Logoff"
$URL_Old_Gen = $PVWAURL + "/WebServices/PIMServices.svc"
# URL Methods
# -----------
if("cloud" -eq $environment){
    if($PVWAURL.Contains("PasswordVault")){
        $URL_Server =  $PVWAURL + "/WebServices/PIMServices.svc/Server"    
    }else{
        $URL_Server =  $PVWAURL + "/PasswordVault/WebServices/PIMServices.svc/Server"
    }
}else{
    $URL_Server = $URL_Old_Gen + "/Server"
}
$URL_Directories = $URL_PVWAAPI + "/Configuration/LDAP/Directories"
$URL_Safes = $URL_PVWAAPI + "/Safes?limit=$($limit)&ExtendedDetails=True"
$URL_SafeMembers = $URL_PVWAAPI + "/Safes/{0}/Members?limit=$($limit)"
$URL_Users = $URL_PVWAAPI + "/Users?ExtendedDetails=True"
$URL_Users_Without_Details = $URL_PVWAAPI + "/Users"
$URL_UserGroups = $URL_PVWAAPI + "/UserGroups"
$URL_Accounts = $URL_PVWAAPI + "/Accounts?limit=$($limit)"
$URL_Directory = $URL_PVWAAPI + "/Configuration/LDAP/Directories/{0}/"
$URL_LDAP_Mapping = $URL_Directory + "Mappings"
$URL_Users_Details = $URL_PVWAAPI + "/Users/{0}"

$URL_Safes_Old_Gen = $URL_Old_Gen + "/Safes"
$URL_Safes_Details_Old_Gen = $URL_Old_Gen + "/Safes/{0}"
$URL_SafeMembers_Old_Gen = $URL_Old_Gen + "/Safes/{0}/Members"

# Out files
$OUT_Safes = "_safes.csv"
$OUT_SafeMembers = "_safemembers.csv"
$OUT_Users = "_users.csv"
$OUT_UserGroups = "_groups.csv"
$OUT_Accounts = "_accounts.csv"
$OUT_LdapMapping = "_ldapmapping.csv"
$OUT_LdapMDirectories = "_ldapdirectories.csv"
$OUT_ObjectsEVD = "_EVD-ObjectProperties.csv"

#Headers atributes
$safeHeaders = @("safeUrlId", "safeName", "safeNumber", "description", "location", "creator.id", "accounts", "olacEnabled", "managingCPM", "numberOfVersionsRetention", "numberOfDaysRetention", "AutoPurgeEnabled", "creationTime", "lastModificationTime", "isExpiredMember")
$safeMembersHeaders = @("safeUrlId", "safeName", "safeNumber", "memberId", "memberName", "memberType", "membershipExpirationDate", "isExpiredMembershipEnable", "isPredefinedUser", "permissions")
$userHeaders = @("id", "username", "directory", "userDN", "source", "changePasswordOnTheNextLogon", "expiryDate", "groupsMembership.groupID", "userType", "unAuthorizedInterfaces", "componentUser", "location", "enableUser", "suspended", "personalDetails.firstName", "personalDetails.lastName", "authenticationMethod", "passwordNeverExpires", "distinguishedName", "internet.businessEmail", "description", "lastSuccessfulLoginDate", "vaultAuthorization")
$groupHeaders = @("id", "groupType", "groupName", "description", "location", "directory", "dn", "members")
$accountHeaders = @("CategoryModificationTime", "id", "name", "address", "userName", "platformId", "safeName", "secretType", "platformAccountProperties", "secretManagement.automaticManagementEnabled", "secretManagement.manualManagementReason", "secretManagement.status", "secretManagement.lastModifiedTime", "secretManagement.lastReconciledTime", "secretManagement.lastVerifiedTime", "remoteMachinesAccess.remoteMachines", "remoteMachinesAccess.accessRestrictedToRemoteMachines", "createdTime")
$ldapMappingHeaders = @("domainName","domainBaseContext","DomainGroups", "MappingName", "MappingAuthorizations", "LDAPBranch", "VaultGroups", "Location", "AuthenticationMethod", "UserType", "DisableUser", "UserActivityLogPeriod", "UserExpiration", "LogonFromHour", "LogonToHour", "MappingID", "secretManagement.status", "DirectoryMappingOrder", "LDAPQuery")
$ldapDirectoriesHeaders = @("groupRecursiveSearch","domainBaseContext","ldapDirectoryName","directoryType","domainName","bindUsername","hostAddresses","ldapDirectoryQueryOrder","ldapDirectoryDescription","vaultObjectNamesPrefix","passwordObjectPath","ldapDirectoryGroupsBaseContext","ldapDirectoryUsage","requireReferredDirectoryDefinition","appendFriendlyDomainNameToGroup","disableUserEnumeration","provisionDisabledUsers")
# ldapDirectories not exported attributes: (additionalQueryFilterOptimize,clientBrowsing,externalObjectsCreation,authentication,useLDAPCertificatesOnly,disablePaging,Port,sslConnect,ldapDirectoryUsage,referralsChasingHopLimit,referralsDNSLookup,bindPassword)
$headersMap = @{}
$headersMap.Add("Safes", $safeHeaders)
$headersMap.Add("SafeMembers", $safeMembersHeaders)
$headersMap.Add("Users", $userHeaders)
$headersMap.Add("Groups", $groupHeaders)
$headersMap.Add("Accounts", $accountHeaders)
$headersMap.Add("LdapMappings", $ldapMappingHeaders)
$headersMap.Add("LdapDirectories", $ldapDirectoriesHeaders)

# EVD Out files
$OUT_AccountsEVD = "_EVD-FilesList.csv"
$OUT_GroupsMembersEVD = "_EVD-GroupMembersList.csv"
$OUT_UserGroupsEVD = "_EVD-GroupsList.csv"
$OUT_SafeMembersEVD = "_EVD-OwnersList.csv"
$OUT_UsersEVD = "_EVD-UsersList.csv"
$OUT_SafesEVD = "_EVD-SafesList.csv"
$OUT_LogsEVD = "_EVD-LogList.csv"

#EVD Headers atributes
$safeHeadersEVD = @("<SafeID>","<SafeName>","<LocationID>","<LocationName>","<Size>","<MaxSize>","<%UsedSize>","<LastUsed>","<VirusFree>","<TextOnly>","<AccessLocation>","<SecurityLevel>","<Delay>","<FromHour>","<ToHour>","<DailyVersions>","<MonthlyVersions>","<YearlyVersions>","<LogRetentionPeriod>","<ObjectsRetentionPeriod>","<RequestRetentionPeriod>","<ShareOptions>","<ConfirmersCount>","<ConfirmType>","<DefaultAccessMarks>","<DefaultFileCompression>","<DefaultReadOnly>","<QuotaOwner>","<UseFileCategories>","<RequireReasonToRetrieve>","<EnforceExlusivePasswords>","<RequireContentValidation>","<CreationDate>","<CreatedBy>","<NumberOfPasswordVersions>")
$safeMembersHeadersEVD = @("<SafeID>","<SafeName>","<OwnerID>","<OwnerName>","<OwnerType>","<ExpirationDate>","<List>","<Retrieve>","<CreateObject>","<UpdateObject>","<UpdateObjectProperties>","<RenameObject>","<Delete>","<ViewAudit>","<ViewOwners>","<UsePassword>","<InitiateCPMChange>","<InitiateCPMChangeWithManualPassword>","<CreateFolder>","<DeleteFolder>","<UnlockObject>","<MoveFrom>","<MoveInto>","<ManageSafe>","<ManageSafeOwners>","<ValidateSafeContent>","<Backup>","<NoConfirmRequired>","<Confirm>","<EventsList>","<EventsAdd>")
$userHeadersEVD = @("<UserID>","<UserName>","<LocationID>","<LocationName>","<FirstName>","<LastName>","<BusinessEmail>","<Disabled>","<FromHour>","<ToHour>","<ExpirationDate>","<PasswordNeverExpires>","<LogRetentionPeriod>","<AuthenticationMethods>","<Authorizations>","<GatewayAccountAuthorizations>","<DistinguishedName>","<Internal/External>","<LDAPFullDN>","<LDAPDirectory>","<MapName>","<MapID>","<LastLogonDate>","<PrevLogonDate>","<UserTypeID>","<RestrictedInterfaces>","<ApplicationMetadata>","<CreationDate>")
$groupHeadersEVD = @("<GroupID>","<GroupName>","<LocationID>","<LocationName>","<Description>","<ExternalGroupName>","<Internal/External>","<LDAPFullDN>","<LDAPDirectory>","<MapName>","<MapID>")
$groupMemberHeadersEVD = @("<GroupID>","<UserID>","<MemberIsGroup>")
$accountHeadersEVD = @("<SafeID>","<SafeName>","<Folder>","<FileID>","<FileName>","<InternalName>","<Size>","<CreatedBy>","<CreationDate>","<LastUsedBy>","<LastUsedDate>","<ModificationDate>","<ModifiedBy>","<DeletedBy>","<DeletionDate>","<LockDate>","<LockBy>","<LockedByUserID>","<Accessed>","<New>","<Retrieved>","<Modified>","<IsRequestNeeded>","<ValidationStatus>","<Type>","<CompressedSize>","<LastModifiedDate>","<LastModifiedBy>","<LastUsedByHuman>","<LastUsedHumanDate>","<LastUsedByComponent>","<LastUsedComponentDate>")

#EVD 
$headersMapEVD = @{}
$headersMapEVD.Add("Safes", $safeHeadersEVD)
$headersMapEVD.Add("SafeMembers", $safeMembersHeadersEVD)
$headersMapEVD.Add("Users", $userHeadersEVD)
$headersMapEVD.Add("Groups", $groupHeadersEVD)
$headersMapEVD.Add("Accounts", $accountHeadersEVD)
$headersMapEVD.Add("GroupsMembers", $groupMemberHeadersEVD)

$predefinedGroupsPermissions = @{}
$predefinedGroupsPermissions.Add("Auditors", "listAccounts,viewSafeMembers,viewAuditLog")
$predefinedGroupsPermissions.Add("Backup Users", "backupSafe")
$predefinedGroupsPermissions.Add("DR Users", "backupSafe")
$predefinedGroupsPermissions.Add("Notification Engines", "listAccounts,viewSafeMembers,viewAuditLog")
$predefinedGroupsPermissions.Add("Operators", "createFolders,deleteFolders,unlockAccounts,moveAccountsAndFolders,manageSafe")
$predefinedGroupsPermissions.Add("PVWAGWAccounts", "listAccounts,viewSafeMembers,viewAuditLog")

$predefinedGroupsId = @{}
$predefinedGroupsId.Add("Auditors", $null)
$predefinedGroupsId.Add("Backup Users", $null)
$predefinedGroupsId.Add("DR Users", $null)
$predefinedGroupsId.Add("Notification Engines", $null)
$predefinedGroupsId.Add("Operators", $null)
$predefinedGroupsId.Add("PVWAGWAccounts", $null)

$predefinedUsersPermissions = @{}
$predefinedUsersPermissions.Add("Administrator", "useAccounts,retrieveAccounts,listAccounts,addAccounts,updateAccountContent,updateAccountProperties,initiateCPMAccountManagementOperations,specifyNextAccountContent,renameAccounts,deleteAccounts,unlockAccounts,manageSafe,manageSafeMembers,backupSafe,viewAuditLog,viewSafeMembers,requestsAuthorizationLevel1,requestsAuthorizationLevel2,accessWithoutConfirmation,createFolders,deleteFolders,moveAccountsAndFolders")

$predefinedUsersId = @{}
$predefinedUsersId.Add("Administrator", $null)
######################################## FUNCTIONS USED FOR LOGS ################################################
# dumpScriptParameters
# return string containig script parameters 
function dumpScriptParameters() {
    $varList = New-Object -TypeName "System.Text.StringBuilder";
    $varList = $varList.Append('{')
    $varList = $varList.Append("mode").Append('=').Append($mode).Append(';')
    $varList = $varList.Append("PVWAURL").Append('=').Append($PVWAURL).Append(';')
    $varList = $varList.Append("AuthType").Append('=').Append($AuthType).Append(';')
    $varList = $varList.Append("credential").Append('=').Append($credential).Append(';')
    $varList = $varList.Append("outputDirectory").Append('=').Append($outputDirectory).Append(';')
    $varList = $varList.Append("skipCertificateCheck").Append('=').Append($skipCertificateCheck).Append(';')
    $varList = $varList.Append("exportDetails").Append('=').Append($exportDetails).Append(';')
    $varList = $varList.Append("limit").Append('=').Append($limit).Append(';')
    $varList = $varList.Append("EVD_location").Append('=').Append($EVD_location).Append(';')
    $varList = $varList.Append("EVD_config").Append('=').Append($EVD_config).Append(';')
    $varList = $varList.Append("EVD_cred").Append('=').Append($EVD_cred).Append(';')
    $varList = $varList.Append("logDirectory").Append('=').Append($logDirectory).Append(';')
    $varList = $varList.Append("logLevel").Append('=').Append($logLevel).Append(';')
    $varList = $varList.Append("errAction").Append('=').Append($errAction).Append(';')
    $varList = $varList.Append("printLog").Append('=').Append($printLog).Append(';')
    $varList = $varList.Append('}')
    return $varList = $varList.ToString()
}

function Write-Log { 
    [CmdletBinding()] 
    Param 
    ( 
        $Message,
        [ValidateSet("Error", "Warning", "Info", "Debug")] [string]$Level = "Info"
    )
    if (canLog $logLevel $Level) {
        $formattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        if($Message.Exception){
            if($Message.ErrorDetails.Message){
                $formattedMsg = '[{0}] {1} - {2} [{3}]' -f $formattedDate, $Level, $Message.Exception.Message, $Message.ErrorDetails.Message
            }else{
                $formattedMsg = '[{0}] {1} - {2}' -f $formattedDate, $Level, $Message.Exception.Message
            }
        }else{
            $formattedMsg = '[{0}] {1} - {2}' -f $formattedDate, $Level, $Message
        }        
        $formattedMsg >> $__logfile__
        if ($Level -eq 'Error') {
            <#
            $Message >> $__logfile__
            "---------" >> $__logfile__
            if ($Message.ScriptStackTrace) {
                $Message.ScriptStackTrace >> $__logfile__
            }
            "---------" >> $__logfile__
            if ($Message.Exception.Response) {
                $Message.Exception.Response >> $__logfile__
                $msg = "StatusCode=$($Message.Exception.Response.StatusCode.Value__)"
                $msg >> $__logfile__
            }
            #>
            if("String" -ne $Message.GetType().Name){
                "##################### Error details" >> $__logfile__
                $Message | Format-List -force >> $__logfile__
    
                if($Message.Exception){
                    "##################### Error exception details" >> $__logfile__ 
                    $Message.Exception | Format-List -force >> $__logfile__
                }
    
                if($Message.Exception.InvocationInfo){
                    "##################### Error invocationInfo" >> $__logfile__ 
                    $Message.Exception.InvocationInfo | Format-List -force >> $__logfile__
                }
    
                if($Message.Exception.Response){
                    "##################### Error response details [StatusCode=$($Message.Exception.Response.StatusCode.Value__)]" >> $__logfile__ 
                    $Message.Exception.Response | Format-List -force >> $__logfile__
                }
            }
        }
        switch ($Level) { 
            'Error' { 
                printLog $formattedMsg $Level
            } 
            'Warning' { 
                printLog $formattedMsg $Level
            } 
            'Info' { 
                printLog $formattedMsg $Level
            }
            'Debug' { 
                printLog $formattedMsg $Level
            } 		
        } 	
    }
}

function printLog() {
    [CmdletBinding()] 
    Param 
    ( 
        [string]$message,
        [string]$Level = "Info"
    )
    
    if ($printLog -eq $true) {
        if ($connectorMode) {
            send_message $Message $Level
        }
        else {
            Write-Host $Message
        }
    }
}

function canLog() {	
    [CmdletBinding()] 
    Param 
    ( 
        [string]$ScriptLogLevel,
        [string]$Level
    )
    $canLog = $false
    $Script = getLevel $ScriptLogLevel
    $curentLevel = getLevel $Level
    if ($curentLevel -le $Script) {
        $canLog = $true
    }
    $canLog
    return
}

function getLevel() {

    [CmdletBinding()] 
    Param 
    ( 
        [string]$Level
    )
    $numLevel = 0
    switch ($Level) { 
        'Error' { 
            $numLevel = 0
        } 
        'Warning' { 
            $numLevel = 1
        } 
        'Info' { 
            $numLevel = 2
        }
        'Debug' { 
            $numLevel = 3
        }
    }
    $numLevel
    return
}
######################################## END FUNCTIONS USED FOR LOGS ################################################

Function Convert-Date($epochdate) {
    $formatedDate = $null
    if ($epochdate) {
        $strValue = "" + $epochdate
        if (($strValue).length -gt 10 ) { 
            $dif = $strValue.Length - 10
            $div = [math]::pow(10, $dif)
            $epochdate = $epochdate / $div
        }
        $date = (Get-Date -Date "01/01/1970").AddSeconds($epochdate) 
        $formatedDate = Get-Date -Date $date -Format 'yyyyMMddHHmmss.0Z'
    }
    return $formatedDate
}

Function Convert-Date-CA($epochdate) {
    if (($epochdate).length -gt 10 ) {
        $d = (Get-Date -Date "01/01/1970").AddMilliseconds($epochdate)
        $formatedDate = Get-Date -Date $d -Format 'yyyyMMddHHmmss'
        return $formatedDate
    }
    else {
        $d = (Get-Date -Date "01/01/1970").AddSeconds($epochdate)
        $formatedDate = Get-Date -Date $d -Format 'yyyyMMddHHmmss'
        return $formatedDate
    }
}

function VaultVersion {
    $apiV = $null
    $retryAttempts = 0
    $backoffInterval = $delaySecond
    while ($retryAttempts -le $retryCount) {
        try {
            if ($skipCertificateCheck) {
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $URL_Server -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec -SkipCertificateCheck
            }
            else {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $URL_Server -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec
            }
            $retryAttempts = $retryCount + 1
        }
        catch {
            Write-Log -Message $_ -Level Error
            $Error.RemoveAt($Error.Count - 1)
            if ($retryAttempts -eq $retryCount) {
                Write-Log "Fatal - retry attempts limits exceeded" -Level Error
                if ($errAction -eq "Stop") {
                    exit
                }
                else {
                    return
                }
            }
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.Value__                
            }
            if ($_.ErrorDetails.Message) {
                try {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                    $ErrorCode = $ErrorDetails.ErrorCode                        
                }
                catch {
                    Write-Log -Message "ErrorDetails is not a valid Json String" -Level Debug
                    $Error.RemoveAt($Error.Count - 1)
                }
            }

            if ($throttlingCode -eq $statusCode) {
                Write-Log "Throttling - request limits exceeded, Retry-After $backoffInterval seconds..." -Level Warning
                Start-Sleep -s $backoffInterval
                $retryAttempts++
                $backoffInterval = $backoffInterval * 2
            }
            elseif ($null -ne $ErrorCode) {
                if ($tokenExpiredCodes.ContainsKey($ErrorCode)) {
                    Write-Log -Message "Requesting for new token..." -Level Info
                    $token = GetToken
                    if ($null -eq $token -or $token -eq "") {
                        Write-Log -Message "No token was returned" -Level Warning
                        $retryAttempts = $retryCount + 1
                    }
                    else {
                        Write-Log -Message "New token was returned" -Level Info
                        $logonHeader.Clear()
                        $logonHeader.Add("Authorization", $token)
                        if ($retryAttempts -eq 0) {
                            $retryAttempts = $retryCount
                        }
                    }                        
                }
                else {
                    $retryAttempts = $retryCount + 1
                }
            }
            else {
                $retryAttempts = $retryCount + 1
            }    
        }
    }
    $script:_vault_name = $GetServerResponse.ServerName
    $script:_ExternalVersion = $GetServerResponse.ExternalVersion
    $script:_InternalVersion = $GetServerResponse.InternalVersion
    Write-Log -Message "Vault name: $($_vault_name)" -Level Info
    Write-Log -Message "Vault ExternalVersion: $($script:_ExternalVersion)" -Level Info
    Write-Log -Message "Vault InternalVersion: $($script:_InternalVersion)" -Level Info
    if($script:_ExternalVersion.IndexOf('.') -gt 0){
        $versions = $script:_ExternalVersion.Split('.');
        if("12" -eq $versions['0']){
            $apiV = 2
        }else{
            $apiV = 1
        }
    }
    return $apiV
}

function LogOff {
    if("cloud" -ne $environment){
        Write-Log -Message "Logoff Session..." -Level Info
        if ($true -eq $skipCertificateCheck) {
            Invoke-RestMethod -Method Post -Uri $URL_Logoff -Headers $logonHeader -ContentType "application/json"  -SkipCertificateCheck | Out-Null
        }
        else {
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
            Invoke-RestMethod -Method Post -Uri $URL_Logoff -Headers $logonHeader -ContentType "application/json" | Out-Null
        }    
    }
}
function ListLDAPDirectories {
    $result = @{}
    $retryAttempts = 0
    $backoffInterval = $delaySecond
    while ($retryAttempts -le $retryCount) {
        try {
            if ($skipCertificateCheck) {
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $URL_Directories -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec -SkipCertificateCheck
            }
            else {
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $URL_Directories -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec
            }
            $retryAttempts = $retryCount + 1
        }
        catch {
            if($_.Exception.Message){
                Write-Log -Message $_.Exception.Message -Level Error
            }
            if ($_.ErrorDetails.Message) {
                Write-Log -Message $_.ErrorDetails.Message -Level Error
            }
            
            #$Error.RemoveAt($Error.Count - 1)
            if ($retryAttempts -eq $retryCount) {
                Write-Log "Fatal - retry attempts limits exceeded" -Level Error
                if ($errAction -eq "Stop") {
                    exit
                }
                else {
                    return
                }
            }
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.Value__                
            }
            if ($_.ErrorDetails.Message) {
                try {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                    $ErrorCode = $ErrorDetails.ErrorCode                        
                }
                catch {
                    Write-Log -Message "ErrorDetails is not a valid Json String" -Level Debug
                    $Error.RemoveAt($Error.Count - 1)
                }
            }

            if ($throttlingCode -eq $statusCode) {
                Write-Log "Throttling - request limits exceeded, Retry-After $backoffInterval seconds..." -Level Warning
                Start-Sleep -s $backoffInterval
                $retryAttempts++
                $backoffInterval = $backoffInterval * 2
                $Error.RemoveAt($Error.Count - 1)
            }
            elseif ($null -ne $ErrorCode) {
                if ($tokenExpiredCodes.ContainsKey($ErrorCode)) {
                    Write-Log -Message "Requesting for new token..." -Level Info
                    $token = GetToken
                    if ($null -eq $token -or $token -eq "") {
                        Write-Log -Message "No token was returned" -Level Warning
                        $retryAttempts = $retryCount + 1
                    }
                    else {
                        Write-Log -Message "New token was returned" -Level Info
                        $logonHeader.Clear()
                        $logonHeader.Add("Authorization", $token)
                        if ($retryAttempts -eq 0) {
                            $retryAttempts = $retryCount
                        }
                        $Error.RemoveAt($Error.Count - 1)
                    }                        
                }
                else {
                    $retryAttempts = $retryCount + 1
                }
            }
            else {
                $retryAttempts = $retryCount + 1
            }    
        }
    }            

    if ($GetServerResponse) {
        foreach ($domain in $GetServerResponse) {
            $result.Add($domain.DomainBaseContext, $domain.DomainName)
        }
    }
    return $result
}

function getObjectDetails {
    param ($url)
    $retryAttempts = 0
    $backoffInterval = $delaySecond
    while ($retryAttempts -le $retryCount) {
        try {
            if ($skipCertificateCheck) {
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $url -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec -SkipCertificateCheck
            }
            else {
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                $GetServerResponse = Invoke-RestMethod -Method Get -Uri $url -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec
            }
            $retryAttempts = $retryCount + 1
        }
        catch {
            if($_.Exception.Message){
                Write-Log -Message $_.Exception.Message -Level Error
            }
            if ($_.ErrorDetails.Message) {
                Write-Log -Message $_.ErrorDetails.Message -Level Error
            }
            #($Error.Count - 1)
            if ($retryAttempts -eq $retryCount) {
                Write-Log "Fatal - retry attempts limits exceeded" -Level Error
                if ($errAction -eq "Stop") {
                    exit
                }
                else {
                    return
                }
            }
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.Value__                
            }
            if ($_.ErrorDetails.Message) {
                try {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                    $ErrorCode = $ErrorDetails.ErrorCode                        
                }
                catch {
                    Write-Log -Message "ErrorDetails is not a valid Json String" -Level Debug
                    $Error.RemoveAt($Error.Count - 1)
                }
            }

            if ($throttlingCode -eq $statusCode) {
                Write-Log "Throttling - request limits exceeded, Retry-After $backoffInterval seconds..." -Level Warning
                Start-Sleep -s $backoffInterval
                $retryAttempts++
                $backoffInterval = $backoffInterval * 2
                $Error.RemoveAt($Error.Count - 1)
            }
            elseif ($null -ne $ErrorCode) {
                if ($tokenExpiredCodes.ContainsKey($ErrorCode)) {
                    Write-Log -Message "Requesting for new token..." -Level Info
                    $token = GetToken
                    if ($null -eq $token -or $token -eq "") {
                        Write-Log -Message "No token was returned" -Level Warning
                        $retryAttempts = $retryCount + 1
                    }
                    else {
                        Write-Log -Message "New token was returned" -Level Info
                        $logonHeader.Clear()
                        $logonHeader.Add("Authorization", $token)
                        if ($retryAttempts -eq 0) {
                            $retryAttempts = $retryCount
                        }
                        $Error.RemoveAt($Error.Count - 1)
                    }                        
                }
                else {
                    $retryAttempts = $retryCount + 1
                }
            }
            else {
                $retryAttempts = $retryCount + 1
            }    
        }
    }            
    return $GetServerResponse
}

function getCloudToken{
    $extractCredential = $null
    $cloud_token = ""
    if ($credential) {
        if (Test-Path $credential) {
            $extractCredential = Import-CliXml $credential                        
        }
        else {
            Write-Error "Credential file $credential not found"
        }
    }
    else {
        Write-Error "Credential file not set"
    }
            
    if ($extractCredential) {
        $userName = $extractCredential.GetNetworkCredential().UserName
        $userPass = $extractCredential.GetNetworkCredential().password        
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/x-www-form-urlencoded")
        $logonBody = "grant_type=client_credentials&client_id=$($userName)&client_secret=$($userPass)"
        #$body = @{ client_id = $userName; client_secret = $userPass;  "grant_type" = "client_credentials"}
        #$logonBody = $body | ConvertTo-Json
        $response = Invoke-RestMethod -Method Post -Uri $URL_Logon -Body $logonBody -Headers $headers
        #$response | ConvertTo-Json
        $cloud_token = $response.access_token
    }
    Write-Log -Level Debug -Message $cloud_token
    return $cloud_token
}

function getOnPremToken{
    $extractCredential = $null
    if ($credential) {
        if (Test-Path $credential) {
            $extractCredential = Import-CliXml $credential                        
        }
        else {
            Write-Error "Credential file $credential not found"
        }
    }
    else {
        Write-Error "Credential file not set"
    }
            
    if ($extractCredential) {
        $userName = $extractCredential.GetNetworkCredential().UserName
        $userPass = $extractCredential.GetNetworkCredential().password
        $logonBody = @{ username = $userName; password = $userPass }
        $logonBody = $logonBody | ConvertTo-Json
        # Logon
        if ($true -eq $skipCertificateCheck) {
            $logonToken = Invoke-RestMethod -Method Post -Uri $URL_Logon -Body $logonBody -ContentType "application/json" -SkipCertificateCheck
        }
        else {
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
            $logonToken = Invoke-RestMethod -Method Post -Uri $URL_Logon -Body $logonBody -ContentType "application/json"
        }
    }
    return $logonToken
}

function GetToken {
    Write-Log "Getting Token..." -Level Debug
    $value = ""
    if("cloud" -eq $environment){
        $value = getCloudToken
    }else{
        $value = getOnPremToken
    }
    Write-Log -Level Debug -Message $value
    return $value
}
function InvokeCARest {
    param ($url, $objectType, $commonObject, $optId)
    $retryAttempts = 0
    $backoffInterval = $delaySecond
    while ($retryAttempts -le $retryCount) {
        try {
            if ($true -eq $skipCertificateCheck) {
                $GetObjectsResponse = Invoke-RestMethod -Method Get -Uri $url -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec -SkipCertificateCheck
            }
            else {
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                $GetObjectsResponse = Invoke-RestMethod -Method Get -Uri $url -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec            
            }
            $retryAttempts = $retryCount + 1
        }
        catch {
            if($_.Exception.Message){
                Write-Log -Message $_.Exception.Message -Level Error
            }
            if ($_.ErrorDetails.Message) {
                Write-Log -Message $_.ErrorDetails.Message -Level Error
            }
            #$Error.RemoveAt($Error.Count - 1)
            if ($retryAttempts -eq $retryCount) {
                Write-Log "Fatal - retry attempts limits exceeded" -Level Error
                if ($errAction -eq "Stop") {
                    exit
                }
                else {
                    return
                }
            }
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.Value__                
            }
            if ($_.ErrorDetails.Message) {
                try {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                    $ErrorCode = $ErrorDetails.ErrorCode                        
                }
                catch {
                    Write-Log -Message "ErrorDetails is not a valid Json String" -Level Debug
                    $Error.RemoveAt($Error.Count - 1)
                }
            }

            if ($throttlingCode -eq $statusCode) {
                Write-Log "Throttling - request limits exceeded, Retry-After $backoffInterval seconds..." -Level Warning
                Start-Sleep -s $backoffInterval
                $retryAttempts++
                $backoffInterval = $backoffInterval * 2
                $Error.RemoveAt($Error.Count - 1)
            }
            elseif ($null -ne $ErrorCode) {
                if ($tokenExpiredCodes.ContainsKey($ErrorCode)) {
                    Write-Log -Message "Requesting for new token..." -Level Info
                    $token = GetToken
                    if ($null -eq $token -or $token -eq "") {
                        Write-Log -Message "No token was returned" -Level Warning
                        $retryAttempts = $retryCount + 1
                    }
                    else {
                        Write-Log -Message "New token was returned" -Level Info
                        $logonHeader.Clear()
                        $logonHeader.Add("Authorization", $token)
                        if ($retryAttempts -eq 0) {
                            $retryAttempts = $retryCount
                        }
                        $Error.RemoveAt($Error.Count - 1)
                    }                        
                }
                else {
                    $retryAttempts = $retryCount + 1
                }
            }
            else {
                $retryAttempts = $retryCount + 1
            }    
        }
    }            

    $GetObjectsList = @()
    if ("Users" -eq $objectType) {
        $GetObjectsList += $GetObjectsResponse.Users
    }
    elseif ($GetObjectsResponse -is [System.Array]) {
        $GetObjectsList += $GetObjectsResponse
    }
    elseif ("LdapDirectories" -eq $objectType) {
        $GetObjectsList += $GetObjectsResponse
    }elseif ("Safes" -eq $objectType -and $apiGen -eq 1) {
        $GetObjectsList += $GetObjectsResponse.GetSafesResult
    }elseif ("SafeMembers" -eq $objectType -and $apiGen -eq 1) {
        $GetObjectsList += $GetObjectsResponse.members
        foreach ($object in $GetObjectsList) {
            $object | Add-Member -NotePropertyName safeUrlId -NotePropertyValue $optId
            $object | Add-Member -NotePropertyName SafeName -NotePropertyValue $optId
            if( $script:safes_cache.ContainsKey($optId) ){
                $cacheSafeNumber = $script:safes_cache[$optId]
                $object | Add-Member -NotePropertyName safeNumber -NotePropertyValue $cacheSafeNumber
            }            
            $membertype = $null
            $memberid = $null
            if($script:users_cache.ContainsKey($object.UserName)){
                $memberid = $script:users_cache[$object.UserName]
                $membertype = "User"
            }elseif($script:groups_cache.ContainsKey($object.UserName)){
                $memberid = $script:groups_cache[$object.UserName]
                $membertype = "Group"
            }
            $object | Add-Member -NotePropertyName memberId -NotePropertyValue $memberid
            $object | Add-Member -NotePropertyName memberName -NotePropertyValue $object.UserName
            $object | Add-Member -NotePropertyName memberType -NotePropertyValue $membertype    
        }
    }else {
        $GetObjectsList += $GetObjectsResponse.value
    }
    Write-Log -Message "$($GetObjectsList.count) $($objectType) returned" -Level Debug
    HandleObjects $GetObjectsList $objectType $commonObject
    $nextLink = $GetObjectsResponse.nextLink
    if ($GetObjectsResponse -isnot [System.Array]) {
        While ($nextLink -ne "" -and $null -ne $nextLink) {
            Write-Log -Message "Requestion next link $($nextLink)" -Level Debug
            $retryAttempts = 0
            $backoffInterval = $delaySecond
            while ($retryAttempts -le $retryCount) {
                try {
                    if ($true -eq $skipCertificateCheck) {
                        $GetObjectsResponse = Invoke-RestMethod -Method Get -Uri $("$PVWAURL/$nextLink") -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec -SkipCertificateCheck
                    }
                    else {
                        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                        $GetObjectsResponse = Invoke-RestMethod -Method Get -Uri $("$PVWAURL/$nextLink") -Headers $logonHeader -ContentType "application/json" -TimeoutSec $TimeoutSec
                    }
                    $retryAttempts = $retryCount + 1
                }
                catch {
                    Write-Log -Message $_ -Level Error
                    $Error.RemoveAt($Error.Count - 1)
                    if ($retryAttempts -eq $retryCount) {
                        Write-Log "Fatal - retry attempts limits exceeded" -Level Error
                        if ($errAction -eq "Stop") {
                            exit
                        }
                        else {
                            return
                        }
                    }
                    if ($_.Exception.Response) {
                        $statusCode = $_.Exception.Response.StatusCode.Value__                
                    }
                    if ($_.ErrorDetails.Message) {
                        try {
                            $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                            $ErrorCode = $ErrorDetails.ErrorCode                        
                        }
                        catch {
                            Write-Log -Message "ErrorDetails is not a valid Json String" -Level Debug
                            $Error.RemoveAt($Error.Count - 1)
                        }
                    }
        
                    if ($throttlingCode -eq $statusCode) {
                        Write-Log "Throttling - request limits exceeded, Retry-After $backoffInterval seconds..." -Level Warning
                        Start-Sleep -s $backoffInterval
                        $retryAttempts++
                        $backoffInterval = $backoffInterval * 2
                    }
                    elseif ($null -ne $ErrorCode) {
                        if ($tokenExpiredCodes.ContainsKey($ErrorCode)) {
                            Write-Log -Message "Requesting for new token..." -Level Info
                            $token = GetToken
                            if ($null -eq $token -or $token -eq "") {
                                Write-Log -Message "No token was returned" -Level Warning
                                $retryAttempts = $retryCount + 1
                            }
                            else {
                                Write-Log -Message "New token was returned" -Level Info
                                $logonHeader.Clear()
                                $logonHeader.Add("Authorization", $token)
                                if ($retryAttempts -eq 0) {
                                    $retryAttempts = $retryCount
                                }
                            }                        
                        }
                        else {
                            $retryAttempts = $retryCount + 1
                        }
                    }
                    else {
                        $retryAttempts = $retryCount + 1
                    }    
                }
            }            
            $nextLink = $GetObjectsResponse.nextLink
            if ("Users" -eq $objectType) {
                $GetObjectsList = $GetObjectsResponse.Users
            }
            elseif ($GetObjectsResponse -is [System.Array]) {
                $GetObjectsList = $GetObjectsResponse
            }
            elseif ("LdapDirectories" -eq $objectType) {
                $GetObjectsList += $GetObjectsResponse
            }elseif ("Safes" -eq $objectType -and $apiGen -eq 1) {
                $GetObjectsList += $GetObjectsResponse.GetSafesResult
            }elseif ("SafeMembers" -eq $objectType -and $apiGen -eq 1) {
                $GetObjectsList += $GetObjectsResponse.members
                foreach ($object in $GetObjectsList) {
                    $object | Add-Member -NotePropertyName safeUrlId -NotePropertyValue $optId
                    $object | Add-Member -NotePropertyName SafeName -NotePropertyValue $optId
                    if( $script:safes_cache.ContainsKey($optId) ){
                        $cacheSafeNumber = $script:safes_cache[$optId]
                        $object | Add-Member -NotePropertyName safeNumber -NotePropertyValue $cacheSafeNumber
                    }
                    $membertype = $null
                    $memberid = $null
                    if($script:users_cache.ContainsKey($object.UserName)){
                        $memberid = $script:users_cache[$object.UserName]
                        $membertype = "User"
                    }elseif($script:groups_cache.ContainsKey($object.UserName)){
                        $memberid = $script:groups_cache[$object.UserName]
                        $membertype = "Group"
                    }
                    $object | Add-Member -NotePropertyName memberId -NotePropertyValue $memberid
                    $object | Add-Member -NotePropertyName memberName -NotePropertyValue $object.UserName
                    $object | Add-Member -NotePropertyName memberType -NotePropertyValue $membertype    
                }
            }else {
                $GetObjectsList = $GetObjectsResponse.value
            }   
            Write-Log -Message "$($GetObjectsList.count) $($objectType) returned" -Level Debug
            HandleObjects $GetObjectsList $objectType $commonObject
            $nextLink = $GetObjectsResponse.nextLink
        }
    }
}

function HandleObjects {
    param ($objects, $type, $commonObject)
    if ($objects.Length -gt 0) {
        $stringBuilder = New-Object -TypeName "System.Text.StringBuilder" 
        $headers = $headersMap[$type]
        for ($i = 0; $i -lt $objects.Length; $i++) {
            $object = $objects[$i]
            if ($null -ne $object) {                
                if ("Safes" -eq $type) {
                    if($apiGen -eq 1){
                        if( $script:safes_cache.ContainsKey($object.SafeName) ){
                            $cacheSafeNumber = $script:safes_cache[$object.SafeName]
                            $object | Add-Member -NotePropertyName safeNumber -NotePropertyValue  $cacheSafeNumber
                        }
                        $object | Add-Member -NotePropertyName safeUrlId -NotePropertyValue $object.SafeName                        
                        #$detailsUrl = $URL_Safes_Details_Old_Gen -f $object.SafeName
                        #$details = getObjectDetails $detailsUrl
                        #Write-Host $details
                    }
                    $safeIDs.Add($object.safeUrlId) | Out-Null
                }
                if($apiGen -eq 1){
                    if ("Users" -eq $type) {
                        if(-not $script:users_cache.ContainsKey($object.username)){
                            $script:users_cache.Add($object.username, $object.id);
                        }                        
                    }
                    if ("Groups" -eq $type) {
                        if(-not $script:groups_cache.ContainsKey($object.groupName)){
                            $script:groups_cache.Add($object.groupName, $object.id);
                        }
                    }
                    if ("Accounts" -eq $type){
                        if($null -ne $object.id -eq $object.id.IndexOf('_') -ne 0){
                            $parts = $object.id.Split('_')
                            $safeNumber = $parts[0]
                            if(-not $script:safes_cache.ContainsKey($object.safeName)){
                                $script:safes_cache.Add($object.safeName, $safeNumber)
                            }                            
                        }
                    }    
                }
                #Add static data (example: add domainName for ldapmapping of same directory)
                if($commonObject){
                    foreach($key in $commonObject.keys){
                        $object | Add-Member -MemberType NoteProperty -Name $key -Value $commonObject[$key]
                    }
                }
                $fObject = FormatObjectResult $object $headers $type
                $data = ConvertTo-Csv -InputObject $fObject -Delimiter ';' -NoTypeInformation
                if (($i + 1) -lt $objects.Length) {
                    $stringBuilder = $stringBuilder.Append($data[1]).AppendLine()
                }
                else {
                    $stringBuilder = $stringBuilder.Append($data[1])
                }
            }                
        }
        $outputPath = $outputPaths[$type]
        Write-Log -Message "Writing $($objects.Length) $($type) to output file $($outputPath)" -Level Debug
        addFileContent $outputPath $stringBuilder
        $stringBuilder = $stringBuilder.Clear()
    }
}
function convertSafeMembers {
    param ($object, $attributes, $type)
    $permissions = $object.Permissions
    foreach ($permission in $permissions) {
        
    }
}
function FormatObjectResult {
    param ($object, $attributes, $type)
    $dataObject = New-Object -TypeName psobject	
    if ($true -eq $exportDetails -and "Users" -eq $type) {
        $id = $object.id
        Write-Log -Message "Requesting Details of user: $($object.username)" -Level Debug
        $detailsUrl = $URL_Users_Details -f $id
        $details = getObjectDetails $detailsUrl
        if ($details) {
            $object | Add-Member -MemberType NoteProperty -Name expiryDate -Value $details.expiryDate
            $object | Add-Member -MemberType NoteProperty -Name lastSuccessfulLoginDate -Value $details.lastSuccessfulLoginDate
            $object | Add-Member -MemberType NoteProperty -Name passwordNeverExpires -Value $details.passwordNeverExpires
            if($apiGen -eq 1){
                $object | Add-Member -MemberType NoteProperty -Name unAuthorizedInterfaces -Value $details.unAuthorizedInterfaces
                $object | Add-Member -MemberType NoteProperty -Name enableUser -Value $details.enableUser
                $object | Add-Member -MemberType NoteProperty -Name suspended -Value $details.suspended
                $object | Add-Member -MemberType NoteProperty -Name distinguishedName -Value $details.distinguishedName
                #$object | Add-Member -MemberType NoteProperty -Name userDN -Value $details.distinguishedName
            }
        }
    }

    foreach ($attributeName in $attributes) {
        $value = ""
        if ("permissions" -eq $attributeName -and "SafeMembers" -eq $type) {
            if ($apiGen -eq 1){
                $value = AggregateSafePermissions_1 $object.Permissions
            }else{
                $value = AggregateSafePermissions $object.permissions
            }
        }
        elseif ($attributeName.IndexOf('.') -ne -1) {
            $value = Get-Sub-Value $object $attributeName
        }
        elseif ("members" -eq $attributeName -and "Groups" -eq $type) {
            if ($object.members -is [System.Array]) {
                if ($object.members.Length -gt 0) {
                    $members = @()
                    foreach ($v in $object.members) {
                        $members += $v
                    }
                    $value = $members -join ','
                }
                else {
                    $value = $null
                }    
            }
            else {
                $value = $object.members.id
            }
        }
        elseif ("directory" -eq $attributeName -and "Users" -eq $type -and "LDAP" -eq $object.source) {
            if ($object.userDN) {                
                $dn = ""
                $dn = $object.userDN
                $dn = $dn.ToLower()
                $index = $dn.IndexOf(",dc=")
                if ($index -ne -1) {
                    $baseContext = $dn.Substring($index + 1)
                    if ($domains) {
                        $value = $domains[$baseContext]
                    }                                        
                }
            }
        }
        elseif (("Safes" -eq $type -or "SafeMembers" -eq $type) -and "safeUrlId" -eq $attributeName) {
            $value = [System.Web.HTTPUtility]::UrlDecode($object.$attributeName)
        }
        else {
            $value = $object.$attributeName
        }
        
        if ($attributeName.EndsWith("Date") -or $attributeName.EndsWith("Time")) {
            if ($null -ne $value) {
                $value = Convert-Date $value
            }
        }

        #get predefined Groups id from groupName
        if ("groupName" -eq $attributeName -and "Groups" -eq $type) {
            if ($predefinedGroupsId.ContainsKey($object.$attributeName)) {
                $groupType = $object.groupType
                if ("Vault" -eq $groupType) {
                    $id = $object.id
                    $predefinedGroupsId[$object.$attributeName] = $id
                }
            }
        }

        #get predefined Users id from groupName
        if ("username" -eq $attributeName -and "Users" -eq $type) {
            if ($predefinedUsersId.ContainsKey($object.$attributeName)) {
                $source = $object.source
                if ("CyberArk" -eq $source) {
                    $id = $object.id
                    $predefinedUsersId[$object.$attributeName] = $id
                }
            }
        }

        if ($value -is [System.Array]) {
            if ($value.Length -gt 0) {
                $value = $value -join ','
            }
            else {
                $value = $null
            }
        }
        $dataObject | Add-Member -MemberType NoteProperty -Name $attributeName -Value $value
    }
    return $dataObject
}

function addPredefinedGroupsMembers {
    param ($safeid)
    $stringBuilder = New-Object -TypeName "System.Text.StringBuilder" 
    $attributes = $headersMap["SafeMembers"]
    $safeid = [System.Web.HTTPUtility]::UrlDecode($safeid)    
    $count = $predefinedGroupsId.Count
    $i = 0
    foreach ($key in $predefinedGroupsId.Keys) {
        $groupId = $predefinedGroupsId[$key]
        $permissions = $predefinedGroupsPermissions[$key]
        $dataObject = New-Object -TypeName psobject	
        $value = $null
        foreach ($attributeName in $attributes) {
            $dataObject | Add-Member -MemberType NoteProperty -Name $attributeName -Value $value
        }
        $dataObject.safeUrlId = $safeid
        $dataObject.safeName = $safeid
        $dataObject.memberId = $groupId
        $dataObject.memberName = $key
        $dataObject.permissions = $permissions
        $dataObject.memberType = "Group"

        $data = ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
        if (($i + 1) -lt $count) {
            $stringBuilder = $stringBuilder.Append($data[1]).AppendLine()
        }
        else {
            $stringBuilder = $stringBuilder.Append($data[1])
        }
        $i++
    }
    $outputPath = $outputPaths["SafeMembers"]
    Write-Log -Message "Writing $($count) Predefined Group Owners to output file $($outputPath)" -Level Debug
    addFileContent $outputPath $stringBuilder
    $stringBuilder = $stringBuilder.Clear()
}

function addPredefinedUsersMembers {
    param ($safeid)
    $stringBuilder = New-Object -TypeName "System.Text.StringBuilder" 
    $attributes = $headersMap["SafeMembers"]
    $safeid = [System.Web.HTTPUtility]::UrlDecode($safeid)    
    $count = $predefinedUsersId.Count
    $i = 0
    foreach ($key in $predefinedUsersId.Keys) {
        $userId = $predefinedUsersId[$key]
        $permissions = $predefinedUsersPermissions[$key]
        $dataObject = New-Object -TypeName psobject	
        $value = $null
        foreach ($attributeName in $attributes) {
            $dataObject | Add-Member -MemberType NoteProperty -Name $attributeName -Value $value
        }
        $dataObject.safeUrlId = $safeid
        $dataObject.safeName = $safeid
        $dataObject.memberId = $userId
        $dataObject.memberName = $key
        $dataObject.permissions = $permissions
        $dataObject.memberType = "User"

        $data = ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
        if (($i + 1) -lt $count) {
            $stringBuilder = $stringBuilder.Append($data[1]).AppendLine()
        }
        else {
            $stringBuilder = $stringBuilder.Append($data[1])
        }
        $i++
    }
    $outputPath = $outputPaths["SafeMembers"]
    Write-Log -Message "Writing $($count) Predefined User Owners to output file $($outputPath)" -Level Debug
    addFileContent $outputPath $stringBuilder
    $stringBuilder = $stringBuilder.Clear()
}
function Get-Sub-Value {
    param ($object, $attributeName)
    $names = $attributeName.Split(".")
    if ($names.Count -gt 0) {
        foreach ($name in $names) {
            $object = $object.$name
            if ($null -eq $object) {
                return $null;
            }
        }
    }
    return $object
}

function  AggregateSafePermissions {
    param ($object)
    $permissionList = @()
    if ($true -eq $object."useAccounts") { $permissionList += "useAccounts" }
    if ($true -eq $object."retrieveAccounts") { $permissionList += "retrieveAccounts" }
    if ($true -eq $object."listAccounts") { $permissionList += "listAccounts" }
    if ($true -eq $object."addAccounts") { $permissionList += "addAccounts" }
    if ($true -eq $object."updateAccountContent") { $permissionList += "updateAccountContent" }
    if ($true -eq $object."updateAccountProperties") { $permissionList += "updateAccountProperties" }
    if ($true -eq $object."initiateCPMAccountManagementOperations") { $permissionList += "initiateCPMAccountManagementOperations" }
    if ($true -eq $object."specifyNextAccountContent") { $permissionList += "specifyNextAccountContent" }
    if ($true -eq $object."renameAccounts") { $permissionList += "renameAccounts" }
    if ($true -eq $object."deleteAccounts") { $permissionList += "deleteAccounts" }
    if ($true -eq $object."unlockAccounts") { $permissionList += "unlockAccounts" }
    if ($true -eq $object."manageSafe") { $permissionList += "manageSafe" }
    if ($true -eq $object."manageSafeMembers") { $permissionList += "manageSafeMembers" }
    if ($true -eq $object."backupSafe") { $permissionList += "backupSafe" }
    if ($true -eq $object."viewAuditLog") { $permissionList += "viewAuditLog" }
    if ($true -eq $object."viewSafeMembers") { $permissionList += "viewSafeMembers" }
    if ($true -eq $object."requestsAuthorizationLevel1") { $permissionList += "requestsAuthorizationLevel1" }
    if ($true -eq $object."requestsAuthorizationLevel2") { $permissionList += "requestsAuthorizationLevel2" }
    if ($true -eq $object."accessWithoutConfirmation") { $permissionList += "accessWithoutConfirmation" }
    if ($true -eq $object."createFolders") { $permissionList += "createFolders" }
    if ($true -eq $object."deleteFolders") { $permissionList += "deleteFolders" }
    if ($true -eq $object."moveAccountsAndFolders") { $permissionList += "moveAccountsAndFolders" }
    if ($true -eq $object."useAccounts") { $permissionList += "useAccounts" }
    $permissionListStr = $permissionList -join ','
    return $permissionListStr
}

function  AggregateSafePermissions_1 {
    param ($object)
    $permissionList = @()
    if ($true -eq $object."RestrictedRetrieve") { $permissionList += "useAccounts" }
    if ($true -eq $object."Retrieve") { $permissionList += "retrieveAccounts" }
    if ($true -eq $object."ListContent") { $permissionList += "listAccounts" }
    if ($true -eq $object."Add") { $permissionList += "addAccounts" }
    if ($true -eq $object."Update") { $permissionList += "updateAccountContent" }
    if ($true -eq $object."UpdateMetadata") { $permissionList += "updateAccountProperties" }
    #if ($true -eq $object."initiateCPMAccountManagementOperations") { $permissionList += "initiateCPMAccountManagementOperations" }
    #if ($true -eq $object."specifyNextAccountContent") { $permissionList += "specifyNextAccountContent" }
    if ($true -eq $object."Rename") { $permissionList += "renameAccounts" }
    if ($true -eq $object."Delete") { $permissionList += "deleteAccounts" }
    if ($true -eq $object."Unlock") { $permissionList += "unlockAccounts" }
    if ($true -eq $object."ManageSafe") { $permissionList += "manageSafe" }
    if ($true -eq $object."ManageSafeMembers") { $permissionList += "manageSafeMembers" }
    if ($true -eq $object."BackupSafe") { $permissionList += "backupSafe" }
    if ($true -eq $object."ViewAudit") { $permissionList += "viewAuditLog" }
    if ($true -eq $object."ViewMembers") { $permissionList += "viewSafeMembers" }
    #if ($true -eq $object."requestsAuthorizationLevel1") { $permissionList += "requestsAuthorizationLevel1" }
    #if ($true -eq $object."requestsAuthorizationLevel2") { $permissionList += "requestsAuthorizationLevel2" }
    #if ($true -eq $object."accessWithoutConfirmation") { $permissionList += "accessWithoutConfirmation" }
    if ($true -eq $object."AddRenameFolder") { $permissionList += "createFolders" }
    if ($true -eq $object."DeleteFolder") { $permissionList += "deleteFolders" }
    if ($true -eq $object."MoveFilesAndFolders") { $permissionList += "moveAccountsAndFolders" }
    $permissionListStr = $permissionList -join ','
    return $permissionListStr
}
function AppendCsvHeaders {
    param ($headers, $path)
    Write-Log -Message "Add CSV Headers to file: $($path)" -Level Debug
    #Add headers
    $dataObject = New-Object -TypeName psobject	
    foreach ($attributeName in $headers) {
        $dataObject | Add-Member -MemberType NoteProperty -Name $attributeName -Value ""
    }
    $data = ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
    Set-Content $data[0] -Path $path -ErrorAction Stop
}

function addFileContent([System.String]$filePath, [System.Text.StringBuilder]$buffer) {
    $streamWriter = New-Object IO.StreamWriter -Arg $filePath, $true, ([System.Text.Encoding]::UTF8) -ErrorAction Stop
    $streamWriter.WriteLine($buffer)
    $streamWriter.Close()	
}

Function extractTerminate() {
    if(($null -ne $evdLogPath) -and (Test-Path $evdLogPath)){
        Remove-Item $evdLogPath -Force | Out-Null
    }
    Set-Location $currentLocation

    # Dump errors in log file if found
    if ($error.count -gt 0) {
        if ($error.count -eq 0) {
            Write-Log -Message  "Terminating with $($error.count) error" -Level Warning
        }
        else {
            Write-Log -Message  "Terminating with $($error.count) errors" -Level Warning
        }
        
        for ($i = $error.Count -1; $i -ge 0; $i--) {
            $err = $error[$i]
            Write-Log -Message $err -Level Error
        }
        		
        $Script:extractCAExitCode = 1
		
    }

    #End datetime
    $datfin = Get-Date
    Write-Log -Message  "End script execution at $($datfin.ToString())" -Level Info
    Write-Log -Message "Total Execution Time:  $($stopwatch.Elapsed)" -Level Info
    Write-Log -Message "Exit with code: $Script:extractCAExitCode" -Level Info
    #Send log file to igrc in connector mode
    exit $Script:extractCAExitCode
}

function readLDAPConfig  {
    $result = @{}
    Write-Log -Message "Loading LDAPConfig from $($hostsFile)..." -Level Debug
    if($LDAPConfigFile){
        $item = Get-Item $LDAPConfigFile
        if($item.Extension -eq ".xml"){
            $profileMap = @{}
            [xml]$xmlElm = Get-Content -Path $LDAPConfigFile
            $profiles = @()
            $profiles += $xmlElm.LDAP.Profiles.Profile
            foreach ($profile in $profiles) {
                $recursiveSearch = 'false'
                if($profile.GroupRecursiveSearch.ToLower() -eq 'yes'){
                    $recursiveSearch = 'true'
                }
                $profileMap.Add($profile.ProfileName,$recursiveSearch)
            }

            $directories = @()
            $directories += $xmlElm.LDAP.Directories.Directory
            foreach ($directory in $directories) {
                $recursiveSearch = $profileMap[$directory.LDAPProfileName]
                $result.Add($directory.DomainName, $recursiveSearch)
                Write-Log -Message "Set groupRecursiveSearch to $($groupRecursiveSearch) for domain $($domainName)" -Level Debug
            }
        }else{
            $configs = Import-Csv -Encoding UTF8 -Delimiter ';' -Path $LDAPConfigFile
            foreach($config in $configs)
            {
                $recursiveSearch = 'false'
                $domainName = $config.domainName
                $groupRecursiveSearch = $config.groupRecursiveSearch
                if($groupRecursiveSearch.ToLower() -eq 'yes'){
                    $recursiveSearch = 'true'
                }
                if($domainName){
                    $result.Add($domainName, $recursiveSearch)
                    Write-Log -Message "Set groupRecursiveSearch to $($recursiveSearch) for domain $($domainName)" -Level Debug
                }
            }    
        }
    }
    return $result
}
function ExtractCA_RestAPI {
    if("RestAPI-only" -ne $mode -and $exportDetails -eq $true){
        Write-Log -Message "Set exportDetails to false, details will be completed using EVD cmd" -Level Info
        $exportDetails = $false
    }
    if("cloud" -eq $environment){
        $apiGen = 2
    }else{
        Write-Log -Message "Retrieving Vault server details..." -Level Info
        if(!$apiGen){
            $apiGen = VaultVersion
            Write-Log -Message "API Gen is: $($apiGen)" -Level Info
        }else{
            VaultVersion
        }    
    }

    # Write-Log -Message "Retrieving LDAPDirectories..." -Level Info
    # $domains = ListLDAPDirectories
    # $domainConfig = readLDAPConfig
    # Write-Log -Message "$($domains.Count) LDAP directory found" -Level Info

    $usersFilePath = Join-Path $outputDirectory ($vaultName + $OUT_Users)
    $usersFile = New-Item $usersFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($usersFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["Users"] $usersFile.FullName
    $outputPaths["Users"] = $usersFile.FullName
    Write-Log -Message "Retrieving Users..." -Level Info
    if($apiGen -eq 1){
        InvokeCARest $URL_Users_Without_Details "Users"
    }else{
        InvokeCARest $URL_Users "Users"
    }    
        
    if("Mixed-mode" -ne $mode){
        $groupsFilePath = Join-Path $outputDirectory ($vaultName + $OUT_UserGroups)
        $groupsFile = New-Item $groupsFilePath -type file -force -ErrorAction Stop
        Write-Log -Message "Creating output file: $($groupsFile.FullName)" -Level Debug
        AppendCsvHeaders $headersMap["Groups"] $groupsFile.FullName
        $outputPaths["Groups"] = $groupsFile.FullName
        Write-Log -Message "Retrieving Groups..." -Level Info
        InvokeCARest $URL_UserGroups "Groups";    
    }

    $accountsFilePath = Join-Path $outputDirectory ($vaultName + $OUT_Accounts)
    $accountsFile = New-Item $accountsFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($accountsFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["Accounts"] $accountsFile.FullName
    $outputPaths["Accounts"] = $accountsFile.FullName
    Write-Log -Message "Retrieving Accounts..." -Level Info
    InvokeCARest $URL_Accounts "Accounts"

    $safesFilePath = Join-Path $outputDirectory ($vaultName + $OUT_Safes)
    $safesFile = New-Item $safesFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($safesFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["Safes"] $safesFile.FullName    
    $outputPaths["Safes"] = $safesFile.FullName
    Write-Log -Message "Retrieving Safes..." -Level Info
    if($apiGen -eq 1){
        InvokeCARest $URL_Safes_Old_Gen "Safes"
    }else{
        InvokeCARest $URL_Safes "Safes"
    }    
   
    if("Mixed-mode" -ne $mode){
        $safeMembersFilePath = Join-Path $outputDirectory ($vaultName + $OUT_SafeMembers)
        $safeMembersFile = New-Item $safeMembersFilePath -type file -force -ErrorAction Stop
        Write-Log -Message "Creating output file: $($safeMembersFile.FullName)" -Level Debug
        AppendCsvHeaders $headersMap["SafeMembers"] $safeMembersFile.FullName
        Write-Log -Message "Retrieving SafeMembers..." -Level Info
        $outputPaths["SafeMembers"] = $safeMembersFile.FullName
        for ($i = 0; $i -lt $safeIDs.Count ; $i++) {
            if($apiGen -eq 1){
                $url = $URL_SafeMembers_Old_Gen -f $safeIDs[$i]
                InvokeCARest $url "SafeMembers" $null $safeIDs[$i]
            }else{
                #addPredefinedUsersMembers $safeIDs[$i]
                #addPredefinedGroupsMembers $safeIDs[$i]            
                $url = $URL_SafeMembers -f $safeIDs[$i]
                InvokeCARest $url "SafeMembers"
            }                        
        }        
    }
    
    $ldapDirectoriesFilePath = Join-Path $outputDirectory ($vaultName + $OUT_LdapMDirectories)
    $ldapDirectoriesFile = New-Item $ldapDirectoriesFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($ldapDirectoriesFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["LdapDirectories"] $ldapDirectoriesFile.FullName
    $outputPaths["LdapDirectories"] = $ldapDirectoriesFile.FullName
    Write-Log -Message "Retrieving LDAP Directories..." -Level Info
    foreach ($bc in $domains.Keys) {
        $domainName = $domains[$bc]
        $isRecursiveSearch = $domainConfig[$domainName]
        if(-not $isRecursiveSearch){
            $isRecursiveSearch = $groupRecursiveSearch
        }
        $commonData = @{groupRecursiveSearch=$isRecursiveSearch}
        $url = $URL_Directory -f $domainName
        InvokeCARest $url "LdapDirectories" $commonData
    }

    $ldapMappingsFilePath = Join-Path $outputDirectory ($vaultName + $OUT_LdapMapping)
    $ldapMappingsFile = New-Item $ldapMappingsFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($ldapMappingsFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["LdapMappings"] $ldapMappingsFile.FullName
    $outputPaths["LdapMappings"] = $ldapMappingsFile.FullName
    Write-Log -Message "Retrieving LDAP Mappings..." -Level Info
    foreach ($bc in $domains.Keys) {
        $domainName = $domains[$bc]
        $commonData = @{domainName=$domainName;domainBaseContext=$bc}
        $url = $URL_LDAP_Mapping -f $domainName
        InvokeCARest $url "LdapMappings" $commonData
    }
}

function EVD_getLdapConfig() {
    $ldapDirectoriesFilePath = Join-Path $outputDirectory ($vaultName + $OUT_LdapMDirectories)
    $ldapDirectoriesFile = New-Item $ldapDirectoriesFilePath -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($ldapDirectoriesFile.FullName)" -Level Debug
    AppendCsvHeaders $headersMap["LdapDirectories"] $ldapDirectoriesFile.FullName
    $outputPaths["LdapDirectories"] = $ldapDirectoriesFile.FullName
    if($LDAPConfigFile){
        $stringBuilder = New-Object -TypeName "System.Text.StringBuilder"
        $domainConfig = readLDAPConfig
        $count = $domainConfig.Count
        $i = 0
        foreach ($domain in $domainConfig.Keys) {
            $dataObject = New-Object -TypeName psobject	
            foreach ($attributeName in $headersMap["LdapDirectories"]) {
                $value = ""
                if($attributeName -eq "domainName"){
                    $value = $domain
                }elseif($attributeName -eq "groupRecursiveSearch"){
                    $value = $domainConfig[$domain]
                }

                $dataObject | Add-Member -MemberType NoteProperty -Name $attributeName -Value $value
            }
            $data = ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
            if (($i + 1) -lt $count) {
                $stringBuilder = $stringBuilder.Append($data[1]).AppendLine()
            }
            else {
                $stringBuilder = $stringBuilder.Append($data[1])
            }
            $i++            
        }
        $outputPath = $outputPaths["LdapDirectories"]
        Write-Log -Message "Writing $($count) entry to output file $($outputPath)" -Level Debug
        addFileContent $outputPath $stringBuilder
        $stringBuilder = $stringBuilder.Clear()
    }
}

function ExtractCA_EVD {
    $safesFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_SafesEVD)
    $safeMembersFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_SafeMembersEVD)
    $usersFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_UsersEVD)
    $groupsFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_UserGroupsEVD)
    $groupsMembersFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_GroupsMembersEVD)
    $accountsFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_AccountsEVD)
    $logsFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_LogsEVD)
    $objectPropertiesFilePathEVD = Join-Path $outputDirectory ($vaultName + $OUT_ObjectsEVD)

    # get ldap config from LDAPConf.xml or csv file (see doc) otherwise create empty output file
    EVD_getLdapConfig
    
    <#
    $safesFileEVD = New-Item $safesFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($safesFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["Safes"] $safesFileEVD.FullName   

    $safeMembersFileEVD = New-Item $safeMembersFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($safeMembersFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["SafeMembers"] $safeMembersFileEVD.FullName   

    $usersFileEVD = New-Item $usersFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($usersFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["Users"] $usersFileEVD.FullName   

    $groupsFileEVD = New-Item $groupsFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($groupsFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["Groups"] $groupsFileEVD.FullName   

    $groupsMembersFileEVD = New-Item $groupsMembersFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($groupsMembersFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["GroupsMembers"] $groupsMembersFileEVD.FullName

    $accountsFileEVD = New-Item $accountsFilePathEVD -type file -force -ErrorAction Stop
    Write-Log -Message "Creating output file: $($accountsFileEVD.FullName)" -Level Debug
    AppendCsvHeaders $headersMapEVD["Accounts"] $accountsFileEVD.FullName
    #>
    
    if($EVD_location){
        if(Test-Path $EVD_location){
            $exePath = Join-Path $EVD_location "ExportVaultData.exe"
            if(Test-Path $exePath){
                if(-not $EVD_config){
                    Write-Log "Using default config 'Vault.ini' in $(EVD_config)" -Level Info            
                    $EVD_configLocation = Join-Path $EVD_location "Vault.ini"
                }else{
                    $EVD_configLocation = Join-Path $EVD_location $EVD_config
                }                
                if(Test-Path($EVD_configLocation)){
                    Set-Location $EVD_location
                    if(-not $EVD_cred){
                        Write-Log "Using default cred 'user.ini' in $(EVD_config)" -Level Info            
                        $EVD_credLocation = Join-Path $EVD_location "user.ini"
                    }else{
                        $EVD_credLocation = Join-Path $EVD_location $EVD_cred
                    }
    
                    if(Test-Path $EVD_credLocation){
                        $guid = New-Guid
                        $evdLogFileName = "$($guid.Guid).txt"
                        $script:evdLogPath = Join-Path $EVD_location $evdLogFileName
                        #New-Item $evdLogPath -ItemType File -Force | Out-Null
                        #$cmdOutput = (cmd /c "$($credExePath)" "$($credPath)" password /username $($userName) /password $($userPass) '2>&1') -join "`r`n"
                        Write-Log -Message "Retrieving data using EVD..." -Level Info
        
                        #$cmdOutput = (& .\ExportVaultData.exe $cmdArgList 2>&1) -join "`r`n"
                        #& .\ExportVaultData.exe \VaultFile="Vault.ini" \CredFile="evd.cred" \Target=File \UsersList="C:\Applications\UsersList_444.csv" \Separator=";"
                        if("Mixed-mode" -eq $mode){
                            $cmdOutput = (& .\ExportVaultData.exe `
                            \VaultFile="$EVD_config" `
                            \CredFile="$EVD_cred" `
                            \Target=File `
                            \Logfile="$evdLogFileName" `
                            \SafesList="$($safesFilePathEVD)" `
                            \UsersList="$($usersFilePathEVD)" `
                            \GroupsList="$($groupsFilePathEVD)" `
                            \GroupMembersList="$($groupsMembersFilePathEVD)" `
                            \ObjectProperties="$($objectPropertiesFilePathEVD)" `
                            \OwnersList="$($safeMembersFilePathEVD)" `
                            \LogList="$($logsFilePathEVD)" `
                            \LogNumOfDays="$($logNumOfDays)" `
                            \Separator=";" 2>&1) -join "`r`n"
                        }else{
                            $cmdOutput = (& .\ExportVaultData.exe `
                            \VaultFile="$EVD_config" `
                            \CredFile="$EVD_cred" `
                            \Target=File `
                            \Logfile="$evdLogFileName" `
                            \UsersList="$($usersFilePathEVD)" `
                            \SafesList="$($safesFilePathEVD)" `
                            \GroupsList="$($groupsFilePathEVD)" `
                            \GroupMembersList="$($groupsMembersFilePathEVD)" `
                            \FilesList="$($accountsFilePathEVD)" `
                            \ObjectProperties="$($objectPropertiesFilePathEVD)" `
                            \OwnersList="$($safeMembersFilePathEVD)" `
                            \LogList="$($logsFilePathEVD)" `
                            \LogNumOfDays="$($logNumOfDays)" `
                            \Separator=";" 2>&1) -join "`r`n"
                        }
                        if($cmdOutput){
                            Write-Log -Message "$($cmdOutput)" -Level Info
                        }
                        $evdLogs = Get-Content $evdLogFileName
                        if($evdLogs){
                            $lastLogLine = $evdLogs[$evdLogs.Length - 1]
                            if(-not $lastLogLine.EndsWith("ExportVaultData Utility ended successfully.")){
                                foreach ($item in $evdLogs) {
                                    Write-Log -Message "$($item)" -Level Warning
                                }
                                Write-Error 'EVD data export failed'
                            }else{
                                foreach ($item in $evdLogs) {
                                    Write-Log -Message "$($item)" -Level Info
                                }
                            }
                        }
                    }else{
                        Write-Error "EVD Cred file $($EVD_credLocation) not found"
                    }
                }else{
                    Write-Error "EVD config file $($EVD_configLocation) not found"
                }
            }else{
                Write-Error "ExportVaultData.exe $($EVD_location) not found"
            }
        }else{
            Write-Error "EVD location $($EVD_location) not found"
        }
    }else {
        Write-Log "EVD is disabled" -Level Info
    }
}

function WriteExportMode {
    $exportModeFile = Join-Path $outputDirectory ($vaultName + "_export-mode.csv")
    $datetimeConfig = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International"
    $LocaleName = $datetimeConfig.LocaleName
    $sShortDate = $datetimeConfig.sShortDate
    $sTimeFormat = $datetimeConfig.sTimeFormat
    $dateTimeFormat = "$($sShortDate) $($sTimeFormat.replace("tt","a"))"
    Write-Log -Message "LocaleName is '$($LocaleName)'" -Level Info
    Write-Log -Message "ShortDate is '$($sShortDate)'" -Level Info
    Write-Log -Message "TimeFormat is '$($sTimeFormat)'" -Level Info
    Write-Log -Message "DateTimeFormat is '$($dateTimeFormat)'" -Level Info
    $props = @{}
    $props.Add("export-mode", $mode);
    $props.Add("date-format", $dateTimeFormat);
    $props.Add("api_external_version", $script:_ExternalVersion);
    $props.Add("api_internal_version", $script:_InternalVersion);
    $props.Add("api_vault_name", $script:_vault_name);
    $props.Add("script_vault_name", $vaultName);
    $entry = New-Object -TypeName psobject -Property $props
    $entry | Export-Csv -Path $exportModeFile -NoTypeInformation -Encoding UTF8 -Delimiter ';'    
}
############################################################ MAIN FUNCTION ##################################################

function extractInit {
$script:currentLocation = Get-Location
# Script starting time
$startTime = Get-Date
$log_sufix = Get-Date -Format "ddMMyyyy_HHmmss"
$script:stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
# Dump script params if logLevel is debug 
$params = dumpScriptParameters
$scriptParamLog = "Executing script with parameters: $($params)"

#Calculate execution directory
$scriptDir =  (Get-Location).Path
if ($outputDirectory) {
    $dir = Get-Item -Path $outputDirectory
    $script:outputDirectory = $dir.FullName
}
else {
    $script:outputDirectory = $scriptDir
}

# Script return code 
[int] $Script:extractCAExitCode = 0

# Calculate log file name
#$current_time = $startTime.Year.ToString() + $startTime.Month.ToString() + $startTime.Day.ToString() + $startTime.Hour.ToString() + $startTime.Minute.ToString() + $startTime.Second.ToString() + $startTime.Millisecond.ToString()	
$Script:__logfile__ = "ExtractCA_" + $log_sufix + ".log"
if (!$connectorMode) {
    if ($logDirectory) {
        $dir = Get-Item -Path $logDirectory
        $logDirectory = $dir.FullName
        $Script:__logfile__ = Join-Path $logDirectory $__logfile__
    }
    else {
        $Script:__logfile__ = Join-Path $scriptDir $__logfile__
    }
}
Write-Log -Message "Log file location is : $($__logfile__)" -Level Info
Write-Log "Starting ExtractCA at $($startTime)" -Level Info
Write-Log -Message "$($scriptParamLog)" -Level Debug

if("RestAPI-only" -eq $mode -or "Mixed-mode" -eq $mode){
    if (-not $skipCertificateCheck) {
        if (-not ([System.Management.Automation.PSTypeName]'TrustAllCertsPolicy').Type) {
$certCallback = @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem) {
    return true;
}
}
"@
            Add-Type $certCallback
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        }    
    }
    $Script:token = GetToken
    Write-Log -Level Debug -Message $token
    if ($null -eq $token -or "" -eq $token) {
        Write-Error "No valid token returned" -ErrorAction Stop
    }
    
    $Script:logonHeader = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    if("cloud" -eq $environment){
        Write-Log -Message "Using CyberArk Cloud API" -Level Info
        $Script:logonHeader.Add("Authorization", "Bearer $($token)")
    }else{
        $Script:logonHeader.Add("Authorization", $token)
    }
    $Script:logonHeader.Add("Content-Type", "application/json")
    
    $Script:throttlingCode = 429
    $Script:tokenExpiredCodes = @{"PASWS006E" = "PASWS006E"; <#"CAWS00001E" = "CAWS00001E";#> "CASSM005E" = "CASSM005E"; "CASTM006E" = "CASTM006E" }
    $Script:safeIDs = New-Object -TypeName "System.Collections.ArrayList"
    
}

# Map containing filepath for eatch object type
$Script:outputPaths = @{}
# Map containing LDAP integration domains
$Script:domains = @{}

if($null -eq $vaultName -or "" -eq $vaultName){
    Write-Error "vaultName is mandatory" -ErrorAction Stop
}

if($LDAPConfigFile){
    $item = Get-Item $LDAPConfigFile
    if($item){
        if( -not($item.Exists)){
            Write-Error "LDAP config file '$($LDAPConfigFile)' not found" -ErrorAction Stop
        }elseif ($item.PSIsContainer) {
            Write-Error "LDAP config should be a file '$($LDAPConfigFile)'" -ErrorAction Stop
        }elseif (-not($item.Extension -eq ".csv") -and -not($item.Extension -eq ".xml")) {
            Write-Error "LDAP config should be an XML or CSV file '$($LDAPConfigFile)'" -ErrorAction Stop
        }elseif ($item.Extension -eq ".csv") {
            $configs = Import-Csv -Encoding UTF8 -Delimiter ';' -Path $LDAPConfigFile
            if($configs){
                $headers = ($configs | Get-Member -MemberType NoteProperty).Name
                if(-not $headers.Contains('groupRecursiveSearch') -or  -not $headers.Contains('domainName')){
                    Write-Error "LDAP CSV config file should have should 'groupRecursiveSearch' and 'domainName' in header '$($LDAPConfigFile)'" -ErrorAction Stop
                }    
            }else{
                Write-Error "LDAP config file '$($LDAPConfigFile)' is empty" -ErrorAction Stop        
            }
        }elseif ($item.Extension -eq ".xml") {
            [xml]$xmlElm = Get-Content -Path $LDAPConfigFile
            if(-not $xmlElm -or -not $xmlElm.LDAP){
                Write-Error "'$($LDAPConfigFile)' file is not a valid CyberARk XML file" -ErrorAction Stop                
            }
        }
    }else{
        Write-Error "LDAP config file '$($LDAPConfigFile)' not found" -ErrorAction Stop
    }            
}
    
}
############################################################ MAIN SCRIPT ###################################################
# Clear errors befor starting script
$error.Clear()

# Set script ErrorActionPreference
$ErrorActionPreference = $errAction
$script:users_cache = @{}
$script:groups_cache = @{}
$script:safes_cache = @{}

$script:_vault_name = ""
$script:_ExternalVersion = ""
$script:_InternalVersion = ""
try {
    extractInit    
}
catch {
    if("RestAPI-only" -eq $mode -or "Mixed-mode" -eq $mode){
        if($null -ne $token){
            LogOff
        }
    }
    extractTerminate
}

if ($errAction -eq "Stop") {
    #dump exception in finally block
    try {
        if("RestAPI-only" -eq $mode){
            ExtractCA_RestAPI
        }elseif ("EVD-only" -eq $mode) {
            ExtractCA_EVD    
        }else {
            ExtractCA_RestAPI
            ExtractCA_EVD                
        }
        WriteExportMode
    }
    finally { 
        if("RestAPI-only" -eq $mode -or "Mixed-mode" -eq $mode){
            if($null -ne $token){
                LogOff
            }
        }
        extractTerminate
    }
}
else {
    if("RestAPI-only" -eq $mode){
        ExtractCA_RestAPI
    }elseif ("EVD-only" -eq $mode) {
        ExtractCA_EVD    
    }else {
        ExtractCA_RestAPI
        ExtractCA_EVD                
    }
    WriteExportMode
    if("RestAPI-only" -eq $mode -or "Mixed-mode" -eq $mode){
        if($null -ne $token){
            LogOff
        }
    }
    extractTerminate
}

# SIG # Begin signature block
# MIIuuQYJKoZIhvcNAQcCoIIuqjCCLqYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCVcVmiIxanrrTh
# GdQ1K259Z4gUO2YmQWFwhYqQKp6RuaCCFCQwggVyMIIDWqADAgECAhB2U/6sdUZI
# k/Xl10pIOk74MA0GCSqGSIb3DQEBDAUAMFMxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQDEyBHbG9iYWxTaWduIENvZGUgU2ln
# bmluZyBSb290IFI0NTAeFw0yMDAzMTgwMDAwMDBaFw00NTAzMTgwMDAwMDBaMFMx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQD
# EyBHbG9iYWxTaWduIENvZGUgU2lnbmluZyBSb290IFI0NTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBALYtxTDdeuirkD0DcrA6S5kWYbLl/6VnHTcc5X7s
# k4OqhPWjQ5uYRYq4Y1ddmwCIBCXp+GiSS4LYS8lKA/Oof2qPimEnvaFE0P31PyLC
# o0+RjbMFsiiCkV37WYgFC5cGwpj4LKczJO5QOkHM8KCwex1N0qhYOJbp3/kbkbuL
# ECzSx0Mdogl0oYCve+YzCgxZa4689Ktal3t/rlX7hPCA/oRM1+K6vcR1oW+9YRB0
# RLKYB+J0q/9o3GwmPukf5eAEh60w0wyNA3xVuBZwXCR4ICXrZ2eIq7pONJhrcBHe
# OMrUvqHAnOHfHgIB2DvhZ0OEts/8dLcvhKO/ugk3PWdssUVcGWGrQYP1rB3rdw1G
# R3POv72Vle2dK4gQ/vpY6KdX4bPPqFrpByWbEsSegHI9k9yMlN87ROYmgPzSwwPw
# jAzSRdYu54+YnuYE7kJuZ35CFnFi5wT5YMZkobacgSFOK8ZtaJSGxpl0c2cxepHy
# 1Ix5bnymu35Gb03FhRIrz5oiRAiohTfOB2FXBhcSJMDEMXOhmDVXR34QOkXZLaRR
# kJipoAc3xGUaqhxrFnf3p5fsPxkwmW8x++pAsufSxPrJ0PBQdnRZ+o1tFzK++Ol+
# A/Tnh3Wa1EqRLIUDEwIrQoDyiWo2z8hMoM6e+MuNrRan097VmxinxpI68YJj8S4O
# JGTfAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0G
# A1UdDgQWBBQfAL9GgAr8eDm3pbRD2VZQu86WOzANBgkqhkiG9w0BAQwFAAOCAgEA
# Xiu6dJc0RF92SChAhJPuAW7pobPWgCXme+S8CZE9D/x2rdfUMCC7j2DQkdYc8pzv
# eBorlDICwSSWUlIC0PPR/PKbOW6Z4R+OQ0F9mh5byV2ahPwm5ofzdHImraQb2T07
# alKgPAkeLx57szO0Rcf3rLGvk2Ctdq64shV464Nq6//bRqsk5e4C+pAfWcAvXda3
# XaRcELdyU/hBTsz6eBolSsr+hWJDYcO0N6qB0vTWOg+9jVl+MEfeK2vnIVAzX9Rn
# m9S4Z588J5kD/4VDjnMSyiDN6GHVsWbcF9Y5bQ/bzyM3oYKJThxrP9agzaoHnT5C
# JqrXDO76R78aUn7RdYHTyYpiF21PiKAhoCY+r23ZYjAf6Zgorm6N1Y5McmaTgI0q
# 41XHYGeQQlZcIlEPs9xOOe5N3dkdeBBUO27Ql28DtR6yI3PGErKaZND8lYUkqP/f
# obDckUCu3wkzq7ndkrfxzJF0O2nrZ5cbkL/nx6BvcbtXv7ePWu16QGoWzYCELS/h
# AtQklEOzFfwMKxv9cW/8y7x1Fzpeg9LJsy8b1ZyNf1T+fn7kVqOHp53hWVKUQY9t
# W76GlZr/GnbdQNJRSnC0HzNjI3c/7CceWeQIh+00gkoPP/6gHcH1Z3NFhnj0qinp
# J4fGGdvGExTDOUmHTaCX4GUT9Z13Vunas1jHOvLAzYIwggboMIIE0KADAgECAhB3
# vQ4Ft1kLth1HYVMeP3XtMA0GCSqGSIb3DQEBCwUAMFMxCzAJBgNVBAYTAkJFMRkw
# FwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQDEyBHbG9iYWxTaWduIENv
# ZGUgU2lnbmluZyBSb290IFI0NTAeFw0yMDA3MjgwMDAwMDBaFw0zMDA3MjgwMDAw
# MDBaMFwxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTIw
# MAYDVQQDEylHbG9iYWxTaWduIEdDQyBSNDUgRVYgQ29kZVNpZ25pbmcgQ0EgMjAy
# MDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMsg75ceuQEyQ6BbqYoj
# /SBerjgSi8os1P9B2BpV1BlTt/2jF+d6OVzA984Ro/ml7QH6tbqT76+T3PjisxlM
# g7BKRFAEeIQQaqTWlpCOgfh8qy+1o1cz0lh7lA5tD6WRJiqzg09ysYp7ZJLQ8LRV
# X5YLEeWatSyyEc8lG31RK5gfSaNf+BOeNbgDAtqkEy+FSu/EL3AOwdTMMxLsvUCV
# 0xHK5s2zBZzIU+tS13hMUQGSgt4T8weOdLqEgJ/SpBUO6K/r94n233Hw0b6nskEz
# IHXMsdXtHQcZxOsmd/KrbReTSam35sOQnMa47MzJe5pexcUkk2NvfhCLYc+YVaMk
# oog28vmfvpMusgafJsAMAVYS4bKKnw4e3JiLLs/a4ok0ph8moKiueG3soYgVPMLq
# 7rfYrWGlr3A2onmO3A1zwPHkLKuU7FgGOTZI1jta6CLOdA6vLPEV2tG0leis1Ult
# 5a/dm2tjIF2OfjuyQ9hiOpTlzbSYszcZJBJyc6sEsAnchebUIgTvQCodLm3HadNu
# twFsDeCXpxbmJouI9wNEhl9iZ0y1pzeoVdwDNoxuz202JvEOj7A9ccDhMqeC5LYy
# AjIwfLWTyCH9PIjmaWP47nXJi8Kr77o6/elev7YR8b7wPcoyPm593g9+m5XEEofn
# GrhO7izB36Fl6CSDySrC/blTAgMBAAGjggGtMIIBqTAOBgNVHQ8BAf8EBAMCAYYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4E
# FgQUJZ3Q/FkJhmPF7POxEztXHAOSNhEwHwYDVR0jBBgwFoAUHwC/RoAK/Hg5t6W0
# Q9lWULvOljswgZMGCCsGAQUFBwEBBIGGMIGDMDkGCCsGAQUFBzABhi1odHRwOi8v
# b2NzcC5nbG9iYWxzaWduLmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUwRgYIKwYBBQUH
# MAKGOmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2NvZGVzaWdu
# aW5ncm9vdHI0NS5jcnQwQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2NybC5nbG9i
# YWxzaWduLmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUuY3JsMFUGA1UdIAROMEwwQQYJ
# KwYBBAGgMgECMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24u
# Y29tL3JlcG9zaXRvcnkvMAcGBWeBDAEDMA0GCSqGSIb3DQEBCwUAA4ICAQAldaAJ
# yTm6t6E5iS8Yn6vW6x1L6JR8DQdomxyd73G2F2prAk+zP4ZFh8xlm0zjWAYCImbV
# YQLFY4/UovG2XiULd5bpzXFAM4gp7O7zom28TbU+BkvJczPKCBQtPUzosLp1pnQt
# pFg6bBNJ+KUVChSWhbFqaDQlQq+WVvQQ+iR98StywRbha+vmqZjHPlr00Bid/XSX
# hndGKj0jfShziq7vKxuav2xTpxSePIdxwF6OyPvTKpIz6ldNXgdeysEYrIEtGiH6
# bs+XYXvfcXo6ymP31TBENzL+u0OF3Lr8psozGSt3bdvLBfB+X3Uuora/Nao2Y8nO
# ZNm9/Lws80lWAMgSK8YnuzevV+/Ezx4pxPTiLc4qYc9X7fUKQOL1GNYe6ZAvytOH
# X5OKSBoRHeU3hZ8uZmKaXoFOlaxVV0PcU4slfjxhD4oLuvU/pteO9wRWXiG7n9dq
# cYC/lt5yA9jYIivzJxZPOOhRQAyuku++PX33gMZMNleElaeEFUgwDlInCI2Oor0i
# xxnJpsoOqHo222q6YV8RJJWk4o5o7hmpSZle0LQ0vdb5QMcQlzFSOTUpEYck08T7
# qWPLd0jV+mL8JOAEek7Q5G7ezp44UCb0IXFl1wkl1MkHAHq4x/N36MXU4lXQ0x72
# f1LiSY25EXIMiEQmM2YBRN/kMw4h3mKJSAfa9TCCB74wggWmoAMCAQICDH3c45Ec
# 8UeqeTXXLTANBgkqhkiG9w0BAQsFADBcMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
# R2xvYmFsU2lnbiBudi1zYTEyMDAGA1UEAxMpR2xvYmFsU2lnbiBHQ0MgUjQ1IEVW
# IENvZGVTaWduaW5nIENBIDIwMjAwHhcNMjIwMjIzMTMyMTA2WhcNMjUwMjIzMTMy
# MTA2WjCCAQExHTAbBgNVBA8MFFByaXZhdGUgT3JnYW5pemF0aW9uMRQwEgYDVQQF
# Ews1MTkgODQ3IDM2MjETMBEGCysGAQQBgjc8AgEDEwJGUjELMAkGA1UEBhMCRlIx
# FzAVBgNVBAgTDkhhdXRzLWRlLVNlaW5lMRwwGgYDVQQHDBNBc25pw6hyZXMtc3Vy
# LVNlaW5lMRwwGgYDVQQJDBMzOC00MiBSVUUgR0FMTEnDiU5JMRYwFAYDVQQKEw1C
# UkFJTldBVkUgU0FTMRYwFAYDVQQDEw1CUkFJTldBVkUgU0FTMSMwIQYJKoZIhvcN
# AQkBFhRzdXBwb3J0QGJyYWlud2F2ZS5mcjCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAM04Nf6HuUkESNIz510LhuqN6eFqpl5LNjLrR9hmTvN5r5l+qPXe
# XYhcgrxoIh7NUqfheC7NRa88OZkewvUpm1SZTSHOZTSQ9OiEDYEiByvucWjiZvz0
# XQL/w14gHoIPLEsjkYLZbphCbc0bna2Y23oB8T3alNXm3zqmY3YksJ3K56uBukmG
# ByeFZC5bEX/D5esRXiyQb1NqaVBG1XHQMTNYOyAZob5A3S6UiznM9hFL7CwAHOuN
# d7bPbqQ7CjPTF9gU/WAh8jj8eSU44pT1gYTaKc4pHApBUfkveeKFi1cAjU/HQAN2
# E6zh/F54DHuTuGrUue7S2dox4puNiUXsPnswm6j0LYw1g9g16DWx9DZrBjy2klD+
# SlO+AErXIMmWdKDzX7swDtOs2l9j3Y2+JntB/hT50mQbsnC7gZb+6UiVU/o+StHK
# cINtFBRbW+RReuxZDi/NjB9xkHfbjrq/P3G/sAgQC8u1yE3f8Z0podoh1/bmH32H
# Y97n+rBUQAuYWhVqCO++RLgREYTHmLxv2YRvABh3xqM9nCCRGo7avPZLUmlqlaQR
# Ag8+etUY54iWegoUmKfMQeV3fKZz3hFaHqYGE+fmlIHmpYdkumPFjmN84Rqp5ZSE
# QN0VVD8JKM3XKOGx4FrYNNjB7IAvEWLX/kX0PY7eGROM+PkNtR7X/gtpAgMBAAGj
# ggHXMIIB0zAOBgNVHQ8BAf8EBAMCB4AwgZ8GCCsGAQUFBwEBBIGSMIGPMEwGCCsG
# AQUFBzAChkBodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2dj
# Y3I0NWV2Y29kZXNpZ25jYTIwMjAuY3J0MD8GCCsGAQUFBzABhjNodHRwOi8vb2Nz
# cC5nbG9iYWxzaWduLmNvbS9nc2djY3I0NWV2Y29kZXNpZ25jYTIwMjAwVQYDVR0g
# BE4wTDBBBgkrBgEEAaAyAQIwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
# YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wBwYFZ4EMAQMwCQYDVR0TBAIwADBHBgNV
# HR8EQDA+MDygOqA4hjZodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjQ1
# ZXZjb2Rlc2lnbmNhMjAyMC5jcmwwHwYDVR0RBBgwFoEUc3VwcG9ydEBicmFpbndh
# dmUuZnIwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHwYDVR0jBBgwFoAUJZ3Q/FkJhmPF
# 7POxEztXHAOSNhEwHQYDVR0OBBYEFEamHA4GMDb6LSGi+YBEfIEWFTnDMA0GCSqG
# SIb3DQEBCwUAA4ICAQCgItZUejsULOrm0WlsPeuajBU+0CPcIl/x2BvwSHgkNsmg
# NvSbfxVAh+kVZtawksK2gv6yfKrxqpJvDxUeju86UE6oJ9bYjq7b8pgeJERbawYj
# 7Xb/7SsR9Pr2hLo1OtOiJLNlZY+VFJTuSI0Sj+PlmNLzVpHFWCIErIEoChY8+igf
# i2NLPRBx7LdHt6HK7ntbDookSW9O0GAK2eMsJU8xwFnuPN0I7zrzr167txP2aAu/
# zPclfgDdxYFU5OsZM42KaUUSbrGDoruEXweaPhi+MYi5FKRUMgPrv9AlZEpvZFx6
# IolSQ0owTMvJp7vod6bUfQrwsfX7uxki3hT8fO5bKp11ldZH2lfnJM1LzbPYxqFp
# bAl9NQfC/nNjKg0OY6k475bhv/0G4krcRvWZrEKFQ9d/4OQfKaZtHXbzLzx8Wins
# 9AuPyDsoX4YfclqlJ3K8YQtNmq0i5ICnh1272TKAtOMEoNA0OblDXM5suYGpr7BC
# brFwEKDQOaitYC1cWT7YyzkWfezJEcVtmIkrLIGT/IPMU0LNMCUFwPe+Wb6lTju0
# s5jMvIajPfQ8sgn2ckZxfqtjwcsje/qhLZNmPxBUfw9bY+R2PyOXDJRPLg+zoHej
# KtvPMPqhEzVc0sx6ODQzAmxhxwojsBxchuMdwDoTLnSYfNNC+6t4wXvYf42o8TGC
# GeswghnnAgEBMGwwXDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24g
# bnYtc2ExMjAwBgNVBAMTKUdsb2JhbFNpZ24gR0NDIFI0NSBFViBDb2RlU2lnbmlu
# ZyBDQSAyMDIwAgx93OORHPFHqnk11y0wDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg7D9E
# ilxRv99YIWtYAeME9D5KYNw1MJljGbfAw+IRZDAwDQYJKoZIhvcNAQEBBQAEggIA
# L6fYPOJDVteXpsUOpcwUPROPKdsu1TjE93gZxkp1POz5jxLxCaLpgORvC6wfbmGx
# W1ZKtXK19Xh0TjVJyyck9ZtBNhgFeF6fKsMhjG2bY3WfNu+ByyU/UyRTQHKVrwOe
# vPI/rRyleDadbfHc+Mtt1aIyvsLy5n7VxSeJv9ARZUJWEMNuvKAJq65yB8kZZ9em
# 7Pan3m6K+WkxRvG/jvZTNEx0IAzTMEcQO7sDILQACjhEy6Tex5vnRShxF4hiR3Zy
# b9d7592mTkevG6UOCgW6IzpUgkvlbyVdJzS4+yB5PhXtIj3Szq+FJaCAahArSeXQ
# Q2oEFts5grnj3Q79q1BTtl7E8iKab4v1r/g0gn27vzqf7wIFKMXX7XZFL6OHgLh6
# /MibneSR8ZwpjLVLUJNYdYJwcfTEcTlsSoKBKEAY2L4jrkNcNE+vpxhklUJKQb8j
# AaahnkSchA67CFoHgdb9YfNWnWjLJPkVVMcfX35rKb9RHY6LFDZYeAyCQDVwqquI
# oJiaU7HMwIRM45xzawpgUho5nL1IX7lI3a7B2yYY+jzW0tgWdOawMFUb4NVfZdQc
# dAthStcy971DGUCkcH81s8DFY/hPG6WYSZYG94Ci5/hzPWjTQOfEB0+tkE0i3VVY
# JEKzn8GabItrm9UjSlqq2j/shqrxiQjGsJ6rTARp1VqhghbJMIIWxQYKKwYBBAGC
# NwMDATGCFrUwghaxBgkqhkiG9w0BBwKgghaiMIIWngIBAzENMAsGCWCGSAFlAwQC
# ATCB5QYLKoZIhvcNAQkQAQSggdUEgdIwgc8CAQEGCSsGAQQBoDICAzAxMA0GCWCG
# SAFlAwQCAQUABCCEL8/Bgy8WwSfWzx7+rmjz2Ae/nEu1vv12OKFF9HJBvwIURXJE
# 3+eE7RcT/DpKMblY3JzRffQYDzIwMjQxMjA2MTMzMzQxWjADAgEBoGCkXjBcMQsw
# CQYDVQQGEwJCRTEZMBcGA1UECgwQR2xvYmFsU2lnbiBudi1zYTEyMDAGA1UEAwwp
# R2xvYmFsc2lnbiBUU0EgZm9yIEFkdmFuY2VkIC0gRzQgLSAyMDIzMTGgghJTMIIG
# azCCBFOgAwIBAgIQARl1dHHJktdE36WW67lwFTANBgkqhkiG9w0BAQsFADBbMQsw
# CQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMo
# R2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBTSEEzODQgLSBHNDAeFw0yMzEx
# MDIxMDMwMDJaFw0zNDEyMDQxMDMwMDJaMFwxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# DBBHbG9iYWxTaWduIG52LXNhMTIwMAYDVQQDDClHbG9iYWxzaWduIFRTQSBmb3Ig
# QWR2YW5jZWQgLSBHNCAtIDIwMjMxMTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCC
# AYoCggGBALI1RnSqg43Vlqc8SNXFyqjfVL4Iq6HfXOlJ0GBetaUa90NYQ5c89Gdj
# CDI8GX8r2VVG1dSMwFzPpMWlGrqnK84mQiE85buho5XdYOoSVa7vztwyhO2jteA/
# c9E1uJu7xUTd4bjr81mtifZxj1oK+gqSBYQNlwG/Bbv8WAGzjcnUBYWnkCturNPZ
# TtqnJDWWb6qzoEE74PnnEY7VZgKALT3Mzx6klosXgNxMORokdSzFdxbZkYMmf+cT
# i6JFVOa2Snfn0i0u57A8SNnGjft69Cu8piJIotferXhHiAxfm/SRSgYc+gOealYe
# KzDj845ZsLQfHmE4hnn5g4OUjwkwQjO0DreIghgtP9eBiyegafHTBa7GRaPCH5ut
# 6cDIT9fnxqdBMmj/WcpUXPu/2R8W8FLSz7g1laWRzqMd9XZSmOyRYYsJoa2Zmeis
# lCiXOIwJrjyc+H5RojdqyHG6HU8NJgFWflfDdULYU+BjY91+nh2oYujO/plZU/bz
# AIr9k5XP0QIDAQABo4IBqDCCAaQwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQM
# MAoGCCsGAQUFBwMIMB0GA1UdDgQWBBTEvu6HPIl0Dt6z7hkbhQzOQU5/nTBWBgNV
# HSAETzBNMAgGBmeBDAEEAjBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0
# cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/BAIw
# ADCBkAYIKwYBBQUHAQEEgYMwgYAwOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLmds
# b2JhbHNpZ24uY29tL2NhL2dzdHNhY2FzaGEzODRnNDBDBggrBgEFBQcwAoY3aHR0
# cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3N0c2FjYXNoYTM4NGc0
# LmNydDAfBgNVHSMEGDAWgBTqFsZp5+PLV0U5M6TwQL7Qw71lljBBBgNVHR8EOjA4
# MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dzdHNhY2FzaGEz
# ODRnNC5jcmwwDQYJKoZIhvcNAQELBQADggIBALMy0epn/9vfp7Q3RF3tHr52I8nO
# A+1N1GrnM4w8XyBi2+7pbDg55Zlx+yaRHyexc1wDGc9oMtDV5nZ4Sqo8lzLSFe56
# HDI8YKdByrk+8UHqw9Pxx+W+3hrGwY4i39aA5Y/yrLIhjXi2xImMlL0yc7jYl0Q8
# 12ZsDRwQXF6oiEC9oK5OWi1kTwYlpYTGOHDHVHMUjVcWqTAcqAlJ36UBBgO/E7N0
# lJsHga8NQZBVKbBgqVT6OCAzzgm6DkxnWIGGqe2IhqmY47blRpckR2xI0RBqynGy
# Pl3DPS0hgmuDY2+XwJH++32WuarAHM2lrZB4gNZ9bYkqQI6sJfrriDYjfoby+7UG
# 7SiDLLPamnpvSBEWlDa1RUCdgTUNxbGMmzvmPOl6GFD5OYqSd7uRIm6guVsqAUAo
# 5NFIqTCOooYSN03JWZnHpgN/4ZEKfQr4C0IOca72z7rlMfj5Hy3w4AqMhIylOaM7
# sPM22UPVm5gkD9DC4yY+reH7+x6r3gb2+2hB7DHfqckejBn2PvYemC7RYIFbJnT0
# VE5ABN+1XtT37vANh29AQKdp6ijIoalPdxKJMWrpmoN3i6nFRDPut2lOLLSntJV4
# m9aqQCw2GqdEQ7NS2GDGc1e/fNY10yOjYEIi1hYVzhMa6c715c9avqw/c+n6c78Z
# zaKXZsocYA2ivVTMMIIGWTCCBEGgAwIBAgINAewckkDe/S5AXXxHdDANBgkqhkiG
# 9w0BAQwFADBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEG
# A1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjAeFw0xODA2MjAw
# MDAwMDBaFw0zNDEyMTAwMDAwMDBaMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBH
# bG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIFRpbWVzdGFtcGlu
# ZyBDQSAtIFNIQTM4NCAtIEc0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEA8ALiMCP64BvhmnSzr3WDX6lHUsdhOmN8OSN5bXT8MeR0EhmW+s4nYluuB4on
# 7lejxDXtszTHrMMM64BmbdEoSsEsu7lw8nKujPeZWl12rr9EqHxBJI6PusVP/zZB
# q6ct/XhOQ4j+kxkX2e4xz7yKO25qxIjw7pf23PMYoEuZHA6HpybhiMmg5ZninvSc
# TD9dW+y279Jlz0ULVD2xVFMHi5luuFSZiqgxkjvyen38DljfgWrhsGweZYIq1CHH
# lP5CljvxC7F/f0aYDoc9emXr0VapLr37WD21hfpTmU1bdO1yS6INgjcZDNCr6lrB
# 7w/Vmbk/9E818ZwP0zcTUtklNO2W7/hn6gi+j0l6/5Cx1PcpFdf5DV3Wh0MedMRw
# KLSAe70qm7uE4Q6sbw25tfZtVv6KHQk+JA5nJsf8sg2glLCylMx75mf+pliy1NhB
# EsFV/W6RxbuxTAhLntRCBm8bGNU26mSuzv31BebiZtAOBSGssREGIxnk+wU0ROoI
# rp1JZxGLguWtWoanZv0zAwHemSX5cW7pnF0CTGA8zwKPAf1y7pLxpxLeQhJN7Kkm
# 5XcCrA5XDAnRYZ4miPzIsk3bZPBFn7rBP1Sj2HYClWxqjcoiXPYMBOMp+kuwHNM3
# dITZHWarNHOPHn18XpbWPRmwl+qMUJFtr1eGfhA3HWsaFN8CAwEAAaOCASkwggEl
# MA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBTq
# FsZp5+PLV0U5M6TwQL7Qw71lljAfBgNVHSMEGDAWgBSubAWjkxPioufi1xzWx/B/
# yGdToDA+BggrBgEFBQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5n
# bG9iYWxzaWduLmNvbS9yb290cjYwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLmNvbS9yb290LXI2LmNybDBHBgNVHSAEQDA+MDwGBFUdIAAw
# NDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
# dG9yeS8wDQYJKoZIhvcNAQEMBQADggIBAH/iiNlXZytCX4GnCQu6xLsoGFbWTL/b
# GwdwxvsLCa0AOmAzHznGFmsZQEklCB7km/fWpA2PHpbyhqIX3kG/T+G8q83uwCOM
# xoX+SxUk+RhE7B/CpKzQss/swlZlHb1/9t6CyLefYdO1RkiYlwJnehaVSttixtCz
# Asw0SEVV3ezpSp9eFO1yEHF2cNIPlvPqN1eUkRiv3I2ZOBlYwqmhfqJuFSbqtPl/
# KufnSGRpL9KaoXL29yRLdFp9coY1swJXH4uc/LusTN763lNMg/0SsbZJVU91naxv
# SsguarnKiMMSME6yCHOfXqHWmc7pfUuWLMwWaxjN5Fk3hgks4kXWss1ugnWl2o0e
# t1sviC49ffHykTAFnM57fKDFrK9RBvARxx0wxVFWYOh8lT0i49UKJFMnl4D6SIkn
# LHniPOWbHuOqhIKJPsBK9SH+YhDtHTD89szqSCd8i3VCf2vL86VrlR8EWDQKie2C
# UOTRe6jJ5r5IqitV2Y23JSAOG1Gg1GOqg+pscmFKyfpDxMZXxZ22PLCLsLkcMe+9
# 7xTYFEBsIB3CLegLxo1tjLZx7VIh/j72n585Gq6s0i96ILH0rKod4i0UnfqWah3G
# PMrz2Ry/U02kR1l8lcRDQfkl4iwQfoH5DZSnffK1CfXYYHJAUJUg1ENEvvqglecg
# WbZ4xqRqqiKbMIIFgzCCA2ugAwIBAgIORea7A4Mzw4VlSOb/RVEwDQYJKoZIhvcN
# AQEMBQAwTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNV
# BAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMTQxMjEwMDAw
# MDAwWhcNMzQxMjEwMDAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3Qg
# Q0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2ln
# bjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJUH6HPKZvnsFMp7PPcN
# CPG0RQssgrRIxutbPK6DuEGSMxSkb3/pKszGsIhrxbaJ0cay/xTOURQh7ErdG1rG
# 1ofuTToVBu1kZguSgMpE3nOUTvOniX9PeGMIyBJQbUJmL025eShNUhqKGoC3GYEO
# fsSKvGRMIRxDaNc9PIrFsmbVkJq3MQbFvuJtMgamHvm566qjuL++gmNQ0PAYid/k
# D3n16qIfKtJwLnvnvJO7bVPiSHyMEAc4/2ayd2F+4OqMPKq0pPbzlUoSB239jLKJ
# z9CgYXfIWHSw1CM69106yqLbnQneXUQtkPGBzVeS+n68UARjNN9rkxi+azayOeSs
# JDa38O+2HBNXk7besvjihbdzorg1qkXy4J02oW9UivFyVm4uiMVRQkQVlO6jxTiW
# m05OWgtH8wY2SXcwvHE35absIQh1/OZhFj931dmRl4QKbNQCTXTAFO39OfuD8l4U
# oQSwC+n+7o/hbguyCLNhZglqsQY6ZZZZwPA1/cnaKI0aEYdwgQqomnUdnjqGBQCe
# 24DWJfncBZ4nWUx2OVvq+aWh2IMP0f/fMBH5hc8zSPXKbWQULHpYT9NLCEnFlWQa
# Yw55PfWzjMpYrZxCRXluDocZXFSxZba/jJvcE+kNb7gu3GduyYsRtYQUigAZcIN5
# kZeR1BonvzceMgfYFGM8KEyvAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBBjAPBgNV
# HRMBAf8EBTADAQH/MB0GA1UdDgQWBBSubAWjkxPioufi1xzWx/B/yGdToDAfBgNV
# HSMEGDAWgBSubAWjkxPioufi1xzWx/B/yGdToDANBgkqhkiG9w0BAQwFAAOCAgEA
# gyXt6NH9lVLNnsAEoJFp5lzQhN7craJP6Ed41mWYqVuoPId8AorRbrcWc+ZfwFSY
# 1XS+wc3iEZGtIxg93eFyRJa0lV7Ae46ZeBZDE1ZXs6KzO7V33EByrKPrmzU+sQgh
# oefEQzd5Mr6155wsTLxDKZmOMNOsIeDjHfrYBzN2VAAiKrlNIC5waNrlU/yDXNOd
# 8v9EDERm8tLjvUYAGm0CuiVdjaExUd1URhxN25mW7xocBFymFe944Hn+Xds+qkxV
# /ZoVqW/hpvvfcDDpw+5CRu3CkwWJ+n1jez/QcYF8AOiYrg54NMMl+68KnyBr3TsT
# jxKM4kEaSHpzoHdpx7Zcf4LIHv5YGygrqGytXm3ABdJ7t+uA/iU3/gKbaKxCXcPu
# 9czc8FB10jZpnOZ7BN9uBmm23goJSFmH63sUYHpkqmlD75HHTOwY3WzvUy2MmeFe
# 8nI+z1TIvWfspA9MRf/TuTAjB0yPEL+GltmZWrSZVxykzLsViVO6LAUP5MSeGbEY
# NNVMnbrt9x+vJJUEeKgDu+6B5dpffItKoZB0JaezPkvILFa9x8jvOOJckvB595yE
# unQtYQEgfn7R8k8HWV+LLUNS60YMlOH1Zkd5d9VUWx+tJDfLRVpOoERIyNiwmcUV
# hAn21klJwGW45hpxbqCo8YLoRT5s1gLXCmeDBVrJpBAxggNJMIIDRQIBATBvMFsx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
# EyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIFNIQTM4NCAtIEc0AhABGXV0
# ccmS10TfpZbruXAVMAsGCWCGSAFlAwQCAaCCAS0wGgYJKoZIhvcNAQkDMQ0GCyqG
# SIb3DQEJEAEEMCsGCSqGSIb3DQEJNDEeMBwwCwYJYIZIAWUDBAIBoQ0GCSqGSIb3
# DQEBCwUAMC8GCSqGSIb3DQEJBDEiBCDU2Dqh31MrlSTlOhtKlseRywIdDa7IAaQp
# wW+kKSI2KTCBsAYLKoZIhvcNAQkQAi8xgaAwgZ0wgZowgZcEIAt5ojmuQhCN71az
# VAW/j82OWadLhO7i3sPZccHqFzTsMHMwX6RdMFsxCzAJBgNVBAYTAkJFMRkwFwYD
# VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIFRpbWVz
# dGFtcGluZyBDQSAtIFNIQTM4NCAtIEc0AhABGXV0ccmS10TfpZbruXAVMA0GCSqG
# SIb3DQEBCwUABIIBgIdhC6MlU8pN+fOSzlngkNVVONat5bSA64yveNPRnYtCoNAQ
# rlVJfaLjCohbiE6OAMDSIab3y747bKkgVsoHtmPPOMcqNFxHAZGXoDW37iEipnd3
# 4UYWEvMndR40QRRGRjba7ARosY0vLqdtnWtNuy8okNQKnPTR8PKABXv3b/CrEdou
# 3CcT3zaDHNnSNuZt3xM/4t7EAV519kyduGMQJxNqiwv+zJP7KtAy9hSq2TphGWO9
# qSUC+krfdOuyDmGmc0UEiYZlt1QKsWPgNIHvDbbj05QUY0cXDHLo7bmf12BchifK
# LFM2D9L9rxyEp7pM6gkdZjarpQSaIVXdjcblf194cHXkwIc/BORAqr6jNkyJBbek
# 3klkb4dCLRvcXFFBlvzt3oB6/5JTWnE1pDL/4Yo02W2L+9syveUUYRh6gFFpbTIH
# IOQq7veYoqPEyKmser+Cxz8Cje4OIsZEoQzaui//AwrCtYRwlkV7fc9CmPrPqcT4
# WQBZyMtPz9KBG203PA==
# SIG # End signature block
