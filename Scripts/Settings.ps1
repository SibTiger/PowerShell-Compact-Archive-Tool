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
        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuZip = $true;    # Zip Menu
        # ----------------------------------------




        # Determine what menus are to be displayed to the user.
        [Settings]::__DrawMenuDetermineHiddenMenus([ref] $showMenuZip);



        # Display the Main Settings Menu list

        # Determine if the dotNET Zip Archive functionality is available to the user in this current session.
        if ($showMenuZip)
        {
            # Configure the dotNET Zip Archive settings
            [CommonCUI]::DrawMenuItem('Z', `
                                    "Zip Preferences [PK3 Builds Only]", `
                                    "Configure the Internal Zip's functionality and preferences.", `
                                    $NULL, `
                                    $true);
        } # if : Show dotNET Zip Settings Menu


        # Configure the 7Zip Application settings
        [CommonCUI]::DrawMenuItem('7', `
                                "7Zip Preferences [PK3 or PK7 Builds]", `
                                "Configure the 7Zip's functionality and preferences.", `
                                $NULL, `
                                $true);


        # Configure the Git Application settings
        [CommonCUI]::DrawMenuItem('G', `
                                "Git Preferences", `
                                "Configure the Git's functionality and preferences.", `
                                $NULL, `
                                $true);


        # Update Application
        [CommonCUI]::DrawMenuItem('U', `
                                "Update $($Global:_PROGRAMNAME_)", `
                                "Check for new available versions of $($GLOBAL:_PROGRAMNAMESHORT_).", `
                                $NULL, `
                                $true);


        # About Application
        [CommonCUI]::DrawMenuItem('A', `
                                "About $($GLOBAL:_PROGRAMNAME_)", `
                                "Access the $($Global:_PROGRAMNAME_) About information", `
                                $NULL, `
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
        [bool] $showMenuZip = $true;    # Zip Menu
        # ----------------------------------------




        # Determine what menus are to be displayed to the user.
        [Settings]::__DrawMenuDetermineHiddenMenus([ref] $showMenuZip);



        switch ($userRequest)
        {
            # Configure Zip Preferences
            #  NOTE: Allow the user's request when they type: 'Configure Zip Preferences',
            #           'Configure Zip', 'Zip', as well as 'Z'.
            {   ($showMenuZip) -and `
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
            {   ($_ -eq "7") -or `
                ($_ -eq "Configure 7Zip Preferences") -or `
                ($_ -eq "Configure 7Zip") -or `
                ($_ -eq "7Zip") -or `
                ($_ -eq "7Z")}
            {
                # Open the 7Zip preferences menu
                [Settings7Zip]::Main();


                # Finished
                break;
            } # Configure 7Zip Preferences



            # Configure Git Preferences
            #  NOTE: Allow the user's request when they type: 'Configure Git Preferences',
            #           'Configure Git', 'Git', as well as 'G'.
            {   ($_ -eq "G") -or `
                ($_ -eq "Configure Git Preferences") -or `
                ($_ -eq "Configure Git") -or `
                ($_ -eq "Git")}
            {
                # Open the Git preferences menu
                [SettingsGit]::Main();


                # Finished
                break;
            } # Configure Git Preferences



            # Update Software
            #  NOTE: Allow the user's request when they type: 'Update' or 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "update")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_Update($Global:_PROGRAMSITEDOWNLOADS_,       ` # Program's Download Page
                                                            "Update $($Global:_PROGRAMNAME_)"))     ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Update Software



            # About the Software
            # NOTE: Allow the user's request when they type: 'About' or 'A'.
            {($_ -eq "A") -or `
                ($_ -eq "About")}
            {
                # Open the About page
                [CommonCUI]::DrawProgramAboutInformation();


                # Add some padding in the terminal
                [Logging]::DisplayMessage("`r`n`r`n");


                # Allow the user to read the results before returning back
                #   to the menu.
                [Logging]::GetUserEnterKey();


                # Finished
                break;
            } # About the Software



            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme',
            #           'Help me', as well as '?'.
            {   ($_ -eq "?") -or `
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
            {   ($_ -eq "#") -or `
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
            #         'Main Menu', as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {   ($_ -eq "X") -or `
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
    #  [bool] (REFERENCE) Zip Menu
    #   Provides the Zip Menu
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenuZip)
    {
        # Show Zip Menu
        #  Show the Zip Menu if the following conditions are true:
        #   - Found Zip Module
        if ([CommonFunctions]::IsAvailableZip())
        {
            $showMenuZip.Value = $true;
        } # If: Zip Menu is Visible

        # Zip Menu is Hidden
        else
        {
            $showMenuZip.Value = $false;
        } # Else: Zip Menu is Hidden
    } # __DrawMenuDetermineHiddenMenus()
} # Settings