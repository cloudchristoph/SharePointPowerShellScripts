$patchfiles = Get-ChildItem | where{$_.Extension -eq ".exe"}

write-host "Found" $patchfiles.Count "Patches"

$i = 0
foreach ($patchfile in $patchfiles) {
    $i++;
    $filename = $patchfile.basename  
    
    write-host "[$i/$($patchfiles.Count)] Install $filename ..."

    Start-Process $filename -ArgumentList '/quiet /passive'

    Start-Sleep -seconds 20 
    $proc = get-process $filename 
    $proc.WaitForExit() 

}