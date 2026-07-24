<#
        Editeur : Mohamed BAHY
        Version : 2024-01-03
                  2025-08-08 :  ajout d'une fichier log avec date 

#>

"$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Started" | Out-File -FilePath "c:\temp\SCCM-Client-Check-passed.txt"

$ccmexecId = (Get-Process CcmExec).Id
Start-Process -FilePath "c:\windows\ccm\ccmRestart.exe" -NoNewWindow
$compteur = 0
while(($compteur -lt 10) -and  (Get-Process ccmRestart -ErrorAction SilentlyContinue))
{
    Start-Sleep -Seconds 1
    $compteur++
}

"$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - ccmexec restarted" | Out-File -FilePath "c:\temp\SCCM-Client-Check-passed.txt" -Append

if(($compteur -ge 10) -and ((Get-Process CcmExec).Id -eq $ccmexecId)){
    while((Get-Process -Name "CcmExec" -ErrorAction SilentlyContinue) -ne $null){
        Stop-Process -Name "CcmExec" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    } 
    Start-Service -Name "CcmExec"
}

c:\windows\ccm\ccmeval.exe
$eval = (Get-Process ccmeval).id
Wait-Process -Id $eval -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

"$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - ccmeval executed" | Out-File -FilePath "c:\temp\SCCM-Client-Check-passed.txt" -Append


C:\Windows\CCM\ccmrepair.exe
$eval = (Get-Process ccmrepair).id
Wait-Process -Id $eval -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5

"$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - ccmrepair executed" | Out-File -FilePath "c:\temp\SCCM-Client-Check-passed.txt" -Append

$SCCMUpdatesStore = New-Object -ComObject Microsoft.CCM.UpdatesStore
$SCCMUpdatesStore.RefreshServerComplianceState()

@(0..300)|%{Invoke-WmiMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule ("{{00000000-0000-0000-0000-000000000{0}}}" -f $_.ToString("000")) -ErrorAction SilentlyContinue}

"$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - inventory sent" | Out-File -FilePath "c:\temp\SCCM-Client-Check-passed.txt"  -Append
