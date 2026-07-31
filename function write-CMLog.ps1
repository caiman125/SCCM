function write-CMLog
param(
[string]$Message,
[string]$Component = "Run Scan",
[string]$LogFile - STSErv.Value("SMSIPU_F1leLogCurrentTS")
49 48 47 46 45 44 ASASEEY ECY RNEBERE
if(test-Path $LogFile -PathType Container)( SLogFile - "SLogFlle\smsts-PSScript. log"
try
$noM - Get-Date Soffsetminutes- [int]([TimeZoneInfo]::Local.GetUtcoffset($now).TotalMlnutes) $formatted -"(0:H:m:ss.fffH[1H2:03) -f inov, ($(1f (Soffsetinutes g 0) (--" ) else ( ";" ])), [math]::Abs(Soffsetrinutes)
$Time - $formatted
)
catch
Mrite-Error "Erreur lors du formatage de "heure : $_"
) ISTime- Get-Date -Format HH:mm:ss.fff-120" $Date - Get-Date -Format "M-dd-yyyy
$Loglessage = "<![LOG[$essage]loG]i><time-""$Tima"" date-""GDate"" component-""$Componant"" context-"""" type-""1"" thread-""$PID"" file-"""">" Add-content -Path SLogfile -Value $Lopiessege -Encoding Default
