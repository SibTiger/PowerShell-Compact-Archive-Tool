<#
.SYNOPSIS
    Debug-Trace POSH ShellScripts

.DESCRIPTION
    This debug script will enable POSH's debugger, primarily to be used for ShellScripts.  When wanting to debug the ShellScript, the programmer may inspect what variable is being initialized too or statement is being called at Runtime.
    For more information, please see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/PowerShell-Compact-Archive-Tool

.INPUTS
    Nothing is to be given or to be provided from a command\pipe.

.OUTPUTS
    Nothing is to be returned or to be sent to the pipe.

.EXAMPLE
    .\TraceStep.ps1

.LINK
    https://github.com/SibTiger/PowerShell-Compact-Archive-Tool
#>




# Program Entry Point (Spine)
# --------------------------
# Documentation:
#     This is the main spine of the program.
#     Evaluate what the user wants to do; setup the PSDebug CMDLet args.
# --------------------------
function main()
{
    # Declarations and Initializations
    # ------------------------------------
    [bool] $loopControl = $true;        # Controller for the do-while() loop.
                                        #  True = Keep looping.
    [string] $menuRequest = "$null";    # User's driven request within the menu.
    [bool] $optStep = $false;           # Enable or disable the '-Step' arg.
    [int] $optTrace = 1;                # Tracing method number use with the '-Trace' arg.
    # ------------------------------------

    # Execute an endless loop; we will use this to get the user's feedback.
    do
    {
        # Display the menu
        Menu $optTrace $optStep;

        # Get the user's feedback
        $menuRequest = GetInput;

        # Evaluate the feedback
        Switch($menuRequest)
        {
            # Trace: Statements
            "1"
            {
                # Change to the requested trace
                $optTrace = 1;

                # Leave
                Break;
            } # Trace: Statements


            # Trace: Everything
            "2"
            {
                # Change to the requested trace
                $optTrace = 2;

                # Leave
                Break;
            } # Trace: Everything


            # Toggle Step
            "S"
            {
                # Toggle the -Step arg
                if ($optStep -eq $false)
                {
                    # Enable Step-wise
                    $optStep = $true;
                } # IF : Step is Disabled
                else
                {
                    # Disable Step-wise
                    $optStep = $false;
                } # Else : Step is Enabled

                # Leave
                Break;
            } # Toggle Step


            # Exit & Disable PSDebug
            "K"
            {
                # We can leave the loop
                $loopControl = $false;

                # Setup the PSDebug CMDLet [Disable]
                Initialize $optTrace $optStep $false;

                # Leave
                Break;
            } # Exit & Disable PSDebug


            # Exit & Enable PSDebug
            "X"
            {
                # We can leave the loop
                $loopControl = $false;

                # Setup the PSDebug CMDLet
                Initialize $optTrace $optStep $true;

                # Leave
                Break;
            } # Exit & Enable PSDebug


            # Unknown or bad option
            Default
            {
                Write-Host "Incorrect option or bad response provided.`r`n",
                           "Please select from the options provided in the main menu.";

                # Leave
                Break;
            } # Unknown or bad option
        } # Switch : Evaluate Feedback

        # Provide some extra spacing; easier on the eyes
        Write-Host "`r`n`r`n`r`n`r`n";
    } while($loopControl)
} # main()




function GetInput()
{
    # Because I love Python's input prompt, we will emulate it here.
    #  I find this to be easier on the user to unify an action from the end-user.
    Write-Host ">>>>> " -NoNewline;

    # Get input from the user.
    [string] $stdInput = (Get-Host).UI.ReadLine();

    # Return the value as a string
    return [string]$stdInput;
} # GetInput()




function Menu()
{
    # Parameters
    Param(
        [int] $valueTrace,  #Trace Option
        [bool] $valueStep   #Step Option
    ) # Function Parameters

    # Display the main menu
    Write-Host "Main Menu Options for the PSDebug CMDLet:`r`n",
               "-------------------------------------------`r`n",
               "[1] Only Trace each Statement`r`n",
               "[2] Trace everything`r`n",
               "    Trace each statement, Variables Init.,`r`n",
               "    Function Calls, and Ext. ShellScript Calls`r`n",
               "[S] Toggle Step-Wise`r`n",
               "[K] Exit and Deactivate PSDebug`r`n",
               "[X] Exit and Activate PSDebug`r`n",
               " - - - - - - - - - - - - - - - - - - - - -`r`n",
               "Values:`r`n",
               "Trace Value is: $($valueTrace)`r`n",
               "Step Value is: $($valueStep)`r`n",
               "`r`n`r`n",
               "More information about Set-PSDebug:`r`n",
               "https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug`r`n";
} # Menu()




function Initialize()
{
    # Parameters
    Param(
        [int] $valueTrace,   # Trace option
        [bool] $valueStep,   # Step option
        [bool] $statePSDebug # Enable or Disable the PSDebug
    ) # Function Parameters


    # Should we disable the PSDebug?
    if ($statePSDebug -eq $false)
    {
        # Turn off the PSDebug
        Set-PSDebug -Off;

        # Leave the function
        return;
    } # If : PSDebug Disabled


    # Is step enabled?
    if ($valueStep -eq $true)
    {
        # Step is enabled
        Set-PSDebug -Trace $valueTrace -Step;
    } # If : Step-wise enabled

    else
    {
        # Step is disabled
        Set-PSDebug -Trace $valueTrace;
    } # Else : Step-wise disabled
} # Initialize()




# Execute the program
main;