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
            [Settings]::DrawMainSettingsMenu();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [Settings]::EvaluateExecuteUserRequest($userInput);
        } while ($menuLoop)
    } # Main()




   <# Draw Main Settings Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the Main Settings Menu list to the
    #   user.  Thus this function provides to the user as to what classes are
    #   available to configure.
    # -------------------------------
    #>
    hidden static [void] DrawMainSettingsMenu()
    {
        # Display the Main Settings Menu list

        # Generate Project and View Project Information
        [CommonCUI]::DrawMenuItem('P', `
                                "Configure General $([ProjectInformation]::projectName) Preferences", `
                                "$($NULL)", `
                                $false);



        # Only show this option if it is available to the user
        if ([CommonFunctions]::IsAvailableZip() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('Z', `
                                    "Configure Zip Preferences", `
                                    "$($NULL)", `
                                    $false);
        } # if: Display .NET Core ZIP Option


        # Only show this option if it is available to the user
        if ([CommonFunctions]::IsAvailable7Zip() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('7', `
                                    "Configure 7Zip Preferences", `
                                    "$($NULL)", `
                                    $false);
        } # if: Display 7Zip Option


        # Only show this option if it available to the user
        if ([CommonFunctions]::IsAvailableGit() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('G', `
                                    "Configure Git Preferences", `
                                    "$($NULL)", `
                                    $false);
        } # if: Display Git Option



        # Program Tools
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "$($NULL)", `
                                $false);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to Main Menu", `
                                "$($NULL)", `
                                $false);
    } # DrawMainSettingsMenu()




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
    hidden static [bool] EvaluateExecuteUserRequest([string] $userRequest)
    {
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
            {(($_ -eq "Z") -or `
                ($_ -eq "Configure Zip Preferences") -or `
                ($_ -eq "Configure Zip") -or `
                ($_ -eq "Zip")) -and `
                    ([CommonFunctions]::IsAvailableZip() -eq $true)}
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
            {(($_ -eq "7") -or `
                ($_ -eq "Configure 7Zip Preferences") -or `
                ($_ -eq "Configure 7Zip") -or `
                ($_ -eq "7Zip") -or `
                ($_ -eq "7Z")) -and `
                    ([CommonFunctions]::IsAvailable7Zip() -eq $true)}
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
            {(($_ -eq "G") -or `
                ($_ -eq "Configure Git Preferences") -or `
                ($_ -eq "Configure Git") -or `
                ($_ -eq "Git")) -and `
                    ([CommonFunctions]::IsAvailableGit() -eq $true)}
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
                #  NOTE: We do not care about the return result as there's
                #         nothing we can do at this present point.
                [WebsiteResources]::AccessWebSite_General("$($Global:_PROGRAMSITEWIKI_)",              ` # Project's Repository
                                                        "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                        $false) | Out-Null;                             ` # Do not force Web Browser function


                # Finished
                break;
            } # Access Help Program's Documentation



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
                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();

                # Finished
                break;
            } # Unknown Option
        } # Switch: Option Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # EvaluateExecuteUserRequest()
} # Settings