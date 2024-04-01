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




<# Settings - Project User Configuration
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user with the ability to configure the currently
 #  loaded PSCAT Project's User Configuration preferences.
 #>




class SettingsProjectUserConfiguration
{
   <# Settings Project User Configuration Menu Driver
    # -------------------------------
    # Documentation:
    #  This function will give the user the ability to configure the current loaded PSCAT Project
    #   User Configuration preferences.
    # -------------------------------
    #>
    static [void] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the
        #  main settings menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave the menu.
        [bool] $menuLoop = $true;

        # Grab the current instance of the Project Info.
        [ProjectInformation] $projectInfo = [ProjectInformation]::GetInstance();
        # ----------------------------------------


        # Open the PSCAT Project User Configuration Settings
        #  Keep the user at the PSCAT Project User Configuration Settings Menu until they request to
        #   return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easier
            #   for the user to read and follow along
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the PSCAT Project User Configuration Settings
            [CommonCUI]::DrawSectionHeader("$($GLOBAL:_PROGRAMNAMESHORT_) Project User Configuration Settings for $($projectInfo.GetProjectName())");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the PSCAT Project User Configuration Settings menu list to the user.
            [SettingsProjectUserConfiguration]::__DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsProjectUserConfiguration]::__EvaluateExecuteUserRequest($userInput);
        } while($menuLoop);
    } # Main()




   <# Draw Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list to the user.
    #   Thus, this function provides to the user as to what settings
    #   are available to configure.
    # -------------------------------
    #>
    hidden static [void] __DrawMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Grab the current instance of the Project Info.
        [ProjectInformation] $projectInfo = [ProjectInformation]::GetInstance();
        # ----------------------------------------



        # Locate the local project assets
        [CommonCUI]::DrawMenuItem('P', `
                                "Locate the $($projectInfo.GetProjectName()) local working copy.", `
                                "Browse for the $($projectInfo.GetProjectName())'s local source and assets directory.", `
                                "Path: $($projectInfo.GetProjectPath())", `
                                $true);


        # Help Documentation
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to previous Menu", `
                                $NULL, `
                                $NULL, `
                                $true);


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # __DrawMenu()




   <# Evaluate and Execute User's Request
    # -------------------------------
    # Documentation:
    #  This function will evaluate and execute the user's desired request in respect to
    #   the Menu options provided.
    # -------------------------------
    # Input:
    #  [string] User's Request
    #   This will provide the user's desired request to run an operation or to access
    #    a specific functionality.
    # -------------------------------
    # Output:
    #  [bool] User Stays at Menu
    #   This defines if the user is to remain at the Menu screen.
    #   $true  = User is to remain at the Menu.
    #   $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] __EvaluateExecuteUserRequest([string] $userRequest)
    {
        switch ($userRequest)
        {
            # Local Working Copy Assets Path
            {(($_ -eq "P") -or `
              ($_ -eq "Path") -or `
              ($_ -eq "Update Path"))
            }
            {
                # The user had selected to browse for the local working copy of the project's source\assets.
                # <<<<<<<<<<<<<<<  DEAD END  >>>>>>>>>>>>>>>>>>>


                # Finished
                break;
            } # Selected Project Source\Assets Path



            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme',
            #           'Help me', as well as '?'.
            {($_ -eq "?") -or `
                ($_ -eq "help") -or `
                ($_ -eq "helpme") -or `
                ($_ -eq "help me")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,               ` # Program's Wiki
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Wiki"))      ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Exit
            #  NOTE: Allow the user's request when they type: 'Exit', 'Cancel', 'Return',
            #         'Settings Menu', as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Cancel") -or `
                ($_ -eq "Return") -or `
                ($_ -eq "Settings Menu")}
            {
                # Return back to the Setting's Main Menu
                return $false;
            } # Exit



            # Unknown Option
            default
            {
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # switch : Execute User Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequest()
} # SettingsProjectUserConfiguration