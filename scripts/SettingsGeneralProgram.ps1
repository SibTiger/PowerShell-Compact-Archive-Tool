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
            #$userInput = []
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
        [CommonCUI]::DrawMenuItem('C', "Compression Tool");
        [CommonCUI]::DrawMenuItem('P', "Locate Project Path");
        [CommonCUI]::DrawMenuItem('O', "Compiled Builds Output Path");
        [CommonCUI]::DrawMenuItem('G', "Git Features");
        [CommonCUI]::DrawMenuItem('E', "Windows Explorer Features");
        [CommonCUI]::DrawMenuItem('A', "Alarms");



        # Program Tools
        [CommonCUI]::DrawMenuItem('?', "Help Documentation");


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', "Go back to Main Menu");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
        # 
    } # DrawMenu()
} # SettingsGeneralProgram