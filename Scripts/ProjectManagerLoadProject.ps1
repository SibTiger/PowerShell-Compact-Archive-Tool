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




<# Project Manager - Load Project
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user with the ability to load an already installed project into the PowerShell
 #  Compact-Archive Tool's environment, in which the user will be able to compile their desired game mods
 #  at any time on-demand.
 #>




class ProjectManagerLoadProject
{
   <# Project Manager Load Project - Main Entry
    # -------------------------------
    # Documentation:
    #  This function will guide the user through the process of safely loading their desired PowerShell
    #   Compact-Archive Tool Project's into the program's current session environment on-demand.
    # -------------------------------
    #>
    static [void] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Project Information object
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();

        # Project Information String; if and only if a PSCAT Project is loaded.
        [string] $projectInformationStr = $NULL;

        # This variable will contain a list of projects that had been installed within the environment.
        [System.Collections.ArrayList] $listOfProjectsInstalled = [System.Collections.ArrayList]::New();

        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $NULL;

        # This variable will determine if the user is to remain within the current menu loop.  If the
        #   user were to exit from the menu, this variable's state will be set as false.
        [bool] $menuLoop = $true;
        # ----------------------------------------



        # Present the Load Project Menu to the user
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
            [CommonCUI]::DrawSectionHeader("Load a $($GLOBAL:_PROGRAMNAMESHORT_) Project");


            # Provide some whitespace padding
            [Logging]::DisplayMessage("`r`n");


            # Show what project is presently loaded into the program's environment.
            if ($projectInformation.Show([ProjectInformationShowDetail]::Basic, [ref] $projectInformationStr))
            {
                [Logging]::DisplayMessage(  `
                            "Current $($GLOBAL:_PROGRAMNAMESHORT_) Project Loaded`r`n"  + `
                            "----------------------------------------------------`r`n"  + `
                            $projectInformationStr                                      + `
                            "----------------------------------------------------`r`n"  );
            } # if : Show Project Information

            # No project is loaded into the environment yet.
            else
            { [Logging]::DisplayMessage("No $($GLOBAL:_PROGRAMNAMESHORT_) Project Loaded`r`n"); }


            # Provide some whitespace padding
            [Logging]::DisplayMessage("`r`n");


            # Provide the instructions
            [ProjectManagerCommon]::__DrawMenuInstructionsForTable();


            # Provide some whitespace padding
            [Logging]::DisplayMessage("`r`n`r`n");


            # Show the list of projects to the user; we will also obtain the list of projects, the user
            #   will use this list to select what to load into the program's environment.
            if (![ProjectManagerLoadProject]::__ShowUserListOfInstalledProjects($listOfProjectsInstalled))
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------
                # Generate the initial message
                [string] $logMessage = ("Unable to load any $($GLOBAL:_PROGRAMNAMESHORT_) Projects!");

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


                # Abort the loading procedure.
                return;
            } # if : No Projects Available


            # Provide some whitespace padding.
            [Logging]::DisplayMessage("`r`n");


            # Show the user the extra menu items.
            [ProjectManagerLoadProject]::__ShowUserExtraMenuItems();


            # Provide some whitespace padding.
            [Logging]::DisplayMessage("`r`n`r`n");


            # Get the user's Feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);


            # Execute the user's request
            $menuLoop = [ProjectManagerLoadProject]::__EvaluateExecuteUserRequest($userInput,                 `
                                                                                $listOfProjectsInstalled);
        } while($menuLoop);
    } # Main()




   <# Project Manager Load Project - Show User List of Installed Projects
    # -------------------------------
    # Documentation:
    #  This function is designed to show the user what projects are presently installed within PSCAT's
    #   current environment.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] List of Projects that are Installed
    #   This is intended to be returned to the calling function such that the user can properly select the
    #   desired project to load.
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
            [string] $logMessage = ("Unable to find any installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!`r`n"  + `
                                    "You may need to install $($GLOBAL:_PROGRAMNAMESHORT_) Projects into"       + `
                                    "$($GLOBAL:_PROGRAMNAME_)!");

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




   <# Project Manager Load Project - Extra Menu Items
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




   <# Project Manager Load Project - Evaluate and Execute User's Request
    # -------------------------------
    # Documentation:
    #  This function will evaluate and execute the user's desired request in respect to the Project Manager's
    #   Load Project's menu options given.
    # -------------------------------
    # [string] User's Request
    #  User's request to load a specific PSCAT Project OR to run a specific operation that is available
    #   within the menu.
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


            # Load the desired project
            else
            {
                # Because the table shows each row as 'natural' numbers, we will need to convert the numbers
                #   to the whole numbers format.
                $userRequestNumber--;

                # Load the project as requested
                [ProjectManagerLoadProject]::__LoadProject($listOfProjectsInstalled[$userRequestNumber]);
            } # else : Load the Project
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


            # Provide an error message to the user that the option they chose is not available.
            [CommonCUI]::DrawIncorrectMenuOption();
        } # if : User Provided Incorrect Input


        # Finished
        return $stayInMenu;
    } # __EvaluateExecuteUserRequest()




   <# Project Manager Load Project - Load Project Driver
    # -------------------------------
    # Documentation:
    #  This function will try to load the desired project into PSCAT's environment as requested by the user.
    # -------------------------------
    # [ProjectMetaData] Project to Load
    #   The PowerShell Compact-Archive Tool Project that will be loaded into the program's environment.
    # -------------------------------
    #>
    hidden static [void] __LoadProject([ProjectMetaData] $projectToLoad)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Project Information object
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();
        # ----------------------------------------



        # Confirm with the user if they want to load the desired project.
        if (![ProjectManagerLoadProject]::__LoadProjectConfirm($projectToLoad))
        {
            # User had canceled the operation


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Loading the desired project had been canceled by the user.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  `
                            "Project Target Path:`r`n"                                              + `
                            "`t`t$($projectToLoad.GetMetaFilePath())`r`n"                           + `
                            [ProjectManagerCommon]::OutputMetaProjectInformation($projectToLoad)    );

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


        # Reset the Project Info.
        $projectInformation.Clear();


        # Load the desired project:
        # - Mandatory Fields
        $projectInformation.SetProjectName($projectToLoad.GetProjectName());
        $projectInformation.SetCompilerVersion($projectToLoad.GetProjectRevision());
        $projectInformation.SetFileName($projectToLoad.GetProjectOutputFileName());
        $projectInformation.SetProjectLoaded($true);

        # - Optional Fields
        $projectInformation.SetCodeName($projectToLoad.GetProjectCodeName());
        $projectInformation.SetURLWebsite($projectToLoad.GetProjectURLWebsite());
        $projectInformation.SetURLWiki($projectToLoad.GetProjectURLWiki());
        $projectInformation.SetURLSource($projectToLoad.GetProjectURLSourceCode());

        # - User Config
        $projectInformation.SetProjectPath("C:\");    # INCOMPLETE
    } # __LoadProject()




   <# Project Manager Load Project - Confirm to Load
    # -------------------------------
    # Documentation:
    #  Prompt the user with a confirmation, in which the user will need to explicitly state that they want
    #   to load the requested PowerShell Compact-Archive Tool Project into the program's environment.
    # -------------------------------
    # [ProjectMetaData] Project to Load
    #   The PowerShell Compact-Archive Tool Project that will be loaded into the program's environment.
    # -------------------------------
    # Output:
    #  [bool] Confirmation Result
    #   $true  = User wishes to continue with the loading procedure.
    #   $false = User wants to cancel the loading procedure.
    # -------------------------------
    #>
    hidden static [bool] __LoadProjectConfirm([ProjectMetaData] $projectToLoad)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will be used as a confirmation string
        [string] $confirmString = $NULL;
        # ----------------------------------------


        # Build the confirmation string
        $confirmString = (  "Are you sure you want to load this project?`r`n"               + `
                            "---------------------------------------------`r`n"             + `
                            "Name:      $($projectToLoad.GetProjectName())`r`n"             + `
                            "Codenamed: $($projectToLoad.GetProjectCodeName())`r`n"         + `
                            "Revision:  $($projectToLoad.GetProjectRevision())"             );


        # Confirm that the user wants to remove the project
        return ([CommonGUI]::MessageBox($confirmString,                                 `
                                        [System.Windows.MessageBoxImage]::Question,     `
                                        [System.Windows.MessageBoxButton]::OKCancel,    `
                                        [System.Windows.MessageBoxResult]::Cancel)      `
                                            -eq                                         `
                                        [System.Windows.MessageBoxResult]::OK)          ;
    } # __LoadProjectConfirm()
} # ProjectManagerLoadProject