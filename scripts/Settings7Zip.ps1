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
   <# 7Zip Menu Driver
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

        # Open the 7Zip Settings
        #  Keep the user at the 7Zip Settings Menu until they request to return
        #  back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the 7Zip Menu.
            [CommonCUI]::DrawSectionHeader("7Zip Preferences");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the 7Zip menu list to the user
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
        [CommonCUI]::DrawMenuItem('B', `
                                "Browse for 7Zip", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('S', `
                                "Compression Method", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('Z', `
                                "Zip Algorithm", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('7', `
                                "7Zip Algorithm", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('M', `
                                "Multithreaded Operations", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('C', `
                                "Compression Level", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('V', `
                                "Verify Build after Compression", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('R', `
                                "Generate Report of Archive Datafile", `
                                "$($NULL)", `
                                $true);



        # Program Tools
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "$($NULL)", `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to Main Menu", `
                                "$($NULL)", `
                                $true);


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
                # Allow the user to locate the path to 7Zip or verify 7Zip's path.
                [Settings7Zip]::Locate7ZipPath()


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





    #region Locate 7Zip Path
    #                                     Locate 7Zip Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Locate 7Zip's Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the 7Zip path, so that this
    #   program can be able to utilize 7Zip's functionality and features.
    # -------------------------------
    #>
    hidden static [void] Locate7ZipPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------

        # Open the Locate 7Zip Path Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Locate 7Zip Path menu
            [CommonCUI]::DrawSectionHeader("Locate 7Zip Path");

            # Provide the current 7Zip path
            #  Determine how to present to the user that the path is valid or not.
            if ([CommonIO]::CheckPathExists("$($sevenZip.GetExecutablePath())", $true))
            {
                # The path was found, so provide a nice message to the user - letting them know that
                #  the program can find the 7Zip application.
                [Logging]::DisplayMessage("I can find the 7Zip application within the following path:");
            } # if : 7Zip Application was found

            # Display that the 7Zip path is not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know that
                #  the program cannot find the 7Zip application.
                [Logging]::DisplayMessage("I cannot find the 7Zip application within the provided path:")
            } # Else: 7Zip's path was not found

            # Output the project's path
            [Logging]::DisplayMessage("`t$($sevenZip.GetExecutablePath())");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuLocate7ZipPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestLocate7ZipPath($userInput);
        } while ($menuLoop);
    } # Locate7ZipPath()




   <# Draw Menu: Locate 7Zip Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate 7Zip Path to the user.
    #   thus this provides what options are available to the user in order to configure the 7Zip
    #   path.
    # -------------------------------
    #>
    hidden static [void] DrawMenuLocate7ZipPath()
    {
        # Display the Menu List

        # Change the 7Zip Path
        [CommonCUI]::DrawMenuItem('C', `
                                "Change Path", `
                                "Locate the directory that contains the 7Zip application.", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuLocate7ZipPath()




   <# Evaluate and Execute User's Request: Locate 7Zip Path
    # -------------------------------
    # Documentation:
    #  This function will evaluate and execute the user's desired request in respect to
    #   the menu options that were provided to them.
    # -------------------------------
    # Input:
    #  [string] User's Request
    #   This will provide the user's desired request to run an operation or to access
    #    a specific functionality.
    # -------------------------------
    # Output:
    #  [bool] User Stays at Menu
    #   This defines if the user is to remain at the Menu screen.
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] EvaluateExecuteUserRequestLocate7ZipPath([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the 7Zip Path
            #  NOTE: Allow the user's request when they type: 'Change Path', 'Change',
            #           'Update Path', 'Update', as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change Path") -or `
                ($_ -eq "Change") -or `
                ($_ -eq "Update Path") -or `
                ($_ -eq "Update")}
            {
                # Configure the path of the 7Zip directory.
                [Settings7Zip]::Locate7ZipPathNewPath();


                # Finished
                break;
            } # Change Path


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
    } # EvaluateExecuteUserRequestLocate7ZipPath()




   <# Configure Locate 7Zip Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the 7Zip directory.
    # -------------------------------
    #>
    hidden static [void] Locate7ZipPathNewPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  7Zip Path variable.
        [string] $newPath = $NULL;

        # We will use this instance so that we can apply the new location to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine if the path that were provided is valid and can be used by the program.
        if ([CommonCUI]::BrowseForTargetFile([ref] $newPath))
        {
            # Because the path is valid, we will use the requested target directory.
            $sevenZip.SetExecutablePath("$($newPath)");
        } # if: Path is valid

        # The provided path is not valid
        else
        {
            # If the user provided "Cancel" or "X", then do not bother the user with an error message.
            #  Otherwise, provide an error message as the path is incorrect.
            if (("$($newPath)" -ne "Cancel") -and `
                ("$($newPath)" -ne "x"))
            {
                # Because the path is not valid, let the user know that the path does not exist
                #  and will not be used.
                [Logging]::DisplayMessage("`r`n" + `
                                        "The provided path does not exist and cannot be used." + `
                                        "`r`n`r`n");


                # Wait for the user to provide feedback; thus allowing the user to see the message.
                [Logging]::GetUserEnterKey();
            } # if : User Provided incorrect path
        } # else : Path is invalid
    } # Locate7ZipPathNewPath()
    #endregion
} # Settings7Zip