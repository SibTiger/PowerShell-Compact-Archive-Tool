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
    Removes some application and user generated data that was created by the PowerShell Compact-Archive Tool

.DESCRIPTION
    This program will set an instruction code to the PowerShell Compact-Archive Tool to perform the Clean Operation.
     In doing so, the PowerShell Compact-Archive Tool will execute the payload to perform the Clean-Up action.

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
    Set-Variable -Name "__PSCAT_OPERATION_CODE__" -Value 1 `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PowerShell Core Executable Name
    Set-Variable -Name "__POWERSHELL_EXECUTABLE__" -Value "pwsh.exe" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PowerShell Core Path
    Set-Variable -Name "__POWERSHELL_PATH__" -Value "$($env:ProgramFiles)\PowerShell\" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # PowerShell Core Complete Path
    #  Populated later within the application.
    Set-Variable -Name "__POWERSHELL_COMPLETE_PATH__" -Value $null `
        -Scope Global -Force -Option None -ErrorAction SilentlyContinue;

    # Exit Codes : Cannot Find PSCAT
    Set-Variable -Name "__EXITCODE_CANNOT_FIND_PSCAT__" -Value 500 `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # Exit Codes : Failed Launch PSCAT
    Set-Variable -Name "__EXITCODE_FAILED_TO_LAUNCH_PSCAT__" -Value 501 `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    # Exit Codes : Cannot Find PowerShell Core
    Set-Variable -Name "__EXITCODE_CANNOT_FIND_POSHCORE__" -Value 502 `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
} # Initialization()





Class Clean
{
    # Call
    # -------------------------------
    # Documentation:
    #  This function will call the PowerShell Compact-Archive Tool with the desired operation code.
    # -------------------------------
    hidden static [Int32] Call()
    {
        # Declarations and Initializations
        # --------------------------------------
        # We are going to use 'Splatting' to make this easier to construct the arguments.
        [System.Collections.Hashtable] $hashArguments = [System.Collections.Hashtable]::New();

        # We are going to use this to capture the Exit Code from PSCAT
        [System.Diagnostics.Process] $processInformation = [System.Diagnostics.Process]::New();
        # --------------------------------------



        # Construct the arguments
        $hashArguments = @{
            FilePath            = "$($Global:__POWERSHELL_COMPLETE_PATH__)";
            WorkingDirectory    = "$($Global:__PSCAT_FULL_PATH__)";
            ArgumentList        = "-File "".\$($Global:__PSCAT_FILENAME__)"" -ProgramMode $Global:__PSCAT_OPERATION_CODE__";
            Wait                = $true;
            NoNewWindow         = $true;
            PassThru            = $true;
            } # Hash Table



        # Launch the PowerShell Compact-Archive Tool program
        $processInformation = Start-Process @hashArguments;


        # Return PSCATs Exit Code
        return $processInformation.ExitCode;
    } # Call()






    # Test Path - File Based
    # -------------------------------
    # Documentation:
    #  This function will make sure that the PowerShell Compact-Archive Tool was detected within the given path.
    # -------------------------------
    hidden static [bool] TestPath([string] $pathToExamine)
    {
        # Check to see if we can find the application
        if (Test-Path -LiteralPath "$($pathToExamine)")
        {
            # We found the application
            return $true;
        } # if : Found Target


        # Could not find the application
        return $false;
    } # TestPath()






    # Test PowerShell Core's Path
    # -------------------------------
    # Documentation:
    #  This function will make sure that the PowerShell Core binary is ready for us to use by either inspecting
    #   the $PATH or the default install location.
    # -------------------------------
    hidden static [bool] TestPowerShellCore()
    {
        # Declarations and Initializations
        # --------------------------------------------
        # We will use this to store as many directories associated with the PowerShell Core's install location.
        [System.Object[]] $qualifiedDirectory = [System.Object]::New();
        # --------------------------------------------



        # With this check, we are going to be focused as to where we can call PowerShell Core.
        #  We have two ways, in a perfect world, to invoke POSH Core:
        #  1. Using $PATH
        #  2. Using the default install location.

        # Lets first take the easy approach, $PATH
        if ($null -ne $(Get-Command -Name "$($GLOBAL:__POWERSHELL_EXECUTABLE__)" -CommandType Application))
        {
            # Successfully found it in $PATH


            # Update the global variable's value.
            $Global:__POWERSHELL_COMPLETE_PATH__ = "$($GLOBAL:__POWERSHELL_EXECUTABLE__)";

            # Successfully completed
            return $true;
        } # if : Scan $PATH


        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


        # Try to find it within the default installation path.
        $qualifiedDirectory = Get-ChildItem -Path "$Global:__POWERSHELL_PATH__" | `
                                Where-Object {$_ -match '([7-9]$|[0-9].$)'} | `
                                Sort-Object -Property {[UInt16]$_.Name};


        # Check to make sure that we where able to capture one or more hits; otherwise - we may not proceed.
        if ($qualifiedDirectory.Count -eq 0)
        {
            # Because we could not find any installed versions, we can not proceed.
            return $false;
        } # if : No PowerShell Core Installation


        for ([uint16] $i = $qualifiedDirectory.Count; $i -ge 0; $i--)
        {
            # If we are not able find the application, then we cannot proceed.
            if ($i -eq 0)
            {
                # Unable to find PowerShell Core
                return $false;
            } # if : Unable to Find PowerShell Core


            # Construct the complete path
            $Global:__POWERSHELL_COMPLETE_PATH__ = ("$($Global:__POWERSHELL_PATH__)" + `            # Base path
                                                    "$($qualifiedDirectory[$i - 1].Name)" + `       # Qualified Directory
                                                    "\$($Global:__POWERSHELL_EXECUTABLE__)");       # Executable File Name


            # Test the path
            if (Test-Path -LiteralPath $Global:__POWERSHELL_COMPLETE_PATH__ `
                        -PathType Leaf)
            {
                # Successfully found PowerShell Core
                return $true;
            } # if : Found PowerShell Core at Path
        } # for : Scan for PowerShell Core Executable



        # Failed to find the PowerShell Core executable
        return $false;
    } # TestPowerShellCore()






    # Display Error Message
    # -------------------------------
    # Documentation:
    #   This function is essentially are main entry point into this program; this is our driver.
    # -------------------------------
    hidden static [void] DisplayErrorMessage([string] $errorMessage)
    {
        # Declarations and Initializations
        # --------------------------------------------
        # Create the message package that we will need to show the user that we were unable to find the PSCAT tool.
        [System.Management.Automation.HostInformationMessage] $messagePackage = `
            [System.Management.Automation.HostInformationMessage]::New();
        # --------------------------------------------



        # Now, build the message package such that it grabs the user's attention immediately.
        $messagePackage.BackgroundColor = "Black";
        $messagePackage.ForegroundColor = "Red";
        $messagePackage.Message = ("`r`n`r`n" + `
                                    "`t`t<!> CRITICAL ERROR <!>`r`n" + `
                                    "------------------------------------------------------`r`n" + `
                                    "$($errorMessage)`r`n" + `
                                    "------------------------------------------------------`r`n");
        $messagePackage.NoNewLine = $false;


        # Display the message to the user
        Write-Information $messagePackage `
                            -InformationAction Continue;
    } # DisplayErrorMessage()






    # Fetch Enter Key
    # -------------------------------
    # Documentation:
    #   The intention of this function is to allow the ability for the user to view messages that are displayed on the
    #   terminal buffer before the buffer is either flushed or the window is closed.
    # -------------------------------
    hidden static [void] FetchEnterKey()
    {
        # Declarations and Initializations
        # --------------------------------------------
        # Create the Message Package, we will need this to tell the user to press the 'Enter' key.
        [System.Management.Automation.HostInformationMessage] $messagePackage = `
            [System.Management.Automation.HostInformationMessage]::New();
        # --------------------------------------------



        # Now, build the message package
        $messagePackage.BackgroundColor = "Black";
        $messagePackage.ForegroundColor = "White";
        $messagePackage.Message = ("`r`n`r`n"+ `
                                    "Press the Enter key to continue. . .");
        $messagePackage.NoNewLine = $false;


        # Display the message to the user
        Write-Information $messagePackage `
                            -InformationAction Continue;


        # Allow the user read the information before we close the script
        (Get-Host).UI.ReadLine();
    } # FetchEnterKey()






    # Main
    # -------------------------------
    # Documentation:
    #   This function is essentially are main entry point into this program; this is our driver.
    # -------------------------------
    static [Int32] main()
    {
        # Declarations and Initializations
        # --------------------------------------
        # PowerShell Core's complete path
        # We will use this return code to signify the operation.
        [int32] $exitCode = 0;

        # This variable will signify if an error was detected; this will help to reduce code duplication.
        [bool] $caughtError = $false;

        # Error Message
        #  Provides an error message that will be presented to the user.
        [string] $errorMessage = $null;
        # --------------------------------------



        # Make sure that we can find the PowerShell Core software
        if (!$([Clean]::TestPowerShellCore()))
        {
            # Generate the error string regarding the error we just found.
            $errorMessage = ("Failed to detect $($Global:__POWERSHELL_EXECUTABLE__)`r`n" + `
                            "Please make sure that the PowerShell Core application had been installed on your system.`r`n" + `
                            "Expected to find PowerShell Core in the following:`r`n" + `
                            "`t- `$PATH`r`n" + `
                            "`tOR`r`n" + `
                            "`t- $($Global:__POWERSHELL_PATH__)");


            # Adjust the return code to signify that an error had been reached.
            $exitCode = $Global:__EXITCODE_CANNOT_FIND_POSHCORE__;


            # We caught an error
            $caughtError = $true;
        } # if : Unable to find POSHCore


        # Now we will make sure that the PSCAT tool can be found.
        elseif (!$([Clean]::TestPath($Global:__PSCAT_COMPLETE_PATH__)))
        {
            # Generate the error string regarding the error we caught.
            $errorMessage = ("Failed to locate $($Global:__PSCAT_FILENAME__)`r`n" + `
                            "Expected Path was:`r`n" + `
                            "`t$($Global:__PSCAT_COMPLETE_PATH__)");


            # Adjust the return code to signify that an error had been reached.
            $exitCode = $Global:__EXITCODE_CANNOT_FIND_PSCAT__;


            # We caught an error
            $caughtError = $true;
        } # if : Unable to find PSCAT


        # We were able to find the PSCAT application, try to call it.
        else
        {
            # Execute PSCAT
            $exitCode = [Clean]::Call();
        } # Else : Call the Application



        # Was an error reached during the checks?
        if ($caughtError)
        {
            # We already have the error message provided to us already, all that we have to do is show the message.
            [Clean]::DisplayErrorMessage($errorMessage);

            # Allow the user to read the message.
            [Clean]::FetchEnterKey();
        } # if : Error During Checks



        # Provide the operation exit code
        return $exitCode;
    } # main()
} # Clean





# We will begin by initializing the variables that we will be using within this application.
Initialization;



# Start the program
exit [Clean]::main();