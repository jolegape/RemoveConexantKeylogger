<#
.SYNOPSIS
    Removes Conexant MicTray and associated log file
.DESCRIPTION
    I first came across this on a Reddit 
    post (https://www.reddit.com/r/sysadmin/comments/6ajfpc/keylogger_in_hp_conexant_hd_audio_audio_driver/)
    Following the proof of concept in the linked blog post I was able to replicate this exploit.
    This script stops the running process and removes the offending files. Needs to be run as admin.
.NOTES
    FileName:       Remove_Conexant_Keylogger.ps1
    Author:         Gavin Willett
.LINK
    Script hosted at:
    http://github.com/jolegape
#>

if (Test-path "$($env:SystemRoot)\System32\Mictray64.exe"){
    Write-Output 'Found MicTray64.exe'
    Stop-Process -Name MicTray64 -Force
    Remove-Item -Path "$($env:SystemRoot)\System32\Mictray64.exe" -Force
} elseif (Test-Path "$($env:SystemRoot)\System32\Mictray.exe"){ 
    Write-Output 'Found MicTray.exe'
    Stop-Process -Name MicTray -Force
    Remove-Item -Path "$($env:SystemRoot)\System32\Mictray.exe" -Force
}

if (Test-path "$($env:SystemDrive)\Users\Public\MicTray.log"){
    Write-Output 'Found MicTray.log'
    Remove-Item -Path "$($env:SystemDrive)\Users\Public\MicTray.log" -Force
}

if ($t = (Get-ScheduledTask | Where-Object TaskName -match 'MicTray')) {
    Write-Output 'Found scheduled task'
    $t | Unregister-ScheduledTask -Confirm:$false
}
Read-Host 'Press enter to continue...'