<# PowerShell Compact-Archive Tool
 # Copyright (C) 2023
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #>




<#
.SYNOPSIS
    Compiles a ZDoom based mod project in to an PK3 or PK7 archive datafile.

.DESCRIPTION
    This program provides the ability to compile a ZDoom family-based project source into either an PK3 or PK7 archive datafile.  With transforming the project's source to an archive datafile to either PK3 or PK7: this allows any modern ZDoom family engine to easily read the file, exporting the archive file to any webservices, sharing with user's abroad on the internet, and to neatly organize different builds for development purposes.

    Make sure that your project source (or custom source) follows the ZDoom's ZIP Specifications.  For more information, please look at the following resources:
        https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement


    To Run this Application:
        You must first run the Launcher, which will prepare the Powershell's environment for the PSCAT application.  Without doing this first, you will not able to run PSCAT properly.
        Reason for this [Technical]: https://stackoverflow.com/questions/42837447/powershell-unable-to-find-type-when-using-ps-5-classes


    Tools that this program utilizes are:
        PowerShell Core 7.1.x Minimum
            The required shell in order for this application to work properly.
        dotNET Core 3.1.x Minimum
            The required framework that is needed for this program to run successfully on all supported platforms.
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
    Program Mode [integer value]
        0 = Normal mode; compile projects (Default)
        1 = Clean up mode; remove some generated data
        2 = Deep clean up mode; removes all generated data

.OUTPUTS
    Operation Return Code
        0 = Operation was Successful
        1 = Compatibility Error

.EXAMPLE
    .\PSCAT.ps1 (-ProgramMode n)
        Where n, can be [0, 1, 2]
        Please see Inputs for Program Mode options.
        Note that the -ProgramMode argument is optional.
        Example is: .\PSCAT.ps1 -ProgramMode 0
                OR  .\PSCAT.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool
    https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement
#>
