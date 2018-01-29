param(
    [Parameter(Mandatory=$true)][string]$BackupPath,
    [bool]$DateTimePrefix = $true,
    [bool]$OverwriteExistingBackups = $false
)

if ($DateTimePrefix) {
    $date_time_prefix = Get-Date -Format "yyMMdd_HHmmss_"
} else {
    $date_time_prefix = "";
}

write-host "Creating backups from all site collections" -ForegroundColor Cyan
write-host "----------------------------------------------------------------" -ForegroundColor White
write-host "Loading site collections..."
asnp *share*
$sites = Get-SPSite -Limit All

$site_count = $sites.Count
$current_site_count = 0
foreach ($site in $sites)
{
    $current_site_count++
    $name = $date_time_prefix + $site.Url.Replace("http://", "").Replace("https://", "").Replace("/", "_").Replace(".", "_") + ".sitebackup";
    $full_path = ($BackupPath + "\" + $name)

    Write-Progress -Activity "Backup all site collections" -status $site.Url -percentComplete ($current_site_count / $site_count * 100)

    write-host "Creating backup from" $site.Url "... " -NoNewline
    if ($OverwriteExistingBackups) {
        Backup-SPSite -Identity $site.Id -Path $full_path -Force -ErrorAction Inquire
    } else {
        Backup-SPSite -Identity $site.Id -Path $full_path -ErrorAction Inquire
    }
    write-host "finished" -ForegroundColor Green
}