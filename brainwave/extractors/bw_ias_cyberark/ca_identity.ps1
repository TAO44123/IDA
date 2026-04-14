param (
    [string]$Identity_Tenant_URL,
    [string]$CredentialFilePath,
    [string]$outputDirectory,
    [ValidateSet('Continue', 'Ignore', 'Inquire', 'SilentlyContinue', 'Stop', 'Suspend')]
    [string]$ErrAction = 'Continue'
)

# Constants
$RetryCount = 5
$DelaySeconds = 5
$ADGroupsCsvPath = $outputDirectory+"\Identity_ADGroup.csv"
$ADUsersCsvPath = $outputDirectory+"\Identity_ADUser.csv"
$OrgCsvPath = $outputDirectory+"\Identity_Organizations.csv"
$OrgAdminCsvPath = $outputDirectory+"\Identity_OrgAdmin.csv"
$CDUsersCsvPath = $outputDirectory+"\Identity_CDUser.csv"
$UsersCsvPath = $outputDirectory+"\Identity_Users.csv"
$DSUsersCsvPath = $outputDirectory+"\Identity_DSUsers.csv"
$DSGroupsCsvPath = $outputDirectory+"\Identity_DSGroups.csv"
$ProxyCsvPath = $outputDirectory+"\Identity_Proxy.csv"
$TenantCsvPath = $outputDirectory+"\Identity_Tenant.csv"
$RolesCsvPath = $outputDirectory+"\Identity_Roles.csv"
$RoleMembersCsvPath = $outputDirectory+"\Identity_RoleMembers.csv"
$RolesAdminRightsCsvPath = $outputDirectory+"\Identity_RolesAdminRights.csv"
$DirectoryServicesCsvPath = $outputDirectory+"\Identity_DirectoryServices.csv"
$FederationsCsvPath = $outputDirectory+"\Identity_Federations.csv"
$FederationsJsonPath = $outputDirectory+"\Identity_Federations.json"
$RepositoryMappingPath = $outputDirectory+"\Identity_Repository_Mapping.csv"

$LogFilePath = "script_log.txt"

# Function to log messages
function Write-Log {
    param (
        [string]$Message,
        [string]$LogLevel
    )

    $LogEntry = "[$(Get-Date)] [$LogLevel] $Message"
    $LogEntry | Out-File -Append -FilePath $LogFilePath
    Write-Host $LogEntry
}

# Function to authenticate and get the token
function Get-AuthToken {
    param (
        [string]$Tenant_URL,
        [pscredential]$Credential
    )

    # $URL_Logon = "$Tenant_URL/oauth2/platformtoken"
    $URL_Logon = "$Tenant_URL/oauth2/token/radiant_endpoint"
    Write-Log $URL_Logon "Info"
    $headers = @{
        "Content-Type" = "application/x-www-form-urlencoded"
    }
    $logonBody = "scope=all&grant_type=client_credentials&client_id=$($Credential.GetNetworkCredential().UserName)&client_secret=$($Credential.GetNetworkCredential().Password)"

    Write-Log "Authenticating and getting token..." "Info"
    
    try {
        $response = Invoke-RestMethod -Method Post -Uri $URL_Logon -Body $logonBody -Headers $headers
        return $response.access_token
    }
    catch {
        Write-Log "Authentication failed. Error details: $_" "Error"
        Handle-Error -ErrorMessage $_
    }
}

# Function to make API calls with token handling
function Invoke-ApiCall {
    param (
        [string]$URL,
        [string]$Token,
        [object]$Body
    )

    $headers = @{
        "Content-Type"  = "application/json"
        "Authorization" = "Bearer $Token"
    }

    #Write-Log "Making API call to $URL..." "Info"

    try {
        $response = Invoke-RestMethod -Method Post -Uri $URL -Body ($Body | ConvertTo-Json) -Headers $headers
        if ($response.success) {
            if ($response.Result.GetType().Name -eq "Object[]") {
                if ($response.Result.Coun -eq 0) {
                    return $();
                }
                else {
                    return $response.Result
                }            
            }
            else {
                if ($response.Result.FullCount -eq 0) {
                    return $();
                }
                else {
                    return $response.Result.Results.Row
                }
            }
        }
        elseif ($response.ErrorCode -eq 401) {
            Write-Log "API call returned 401. Attempting to refresh token..." "Info"
            return $null
        }
        else {
            Write-Log "API call failed. Error details: $response.Message" "Error"
            return $null
        }
    }
    catch {
        Write-Log "API call failed. Error details: $_" "Error"
        Handle-Error -ErrorMessage $_
    }
}

# Function to handle errors based on the specified error action
function Handle-Error {
    param (
        [string]$ErrorMessage
    )

    Write-Log "Handling error..." "Info"

    switch ($ErrAction) {
        'Continue' {
            Write-Host "Continuing script execution..."
        }
        'Ignore' {
            Write-Host "Ignoring the error..."
        }
        'Inquire' {
            $userChoice = Read-Host "An error occurred: $ErrorMessage. Do you want to continue? (Y/N)"
            if ($userChoice -ne 'Y') {
                Write-Host "Script execution stopped."
                exit
            }
        }
        'SilentlyContinue' {
            Write-Host "Continuing without displaying error message..."
        }
        'Stop' {
            Write-Host "Script execution stopped due to an error."
            exit
        }
        'Suspend' {
            Write-Host "Script execution suspended. Enter 'Exit' to exit the script."
            Suspend
        }
        default {
            Write-Host "Invalid error action. Exiting script."
            exit
        }
    }
}

# Function to export data to CSV
function Export-ToCsv {
    param (
        [string]$Path,
        [object]$Data
    )

    Write-Log "Exporting data to $Path..." "Info"

    try {
        if ($Data -ne $null) {
            $Data | Export-Csv -Path $Path -NoTypeInformation -Force
        }
    }
    catch {
        Write-Log "Export to CSV failed. Error details: $_" "Error"
        Handle-Error -ErrorMessage $_
    }
}

# Function to get all pages of data with backoff strategy
function Get-AllPagesWithRetry {
    param (
        [string]$URL,
        [string]$Token,
        [object]$Body
    )

    $retryCount = $RetryCount
    $allResult = @()
    $result = Invoke-ApiCall -URL $URL -Token $Token -Body $Body
    $allResult += $result
    while ($null -ne $result -and $result.Count -eq $Body["Args"]["PageSize"] ) {
        $Body["Args"]["PageNumber"] ++
        if ($null -ne $result) {
            $allResult += $result
        }
        $result = Invoke-ApiCall -URL $URL -Token $Token -Body $Body
        <#
        if ($result -eq $null) {
            # Retry logic
            $retryCount--
            Write-Log "Retrying API call. Retries left: $retryCount" "Info"
            Start-Sleep -Seconds $DelaySeconds
            
            # Refresh the token
            $Token = Get-AuthToken -Identity_Tenant_URL $Identity_Tenant_URL -Credential $Credential
            }
            #>
    }    
    return $allResult
}

# Function to get all pages of data for role members with backoff strategy
function Get-AllRoleMembersWithRetry {
    param (
        [string]$URL,
        [string]$Token,
        [string]$RoleID,
        [string]$RoleName
    )

    $retryCount = $RetryCount
    $result = $null

    $body = @{ "name" = $RoleID }
    $result = Invoke-ApiCall -URL $URL -Token $Token -Body $body

    <#
    while ($retryCount -gt 0 -and $result -eq $null) {
        if ($result -eq $null) {
            # Retry logic
            $retryCount--
            Write-Log "Retrying API call. Retries left: $retryCount" "Info"
            Start-Sleep -Seconds $DelaySeconds

            # Refresh the token
            $Token = Get-AuthToken -Identity_Tenant_URL $Identity_Tenant_URL -Credential $Credential
        }
    }
    #>

    if ($result -ne $null) {
        foreach ($item in $result) {
            $item | Add-Member -MemberType NoteProperty -Name "RoleID" -Value $RoleID
            $item | Add-Member -MemberType NoteProperty -Name "RoleName" -Value $RoleName
        }
    }

    return $result
}

function Get-AllOrganizationAdminsWithRetry {
    param (
        [string]$URL,
        [string]$Token,
        [string]$OrgID,
        [string]$OrgName
    )

    $retryCount = $RetryCount
    $result = $null

    $body = @{ "OrgId" = $OrgID }
    $result = Invoke-ApiCall -URL $URL -Token $Token -Body $body

    <#
    while ($retryCount -gt 0 -and $result -eq $null) {
        if ($result -eq $null) {
            # Retry logic
            $retryCount--
            Write-Log "Retrying API call. Retries left: $retryCount" "Info"
            Start-Sleep -Seconds $DelaySeconds

            # Refresh the token
            $Token = Get-AuthToken -Identity_Tenant_URL $Identity_Tenant_URL -Credential $Credential
        }
    }
    #>

    if ($result -ne $null) {
        foreach ($item in $result) {
            $item | Add-Member -MemberType NoteProperty -Name "OrgID" -Value $OrgID
            $item | Add-Member -MemberType NoteProperty -Name "OrgName" -Value $OrgName
        }
    }

    return $result
}

function Get-AllData {
    param (
        [string]$URL,
        [string]$Token
    )
    $result = Invoke-ApiCall -URL $URL -Token $Token     
    return $result    
}

# Function to get all pages of data for administrative rights with backoff strategy
function Get-AllAdminRightsWithRetry {
    param (
        [string]$URL,
        [string]$Token,
        [string]$RoleID,
        [string]$RoleName        
    )

    $retryCount = $RetryCount
    $result = $null
    $body = @{ "role" = $RoleID }
    $result = Invoke-ApiCall -URL $URL -Token $Token -Body $body

    <#
    while ($retryCount -gt 0 -and $result -eq $null) {
        if ($result -eq $null) {
            # Retry logic
            $retryCount--
            Write-Log "Retrying API call. Retries left: $retryCount" "Info"
            Start-Sleep -Seconds $DelaySeconds

            # Refresh the token
            $Token = Get-AuthToken -Identity_Tenant_URL $Identity_Tenant_URL -Credential $Credential
        }
    }
    #>

    if ($null -ne $result) {
        foreach ($item in $result) {
            $item | Add-Member -MemberType NoteProperty -Name "RoleID" -Value $RoleID
            $item | Add-Member -MemberType NoteProperty -Name "RoleName" -Value $RoleName
        }
    }

    return $result
}

# Main script

# Importing credentials from file
try {
    $Credential = Import-CliXml -Path $CredentialFilePath
}
catch {
    Write-Log "Importing credentials failed. Error details: $_" "Error"
    Handle-Error -ErrorMessage $_
}

# Authentication
$Token = Get-AuthToken -Tenant_URL $Identity_Tenant_URL -Credential $Credential

# Mapping File
Write-Log "Creating $RepositoryMappingPath..." "Info"
$MappingHeaders = "identityrepo", "entraidrepo"
$MappingHeaders -join ";" | Out-File -FilePath $RepositoryMappingPath -Encoding UTF8
$FirstLine = "CDS", "CAIdentity"
$FirstLine -join ";" |  Out-File -FilePath $RepositoryMappingPath -Append -Encoding UTF8

# List Federations
$FederationsData = @()
$FederationsScript = "$Identity_Tenant_URL/Federation/GetFederations"
$FederationsData = Get-AllData -URL $FederationsScript -Token $Token
#$csv = ($FederationsData | ConvertFrom-Json).results | ConvertTo-Csv -NoTypeInformation 
#Export-ToCsv -Path $FederationsCsvPath -Data $FederationsData
$FederationsData | ConvertTo-Json -depth 100 | Out-File $FederationsJsonPath

# List DirectoryServices
$DirectoryServicesData = @()
$DirectoryServicesScript = "$Identity_Tenant_URL/core/GetDirectoryServices"
$DirectoryServicesData = Get-AllData -URL $DirectoryServicesScript -Token $Token
Export-ToCsv -Path $DirectoryServicesCsvPath -Data $DirectoryServicesData

# List users
$UsersScript = "Select * from Users ORDER BY DisplayName COLLATE NOCASE"
$UsersArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "Username"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$UsersBody = @{
    Script = $UsersScript
    Args   = $UsersArgs
}
$UsersData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $UsersBody
Export-ToCsv -Path $UsersCsvPath -Data $UsersData

# List DSUsers
$UsersScript = "Select * from DSUsers ORDER BY DisplayName COLLATE NOCASE"
$UsersArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "InternalName"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$DSUsersBody = @{
    Script = $UsersScript
    Args   = $UsersArgs
}
$DSUsersData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $DSUsersBody
Export-ToCsv -Path $DSUsersCsvPath -Data $DSUsersData

# List ADGroup
$ADGroupsScript = "Select * from ADGroup ORDER BY Name COLLATE NOCASE"
$ADGroupsArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "Name"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$ADGroupsBody = @{
    Script = $ADGroupsScript
    Args   = $ADGroupsArgs
}
$ADGroupsData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $ADGroupsBody
Export-ToCsv -Path $ADGroupsCsvPath -Data $ADGroupsData

# List ADUser
$ADUsersScript = "Select * from ADUser ORDER BY Name COLLATE NOCASE"
$ADUsersArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "Name"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$ADUsersBody = @{
    Script = $ADUsersScript
    Args   = $ADUsersArgs
}
$ADUsersData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $ADUsersBody
Export-ToCsv -Path $ADUsersCsvPath -Data $ADUsersData

# List Organizations
$OrgArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
    Format     = "Query"
}
$OrgBody = @{
    Args   = $OrgArgs
}

$OrgData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/Org/ListAll" -Token $Token -Body $OrgBody
Export-ToCsv -Path $OrgCsvPath -Data $OrgData

# List Organization Administrators

$OrgAdminData = @()
foreach ($org in $OrgData) {
    Write-Log "List $($org.Name) organisation administrators ..." "Info"
    $OrgAdminScript = "$Identity_Tenant_URL/Org/GetAdministrators"
    $Result = Get-AllOrganizationAdminsWithRetry -URL $OrgAdminScript -Token $Token -OrgID $org.ID -OrgName $org.Name
    if ($null -ne $Result) {
        $OrgAdminData += $Result
    }
    
}
Export-ToCsv -Path $OrgAdminCsvPath -Data $OrgAdminData

# List CDUser
$CDUsersScript = "Select * from CDUser ORDER BY Name COLLATE NOCASE"
$CDUsersArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "Name"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$CDUsersBody = @{
    Script = $CDUsersScript
    Args   = $CDUsersArgs
}
$CDUsersData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $CDUsersBody
Export-ToCsv -Path $CDUsersCsvPath -Data $CDUsersData

# List DSGroups
$DSGroupsScript = "Select * from DSGroups ORDER BY DisplayName COLLATE NOCASE"
$DSGroupsArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "DisplayName"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$DSGroupsBody = @{
    Script = $DSGroupsScript
    Args   = $DSGroupsArgs
}
$DSGroupsData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $DSGroupsBody
Export-ToCsv -Path $DSGroupsCsvPath -Data $DSGroupsData

# List Proxy
$ProxysScript = "Select * from Proxy ORDER BY MachineName COLLATE NOCASE"
$ProxysArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "MachineName"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$ProxysBody = @{
    Script = $ProxysScript
    Args   = $ProxysArgs
}
$ProxysData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $ProxysBody
Export-ToCsv -Path $ProxyCsvPath -Data $ProxysData

# List Tenant
$TenantsScript = "Select * from Tenant ORDER BY CompanyName COLLATE NOCASE"
$TenantsArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "CompanyName"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$TenantsBody = @{
    Script = $TenantsScript
    Args   = $TenantsArgs
}
$TenantsData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $TenantsBody
Export-ToCsv -Path $TenantCsvPath -Data $TenantsData

# List roles
$RolesScript = "Select * from Role ORDER BY Name COLLATE NOCASE"
$RolesArgs = @{
    PageNumber = 1
    PageSize   = 100
    Limit      = 100000
    SortBy     = "Name"
    Ascending  = $true
    Direction  = "ASC"
    Caching    = -1
}
$RolesBody = @{
    Script = $RolesScript
    Args   = $RolesArgs
}
$RolesData = Get-AllPagesWithRetry -URL "$Identity_Tenant_URL/RedRock/query" -Token $Token -Body $RolesBody
Export-ToCsv -Path $RolesCsvPath -Data $RolesData

# List role members
$RoleMembersData = @()
foreach ($role in $RolesData) {
    Write-Log "List $($role.Name) role members ..." "Info"
    $RoleMembersScript = "$Identity_Tenant_URL/Roles/GetRoleMembers"
    $Result = Get-AllRoleMembersWithRetry -URL $RoleMembersScript -Token $Token -RoleID $role.ID -RoleName $role.Name
    if ($null -ne $Result) {
        $RoleMembersData += $Result
    }
    
}
Export-ToCsv -Path $RoleMembersCsvPath -Data $RoleMembersData

# List roles AdministrativeRights
$RolesAdminRightsData = @()
foreach ($role in $RolesData) {
    Write-Log "List $($role.Name) RolesAdminRightsData ..." "Info"
    $RolesAdminRightsScript = "$Identity_Tenant_URL/core/GetAssignedAdministrativeRights"
    $Result = Get-AllAdminRightsWithRetry -URL $RolesAdminRightsScript -Token $Token -RoleID $role.ID -RoleName $role.Name
    if ($null -ne $Result) {
        $RolesAdminRightsData += $Result    
    }
}
Export-ToCsv -Path $RolesAdminRightsCsvPath -Data $RolesAdminRightsData


Write-Log "Script execution completed successfully." "Info"

# SIG # Begin signature block
# MIIuuQYJKoZIhvcNAQcCoIIuqjCCLqYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDyeKLOmR9G17GK
# wqKFqPGIDIe40yNehGzw7v5PCwKsQqCCFCQwggVyMIIDWqADAgECAhB2U/6sdUZI
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgHpRL
# 0a0S4fQ1FRB70zcOBzMeraiE9KcC0Ynrt1jA9+kwDQYJKoZIhvcNAQEBBQAEggIA
# UpXelxKqBK/gIMh2kEm/2ayxn0fMFPhSrj5k2jLqMM8pZITqKDYXCNanGmHfARwr
# O9xtMuqp+FO0kw3Kt30tXg1XNSZ6pPVBaGsStu8xzmLT//zWZHCJppq+Qoux5qVO
# d5XtrwmE/Xk+fU3lwAlAMH450Hyt+zKxgjdU1TqSfn990CwEOMtJRb/2lhps1DYM
# SAIQEtPtKhU3nIGvN1+OrH7aIWvSn2d1YQfoI6Y+W9UEEPO2MMSez2Xn8d5FhrFG
# YPnz71e/tCQcOx8qu2UaKYVaNvlUkjMvnMaunVtr9jaiLKyIOgqXd5JdQpUZfE2f
# kjCOdVv4Xx0W2nskAzRCPuVAJzMzlLiGEQ2/BkdvDY3V5NKAI/0KkUP+Dl8wi/IX
# USYFdniXH4v/0wyMc1UDzEsxMHDzcSBSiOqmcAocgi8AgGT6lvwGxdjXwD87FHi6
# GsbOyxhyRReE2U1HrSY3kqszwrqp/MutjQ6TBtzxTYXfFwfOj6ouASKMVn6euf6/
# n2BrYq0x1Gk9FvOAhHcF5N6kvZGY1VTu2ltdtJFVVJpAL1eSgvs1bMzv873/EWRM
# Jvvsoj+7TGPcpil3lIhHgUW2Wvpg+v8O6GfnIe49iufP67tUwhByNUNu0cqqUTbq
# 296bquBnpQlHIBk/RT2BdlAs/oytSoB24A8NtmspY9KhghbJMIIWxQYKKwYBBAGC
# NwMDATGCFrUwghaxBgkqhkiG9w0BBwKgghaiMIIWngIBAzENMAsGCWCGSAFlAwQC
# ATCB5QYLKoZIhvcNAQkQAQSggdUEgdIwgc8CAQEGCSsGAQQBoDICAzAxMA0GCWCG
# SAFlAwQCAQUABCA+fTNp97ZVdWBGau3i+AtAnzsKP++Khxe12agztWgc6QIUWStz
# zqj1SpNLjkxbSEOhjxsNWFAYDzIwMjQxMjA2MTMzMzM5WjADAgEBoGCkXjBcMQsw
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
# DQEBCwUAMC8GCSqGSIb3DQEJBDEiBCBeLiYsY96prKMUkcWLesY0r8dEqHTR2z7C
# v2FwKM23ujCBsAYLKoZIhvcNAQkQAi8xgaAwgZ0wgZowgZcEIAt5ojmuQhCN71az
# VAW/j82OWadLhO7i3sPZccHqFzTsMHMwX6RdMFsxCzAJBgNVBAYTAkJFMRkwFwYD
# VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIFRpbWVz
# dGFtcGluZyBDQSAtIFNIQTM4NCAtIEc0AhABGXV0ccmS10TfpZbruXAVMA0GCSqG
# SIb3DQEBCwUABIIBgKYXJMgbf0OomRDbd9Pca67Cg3O/DbQcyU6HNcVf5sdGW2Nt
# MqRj3AloVdkfrW8HTGxNCE7wJV8zxkqDVRa16K1y6dCWAwXDLTmB7fB5YfIb0GHv
# sB7GH9cYHsKfZcgM/b1XvbdPa4awJfxUO5zzaDdD5LxrAnKRsXZG//7+veuWVD55
# GORruNKfTmBfe5rooI7BvVVQRJqmxFqK9Cm/IY+bBWbpefqwB1Fq0Kf1Ne+ceA0X
# RikxBUJBk/tgRci6/NXqM8FOg6e5hj6szFsdiwoJsZO9i/tqExJJ5sGzRc/ml8SD
# /w/LQ86ZCNpvEQ11phquUT/7QP3NafqyhTXEtv/witEZIata77Ok4tMX99PQGOqb
# N/cpzRi+KdFbMBGOTTMfepYJk1+ZVPFhVO703z7nm6444eHJUZnlXy1XB2LFubl1
# yQZrai1FuA+PcJX2kUKanw5jzJfb5KfvNhFUVEEQKgGFqCtLE8N6RmW8ivnkQeo5
# 20UDJfdRdJEatzL81g==
# SIG # End signature block
