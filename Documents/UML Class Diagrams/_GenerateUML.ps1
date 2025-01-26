# -------------------------------------
# New Installation Instructions:
#   - Install Chocolatey
#       - [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#   - Find-module PSClassUtils | install-Module
#       - https://github.com/Stephanevg/PSClassUtils
#   - Install-CUDiagramPrerequisites
#   - choco install graphviz
#       - https://github.com/PrateekKumarSingh/AzViz/issues/12#issuecomment-816745045
# -------------------------------------


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