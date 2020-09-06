<#
.SYNOPSIS
    Compiles a ZDoom based mod project in to an PK3 or PK7 archive datafile.

.DESCRIPTION
    This program provides the ability to compile a ZDoom family-based project source into either an PK3 or PK7 archive datafile.  With transforming the project's source to an archive datafile to either PK3 or PK7: this allows any modern ZDoom family engine to easily read the file, exporting the archive file to any webservices, sharing with user's abroad on the internet, and to neatly organize different builds for development purposes.

    Make sure that your project source (or custom source) follows the ZDoom's ZIP Specifications.  For more information, please look at the following resources:
        https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement

    Tools that this program utilizes are:
        dotNET Framework 5.0 Minimum (Windows Platform)
            The required framework that is needed for this program to run successfully on the Windows Platform.
        dotNET Core 2.1.x Minimum (*nix Platform)
            The required framework that is needed for this program to run successfully on the *nix Platform.
        7Zip [Optional]
            Compact the project source to either a PK3 or PK7 archive datafile.
        Git [Optional]
            Ideal for Alpha and Beta Development Builds.
            Retrieve project's repository information and pull updates to project's local repository.
        Microsoft Word 2016 or Later [Optional]
            Generate a report in Portable Document File (PDF).
.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/PowerShell-Compact-Archive-Tool

.INPUTS
    Nothing is to be given or to be provided from a command or pipe.

.OUTPUTS
    Nothing is to be returned or to be sent to the pipe.

.EXAMPLE
    .\Compile.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool
    https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement
#>