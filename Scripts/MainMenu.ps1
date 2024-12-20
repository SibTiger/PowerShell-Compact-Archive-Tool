<# PowerShell Compact-Archive Tool
 # Copyright (C) 2025
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




<# Main Menu
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the ability for the user to interact with the application and to
 #  access the functionality that is available within the program.  Thus, the main menu
 #  provides a way for the user to perform any essential task possible within the
 #  application.  If the main menu object where to fail, for any reason at-all, then
 #  the user cannot perform any meaningful tasks within application.  The Main Menu
 #  will allow the user to perform requests to configure the application's settings,
 #  compile the desired project, or to perform miscellaneous operations that are
 #  available by the program's Main Menu.
 #>




class MainMenu
{
   <# Main Menu Driver
    # -------------------------------
    # Documentation:
    #   This function allows the user to see and select from all the available
    #   options that exists within the program.  This function is essentially
    #   a driver in which the user can perform various operations as requested.
    # -------------------------------
    # Output:
    #  [integer] Exit Level
    #    0 = Everything was successful
    #   !0 = An error was reached
    # -------------------------------
    #>
    static [int] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the main menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave the menu.
        [bool] $menuLoop = $true;
        # ----------------------------------------

        # Open the Main Menu
        #  Keep the user at the Main Menu until they request to leave the program
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that
            #  it is easy for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Main Menu
            [CommonCUI]::DrawSectionHeader("Main Menu");

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Main Menu list to the user
            [MainMenu]::__DrawMainMenu();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [MainMenu]::__EvaluateExecuteUserRequest($userInput);
        } while ($menuLoop);


        # Finished with the Main Menu; prepare to close the application
        return 0;
    } # Main()




   <# Draw Main Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the Main Menu list the user.  Thus this function
    #   provides what features and options are available to the user.
    # -------------------------------
    #>
    hidden static [void] __DrawMainMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Project Information object; this contains details
        #  in regards to where the source files exists within the user's system.
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();


        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available.
        [bool] $showMenuBuildRelease        = $true;    # Build: Release
        [bool] $showMenuBuildDevelopment    = $true;    # Build: Development
        [bool] $showMenuProjectHomePage     = $true;    # Project's Homepage
        [bool] $showMenuProjectWikiPage     = $true;    # Project's Wiki Page
        [bool] $showMenuProjectSourceCode   = $true;    # Project's Source Code
        # ----------------------------------------



        # Determine what options are to be hidden or to be visible to the user.
        [MainMenu]::__DrawMenuDetermineHiddenMenus([ref] $showMenuProjectHomePage, `        # Project's Homepage
                                                    [ref] $showMenuProjectWikiPage, `       # Project's Wiki Page
                                                    [ref] $showMenuProjectSourceCode, `     # Project's Source Code
                                                    [ref] $showMenuBuildRelease, `          # Build: Release
                                                    [ref] $showMenuBuildDevelopment);       # Build: Development



        # Display the Main Menu list

        # Generate Project and View Project Information
        if ($showMenuBuildRelease)
        {
            [CommonCUI]::DrawMenuItem('B', `
                                    "Build $($projectInformation.GetProjectName())", `
                                    "Create a new build of the $($projectInformation.GetProjectName()) ($($projectInformation.GetCodeName())) project.", `
                                    $NULL, `
                                    $true);
        } # if : Show Build: Release


        # Generate Development Project and View Dev. Project Information
        if ($showMenuBuildDevelopment)
        {
            [CommonCUI]::DrawMenuItem('D', `
                                    "Build a Development Build of $($projectInformation.GetProjectName())", `
                                    "Create a new dev. build of the $($projectInformation.GetProjectName()) ($($projectInformation.GetCodeName())) project.", `
                                    $NULL, `
                                    $true);
        } # if : Show Build: Development


        # Project's Homepage
        if ($showMenuProjectHomePage)
        {
            [CommonCUI]::DrawMenuItem('H', `
                                    "$($projectInformation.GetProjectName()) Homepage", `
                                    "Access the $($projectInformation.GetProjectName())'s Homepage online.", `
                                    $NULL, `
                                    $true);
        } # if : Show Project's Homepage


        # Project's Wiki
        if ($showMenuProjectWikiPage)
        {
            [CommonCUI]::DrawMenuItem('W', `
                                    "$($projectInformation.GetProjectName()) Wiki", `
                                    "Access the $($projectInformation.GetProjectName())'s Wiki documentation online.", `
                                    $NULL, `
                                    $true);
        } # if : Show Project's Wiki Page


        # Project's Source Code
        if ($showMenuProjectSourceCode)
        {
            [CommonCUI]::DrawMenuItem('S', `
                                    "$($projectInformation.GetProjectName()) Source Code", `
                                    "Access the $($projectInformation.GetProjectName())'s source code online.", `
                                    $NULL, `
                                    $true);
        } # if : Show Project's Source Code


        # Project Installer
        [CommonCUI]::DrawMenuItem('I', `
                                "Install Projects into $($GLOBAL:_PROGRAMNAMESHORT_)", `
                                "Install or Update projects into $($GLOBAL:_PROGRAMNAME_)", `
                                $NULL, `
                                $true);


        # Preferences
        [CommonCUI]::DrawMenuItem('P', `
                                "Preferences", `
                                "Configure how $($GLOBAL:_PROGRAMNAME_) works within your desired environment.", `
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


        # Terminate application
        [CommonCUI]::DrawMenuItem('X', `
                                "Exit", `
                                "Close the $($GLOBAL:_PROGRAMNAMESHORT_) program.", `
                                $NULL, `
                                $false);
    } # __DrawMainMenu()




   <# Evaluate and Execute User's Request
    # -------------------------------
    # Documentation:
    #  This function will evaluate and execute the user's desired request in respect to
    #   the Menu options provided.
    # -------------------------------
    # Input:
    #  [string] User's Request
    #   This will provide the user's desired request to run an operation
    #    or to access a specific functionality.
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
        # Retrieve the current instance of the Project Information object; this contains details
        #  in regards to where the source files exists within the user's system.
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();


        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available.
        [bool] $showMenuBuildRelease        = $true;    # Build: Release
        [bool] $showMenuBuildDevelopment    = $true;    # Build: Development
        [bool] $showMenuProjectHomePage     = $true;    # Project's Homepage
        [bool] $showMenuProjectWikiPage     = $true;    # Project's Wiki Page
        [bool] $showMenuProjectSourceCode   = $true;    # Project's Source Code
        # ----------------------------------------



        # Determine what options are to be hidden or to be visible to the user.
        [MainMenu]::__DrawMenuDetermineHiddenMenus([ref] $showMenuProjectHomePage, `        # Project's Homepage
                                                    [ref] $showMenuProjectWikiPage, `       # Project's Wiki Page
                                                    [ref] $showMenuProjectSourceCode, `     # Project's Source Code
                                                    [ref] $showMenuBuildRelease, `          # Build: Release
                                                    [ref] $showMenuBuildDevelopment);       # Build: Development



        # Determine what action was requested by the user.
        switch ($userRequest)
        {
            # Build the desired ZDoom project
            #  NOTE: Allow the user's request when they type: 'Build', 'Make', 'Make $project', 'Build $project', as well as 'B'.
            {($showMenuBuildRelease) -and
                (($_ -eq "B") -or `
                 ($_ -eq "Build") -or `
                 ($_ -eq "Make") -or `
                 ($_ -eq "Make $($projectInformation.GetProjectName())") -or `
                 ($_ -eq "Build $($projectInformation.GetProjectName())"))}
            {
                # Build the desired ZDoom based Project
                [Builder]::Build($false);


                # Allow the user to read the results from the Builder before
                #  refreshing the Main Menu screen.
                [Logging]::GetUserEnterKey();


                # Finished
                break;
            } # Build ZDoom Project


            # Build a developmental build of the desired ZDoom project
            #  NOTE: Allow the user's request when they type: 'Dev' or 'D'.
            {($showMenuBuildDevelopment) -and
                (($_ -eq "D") -or `
                 ($_ -eq "Dev"))}
            {
                # Build the desired ZDoom based Project
                [Builder]::Build($true);


                # Allow the user to read the results from the Builder before
                #  refreshing the Main Menu screen.
                [Logging]::GetUserEnterKey();


                # Finished
                break;
            } # Build ZDoom Project


            # Access the ZDoom project's Homepage
            #  NOTE: Allow the user's request when they type: '$project Homepage' or 'H'.
            {($showMenuProjectHomePage) -and `
                (($_ -eq "H") -or `
                 ($_ -eq "$($projectInformation.GetProjectName()) Homepage"))}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($projectInformation.GetURLWebsite(),                 ` # Project's Homepage
                                                            "$($projectInformation.GetProjectName()) Homepage"))    ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Homepage


            # Access the ZDoom project's Wiki Page
            #  NOTE: Allow the user's request when they type: '$project Wiki' or 'W'.
            {($showMenuProjectWikiPage) -and `
                (($_ -eq "W") -or `
                 ($_ -eq "$($projectInformation.GetProjectName()) Wiki"))}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($projectInformation.GetURLWiki,                  ` # Project's Wiki
                                                            "$($projectInformation.GetProjectName()) Wiki"))    ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Wiki


            # Access the ZDoom project's Source Code Repository
            #  NOTE: Allow the user's request when they type: '$project Source Code', '$project Source', as well as 'S'.
            {($showMenuProjectSourceCode) -and `
                (($_ -eq "S") -or `
                 ($_ -eq "$($projectInformation.GetProjectName()) Source Code") -or `
                 ($_ -eq "$($projectInformation.GetProjectName()) Source"))}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($projectInformation.GetURLSource(),                              ` # Project's Repository
                                                            "$($projectInformation.GetProjectName()) Source Code Repository"))  ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Repository


            # Project Installer
            #  NOTE: Allow the user's request when they type: 'Installer', 'Install', 'Project Installer',
            #       'Install Project' as well as 'I'
            {($_ -eq "Installer") -or `
                ($_ -eq "Install") -or `
                ($_ -eq "Project Installer") -or `
                ($_ -eq "Project Install") -or `
                ($_ -eq "Install Project") -or `
                ($_ -eq "I")}
                {
                    # Open the Project Installer through the Project Manager
                    [ProjectManager]::Main([ProjectManagerOperationRequest]::ShowMenu);


                    # Finished
                    break;
                } # Install \ Update PSCAT Project


            # Configure User Preferences
            #  NOTE: Allow the user's request when they type: 'Settings', 'Preferences', as well as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Settings") -or `
                ($_ -eq "Preferences")}
            {
                # Open the Preferences Main Menu
                [Settings]::Main();


                # Finished
                break;
            } # Configure User Preferences


            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme', 'Help me', as well as '?'.
            {($_ -eq "?") -or `
                ($_ -eq "help") -or `
                ($_ -eq "helpme") -or `
                ($_ -eq "help me")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,               ` # Program's Wiki
                                                            "$($Global:_PROGRAMNAMESHORT_) Wiki"))      ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Help Program's Documentation


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($Global:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation


            # Exit
            #  NOTE: Allow the user's request when they type: 'Exit', 'Quit', as well as 'X'.
            #         This can come handy if the user is in a panic - remember that the terminal
            #         is intimidating for some which may cause user's to panic, and this can be
            #         helpful if user's are just used to typing 'Exit' or perhaps 'Quit'.
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Quit")}
            {
                # Exit
                [Logging]::DisplayMessage("Terminating Software...");

                # Return back to the menu
                return $false;
            } # Exit


            # Unknown Option
            default
            {
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);

                # Provide an error message to the user that the option they chose is not available.
                [CommonCUI]::DrawIncorrectMenuOption();

                # Finished
                break;
            } # Unknown Option
        } # Switch()


        # Return back to the menu
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
    #  [bool] (REFERENCE) Project's Homepage
    #   Provides access to the project's Homepage.
    #  [bool] (REFERENCE) Project's Wiki Page
    #   Provides access to the project's Wiki page.
    #  [bool] (REFERENCE) Project's Source Code
    #   Provides access to the project's source code.
    #  [bool] (REFERENCE) Build: Release
    #   Provide access to the Build Release operation.
    #  [bool] (REFERENCE) Build: Development
    #   Provide access to the Build Development operation.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenuProjectHomePage, `       # Project's Homepage
                                                        [ref] $showMenuProjectWikiPage, `       # Project's Wiki Page
                                                        [ref] $showMenuProjectSourceCode, `     # Project's Source Code
                                                        [ref] $showMenuBuildRelease, `          # Build: Release
                                                        [ref] $showMenuBuildDevelopment)        # Build: Development
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Project Information object; this contains details
        #  in regards to where the source files exists within the user's system.
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();
        # ----------------------------------------




        # Check Project
        # - - - - - -
        # We will inspect the Project Information available to determine if it is possible
        #  to build the project or determine if we cannot build the project due to limited
        #  to no useful data given.


        # Build: Release - Visible
        if ($projectInformation.GetProjectLoaded()) { $showMenuBuildRelease.Value = $true; }

        # Build Release - Hidden
        #   Limited or No Information Available.
        else { $showMenuBuildRelease.Value = $false; }



        # Build: Development - Visible
        if ($projectInformation.GetProjectLoaded()) { $showMenuBuildDevelopment.Value = $true; }

        # Build Development - Hidden
        #   Limited or No Information Available.
        else { $showMenuBuildDevelopment.Value = $false; }




        # Check URLs
        # - - - - - -
        # We will only be able to check if the strings are empty.  If the string is populated,
        #   then we will be able to use the URL.


        # Project's Homepage - Visible
        if (($projectInformation.GetProjectLoaded()) -and `
            ((![CommonIO]::IsStringEmpty($projectInformation.GetURLWebsite())) -and `
             ([WebsiteResources]::CheckSiteAvailability($projectInformation.GetURLWebsite(), $true))))
        {
            $showMenuProjectHomePage.Value = $true;
        } # if : Project's homepage - Visible

        # Project's Homepage - Hidden
        #   Limited or No Information Available.
        else
        {
            $showMenuProjectHomePage.Value = $false;
        } # else : Project's Homepage - Hidden



        # Project's Wiki Page - Visible
        if (($projectInformation.GetProjectLoaded()) -and `
            ((![CommonIO]::IsStringEmpty($projectInformation.GetURLWiki())) -and `
             ([WebsiteResources]::CheckSiteAvailability($projectInformation.GetURLWiki(), $true))))
        {
            $showMenuProjectWikiPage.Value = $true;
        } # if : Project's Wiki Page - Visible

        # Project's Wiki Page - Hidden
        #   Limited or No Information Available.
        else
        {
            $showMenuProjectWikiPage.Value = $false;
        } # else : Project's Wiki Page - Hidden



        # Project's Source Code: Visible
        if (($projectInformation.GetProjectLoaded()) -and `
            ((![CommonIO]::IsStringEmpty($projectInformation.GetURLSource()) -and `
             ([WebsiteResources]::CheckSiteAvailability($projectInformation.GetURLSource(), $true)))))
        {
            $showMenuProjectSourceCode.Value = $true;
        } # if : Project's Source Code - Visible

        # Project's Source Code: Hidden
        #   Limited or No Information Available.
        else
        {
            $showMenuProjectSourceCode.Value = $false;
        } # else : Project's Source Code - Hidden
    } # __DrawMenuDetermineHiddenMenus()
} # MainMenu