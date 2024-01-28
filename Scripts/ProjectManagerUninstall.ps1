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




<# Project Manager - Uninstall Project
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability for the user to uninstall PowerShell Compact-Archive Tool projects.
 #  Removing Projects will come necessary when needing to delete data that is no longer necessary, or
 #  if wanting to discard an outdated version for a newer version.  Or, hopefully never coming to this,
 #  discarding a buggy project version in exchange for cleaner version.
 #>




class ProjectManagerUninstall
{
   <# Project Manager Uninstaller - Main Entry
    # -------------------------------
    # Documentation:
    #   This function will drive the uninstallation procedure such that the desired PSCAT Projects are
    #   safely removed from the program's environment.
    # -------------------------------
    #>
    hidden static [void] __Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will contain a list of projects that had been installed within the environment.
        [System.Collections.ArrayList] $listOfProjectsInstalled = [System.Collections.ArrayList]::New();

        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $NULL;

        # This variable will determine if the user is to remain within the current menu loop.  If the
        #   user were to exit from the menu, this variable's state will be set as false.
        [bool] $menuLoop = $true;
        # ----------------------------------------



        # Present the Project Uninstallation Menu to the user
        do
        {
            # Clear the list of projects
            $listOfProjectsInstalled.Clear();


            # Clear the terminal of all previous text; keep the space clean so that it is easier
            #   for the user to read the information presented.
            [CommonIO]::ClearBuffer();


            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();


            # Show the user that they are at the Uninstall Project Menu
            [CommonCUI]::DrawSectionHeader("Uninstall $($GLOBAL:_PROGRAMNAMESHORT_) Projects");


            # Provide the instructions
            [ProjectManagerCommon]::__DrawMenuInstructionsForTable();


            # Show the list of projects to the user; we will also obtain the list of projects, the user
            #   will use this list to select what to uninstall.
            if (![ProjectManagerUninstall]::__ShowUserListOfInstalledProjects($listOfProjectsInstalled))
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------
                # Generate the initial message
                [string] $logMessage = ("Unable to uninstall any $($GLOBAL:_PROGRAMNAMESHORT_) Projects!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = $NULL;

                # Pass the information to the logging system
                [Logging]::LogProgramActivity(  $logMessage, `                  # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Warning);    # Message level

                # Display a message to the user that there was no projects found and log that same message for
                #  referencing purpose.
                [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                            [LogMessageLevel]::Warning);    # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Abort the uninstallation procedure.
                return;
            } # if : No Projects Available


            # Provide some whitespace padding.
            [Logging]::DisplayMessage("`r`n");


            # Show the user the extra menu items.
            [ProjectManagerUninstall]::__ShowUserExtraMenuItems();


            # Provide some whitespace padding.
            [Logging]::DisplayMessage("`r`n`r`n");


            # Get the user's Feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);


            # Execute the user's request
            $menuLoop = [ProjectManagerUninstall]::__EvaluateExecuteUserRequest($userInput,                 `
                                                                                $listOfProjectsInstalled);
        } while($menuLoop);
    } # __Main()




   <# Project Manager Uninstaller - Show User List of Installed Projects
    # -------------------------------
    # Documentation:
    #  This function is designed to show the user what projects are presently installed within PSCAT's
    #   current environment.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] List of Projects that are Installed
    #   This is intended to be returned to the calling function such that the user can properly select the
    #   desired project to remove.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed
    #     $true  = Operation was successful
    # -------------------------------
    #>
    hidden static [bool] __ShowUserListOfInstalledProjects([System.Collections.ArrayList] $listOfProjectsInstalled)
    {
        # Obtain a list of installed projects
        if ((![ProjectManagerCommon]::__GetInstalledProjects($listOfProjectsInstalled)) -or `   # Failure occurred
            ($NULL -eq $listOfProjectsInstalled)                                        -or `   # No installs found
            ($listOfProjectsInstalled.Count -eq 0))                                             # No installs found
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------
            # Generate the initial message
            [string] $logMessage = ("Unable to find any installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!`r`n" + `
                                    "You may need to install new projects into $($GLOBAL:_PROGRAMNAME_).");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                            "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Display a message to the user that there was no projects found and log that same message for
            #  referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                        [LogMessageLevel]::Warning);    # Message level

            # Alert the user through a message box as well that an event had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Warning) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Finished; nothing more we can do.
            return $false;
        } # if : No Installed Projects Found


        # Show the list of installed projects to the user
        [ProjectManagerCommon]::DrawTableProjectInformation($listOfProjectsInstalled);


        # Finished
        return $true;
    } # __ShowUserListOfInstalledProjects()




   <# Project Manager Uninstaller - Extra Menu Items
    # -------------------------------
    # Documentation:
    #  Present extra menu items that are available within the menu.
    # -------------------------------
    #>
    hidden static [void] __ShowUserExtraMenuItems()
    {
        # Other Options Section
        [Logging]::DisplayMessage("Other Options:");


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to previous menu", `
                                $NULL, `
                                $NULL, `
                                $false);
    } # __ShowUserExtraMenuItems()




   <# Project Manager Uninstaller - Evaluate and Execute User's Request
    # -------------------------------
    # Documentation:
    #  This function will evaluate and execute the user's desired request in respect to the
    #   Project Manager Uninstaller's menu options given.
    # -------------------------------
    # [string] User's Request
    #  User's request to uninstall a specific PSCAT Project OR to run a specific operation that
    #   is available within the menu.
    # [System.Collections.ArrayList] List of Projects Installed
    #  A list of projects that are installed within PowerShell Compact-Archive Tool's environment.
    # -------------------------------
    # Output:
    #  [bool] User Stays at Menu
    #   This defines if the user is to remain at the Menu screen.
    #   $true  = User is to remain at the Menu.
    #   $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] __EvaluateExecuteUserRequest([string] $userRequest,                                  ` # User's Request to Execute
                                                    [System.Collections.ArrayList] $listOfProjectsInstalled)    # List of Projects that are Installed
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Determines if the user wants to stay within the menu.
        [bool] $stayInMenu = $true;

        # Determines if the input provided by the user was incorrect.
        [bool] $badInput = $false;
        # ----------------------------------------



        # If the user provided a numerical value, we will need to cast it from a string data type.
        try
        {
            # Try to cast the user's input as a numerical value - if possible.
            [UInt64] $userRequestNumber = [Convert]::ToUInt64($userRequest);


            # Determine if the user's request is within the range of the Projects that are installed.
            #   In this check, we want to determine if the number is outside the bounds of the list.
            if (($userRequestNumber -gt $listOfProjectsInstalled.Count) -or `   # Number exceeds the list
                ($userRequestNumber -eq 0))                                     # Number is equal to zero
            { $badInput = $true; }


            # Delete the desired project
            else
            {
                # Because the table shows each row as 'natural' numbers, we will need to convert the numbers
                #   to the whole numbers format.
                $userRequestNumber--;

                # Uninstall the project as requested
                [ProjectManagerUninstall]::__UninstallProject($listOfProjectsInstalled[$userRequestNumber]);
            } # else : Uninstall the Project
        } # Try : User Provided Numerical Value


        # The user had provided a non-numerical value.
        catch
        {
            # Evaluate the user's non-numerical value
            switch ($userRequest)
            {
                # Exit
                #  NOTE: Allow the user's request when they type: 'Exit', 'Quit', 'Abort', 'Cancel',
                #   'Return', as well as 'X'.
                {   ($userRequest -eq "X")      -or `
                    ($userRequest -eq "Exit")   -or `
                    ($userRequest -eq "Quit")   -or `
                    ($userRequest -eq "Abort")  -or `
                    ($userRequest -eq "Return") -or `
                    ($userRequest -eq "Cancel")}
                { $stayInMenu = $false; }

                # Unknown Value
                default
                { $badInput = $true; }
            } # Switch : Evaluate Non-Numerical Value
        } # catch : User Provided Non-Numerical Value


        # Was Bad Input given?
        if ($badInput)
        {
            # Alert the user that they had provided an incorrect option.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


            # Provide an error message to the user that the option they chose is
            #  not available.
            [CommonCUI]::DrawIncorrectMenuOption();
        } # if : User Provided Incorrect Input


        # Finished
        return $stayInMenu;
    } # __EvaluateExecuteUserRequest()




   <# Project Manager Uninstaller - Uninstall Project Driver
    # -------------------------------
    # Documentation:
    #  This function will try to remove the desired project from the PSCAT's environment as requested by
    #   the user.
    # -------------------------------
    # [ProjectMetaData] Project to Remove
    #   The PowerShell Compact-Archive Tool Project that will be removed from the program's environment.
    # -------------------------------
    #>
    hidden static [void] __UninstallProject([ProjectMetaData] $projectToRemove)
    {
        # Confirm with the user if they /really/ wish to delete the project.
        if (![ProjectManagerUninstall]::__UninstallProjectConfirm($projectToRemove))
        {
            # User had canceled the operation


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Uninstallation had been canceled by the user.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  `
                            "Project Target Path:`r`n"                                                  + `
                            "`t`t$($projectToRemove.GetMetaFilePath())`r`n"                             + `
                            [ProjectManagerCommon]::OutputMetaProjectInformation($projectToRemove)      );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                    # Initial message
                                        $logAdditionalMSG, `                # Additional information
                                        [LogMessageLevel]::Warning);        # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                        # Message to display
                                        [LogMessageLevel]::Warning);        # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation.
            return;
        } # if : User Canceled Operation


        # Delete the project as requested
        if(![CommonIO]::DeleteDirectory($projectToRemove.GetMetaFilePath()))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to successfully uninstall $($projectToRemove.GetProjectName())!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ( `
                            "Project Target Path:`r`n"                                                  + `
                            "`t`t$($projectToRemove.GetMetaFilePath())`r`n"                             + `
                            [ProjectManagerCommon]::OutputMetaProjectInformation($projectToRemove)      );


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                    # Initial message
                                        $logAdditionalMSG, `                # Additional information
                                        [LogMessageLevel]::Error);          # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                        # Message to display
                                        [LogMessageLevel]::Error);          # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Operation had failed.
            return;
        } # If : Failure to Delete Directory


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # If we made it this far, then the operation was successful!
        [Logging]::DisplayMessage(  "Successfully uninstalled $($projectToRemove.GetProjectName())!`r`n"    + `
                                    "`tProject Name:`r`n"                                                   + `
                                    "`t`t$($projectToRemove.GetProjectName())`r`n"                          + `
                                    "`tProject Code Name:`r`n"                                              + `
                                    "`t`t$($projectToRemove.GetProjectCodeName())`r`n"                      + `
                                    "`tProject Revision ID:`r`n"                                            + `
                                    "`t`t$($projectToRemove.GetProjectRevision())"                          );


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n");


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("$($projectToRemove.GetProjectName()) had been uninstalled successfully!");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ( `
                        "Project Target Path:`r`n"                                              + `
                        "`t`t$($projectToRemove.GetMetaFilePath())`r`n"                         + `
                        [ProjectManagerCommon]::OutputMetaProjectInformation($projectToRemove)  );


        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # Display a message to the user that something went horribly wrong
        #  and log that same message for referencing purpose.
        [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                    [LogMessageLevel]::Verbose);    # Message level

        # Alert the user through a message box as well that an event had occurred;
        #   the message will be brief as the full details remain within the terminal.
        [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Information) | Out-Null;

        # * * * * * * * * * * * * * * * * * * *
    } # __UninstallProject()




   <# Project Manager Uninstaller - Confirm to Uninstall
    # -------------------------------
    # Documentation:
    #  Prompt the user with a confirmation, in which the user will need to explicitly state that they want
    #   to delete the requested PowerShell Compact-Archive Tool Project from the environment.
    # -------------------------------
    # [ProjectMetaData] Project to Remove
    #   The PowerShell Compact-Archive Tool Project that will be removed from the program's environment.
    # -------------------------------
    # Output:
    #  [bool] Confirmation Result
    #   $true  = User wishes to continue with the uninstallation.
    #   $false = User wants to cancel the uninstallation.
    # -------------------------------
    #>
    hidden static [bool] __UninstallProjectConfirm([ProjectMetaData] $projectToRemove)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will be used as a confirmation string
        [string] $confirmString = $NULL;
        # ----------------------------------------


        # Build the confirmation string
        $confirmString = (  "Are you sure you want to delete this project?`r`n"             + `
                            "---------------------------------------------`r`n"             + `
                            "Name:      $($projectToRemove.GetProjectName())`r`n"           + `
                            "Codenamed: $($projectToRemove.GetProjectCodeName())`r`n"       + `
                            "Revision:  $($projectToRemove.GetProjectRevision())"           );


        # Confirm that the user wants to remove the project
        return ([CommonGUI]::MessageBox($confirmString,                                 `
                                        [System.Windows.MessageBoxImage]::Question,     `
                                        [System.Windows.MessageBoxButton]::OKCancel,    `
                                        [System.Windows.MessageBoxResult]::Cancel)      `
                                            -eq                                         `
                                        [System.Windows.MessageBoxResult]::OK)          ;
    } # __UninstallProjectConfirm()
} # ProjectManagerUninstall