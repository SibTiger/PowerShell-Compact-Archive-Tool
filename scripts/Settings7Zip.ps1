<# Settings - 7Zip Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the ability for the user to configure
 #  how the program will interact with the user as well how the
 #  program will perform specific functionalities with the
 #  supporting technologies.
 #>




class Settings7Zip
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
            [Settings7Zip]::DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequest($userInput);
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
        [CommonCUI]::DrawMenuItem('B', "Browse for 7Zip", "$($NULL)");
        [CommonCUI]::DrawMenuItem('S', "Compression Method", "$($NULL)");
        [CommonCUI]::DrawMenuItem('Z', "Zip Algorithm", "$($NULL)");
        [CommonCUI]::DrawMenuItem('7', "7Zip Algorithm", "$($NULL)");
        [CommonCUI]::DrawMenuItem('M', "Multithreaded Operations", "$($NULL)");
        [CommonCUI]::DrawMenuItem('C', "Compression Level", "$($NULL)");
        [CommonCUI]::DrawMenuItem('V', "Verify Build after Compression", "$($NULL)");
        [CommonCUI]::DrawMenuItem('R', "Generate Report of Archive Datafile", "$($NULL)");



        # Program Tools
        [CommonCUI]::DrawMenuItem('?', "Help Documentation", "$($NULL)");


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', "Go back to Main Menu", "$($NULL)");


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
            # Browse for 7Zip
            #  NOTE: Allow the user's request when they type: 'Browse for 7Zip', 'Find 7Zip',
            #           'Locate 7Zip', 'Browse 7Zip', as well as 'B'.
            {($_ -eq "B") -or `
                ($_ -eq "Browse for 7Zip") -or `
                ($_ -eq "Find 7Zip") -or `
                ($_ -eq "Locate 7Zip") -or `
                ($_ -eq "Browse 7Zip")}
            {
                # Still working on this


                # Finished
                break;
            } # Browse for 7Zip



            # Compression Method
            #  NOTE: Allow the user's request when they type: 'Compression Method' and 'S'.
            {($_ -eq "S") -or `
                ($_ -eq "Compression Method")}
            {
                # Still working on this


                # Finished
                break;
            } # Compression Method



            # Zip Algorithm
            #  NOTE: Allow the user's request when they type: 'Zip Algorithm' and 'Z'.
            {($_ -eq "Z") -or `
                ($_ -eq "Zip Algorithm")}
            {
                # Still working on this


                # Finished
                break;
            } # Zip Algorithm



            # 7Zip Algorithm
            #  NOTE: Allow the user's request when they type: '7Zip Algorithm' and '7'.
            {($_ -eq "7") -or `
                ($_ -eq "7Zip Algorithm")}
            {
                # Still working on this


                # Finished
                break;
            } # 7Zip Algorithm



            # Multithreaded Operations
            #  NOTE: Allow the user's request when they type: 'Multithreaded Operations',
            #           'Multithread', as well as 'M'.
            {($_ -eq "M") -or `
                ($_ -eq "Multithreaded Operations") -or `
                ($_ -eq "Multithread")}
            {
                # Still working on this


                # Finished
                break;
            } # Multithreaded Operations



            # Compression Level
            #  NOTE: Allow the user's request when they type: 'Compression Level' and 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Compression Level")}
            {
                # Still working on this


                # Finished
                break;
            } # Compression Level



            # Verify Build after Compression
            #  NOTE: Allow the user's request when they type: 'Verify Build after Compression', 'Verify',
            #           'Verify Build', 'Test Build', 'Test', as well as 'V'.
            {($_ -eq "V") -or `
                ($_ -eq "Verify Build after Compression") -or `
                ($_ -eq "Verify") -or `
                ($_ -eq "Verify Build") -or `
                ($_ -eq "Test Build") -or `
                ($_ -eq "Test")}
            {
                # Still working on this


                # Finished
                break;
            } # Verify Build after Compression



            # Generate Report of Archive Datafile
            #  NOTE: Allow the user's request when they type: 'Report', 'Generate Report',
            #           'Generate Report of Archive Datafile', as well as 'R'.
            {($_ -eq "R") -or `
                ($_ -eq "Generate Report") -or `
                ($_ -eq "Report") -or `
                ($_ -eq "Generate Report of Archive Datafile")}
            {
                # Still working on this


                # Finished
                break;
            } # Generate Report of Archive Datafile



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
} # Settings7Zip