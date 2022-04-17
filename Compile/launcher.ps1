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