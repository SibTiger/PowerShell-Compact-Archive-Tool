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
    static [void] MainSettingsMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the
        #  main settings menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the Main
        #  Settings Menu loop.  If the user wanted to return back to the Main
        #  Menu, this variable's state will be set as false.  Thus, with a false
        #  value - they may return back to the Main Menu.
        [bool] $mainSettingsMenuLoop = $true;
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

            # Show the user that they are at the Main Menu
            [CommonCUI]::DrawSectionHeader("User Preference Main Menu");

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Main Menu list to the user
            [Settings]::DrawMainSettingsMenu();

            # Capture the user's feedback
            $userInput = [Settings]::GetUserInput();

            # Execute the user's request
            $mainSettingsMenuLoop = [Settings]::EvaluateExecuteUserRequest($userInput);
        } while ($mainSettingsMenuLoop)
    } # MainSettingsMenu()




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
        [CommonCUI]::DrawMenuItem('P', "Configure General $([ProjectInformation]::projectName) Preferences");



        # Only show this option if it is available to the user
        if ([Settings]::IsAvailableZip() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('Z', "Configure Zip Preferences");
        } # if: Display .NET Core ZIP Option


        # Only show this option if it is available to the user
        if ([Settings]::IsAvailable7Zip() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('7', "Configure 7Zip Preferences");
        } # if: Display 7Zip Option


        # Only show this option if it available to the user
        if ([Settings]::IsAvailableGit() -eq $true)
        {
            # Option is available, so display it on the settings main menu.
            [CommonCUI]::DrawMenuItem('G', "Configure Git Preferences");
        } # if: Display Git Option



        # Program Tools
        [CommonCUI]::DrawMenuItem('?', "Help Documentation");


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', "Go back to Main Menu");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
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
            {($_ -eq "P") -or `
            ($_ -eq "Configure General $([ProjectInformation]::projectName) Preferences") -or `
            ($_ -eq "Configure General") -or `
            ($_ -eq "Configure Program")}
        {
            # Configure General Program Preferences
            [Logging]::DisplayMessage("Configure General Program Preferences...");

            # Not yet available!
            [Logging]::DisplayMessage("`tYonkers!");
            [Logging]::DisplayMessage("##################################");
            [Logging]::DisplayMessage("");
            [Logging]::DisplayMessage("This feature is not yet available!");
            [Logging]::DisplayMessage("`r`n");
            PAUSE;

            # Finished
            break;
        } # Configure General Program Preferences




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



        return $true;
    } # EvaluateExecuteUserRequest()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will retrieve the user's feedback associated with any
    #   of the Settings Menus.
    # -------------------------------
    # Output:
    #  [string] User's Feedback
    #   Returns the user's feedback
    # -------------------------------
    #>
    hidden static [string] GetUserInput()
    {
        # Let the user know that the program is currently waiting for their
        #  response.
        [CommonCUI]::DrawWaitingForUserResponse();

        # Retrieve the user's feedback and return their desired request such
        #  that it can be
        #  evaluated further.
        return [Logging]::GetUserInput();
    } # GetUserInput()




   <# Is 7Zip Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the 7Zip functionality is available
    #   on the host system.  In order for this operation to work, we will
    #   use the 7Zip object to check if such feature is present.
    # -------------------------------
    # Output:
    #  [bool] 7Zip Availability
    #   When true, this will mean that 7Zip is available and can be used.
    #   False, however, will mean that the 7Zip functionality is not available.
    # -------------------------------
    #>
    hidden static [bool] IsAvailable7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $sevenZip.Detect7ZipExist();
    } # IsAvailable7Zip()




   <# Is Git Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the Git functionality is available
    #   on the host system.  In order for this operation to work, we will
    #   use the Git object to check if such feature is present.
    # -------------------------------
    # Output:
    #  [bool] Git Availability
    #   When true, this will mean that Git is available and can be used.
    #   False, however, will mean that the Git functionality is not available.
    # -------------------------------
    #>
    hidden static [bool] IsAvailableGit()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the Git object
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $gitControl.DetectGitExist();
    } # IsAvailableGit()




   <# Is .NET Core ZIP Archive Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the .NET Core Zip  functionality
    #   is available on the host system.  In order for this operation
    #   to work, we will use the Default Zip object to check if such
    #   feature is present.
    # -------------------------------
    # Output:
    #  [bool] .NET Core Zip Availability
    #   When true, this will mean that Zip is available and can be used.
    #   False, however, will mean that the Zip functionality is not available.
    # -------------------------------
    #>
    hidden static [bool] IsAvailableZip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the Zip object
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $defaultCompress.DetectCompressModule();
    } # IsAvailableZip()
} # Settings