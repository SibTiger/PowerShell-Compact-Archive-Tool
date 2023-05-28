<# PowerShell Compact-Archive Tool
 # Copyright (C) 2023
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




<# Cleanup Entry Point
 # ------------------------------
 # ==============================
 # ==============================
 # This source file will allow the ability to cleanup all files and directories that are associated with the software.
 #  With this functionality, the user can merely clean their filesystem by removing compiled builds, logs, reports,
 #  and their configuration files with ease.
 # The following is supported:
 #  - Cleanup
 #      Removes the following:
 #      - Compiled Builds
 #      - Log files
 #      - Report files
 #  - Deep Cleanup
 #      - Compiled Builds
 #      - Log files
 #      - Report files
 #      - User Configuration Files
 # ----------------------------
 # Exit Codes:
 # 0 = Successfully
 # 1 = Operation had Failed
 #>




# Cleanup Entry Point
# --------------------------
# Documentation:
#  This function is a sub-entry point of the program, which is invoked by setting the Program Mode to either '1' or '2'.
#   This functionality is not driven by the main driver and will not use the main driver afterwards, as such this function
#   is a stand-alone.
# --------------------------
function clean()
{
    param(
        # Deletes all builds, logs, report files, and user configuration.
        [Parameter(Mandatory=$true)]
        [ValidateRange(1, 2)]
        [byte]$programMode
    )


    # Declarations and Initializations
    # ----------------------------------------
    # This variable will hold our return code.
    [int] $exitLevel = 0;


    # This variable will provide how long the splash screen should be displayed on the terminal.
    #  Because I want the splash screen to be displayed AND still having some work done in the background, we will capture the time now.
    [UInt64] $splashScreenHoldTime = ((Get-Date) + (New-TimeSpan -Seconds $Global:_STARTUPSPLASHSCREENHOLDTIME_)).Ticks;


    # This will hold what directories could not be automatically removed.  Once fully populated,
    #   the results stored in this variable will be visible in a message box.
    [string] $messageBoxError = $null;


    # When there was an error during the removal process, this flag will be raised again.
    [bool] $errorFlag = $false;
    # ----------------------------------------



    # Clear the host's terminal buffer
    [CommonIO]::ClearBuffer();


    # Display the Startup Splash Screen
    [CommonCUI]::StartUpScreen();


    # Provide a new Window Title
    [CommonIO]::SetTerminalWindowTitle("$($Global:_PROGRAMNAME_) (Version $($Global:_VERSION_)) - Clean Mode");


    # Load the user's configurations, if available.
    $loadSaveUserConfiguration.Load();


    # Let the user know that the application is preparing to perform an action
    [CommonIO]::WriteToBuffer("Preparing Operation: ", + `
                            [LogMessageLevel]::Standard, + `
                            $true);


    # Show that the program is about to perform the following actions:
    switch ($programMode)
    {
        # Clean Up Mode
        {($_ -eq [CleanUpModeType]::CleanUp)}
        {
            # Let the user know that the application is performing a clean up.
            [CommonIO]::WriteToBuffer("Cleaning Up`r`n`r`n", + `
                                        [LogMessageLevel]::Warning, + `
                                        $false);
        } # Clean Up Mode


        # Deep Clean Up Mode
        {($_ -eq [CleanUpModeType]::DeepCleanUp)}
        {
            # Let the user know that the application is performing a deep cleanup.
            [CommonIO]::WriteToBuffer("Deep Clean Up`r`n`r`n", + `
                                        [LogMessageLevel]::Warning, + `
                                        $false);
        } # Deep Clean Up Mode
    } # switch : Program Mode


    # Disable the logging functionality
    [Logging]::SetRestrictLogging($true);


    # Delay the program momentarily so the user can see the splash screen.
    [CommonIO]::DelayTicks($splashScreenHoldTime);


    # Let the user know that the operation could take some time to finish
    [CommonIO]::WriteToBuffer("This operation may take awhile, depending as to how many builds were generated by $($Global:_PROGRAMNAME_)...`r`n`r`n", + `
                                [LogMessageLevel]::Standard, + `
                                $false);




    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    #                                 Expunge the Data




    # Let the user know that the application is preparing to perform an action
    [CommonIO]::WriteToBuffer("Deleting the following directories: ", + `
                                [LogMessageLevel]::Standard, + `
                                $false);



    # LOG FILES
    # -----------
    # -----------


    # Delete all of the log\report files and directories
    [CommonIO]::WriteToBuffer("`tLog Files`r`n`t`t$GLOBAL:_PROGRAMDATA_ROOT_LOCAL_PATH_", + `
                                [LogMessageLevel]::Warning, + `
                                $false);


    if (![CommonIO]::DeleteDirectory($GLOBAL:_PROGRAMDATA_ROOT_LOCAL_PATH_))
    {
        # Raise the error flag
        if (!$errorFlag) {$errorFlag = $true;}

        # Include the directory path.
        $messageBoxError += "`r`n>>> $($GLOBAL:_PROGRAMDATA_ROOT_LOCAL_PATH_)";

        # Show that the directory could not be removed.
        [CommonIO]::WriteToBuffer("`t`tFailed!", + `
                                    [LogMessageLevel]::Error, + `
                                    $false);
    } # if : Failed to Delete Directory - Logs\Reports



    # User Configuration
    #        AND
    # Installed Projects
    # -----------
    # -----------


    # Delete the user configuration AND installed projects
    if ($programMode -eq [CleanUpModeType]::DeepCleanUp)
    {
        [CommonIO]::WriteToBuffer("`tUser Configuration and Installed Projects`r`n`t`t$GLOBAL:_PROGRAMDATA_ROOT_ROAMING_PATH_", + `
                                    [LogMessageLevel]::Warning, + `
                                    $false);


        if (![CommonIO]::DeleteDirectory($GLOBAL:_PROGRAMDATA_ROOT_ROAMING_PATH_))
        {
            # Raise the error flag
            if (!$errorFlag) {$errorFlag = $true;}

            # Include the directory path.
            $messageBoxError += "`r`n>>> $($GLOBAL:_PROGRAMDATA_ROOT_ROAMING_PATH_)";

            # Show that the directory could not be removed.
            [CommonIO]::WriteToBuffer("`t`tFailed!", + `
                                        [LogMessageLevel]::Error, + `
                                        $false);
        } # if : Failed to Delete Directory - Logs\Reports
    } # if : Deep Clean Up



    # Compiled Builds
    # -----------
    # -----------


    # Delete all of the compiled builds
    [CommonIO]::WriteToBuffer("`tCompiled Builds`r`n`t`t$GLOBAL:_USERDATA_ROOT_PATH_", + `
                                [LogMessageLevel]::Warning, + `
                                $false);


    if (![CommonIO]::DeleteDirectory($GLOBAL:_USERDATA_ROOT_PATH_))
    {
        # Raise the error flag
        if (!$errorFlag) {$errorFlag = $true;}

        # Include the directory path.
        $messageBoxError += "`r`n>>> $($GLOBAL:_USERDATA_ROOT_PATH_)";

        # Show that the directory could be removed.
        [CommonIO]::WriteToBuffer("`t`tFailed!", + `
                                    [LogMessageLevel]::Error, + `
                                    $false);
    } # if : Failed to Delete Directory - Compiled Builds




    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    #                                    Finished!



    # Display an error message to the user that there were errors during the operation.
    if ($errorFlag)
    {
        # Display the Message Box to the user indicating the errors.
        [CommonGUI]::MessageBox("Failed to delete the following directories:$($messageBoxError)", `
                                [System.Windows.MessageBoxImage]::Hand) | Out-Null;
    } # if : Errors Occurred

    # Display a message indicating that the operation was successful
    else
    {
        # Display the Message Box to the user indicating that the operation was successful.
        [CommonGUI]::MessageBox("Operation was successful!", `
                                [System.Windows.MessageBoxImage]::Asterisk) | Out-Null;
    } # else : Operation was Successful



    # Let the user know that the operation had concluded.
    [CommonIO]::WriteToBuffer("`r`nOperation had finished!", + `
                                [LogMessageLevel]::Standard, + `
                                $false);


    # Allow the user to read the information that is presented on the terminal's buffer
    [CommonIO]::FetchEnterKey();


    # Restore the Window Title back to it's state.
    [CommonIO]::SetTerminalWindowTitle($Global:_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_);


    # Operation had been finished, return the main operation return code.
    return $exitLevel;
} # clean()




<# Clean Up Mode Type [ENUM]
 # -------------------------------
 # This provides specific cleanup types that can be handled within the clean functionality.
 # -------------------------------
 #>
enum CleanUpModeType
{
    Nothing     = 0;        # No cleaning is required
    CleanUp     = 1;        # Standard Cleanup Operation
    DeepCleanUp = 2;        # Deep Cleanup Operation
} # CleanUpModeType