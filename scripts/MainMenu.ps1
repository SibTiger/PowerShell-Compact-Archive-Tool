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
        # Draw Program Information Header
        [MainMenu]::DrawProgramInformation();

        # Draw the Instructions so that the user knows how to interact with the application.
        [mainMenu]::DrawInstructions();

        # Draw the Main Menu to the user's screen
        [MainMenu]::DrawMainMenu();


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
        # Display the program information

        # For right now, I will need to figure out how the program information will be
        # presented to the user.
        [Logging]::DisplayMessage("<<< PROGRAM INFORMATION >>>", `  # Message to display
                                    "Standard");                    # Message Level
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

        # For right now, I do not know of how the instructions are going to be presented to the
        #  user.
        [Logging]::DisplayMessage("<<< INSTRUCTIONS >>>", `     # Message to display
                                    "Standard");                # Message Level
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


        # For right now, I do not know of how the menu is going to be interacted with the user.
        #  Thus, for right now - just provide anything onto the screen and when I have a better
        #  idea of how the program is going to interact with the user, then I will update this
        #  accordingly.
        [Logging]::DisplayMessage("<<< MAIN MENU HERE >>>", `   # Message to display
                                    "Standard");                # Message level
    } # DrawMainMenu()
} # MainMenu