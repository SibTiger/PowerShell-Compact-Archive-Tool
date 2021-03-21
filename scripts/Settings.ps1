<# Settings
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user to easily modify their settings
 #  from various known objects, in which contains variables that
 #  are configurable within the designated object - and friendly
 #  within the program's environment.  Because the idea of the
 #  program's objects are not supposed to integrate its settings
 #  per-class, we will need to use a centralized settings class
 #  to unify the User Interface and functionality, while allowing
 #  all of the objects to be configured respectively.  This is
 #  where this class comes into play.  We will want to be sure
 #  that we can easily allow the user to configure their settings
 #  and to make it as painless as possible.
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
    static [void] MainSettingsMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the main settings menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the Main Settings Menu loop.
        #  If the user wanted to return back to the Main Menu, this variable's state will be set as
        #  false.  Thus, with a false value - they may return back to the Main Menu.
        [bool] $mainSettingsMenuLoop = $true;
        # ----------------------------------------

        # Open the Main Settings Menu
        #  Keep the user at the Main Settings Menu until they request to return back to the Main Menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that
            #  it is easy for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Main Menu
            [CommonCUI]::DrawSectionHeader("User Preference Main Menu");

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Main Menu list to the user
            [Settings]::DrawMainSettingsMenu();

            # Capture the user's feedback
            $userInput = [Settings]::GetUserInput();
        } while ($mainSettingsMenuLoop)
    } # MainSettingsMenu()




<# Draw Main Settings Menu
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the Main Settings Menu list to the user.  Thus this function
    #   provides to the user as to what classes are available to configure.
    # -------------------------------
    #>
    static [void] DrawMainSettingsMenu()
    {
        # Display the Main Settings Menu list

        # Generate Project and View Project Information
        [CommonCUI]::DrawMenuItem('P', "Configure General $([ProjectInformation]::projectName) Preferences");
        [CommonCUI]::DrawMenuItem('Z', "Configure Zip Preferences");
        [CommonCUI]::DrawMenuItem('7', "Configure 7Zip Preferences");
        [CommonCUI]::DrawMenuItem('G', "Configure Git Preferences");


        # Program Tools
        [CommonCUI]::DrawMenuItem('?', "Help Documentation");


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', "Go back to Main Menu");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # DrawMainSettingsMenu()





   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will retrieve the user's feedback associated with any of the Settings Menus.
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
} # Settings