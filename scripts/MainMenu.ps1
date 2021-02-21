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
    # Input:
    #  [UserPreferences] User Preferences
    #   Contains the User Preferences for the generalized application.
    #  [GitControl] Git Control User Settings
    #   Contains the user's preferences for the Git Control functionality.
    #  [SevenZip] 7Zip User Settings
    #   Contains the user's preferences for the 7Zip functionality. 
    #  [DefaultComnpress] Default Compression (.NET) User Settings
    #   Contains the user's preferences for the Default Compression functionality.
    #  [LoadSaveUserConfiguration] Load\Save User Configuration
    #   Contains the user's preferences for the Load\Save user configuration.
    # -------------------------------
    # Output:
    #  [integer] Exit Level
    #    0 = Everything was successful
    #   !0 = An error was reached
    # -------------------------------
    #>
    static [int] Main([UserPreferences] $userPreferences,                       # User Preferences
                    [GitControl] $gitControl,                                   # Git Control Settings
                    [SevenZip] $sevenZip,                                       # 7Zip Settings
                    [DefaultCompress] $defaultCompress,                         # Default Compress (.NET) Settings
                    [LoadSaveUserConfiguration] $loadSaveUserConfiguration)     # Load\Save User Configuration
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the main menu.
        [string] $userInput = $null;
        # ----------------------------------------


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
            "B"
            {
                # Build the desired ZDoom project
                [Logging]::DisplayMessage("Build Project...");

                # Finished
                break;
            } # Build ZDoom Project

            # Access the ZDoom project's Homepage
            "H"
            {
                # Access the ZDoom project's Homepage
                [Logging]::DisplayMessage("Accessing Homepage...");

                # Finished
                break;
            } # Access ZDoom project's Homepage

            # Access the ZDoom project's Wiki Page
            "W"
            {
                # Access the ZDoom project's Wiki page
                [Logging]::DisplayMessage("Accessing Wiki...");

                # Finished
                break;
            } # Access ZDoom project's Wiki


            # Access the ZDoom project's Source Code Repository
            "S"
            {
                # Access the ZDoom project's Source Code Repository
                [Logging]::DisplayMessage("Accessing Source Code Repository");

                # Finished
                break;
            } # Access ZDoom project's Repository

            # Configure User Preferences
            "P"
            {
                # Configure User Preferences
                [Logging]::DisplayMessage("Configuring User Settings...");

                # Finished
                break;
            } # Configure User Preferences

            # Update Software
            "U"
            {
                # Update software
                [Logging]::DisplayMessage("Updating Software...");

                # Finished
                break;
            } # Update Software

            # Exit
            {($_ -eq "X") -or ($_ -eq "Exit") -or ($_ -eq "Quit")}
            {
                # Exit
                [Logging]::DisplayMessage("Terminating Software...");

                # Return back to the menu
                return $false;
            } # Exit

            # Unknown Option
            default
            {
                # Unknown Option
                [Logging]::DisplayMessage("<!> UNKNOWN OPTION PROVIDED <!>");

                # Finished
                break;
            } # Unknown Option
        } # Switch()


        # Return back to the menu
        return $true;
    } # EvaluateExecuteUserRequest()
} # MainMenu