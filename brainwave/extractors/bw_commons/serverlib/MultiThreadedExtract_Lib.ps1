<#
.DESCRIPTION
	This script with run an extraction script in multiple threads

.PARAMETER MaxThreads
    This is the maximum number of threads to run at any given time. If resources are too congested try lowering
    this number.  The default value is 20.
    
.PARAMETER SleepTimer
    This is the time between cycles of the child process detection cycle. The default value is 200ms. If CPU 
    utilization is high then you can consider increasing this delay.  If the child script takes a long time to
    run, then you might increase this value to around 1000 (or 1 second in the detection cycle).

.PARAMETER Timeout
	Stop each thread after this many minutes.  Default: 0.
	WARNING:
	This parameter should be used as a failsafe only.
	Set it for roughly the entire duration you expect for all threads to complete.

.PARAMETER keepOpenOnTimeout
	Do not dispose of timed out tasks or attempt to close the runspace if threads have timed out.
	This will prevent the script from hanging in certain situations where threads become non-responsive,
	at the expense of leaking memory within the PowerShell host.

.PARAMETER LogFile
	Path to a file where we can log results, including run time for each thread, whether it completes, completes with errors, or times out.

example usage

# Load Lib
. .\MultiThreadedExtract_Lib.ps1
runMultithreadedExtractScript "test.ps1"  @( @{ target="T1" ; param1="P11" ; switch1=$true } ; @{ target="T2" ; param1="P21"} ) 

#>

function runMultithreadedExtractScript(
   [string] $scriptName, 
   [hashtable[]] $targetArgumentsList, #array of hashtable
   [string] $extractionReadyPath, #path to move ready extractions
   [string] $targetArgName = "target", #name of the argument that holds the target
   [string] $logPath =$null, 
   [string] $logName =$null,
   [switch] $useEventLog= $False,
   [int]    $maxThreads = 20, 
   [double] $sleepTimer = 200, 
   [double] $timeout = 5,
   [switch] $keepOpenOnTimeout=$false 
)
{

$auditApplicationName = 'Brainwave Extractor';

# Execution timer information
$globalWatch = [system.diagnostics.StopWatch]::startNew();

# Setup log file if specified
$logFile = $Null;
If ($LogPath) {
	$executionDate = ((Get-Date).ToUniversalTime()).ToString("yyyyMMdd");
	$logFilename = $LogName + '-' + $executionDate + '.log';

	$logFile = Join-Path -Path $LogPath $logFilename;
	If (!(Test-Path $logFile)) {
		New-Item -ItemType File -Path $logFile | Out-Null;
		("" | Select Date, Action, Runtime, Status, Details | ConvertTo-Csv -NoTypeInformation -Delimiter ';')[0] | Out-File $logFile;
	}
	# Write initial log entry
	$log = "" | Select Date, Action, Runtime, Status, Details;
	$log.Date = Get-Date;
	$log.Action = 'Batch processing started';
	$log.Runtime = $null;
	$log.Status = 'Started';
	($log | ConvertTo-Csv -Delimiter ';' -NoTypeInformation)[1] | Out-File $logFile -Append;
}
If ($UseEventLog) {
	$message = "Batch processing started";
	Write-EventLog -LogName 'Application' -Source $auditApplicationName -EntryType 'INFO' -Message $message -EventID 3000;
}

$Error.Clear();
$execResult = 0;

[string] $scriptCode = (Get-Content $scriptName) | Out-String


Try {

	# Define the initial Session State (can share information like Import-Module on all script in pool)
	$sessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault();

	# Managed threads pool
	$runspacePool = [RunspaceFactory]::CreateRunspacePool(1, $maxThreads, $sessionState, $host);
	$runspacePool.Open();
	# Array to hold details on each thread 
	$threads = @();

    # create thread for each target
	ForEach ($targetArgs in $targetArgumentsList) {
        $target = $targetArgs.Get_Item($targetArgName)
        

		[scriptblock] $psScript = [ScriptBlock]::Create( $scriptCode );

		# Create a PowerShell thread to execute scripts in parallel
		[System.Management.Automation.PowerShell] $powershellThread = [powershell]::Create();
		Write-Verbose "Starting thread for $target";
		Start-Sleep -Milliseconds $sleepTimer;

		# Add extraction script new PowerShell thread
		$powershellThread.AddScript($psScript) | Out-Null;
        $powershellThread.AddParameters($targetArgs) | Out-Null;
		

		# Add PowerShell thread to managed threads pool
		$powershellThread.runspacePool = $runspacePool;
		$threads += New-Object PSObject -Property @{
			target = $target;
			instance = $powershellThread;
			handle = $powershellThread.BeginInvoke();
			startTime = Get-Date;
			status = 'started';
			details = '';
	   }
	}

	$threadResults = @();
	$executionDone = $true;
         
	# Loop through threads until all finished or timeout exceeded
	While ($executionDone) { 
		$executionDone = $False;
		For ($i=0; $i -lt $threads.count; $i++) { 
			$thread = $threads[$i];
			If ($thread) {				
				# If thread is complete, dispose of it. 
				If ($thread.handle.IsCompleted) { 
					Write-Verbose "Closing thread for $($thread.target)";
					$threadResult = $thread.instance.EndInvoke($thread.handle);
					If ($threadResult.errors -ne 0) {
						$thread.status = 'completedWithErrors';
						$thread.details = $threadResult.errorMessages -Replace '"', "'";
					} ElseIf ($threadResult.warnings -ne 0) {
						$thread.status = 'completedWithWarnings';
						$thread.details = $threadResult.warningMessages -Replace '"', "'";
					} Else {
						$thread.status = 'completed';
					}
					If ($logFile){
						# Setup log object
						$log = "" | select Date, Action, Runtime, Status, Details;
						$log.Action = "Extraction on '$($thread.target)'";
						$log.Date = Get-Date;
						$log.Runtime = "{0} seconds" -f ((Get-Date) - $thread.startTime).TotalSeconds;
						$log.Status = $thread.status;
						$log.Details = $thread.details;
						($log | ConvertTo-Csv -Delimiter ';' -NoTypeInformation)[1] | Out-File $logFile -Append;
					}
					# Append result of this thread
					$threadResults += $threadResult;
					$thread.instance.Dispose();
					$thread.instance = $Null;
					$thread.handle = $Null;
					$threads[$i] = $Null;
				} ElseIf (($timeout -ne 0) -and ((Get-Date) - $thread.startTime).TotalMinutes -gt $timeout) {
					$thread.status = 'timedOut';
					# Thread exceeded max runtime timeout threshold
					If ($UseEventLog) {
						$message = "Extraction aborted for $($thread.target): $timeout minute(s) limit exceeded";
						Write-EventLog -LogName 'Application' -Source $auditApplicationName -EntryType 'Error' -Message $message -EventID 3002;
					}
					If ($logFile) {
						# Setup log object
						$log = "" | select Date, Action, Runtime, Status, Details
						$log.Action = "Extraction on '$($thread.target)'";
						$log.Date = Get-Date;
						$log.Runtime = "{0} seconds" -f ((Get-Date) - $thread.startTime).TotalSeconds;
						$log.Status = $thread.status;
						($log | ConvertTo-Csv -Delimiter ';' -NoTypeInformation)[1] | Out-File $logFile -Append;
					}
					#$thread.instance.Stop();
					$thread.handle = $Null;
					#If (!$keepOpenOnTimeout) {
					$thread.instance.Dispose();
					#}
					$thread.instance = $Null;
					$threads[$i] = $Null;
				} Else {
					# Threads still running, wait again
					$executionDone = $True;
				}
			}
		} 

		# Sleep for specified time before looping again 
		Start-Sleep -Milliseconds $sleepTimer 
	}

	
} Catch {
	$errorMessage = $_.Exception.Message;
	$errorType = $_.Exception.GetType().FullName;
	$message = $errorType + " : " + $errorMessage;
	If ($UseEventLog) {
		Write-EventLog -LogName 'Application' -Source $auditApplicationName -EntryType 'Error' -Message $message -EventID 3002;
	}
	Write-Verbose "Execution failed: $errorMessage";	
	$execResult--;
} Finally {
	If ($runspacePool -ne $Null) {
		# Clean up
		$runspacePool.Close();
		$runspacePool.Dispose();
	}
	# Prevents from memory leaks (DCOM objects and .Net calls)
	[gc]::Collect();
	#
	# @TODO
	#
	# Clean directory if any error occurs
}

$globalWatch.Stop();
Write-Verbose "Total execution time $($globalWatch.Elapsed)";
$totalExecutionTime = $globalWatch.Elapsed.ToString();

If ($logFile) {
	# Write final log entry
	$log = "" | Select Date, Action, Runtime, Status, Details;
	$log.Date = Get-Date;
	$log.Action = 'Batch processing completed';
	$log.Runtime = $totalExecutionTime;
	$log.Status = 'Finished';
	If ($execResult -ne 0) {
		$log.Details = 'Some extractions have errors';
	}
	($log | ConvertTo-Csv -Delimiter ';' -NoTypeInformation)[1] | Out-File $logFile -Append;
}
If ($UseEventLog) {
	$message = "Batch processing completed in $totalExecutionTime";
	Write-EventLog -LogName 'Application' -Source $auditApplicationName -EntryType 'INFO' -Message $message -EventID 3001;
}

 #create dir if does not exist
If (-not (Test-Path $extractionReadyPath) ){
  New-Item $extractionReadyPath -type directory;
}
ForEach ($result in $threadResults) {
	# Move extractions to ready directory
	Move-Item $result.filename $extractionReadyPath;
}

Return $threadResults
# Exit($execResult)


}

# runMultithreadedScript -scriptName "test.ps1" -extractionReadyPath "C:\AuditLogs\ADEvents\out\ready"  -targetArgumentsList  @( @{ target="T1" ; param1="P11" ; switch1=$true } ; @{ target="T2" ; param1="P21"} ) 



