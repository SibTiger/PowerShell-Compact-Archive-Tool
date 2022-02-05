<# PowerShell Compact-Archive Tool
 # Copyright (C) 2021
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
    Removes some application and user generated data that was created by the PowerShell Compact-Archive Tool

.DESCRIPTION
    This program will set an instruction code to the PowerShell Compact-Archive Tool to perform the Clean Operation.  In doing so, the PowerShell Compact-Archive Tool will execute the payload to perform the Clean-Up action.

    Tools that this program utilizes are:
        PowerShell Core 7.1.x Minimum
            The required shell in order for this application to work properly.
        PowerShell Compact-Archive Tool (version 1.0.0 minimum)
            This is required in order for this operation to take place.
.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/PowerShell-Compact-Archive-Tool

.INPUTS
    Nothing is to be given or to be provided from a command or pipe.

.OUTPUTS
    Nothing is to be returned or to be sent to the pipe.

.EXAMPLE
    .\cleanup.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool
#>





# Initialization
# -------------------------------
# Documentation:
#  This function will initialize all of the required variables that we will need within this application.
#  This is mainly to help when needing to maintain this application over future generations of PSCAT.
# -------------------------------
function Initialization()
{
    # PSCAT Filename
    Set-Variable -Name "__PSCAT_FILENAME__" -Value "PSCAT.ps1" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PSCAT Absolute Path
    #  NOTE: This script should reside with the PSCAT application.
    Set-Variable -Name "__PSCAT_FULL_PATH__" -Value $PSScriptRoot `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PSCAT Complete Path
    Set-Variable -Name "__PSCAT_COMPLETE_PATH__" -Value "$($__PSCAT_FULL_PATH__)\$($__PSCAT_FILENAME__)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PSCAT Operation Code
    Set-Variable -Name "__PSCAT_OPERATION_CODE__" -Value "1" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
} # Initialization()





# Call
# -------------------------------
# Documentation:
#  This function will call the PowerShell Compact-Archive Tool with the desired operation code.
# -------------------------------
function Call()
{
    # Declarations and Initializations
    # --------------------------------------
    # We are going to use 'Splatting' to make this easier to construct the arguments.
    [System.Collections.Hashtable] $hashArguments = [System.Collections.Hashtable]::New();
    # --------------------------------------


    # Construct the arguments
    $hashArguments = @{
        FilePath            = "pwsh.exe";
        WorkingDirectory    = "$($__PSCAT_FULL_PATH__)";
        ArgumentList        = "-File .\$($__PSCAT_FILENAME__) -ProgramMode $__PSCAT_OPERATION_CODE__";
        Wait                = $true;
        NoNewWindow         = $true;
        } # Hash Table


    # Invoke PSCAT with the constructed arguments.
    Start-Process @hashArguments;
} # Call()




# Test Path
# -------------------------------
# Documentation:
#  This function will make sure that the PowerShell Compact-Archive Tool was detected within the given path.
# -------------------------------
function TestPath()
{
    # Check to see if we can find the application
    if (Test-Path -LiteralPath "$($__PSCAT_COMPLETE_PATH__)")
    {
        # We found the application
        return $true;
    } # if : Found PSCAT


    # Could not find the application
    return $false;
} # TestPath()




# Main
# -------------------------------
# Documentation:
#   This function is essentially are main entry point into this program; this is our driver.
# -------------------------------
function main()
{
    # Declarations and Initializations
    # --------------------------------------
    # We will use this return code to signify the operation.
    [int32] $exitCode = 0;
    # --------------------------------------



    # We will begin by initializing the variables that we will be using within this application.
    Initialization;

    # Now we will make sure that the PSCAT tool can be found.
    if ($(TestPath) -eq $false)
    {
        # Create the message package that we will need to show the user that we were unable to find the PSCAT tool.
        [System.Management.Automation.HostInformationMessage] $messagePackage = `
            [System.Management.Automation.HostInformationMessage]::New();

        # Now, build the message package such that it grabs the user's attention immediately.
        $messagePackage.BackgroundColor = "Black";
        $messagePackage.ForegroundColor = "Red";
        $messagePackage.Message = ("Failed to locate $($__PSCAT_FILENAME__)`r`n" + `
                                    "Expected Path was:`r`n" + `
                                    "$($__PSCAT_COMPLETE_PATH__)`r`n" + `
                                    "`r`n`r`n"+ `
                                    "Press the Enter key to close this window. . .");
        $messagePackage.NoNewLine = $false;


        # Display the message to the user
        Write-Information $messagePackage `
                            -InformationAction Continue;


        # Adjust the return code to signify that an error had been reached.
        $exitCode = 500;


        # Allow the user read the information before we close the script
        (Get-Host).UI.ReadLine();
    } # if : Unable to find PSCAT

    # We were able to find the PSCAT application, try to call it.
    else
    {
        # Because we are able to find the PSCAT application, we may now try to invoke the operation code.
        $exitCode = Call;
    } # Else : Call the Application


    return $exitCode
} # main()




# Start the program
exit main;