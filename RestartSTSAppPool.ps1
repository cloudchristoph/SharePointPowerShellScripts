Import-Module WebAdministration
$appPoolName = "SecurityTokenServiceApplicationPool"

# New-EventLog –LogName Application –Source "RestartSTSAppPool"
Write-EventLog -LogName "Application" -Source "RestartSTSAppPool" -EventID 39001 -EntryType Information -Message "Restart of $appPoolName started"

write-host "Trying to stop $appPoolName..." -ForegroundColor Yellow
Stop-WebAppPool -Name $appPoolName -ErrorAction Continue

write-host "Waiting for $appPoolName to stop..." -NoNewline

while ((Get-WebAppPoolState -Name $appPoolName).Value -ne "Stopped") {
    write-host "." -NoNewline
    Start-Sleep -Milliseconds 500
}
write-host "stopped" -ForegroundColor Green

write-host "Trying to start $appPoolName..." -ForegroundColor Yellow
Start-WebAppPool -Name $appPoolName

write-host "Waiting for $appPoolName to start..." -NoNewline

while((Get-WebAppPoolState -Name $appPoolName).Value -ne "Started") {
    write-host "." -NoNewline
    Start-Sleep -Milliseconds 500
}

write-host "started" -ForegroundColor Green

Write-EventLog -LogName "Application" -Source "RestartSTSAppPool" -EventID 39002 -EntryType Information -Message "Restart of $appPoolName succeded"
