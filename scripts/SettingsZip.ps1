<# Settings - Zip Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the ability for the user to configure
 #  how the program will interact with the user as well how the
 #  program will perform specific functionalities with the
 #  supporting technologies.
 #>




 class SettingsZip
 {
    <# Settings Zip Menu Driver
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

         # Open the Zip Settings Menu
         #  Keep the user at the Zip Settings Menu until they request to return
         #  back to the previous menu.
         do
         {
             # Clear the terminal of all previous text; keep the space clean so that it is easy
             #  for the user to read and follow along.
             [CommonIO]::ClearBuffer();

             # Draw Program Information Header
             [CommonCUI]::DrawProgramTitleHeader();

             # Show the user that they are at the Zip Settings Menu.
             [CommonCUI]::DrawSectionHeader("Zip Settings Menu");

             # Display the instructions to the user
             [CommonCUI]::DrawMenuInstructions();

             # Draw the Zip Settings Menu list to the user
             [SettingsZip]::DrawMenu();

             # Capture the user's feedback
             $userInput = [CommonCUI]::GetUserInput();

             # Execute the user's request
             $menuLoop = [SettingsZip]::EvaluateExecuteUserRequest($userInput);
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
         [CommonCUI]::DrawMenuItem('C', "Compression Level");
         [CommonCUI]::DrawMenuItem('V', "Verify Build after Compression");
         [CommonCUI]::DrawMenuItem('R', "Generate Report of Archive Datafile");


         # Program Tools
         [CommonCUI]::DrawMenuItem('?', "Help Documentation");


         # Return back to the Main Menu
         [CommonCUI]::DrawMenuItem('X', "Go back to previous Menu");


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
             # Compression Level
             {($_ -eq "C") -or `
                 ($_ -eq "Compression Level") -or `
                 ($_ -eq "Compress")}
             {
             } # Compression Level
             
             # Verify Build
             {($_ -eq "V") -or `
                 ($_ -eq "Verify") -or `
                 ($_ -eq "Verify Build")}
             {
             } # Verify Build
             
             # Generate Report
             {($_ -eq "G") -or `
                 ($_ -eq "Generate Report") -or `
                 ($_ -eq "Report") -or `
                 ($_ -eq "             
             
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
 } # SettingsZip