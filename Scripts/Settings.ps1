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




<# Settings
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user to easily access their desired
 #  settings in which they wish to configure.  To avoid
 #  over-bloating this class, each main object setting will have
 #  their own Settings Class.  Thus, allowing each object to
 #  handle its intended operation - done well.  This class,
 #  will act as a gateway into accessing other settings, if
 #  and only if the object is available to the user in the current
 #  instance of the program.
 #>





class Settings
{
   <# Main Settings Menu Driver
    # -------------------------------
    # Documentation:
    #  This function allows the ability for the user to select which object
    #   to modify.  The objects provided are part of the Singleton methodology
    #   and can be easily manipulated, if the getters\setters are properly
    #   provided for the desired member variables.
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


        # Open the Main Settings Menu
        #  Keep the user at the Main Settings Menu until they request to return
        #  back to the Main Menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so
            #  that it is easy for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Main Settings Menu
            [CommonCUI]::DrawSectionHeader("User Preference Main Menu");

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Main Menu list to the user
            [Settings]::__DrawMainSettingsMenu();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings]::__EvaluateExecuteUserRequest($userInput);
        } while ($menuLoop);
    } # Main()




   <# Draw Main Settings Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the Main Settings Menu list to the
    #   user.  Thus this function provides to the user as to what classes are
    #   available to configure.
    # -------------------------------
    #>
    hidden static [void] __DrawMainSettingsMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold a message that will be displayed to the user, in which
        #   it indicates the current value of the Show Hidden Menus and Options
        #   variable.
        # NOTE: Use a space character as default, so the spacing is consistent
        #        in the menu.
        [string] $currentValueShowHiddenMenus = " ";

        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenu7Zip = $true;   # 7Zip Menu
        [bool] $showMenuZip = $true;    # Zip Menu
        [bool] $showMenuGit = $true;    # Git Menu

        # Retrieve the User Preference object.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Determine what menus are to be displayed to the user.
        [Settings]::__DrawMenuDetermineHiddenMenus([ref] $showMenu7Zip, `   # 7Zip Menu
                                                    [ref] $showMenuZip, `   # Zip Menu
                                                    [ref] $showMenuGit);    # Git Menu



        # Determine the current value of the "Show Hidden Menus and Options" and
        #  prepare a nice message to the user indicating the current value.
        # Display hidden menus and options
        if ($userPreferences.GetShowHiddenMenu())
        {
            # We are displaying hidden menus to the user.
            $currentValueShowHiddenMenus = "Showing all hidden menus";
        } # if: Display Hidden Menus




        # Display the Main Settings Menu list

        # Generate Project and View Project Information
        [CommonCUI]::DrawMenuItem('P', `
                                "General $($GLOBAL:_PROGRAMNAME_) Preferences", `
                                "Configure the $($GLOBAL:_PROGRAMNAMESHORT_) generalized functionality and preferences.", `
                                $NULL, `
                                $true);


        # Only show this option if it is available to the user
        if ($showMenuZip)
        {
            # Option is available, so display it on the settings main menu.
            #  Configure the dotNET Zip Archive settings
            [CommonCUI]::DrawMenuItem('Z', `
                                    "Zip Preferences [PK3 Builds Only]", `
                                    "Configure the Internal Zip's functionality and preferences.", `
                                    $NULL, `
                                    $true);
        } # if: Display .NET Core ZIP Option


        # Only show this option if it is available to the user
        if ($showMenu7Zip)
        {
            # Option is available, so display it on the settings main menu.
            #  Configure the 7Zip Application settings
            [CommonCUI]::DrawMenuItem('7', `
                                    "7Zip Preferences [PK3 or PK7 Builds]", `
                                    "Configure the 7Zip's functionality and preferences.", `
                                    $NULL, `
                                    $true);
        } # if: Display 7Zip Option


        # Only show this option if it available to the user
        if ($showMenuGit)
        {
            # Option is available, so display it on the settings main menu.
            #  Configure the Git Application settings
            [CommonCUI]::DrawMenuItem('G', `
                                    "Git Preferences", `
                                    "Configure the Git's functionality and preferences.", `
                                    $NULL, `
                                    $true);
        } # if: Display Git Option


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


        # Show or Hide Hidden Menus and Options
        [CommonCUI]::DrawMenuItem('~', `
                                "Toggle Hidden Menus", `
                                $currentValueShowHiddenMenus, `
                                $NULL, `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to Main Menu", `
                                $NULL, `
                                $NULL, `
                                $false);
    } # __DrawMainSettingsMenu()




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
        [bool] $showMenu7Zip = $true;   # 7Zip Menu
        [bool] $showMenuZip = $true;    # Zip Menu
        [bool] $showMenuGit = $true;    # Git Menu

        # Retrieve the User Preference object.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Determine what menus are to be displayed to the user.
        [Settings]::__DrawMenuDetermineHiddenMenus([ref] $showMenu7Zip, `   # 7Zip Menu
                                                    [ref] $showMenuZip, `   # Zip Menu
                                                    [ref] $showMenuGit);    # Git Menu



        switch ($userRequest)
        {
            # Configure General Program Preferences
            #  NOTE: Allow the user's request when they type: 'Configure General $project
            #           Preferences', 'Configure General', 'Configure Program', as well
            #           as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Configure General $([ProjectInformation]::projectName) Preferences") -or `
                ($_ -eq "Configure General") -or `
                ($_ -eq "Configure Program")}
            {
                # Open the General Program preferences menu
                [SettingsGeneralProgram]::Main();


                # Finished
                break;
            } # Configure General Program Preferences



            # Configure Zip Preferences
            #  NOTE: Allow the user's request when they type: 'Configure Zip Preferences',
            #           'Configure Zip', 'Zip', as well as 'Z'.
            #       Further, only allow the option if and only if the feature is available
            #           within the current session of the program's instance.
            {($showMenuZip) -and `
                (($_ -eq "Z") -or `
                ($_ -eq "Configure Zip Preferences") -or `
                ($_ -eq "Configure Zip") -or `
                ($_ -eq "Zip"))}
            {
                # Open the Zip preferences menu
                [SettingsZip]::Main();


                # Finished
                break;
            } # Configure Zip Preferences



            # Configure 7Zip Preferences
            #  NOTE: Allow the user's request when they type: 'Configure 7Zip Preferences',
            #           'Configure 7Zip', '7Zip', '7Z', as well as '7'.
            #       Further, only allow the option if and only if the feature is available
            #           within the current session of the program's instance.
            {($showMenu7Zip) -and `
                (($_ -eq "7") -or `
                ($_ -eq "Configure 7Zip Preferences") -or `
                ($_ -eq "Configure 7Zip") -or `
                ($_ -eq "7Zip") -or `
                ($_ -eq "7Z"))}
            {
                # Open the 7Zip preferences menu
                [Settings7Zip]::Main();


                # Finished
                break;
            } # Configure 7Zip Preferences



            # Configure Git Preferences
            #  NOTE: Allow the user's request when they type: 'Configure Git Preferences',
            #           'Configure Git', 'Git', as well as 'G'.
            #       Further, only allow the option if and only if the feature is available
            #           within the current session of the program's instance.
            {($showMenuGit) -and `
                (($_ -eq "G") -or `
                ($_ -eq "Configure Git Preferences") -or `
                ($_ -eq "Configure Git") -or `
                ($_ -eq "Git"))}
            {
                # Open the Git preferences menu
                [SettingsGit]::Main();


                # Finished
                break;
            } # Configure Git Preferences



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
                    [Notifications]::Notify([NotificationEventType]::Error);
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
                    [Notifications]::Notify([NotificationEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Toggle the Show Hidden Menus and Options
            #  NOTE: Allow the user's request when they type: "Toggle hidden menus" and "~"
            {($_ -eq "~") -or `
                ($_ -eq "Toggle hidden menus")}
            {
                # Toggle the Show Hidden Menus and Options
                $userPreferences.SetShowHiddenMenu(-not($userPreferences.GetShowHiddenMenu()));
            } # Toggle Show Hidden Menus



            # Exit
            #  NOTE: Allow the user's request when they type: 'Exit', 'Cancel', 'Return',
            #         'Main Menu', as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Cancel") -or `
                ($_ -eq "Return") -or `
                ($_ -eq "Main Menu")}
            {
                # Return back to the Program's Main Menu
                return $false;
            } # Exit



            # Unknown Option
            default
            {
                # Alert the user that they had provided an incorrect option.
                [Notifications]::Notify([NotificationEventType]::IncorrectOption);


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




   <# Draw Menu: Determine Hidden Menus
    # -------------------------------
    # Documentation:
    #  This function will determine what menus and options are to be displayed
    #   to the user.  Menus can be considered hidden if a particular setting,
    #   feature, or environment is not available to the user or is not considered
    #   ready to be used.  This can happen if a parent feature had been disabled,
    #   thus causes a sub-feature to be hidden from the user.
    #  This helps to declutter the menu screen by hiding sub-menus from the user
    #   in-which have no effect as the main feature is disabled or configured in
    #   a way that has no real effect.
    # -------------------------------
    # Input:
    #  [bool] (REFERENCE) 7Zip Menu
    #   Provides the 7Zip Menu
    #  [bool] (REFERENCE) Zip Menu
    #   Provides the Zip Menu
    #  [bool] (REFERENCE) Git Menu
    #   Provides the Git Menu
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenu7Zip, `      # 7Zip Menu
                                                        [ref] $showMenuZip, `       # Zip Menu
                                                        [ref] $showMenuGit)         # Git Menu
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the User Preferences object
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Show 7Zip Menu
        #  Show the 7Zip Menu if the following conditions are true:
        #   - Found 7Zip
        #   - Compression Tool is 7Zip
        #   OR
        #   - Show Hidden Menus
        if (([CommonFunctions]::IsAvailable7Zip() -and `
            ($userPreferences.GetCompressionTool() -eq [UserPreferencesCompressTool]::SevenZip)) -or `
            $userPreferences.GetShowHiddenMenu())
        {
            $showMenu7Zip.Value = $true;
        } # If: 7Zip Menu is Visible

        # 7Zip Menu is Hidden
        else
        {
            $showMenu7Zip.Value = $false;
        } # Else: 7Zip Menu is Hidden




        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -




        # Show Zip Menu
        #  Show the Zip Menu if the following conditions are true:
        #   - Found Zip Module
        #   - Compression Tool is Zip
        #   OR
        #   - Show Hidden Menus
        if (([CommonFunctions]::IsAvailableZip() -and `
            ($userPreferences.GetCompressionTool() -eq [UserPreferencesCompressTool]::InternalZip)) -or `
            $userPreferences.GetShowHiddenMenu())
        {
            $showMenuZip.Value = $true;
        } # If: Zip Menu is Visible

        # Zip Menu is Hidden
        else
        {
            $showMenuZip.Value = $false;
        } # Else: Zip Menu is Hidden




        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -




        # Show Git Menu
        #  Show the Git Menu if the following conditions are true:
        #   - Found Git
        #   - Use Git Features
        #   OR
        #   - Show Hidden Menus
        if (([CommonFunctions]::IsAvailableGit() -and $userPreferences.GetUseGitFeatures()) -or `
            $userPreferences.GetShowHiddenMenu())
        {
            $showMenuGit.Value = $true;
        } # If: Git Menu is Visible

        # Git Menu is Hidden
        else
        {
            $showMenuGit.Value = $false;
        } # Else: Git Menu is Hidden
    } # __DrawMenuDetermineHiddenMenus()
} # Settings