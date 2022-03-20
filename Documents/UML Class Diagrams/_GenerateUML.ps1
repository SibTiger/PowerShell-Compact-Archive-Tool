[System.Collections.ArrayList] $path = [System.Collections.ArrayList]@();



if (Test-Path -Path "..\..\compile.ps1")
{
    Write-CUClassDiagram -Path "..\..\compile.ps1" -ExportFolder ".\";
}



$path = Get-ChildItem -Path "..\..\Scripts\*.ps1";

foreach ($i in $path)
{
    Write-CUClassDiagram -Path $i.FullName -ExportFolder ".\";
} # foreach