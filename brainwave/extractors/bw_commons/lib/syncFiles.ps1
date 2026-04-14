<#
.SYNOSPSIS
This script allows to synchronize (input parameters and output results) with the background extraction process through an openICF connector 
- Retrieves files matching a given pattern from extraction output folder to the openICF ouput folder,
- moves the retrieved files to an archive folder so they are not processed twice
- Passes on optional configuration file to background extraction batch

NB: this script is only supposed to be run through an OpenICF Connector
#>


#
# Parameters to send by the connector to the script
#  
# [String]@config.connectorSearchDir Full directory path of files to retrieve on the connector server  
# [String]@config.connectorArchiveDir Full path of archive directory to move files once retrieved
# [String]@config.connectorParamsDir Path to directory containing configuration files
# [String]@config.filePattern windows-like pattern of files to retrieve from search directory
# [File]@config.configFile Path of configuration file to move to the parameters directory
# [String]@config.configDestFile name of configuration file after copy
# [boolean]@config.simulate Simulate actions


$connectorEnabled = $Connector -ne $Null;

#TODO Move utility functions to PS Module 
#Remove-Module ConnectorLib
#Import-Module "..\ConnectorLib.psm1"

function Send-ConnectorMessage($msg , $level)
{
	#level can be: @Error	@Warning	@Log	@Info	@Debug	@Message
	if($Connector -ne $null){
	    if ($level -eq $null) {
	       $level = '@Message'; 
	    }		
		$d=(get-date).millisecond
		$result = @{
		  "__UID__" = $connCounter; 
		  "__NAME__" = $connCounter;
		  "__event_type__"=$level;
		  "__event_when__"="$d"; 
		  "__event_message__" = $msg;
		  "__event_line__"="-1";
		  "__event_script__"=$__SiloName__+"$"+ $__ConnectorName__+"$"+ $__ScriptName__
		}    	
		$script:connCounter+=1
		if (!$Connector.Result.Process($result)) {					
			break
		}
	}
    else{
		Write-Host $msg
	}
}


# assigns each entry Options.Options to a variable with the same name
function ProcessConnectorOptions( ) {

  if ($Connector -ne $null) {
      $opts = $Connector.Options.Options; 
 

     foreach ($key in $opts.Keys) {
           $val = $opts.Get_Item($key)
           #assignement expression eg. $filePattern = $val 
           $exp = "`$script:$key = `$val"
           Invoke-Expression $exp  
           Send-ConnectorMessage "Script Parameter $key = $val"     
     }
  }
  else {
     write-Host "This function can only be called within a connector connexion"
  }
 
}


#
# Reading the file with stream reader
#
Function Send-ConnectorFile($pFilePath, $pFilename) {
	$bufferSize = 65536	
    $file = Join-Path -Path $pFilePath $pFilename;	
	$stream = [System.IO.File]::OpenRead($file);    	
    	
	While ($stream.Position -lt $stream.Length) {  
        [byte[]] $buffer = New-Object byte[] $bufferSize;  			
		$bytesRead = $stream.Read($buffer, 0, $bufferSize);  		
		Process-Copy $pFilename $buffer $bytesRead;	
	};
	$stream.Close();
}

#
# Send byte array over connector server
#
Function Process-Copy($pFilename, $pBuffer, $pBytesRead) {
	#__bytesdata__ contain the buffer (array of bytes)
	#__outputstream__ contain destination file name
	#__bytesRead__ contain number of bytes read into the buffer
	#__UID__ , __NAME__ are mandatory and have to be unique (ICF spec)
$type = $pFilename.getType()

  		
    $result = @{
		"__UID__"			= $connCounter;
		"__NAME__"			= $connCounter;
		"__bytesdata__"		= $pBuffer;
		"__outputstream__"	= $pFilename;
		"__outputtype__"	= "__bytes_copy__";
		"__bytesRead__"		= $pBytesRead;
		"__event_type__"	= "Data";
	};

    $script:connCounter += 1;
    If (!$Connector.Result.Process($result)) {					
    	Break;
        
    }
}


function moveCfgFile( $path, $file, $destFileName) {
  
    $destFile = Join-Path $path $destFileName
    if (-not $simulate) {
		  if (-not (test-path $path -pathType Container)){
		     new-item $path -itemType directory
		   }    
            Move-Item $file $destFile -force   
    } 
    Send-ConnectorMessage "Moving '$file' to '$destFile'" ;     
}

#
#Script Main Body
#

$connCounter = 0;

#Process Connector.Options.Options
ProcessConnectorOptions;

#Send-ConnectorMessage "filePattern=$filePattern connectorSearchDir=$connectorSearchDir paramsPath=$paramsPath configFile=$configFile"

if (-not $connectorEnabled) {
   Write-Error "This script can only be executed through an openICF connector";
   Exit 1
}

$Error.Clear();

Try {

	
	# Copy config File to param Path
    if (($connectorParamsDir -ne $Null) -and ($configFile -ne $Null) -and ($configDestFile -ne $Null)){
       moveCfgFile $connectorParamsDir $configFile $configDestFile
    }
    
	$nbFiles = 0;

	send-ConnectorMessage "Search files matching pattern '$filePattern' in '$connectorSearchDir'";
	ForEach ($file In Get-ChildItem -Path $connectorSearchDir -Filter $filePattern  | Sort-Object CreationTime) {
        $fileSize = [int]($file.Length / 1024); 
	    If (-not $simulate) {  
            send-ConnectorMessage  "Retrieving file: $file ($fileSize KB)." '@Message';         
			Send-ConnectorFile $connectorSearchDir $file.Name;               
            $srcPath = Join-Path $connectorSearchDir $file;
            $destPath = Join-Path $connectorArchiveDir $file;
            Move-Item $srcPath $destPath -force
	    } Else {
		    send-ConnectorMessage  "Simulate retrieving file: $file ($fileSize KB)." '@Message';           
	    }

        $nbFiles +=1
   }
   send-ConnectorMessage "Processed $nbFiles matching file(s)." '@Message';
   Exit 0

} Catch {

	$errorMessage = "Get extraction files failed. '{0}': {1}" -f $_.Exception.GetType().FullName, $_.Exception.Message;
     
	Throw [System.Exception] $errorMessage;
}


