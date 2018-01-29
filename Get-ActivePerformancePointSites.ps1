# PerformancePoint Site Collection Feature
# a1cb5b7f-e5e9-421b-915f-bf519b0760ef

$feature = Get-SPFeature a1cb5b7f-e5e9-421b-915f-bf519b0760ef

$databases = Get-SPContentDatabase | select name
$i = 0
foreach ($database in $databases) {
    $i++
    write-host ("[" + $i + "/" + $databases.Count + "] " + $database.Name) -ForegroundColor Gray
    $memoryAssignment = Start-SPAssignment

    $allSites = Get-SPSite -ContentDatabase $database.Name -Limit ALL -Confirm:$false -AssignmentCollection $memoryAssignment -WarningAction SilentlyContinue
    foreach($site in $allSites) {
        if (($site.Features | where { $_.DefinitionId -eq $feature.Id }).Count -gt 0) {
            write-host "-" $site.Url -ForegroundColor Yellow
        }
    }

    Stop-SPAssignment $memoryAssignment

}