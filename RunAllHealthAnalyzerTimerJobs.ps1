asnp *share*

write-host "Getting timerjob definitions..."

$jobs = Get-SPTimerJob | ? {$_.Title -like "Health Analysis Job*"}
if (!$jobs -or $jobs.Count -eq 0) {
    # Maybe in German? :)
    $jobs = Get-SPTimerJob | ? {$_.Title -like "Integritätsanalyseauftrag*"}
}

if (!$jobs -or $jobs.Count -eq 0) {
    throw "Found no timerjobs."
}

write-host "Found" $jobs.Count "timerjobs. Calling RunNow on all of them..." -f y

foreach ($job in $jobs) {
    write-host $job.Title
    $job.RunNow()
}

write-host "Getting Central Admin URL..." -f Y
$caUrl = Get-SPWebApplication -includecentraladministration | where {$_.IsAdministrationWebApplication} | Select-Object -ExpandProperty Url

write-host "Open IE with current timerjob status..." -f Y
$ie = New-Object -com internetexplorer.application; 
$ie.visible = $true; 
$ie.navigate($caUrl + "/_admin/ServiceRunningJobs.aspx");

write-host "finished" -f Green