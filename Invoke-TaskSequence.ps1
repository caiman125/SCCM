function{
  param(
    [Parameter(ParameterSetName="DeploymentId", Mandatory=$true)]
    [string]$deploymentid,
    [Parameter(ParameterSetName="PackageId", Mandatory=$true)]
    [string]$packageId
    )

  $scheduledMessageID = Get CimInstance -ClassName CCM_Scheduler_ScheduledMessage -Namespace root\ccm\policy\machine\actualconfig | where-Object { $_.ScheduledMessageID -like "$deploymentid-*" -or $_.scheduledMessageID -like "*-$packageid-*" } | Select-Object -ExpandProperty ScheduledMessageID
  if($scheduledMessageID){
    invoke-CimMethod -namespace "root\ccm" -Class "SMS_Client" -MethodName "TriggerSchedule" -Arguments @{sScheduleID = $scheduledMessageID }
  }
  else{
    Write-Error "PackageID $packageid or DeplymentId $deplymentid not affected to this machine" -Category InvalidArgument
  }
}
