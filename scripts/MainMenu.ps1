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
            [MainMenu]::DrawMainMenu();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [MainMenu]::EvaluateExecuteUserRequest($userInput);
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
    hidden static [void] DrawMainMenu()
    {
        # Display the Main Menu list

        # Generate Project and View Project Information
        [CommonCUI]::DrawMenuItem('B', `
                                "Build $([ProjectInformation]::projectName)", `
                                "Create a new build of the $([ProjectInformation]::projectName) ($([ProjectInformation]::codeName)) project.", `
                                $NULL, `
                                $true);

        # Generate Development Project and View Dev. Project Information
        [CommonCUI]::DrawMenuItem('D', `
                                "Build a Development Build of $([ProjectInformation]::projectName)", `
                                "Create a new dev. build of the $([ProjectInformation]::projectName) ($([ProjectInformation]::codeName)) project.", `
                                $NULL, `
                                $true);


        [CommonCUI]::DrawMenuItem('H', `
                                "$([ProjectInformation]::projectName) Homepage", `
                                "Access the $([ProjectInformation]::projectName)'s Homepage online.", `
                                $NULL, `
                                $true);

        [CommonCUI]::DrawMenuItem('W', `
                                "$([ProjectInformation]::projectName) Wiki", `
                                "Access the $([ProjectInformation]::projectName)'s Wiki documentation online.", `
                                $NULL, `
                                $true);

        [CommonCUI]::DrawMenuItem('S', `
                                "$([ProjectInformation]::projectName) Source Code", `
                                "Access the $([ProjectInformation]::projectName)'s source code online.", `
                                $NULL, `
                                $true);


        # Program Tools
        [CommonCUI]::DrawMenuItem('P', `
                                "Preferences", `
                                "Configure how $($GLOBAL:_PROGRAMNAME_) works within your desired environment.", `
                                $NULL, `
                                $true);

        [CommonCUI]::DrawMenuItem('U', `
                                "Update $($Global:_PROGRAMNAME_)", `
                                "Check for new available versions of $($GLOBAL:_PROGRAMNAMESHORT_).", `
                                $NULL, `
                                $true);

        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online.", `
                                $NULL, `
                                $true);


        # Terminate application
        [CommonCUI]::DrawMenuItem('X', `
                                "Exit", `
                                "Close the $($GLOBAL:_PROGRAMNAMESHORT_) program.", `
                                $NULL, `
                                $false);
    } # DrawMainMenu()




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
    hidden static [bool] EvaluateExecuteUserRequest([string] $userRequest)
    {
        switch ($userRequest)
        {
            # Build the desired ZDoom project
            #  NOTE: Allow the user's request when they type: 'Build', 'Make', 'Make $project', 'Build $project', as well as 'B'.
            {($_ -eq "B") -or `
                ($_ -eq "Build") -or `
                ($_ -eq "Make") -or `
                ($_ -eq "Make $([ProjectInformation]::projectName)") -or `
                ($_ -eq "Build $([ProjectInformation]::projectName)")}
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
            {($_ -eq "D") -or `
                ($_ -eq "Dev")}
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
            {($_ -eq "H") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Homepage")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General([ProjectInformation]::urlWebsite,                ` # Project's Homepage
                                                            "$([ProjectInformation]::projectName) Homepage",    ` # Show page title
                                                            $false))                                            ` # Do not force Web Browser functionality.
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [Notifications]::Notify([NotificationEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Homepage


            # Access the ZDoom project's Wiki Page
            #  NOTE: Allow the user's request when they type: '$project Wiki' or 'W'.
            {($_ -eq "W") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Wiki")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General([ProjectInformation]::urlWiki,               ` # Project's Wiki
                                                            "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                            $false))                                        ` # Do not force Web Browser functionality.
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [Notifications]::Notify([NotificationEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Wiki


            # Access the ZDoom project's Source Code Repository
            #  NOTE: Allow the user's request when they type: '$project Source Code', '$project Source', as well as 'S'.
            {($_ -eq "S") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Source Code") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Source")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General([ProjectInformation]::urlSource,                             ` # Project's Repository
                                                            "$([ProjectInformation]::projectName) Source Code Repository",  ` # Show page title
                                                            $false))                                                        ` # Do not force Web Browser functionality.
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [Notifications]::Notify([NotificationEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access ZDoom project's Repository


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


            # Update Software
            #  NOTE: Allow the user's request when they type: 'Update' or 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "update")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEDOWNLOADS_,      ` # Program's Download Page
                                                            "Update $($Global:_PROGRAMNAME_)",      ` # Show page title
                                                            $false))                                ` # Do not force Web Browser functionality.
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [Notifications]::Notify([NotificationEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Update Software


            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme', 'Help me', as well as '?'.
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
            } # Help Program's Documentation


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
                [Notifications]::Notify([NotificationEventType]::IncorrectOption);

                # Provide an error message to the user that the option they chose is not available.
                [CommonCUI]::DrawIncorrectMenuOption();

                # Finished
                break;
            } # Unknown Option
        } # Switch()


        # Return back to the menu
        return $true;
    } # EvaluateExecuteUserRequest()
} # MainMenu