<#
.SYNOPSIS
    Displays the PowerShell version and the instance's word-width.

.DESCRIPTION
    This debug script is designed to display what PowerShell (.NET Foundation) is present in the user's host system.
    In addition, this script will also display if the PowerShell is being executed in a 32bit or 64bit environment.

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/Alphecca

.INPUTS
    Nothing is to be given or to be provided from a command\pipe.

.OUTPUTS
    Nothing is to be returned or to be sent to the pipe.

.EXAMPLE
    .\PSVersion.ps1

.LINK
    https://github.com/SibTiger/Alphecca
#>




# Program Entry Point (Spine)
# --------------------------
# Documentation:
#     This is the main spine of the program.
# --------------------------
function main()
{
    # Display PowerShell Version
    PSVersion;

    # Determine if the PowerShell process is executed in a 64bit environment or 32bit environment
    PSProcessWidthDisplay $(PSProcessWidthDetection);

    # Prevent destroying the window process before the user sees the results
    Read-Host -Prompt "Press Enter to close";
} # main()




# PowerShell Version
# --------------------------
# Documentation:
#     This function will display the Host's PowerShell version
#     that is available.  This is important as some CMDLets are
#     not available older versions.
# --------------------------
function PSVersion()
{
    Write-Host "PowerShell Version: " -NoNewLine;
    Write-Host $PSVersionTable.PSVersion;
} # PSVersion()




# PowerShell 32/64 Bit-Width Detection
# --------------------------
# Documentation
#    This function will detect the instance Word-Width
# --------------------------
# Return [Bool]
#    True
#        64bit Process
#    False
#        32bit Process (assumed)
function PSProcessWidthDetection()
{
    return [Environment]::Is64BitProcess;
} # PSProcessWidthDetection()




# PowerShell 32/64 Bit-Width Detection
# --------------------------
# Documentation
#    This function will display the PowerShell's process
#    word-width.  This could be important later on, depending
#    on specialized operations.
# --------------------------
# Parameters
#    psWordWidth [Bool]
#        Contains a value of a Bool type determining the
#        word-width of the process's instance.
function PSProcessWidthDisplay([Bool]$psWordWidth)
{
    # Declarations and Initializations
    # -----------------------------------
    # Used for displaying the results nicely to the user.
    Set-Variable -Name "detectedProcessNice";
    # -----------------------------------
    
    # With the environment detected, determine the process environment
    #  and prepare to show the results to the user.
    if ($psWordWidth)
    {
        Set-Variable -Name "detectedProcessNice" -Value "64bit";
    }
    else
    {
        Set-Variable -Name "detectedProcessNice" -Value "32bit";
    }

    # Display the results to the user's terminal
    Write-Host "This PowerShell instance is running under a" `
               $detectedProcessNice "environment";
} # PSProcessWidthDisplay()




# Execute the main
main;

# Exit
Exit;