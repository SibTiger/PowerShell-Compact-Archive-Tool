<# PowerShell Compact-Archive Tool
 # Copyright (C) 2025
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
        2 = Deep clean up mode; removes all generated data

.OUTPUTS
    Operation Return Code
        0   = Operation was Successful
        1   = General Failure
        500 = Unable to find the PowerShell Compact-Archive Tool.
        501 = Unable to launch the PowerShell Compact-Archive Tool.
        502 = Unable to load the required dependencies.

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
    #   2 = Deep Clean Up Mode
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

    # Exit Codes : Failed Load Dependency
    Set-Variable -Name "__EXITCODE_FAILED_TO_LOAD_DEPENDENCY__" -Value 502 `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Public `
        -Description "Exit Code Signifying that the dependencies could not loaded into PowerShell's environment.";
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

    # Exit Codes : Failed Load Dependency
    Remove-Variable -Name "__EXITCODE_FAILED_TO_LOAD_DEPENDENCY__" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;
} # Uninitialization()





# This class provides the main operations in order to get the job done.
#  Fun-Fact, I am explicitly using OOP as I can control the return information.  Previously I did use
#           POP, however due to the nature of the 'Pipe' in POSH - it was more trouble than what it was
#           worth.  Thus, switching to OOP was necessary to assure that I can move information as I want
#           without it getting ridiculous....
Class Launcher
{
    # Load Library
    # -------------------------------
    # Documentation:
    #   This function will load the proper environment that is required for the PowerShell Compact-Archive Tool to
    #   function correctly.  Without this crucial step, it is not possible for the PowerShell Compact-Archive Tool
    #   to run.
    # -------------------------------
    # Output:
    #   [Bool] Exist Result
    #       $True   - Successfully loaded the required dependencies.
    #       $False  - Failed to load the required dependencies.
    # -------------------------------
    hidden static [bool] LoadLibrary([ref] $dependencyName)
    {
        # Declarations and Initializations
        # --------------------------------------
        # This array will contain the binaries that will need to be loaded into the environment.
        [System.Collections.ArrayList] $binaryList = [System.Collections.ArrayList]::new();
        # --------------------------------------



        # Setup the binary list
        $binaryList.Add("PresentationCore");
        $binaryList.Add("PresentationFramework");
        $binaryList.Add("System.Windows.Forms");



        foreach ($item in $binaryList)
        {
            # Update the Error Dependency string, if incase the binary could not be loaded correctly.
            $dependencyName.Value = $item;

            # Try to load the binary into the PowerShell environment.
            try
            {
                Add-Type -AssemblyName $item -ErrorAction Stop;
            } # Try : Load Binary

            # Caught an error
            catch
            {
                # Failed to load binary; unable to continue
                return $false;
            } # Catch : Caught an error
        } # foreach : Load Binaries



        # Operation was successful
        return $true;
    } # LoadLibrary()





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
        # We are going to use 'Splatting' to make this easier to construct the Invoke-Expression arguments.
        [System.Collections.Hashtable] $hashArguments = [System.Collections.Hashtable]::New();

        # Error Message
        #  Chief Reason for Error
        [string] $errorTitle = "((REASON IS NOT KNOWN))";
        # --------------------------------------



        # Construct the arguments
        $hashArguments = @{
            Command         = "&""$($Global:__PSCAT_COMPLETE_PATH__)"" -ProgramMode ""$($GLOBAL:__PSCAT_PROGRAM_MODE__)""";
            ErrorAction     = "Stop";
        } # Invoke-Expression Arguments



        # Try to launch PowerShell Compact-Archive Tool application
        try
        {
            # Launch the PowerShell Compact-Archive Tool program
            Invoke-Expression @hashArguments;

            # Operation was successful
            return $LASTEXITCODE;
        } # Try: Launch PSCAT


        # Caught an error during Launch
        catch
        {
            # Provide the error message
            $errorTitle = "Failed to launch PowerShell Compact-Archive Tool!"
        } # Catch: Caught an error



        # Generate the full error message
        [string] $errorMessage = ("$($errorTitle)`r`n" + `
                                "Tried to use this command: $($hashArguments.Command)`r`n" + `
                                "Other properties that were used:`r`n" + `
                                "`tError Action: $($hashArguments.ErrorAction)");


        # Display the error message to the user
        [Launcher]::DisplayErrorMessage($errorMessage);


        # Allow the user to read the message.
        [Launcher]::FetchEnterKey();


        # Return the error code that we were unable to start PSCAT.
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

        # This will hold the dependency name that could not be loaded within the environment.
        [string] $errorDependencyName = $null;
        # --------------------------------------



        # Load the necessary libraries required for PSCAT to work properly.
        if (![Launcher]::LoadLibrary([ref] $errorDependencyName))
        {
            # Because we cannot load the necessary dependencies, we cannot continue.
            # Generate the error message
            [string] $errorMessage = ("Failed to load the necessary dependencies!`r`n" + `
                                        "Tried to load:`r`n" + `
                                        "`t$($errorDependencyName)");


            # Adjust the return code to signify that an error had been reached.
            $exitCode = $Global:__EXITCODE_FAILED_TO_LOAD_DEPENDENCY__;


            # Display the error message to the user
            [Launcher]::DisplayErrorMessage($errorMessage);


            # Allow the user to read the message.
            [Launcher]::FetchEnterKey();
        } # if : Unable to Load Dependencies



        # Try to detect if the PowerShell Compact-Archive Tool had been found.
        elseif (![Launcher]::TestFilePath($Global:__PSCAT_COMPLETE_PATH__))
        {
            # Because we cannot find the PSCAT, we cannot continue.
            # Generate the error message
            [string] $errorMessage = ("Failed to locate $($Global:__PSCAT_FILENAME__)`r`n" + `
                                        "Expected Path was:`r`n" + `
                                        "`t$($Global:__PSCAT_COMPLETE_PATH__)");


            # Adjust the return code to signify that an error had been reached.
            $exitCode = $Global:__EXITCODE_CANNOT_FIND_PSCAT__;


            # Display the error message to the user
            [Launcher]::DisplayErrorMessage($errorMessage);


            # Allow the user to read the message.
            [Launcher]::FetchEnterKey();
        } # if : Unable to find PSCAT



        # If we successfully found PSCAT, then launch the program.
        else
        {
            # Execute PSCAT
            $exitCode = [Launcher]::LaunchPSCAT();
        } # Else : Launch the Application



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


# Start the program and then return the exit code upon terminating.
$returnState = [Launcher]::main();


# Thrash the program's global variables.
Uninitialization;


# Try to retrieve the exit code that was returned by the main application and then
#  return it to the Operating System.
#  NOTE: We use the very last index as that was the very last item that was added
#       into the Pipe.  And this last item - is our exit code.
exit $returnState[$returnState.Length - 1];