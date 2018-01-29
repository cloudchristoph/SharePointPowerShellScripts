asnp *share*

write-host "Datenbanken der Dienstanwendungen" -f c
$serviceDatabases = Get-SPDatabase | ? {$_.Type -ne "Content Database" }
foreach ($db in $serviceDatabases) {
    if ($db.NeedsUpgrade) {
        write-host "Upgrade der Datenbank" $db.Name "notwendig..." -f y
        $db.Provision()
    }
}

write-host "Inhaltsdatenbanken" -f c
$contentDatabases = Get-SPContentDatabase
write-host $contentDatabases.Count "Inhaltsdatenbanken gefunden"
foreach ($db in $contentDatabases) {
    if ($db.NeedsUpgrade) {
        write-host "Upgrade der Inhaltsdatenbank" $db.Name "notwendig..." -f Y
        Upgrade-SPContentDatabase $db -Confirm:$false
    } else {
        write-host "Kein Upgrade für Inhaltsdatenbank" $db.Name "notwendig" -f Green
    }    
}

