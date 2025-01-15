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
 #  application.
 #>




class MainMenu
{
   <# Main Menu Driver
    # -------------------------------
    # Documentation:
    #  This function will present the Main Menu to the user, where the user
    #   can choose what the program will be doing.
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
    #   provides what options are available to the user.
    # -------------------------------
    #>
    hidden static [void] __DrawMainMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # These variables will determine what menu items are to be hidden from the user,
        #  as the options are possibly not available.
        [bool] $showOptionBuild     = $false;    # Build Project
        [bool] $showOptionWebpage   = $false;    # Project's Webpage

        # This string will show what project is presently loaded into the program's environment.
        #   However, if and only if, a project /is/ loaded.
        [string] $projectName       = $NULL;
        # ----------------------------------------



        # Determine what options are to be hidden or to be visible to the user.
        [MainMenu]::__DrawMenuDetermineHiddenMenus( [ref] $showOptionBuild, `   # Build Project
                                                    [ref] $showOptionWebpage);  # Project's Webpage

        # Show the Project Name to the user, if one is presently loaded into the program's environment.
        if ([ProjectInformation]::GetIsLoaded())
        { $projectName = "Project Loaded is: " + [ProjectInformation]::GetProjectName(); }
        else
        { $projectName = "No project is presently loaded; please select a project to continue."; }



        # Display the Main Menu list

        # Build Project
        if ($showOptionBuild)
        {
            [CommonCUI]::DrawMenuItem('B', `
                                    "Build the Project, $([ProjectInformation]::GetProjectName())", `
                                    "Create a new build of the $([ProjectInformation]::GetProjectName()) project.", `
                                    $NULL, `
                                    $true);
        } # if : Show Build Project


        # Project's Webpage
        if ($showOptionWebpage)
        {
            [CommonCUI]::DrawMenuItem('H', `
                                    "Access the project's, $([ProjectInformation]::GetProjectName()), webpage", `
                                    [ProjectInformation]::GetProjectWebsite(), `
                                    $NULL, `
                                    $true);
        } # if : Show Project's Webpage


        # Load a new project
        [CommonCUI]::DrawMenuItem('L', `
                                "Load a new project into $($GLOBAL:_PROGRAMNAME_).", `
                                $projectName, `
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
    #  This function will evaluate and execute the user's request in respect to
    #   the Main Menu options provided.
    # -------------------------------
    # Input:
    #  [string] User's Request
    #   This is the user's input to interact within the Main Menu.
    # -------------------------------
    # Output:
    #  [bool] User Stays at Menu
    #   This defines if the user is to remain at the Main Menu screen.
    #   $true  = User is to remain at the Main Menu.
    #   $false = User requested to leave the Main Menu.
    # -------------------------------
    #>
    hidden static [bool] __EvaluateExecuteUserRequest([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # These variables will determine what menu items were hidden from the user,
        #  as the options are possibly not available.
        [bool] $showOptionBuild     = $false;    # Build Project
        [bool] $showOptionWebpage   = $false;    # Project's Webpage
        # ----------------------------------------



        # Determine what options were hidden from the user.
        [MainMenu]::__DrawMenuDetermineHiddenMenus( [ref] $showOptionBuild, `   # Build Project
                                                    [ref] $showOptionWebpage);  # Project's Webpage



        # Determine what action was requested by the user.
        switch ($userRequest)
        {
            # Build the desired project
            {($showOptionBuild) -and
                (($_ -eq "B") -or `
                 ($_ -eq "Build") -or `
                 ($_ -eq "Make") -or `
                 ($_ -eq "Make $([ProjectInformation]::GetProjectName())") -or `
                 ($_ -eq "Build $([ProjectInformation]::GetProjectName())"))}
            {
                # Build the desired based Project
                [Builder]::Build();


                # Allow the user to read the results from the Builder before
                #  refreshing the Main Menu screen.
                [Logging]::GetUserEnterKey();


                # Finished
                break;
            } # Build Project


            # Access the project's Website
            {($showOptionWebpage) -and `
                (($_ -eq "H") -or `
                 ($_ -eq "$([ProjectInformation]::GetProjectName()) Webpage"))}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General([ProjectInformation]::GetProjectWebsite(),           ` # Project's Webpage
                                                            "$([ProjectInformation]::GetProjectName()) Webpage"))   ` # Show page title
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access project's Webpage


            # Load a Project into the Program
            {(($_ -eq "L") -or `
                ($_ -eq "Load") -or `
                ($_ -eq "Load Project"))}
            {
                # Load a new project into the program's environment.
                [ProjectInformation]::Load();


                # Allow the user to read the results from the Project Information class
                #   before refreshing the Main Menu screen.
                [Logging]::GetUserEnterKey();


                # Finished
                break;
            } # Load Project into Program


            # Access the Program's Help Documentation
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
            } # Program's Help Documentation


            # Access the Program's Bug Tracker
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
            } # Access Program's Help Documentation


            # Exit
            {($_ -eq "X") -or `
                ($_ -eq "Exit") -or `
                ($_ -eq "Quit")}
            {
                # Notify the user that the program is now terminating.
                [Logging]::DisplayMessage("Terminating $($GLOBAL:_PROGRAMNAME_)...");

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
    #  This function will determine what menu items are available to the user.
    #   Because some options may not be available then do not present the item
    #   to the user.
    # -------------------------------
    # Input:
    #  [bool] (REFERENCE) Show Menu Item: Compile Project
    #   A flag that signifies if it is possible to compile the project.
    #  [bool] (REFERENCE) Show Menu Item: Access Project's Webpage
    #   A flag that signifies if it is possible to access the project's webpage.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenuBuildProject, `       # Project's Homepage
                                                        [ref] $showMenuProjectWebpage)       # Project's Wiki Page
    {
        # CHECK PROJECT VARIABLES
        # - - - - - - - - - - - - -
        # Is a project loaded into the environment?
        if ([ProjectInformation]::GetIsLoaded())
        {
            # Because a project is loaded, it is possible to compile a build of the project.
            $showMenuBuildProject.Value = $true;


            # Project's Webpage is Available - Visible
            if (([CommonIO]::IsStringEmpty([ProjectInformation]::GetProjectWebsite()) -eq $false) -and `
                ([WebsiteResources]::CheckSiteAvailability([ProjectInformation]::GetProjectWebsite(), $true)))
            { $showMenuProjectWebpage.Value = $true; }

            # Project's Webpage is Hidden
            else
            { $showMenuProjectWebpage.Value = $false; }
        } # if : Project is Loaded

        # Project is not loaded into the environment.
        else
        {
            # Hide the ability to compile the project.
            $showMenuBuildProject.Value = $false;

            # Hide the ability to access the project's webpage.
            $showMenuProjectWebpage.Value = $false;
        } # else: Project is not Loaded
    } # __DrawMenuDetermineHiddenMenus()
} # MainMenu