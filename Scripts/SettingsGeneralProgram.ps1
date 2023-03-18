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




<# Settings - General Program Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the ability for the user to configure
 #  how the program will interact with the user as well how the
 #  program will perform specific functionalities with the
 #  supporting technologies.
 #>




class SettingsGeneralProgram
{
   <# General Program Settings Menu Driver
    # -------------------------------
    # Documentation:
    #  This function will allow the ability for the user to select which
    #   feature or behavior will be configured by the end-user.
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
        # ----------------------------------------


        # Open the General Program settings
        #  Keep the user at the General Program Settings Menu until they request to return
        #  back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the General Program Settings.
            [CommonCUI]::DrawSectionHeader("General Program Preferences");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the General Program settings menu list to the user
            [SettingsGeneralProgram]::__DrawMenu();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::__EvaluateExecuteUserRequest($userInput);
        } while($menuLoop);
    } # Main()




   <# Draw Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list to the user.
    #   Thus this function provides to the user as to what classes
    #   are available to configure.
    # -------------------------------
    #>
    hidden static [void] __DrawMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the user's preferences
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();


        # Here are some variables that are used to help the user to understand the
        #  meaning behind a particular setting.  Thus, instead of saying "True" or
        #  an enumerator value that is not easy to decipher, we can break it down in
        #  a way that it is easier to convey the point across to the user.
        [string] $currentSettingCompressionTool = $NULL;    # Compression Tool
        [string] $currentSettingGitFeatures = $NULL;        # Git Features
        [string] $currentSettingNotification = $NULL;       # Notifications

        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuCompressionTool = $true;            # Compression Tool
        [bool] $showMenuGitFeatures = $true;                # Git Features
        # ----------------------------------------



        # Display the menu list

        # Paths
        # - - - - - - -
        # Find Project Path
        [CommonCUI]::DrawMenuItem('P', `
                                "Locate Project Path", `
                                "The directory that contains the $([ProjectInformation]::projectName) ($([ProjectInformation]::codeName)) project files", `
                                "Project is located at: $($userPreferences.GetProjectPath())", `
                                $true);

        # Specify Output Path
        [CommonCUI]::DrawMenuItem('O', `
                                "Compiled Builds Output Path", `
                                "The directory that will contain all of the compiled builds generated by the $($GLOBAL:_PROGRAMNAME_).", `
                                "Compiled Builds are located at: $($userPreferences.GetProjectBuildsPath())", `
                                $true);



        # Help Documentation
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online", `
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
                                "Go back to previous menu", `
                                $NULL, `
                                $NULL, `
                                $false);
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
        # Declarations and Initializations
        # ----------------------------------------
        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuCompressionTool = $true;            # Compression Tool
        [bool] $showMenuGitFeatures = $true;                # Git Features
        [bool] $showMenuWindowsFeatures = $true;            # Windows Features
        # ----------------------------------------



        # Evaluate the user's request
        switch ($userRequest)
        {
            # Locate the Project Path
            #  NOTE: Allow the user's request when they type: 'Locate Project'
            #           'Locate Project Path', as well as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Locate Project Path") -or `
                ($_ -eq "Locate Project")}
            {
                # Allow the user to update or verify the project path.
                [SettingsGeneralProgram]::__LocateProjectPath();


                # Finished
                break;
            } # Locate the Project Path



            # Compiled Builds Output Path
            #  NOTE: Allow the user's request when they type: 'Compiled Builds Output Path',
            #           'Builds Output Path', 'Output Path', 'Compiled Output Path', as well as 'O'.
            {($_ -eq "O") -or `
                ($_ -eq "Compiled Builds Output Path") -or `
                ($_ -eq "Builds Output Path") -or `
                ($_ -eq "Output Path") -or `
                ($_ -eq "Compiled Output Path")}
            {
                # Allow the user to specify where the output\compiled builds are to be placed after
                #  being generated.
                [SettingsGeneralProgram]::__CompiledBuildsOutputPath();


                # Finished
                break;
            } # Compiled Builds Output Path



            # Graphical User Interface Features
            #  NOTE: Allow the user's request when they type: 'Graphical User Interface Features',
            #           'GUI Features', as well as 'E'.
            {($showMenuWindowsFeatures) -and `
                (($_ -eq "E") -or `
                 ($_ -eq "Graphical User Interface Features") -or `
                 ($_ -eq "GUI Features"))}
            {
                # Allow the user to configure the state of the Use Windows Explorer variable, thus giving
                #  the user the ability to benefit - if chosen so - of using Windows Explorer functionality.
                [SettingsGeneralProgram]::__UseWindowsExplorer();


                # Finished
                break;
            } # Graphical User Interface Features



            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme',
            #           'Help me', as well as '?'.
            {($_ -eq "?") -or `
                ($_ -eq "help") -or `
                ($_ -eq "helpme") -or `
                ($_ -eq "help me")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,                   ` # Program's Wiki
                                                            "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                            $false))                                        ` # Do not force Web Browser functionality.
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
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
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
        } # Switch: Option Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequest()





    #region Locate Project Path
    #                                    Locate Project Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the Project Path, so that this program
    #   can perform compact the project as expected.
    # -------------------------------
    #>
    hidden static [void] __LocateProjectPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Open the Locate Project Path Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Locate Project Path
            [CommonCUI]::DrawSectionHeader("Locate Project Path");


            # Provide the current project path
            #  Determine how to present to the user that the path is valid or not.
            if ([CommonIO]::CheckPathExists($userPreferences.GetProjectPath(), $true))
            {
                # The path was found, so provide a nice message to the user - letting them know
                #  that the program can find the project files.
                [Logging]::DisplayMessage("I can find the $($GLOBAL:projectName) Project files within the following path:");
            } # if: Project Path was Found

            # Display that the path is not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know
                #  that the program cannot find the project files.
                [Logging]::DisplayMessage("I cannot find the $($GLOBAL:projectName) Project files within the following path:");
            } # else: Project Path was Not Found


            # Output the project's path
            [Logging]::DisplayMessage("`t$($userPreferences.GetProjectPath())");

            # Provide some extra whitespacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::__DrawMenuLocateProjectPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::__EvaluateExecuteUserRequestLocateProjectPath($userInput);
        } while ($menuLoop);
    } # __LocateProjectPath()




   <# Draw Menu: Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate Project Path to the user.
    #   Thus this provides what options are available to the user in order to configure the
    #   project path.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuLocateProjectPath()
    {
        # Display the Menu List

        # Change the Project Path
        [CommonCUI]::DrawMenuItem('C', `
                                "Change Path", `
                                "Locate the directory that contains that $([ProjectInformation]::projectName) source files." , `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $false);
    } # __DrawMenuLocateProjectPath()




   <# Evaluate and Execute User's Request: Locate Project Path
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
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] __EvaluateExecuteUserRequestLocateProjectPath([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the Project Path
            #  NOTE: Allow the user's request when they type: 'Change Path', 'Change',
            #           'Update Path', 'Update', as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change Path") -or `
                ($_ -eq "Change") -or `
                ($_ -eq "Update Path") -or `
                ($_ -eq "Update")}
            {
                # Configure the path of the project source directory.
                [SettingsGeneralProgram]::__LocateProjectPathNewPath();


                # Finished
                break;
            } # Change Path



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Exit
            #  NOTE: Allow the user's request when they type: 'Exit', 'Cancel', 'Return',
            #         as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Cancel") -or `
                ($_ -eq "Return")}
            {
                # Return back to the previous menu
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
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestLocateProjectPath()




   <# Configure Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the Project source directory.
    # -------------------------------
    #>
    hidden static [void] __LocateProjectPathNewPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Project Path variable.
        [string] $newProjectPath = $NULL;

        # We will use this instance so that we can apply the new location to the project.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine if the path that were provided is valid and can be used by the program.
        if ([UserExperience]::BrowseForFolder("Locate the Project Folder",              ` # Instructions
                                            [BrowserInterfaceStyle]::Modern,            ` # GUI Style
                                            [ref] $newProjectPath))                     ` # Selected Directory
        {
            # Because the path is valid, we will use the requested target directory.
            $userPreferences.SetProjectPath($newProjectPath);
        } # if: Path is valid

        # The provided path is not valid
        else
        {
            # Alert the user that the path is incorrect.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Because the path is not valid, let the user know that the path does not exist
            #  and will not be used as part of the project directory.
            [Logging]::DisplayMessage("`r`n" + `
                                    "The provided path does not exist and cannot be used as the Project Directory." + `
                                    "`r`n`r`n");


            # Wait for the user to provide feedback; thus allowing the user to see the message.
            [Logging]::GetUserEnterKey();
        } # else : Path is invalid
    } # __LocateProjectPathNewPath()
    #endregion





    #region Compiled Builds Output Path
    #                                Compiled Builds Output Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will allow the ability for the user to customize the Output Path, in which will
    #   hold all compiled builds generated by this program.
    # -------------------------------
    #>
    hidden static [void] __CompiledBuildsOutputPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $NULL;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Open the Compiled Build Output Path Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user tha3t they are at the Compiled Builds Output Path
            [CommonCUI]::DrawSectionHeader("Compiled Builds Output Path");


            # Provide the current output path
            #  Determine how to present to the user that the path is valid or not.
            if ([CommonIO]::CheckPathExists($userPreferences.GetProjectBuildsPath(), $true))
            {
                # The path waws found, so provide a nice message to the user - letting them know
                #  that the program can find the output path.
                [Logging]::DisplayMessage("I can find the Compiled Builds Output Path directory:");
            } # if: Found the Compiled Builds Output Directory

            # Display that the4 path was not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know
                #  That the program cannot find the compiled builds output directory.
                [Logging]::DisplayMessage("I cannot find the Compiled Builds Output Path directory:");
            } # else: Compiled Builds Output Path was Not Found


            # Display the Compiled Build Output Path
            [Logging]::DisplayMessage("`t$($userPreferences.GetProjectBuildsPath())");

            # Provide some extra whitespacing so that it is easier to read for the user.
            [Logging]::DisplayMessage("`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::__DrawMenuCompiledBuildsOutputPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::__EvaluateExecuteUserRequestCompiledBuildsOutputPath($userInput);
        } while ($menuLoop);
    } # CompiledBuildsOutputPath()




   <# Draw Menu: Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compiled Builds Output Path to the user.
    #   Thus this provides what options are available to the user in order to configure the
    #   Output path.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuCompiledBuildsOutputPath()
    {
        # Display the Menu List

        # Change the Compiled Builds Output Path
        [CommonCUI]::DrawMenuItem('C', `
                                "Change Path", `
                                "Specify a new directory that will contain newly compiled builds generated by the $($GLOBAL:_PROGRAMNAMESHORT_) program.", `
                                $NULL, `
                                $true);

        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);

        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $false);
    } # __DrawMenuCompiledBuildsOutputPath()




   <# Evaluate and Execute User's Request: Compiled Builds Output Path
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
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] __EvaluateExecuteUserRequestCompiledBuildsOutputPath([string] $userInput)
    {
        # Evaluate the user's request
        switch ($userInput)
        {
            # Change the Compiled Builds Output Path
            #  NOTE: Allow the user's request when they type: 'Change Path', 'Change',
            #           'Update Path', 'Update', as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change Path") -or `
                ($_ -eq "Change") -or `
                ($_ -eq "Update Path") -or `
                ($_ -eq "Update")}
            {
                # Configure the path of the project source directory.
                [SettingsGeneralProgram]::__CompiledBuildsOutputPathNewPath();


                # Finished
                break;
            } # Change Path



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Exit
            #  NOTE: Allow the user's request when they type: 'Exit', 'Cancel', 'Return',
            #         as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Cancel") -or `
                ($_ -eq "Return")}
            {
                # Return back to the previous menu
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
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestCompiledBuildsOutputPath()




   <# Configure Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the Compiled Builds Output directory.
    # -------------------------------
    #>
    hidden static [void] __CompiledBuildsOutputPathNewPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Compiled Builds Output Path variable.
        [string] $newOutputPath = $NULL;

        # We will use this instance so that we can apply the new location to the Compiled
        #  Builds Output Path.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");



        # Determine if the path that were provided is valid and can be used by the program.
        if ([UserExperience]::BrowseForFolder("Store Compiled Builds to this directory",    ` # Instructions
                                            [BrowserInterfaceStyle]::Modern,                ` # GUI Style
                                            [ref] $newOutputPath))                          ` # Selected Directory
        {
            # Because the path is valid, we will use the requested target directory.
            $userPreferences.SetProjectBuildsPath($newOutputPath);
        } # if: Path is valid

        # The provided path is not valid
        else
        {
            # Alert the user that the path is incorrect.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Because the path is not valid, let the user know that the path does not exist
            #  and will not be used as part of the Compiled Builds Output directory.
            [Logging]::DisplayMessage("`r`n" + `
                                    "The provided path does not exist and cannot be used as the Compiled Builds Output Directory." + `
                                    "`r`n`r`n");


            # Wait for the user to provide feedback; thus allowing the user to see the message.
            [Logging]::GetUserEnterKey();
        } # else : Path is invalid
    } # __CompiledBuildsOutputPathNewPath()
    #endregion
} # SettingsGeneralProgram