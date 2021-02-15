<# Main Menu
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the ability for the user to interact with the application and to
 #  access functionality that is available within the program.  Thus, the main menu
 #  provides a way for the user to perform any essential task possible.  If the main
 #  menu object where to fail, then the user cannot perform any meaningful tasks within
 #  application.  The Main Menu will allow the End-User to drive the application by
 #  performing various tasks as expected, such as: accessing the User Settings, perform
 #  compile configurations, check program state, and other features if deemed available.
 #>




class MainMenu
{
   <# Main Menu Driver
    # -------------------------------
    # Documentation:
    #   This function allows the user to see all available functionalities that exists within
    #   the software and to drive the application as desired.  This function, essentially, is
    #   a driver in which the user can perform various operations as needed.
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
        [MainMenu]::DrawProgramInformation();

        # Draw the Instructions so that the user knows how to interact with the application.
        [mainMenu]::DrawInstructions();

        # Draw the Main Menu to the user's screen
        [MainMenu]::DrawMainMenu();

        # Capture the user's input
        $userInput = [MainMenu]::GetUserInput();


        # Finished with the Main Menu; prepare to close the application
        return 0;
    } # Main()




   <# Draw Program Information
    # -------------------------------
    # Documentation:
    #  This function will display the Program Information to the user so that they are able
    #   to see what version of the program is currently running.
    # -------------------------------
    #>
    static [void] DrawProgramInformation()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the main border
        [string] $border    = "----------------------------------------------------";
        # This will help separate the contents
        [string] $borderSub = "- - - - - - - - - - - - - - - - - - - - - - - - - - ";
        # ----------------------------------------


        # Display the program information
        [Logging]::DisplayMessage("$($border)");

        # Show the full program name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Show the version, version name, and the release date of the version.
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");

        # Change of contents
        [Logging]::DisplayMessage("$($borderSub)");

        # Show the intended supported project
        [Logging]::DisplayMessage("Designed for $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)]");
        [Logging]::DisplayMessage("$($border)");
        [Logging]::DisplayMessage("$($border)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n`r`n");
    } # DrawProgramInformation()




   <# Draw Instructions
    # -------------------------------
    # Documentation:
    #  This function will display the Main Menu instructions to the user so that they know
    #   how to interact with the application.  The instructions are to be minimal but yet
    #   concise so that the user can easily start using the program, but not to the point
    #   of flooding the returning user.
    # -------------------------------
    #>
    static [void] DrawInstructions()
    {
        # Display the instructions to the user
        # Try to keep the instructions minimal yet impactful so that the user knows how to use the main menu.


        # Show to the user that they are in the main menu screen
        [Logging]::DisplayMessage("`t`t  Main Menu");
        [Logging]::DisplayMessage("`t~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n");

        # Instructions
        [Logging]::DisplayMessage("Select from the following available options:");
        [Logging]::DisplayMessage("----------------------------------------------------");
    } # DrawInstructions()




   <# Draw Main Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the Main Menu selection onto the End-User's terminal
    #   buffer, thus providing what features and functionalities are available to the end-user
    #   and how the user can access them directly using their keyboard or other input devices.
    # -------------------------------
    #>
    static [void] DrawMainMenu()
    {
        # Display the main menu

        # Generate Project and View Project Information
        [Logging]::DisplayMessage(" [B] - Build $([ProjectInformation]::projectName)");
        [Logging]::DisplayMessage(" [H] - Access $([ProjectInformation]::projectName) Homepage");
        [Logging]::DisplayMessage(" [W] - Access $([ProjectInformation]::projectName) Wiki");
        [Logging]::DisplayMessage(" [S] - Access $([ProjectInformation]::projectName) Source Code");

        # Empty Space; help to provide some separation between the two different categories
        [Logging]::DisplayMessage("$($null)");

        # Program Tools
        [Logging]::DisplayMessage(" [P] - Preferences");
        [Logging]::DisplayMessage(" [U] - Update $($Global:_PROGRAMNAME_)");


        # Terminate application
        [Logging]::DisplayMessage(" [X] - Exit");
    } # DrawMainMenu()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will ask the user to provide input so that they may navigate within the
    #   Main Menu.
    # -------------------------------
    # Output:
    #  [string] User's Feedback
    #   Returns the user's feedback for navigating the Main Menu
    # -------------------------------
    #>
    static [string] GetUserInput()
    {
        # For right now, I do not know of how the menu is going to be interacted with the user.
        #  Thus, for right now - just provide anything onto the screen and when I have a better
        #  idea of how the program is going to interact with the user, then I will update this
        #  accordingly.
        [Logging]::DisplayMessage("<<< GET USER INPUT >>>", `   # Message to display
                                    "Standard");                # Message level


        # Get the user's input
        return [Logging]::GetUserInput();
    } # GetUserInput()
} # MainMenu