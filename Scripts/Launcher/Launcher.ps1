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





# Initialization
# -------------------------------
# Documentation:
#   This function will initialize all of the required variables that we will need within this application.
#   This is mainly to help when needing to maintain this application over future generations of PSCAT.
# -------------------------------
function Initialization()
{
    # PSCAT Filename
    Set-Variable -Name "__PSCAT_FILENAME__" -Value "PSCAT.ps1" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "PowerShell Compact-Archive Tool's filename";

    # PSCAT Absolute Path
    #  NOTE: This script should reside with the PSCAT application.
    Set-Variable -Name "__PSCAT_FULL_PATH__" -Value $PSScriptRoot `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Base path in which the PSCAT application will reside";

    # PSCAT Complete Path
    Set-Variable -Name "__PSCAT_COMPLETE_PATH__" -Value "$($GLOBAL:__PSCAT_FULL_PATH__)\$($GLOBAL:__PSCAT_FILENAME__)" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "PowerShell Compact-Archive Tool's absolute path - including filename.";

    # PSCAT Program Mode
    Set-Variable -Name "__PSCAT_PROGRAM_MODE__" -Value $programMode `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Program Mode; Using this variable as a helper, I cannot figure out how to use programMode directly in an object.";

    # PowerShell Core Executable Name
    Set-Variable -Name "__POWERSHELL_EXECUTABLE__" -Value "pwsh.exe" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "PowerShell Core's filename";

    # PowerShell Core Path
    Set-Variable -Name "__POWERSHELL_PATH__" -Value "$($env:ProgramFiles)\PowerShell\" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Common base path for PowerShell Core";

    # PowerShell Core Complete Path
    #  Populated later within the application.
    Set-Variable -Name "__POWERSHELL_COMPLETE_PATH__" -Value $null `
        -Option None -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "PowerShell Core's absolute path [Must be generated before use]";

    # Exit Codes : Cannot Find PSCAT
    Set-Variable -Name "__EXITCODE_CANNOT_FIND_PSCAT__" -Value 500 `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Exit Code signifying that the PowerShell Compact-Archive Tool could not be found.";

    # Exit Codes : Failed Launch PSCAT
    Set-Variable -Name "__EXITCODE_FAILED_TO_LAUNCH_PSCAT__" -Value 501 `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Exit Code Signifying that the PowerShell Compact-Archive Tool could not be started.";

    # Exit Codes : Cannot Find PowerShell Core
    Set-Variable -Name "__EXITCODE_CANNOT_FIND_POSHCORE__" -Value 502 `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Exit Code signifying that the PowerShell Core could not be found.";
} # Initialization()





# Uninitialization
# -------------------------------
# Documentation:
#   This function will remove all of the global variables that had been declared and initialize by this shellscript.
#    This will help to cleanup unnecessary variables from the user's terminal environment.
# -------------------------------
function Uninitialization()
{
    # PSCAT Filename
    Remove-Variable -Name "__PSCAT_FILENAME__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PSCAT Absolute Path
    Remove-Variable -Name "__PSCAT_FULL_PATH__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PSCAT Complete Path
    Remove-Variable -Name "__PSCAT_COMPLETE_PATH__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PSCAT Program Mode
    Remove-Variable -Name "__PSCAT_PROGRAM_MODE__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PowerShell Core Executable Name
    Remove-Variable -Name "__POWERSHELL_EXECUTABLE__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PowerShell Core Path
    Remove-Variable -Name "__POWERSHELL_PATH__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PowerShell Core Complete Path
    Remove-Variable -Name "__POWERSHELL_COMPLETE_PATH__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Exit Codes : Cannot Find PSCAT
    Remove-Variable -Name "__EXITCODE_CANNOT_FIND_PSCAT__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Exit Codes : Failed Launch PSCAT
    Remove-Variable -Name "__EXITCODE_FAILED_TO_LAUNCH_PSCAT__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Exit Codes : Cannot Find PowerShell Core
    Remove-Variable -Name "__EXITCODE_CANNOT_FIND_POSHCORE__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;
} # Uninitialization()





# Load Library
# -------------------------------
# Documentation:
#   This function will load the proper environment that is required for the PowerShell Compact-Archive Tool to
#   function correctly.  Without this crucial step, it is not possible for the PowerShell Compact-Archive Tool
#   to run.
# -------------------------------
function LoadLibrary()
{
    # Required in order to use the Message Box functionality within the Windows environment.
    Add-Type -AssemblyName PresentationCore;
    Add-Type -AssemblyName PresentationFramework;

    # Required in order to use the following GUI functionalities within the Windows Environment
    #   - File Browser Dialog
    #   - Folder Browser Dialog
    Add-Type -AssemblyName System.Windows.Forms;
} # LoadLibrary()





# This class provides the main operations in order to get the job done.
#  Fun-Fact, I am explicitly using OOP as I can control the return information.  Previously I did use
#           POP, however due to the nature of the 'Pipe' in POSH - it was more trouble than what it was
#           worth.  Thus, switching to OOP was necessary to assure that I can move information as I want
#           without it getting ridiculous....
Class Launcher
{
    # Launch the PowerShell Compact-Archive Tool
    # -------------------------------
    # Documentation:
    #   This function will execute the PowerShell Compact-Archive Tool and set the Program Mode to 'Launcher'.
    # -------------------------------
    # Output:
    #   [Int] Exit Code
    #       This is the exit code provided by the PowerShell Compact-Archive Tool program.
    # -------------------------------
    hidden static [Int32] LaunchPSCAT()
    {
        # Declarations and Initializations
        # --------------------------------------
        # We are going to use 'Splatting' to make this easier to construct the Start-Process arguments.
        [System.Collections.Hashtable] $hashArguments = [System.Collections.Hashtable]::New();

        # We are going to use this variable to capture the Exit Code from PSCAT.
        [System.Diagnostics.Process] $processInformation = [System.Diagnostics.Process]::New();

        # Error Message
        #  Chief Reason for Error
        [string] $errorTitle = "((REASON IS NOT KNOWN))";
        # --------------------------------------



        # Construct the arguments
        $hashArguments = @{
            FilePath            = "$($Global:__POWERSHELL_COMPLETE_PATH__)";
            WorkingDirectory    = "$($Global:__PSCAT_FULL_PATH__)";
            ArgumentList        = "-File "".\$($Global:__PSCAT_FILENAME__)"" -ProgramMode $($GLOBAL:__PSCAT_PROGRAM_MODE__)";
            Wait                = $true;
            NoNewWindow         = $true;
            PassThru            = $true;
            ErrorAction         = "Stop";
            } # Start-Process Arguments



        # Try to launch the PowerShell Core application
        try
        {
            # Launch the PowerShell Compact-Archive Tool program
            $processInformation = Start-Process @hashArguments;


            # Evaluate POSHCore's return code; check to see if we reached an internal error or if the operation was successful.
            switch($processInformation.ExitCode)
            {
                # General Error
                1
                {
                    # Provide the error message
                    $errorTitle = "PowerShell reached a very general error!";
                } # 1 : General Error


                # POSH: Bad script name or path to script
                64
                {
                    # Provide the error message
                    $errorTitle = "Could not find the PowerShell Compact-Archive Tool!";
                } # 64: Bad File Path


                # PSCAT - POSH: Incorrect Argument Conditions
                501
                {
                    # Provide the error message
                    $errorTitle = "Program Mode was out of range!"
                } # 501: Incorrect Argument Conditions


                # Operation was successful
                default
                {
                    # Operation was successful

                    # Return PSCAT's Exit Code
                    return $processInformation.ExitCode;
                } # Default: No errors detected
            } # switch : Evaluate Return Code
        } # Try: Launch POSHCore with PSCAT


        # Caught an error during POSH Launch
        catch
        {
            # Provide the error message
            $errorTitle = "Failed to launch PowerShell Core!"
        } # Catch: Caught an error



        # Generate the full error message
        [string] $errorMessage = ("$($errorTitle)`r`n" + `
                                "Tried to invoke PowerShell Core using: $($hashArguments.FilePath)`r`n" + `
                                "Working Directory was set to: $($hashArguments.WorkingDirectory)`r`n" + `
                                "Arguments that were used: $($hashArguments.ArgumentList)`r`n" + `
                                "Other properties that were used:`r`n" + `
                                "`tWait: $($hashArguments.Wait)`r`n" + `
                                "`tNo New Window: $($hashArguments.NoNewWindow)`r`n" + `
                                "`tPass Through: $($hashArguments.PassThru)`r`n" + `
                                "`tError Action: $($hashArguments.ErrorAction)");


        # Display the error message to the user
        [Launcher]::DisplayErrorMessage($errorMessage);


        # Allow the user to read the message.
        [Launcher]::FetchEnterKey();


        # Return the error code that we were unable to start PSCAT via POSHCore.
        return $Global:__EXITCODE_FAILED_TO_LAUNCH_PSCAT__;
    } # LaunchPSCAT()






    # Test File Path
    # -------------------------------
    # Documentation:
    #   This function will inspect the complete path in which the file supposedly resides.
    # -------------------------------
    # Output:
    #   [Bool] Exist Result
    #       $True   - File exists within the given path.
    #       $False  - File could not be found with the provided path.
    # -------------------------------
    hidden static [bool] TestFilePath([string] $pathToExamine)
    {
        # Check to see if we can find the file
        if (Test-Path -LiteralPath "$($pathToExamine)" -PathType Leaf)
        {
            # Found the target file
            return $true;
        } # if : Found Target


        # Unable to find the target file
        return $false;
    } # TestFilePath()






    # Find PowerShell Core
    # -------------------------------
    # Documentation:
    #   This function will examine the common ways in which we can be able to locate the PowerShell Core
    #   application within the host system's environment.
    #
    #   This function will try to find the PowerShell Core by checking the following:
    #       1) Checking the system's environment variable, $PATH.
    #       2) Checking the default install location.
    # -------------------------------
    hidden static [bool] FindPowerShellCore()
    {
        # Declarations and Initializations
        # --------------------------------------------
        # We will use this to store as many directories associated with the PowerShell Core's install location.
        [System.Object[]] $qualifiedDirectory = [System.Object]::New();
        # --------------------------------------------



        # Lets first take the easy approach, $PATH
        if ($null -ne $(Get-Command -Name "$($GLOBAL:__POWERSHELL_EXECUTABLE__)" -CommandType Application))
        {
            # Successfully found it in $PATH


            # Update the global variable's value.
            $Global:__POWERSHELL_COMPLETE_PATH__ = "$($GLOBAL:__POWERSHELL_EXECUTABLE__)";


            # Successfully found POSH from the System's environment variable
            return $true;
        } # if : Scan $PATH


        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


        # Try to find it within the default installation path.
        $qualifiedDirectory = Get-ChildItem -Path "$Global:__POWERSHELL_PATH__" | `     # Obtain all possible sub-directories within the location
                                Where-Object {$_ -match '([7-9]$|[0-9].$)'} | `         # Filter all names that do not start with 7 to 9
                                Sort-Object -Property {[UInt16]$_.Name};                # Output all results that fit the criteria.


        # Check to make sure that we where able to capture one or more hits; otherwise - we may not proceed.
        if ($qualifiedDirectory.Count -eq 0)
        {
            # Because we could not find any installed versions, we can not proceed.
            return $false;
        } # if : No PowerShell Core Installation


        # Try to use the latest version of the PowerShell Core application
        for ([uint16] $i = $qualifiedDirectory.Count; $i -ge 0; $i--)
        {
            # Construct the complete path
            $Global:__POWERSHELL_COMPLETE_PATH__ = ("$($Global:__POWERSHELL_PATH__)" + `            # Base path
                                                    "$($qualifiedDirectory[$i - 1].Name)" + `       # Qualified Directory
                                                    "\$($Global:__POWERSHELL_EXECUTABLE__)");       # Executable File Name


            # Check the path
            if (Test-Path -LiteralPath $Global:__POWERSHELL_COMPLETE_PATH__ `
                        -PathType Leaf)
            {
                # Successfully found PowerShell Core
                return $true;
            } # if : Found PowerShell Core at Path
        } # for : Scan for PowerShell Core Executable


        # Failed to find the PowerShell Core executable
        return $false;
    } # FindPowerShellCore()






    # Display Error Message
    # -------------------------------
    # Documentation:
    #   This function will provide centralized way into creating an error message that will be
    #   displayed to the user's terminal buffer.
    #   We will only provide a static error message, such that the format does not change.
    # -------------------------------
    hidden static [void] DisplayErrorMessage([string] $errorMessage)
    {
        # Declarations and Initializations
        # --------------------------------------------
        # Create the message package that we will need to show the user that we were unable to find the PSCAT tool.
        [System.Management.Automation.HostInformationMessage] $messagePackage = `
            [System.Management.Automation.HostInformationMessage]::New();
        # --------------------------------------------



        # Generate the message package such that it grabs the user's attention immediately.
        $messagePackage.BackgroundColor = "Black";
        $messagePackage.ForegroundColor = "Red";
        $messagePackage.Message = ("`r`n`r`n" + `
                                    "`t`t<!> CRITICAL ERROR <!>`r`n" + `
                                    "------------------------------------------------------`r`n" + `
                                    "$($errorMessage)`r`n" + `
                                    "------------------------------------------------------`r`n");
        $messagePackage.NoNewLine = $false;


        # Display the error message to the user
        Write-Information $messagePackage `
                            -InformationAction Continue;
    } # DisplayErrorMessage()






    # Fetch Enter Key
    # -------------------------------
    # Documentation:
    #   With this function, we can momentarily pause the application such that the user may view the messages
    #   before terminal's buffer is cleared, the terminal is about to exit, or before the buffer gets flooded
    #   with verbose or additional messages.
    #
    #   As such, we want the user to read the messages before the content is lost.
    # -------------------------------
    hidden static [void] FetchEnterKey()
    {
        # Declarations and Initializations
        # --------------------------------------------
        # Create the Message Package, we will need this to tell the user to press the 'Enter' key.
        [System.Management.Automation.HostInformationMessage] $messagePackage = `
            [System.Management.Automation.HostInformationMessage]::New();
        # --------------------------------------------



        # Create the message package
        $messagePackage.BackgroundColor = "Black";
        $messagePackage.ForegroundColor = "White";
        $messagePackage.Message = ("`r`n`r`n"+ `
                                    "Press the Enter key to continue. . .");
        $messagePackage.NoNewLine = $false;


        # Display the message to the user
        Write-Information $messagePackage `
                            -InformationAction Continue;


        # Momentarily stop the application from further executing until the user provides the
        #  enter key character.
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
        # We will use this variable to signify the entire operation's status.
        [int32] $exitCode = 0;

        # This variable will signify if an error was detected; this will help to reduce code duplication.
        [bool] $caughtError = $false;

        # Provides an error message that will be presented to the user.
        [string] $errorMessage = $null;
        # --------------------------------------



        # Try to detect if the PowerShell Core is presently installed within the host's system.
        #  If we can find it, then we will be able to know how to directly invoke POSH Core.
        if (!$([Launcher]::FindPowerShellCore()))
        {
            # Because we cannot find POSH Core, we cannot continue.
            # Generate the error message
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


        # Try to detect if the PowerShell Compact-Archive Tool had been found.
        elseif (!$([Launcher]::TestFilePath($Global:__PSCAT_COMPLETE_PATH__)))
        {
            # Because we cannot find the PSCAT, we cannot continue.
            # Generate the error message
            $errorMessage = ("Failed to locate $($Global:__PSCAT_FILENAME__)`r`n" + `
                            "Expected Path was:`r`n" + `
                            "`t$($Global:__PSCAT_COMPLETE_PATH__)");


            # Adjust the return code to signify that an error had been reached.
            $exitCode = $Global:__EXITCODE_CANNOT_FIND_PSCAT__;


            # We caught an error
            $caughtError = $true;
        } # if : Unable to find PSCAT


        # If we successfully found POSHCore and PSCAT, then launch the program.
        else
        {
            # Execute PSCAT
            $exitCode = [Launcher]::LaunchPSCAT();
        } # Else : Launch the Application



        # Did we catch an error during the detections?
        if ($caughtError)
        {
            # We already have the error message provided to us already, all that we have to do is show the message.
            [Launcher]::DisplayErrorMessage($errorMessage);

            # Allow the user to read the message.
            [Launcher]::FetchEnterKey();
        } # if : Error During Checks



        # Provide the operation exit code
        return $exitCode;
    } # main()
} # Launcher





#region Special Program Variables

# This will contain all of the information stored within the pipe.  Now, I am using this
#  as I will need to capture the exit code that is returned from the main application's
#  function.
[System.Object[]] $returnState = $null;

#endregion




# Initialize the global variables that we will use within this program.
Initialization;


# Load the necessary libraries required for PSCAT to work properly.
LoadLibrary;


# Start the program and then return the exit code upon terminating.
$returnState = [Launcher]::main();


# Thrash the program's global variables.
Uninitialization;


# Try to retrieve the exit code that was returned by the main application and then
#  return it to the Operating System.
#  NOTE: We use the very last index as that was the very last item that was added
#       into the Pipe.  And this last item - is our exit code.
exit $returnState[$returnState.Length - 1];
