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
            [SettingsGeneralProgram]::DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequest($userInput);
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
    hidden static [void] DrawMenu()
    {
        # Display the menu list
        # Paths
        [CommonCUI]::DrawMenuItem('P', "Locate Project Path", "$($NULL)");
        [CommonCUI]::DrawMenuItem('O', "Compiled Builds Output Path", "$($NULL)");


        # Tools and Features
        [CommonCUI]::DrawMenuItem('C', "Compression Tool", "$($NULL)");
        [CommonCUI]::DrawMenuItem('G', "Git Features", "$($NULL)");
        [CommonCUI]::DrawMenuItem('E', "Graphical User Interface Features", "$($NULL)");


        # Notifications
        [CommonCUI]::DrawMenuItem('N', "Notifications", "$($NULL)");


        # Program Tools
        [CommonCUI]::DrawMenuItem('?', "Help Documentation", "$($NULL)");


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', "Go back to previous menu", "$($NULL)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # DrawMenu()




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
            # Locate the Project Path
            #  NOTE: Allow the user's request when they type: 'Locate Project'
            #           'Locate Project Path', as well as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Locate Project Path") -or `
                ($_ -eq "Locate Project")}
            {
                # Allow the user to update or verify the project path.
                [SettingsGeneralProgram]::LocateProjectPath();


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
                # Still working on this


                # Finished
                break;
            } # Compiled Builds Output Path



            # Compression Tool
            #  NOTE: Allow the user's request when they type: 'Compression Tool', 'Compression',
            #           as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Compression Tool") -or `
                ($_ -eq "Compression")}
            {
                # Still working on this


                # Finished
                break;
            } # Compression Tool



            # Git Features
            #  NOTE: Allow the user's request when they type: 'Git Features', 'Git',
            #           as well as 'G'.
            {($_ -eq "G") -or `
                ($_ -eq "Git Features") -or `
                ($_ -eq "Git")}
            {
                # Still working on this


                # Finished
                break;
            } # Git Features



            # Graphical User Interface Features
            #  NOTE: Allow the user's request when they type: 'Graphical User Interface Features',
            #           'GUI Features', as well as 'E'.
            {($_ -eq "E") -or `
                ($_ -eq "Graphical User Interface Features") -or `
                ($_ -eq "GUI Features")}
            {
                # Still working on this


                # Finished
                break;
            } # Graphical User Interface Features



            # Notifications
            #  NOTE: Allow the user's request when they type: 'Notifications', 'Notify', and 'N'.
            {($_ -eq "N") -or `
                ($_ -eq "Notifications") -or `
                ($_ -eq "Notify")}
            {
                # Still working on this


                # Finished
                break;
            } # Notifications



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




   <# Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the Project Path, so that this program
    #   can perform compact the project as expected.
    # -------------------------------
    #>
    hidden static [void] LocateProjectPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------

        # Open the Locate Project Path Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Clear the terminal  of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Locate Project Path
            [CommonCUI]::DrawSectionHeader("Locate Project Path");

            # Provide the current project path
            [Logging]::DisplayMessage("Current Project Path is the following:`r`n" + `
                                        "`t$($userPreferences.GetProjectPath())");

            # Provide some extra whitespacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuLocateProjectPath();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestLocateProjectPath($userInput);
        } until ($menuLoop)
    } # LocateProjectPath()




   <# Draw Menu: Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate Project Path to the user.
    #   Thus this provides what options are available to the user in order to configure the
    #   project path.
    # -------------------------------
    #>
    hidden static [void] DrawMenuLocateProjectPath()
    {
        # Display the Menu List

        # Change the Project Path
        [CommonCUI]::DrawMenuItem('C', "Change Path", "$($NULL)");


        # Make sure that the path is correct
        [CommonCUI]::DrawMenuItem('T', "Test Path", "$($NULL)");


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', "Cancel", "$($NULL)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # DrawMenuLocateProjectPath()




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
    #   $true  = User is to remain at the Menu.
    #   $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] EvaluateExecuteUserRequestLocateProjectPath([string] $userRequest)
    {
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
                LocateProjectPathNewPath();


                # Finished
                break;
            } # Change Path



            # Test the Project Path
            #  NOTE: Allow the user's request when they type: 'Test Path', 'Verify', 'Verify Path',
            #           as well as 'T'.
            {($_ -eq "T") -or `
                ($_ -eq "Test Path") -or `
                ($_ -eq "Verify") -or `
                ($_ -eq "Verify Path")}
            {
                # Still working on this


                # Finished
                break;
            } # Test Path



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
                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # EvaluateExecuteUserRequestLocateProjectPath()
    
    
    
    
    
    
   <# Configure Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the Project source directory.
    # -------------------------------
    #>
    hidden static [void] LocateProjectPathNewPath()
    {
        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        
    } # LocateProjectPathNewPath()
} # SettingsGeneralProgram