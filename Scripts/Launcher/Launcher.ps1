<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
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
    This script is designed to prepare the environment for the PowerShell Compact-Archive Tool and then start the main application.

.DESCRIPTION
    This launcher is designed to prepare the environment for the PowerShell Compact-Archive Tool, such that it is able to run
    properly for the end-user's experience.  Without this Launcher, it is not possible to run the PSCAT application due to limitations
    with Powershell and how objects work [1].

    The environment that this launcher prepares is the need to include libraries into the environment session of the instance of
    PowerShell.  If there are APIs and classes being in the same source, then - due to how Powershell parses the data - it will fail
    to load-in the APIs first before loading the classes.  To get around this, this launcher will include the necessary libraries first
    then start the main application as normally.

    Tools that this program utilizes are:
        PowerShell Core 7.1.x Minimum
            This is required in order for the PSCAT software to work properly.
        PowerShell Compact-Archive Tool (version 1.1.0 minimum)
            This specifies which version of PSCAT supports this functionality.


    Resources:
    [1] - https://stackoverflow.com/questions/42837447/powershell-unable-to-find-type-when-using-ps-5-classes

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/PowerShell-Compact-Archive-Tool

.INPUTS
    Program Mode [integer value]
        0 = Normal mode; compile projects (Default)
        1 = Clean up mode; remove some generated data
        2 = Uninstall mode; removes all generated data

.OUTPUTS
    Operation Return Code
        0   = Operation was Successful
        1   = General Failure
        500 = Unable to find the PowerShell Compact-Archive Tool.
        501 = Unable to launch the PowerShell Compact-Archive Tool.
        502 = Unable to find the PowerShell Core application.

.EXAMPLE
    .\Launcher.ps1 (-ProgramMode n)
        Where n, can be [0, 1, 2]
        Please see Inputs for Program Mode options.
        Note that the -ProgramMode argument is optional.
        Example is: .\Launcher.ps1 -ProgramMode 0
                OR  .\Launcher.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool
#>





<# PowerShell Compact-Archive Tool Launcher
 # ------------------------------
 # ==============================
 # ==============================
 # This launcher is designed to load any dependencies that are required
 #  for the PowerShell Compact-Archive Tool into the Powershell's current
 #  environment.  Thus, this will allow the application to run properly
 #  for the user.  We are having to perform this operation due to the
 #  nature of Powershell and its functionalities with Object-Oriented
 #  Programming.  As such, the classes are parsed first before executing
 #  any inclusions - which can cause the Powershell instance to raise
 #  errors due to missing components and APIs.  To combat this complication,
 #  I will first force the inclusions to be in the current instance of
 #  Powershell AND THEN load PSCAT as normal.
 #
 # Resources:
 #  - https://github.com/PowerShell/PowerShell/issues/6652
 #>




# Startup Arguments
param(
    # Program Mode (optional)
    # When provided, this well configure the software to run in a
    #   specialized mode.
    # Settings:
    #   0 = Normal Mode (Default)
    #       Software runs normally, no changes.
    #   1 = Clean Up Mode
    #       Deletes all builds, logs, and report files.
    #   2 = Uninstall Mode
    #       Deletes all builds, logs, report files, and user configuration.
    [Parameter(Mandatory=$false)]
    [ValidateRange(0, 2)]
    [byte]$programMode = 0
) # Startup Arguments





# Execute the PowerShell Compact-Archive Tool application
function Invoke-Application()
{
    # Launch the application
    .".\PSCAT.ps1" -programMode $programMode;

    # Return the exit code
    return $LASTEXITCODE;
} # Invoke-Application()





# Setup the environment by including the dependencies into the environment.
function Set-Environment()
{
    # Required in order to use the Message Box functionality within the Windows environment.
    Add-Type -AssemblyName PresentationCore;
    Add-Type -AssemblyName PresentationFramework;

    # Required in order to use the following GUI functionalities within the Windows Environment
    #   - File Browser Dialog
    #   - Folder Browser Dialog
    Add-Type -AssemblyName System.Windows.Forms;
} # Set-Environment()





# Setup the environment
Set-Environment;



# Start the application and return the exit code
return Invoke-Application;