# Source: https://technet.microsoft.com/en-us/library/jj219613.aspx?f=255&MSPPError=-2147217396#graceful
# changed it to dynamic hostname

# Run this on the Cache Host that should be stopped

$hostName = [System.Net.Dns]::GetHostByName(($env:COMPUTERNAME)).HostName

$startTime = Get-Date
$currentTime = $startTime
$elapsedTime = $currentTime - $startTime
$timeOut = 900

try {

    Use-CacheCluster
    Get-AFCacheClusterHealth

    Write-Host "Shutting down distributed cache host."
    $hostInfo = Stop-CacheHost -Graceful -CachePort 22233 -HostName $hostName

    while($elapsedTime.TotalSeconds -le $timeOut-and $hostInfo.Status -ne 'Down')
    {
        Write-Host "Host Status : [$($hostInfo.Status)]"
        Start-Sleep(5)
        $currentTime = Get-Date
        $elapsedTime = $currentTime - $startTime
        $hostInfo = Get-CacheHost -HostName $hostName -CachePort 22233
    }

    Write-Host "Stopping distributed cache host was successful. Updating Service status in SharePoint."
    Stop-SPDistributedCacheServiceInstance
    Write-Host "To start service, please use Central Administration site."

} catch [System.Exception] {

    Write-Host "Unable to stop cache host within 15 minutes."

}