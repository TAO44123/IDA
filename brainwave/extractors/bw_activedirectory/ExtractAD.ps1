<# 
.SYNOPSIS
COPYRIGHT BRAINWAVE, all rights reserved.
This computer program is protected by copyright law and international treaties.
Unauthorized duplication or distribution of this program, or any portion of it, may result in severe civil or criminal penalties, and will be prosecuted to the maximum extent possible under the law.

ExtractAD Version 5.2
Extract groups and user accounts of an Active Directory.
 
.DESCRIPTION
	USAGE :
	  ExtractAD.ps1 -filter<String> -attributesfile<String> -servers<String> -credential<String> -logLevel<String> -errAction<String> -printLog<boolean> -port<Int32> -authType<String> -useSSL<boolean> -outputDirectory<String> -logDirectory<String>
	  
	SCRIPT PARAMETERS:
	- filter : LDAP filter, default value is : "(|(objectcategory=Person)(objectclass=group))"
	- ouFilter : filter on a specific organizationalUnit, should be a valid organizationalUnit DN (example: OU=Internal Users,DC=intra,DC=test,DC=local)"
	- attributesfile : File that contains the attribute names to exclude or include in the extraction according to the mode parameter(by default, "attributes.cfg")
	- servers: File that contains the names of servers to do their extraction.
	- credential: file containing PSCredential used to extract rights on share and mount drive, see example to create and store PSCredential object to a file, if not set current session credential will be used.
	- logLevel: log level, possible values are: <'Debug','Info','Warning','Error'>, default value is Info
	- errAction: set error action  preference, possible values are: <'Continue','Ignore','Inquire','SilentlyContinue','Stop','Suspend'>, default value is 'Stop'
	- printLog: set to false to disable printing info on console, default value is 'True'
	- port: LDAP server port, default value is 389.
	- authType: authentication method to use in LDAP connection.
	- useSSL: boolean to activate SecureSocketLayer  on LDAP connection, default value is 'False'.
	- outputDirectory: directory where extracted file will be stored, if not set extracted file will be in execution directory.
	- logDirectory: directory where log file will be stored, if not set log file will be in execution directory.
	- hrData: set to true to export users only in csv file to be colected as hr data
	- customHrAttributes: Path to file that contains custom mapping between HR attributes and AD attributes (please check the documentation to create a valid file)

.EXAMPLE
./ExtractAD.ps1 -servers 'servers.cfg' -attributesfile 'attributes.cfg' -filter '(|(objectcategory=Person)(objectclass=organizationalUnit)(objectclass=group)(objectclass=container))'

.EXAMPLE
./ExtractAD.ps1 -servers 'servers.cfg'
	
- The script will extract all AD attributes.
- Default LDAP filter is '(|(objectcategory=Person)(objectclass=group))'

.EXAMPLE
./ExtractAD.ps1 -servers 'servers.cfg' -credential $credFile

.EXAMPLE
$password_ =  ConvertTo-SecureString –String $filerPassword –AsPlainText -Force		
$credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $filerLogin, $password_ 
$credential | Export-CliXml credential.xml

Example to create PSCredential and store it in a file (password will be encrypted by powershell API), file can work only under local machine and user session where it was created.
		

.EXAMPLE
$credential = Get-Credential -UserName test\local		
$credential | Export-CliXml credential.xml

Example to create PSCredential in interactive mode and store it in a file (password will be encrypted by powershell API), file can work only under local machine and user session where it was created.

#>

# In connector mode: Parameters to send by the connector to the script
# [String]@config.filter LDAP filter
# [String]@config.ouFilter organizationalUnit DN filter
# [File]@config.attributesfile Attribute list
# [File]@config.serverList Server list
# [File]@config.credential Credential File on server
# [String]@config.logLevel  Log level
# [String]@config.errAction  Error action  preference
# [boolean]@config.printLog Print Logs in console
# [int]@config.port LDAP server port
# [String]@config.authType Authentication method
# [boolean]@config.useSSL activate SecureSocketLayer
# [String]@config.hrData extract RH data only
# [String]@config.customHrAttributes Custom HR attribute list

param
(
	[string]$attributesfile,
	[string]$servers,
	[string]$filter='(|(objectcategory=Person)(objectclass=group))',
	[string]$ouFilter,
	[string]$outputDirectory,
	[string]$logDirectory,
	[ValidateSet('Debug','Info','Warning','Error')][string]$logLevel = "Info",
    [ValidateSet('Continue','Ignore','Inquire','SilentlyContinue','Stop','Suspend')][string]$errAction = "Continue",
	[string]$printLog=$true,
	[string]$credential,
	[ValidateSet('Anonymous','Basic','Digest','Dpa','External','Kerberos','Msn','Negotiate','Ntlm')][string]$authType,
	$useSSL=$false,
	[boolean]$hrData=$false,
	$customHrAttributes,
	$memberlimit= 1000000
)

######################################## FUNCTIONS USED FOR LOGS ################################################

function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        $Message,
        [ValidateSet("Error","Warning","Info","Debug")] [string]$Level="Info"
    )
	if(canLog $logLevel $Level){
		$formattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		$formattedMsg = '[{0}] {1} - {2}' -f $formattedDate, $Level, $Message
		$formattedMsg >> $__logfile__
        if($Level -eq 'Error'){
            $Message >> $__logfile__
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

function printLog(){
    [CmdletBinding()] 
	Param 
    ( 
		[string]$message,
		[string]$Level="Info"
	)
    
	if($printLog -eq $true){
		if($connectorMode){
			send_message $Message $Level
		}else{
			Write-Host $Message
		}
	}
}

function canLog(){	
    [CmdletBinding()] 
	Param 
    ( 
		[string]$ScriptLogLevel,
		[string]$Level
	)
    $canLog = $false
	$Script = getLevel $ScriptLogLevel
	$curentLevel = getLevel $Level
	if($curentLevel -le $Script){
		$canLog = $true
	}
	$canLog
	return
}

function getLevel(){

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

#send_message
#print message in studio console if extractor launched in connector mode using studio
function send_message($msg,$level){
	#level can be: @Error	@Warning	@Log	@Info	@Debug	@Message
	if($connectorMode){		
		$d=(get-date).millisecond
		$result = @{"__UID__" = $script:connector_counter; "__NAME__" = $script:connector_counter;"__event_type__"="@$($level)";"__event_when__"="$d"; "__event_message__" = $msg;"__event_line__"="-1";"__event_script__"=$__SiloName__+"$"+ $__ConnectorName__+"$"+ $__ScriptName__}    	
		$script:connector_counter+=1
		if (!$Connector.Result.Process($result)) {					
			break
		}
	}
}

#send_signal
#send info to the host, ex: (data uncompleted, close streams)
#$signle: can be
#			"open" : to open a stream on host
#			"finish": to close a stream on host
#			"finish": generated output files on host are uncompleted (ex: extraction error)
#streamName: contain stream name, it must be used only if $signle is open or finish
function send_signal($signle, $streamName){
	#level can be: @Error	@Warning	@Log	@Info	@Debug	@Message
	if($connectorMode){		
		$result = @{"__UID__" = $script:connector_counter; "__NAME__" = $script:connector_counter;"__outputstrem_state__"=$signle;"__outputstrem_state_name__"=$streamName}    	
		$script:connector_counter+=1
		if (!$Connector.Result.Process($result)) {					
			break
		}
	}
}

# processCopy
# This function is used to send information using the connector mode
# Parameters
#     - $buf the buffer with the information to send
#     - $append true or false
function  processCopy ($buf, $append, $fileName) {
    $result = @{"__UID__" = $script:connector_counter; "__NAME__" = $script:connector_counter;"__APPEND__" = $append;"__bytesdata__"=$buf;"__outputstream__"=$fileName; "__outputtype__"="__bytes_copy__";"__bytesRead__" = $bytesRead;"__event_type__"="Data"}
    $script:connector_counter += 1
    if (!$Connector.Result.Process($result)) {					
    	break
    }
	
}

#send_log
#send log file to igrc in connector mode
function send_log() {
	try{
		$bufferSize = 65536
		$stream = [System.IO.File]::OpenRead($__logfile__)
		while ( $stream.Position -lt $stream.Length ) {
			#BEGIN CALLOUT A
			[byte[]]$buffer = new-object byte[] $bufferSize
			$bytesRead = $stream.Read($buffer, 0, $bufferSize)    
			processCopy $buffer $true $__logfile__   			
		 }
	}finally{
		 if($stream){
			$stream.Close()
		 }
	}
}

#send_file
#send data file to igrc in connector mode
function send_file($filepath) {
	try{
		$bufferSize = 65536
		$stream = [System.IO.File]::OpenRead($filepath)
		while ( $stream.Position -lt $stream.Length ) {
			[byte[]]$buffer = new-object byte[] $bufferSize
			$bytesRead = $stream.Read($buffer, 0, $bufferSize)    
			processCopy $buffer $true $filepath    			
		 }
	}finally{
		 if($stream){
			$stream.Close()
		 }
	}
}

function add_loginfo ( $message ) {
	$now_timestamp=get-Date
	$current_time=$now_timestamp.Year.ToString()+$now_timestamp.Month.ToString()+$now_timestamp.Day.ToString()+$now_timestamp.Hour.ToString()+$now_timestamp.Minute.ToString()+$now_timestamp.Second.ToString()+$now_timestamp.Millisecond.ToString()	
	$finalmessage = "[" + $current_time + "] " + $message
	$finalmessage >> $__logfile__
}

#Function overrideAttribures
#	Get attributes to extract using -attributesfile parameter if set, otherwise default attributes will be used, see help for more detail.
#	Parameters:
#		$default: default script attributes
function overrideAttribures(){	
	if ($attributesfile){
		if (test-path $attributesfile) {
			$cfg = Get-Content $attributesfile 
			foreach ($line in $cfg)	{
				if ($null -ne $line -and $line -ne "" -and ($false -eq $Script:attributesList.Contains($line))) {
					$line = $line.ToLower()
					$Script:attributesList += $line
				}
			}
		}else{
			$Script:extractADExitCode = 1
			throw "The file ($attributesfile) containing attribute list to export is not found"
		}
	}else{		
		Write-Log -message "No attributes file is set, the script will export default attributes" -Level Warning		
	}
}

function overrideHrAttribures(){
	$header = 'hr_attribute', 'ad_attribute'
	if ($customHrAttributes){
		if (test-path $customHrAttributes) {
			$cfg = Import-Csv -Path $customHrAttributes -Delimiter ';' -Header $header
			foreach ($line in $cfg)	{
				if ($null -ne $line){
					$hr_attribute = $line.hr_attribute
					$ad_attribute = $line.ad_attribute
					if ( $null -ne $hr_attribute -and "" -ne $hr_attribute -and $null -ne $ad_attribute -and "" -ne $ad_attribute) {
						if($script:hrAttributes.ContainsKey($hr_attribute)){
							$ad_attribute = $ad_attribute.ToLower()
							$script:hrAttributes[$hr_attribute] = $ad_attribute
							if ($false -eq $Script:attributesList.Contains($ad_attribute)) {
								$Script:attributesList += $ad_attribute
							}
						}
					}
				}
			}
		}else{
			$Script:extractADExitCode = 1
			throw "The file ($customHrAttributes) containing hr attributes mapping is not found"
		}
	}else{		
		Write-Log -message "No hr attributes mapping file is set, the script will export default mapping" -Level Warning		
	}
}

#Function getServerList
#	Get server list using -servers parameter
function getServerList(){
	$domains =@()
	if ($servers) {
		if (test-path $servers)	{
			$cfg = Get-Content $servers 
			foreach ($line in $cfg)	{
				if (($line -ne $null) -and ($line -ne "")) {
					$domains += $line
				}
			}
			if(($domains -eq $null) -or ($domains.Count -eq 0))	{
				Write-Log -Level Warning -message "The file ($servers) containing server list is empty"				
			}
		}else{
			$Script:extractADExitCode = 1
			throw "The file ($servers) containing server list not found"
		}
	}else{
		Write-Log "Server list not set, script will try to enumerate domains from current Forest" -Level Warning
		$CDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
		$Domains_objs = $CDomain.Forest.Domains		
		foreach ($objDomain_ in $Domains_objs)
		{	
			$domains+=$objDomain_.Name;
		}	
	}
	,$domains
	return
}

#Function handleAttribute
#	get value of an attributes from DirectoryAttribute object
#	Parameters:
#				$attribute: DirectoryAttribute
#				$attributeName: name of the attribute
function handleAttribute ([System.DirectoryServices.Protocols.DirectoryAttribute]$attribute, $attributeName){	
		if($attribute.Count -gt 0){		
		For ($i=0; $i -lt $attribute.Count; $i++) {
			$value = $attribute[$i]
			if ($attributeName -eq "objectsid" -or $attributeName -eq "sidhistory"){
				if($value.GetType().Name -eq "String"){
					$enc = [system.Text.Encoding]::UTF8
					$value = $enc.GetBytes($value)
					# Encoding.ASCII.GetBytes($value);
				}
				$value = (New-Object System.Security.Principal.SecurityIdentifier($value, 0)).Value
			}

			if ($attributeName -eq "objectguid"){
				$value = [System.GUID]$value
			}
			
			if($value.GetType().Tostring() -eq "System.Byte[]"){
				$stringBuilder = $stringBuilder.Append($attributeName).Append(":: ").AppendLine([System.Convert]::ToBase64String($value))
			}elseif (-not (isLDIFSafe $value)) {
				$enc = [system.Text.Encoding]::UTF8
				[Byte[]]$data = $enc.GetBytes($value)			
				$stringBuilder = $stringBuilder.Append($attributeName).Append(":: ").AppendLine([System.Convert]::ToBase64String($data))
			}else{
				$stringBuilder = $stringBuilder.Append($attributeName).Append(": ").AppendLine($value)
			}
		}
	}
}

Function getDomainInfo {
    Param (
        [System.DirectoryServices.Protocols.LdapConnection]$LdapConnection
    )
    $results = @()
    $propDef=@{"rootDomainNamingContext"=@(); "configurationNamingContext"=@(); "schemaNamingContext"=@();"defaultNamingContext"=@();"dnsHostName"=@()}

    #Get RootDSE info
    $rq=new-object System.DirectoryServices.Protocols.SearchRequest
    $rq.Scope = "Base"
    $rq.Attributes.AddRange($propDef.Keys) | Out-Null
    [System.DirectoryServices.Protocols.ExtendedDNControl]$exRqc = new-object System.DirectoryServices.Protocols.ExtendedDNControl("StandardString")
    $rq.Controls.Add($exRqc) | Out-Null
            
    $rsp=$LdapConnection.SendRequest($rq)
            
    $data=new-object PSObject -Property $propDef
            
    $data.configurationNamingContext = (($rsp.Entries[0].Attributes["configurationNamingContext"].GetValues([string]))[0]).Split(';')[1];
    $data.schemaNamingContext = (($rsp.Entries[0].Attributes["schemaNamingContext"].GetValues([string]))[0]).Split(';')[1];
    $data.rootDomainNamingContext = (($rsp.Entries[0].Attributes["rootDomainNamingContext"].GetValues([string]))[0]).Split(';')[2];
    $data.defaultNamingContext = (($rsp.Entries[0].Attributes["defaultNamingContext"].GetValues([string]))[0]).Split(';')[2];
    $data.dnsHostName = ($rsp.Entries[0].Attributes["dnsHostName"].GetValues([string]))[0]	
	
	$domainDN = $data.defaultNamingContext
	$results += $domainDN
	#Get netBiosName
	$rq2=new-object System.DirectoryServices.Protocols.SearchRequest
	$rq2.DistinguishedName = "CN=Partitions, $($data.configurationNamingContext)"
	$rq2.Attributes.Clear()
	$rq2.Attributes.Add("nETBIOSName")  | Out-Null
	$rq2.Filter = "(&(objectCategory=crossRef)(ncName= $($data.defaultNamingContext)))"
	$rqs2=$LdapConnection.SendRequest($rq2)

		if ($rqs2.Entries.Count -ge 0){		
			$foundItem = $rqs2.Entries[0]
			if($foundItem.Attributes["nETBIOSName"]){
				$netBios = $foundItem.Attributes["nETBIOSName"].GetValues([string])	
				$results += $netBios
			}
		}
	,$results
	return
  }
#Function handleGroupMembers
#	export group members using pagination if member count great then max (by default max if 1500)
#	Parameters:
#		$dn: disnguishedname of the group
#		$LDAPConnection: LDAP connection object
function handleGroupMembers($dn, [System.DirectoryServices.Protocols.LDAPConnection]$LDAPConnection){
	$attributeNameBuilder = New-Object -TypeName "System.Text.StringBuilder"
	$totalMemberCount = 0
	$pageSize = 1000
	$currentPageRange = 0;	
	$stillMembers = $true
	while($stillMembers){
		# Prepare the request
		$attributeNameBuilder = $attributeNameBuilder.Append("member;range=").Append($currentPageRange).Append("-").Append($currentPageRange + $pageSize -1)
		$memberRequest = New-Object System.directoryServices.Protocols.SearchRequest	
		$memberRequest.DistinguishedName = $dn
		#$memberRequest.DistinguishedName= $domainDN # Root
		$memberRequest.Filter = $filter
		$memberRequest.Scope = "Subtree"	
		$memberRequest.TimeLimit=(new-object System.Timespan(0,5,0))	
		[void]$memberRequest.Attributes.Clear()
		[void]$memberRequest.Attributes.AddRange($attributeNameBuilder.ToString())
    
		$response = $LdapConnection.SendRequest($memberRequest,(new-object System.Timespan(0,5,0)) ) -as [System.DirectoryServices.Protocols.SearchResponse];	    
		# Parse results
		$members = $response.Entries[0].Attributes[$attributeNameBuilder.ToString()]
		if($members.Count -lt $pageSize){
			# for last page attribute name will be member;range=xxx-* and not member;range=xx-yy
			$stillMembers = $false
			$attributeNameBuilder = $attributeNameBuilder.Clear()
			$attributeNameBuilder = $attributeNameBuilder.Append("member;range=").Append($currentPageRange).Append("-*")
			$members = $response.Entries[0].Attributes[$attributeNameBuilder.ToString()]
		}
		$totalMemberCount += $members.Count
		handleAttribute $members "member"		

		if($currentPageRange -gt $memberlimit){
			$stillMembers = $false
		}

		$attributeNameBuilder = $attributeNameBuilder.Clear()
		$currentPageRange +=  $pageSize
	}

	$groupMemberCountmsg = "{0} members exported for group {1}" -f $totalMemberCount ,$dn
	Write-Log -Message $groupMemberCountmsg -Level Debug
}

#Function addFileContent
#	append stringbuilder value to output ldif file
#	Parameters:
#		$filePath: ldif file
#		$buffer: StringBuilder containing bufferSize object
function addFileContent([System.String]$filePath, [System.Text.StringBuilder]$buffer){
	$streamWriter =  New-Object IO.StreamWriter -Arg $filePath,$true,([System.Text.Encoding]::UTF8)
	$streamWriter.WriteLine($buffer)
	$streamWriter.Close()	
}

#Function handleDomain
#	iterate on objects of a domain
#	parameers:
#		$Domain: domain name
#		$attributesList attributes to export
function handleDomain($Domain){
	$dnCache = @{}
	$LDAPConnection = New-Object System.DirectoryServices.Protocols.LDAPConnection ($Domain <#$domainController#> )
	$LDAPConnection.SessionOptions.ProtocolVersion=3
	$LDAPConnection.SessionOptions.ReferralChasing= [System.DirectoryServices.Protocols.ReferralChasingOptions]::None
	$LDAPConnection.Timeout=(new-object System.Timespan(10,0,0))
	if($exportCredential){$LDAPConnection.Credential = $exportCredential}
	if($authType){$LDAPConnection.AuthType = $authType}
	
	if($useSSL -eq $true){$LDAPConnection.SessionOptions.SecureSocketLayer = $true}

	#get netBiosName
	$netBios = $null
	$domainDN = $null
	$warning = $false
	try{
		$info = getDomainInfo $LDAPConnection
		if($info.count -eq 1){
			$domainDN = $info[0]
			$warning = $true
		}else{
			if($info.count -eq 2){
				$domainDN = $info[0]
				$netBios = $info[1]
			}else{
				$warning = $true				
			}
		}
	}catch{
		$warning = $true
		if($error.Count -gt 0){
			Write-Log -Message $error[$error.Count-1] -Level Error
		}
	}finally{
		if($warning -eq $true){
			$msg1 = "Cannot retrieve NetBios name of server $($Domain) using LDAP request, provided server name in parameters will be used to name the out file, this name will be used in AD facet during collect to calculate repository code."
			$msg2 = "You must rename manualy out file name to have the format <NetBiosName>.ldif"
			Write-Log -Message $msg1 -Level Warning
			Write-Log -Message $msg2 -Level Warning
			$netBios = $Domain		
		}
	}
	if($false -eq $hrData){
		$current_outputFile = Join-Path $outputDirectory ($netBios.ToUpper() + ".ldif")
		$file = New-Item $current_outputFile -type file -force
		Write-Log -Message "$($file.FullName) file created" -Level Debug
		$Script:outFiles +=  ($netBios.ToUpper() + ".ldif")	
	}else{
		$current_outputFile = Join-Path $outputDirectory ($netBios.ToUpper() + ".csv")
		$file = New-Item $current_outputFile -type file -force
		Write-Log -Message "$($file.FullName) file created" -Level Debug
		$Script:outFiles +=  ($netBios.ToUpper() + ".csv")	

		$dataObject = New-Object -TypeName psobject	
		foreach ($hrAttributeName in $script:hrAttributesOrder){
			$dataObject | Add-Member -MemberType NoteProperty -Name $hrAttributeName -Value ""
		}
		$data =  ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
		Set-Content $data[0] -Path $file.FullName
	}
	# Prepare the request
	$request = New-Object System.directoryServices.Protocols.SearchRequest
	if($ouFilter){
		$request.DistinguishedName= $ouFilter # OU filter
	}else{
		$request.DistinguishedName= $domainDN # Root
	}
	
	if($false -eq $hrData){
		$request.Filter = $filter
	}else{
		if($null -ne $filter -and "" -ne $filter -and "(|(objectcategory=Person)(objectclass=group))" -ne $filter){
			$filter = '(&(objectcategory=Person)(objectClass=user)' + '(' + $filter + '))'
		}else{
			$filter = '(&(objectcategory=Person)(objectClass=user))'
		}		
		$request.Filter = $filter
	}
	$request.Scope = "Subtree"
	[System.DirectoryServices.Protocols.PageResultRequestControl]$requestcontrol = New-Object System.DirectoryServices.Protocols.PageResultRequestControl( 500 ) # Page size
	$request.Controls.Add($requestcontrol) | Out-Null
	$request.TimeLimit=(new-object System.Timespan(0,5,0))

	[void]$request.Attributes.AddRange($Script:attributesList)
	
	# Get the responses page by page
	$pagenb=0
	$stringBuilder = New-Object -TypeName "System.Text.StringBuilder"
	[System.DirectoryServices.Protocols.PageResultResponseControl] $responsecontrol=$null;
	while ($true){	
		$response = $LdapConnection.SendRequest($request,(new-object System.Timespan(0,5,0)) ) -as [System.DirectoryServices.Protocols.SearchResponse];	
		# Dump session options
		if ($pagenb -eq 0 ){
			Write-Log -Message ("Auth Type " +  $LDAPConnection.AuthType) -Level Debug
			Write-Log -Message ("Auto Bind " +  $LDAPConnection.AutoBind) -Level Debug
			$PropertyList=($LDAPConnection.SessionOptions | Get-Member)
			foreach ( $property in $PropertyList ) {
				if ($property.MemberType -eq "Property"){
					$sessionOptions = "SessionOptions " + $property.Name + " : " + $LDAPConnection.SessionOptions.($property.Name)
					Write-Log -Message $sessionOptions -Level Debug
				}
			}
		}
		$pagenb=$pagenb+1
		# Parse results
		foreach ($foundItem in $response.Entries){
			if($dnCache.ContainsKey($foundItem.DistinguishedName)){
				Write-Log -Message "Break loop, '$($foundItem.DistinguishedName)' already handled." -Level Debug
				Write-Log -Message "PageResponseControl.Cookie.Length = $($responsecontrol.Cookie.Length)." -Level Debug
				return
			}else{
				$dnCache.Add($foundItem.DistinguishedName,"");
			}
	
			# Count and log
			$Script:objectCountPerServer ++
			$objectCount ++
			if ( $objectCount % 1000 -eq 0 ){
				Write-Log -Message ("AD objects - $objectCount objects read ...") -Level Info				
			}
			if ($false -eq $hrData) {
				$stringBuilder = $stringBuilder.Append("dn: ").AppendLine( $foundItem.DistinguishedName)
				foreach ($attributeName in $Script:attributesList){
					$attribute = $foundItem.Attributes.Item($attributeName);
					if($attribute){
						handleAttribute $attribute $attributeName
					}
				}
	
				foreach ($name in $foundItem.Attributes.AttributeNames){
					if($name.Contains("member;range=") ){
						$members = $foundItem.Attributes[$name]
						$msg = 'Group {0} have more then {1} members' -f $foundItem.DistinguishedName , $members.Count
						Write-Log -Message $msg -Level Warning				
						Write-Log -Message "Paginating on group members" -Level Debug				
						#paginate on group members
						handleGroupMembers  $foundItem.DistinguishedName $LDAPConnection					
						break
					}
				}
				$stringBuilder = $stringBuilder.AppendLine()
			}else{
				handleAttributesCsv $foundItem
			}
		}
		Write-Log -Message "Page $($pagenb): $($response.Entries.Count) entries:" -Level Debug
		# write buffer to file
		#Add-Content $current_outputFile $temp_fields			
		addFileContent $current_outputFile $stringBuilder
		$stringBuilder = $stringBuilder.Clear()

		# retrieve the cookie 
		if ($response.Controls.Length -ne 1 -or (-not($response.Controls[0] -is [System.DirectoryServices.Protocols.PageResultResponseControl])) ){
			Write-Log -Message "The server did not return a PageResultResponseControl as expected." -Level Info
			return;
		}
	
		$responsecontrol = [System.DirectoryServices.Protocols.PageResultResponseControl]$response.Controls[0];

		# if responseControl.Cookie.Length is 0 then there is no more page to retrieve so break the loop
		if($responsecontrol.Cookie.Length -eq 0) {
			break;
		}

		# set the cookie from the response control to retrieve the next page
		$requestcontrol.Cookie = $responsecontrol.Cookie;
	}
}

function handleAttributesCsv{
    Param 
    (   
		$foundItem		
    )	
	
	$dataObject = New-Object -TypeName psobject	
	$index = 1
	$ignore = $true;
	foreach ($hrAttributeName in $script:hrAttributesOrder){
		$attributeName = $script:hrAttributes[$hrAttributeName]
		$value = ""
		if($attributeName){
			$attribute = $foundItem.Attributes.Item($attributeName);
			if($attribute){
				$value = handleAttributeCsv $attribute
			}	
		}
		if(("displayname" -eq $attributeName -or "givenname" -eq $attributeName -or "sn" -eq $attributeName) -and ($null -ne $value -and $value -ne "")){
			$ignore = $false
		}
		if("createtimestamp" -eq $attributeName){
			$value = [datetime]::parseexact($value.ToString(), 'yyyyMMddHHmmss.0Z', $null).ToString('dd/MM/yyyy')
		}

		if("accountexpires" -eq $attributeName){
			if(0 -eq $value -or 9223372036854775807 -eq $value){
				$value = ""
			}else{
				$value = [datetime]::FromFileTime($value).ToString('dd/MM/yyyy')
			}
		}

		if("active" -eq $hrAttributeName){
			if(($value -band  0x00000002) -eq  0x00000002){
				$value = "false"
			}else{
				$value = "true"
			}
		}

		$hrAttributeName = $index.ToString() + "_" + $hrAttributeName
		$dataObject | Add-Member -MemberType NoteProperty -Name $hrAttributeName -Value $value
		$index++
		
	}
	if($false -eq $ignore){
		$data =  ConvertTo-Csv -InputObject $dataObject -Delimiter ';' -NoTypeInformation
		$stringBuilder = $stringBuilder.Append($data[1]).AppendLine()	
		# write buffer to file
	}else{
		$Script:objectCountPerServer --
		$objectCount --
	}
}

function handleAttributeCsv ([System.DirectoryServices.Protocols.DirectoryAttribute]$attribute){
	$values = @()
	if($attribute.Count -gt 0){		
		For ($i=0; $i -lt $attribute.Count; $i++) {
			$value = $attribute[$i]
			if($value.GetType().Tostring() -eq "System.Byte[]"){
				$value = [System.Convert]::ToBase64String($value)
			}
			$values += $value
		}
	}
	$strValue = $values -join ','
	return $strValue
}

# dumpScriptParameters
# return string containig script parameters 
function dumpScriptParameters(){
    $varList= New-Object -TypeName "System.Text.StringBuilder";
    $varList = $varList.Append('{')
    $varList = $varList.Append("filter").Append('=').Append($filter).Append(';')
    $varList = $varList.Append("attributesfile").Append('=').Append($attributesfile).Append(';')
    $varList = $varList.Append("servers").Append('=').Append($servers).Append(';')
	$varList = $varList.Append("credential").Append('=').Append($credential).Append(';')
    $varList = $varList.Append("logLevel").Append('=').Append($logLevel).Append(';')
	$varList = $varList.Append("errAction").Append('=').Append($errAction)
    $varList = $varList.Append("printLog").Append('=').Append($printLog).Append(';')
    $varList = $varList.Append("memberlimit").Append('=').Append($memberlimit).Append(';')
    $varList = $varList.Append("authType").Append('=').Append($authType).Append(';')
    $varList = $varList.Append("useSSL").Append('=').Append($useSSL).Append(';')
    $varList = $varList.Append("outputDirectory").Append('=').Append($outputDirectory).Append(';')
	$varList = $varList.Append("logDirectory").Append('=').Append($logDirectory).Append(';')
	$varList = $varList.Append("hrdata").Append('=').Append($hrdata).Append(';')
	$varList = $varList.Append("port").Append('=').Append($port).Append(';')
    $varList = $varList.Append('}')
    return $varList = $varList.ToString()
}


Function extractTerminate(){
	Write-Log -Message "Total objects exported is: $($Script:totalObjectCount)" -Level Info

	#Send ldif files to igrc
	if($connectorMode){
		try{
			foreach ($outFile in $Script:outFiles){ send_file $outFile }
		}catch{
			Write-Log -Message "Error occurred when trying to send Ldif files" -Level Error
		}
		foreach ($outFile in $Script:outFiles){ Remove-Item  $outFile }
	}

    # Dump errors in log file if found
	if($error.count -gt 0){
		if($error.count -eq 0){
			Write-Log -Message  "Terminating with $($error.count) error" -Level Warning
		}else{
			Write-Log -Message  "Terminating with $($error.count) errors" -Level Warning
		}

		foreach($err in $error){
			Write-Log -Message $err -Level Error
		}		
		$Script:extractADExitCode = 1
		
		if($connectorMode){
			foreach ($outFile in $Script:outFiles){ send_signal "uncomplete" $outFile }
			#error found data may not be completed, generated files are not approved
		}
	}

    #End datetime
	$datfin = Get-Date
	Write-Log -Message  "End script execution at $($datfin.ToString())" -Level Info
	Write-Log -Message "Total Execution Time:  $($stopwatch.Elapsed)" -Level Info
    Write-Log -Message "Exit with code: $Script:extractADExitCode" -Level Info
	#Send log file to igrc in connector mode
	if($connectorMode){
		$send = $false
		try{
			send_log
			$send = $true
		}catch{
			Write-Log -Message "Error occurred when trying to send log file" -Level Error
		}finally{
			if($send -eq $true){
				Remove-Item $__logfile__
			}
		}
	}
	exit $Script:extractADExitCode
}


Function extractActiveDirectory(){
	# override default attribures if -attributesfile parameter is set
	overrideAttribures
	$attributesListLog = "Attributes to export are: $($Script:attributesList)"
	Write-Log -Message $attributesListLog -Level Debug
	# get domains list from input parameter file
	$domains = @()
	$domains = getServerList
	$domainsLog =  "Servers to export are : $($domains)"
	Write-Log -Message $domainsLog -Level Debug

	$exportCredential = $null
	if($credential){
		if(Test-Path $credential){
			$exportCredential = Import-CliXml $credential                        
		}
	}
			
	foreach ($objDomain in $domains){	
		if($objDomain -ne $null) {
			# handle signle domain
			Write-Log -Message "Iterating on server $($objDomain)" -Level Info
			handleDomain $objDomain
			Write-Log -Message "End Ierating on server $($objDomain): $($Script:objectCountPerServer) Objects exported" -Level Info
			$Script:totalObjectCount += $objectCountPerServer
			$Script:objectCountPerServer = 0
		}
	}
}

function getHrAttributesOrdred() {
	$hrAttributes = ("hrcode","givenname","surname","altname","fullname","titlecode","mail","phone","mobile","internal","employeetype","arrivaldate","departuredate","active",
					"jobtitlecode","jobtitledisplayname","organisationcode","organisationshortname","organisationdisplayname","organisationtype","parentorganisationcode",
					"linemanager","managedorgcode","analyticsgroup")
	return $hrAttributes
}
function getHrAttributes() {
	$hrAttributes = @{}
	$hrAttributes.Add("hrcode","samaccountname")
	$hrAttributes.Add("givenname","givenname")
	$hrAttributes.Add("surname","sn")
	$hrAttributes.Add("altname","")
	$hrAttributes.Add("fullname","displayname")
	$hrAttributes.Add("titlecode","")
	$hrAttributes.Add("mail","mail")
	$hrAttributes.Add("phone","")
	$hrAttributes.Add("mobile","")
	$hrAttributes.Add("internal","")
	$hrAttributes.Add("employeetype","employeetype")
	$hrAttributes.Add("arrivaldate","createtimestamp")
	$hrAttributes.Add("departuredate","accountexpires")
	$hrAttributes.Add("active","useraccountcontrol")
	$hrAttributes.Add("jobtitlecode","title")
	$hrAttributes.Add("jobtitledisplayname","title")
	$hrAttributes.Add("organisationcode","department")
	$hrAttributes.Add("organisationshortname","department")
	$hrAttributes.Add("organisationdisplayname","department")
	$hrAttributes.Add("organisationtype","")
	$hrAttributes.Add("parentorganisationcode","")
	$hrAttributes.Add("linemanager","manager")
	$hrAttributes.Add("managedorgcode","")
	$hrAttributes.Add("analyticsgroup","")
	return $hrAttributes
}

<#
Checks if the input byte array contains only safe values, that is,
the data does not need to be encoded for use with LDIF.
The rules for checking safety are based on the rules for LDIF
(Ldap Data Interchange Format) per RFC 2849.  The data does
not need to be encoded if all the following are true:

The data cannot start with the following byte values:

00 (NUL) 0x00
10 (LF) 0x0A
13 (CR) 0x0D
32 (SPACE) 0x20
58 (:) 0x3A
60 (LESSTHAN) 0x3C
Any character with value greater than 127 (Negative for a byte value)

The data cannot contain any of the following byte values:

00 (NUL) 0x00
10 (LF) 0x0A
13 (CR) 0x0D
Any character with value greater than 127
(Negative for a byte value)

The data cannot end with a space.
#>
function isLDIFSafe {
	
	param (
		$attributeValue
	)

	$enc = [system.Text.Encoding]::UTF8
	[Byte[]]$data = $enc.GetBytes($attributeValue)
	$length = $data.Length
	if($length -gt 0){
		$firstChar = $data[0]
        # unsafe if first character is a NON-SAFE-INIT-CHAR
        if (($firstChar -eq 0x00) -or ($firstChar -eq 0x0A) -or ($firstChar -eq 0x0D) -or ($firstChar -eq 0x20) -or ($firstChar -eq 0x3A) -or ($firstChar -eq 0x3C) -or ($firstChar -lt 0) -or ($firstChar -gt 127)) {
          # non ascii (>127 is negative)
          return $false;
        }
        # unsafe if last character is a space
        if ($data[$length - 1] -eq 0x20) {
          return $false;
        }
        # unsafe if contains any non safe character
        if ($length -gt 1) {
          for ($i = 1; $i -lt $data.Length; $i++) {
            $char = $data[$i]
            if (($char -eq 0x00) -or ($char -eq 0x0A) -or ($char -eq 0x0D) -or ($char -lt 0)) {
              # non ascii (>127 is negative)
              return $false
            }
          }
        }
	}
	return $true
}

#############################################################################################################################################
########################################################### Main Script #####################################################################
#############################################################################################################################################

# Script starting time
$datdebut = Get-Date
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Script return code 
[int] $Script:extractADExitCode = 0

#Connector counters
$script:connector_counter = 0
$script:connector_p = 0

#Calculate execution directory
$scriptDir = (Get-Location).Path

# Get execution mode if manual or over connector
$connectorVarSet = Get-Variable Connector -Scope Global -ErrorAction SilentlyContinue
$connectorMode = $false
if($connectorVarSet){
	$connectorMode = $true
}	

# Clear errors befor starting script
$error.Clear()

# Calculate log file name
$current_time = $datdebut.Year.ToString()+$datdebut.Month.ToString()+$datdebut.Day.ToString()+$datdebut.Hour.ToString()+$datdebut.Minute.ToString()+$datdebut.Second.ToString()+$datdebut.Millisecond.ToString()	
if($false -eq $hrData){
	$__logfile__ = "ExtractAD_" + $current_time + ".log"
}else{
	$__logfile__ = "ExtractADHR_" + $current_time + ".log"
}
if(!$connectorMode){
	if($logDirectory){
		$dir = Get-Item -Path $logDirectory
		$logDirectory = $dir.FullName
		$__logfile__ = Join-Path $logDirectory $__logfile__
	}else{
		$__logfile__ = Join-Path $scriptDir $__logfile__
	}
}
############################ Read parameters in connector mode ##############################
if ($connectorMode -eq $true) {
		

	if($Connector.Options.Options.ContainsKey("filter") -and $Connector.Options.Options.Get_Item("filter") -ne $null) {
		$filter=$Connector.Options.Options.Get_Item("filter") 
	}

	if($Connector.Options.Options.ContainsKey("serverList") -and $Connector.Options.Options.Get_Item("serverList") -ne $null) {
		$servers =$Connector.Options.Options.Get_Item("serverList")
	}
		
	if($Connector.Options.Options.ContainsKey("attributesfile") -and $Connector.Options.Options.Get_Item("attributesfile") -ne $null) {
		$attributesfile =$Connector.Options.Options.Get_Item("attributesfile")
	}
		
	if($Connector.Options.Options.ContainsKey("credential") -and $Connector.Options.Options.Get_Item("credential") -ne $null) {
		$credential = $Connector.Options.Options.Get_Item("credential") 
	}
		
	if($Connector.Options.Options.ContainsKey("port") -and $Connector.Options.Options.Get_Item("port") -ne $null) {
		$port = $Connector.Options.Options.Get_Item("port") 
		if(!$port -or $port -eq 0){
			$port = 389
		}
	}

	if($Connector.Options.Options.ContainsKey("authType") -and $Connector.Options.Options.Get_Item("authType") -ne $null) {
		$authType = $Connector.Options.Options.Get_Item("authType") 
	}

	if($Connector.Options.Options.ContainsKey("useSSL") -and $Connector.Options.Options.Get_Item("useSSL") -ne $null) {
		$useSSL = $Connector.Options.Options.Get_Item("useSSL")
	}

	if($Connector.Options.Options.ContainsKey("logLevel") -and $Connector.Options.Options.Get_Item("logLevel")) {
		$logLevel = $Connector.Options.Options.Get_Item("logLevel") 
	}

	if($Connector.Options.Options.ContainsKey("errAction") -and $Connector.Options.Options.Get_Item("errAction")) {
		$errAction = $Connector.Options.Options.Get_Item("errAction") 
	}
	
	if($Connector.Options.Options.ContainsKey("printLog") -and $Connector.Options.Options.Get_Item("printLog")) {
		$printLog = $Connector.Options.Options.Get_Item("printLog") 
	}else{
		$printLog = $false
	}
	
	if($Connector.Options.Options.ContainsKey("hrData") -and $Connector.Options.Options.Get_Item("hrData")) {
		$hrData = $Connector.Options.Options.Get_Item("hrData") 
	}

	if($Connector.Options.Options.ContainsKey("customHrAttributes") -and $Connector.Options.Options.Get_Item("customHrAttributes")) {
		$customHrAttributes = $Connector.Options.Options.Get_Item("customHrAttributes") 
	}

	if($Connector.Options.Options.ContainsKey("ouFilter") -and $Connector.Options.Options.Get_Item("ouFilter")) {
		$ouFilter = $Connector.Options.Options.Get_Item("ouFilter") 
	}

	$outputDirectory = $scriptDir
	$logDirectory = $scriptDir
}

Write-Log "Starting extractAD at $($datdebut)" -Level Info
Write-Log -Message "Log file in: $($__logfile__)" -Level Info

if($connectorMode -eq $true){
	$msg = "Connector options: $($Connector.Options.Options)"
	Write-Log -Message $msg -Level Debug 
}

$executionMode = "Executing script in connector mode: {0}" -f $connectorMode
Write-Log -Message $executionMode -Level Debug 

# Set script ErrorActionPreference
$ErrorActionPreference = $errAction

# Dump script params if logLevel is debug 
$params = dumpScriptParameters

$scriptParamLog = "Executing script with parameters: $($params)"
Write-Log -Message $scriptParamLog -Level Debug

#calculate output directory Path
if(!$connectorMode){
	if($outputDirectory){
		$dir = Get-Item -Path $outputDirectory
		$outputDirectory = $dir.FullName
	}else{
		$outputDirectory = $scriptDir
	}
}

Add-Type -AssemblyName "System.DirectoryServices"
Add-Type -AssemblyName "System.DirectoryServices.Protocols"

$Script:objectCountPerServer = 0
$Script:totalObjectCount = 0
$Script:outFiles = @()

# attributes list to include in output
$script:attributesList=@("objectcategory","objectguid","objectsid","sidhistory","member","objectclass","accountexpires",
						"badpwdcount","displayname","givenname","lastlogon","logoncount","lastlogontimestamp","mail","manager",
						"pwdlastset","samaccountname","sn","whencreated","useraccountcontrol","createtimestamp","description",
						"grouptype","managedby","modifytimestamp","legacyexchangedn","whenchanged","PrimaryGroupID")

#mapping between rh attributes an AD attribues
if($true -eq $hrData){
	$script:attributesList += "department"
	$script:attributesList += "title"
	$script:attributesList += "employeetype"
	$script:hrAttributesOrder = @()
	$script:hrAttributesOrder = getHrAttributesOrdred
	
	$script:hrAttributes = @{}
	$script:hrAttributes = getHrAttributes
	overrideHrAttribures
}

if($errAction -eq "Stop"){	
	#dump exception in finally block
	try{
		extractActiveDirectory
	}finally{ 
		extractTerminate
	}
}else{
	extractActiveDirectory
	extractTerminate
}


# SIG # Begin signature block
# MIIuYQYJKoZIhvcNAQcCoIIuUjCCLk4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDaHs5ChElsIFYM
# JZ64Rs9tWaMIdEsjtlmfMd6+aUh/jaCCFCQwggVyMIIDWqADAgECAhB2U/6sdUZI
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
# GZMwghmPAgEBMGwwXDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24g
# bnYtc2ExMjAwBgNVBAMTKUdsb2JhbFNpZ24gR0NDIFI0NSBFViBDb2RlU2lnbmlu
# ZyBDQSAyMDIwAgx93OORHPFHqnk11y0wDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgcRuH
# wmKXVYs9JwyJgJS5UbZ5205D4j/vlYCMh24N2PAwDQYJKoZIhvcNAQEBBQAEggIA
# rA1QP9RVhWPzR83G2W5ZPMcCfm5W/0f4dHd58DAUBcHIKTDeEoJvFS5VW/LpCPVz
# dAi9ewP/1fskDDPhHmXtOvfal1VFaSAm6RxNyKmf7fQ8e5olfepfciiCDP5c6itI
# t7NT0fhJ+5iHOgPRVaGiJ+bVxY4NmAjIqHqRCFHl38QEeDL1M24tjaONn2Md548i
# FIIV6MpID+aUKpiopf3ySJobSkf3eIhlLxGwIt6d9/owQAWYt1MExAvl1FLYTBe0
# AqrB7CTcoyhVOFwO5wwQ7N7W7SOOhcGVDyq1TE8kaDJr7ASOkjs7ZQBNIGdxvGR+
# mv1ACPphIos7Tt6wr1sWbNL1DkByzF8+0dqzuH/SeFXdAHDHdqCru2D/f5ixd8tI
# iUEwAmxOng4lgO2LHXOe992dpio3XTFVjYqQbqhi5DBe9NOpvi+O9v6mFDUucxcT
# m88hmRHRXnk4ONRGwpnrnj8/31v5+MdiZ3S+WspNK05XT0IPUD/YKbrjotERM/UX
# vb0rRnKbtl+nHD1PvNazgGz766Ja7zTcrlwKwnBi2GFXcMVq2mybz4ARX1J5asZW
# OVSd9CGQACbfJThRHnOFy2FRFwQ6WfYO6HkKlZwuEZ+bXS3gpUdgkG+O8CKV/qoV
# 2Z6KfKF0/sNaRGAXVrOVUTqwIdq7VnDgn4UW1jLkiJWhghZxMIIWbQYKKwYBBAGC
# NwMDATGCFl0wghZZBgkqhkiG9w0BBwKgghZKMIIWRgIBAzENMAsGCWCGSAFlAwQC
# ATCB3AYLKoZIhvcNAQkQAQSggcwEgckwgcYCAQEGCSsGAQQBoDICAzAxMA0GCWCG
# SAFlAwQCAQUABCDxdokqq8jmbyqsf6TJWSB8QX372iYihVGgBUUs+jN7zAIUAVT5
# 451NM3xOhPdJKGhEc8bRnpYYDzIwMjIwNTAyMTQ1MDI4WjADAgEBoFekVTBTMQsw
# CQYDVQQGEwJCRTEZMBcGA1UECgwQR2xvYmFsU2lnbiBudi1zYTEpMCcGA1UEAwwg
# R2xvYmFsc2lnbiBUU0EgZm9yIEFkdmFuY2VkIC0gRzSgghIEMIIGWDCCBECgAwIB
# AgIQAcKcevR6pgJYDq8ysSOxHTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
# RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2ln
# biBUaW1lc3RhbXBpbmcgQ0EgLSBTSEEzODQgLSBHNDAeFw0yMjA0MDYwNzQ0MTJa
# Fw0zMzA1MDgwNzQ0MTJaMFMxCzAJBgNVBAYTAkJFMRkwFwYDVQQKDBBHbG9iYWxT
# aWduIG52LXNhMSkwJwYDVQQDDCBHbG9iYWxzaWduIFRTQSBmb3IgQWR2YW5jZWQg
# LSBHNDCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAKPepiESFhK8KOAE
# 97PUsNMBaI9TthhYW3GgXtjWTHPgV/C5DAf3h7kpg/7w1XWhSP89sBxAvIJVaEg6
# DEbrP8MsmDTPxJibcBuGEY1eFXyhDdrWd32v7H6cFOylvylq64opGv4Onyy6Fk1Y
# WmNxDNsutHAK50YQQu57RXz+ZEWUr+DrULJSZx9xQzfx4hiDQBBXmhXX8vJrnpvJ
# Vttngxh492WkBczmE4UU/l+JZwFh+9rGgyjWjU7dNCwYAwGESN0WeCXh1khprVw1
# liEeoMNPEwAXy8Je3JJNBGLJePXep7GECp50OoLcgJS3AW2rqDmeGl3BfAEGXZB7
# Pl1KKMopELGzWc8BuCEwx9m19JcsNq5Sx7MyI26DpvnUJPdW+GF1dE7yBqsihMj9
# ZOVfFaXcJ3Sq0tDptEh415jMux/41kbDdXX6nkXGlXVrBweoRN1WdijOSk0CeWtP
# keL8rJ3rvIqvemtsZDRG8cx4HLwn9HVopzPJOhd+ik5EPoPzvQIDAQABo4IBnjCC
# AZowDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMB0GA1Ud
# DgQWBBRJO2e1V6KZ5nQZegxZLD4I6iB7izBMBgNVHSAERTBDMEEGCSsGAQQBoDIB
# HjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBv
# c2l0b3J5LzAMBgNVHRMBAf8EAjAAMIGQBggrBgEFBQcBAQSBgzCBgDA5BggrBgEF
# BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3N0c2FjYXNoYTM4
# NGc0MEMGCCsGAQUFBzAChjdodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
# Y2VydC9nc3RzYWNhc2hhMzg0ZzQuY3J0MB8GA1UdIwQYMBaAFOoWxmnn48tXRTkz
# pPBAvtDDvWWWMEEGA1UdHwQ6MDgwNqA0oDKGMGh0dHA6Ly9jcmwuZ2xvYmFsc2ln
# bi5jb20vY2EvZ3N0c2FjYXNoYTM4NGc0LmNybDANBgkqhkiG9w0BAQsFAAOCAgEA
# CIik6oWIM1hrfvwAVSLTb0Npb3z+vkOGNw6fU9pRntA84xuZ11FRGQ9RkA7b7ppG
# z30K4MbsFYLrPq7MA/pZ7Y+lSqIZPsJf/RaDMVZSKEtfxEWDYeuWDCAwon1F6pZt
# svx0uP1MYZRqp7Dqqb84jph2dQem+6XcC291emTpMNeRkGLQ4csZ5OgvJ4hAjIfb
# P9sVsEiN4o2VjCfzrEmHsHzpxKXg2dy+9g0VuN5jnX2WK62krpRgN9BImajbvS9O
# 9ACPt/xI2rYQQMQ/OdtVd70LPKw2oEqZFODQMR6J0icKcFDdrW9k+m+NGvZQ9BYT
# MAwYzthoQtVV41pfwKCBvBm8RLBjin7AKx5VbucdHhNkmWZkCYPpgeY+K/3kfOxD
# u5tvNWKTZJq7WLivBG4ouwpY44U5JdTjixVzATody12R/J5FLoe18EaclMNorfoO
# 60fZqSXWigrYnu+sol6mLpxY0b1RvxJy0BGbTM+bUr+n6kqUIvzadLNF1LMJ1mhE
# QCofimza5WlxABL4yd/qmKkqao/UmuAfrJnh6F0+eTxFpA4KhhSgFeWSIIHygo7z
# qsmcXxxJdPwhtSjggQ3/t3+Yg8Bg0wHFZsxhvMKkCwM3NpoyJcLF5oOU/NB5v4PT
# vFO14/7P4XE+BdtijyS971Oq8p5TDD98a/DqJThfcqowggZZMIIEQaADAgECAg0B
# 7BySQN79LkBdfEd0MA0GCSqGSIb3DQEBDAUAMEwxIDAeBgNVBAsTF0dsb2JhbFNp
# Z24gUm9vdCBDQSAtIFI2MRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpH
# bG9iYWxTaWduMB4XDTE4MDYyMDAwMDAwMFoXDTM0MTIxMDAwMDAwMFowWzELMAkG
# A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAvBgNVBAMTKEds
# b2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gU0hBMzg0IC0gRzQwggIiMA0GCSqG
# SIb3DQEBAQUAA4ICDwAwggIKAoICAQDwAuIwI/rgG+GadLOvdYNfqUdSx2E6Y3w5
# I3ltdPwx5HQSGZb6zidiW64HiifuV6PENe2zNMeswwzrgGZt0ShKwSy7uXDycq6M
# 95laXXauv0SofEEkjo+6xU//NkGrpy39eE5DiP6TGRfZ7jHPvIo7bmrEiPDul/bc
# 8xigS5kcDoenJuGIyaDlmeKe9JxMP11b7Lbv0mXPRQtUPbFUUweLmW64VJmKqDGS
# O/J6ffwOWN+BauGwbB5lgirUIceU/kKWO/ELsX9/RpgOhz16ZevRVqkuvftYPbWF
# +lOZTVt07XJLog2CNxkM0KvqWsHvD9WZuT/0TzXxnA/TNxNS2SU07Zbv+GfqCL6P
# SXr/kLHU9ykV1/kNXdaHQx50xHAotIB7vSqbu4ThDqxvDbm19m1W/oodCT4kDmcm
# x/yyDaCUsLKUzHvmZ/6mWLLU2EESwVX9bpHFu7FMCEue1EIGbxsY1TbqZK7O/fUF
# 5uJm0A4FIayxEQYjGeT7BTRE6giunUlnEYuC5a1ahqdm/TMDAd6ZJflxbumcXQJM
# YDzPAo8B/XLukvGnEt5CEk3sqSbldwKsDlcMCdFhniaI/MiyTdtk8EWfusE/VKPY
# dgKVbGqNyiJc9gwE4yn6S7Ac0zd0hNkdZqs0c48efXxeltY9GbCX6oxQkW2vV4Z+
# EDcdaxoU3wIDAQABo4IBKTCCASUwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQI
# MAYBAf8CAQAwHQYDVR0OBBYEFOoWxmnn48tXRTkzpPBAvtDDvWWWMB8GA1UdIwQY
# MBaAFK5sBaOTE+Ki5+LXHNbH8H/IZ1OgMD4GCCsGAQUFBwEBBDIwMDAuBggrBgEF
# BQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyNjA2BgNVHR8E
# LzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL3Jvb3QtcjYuY3Js
# MEcGA1UdIARAMD4wPAYEVR0gADA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5n
# bG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQwFAAOCAgEAf+KI
# 2VdnK0JfgacJC7rEuygYVtZMv9sbB3DG+wsJrQA6YDMfOcYWaxlASSUIHuSb99ak
# DY8elvKGohfeQb9P4byrze7AI4zGhf5LFST5GETsH8KkrNCyz+zCVmUdvX/23oLI
# t59h07VGSJiXAmd6FpVK22LG0LMCzDRIRVXd7OlKn14U7XIQcXZw0g+W8+o3V5SR
# GK/cjZk4GVjCqaF+om4VJuq0+X8q5+dIZGkv0pqhcvb3JEt0Wn1yhjWzAlcfi5z8
# u6xM3vreU0yD/RKxtklVT3WdrG9KyC5qucqIwxIwTrIIc59eodaZzul9S5YszBZr
# GM3kWTeGCSziRdayzW6CdaXajR63Wy+ILj198fKRMAWcznt8oMWsr1EG8BHHHTDF
# UVZg6HyVPSLj1QokUyeXgPpIiScseeI85Zse46qEgok+wEr1If5iEO0dMPz2zOpI
# J3yLdUJ/a8vzpWuVHwRYNAqJ7YJQ5NF7qMnmvkiqK1XZjbclIA4bUaDUY6qD6mxy
# YUrJ+kPExlfFnbY8sIuwuRwx773vFNgUQGwgHcIt6AvGjW2MtnHtUiH+Pvafnzka
# rqzSL3ogsfSsqh3iLRSd+pZqHcY8yvPZHL9TTaRHWXyVxENB+SXiLBB+gfkNlKd9
# 8rUJ9dhgckBQlSDUQ0S++qCV5yBZtnjGpGqqIpswggVHMIIEL6ADAgECAg0B8kBC
# QM79ItvpbHH8MA0GCSqGSIb3DQEBDAUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24g
# Um9vdCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9i
# YWxTaWduMB4XDTE5MDIyMDAwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UE
# CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkdsb2JhbFNpZ24x
# EzARBgNVBAMTCkdsb2JhbFNpZ24wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCVB+hzymb57BTKezz3DQjxtEULLIK0SMbrWzyug7hBkjMUpG9/6SrMxrCI
# a8W2idHGsv8UzlEUIexK3RtaxtaH7k06FQbtZGYLkoDKRN5zlE7zp4l/T3hjCMgS
# UG1CZi9NuXkoTVIaihqAtxmBDn7EirxkTCEcQ2jXPTyKxbJm1ZCatzEGxb7ibTIG
# ph75ueuqo7i/voJjUNDwGInf5A959eqiHyrScC5757yTu21T4kh8jBAHOP9msndh
# fuDqjDyqtKT285VKEgdt/Yyyic/QoGF3yFh0sNQjOvddOsqi250J3l1ELZDxgc1X
# kvp+vFAEYzTfa5MYvms2sjnkrCQ2t/DvthwTV5O23rL44oW3c6K4NapF8uCdNqFv
# VIrxclZuLojFUUJEFZTuo8U4lptOTloLR/MGNkl3MLxxN+Wm7CEIdfzmYRY/d9XZ
# kZeECmzUAk10wBTt/Tn7g/JeFKEEsAvp/u6P4W4LsgizYWYJarEGOmWWWcDwNf3J
# 2iiNGhGHcIEKqJp1HZ46hgUAntuA1iX53AWeJ1lMdjlb6vmlodiDD9H/3zAR+YXP
# M0j1ym1kFCx6WE/TSwhJxZVkGmMOeT31s4zKWK2cQkV5bg6HGVxUsWW2v4yb3BPp
# DW+4LtxnbsmLEbWEFIoAGXCDeZGXkdQaJ783HjIH2BRjPChMrwIDAQABo4IBJjCC
# ASIwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFK5s
# BaOTE+Ki5+LXHNbH8H/IZ1OgMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i
# 3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmds
# b2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMEcGA1UdIARAMD4wPAYEVR0gADA0
# MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0
# b3J5LzANBgkqhkiG9w0BAQwFAAOCAQEASaxexYPzWsthKk2XShUpn+QUkKoJ+cR6
# nzUYigozFW1yhyJOQT9tCp4YrtviX/yV0SyYFDuOwfA2WXnzjYHPdPYYpOThaM/v
# f2VZQunKVTm808Um7nE4+tchAw+3TtlbYGpDtH0J0GBh3artAF5OMh7gsmyePLLC
# u5jTkHZqaa0a3KiJ2lhP0sKLMkrOVPs46TsHC3UKEdsLfCUn8awmzxFT5tzG4mE1
# MvTO3YPjGTrrwmijcgDIJDxOuFM8sRer5jUs+dNCKeZfYAOsQmGmsVdqM0LfNTGG
# yj43K9rE2iT1ThLytrm3R+q7IK1hFregM+Mtiae8szwBfyMagAk06TGCA0kwggNF
# AgEBMG8wWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2Ex
# MTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gU0hBMzg0IC0g
# RzQCEAHCnHr0eqYCWA6vMrEjsR0wCwYJYIZIAWUDBAIBoIIBLTAaBgkqhkiG9w0B
# CQMxDQYLKoZIhvcNAQkQAQQwKwYJKoZIhvcNAQk0MR4wHDALBglghkgBZQMEAgGh
# DQYJKoZIhvcNAQELBQAwLwYJKoZIhvcNAQkEMSIEIB5D9dmkDYnRNeY72TreYq4H
# Zgiv03myoytnQ74B7xqsMIGwBgsqhkiG9w0BCRACLzGBoDCBnTCBmjCBlwQgr4Ax
# 7W7LORRESJW9Cx0M6xKVlNteDCxt9r5ysSVCR9AwczBfpF0wWzELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gU0hBMzg0IC0gRzQCEAHCnHr0eqYCWA6vMrEj
# sR0wDQYJKoZIhvcNAQELBQAEggGALOY08HqrRXtfZm9qGpHHdxctEE/stGhUZVCL
# WO9yoLe72bsiv5ZTeTvBvlLnzLdhm2O3hPHNcj/rYKkNIuY4X5Az8pONFAkOn9X3
# jsoozE8ERbbaECtANRsJpkz5PO/PK1wW5PnjyIzCr301zXnzjY821Z0qPPubcUns
# Hp7gT8vF0c757LAgfCD3ss85K/ZmELuHlnQnJXC1G2LgS2fg3Tc1MlmTxYRbRGHt
# YNw6Y3cm3frx1AEDY0++tyOef/HmDTAlR2xpsjO77GmKtGbEhbuv/2jrEarxN0Tn
# 31HvAoLPBZmfqh1fOE4HOsDjPrt4hgJfnicA5K0wR5nZlhbisXSQPmcP625v/KIX
# VT8tdg9xDGdV7eQ6RHp1y6lDbpOcjnsPnbRKYQuTAQBuA87AZJ5cHc66B/7YDCQo
# Uijk3XYzngTlfW6PbeAt0xpaxagkIVMzKZ8nngx43nRUHGrPasClFtFKIASR3upr
# II+PXi0wLJc9AqEEKZHFbgv0yube
# SIG # End signature block
