param (
    [Parameter(Mandatory=$true)][string]$Path
)

Write-Host "Exporting solutions to" $Path
foreach ($solution in Get-SPSolution)  
{  
    $id = $solution.SolutionID  
    $title = $solution.Name  
    $filename = $solution.SolutionFile.Name 
    Write-Host "Exporting ‘$title’ to …\$filename" -nonewline  
    try {  
        $solution.SolutionFile.SaveAs("$Path\$filename")  
        Write-Host " – done" -foreground green  
    }
    catch
    {
        Write-Host " – error : $_" -foreground red  
    }
}
Write-Host "Finished" -ForegroundColor Green