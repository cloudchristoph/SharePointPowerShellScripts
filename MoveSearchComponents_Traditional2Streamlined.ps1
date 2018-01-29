asnp *share*

$wfeServerName = "SP2016-1"
$appServerName = "SP2016-2"

$ssa = Get-SPEnterpriseSearchServiceApplication
$active = Get-SPEnterpriseSearchTopology -SearchApplication $ssa -Active

$clone = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone –SearchTopology $active

$wfeServer = Get-SPEnterpriseSearchServiceInstance -Identity $wfeServerName
$appServer = Get-SPEnterpriseSearchServiceInstance -Identity $appServerName


# Neue Komponenten (Admin, Crawler, ContentProcessing, AnalyticsProcessing)

New-SPEnterpriseSearchAdminComponent -SearchTopology $clone -SearchServiceInstance $appServer
New-SPEnterpriseSearchCrawlComponent -SearchTopology $clone -SearchServiceInstance $appServer
New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $clone -SearchServiceInstance $appServer
New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $clone -SearchServiceInstance $appServer

# in unserem Fall nicht notwendig:
#New-SPEnterpriseSearchQueryProcessingComponent 
#New-SPEnterpriseSearchIndexComponent

Set-SPEnterpriseSearchTopology -Identity $clone


# Nochmals klonen  -------------------------------------

$ssa = Get-SPEnterpriseSearchServiceApplication
$active = Get-SPEnterpriseSearchTopology -SearchApplication $ssa -Active
$clone = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone –SearchTopology $active

$oldComponents = Get-SPEnterpriseSearchComponent -SearchTopology $clone | ? { $_.ServerName -eq $wfeServerName }

# Alte Komponenten entfernen

foreach ($component in $oldComponents) {
    Remove-SPEnterpriseSearchComponent -SearchTopology $clone -Identity $component.ComponentId.Guid
}

# Neue Topologie aktivieren

Set-SPEnterpriseSearchTopology -Identity $clone

# Alte Topologie löschen

$inactiveSearchTopologies = Get-SPEnterpriseSearchTopology -SearchApplication $ssa | ? { $_.State -eq "Inactive" }
foreach ($topology in $inactiveSearchTopologies) {
    Remove-SPEnterpriseSearchTopology -SearchApplication $ssa -Identity $topology.TopologyId.Guid
}
Get-SPEnterpriseSearchTopology -SearchApplication $ssa