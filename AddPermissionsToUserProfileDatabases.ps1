# If an error occurs, the only solution so far has been to make the installation account the "sysadmin" on the SQL Server instance.
asnp *share*

$webapplication = Get-SPWebApplication | where { $_.DisplayName -like "Portal*" }
$poolAccount = $webapplication.ApplicationPool.ManagedAccount

Get-SPDatabase | where { 
    $_.Type -eq "Microsoft.Office.Server.Administration.ProfileDatabase" -or 
    $_.Type -eq "Microsoft.Office.Server.Administration.SocialDatabase" } | foreach {

    Add-SPShellAdmin -UserName $poolAccount.Username -database $_ -Verbose
}
 
