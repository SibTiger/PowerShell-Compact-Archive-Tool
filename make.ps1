<#
.SYNOPSIS
    Generates the compile program for this project.

.DESCRIPTION
    This program is designed to create the project compiler.
    In order to play this project with GZDoom or its children
    ports, this project's source hierarchy must meet with the
    ZDoom PK3 and PK7 standards.  The compiler, which this
    program generates, will allow the user to easily create
    a build of the project and is readable to the GZDoom
    engine.

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/Alphecca

.INPUTS
    Nothing is to be given or to be provided from a command\pipe.

.OUTPUTS
    Exit Codes:
        0 = Program finished successfully
        1 = Program finished with errors

.EXAMPLE
    .\make.ps1

.LINK
    https://github.com/SibTiger/Alphecca
    https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement
#>




# Global Variables
# --------------------------
# Script Absolute Script Path
Set-Variable -Name "SCRIPTPATH" -Value $PSScriptRoot `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Compiler Script File Name
Set-Variable -Name "SCRIPTFILENAME" -Value "compile.ps1" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Subscripts Directory
Set-Variable -Name "SCRIPTSDIRECTORY" -Value "$($SCRIPTPATH)\Scripts\" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Output Compiler Directory
Set-Variable -Name "OUTPUTDIRECTORY" -Value "$(Resolve-Path "$($PSScriptRoot)\" | select -ExpandProperty Path)" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Output Script File
Set-Variable -Name "OUTPUTFILE" -Value "$($OUTPUTDIRECTORY)$($SCRIPTFILENAME)" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# Project Name
Set-Variable -Name "PROJECTNAME" -Value "Alphecca" `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# DEBUG MODE [Verbose Mode]
Set-Variable -Name "DEBUGMODE" -Value $false `
    -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
# --------------------------




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
function Printf([int] $msgLevel, [string] $msgString)
{
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
} # Printf()




# Make Compiler
# --------------------------
# Documentation
#    This function will combine all of the sub-scripts into one script.
# --------------------------
# Parameters
#    fileName [string]
#     The file name of the file
#    filePath [string]
#     The file path of the script
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function MakeCompiler([string] $fileName, [string] $filePath)
{
    # If Debug Mode is enabled, display the operation
    if ($DEBUGMODE)
    {
        Printf 3 "Including File: $($fileName). . .";
        Printf 3 " >> LOCATION:";
        Printf 3 "    $($filePath)";
    } # DEBUGMODE - Starting Task Msg

    # Append the file and assure it was successful
    if (!($(FileDetection $filePath) -and $(AppendContent $OUTPUTFILE $filePath) -and $(AppendSeparation $OUTPUTFILE)))
    {
        # An error occurred
        return 1;
    } # If : File does not exist

    # If Debug Mode is enabled, display the operation passed
    if ($DEBUGMODE)
    {
        Printf 3 "Added File: $($fileName) successfully!";
    } # DEBUGMODE - Finished Task Msg

    # return successful code
    return 0;
} # MakeCompiler()




# Make Compiler
# --------------------------
# Documentation
#    This function will organize how the file should be included into the compiler script.
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function MakeCompilerDriver()
{
    # Declarations and Initializations
    # ----------------------------------
    # Sub-Script File (with path)
    Set-Variable -Name "scriptFile" -Scope Local;
    # Sub-Script Filename
    Set-Variable -Name "scriptFileName" -Scope Local;
    # ----------------------------------

    # Sub-Script Array
    $scriptFileName = @("help.ps1", `
                        "Initializations.ps1", `
                        "IOCommon.ps1", `
                        "CommonCUI.ps1", `
                        "ProgramFunctions.ps1", `
                        "DefaultCompress.ps1", `
                        "GitControl.ps1", `
                        "ProjectInformation.ps1", `
                        "SevenZip.ps1", `
                        "UserPreferences.ps1", `
                        "LoadSaveUserConfigs.ps1", `
                        "Logging.ps1", `
                        "SystemInformation.ps1", `
                        "WebsiteResources.ps1", `
                        "MainMenu.ps1", `
                        "main.ps1");

    # Loop through each index in the array
    foreach ($index in $scriptFileName)
    {
        # Update target script
        $scriptFile = "$($SCRIPTSDIRECTORY)$($index)";

        # Try to append the target script to the destination file
        if ($(MakeCompiler $index $scriptFile))
        {
            # An error occurred
            Printf 2 "Unable to include file: $($scriptFile)";

            # Return error code
            return 1;
        } # If Operation was Successful
    } #foreach

    # Operation was successful
    return 0;
} # MakeCompilerDriver()




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
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function AppendContent([string] $outputFile, [string] $targetFile)
{
    if((Add-Content -Path $outputFile -Value (Get-Content $targetFile) -ErrorAction SilentlyContinue))
    {
        return 0;
    } # If:Successful
    else
    {
        return 1;
    } # Else:Failure
} # AppendContent()




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
# --------------------------
# Return [int]
#    0 = Operation was successful
#    1 = Operation failed
# --------------------------
function AppendSeparation([string] $outputFile)
{
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

    # Append the separation to the script
    if((Add-Content -Path $outputFile -Value $($scriptSeparator) -ErrorAction SilentlyContinue))
    {
        return 0;
    } # If:Successful
    else
    {
        return 1;
    } # Else:Failure
} # AppendSeparation()




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
function CreateNewScriptFile()
{
    # Try to create the file; if we are unable to - then return with an error signal.
    try
    {
        New-Item -Path $OUTPUTDIRECTORY -Name $SCRIPTFILENAME -ItemType "File" `
            -Value "# $($PROJECTNAME) Compiler was generated on: $(Get-Date)`r`n`r`n" -ErrorAction Stop | Out-Null;
        return 0;
    } # Try
    catch
    {
        return 1;
    } # Error
} # CreateNewScriptFile()




# Expunge Old Script File
# --------------------------
# Documentation
#    This function will delete the old script file that was previously compiled.
# --------------------------
# Return [int]
#    0 = Deleted file successfully
#    1 = Error occurred; vague
# --------------------------
function ExpungeOldScriptFile()
{
    # Try to delete the file, if we are unable to - then return with an error signal.
    try
    {
        Remove-Item -Path $OUTPUTFILE -ErrorAction Stop;
        return 0;
    } # Try
    catch
    {
        return 1;
    } # Error
} # ExpungeOldScriptFile()




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
function FileDetection([string]$path)
{
    if(Test-Path -Path $path)
    {
        return 1;
    } # if : File Exists
    else
    {
        return 0;
    } # else : File does not exist
} # FileDetection()




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
function ExistingFileProtocol()
{
    if($(FileDetection($OUTPUTFILE)))
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
} # ExistingFileProtocol()




# Inspector
# --------------------------
# Documentation
#    DEBUG MODE ONLY
#    This function displays all of the global variables.
# --------------------------
function Inspector()
{
    # Declarations and Initializations
    # ----------------------------------
    # Inspector Table
    Set-Variable -Name "inspectorTable" -Scope Local;
    # ----------------------------------

    # Create a Hash Table to display the contents; nicer output
    $inspectorTable = @{}

    # Add in the Global Vars. to our HashTable
    $inspectorTable.Add("SCRIPTPATH", "$($SCRIPTPATH)");
    $inspectorTable.Add("SCRIPTFILENAME", "$($SCRIPTFILENAME)");
    $inspectorTable.Add("SCRIPTSDIRECTORY", "$($SCRIPTSDIRECTORY)");
    $inspectorTable.Add("OUTPUTDIRECTORY", "$($OUTPUTDIRECTORY)");
    $inspectorTable.Add("OUTPUTFILE", "$($OUTPUTFILE)");
    $inspectorTable.Add("PROJECTNAME", "$($PROJECTNAME)");

    # Display the Table Header
    Printf 3 "GLOBAL VARIABLE TABLE";

    # Display our table
    Printf 3 ($inspectorTable|Format-Table -AutoSize|Out-String);
    
    # Tell the user how many Global Vars exists
    Printf 3 "Global Variables in use: $($inspectorTable.Count)";

    # Add some extra spacing to make the output nicer -- separating data
    Printf 0 "`n`n";
} # Inspector()




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
function WaitUserInput()
{
    Read-Host -Prompt "Press the Enter key to close this program`n";
} # WaitUserInput()




# Main [Entry Point]
# --------------------------
# Documentation
#    This function is our main program entry point.
# --------------------------
function main()
{
    # Output all of the Global Variables [DEBUG MODE]
    if($DEBUGMODE)
    {
        Inspector;
    } # Inspect Global Vars

    # Tell the user that the program is preparing to generate the script
    Printf 0 "Creating the $($SCRIPTFILENAME) script file. . .";


    # ===============================================
    # ===============================================
    # First, check if the script file already exists

    if($DEBUGMODE)
    {
        Printf 3 "Checking for existing $($SCRIPTFILENAME) and thrashing it. . .";
    } # DEBUG MODE
    
    # Check for existing script and delete it - if it exists
    if(ExistingFileProtocol)
    {
        Printf 2 "Unable to successfully delete the old compile script";
        return 1;
    } # Check existing script

    if($DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================
    # Second, create a new script file

    if($DEBUGMODE)
    {
        Printf 3 "Creating a new empty $($SCRIPTFILENAME) file. . .";
    } # DEBUG MODE

    # Create the script
    if(CreateNewScriptFile)
    {
        Printf 2 "Failure to create the script file";
        return 1;
    } # Create the script

    if($DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================
    # Third, append all of the sub-scripts into one script file

    if($DEBUGMODE)
    {
        Printf 3 "Building $($SCRIPTFILENAME) script file. . .";
    } # DEBUG MODE

    # Append the sub-scripts to the main script
    if(MakeCompilerDriver)
    {
        Printf 2 "Failure to generate the script file";
        return 1;
    } # Generate the script

    if($DEBUGMODE)
    {
        Printf 3 "  Done!";
    } # DEBUG MODE


    # ===============================================
    # ===============================================

    # Display a message that the build has been generated
    Printf 1 "$($SCRIPTFILENAME) has been successfully created!";
    Printf 1 "You may find the $($SCRIPTFILENAME) in this path:";
    Printf 1 "  $($OUTPUTFILE)";

    # Successful operation
    return 0;
} # main()




# Start the program
$errorSignal = $(main);

# Wait for the user to view the results
WaitUserInput;

# Terminate the program and provide the Error Code to the OS
exit $errorSignal;