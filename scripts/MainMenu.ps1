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

        # This variable will determine if the user is to remain within the Main Menu loop.
        #  If the user were to exit from the program, this variable's state will be set as
        #  false.  Thus, with a false value - they may leave the program.
        [bool] $mainMenuLoop = $true;
        # ----------------------------------------

        # Open the Main Menu
        #  Keep the user at the Main Menu until they request to leave the program
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that
            #  it is easy for the user to read and follow along.
            [IOCommon]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Main Menu
            [CommonCUI]::DrawSectionHeader("Main Menu");

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Main Menu list to the user
            [MainMenu]::DrawMainMenu();

            # Capture the user's feedback
            $userInput = [MainMenu]::GetUserInput();

            # Execute the user's request
            $mainMenuLoop = [MainMenu]::EvaluateExecuteUserRequest($userInput);
        } while ($mainMenuLoop)


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
    static [void] DrawMainMenu()
    {
        # Display the Main Menu list

        # Generate Project and View Project Information
        [CommonCUI]::DrawMenuItem('B', "Build $([ProjectInformation]::projectName)");
        [CommonCUI]::DrawMenuItem('H', "Access $([ProjectInformation]::projectName) Homepage");
        [CommonCUI]::DrawMenuItem('W', "Access $([ProjectInformation]::projectName) Wiki");
        [CommonCUI]::DrawMenuItem('S', "Access $([ProjectInformation]::projectName) Source Code");


        # Program Tools
        [CommonCUI]::DrawMenuItem('P', "Preferences");
        [CommonCUI]::DrawMenuItem('U', "Update $($Global:_PROGRAMNAME_)");
        [CommonCUI]::DrawMenuItem('?', "Help Documentation");


        # Terminate application
        [CommonCUI]::DrawMenuItem('X', "Exit");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # DrawMainMenu()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will retrieve the user's feedback associated with the Main Menu.
    # -------------------------------
    # Output:
    #  [string] User's Feedback
    #   Returns the user's feedback
    # -------------------------------
    #>
    static [string] GetUserInput()
    {
        # Let the user know that the program is currently waiting for their response.
        [CommonCUI]::DrawWaitingForUserResponse();

        # Retrieve the user's feedback and return their desired request such that it can be
        #  evaluated further.
        return [Logging]::GetUserInput();
    } # GetUserInput()




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
    static [bool] EvaluateExecuteUserRequest([string] $userRequest)
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
                # Build the desired ZDoom project
                [Logging]::DisplayMessage("Build Project...");

                # Not yet available!
                [Logging]::DisplayMessage("`tYonkers!");
                [Logging]::DisplayMessage("##################################");
                [Logging]::DisplayMessage("");
                [Logging]::DisplayMessage("This feature is not yet available!");
                [Logging]::DisplayMessage("Please wait a bit more time so that I can construct this feature properly....");
                [Logging]::DisplayMessage("`r`n");
                PAUSE;

                # Finished
                break;
            } # Build ZDoom Project


            # Access the ZDoom project's Homepage
            #  NOTE: Allow the user's request when they type: '$project Homepage' or 'H'.
            {($_ -eq "H") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Homepage")}
            {
                # Open the webpage as requested
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_General("$([ProjectInformation]::urlWebsite)",            ` # Project's Homepage
                                                        "$([ProjectInformation]::projectName) Homepage",    ` # Show page title
                                                        $false) | Out-Null;                                 ` # Do not force Web Browser function


                # Finished
                break;
            } # Access ZDoom project's Homepage


            # Access the ZDoom project's Wiki Page
            #  NOTE: Allow the user's request when they type: '$project Wiki' or 'W'.
            {($_ -eq "W") -or `
                ($_ -eq "$([ProjectInformation]::projectName) Wiki")}
            {
                # Open the webpage as requested
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_General("$([ProjectInformation]::urlWiki)",           ` # Project's Wiki
                                                        "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                        $false) | Out-Null;                             ` # Do not force Web Browser function


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
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_General("$([ProjectInformation]::urlSource)",                         ` # Project's Repository
                                                        "$([ProjectInformation]::projectName) Source Code Repository",  ` # Show page title
                                                        $false) | Out-Null;                                             ` # Do not force Web Browser function


                # Finished
                break;
            } # Access ZDoom project's Repository


            # Configure User Preferences
            #  NOTE: Allow the user's request when they type: 'Settings', 'Preferences', as well as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Settings") -or `
                ($_ -eq "Preferences")}
            {
                # Configure User Preferences
                [Logging]::DisplayMessage("Configuring User Settings...");


                # Not yet available!
                [Logging]::DisplayMessage("`tYonkers!");
                [Logging]::DisplayMessage("##################################");
                [Logging]::DisplayMessage("");
                [Logging]::DisplayMessage("This feature is not yet available!");
                [Logging]::DisplayMessage("Please wait a bit more time so that I can construct this feature properly....");
                [Logging]::DisplayMessage("`r`n");
                PAUSE;


                # Finished
                break;
            } # Configure User Preferences


            # Update Software
            #  NOTE: Allow the user's request when they type: 'Update' or 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "update")}
            {
                # Open the webpage as requested
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_Update("$($Global:_PROGRAMSITEDOWNLOADS_)",      ` # Project's Repository
                                                        "Update $($Global:_PROGRAMNAME_)",          ` # Show page title
                                                        $false) | Out-Null;                         ` # Do not force Web Browser function


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
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_General("$($Global:_PROGRAMSITEWIKI_)",              ` # Project's Repository
                                                        "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                        $false) | Out-Null;                             ` # Do not force Web Browser function


                # Finished
                break;
            } # Access ZDoom project's Repository


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