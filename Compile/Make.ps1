<#
.SYNOPSIS
    Generates the compile program for this project.

.DESCRIPTION
    This program is designed to create the project compiler.
    In order to play this project with GZDoom or its children
    ports, this project's source hierarchy must meet with the
    ZDoom PK3 standards.  The compiler, which this program
    generates, will allow the user to easily create a build
    of the project and is readable to the GZDoom engine.

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/

.INPUTS
    Nothing is to be given or to be provided from a command\pipe.

.OUTPUTS
    Exit Codes:
        0 = Program finished successfully
        1 = Program finished with errors

.EXAMPLE
    .\make.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki
#>




# Global Variables
# --------------------------
# Script Absolute Script Path
Set-Variable -Name "SCRIPTPATH" -Value $PSScriptRoot `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Compiler Script File Name
Set-Variable -Name "SCRIPTFILENAME" -Value "PSCAT.ps1" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Launcher Script File Name
Set-Variable -Name "SCRIPTFILENAMELAUNCHER" -Value "Launcher.ps1" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Subscripts Directory
Set-Variable -Name "SCRIPTSDIRECTORY" -Value "$($GLOBAL:SCRIPTPATH)\..\Scripts\" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Launcher Subscripts Directory
Set-Variable -Name "SCRIPTSDIRECTORYLAUCNHER" -Value "$($GLOBAL:SCRIPTPATH)\..\Scripts\Launcher\" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Output Compiler Directory
Set-Variable -Name "OUTPUTDIRECTORY" -Value "$(Resolve-Path "$($PSScriptRoot)\" | Select-Object -ExpandProperty Path)" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Output Script File
Set-Variable -Name "OUTPUTFILE" -Value "$($GLOBAL:OUTPUTDIRECTORY)$($GLOBAL:SCRIPTFILENAME)" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Cache Program Content instead of Writing to Output Immediately -- can resolve issues with Add-Content per-each iteration.
Set-Variable -Name "CACHEPROGRAMCONTENT" -Value $true `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Cached Program Contents
Set-Variable -Name "CACHEDPROGRAMCONTENTS" `
    -Scope Global -Force -Option None -ErrorAction Stop;
# Project Name
Set-Variable -Name "PROJECTNAME" -Value "PowerShell Compact-Archive Tool" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# DEBUG MODE [Verbose Mode]
Set-Variable -Name "DEBUGMODE" -Value $false `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# --------------------------




# Uninitialize Variables
# --------------------------
# Documentation
#   This function will remove any mutable global variable from
#       the environment.
# ----------------
function UninitializeVariables
{
    # Try to remove global variables
    try
    {
        Remove-Variable -Name CACHEDPROGRAMCONTENTS `
                        -Scope Global `
                        -Force `
                        -ErrorAction Stop;
    } # Try to Uninit. Vars

    # Caught an error
    catch
    {
        Printf 2 "Failed to Uninitialize a mutable global variable!";
        Printf 2 $_.Exception.Message;

        return;
    } # Caught an error
} # UninitializeVariables()




# Print with Formatting
# --------------------------
# Documentation
#    This function display text with the necessary formatting.
#    With the formatting, the messages will be much easier to
#     signify to the user between a successful, warning, and
#     error message.
# --------------------------
# Parameters
#    msgLevel [int]
#     The level of the message to be formatted:
#      0 = Normal
#      1 = Successful
#      2 = Error
#      3 = DEBUG MODE
#    msgString [string]
#     The message to display on the terminal buffer.
# --------------------------
function Printf
{
    # Function Parameters
    param([int] $msgLevel, [string] $msgString)


    # Declarations and Initializations
    # ----------------------------------
    # Sub-Script File (with path)
    Set-Variable -Name "msgBackColor" -Scope Local;
    Set-Variable -Name "msgForeColor" -Scope Local;
    # ----------------------------------

    # Determine the formatting of the message
    switch($msgLevel)
    {
        # Normal
        0
        {
            $msgBackColor = "Black";
            $msgForeColor = "White";
            Break;
        } # Normal

        # --------------

        # Successful
        1
        {
            $msgBackColor = "Black";
            $msgForeColor = "Green";
            Break;
        } # Successful
        
        # --------------

        # Error
        2
        {
            $msgBackColor = "Black";
            $msgForeColor = "Red";
            Break;
        } # Error

        # --------------

        # DEBUG MODE
        3
        {
            $msgBackColor = "Black";
            $msgForeColor = "Yellow";
            Break;
        } # DEBUG MODE

        # --------------

        # Default (Bad Key)
        default
        {
            $msgBackColor = "Black";
            $msgForeColor = "Gray";
            Break;
        } # Default (Bad key)
    } # Switch : Message Level

    # Display the message with the formatting
    Write-Host $msgString -BackgroundColor $msgBackColor -ForegroundColor $msgForeColor;
} # Printf




# Make Compiler
# --------------------------
# Documentation
#    This function will combine all of the sub-scripts into one script
#                       OR
#    This function will cache the contents from the sub-script into a string.
# --------------------------
# Parameters
#    fileName [string]
#     The file name of the file
#    filePath [string]
#     The file path of the script
#    cacheResults [Bool]
#     When true, specifies that the content from the script(s) will be
#       cached into a string instead of being written to a file.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function MakeCompiler
{
    # Function Parameters
    param([string] $fileName, [string] $filePath, [bool] $cacheResults)


    # If Debug Mode is enabled, display the operation
    if ($GLOBAL:DEBUGMODE)
    {
        if (!$cacheResults) { Printf 3 "Including File: $($fileName). . ."; }
        else { Printf 3 "Caching File: $($fileName). . ."; }
        Printf 3 " >> LOCATION:";
        Printf 3 "    $($filePath)";
    } # DEBUGMODE - Starting Task Msg

    # Append the file and assure it was successful\
    if( ($(FileDetection $filePath) -eq 0) -or `                                    # Unable to detect file
        ($(AppendContent $GLOBAL:OUTPUTFILE $filePath $cacheResults) -eq 1) -or `   # Failed to Append Content
        ($(AppendSeparation $GLOBAL:OUTPUTFILE $cacheResults) -eq 1))               # Failed to Append Borders
    {
        # An error occurred
        return 1;
    } # If : File does not exist

    # If Debug Mode is enabled, display the operation passed
    if ($GLOBAL:DEBUGMODE)
    {
        Printf 3 "Added File: $($fileName) successfully!";
    } # DEBUGMODE - Finished Task Msg

    # return successful code
    return 0;
} # MakeCompiler




# Make Compiler
# --------------------------
# Documentation
#    This function will organize how the file should be included into the compiler script.
# --------------------------
# Parameters
#    cacheResults [Bool]
#     When true, specifies that the content from the script(s) will be
#       cached into a string instead of being written to a file.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function MakeCompilerDriver
{
    # Function Parameters
    param([bool] $cacheResults)


    # Declarations and Initializations
    # ----------------------------------
    # Sub-Script File (with path)
    Set-Variable -Name "scriptFile" -Scope Local;
    # Sub-Script Filename
    Set-Variable -Name "scriptFileName" -Scope Local;
    # ----------------------------------

    # Sub-Script Array
    $scriptFileName = @("help.ps1", `
                        "StartUpArguments.ps1"
                        "Initializations.ps1", `
                        "Uninitializations.ps1", `
                        "CommonIO.ps1", `
                        "CommonCUI.ps1", `
                        "CommonGUI.ps1", `
                        "UserExperience.ps1", `
                        "CommonPowerShell.ps1", `
                        "ProgramFunctions.ps1", `
                        "DefaultCompress.ps1", `
                        "ProjectInformation.ps1", `
                        "UserPreferences.ps1", `
                        "LoadSaveUserConfigs.ps1", `
                        "Logging.ps1", `
                        "SystemInformation.ps1", `
                        "WebsiteResources.ps1", `
                        "NotificationAudible.ps1", `
                        "NotificationVisual.ps1", `
                        "Settings.ps1", `
                        "SettingsZip.ps1", `
                        "SettingsProjectUserConfig.ps1", `
                        "ProjectManager.ps1", `
                        "ProjectManagerInstallation.ps1", `
                        "ProjectManagerLoadProject.ps1", `
                        "ProjectManagerCommon.ps1", `
                        "ProjectManagerUninstall.ps1", `
                        "ProjectManagerShowProjects.ps1", `
                        "ProjectMetaData.ps1", `
                        "ProjectUserConfig.ps1", `
                        "ProjectUserConfigLoadSave.ps1", `
                        "ProjectUserConfigSettings.ps1", `
                        "BurntToast.ps1", `
                        "MainMenu.ps1", `
                        "Builder.ps1", `
                        "Clean.ps1", `
                        "main.ps1");

    # Loop through each index in the array
    foreach ($index in $scriptFileName)
    {
        # Update target script
        $scriptFile = "$($GLOBAL:SCRIPTSDIRECTORY)$($index)";

        # Try to append the target script to the destination file
        if ($(MakeCompiler $index $scriptFile $cacheResults))
        {
            # An error occurred
            Printf 2 "Unable to include file: $($scriptFile)";

            # Return error code
            return 1;
        } # If Operation was Successful
    } #foreach


    # Program Contents Cached?
    if (($cacheResults      -eq $true)  -and `      # Contents cached into a string?
        (WriteCacheToFile   -eq 1))                 # Failure had occurred while writing to disk
    {
        # Write contents to disk had failed
        Printf 2 "Failed to write cached contents to disk!";

        # Return error code;
        return 1;
    } # if : Program Contents Cached


    # Operation was successful
    return 0;
} # MakeCompilerDriver




# Append Content to File
# --------------------------
# Documentation
#    This function will append information provided from
#     a specific file and append the data to the destination file.
# --------------------------
# Parameters
#    outputFile [string]
#     The destination file that the data will be appended.
#    targetFile [string]
#     The target file that contains the data that we want
#      to mirror to another file.
#    cacheResults [Bool]
#     When true, specifies that the content from the script(s) will be
#       cached into a string instead of being written to a file.
#       $outputFile will be ignored.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function AppendContent
{
    # Function Parameters
    param([string] $outputFile, [string] $targetFile, [bool] $cacheResults)


    # Write to File
    if ($cacheResults -eq $false)
    {
        # Append Script Contents
        try
        {
            Add-Content -Path $outputFile -Value (Get-Content $targetFile) -ErrorAction Stop;
        } # Try to Append Script Contents

        # Caught an Error
        catch
        {
            # Show the Exception Message
            Printf 2 $_.Exception.Message;
            return 1;
        } # Catch : Failed to Append Contents


        # Operation was successful.
        return 0;
    } # if : Write to File



    # Try to cache the contents into the designated variable
    try
    {
        $GLOBAL:CACHEDPROGRAMCONTENTS += $(Get-Content $targetFile);
    } # try : Cache Contents

    # Caught an Error
    catch
    {
        # Reached CLR limit?
        Printf 2 $_.Exception.Message;
        return 1;
    } # Catch : Caught Error


    # Done
    return 0;
} # AppendContent




# Append Separation to File
# --------------------------
# Documentation
#    This function will append separation, such as borders and white-spacing,
#     to the destination file.  This should make viewing the output
#     script a bit easier.
# --------------------------
# Parameters
#    outputFile [string]
#     The destination file that the data will be appended.
#    cacheResults [Bool]
#     When true, specifies that the content from the script(s) will be
#       cached into a string instead of being written to a file.
#       $outputFile will be ignored.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function AppendSeparation
{
    # Function Parameters
    param([string] $outputFile, [bool] $cacheResults)


    # Declarations and Initializations
    # ----------------------------------
    # Border; useful to separate the scripts
    Set-Variable -Name "scriptSeparatorBorder" -Value "# =====================================================" -Scope Local;
    # White Spacing; helpful to provide spacing between scripts
    Set-Variable -Name "scriptSeparatorWhiteSpace" -Value "`r`n`r`n`r`n`r`n" -Scope Local;
    # Combined separating structure; border and white-spacing between each script.
    Set-Variable -Name "scriptSeparator" -Value `
     "$($scriptSeparatorWhiteSpace)$($scriptSeparatorBorder)`r`n$($scriptSeparatorBorder)`r`n$($scriptSeparatorBorder)$($scriptSeparatorWhiteSpace)" `
      -Scope Local;
    # ----------------------------------


    # Write to file
    if ($cacheResults -eq $false)
    {
        # Append the separation to the script
        try
        {
            Add-Content -Path $outputFile -Value $scriptSeparator -ErrorAction Stop;
        } # Try to Append Separators between Contents

        # Caught an Error
        catch
        {
            # Show the Exception Message
            Printf 2 $_.Exception.Message;
            return 1;
        } # Catch : Failed to Append Separators between Contents


        # Operation was successful.
        return 0;
    } # if : Write to File



    # Try to cache the results to the designated variable.
    try
    {
        $GLOBAL:CACHEDPROGRAMCONTENTS += $scriptSeparator;
    } # try : Cache Contents

    # Caught an Error
    catch
    {
        # Reached CLR limit?
        Printf 2 $_.Exception.Message;
        return 1;
    } # Catch : Caught Error


    # Done
    return 0;
} # AppendSeparation




# Write Cache to File
# --------------------------
# Documentation
#    This function will write the contents that had been
#       cached in the designated string to the output file.
#
# NOTE: Only call this function when the flag,
#       $CACHEPROGRAMCONTENT, is '$true'.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function WriteCacheToFile
{
    # Try to write cached contents to disk
    try
    {
        Add-Content -Path $outputFile -Value $GLOBAL:CACHEDPROGRAMCONTENTS -ErrorAction Stop;
    } # Try : Write Cached Contents to Disk

    # Caught an error
    catch
    {
        # Provide the exception message to the user.
        Printf 2 "ERROR:"
        Printf 2 $_.Exception.Message;

        # Return error
        return 1;
    } # Catch : Failed to Write Cached Contents to Disk


    # Finished
    return 0;
} # WriteCacheToFile()




# Create New Script File
# --------------------------
# Documentation
#    This function merely creates the new script file that will hold all of the
#     sub-scripts into one script file.
# --------------------------
# Return [int]
#    0 = Created file successfully
#    1 = Error occurred; vague
# --------------------------
function CreateNewScriptFile
{
    # Try to create the file; if we are unable to - then return with an error signal.
    try
    {
        New-Item -Path $GLOBAL:OUTPUTDIRECTORY -Name $GLOBAL:SCRIPTFILENAME -ItemType "File" `
            -Value "# The $($GLOBAL:PROJECTNAME) was generated on: $(Get-Date)`r`n`r`n" -ErrorAction Stop | Out-Null;
        return 0;
    } # Try
    catch
    {
        return 1;
    } # Error
} # CreateNewScriptFile




# Expunge Old Script File
# --------------------------
# Documentation
#    This function will delete the old script file that was previously compiled.
# --------------------------
# Return [int]
#    0 = Deleted file successfully
#    1 = Error occurred; vague
# --------------------------
function ExpungeOldScriptFile
{
    # Try to delete the file, if we are unable to - then return with an error signal.
    try
    {
        Remove-Item -Path $GLOBAL:OUTPUTFILE -ErrorAction Stop;
        return 0;
    } # Try
    catch
    {
        return 1;
    } # Error
} # ExpungeOldScriptFile




# Detect if File Exists
# --------------------------
# Documentation
#    This function will check if a specific file exists
#     with the provided path and file.
# --------------------------
# Parameters
#    target [string]
#     The path and filename
# --------------------------
# Return [int]
#    0 = File does not exist
#    1 = File exist
# --------------------------
function FileDetection
{
    # Function Parameters
    param([string]$path)


    if(Test-Path -Path $path)
    {
        return 1;
    } # if : File Exists
    else
    {
        return 0;
    } # else : File does not exist
} # FileDetection




# Existing File Protocol
# --------------------------
# Documentation
#    This function will perform the protocol in assuring that
#     the older script file is removed properly.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed; vague
# --------------------------
function ExistingFileProtocol
{
    if($(FileDetection($GLOBAL:OUTPUTFILE)))
    {
        if (ExpungeOldScriptFile)
        {
            return 1;
        } # Expunge failure
    } # Check existing script
    else
    {
        return 0;
    }
} # ExistingFileProtocol




# Inspector
# --------------------------
# Documentation
#    DEBUG MODE ONLY
#    This function displays all of the global variables.
# --------------------------
function Inspector
{
    # Declarations and Initializations
    # ----------------------------------
    # Inspector Table
    Set-Variable -Name "inspectorTable" -Scope Local;
    # ----------------------------------

    # Create a Hash Table to display the contents; nicer output
    $inspectorTable = @{}

    # Add in the Global Vars. to our HashTable
    $inspectorTable.Add("SCRIPTPATH", "$($GLOBAL:SCRIPTPATH)");
    $inspectorTable.Add("SCRIPTFILENAME", "$($GLOBAL:SCRIPTFILENAME)");
    $inspectorTable.Add("SCRIPTFILENAMELAUNCHER", "$($GLOBAL:SCRIPTFILENAMELAUNCHER)");
    $inspectorTable.Add("SCRIPTSDIRECTORY", "$($GLOBAL:SCRIPTSDIRECTORY)");
    $inspectorTable.Add("SCRIPTSDIRECTORYLAUCNHER", "$($GLOBAL:SCRIPTSDIRECTORYLAUCNHER)");
    $inspectorTable.Add("OUTPUTDIRECTORY", "$($GLOBAL:OUTPUTDIRECTORY)");
    $inspectorTable.Add("OUTPUTFILE", "$($GLOBAL:OUTPUTFILE)");
    $inspectorTable.Add("CACHEPROGRAMCONTENT", "$($GLOBAL:CACHEPROGRAMCONTENT)");
    $inspectorTable.Add("CACHEDPROGRAMCONTENTS", "$($GLOBAL:CACHEDPROGRAMCONTENTS)");
    $inspectorTable.Add("PROJECTNAME", "$($GLOBAL:PROJECTNAME)");
    $inspectorTable.Add("DEBUGMODE", "$($GLOBAL:DEBUGMODE)");


    # Display the Table Header
    Printf 3 "GLOBAL VARIABLE TABLE";

    # Display our table
    Printf 3 ($inspectorTable | Format-Table -AutoSize | Out-String);
    
    # Tell the user how many Global Vars exists
    Printf 3 "Global Variables in use: $($inspectorTable.Count)";

    # Add some extra spacing to make the output nicer -- separating data
    Printf 0 "`n`n";
} # Inspector




# Wait for User Input [Program Termination]
# --------------------------
# Documentation
#    This function merely halts the program allowing
#     the user to view the output before the Terminal
#     is terminated.  Without this, the terminal will
#     automatically be destroyed once EXIT has been
#     reached.  This is only true, however, if the
#     user 'double-clicks' on the script file.  If
#     the terminal session has been active before
#     the script was executed, than this function
#     is redundant - as the terminal will not close
#     once EXIT has been reached.
# --------------------------
function WaitUserInput
{
    Read-Host -Prompt "Press the Enter key to close this program`n";
} # WaitUserInput




# Provide Launcher Script
# --------------------------
# Documentation
#   This function will provide the Launcher script
#   file to the user's focus, this usually is combined
#   with the core of the application.  The Launcher
#   program is a small piece to the main application,
#   but its importance is too great - such that without
#   the Launcher the main application can not work
#   correctly.  The Launcher will prepare the environment
#   where the main application can run successfully and
#   further enrich the user's experience.
# --------------------------
function ProvideLauncher
{
    # Does the file already exists?
    if (FileDetection $GLOBAL:SCRIPTFILENAMELAUNCHER)
    {
        # Found the script file, try to remove it.
        try
        {
            Remove-Item -Path "$($GLOBAL:OUTPUTDIRECTORY)\$($GLOBAL:SCRIPTFILENAMELAUNCHER)" `
                        -ErrorAction Stop;
        } # Try : Remove Script File

        # Error
        catch
        {
            return 1;
        } # Catch : Failed to Remove Script File
    } # if : Detected Launcher Script File


    # Try to duplicate the Launcher file to the output directory
    try
    {
        Copy-Item -Path "$($GLOBAL:SCRIPTSDIRECTORYLAUCNHER)\$($GLOBAL:SCRIPTFILENAMELAUNCHER)" `
                    -Destination "$($GLOBAL:OUTPUTDIRECTORY)\$($GLOBAL:SCRIPTFILENAMELAUNCHER)" `
                    -ErrorAction Stop;
    } # Try : Duplicate Script File

    # Error
    catch
    {
        return 1;
    } # Catch : Failed to Duplicate Script File


    # Operation was successful
    return 0;
} # ProvideLauncher




# Main [Entry Point]
# --------------------------
# Documentation
#    This function is our main program entry point.
# --------------------------
function main
{
    # Output all of the Global Variables [DEBUG MODE]
    if($GLOBAL:DEBUGMODE)
    {
        Inspector;
    } # Inspect Global Vars

    # Tell the user that the program is preparing to generate the script
    Printf 0 "Creating the $($GLOBAL:SCRIPTFILENAME) script file. . .";


    # ===============================================
    # ===============================================
    # First, check if the script file already exists

    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "Checking for existing $($GLOBAL:SCRIPTFILENAME) and thrashing it. . .";
    } # DEBUG MODE
    
    # Check for existing script and delete it - if it exists
    if(ExistingFileProtocol)
    {
        Printf 2 "Unable to successfully delete the old compile script";
        return 1;
    } # Check existing script

    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================
    # Second, create a new script file

    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "Creating a new empty $($GLOBAL:SCRIPTFILENAME) file. . .";
    } # DEBUG MODE

    # Create the script
    if(CreateNewScriptFile)
    {
        Printf 2 "Failure to create the script file";
        return 1;
    } # Create the script

    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================
    # Third, append all of the sub-scripts into one script file
    #       OR
    #       Cache all of the sub-scripts into one large string


    # Write to File
    if ($GLOBAL:CACHEPROGRAMCONTENT -eq $false)
    {
        if($GLOBAL:DEBUGMODE)
        {
            Printf 3 "Building $($GLOBAL:SCRIPTFILENAME) script file. . .";
        } # DEBUG MODE

        # Append the sub-scripts to the main script
        if(MakeCompilerDriver $false)
        {
            Printf 2 "Failure to generate the script file";
            return 1;
        } # Generate the script
    } # if : Write to File

    # Cache to String
    else
    {
        if($GLOBAL:DEBUGMODE)
        {
            Printf 3 "Caching $($GLOBAL:SCRIPTFILENAME) contents into main memory. . .";
        } # DEBUG MODE

        # Cache the sub-scripts contents into a string datatype.
        if(MakeCompilerDriver $true)
        {
            Printf 2 "Failure to cache the contents!`r`n`tDid we go beyond the CLR memory restrictions?";
            return 1;
        } # Generate the script
    } # else : Cache to String



    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================
    # Fourth, provide the Launcher script file


    if($GLOBAL:DEBUGMODE)
    {
        Printf 3 "Providing $($GLOBAL:SCRIPTFILENAMELAUNCHER) script file. . .";
    } # DEBUG MODE

    # Setup the Launcher for easy access
    if (ProvideLauncher)
    {
        Printf 2 "Failure to prepare the Launcher script file";
        return 1;
    } # Prepare the Launcher

    if ($GLOBAL:DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================

    # Display a message that the build has been generated
    Printf 1 "$($GLOBAL:SCRIPTFILENAMELAUNCHER) is ready!";
    Printf 1 "You may find the $($GLOBAL:SCRIPTFILENAMELAUNCHER) in this path:";
    Printf 1 "  $($GLOBAL:OUTPUTDIRECTORY)$($GLOBAL:SCRIPTFILENAMELAUNCHER)";
    Printf 1 "$($GLOBAL:SCRIPTFILENAME) has been successfully created!";
    Printf 1 "You may find the $($GLOBAL:SCRIPTFILENAME) in this path:";
    Printf 1 "  $($GLOBAL:OUTPUTFILE)";


    # Successful operation
    return 0;
} # main




# Start the program
$errorSignal = $(main);

# Remove mutable variables
UninitializeVariables

# Wait for the user to view the results
WaitUserInput;

# Terminate the program and provide the Error Code to the OS
exit $errorSignal;