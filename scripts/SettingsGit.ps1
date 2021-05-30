<# Settings - Git Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the ability for the user to configure
 #  how the program will interact with the user as well how the
 #  program will perform specific functionalities with the
 #  supporting technologies.
 #>




class SettingsGit
{
   <# Settings Git Menu Driver
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


        # Open the Git Settings
        #  Keep the user at the Git Settings Menu until they request to return
        #  back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Settings Git.
            [CommonCUI]::DrawSectionHeader("Git Settings");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Git Settings menu list to the user
            [SettingsGit]::DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequest($userInput);
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
                                "Browse for Git", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('U', `
                                "Update Source", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('S', `
                                "Size of Commit ID", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('H', `
                                "Retrieve History", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('L', `
                                "History Commit Size", `
                                "$($NULL)", `
                                $true);

        [CommonCUI]::DrawMenuItem('R', `
                                "Generate Report of Project Repository", `
                                "$($NULL)", `
                                $true);



        # Help Documentation
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
            # Browse for Git
            #  NOTE: Allow the user's request when they type: 'Browse for Git', 'Find Git',
            #           'Locate Git', 'Browse Git', as well as 'B'.
            {($_ -eq "B") -or `
                ($_ -eq "Browse for Git") -or `
                ($_ -eq "Find Git") -or `
                ($_ -eq "Locate Git") -or `
                ($_ -eq "Browse Git")}
            {
                # Allow the user to locate the path to Git or verify Git's path.
                [SettingsGit]::LocateGitPath()


                # Finished
                break;
            } # Browse for Git



            # Update Source
            #  NOTE: Allow the user's request when they type: 'Update Source', 'Update Project',
            #           'Update', as well as 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "Update") -or `
                ($_ -eq "Update Source") -or `
                ($_ -eq "Update Project")}
            {
                # Allow the user the ability to choose if they want to update the project's
                #  source files or not to update the project's files.
                [SettingsGit]::UpdateSource()


                # Finished
                break;
            } # Update Source



            # Length of the Commit SHA ID
            #  NOTE: Allow the user's request when they type: 'Size', 'Size of Commit ID',
            #           as well as 'S'.
            {($_ -eq "S") -or `
                ($_ -eq "Size") -or `
                ($_ -eq "Size of Commit ID")}
            {
                # Allow the user the ability to choose the size of the commit ID regarding the
                #  project's repository.
                [SettingsGit]::SizeCommitID()


                # Finished
                break;
            } # Size of Commit ID



            # History
            #  NOTE: Allow the user's request when they type: 'History', 'Changelog',
            #           as well as 'H'.
            {($_ -eq "H") -or `
                ($_ -eq "History") -or `
                ($_ -eq "Changelog")}
            {
                # Allow the ability for the user to specify if they wish to have the history
                #  changelog from the project's repository.
                [SettingsGit]::History()


                # Finished
                break;
            } # History



            # History Commit Size
            #  NOTE: Allow the user's request when they type: 'History Commit Size' or 'L'
            {($_ -eq "L") -or `
                ($_ -eq "History Commit Size")}
            {
                # Allow the user to change how many commits are to be recorded into the
                #  changelog history.
                [SettingsGit]::HistoryCommitSize()


                # Finished
                break;
            } # History Commit Size



            # Generate Report of Project's Repository
            #  NOTE: Allow the user's request when they type: 'Report', 'Generate Report',
            #           as well as 'R'.
            {($_ -eq "R") -or `
                ($_ -eq "Generate Report") -or `
                ($_ -eq "Report")}
            {
                # Allow the user the ability to request reports regarding the project's repository.
                [SettingsGit]::GenerateReport();


                # Finished
                break;
            } # Generate Report of Project's Repository



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





    #region Locate Git Path
    #                                     Locate Git Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Locate Git's Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the Git path, so that this
    #   program can be able to utilize Git's functionality and features.
    # -------------------------------
    #>
    hidden static [void] LocateGitPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Open the Locate Git Path Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Locate Git Path menu
            [CommonCUI]::DrawSectionHeader("Locate Git Path");


            # Provide the current Git path
            #  Determine how to present to the user that the path is valid or not.
            if ($gitControl.DetectGitExist())
            {
                # The path was found, so provide a nice message to the user - letting them know that
                #  the program can find the Git application.
                [Logging]::DisplayMessage("I can find the Git application within the following path:");
            } # if : Git Application was found

            # Display that the Git path is not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know that
                #  the program cannot find the Git application.
                [Logging]::DisplayMessage("I cannot find the Git application within the provided path:")
            } # Else: Git's path was not found


            # Output the project's path
            [Logging]::DisplayMessage("`t$($gitControl.GetExecutablePath())");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuLocateGitPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestLocateGitPath($userInput);
        } while ($menuLoop);
    } # LocateGitPath()




   <# Draw Menu: Locate Git Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate Git Path to the user.
    #   thus this provides what options are available to the user in order to configure the Git
    #   path.
    # -------------------------------
    #>
    hidden static [void] DrawMenuLocateGitPath()
    {
        # Display the Menu List

        # Automatically find Git
        [CommonCUI]::DrawMenuItem('A', `
                                "Automatically find Git", `
                                "Try to automatically find the Git Application.", `
                                $true);


        # Manually find Git
        [CommonCUI]::DrawMenuItem('M', `
                                "Manually find Git", `
                                "Manually locate the Git Application.", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuLocateGitPath()




   <# Evaluate and Execute User's Request: Locate Git Path
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
    hidden static [bool] EvaluateExecuteUserRequestLocateGitPath([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Automatically find Git
            #  NOTE: Allow the user's request when they type: 'Automatically find Git',
            #           'Automatically find', 'Automatically', 'Automatic', as well as 'A'.
            {($_ -eq "A") -or `
                ($_ -eq "Automatically find Git") -or `
                ($_ -eq "Automatically find") -or `
                ($_ -eq "Automatically") -or `
                ($_ -eq "Automatic")}
            {
                # Try to find the Git Application automatically.
                [SettingsGit]::LocateGitPathAutomatically();


                # Finished
                break;
            } # Automatically find Git



            # Manually find Git
            #  NOTE: Allow the user's request when they type: 'Manually find Git',
            #           'Manually', 'Manual', as well as 'M'.
            {($_ -eq "M") -or `
                ($_ -eq "Manually Find Git") -or `
                ($_ -eq "Manually") -or `
                ($_ -eq "Manual")}
            {
                # Find the Git Application manually
                [SettingsGit]::LocateGitPathManually();


                # Finished
                break;
            } # Manually find Git



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
    } # EvaluateExecuteUserRequestLocateGitPath()




   <# Configure Locate Git Path Automatically
    # -------------------------------
    # Documentation:
    #  This function will try to find the Git application automatically
    #   for the user.
    # -------------------------------
    #>
    hidden static [void] LocateGitPathAutomatically()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the results provided by the Git Finder.
        [string] $findGitResults = $null;

        # Instantiate the Git Object so that we may utilize the
        #  functions and properties as needed.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Capture the results from the finder
        $findGitResults = $gitControl.FindGit();


        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Now that we have the results from the finder, now determine
        #  if we were able to automatically detect the Git Application.
        if ($null -eq $findGitResults)
        {
            # Because we are unable to find Git automatically, there's
            #  really nothing that we can do.
            [Logging]::DisplayMessage("Unable to find the Git application!`r`nPlease be sure that it had been properly installed on your system!");
        } # If : Cannot Find Git Automatically


        # We were able to obtain a new location of where the Git Application resides within the system.
        else
        {
            # Because we were able to find the Git Application, we can use the new value.
            $gitControl.SetExecutablePath("$($findGitResults)");

            # Let the user know that we were able to successfully find the Git Application
            [Logging]::DisplayMessage("Successfully found the Git Application in:`r`n$($findGitResults)");
        } # Else: Found Git


        # Wait for the user to provide feedback; thus allowing the user to read the message.
        [logging]::GetUserEnterKey();
    } # LocateGitPathAutomatically()




   <# Configure Locate Git Path Manually
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to manually configure
    #   the path of the Git directory.
    # -------------------------------
    #>
    hidden static [void] LocateGitPathManually()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Git Path variable.
        [string] $newPath = $NULL;

        # We will use this instance so that we can apply the new location to the object.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine if the path that were provided is valid and can be used by the program.
        if ([CommonCUI]::BrowseForTargetFile([ref] $newPath))
        {
            # Because the path is valid, we will use the requested target directory.
            $gitControl.SetExecutablePath("$($newPath)");
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
    } # LocateGitPathManually()
    #endregion





    #region Update Source
    #                                     Update Source
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Update Source
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the Update Source functionality.
    #   With this setting, the program can try to update the project's source files to the latest
    #   commits from the remote master.
    # -------------------------------
    #>
    hidden static [void] UpdateSource()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Update Source Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Update Source variable, then make it easier
            #  for the user to understand the current setting.
            # Is the Program supposed to update the project's source files?
            if ($gitControl.GetUpdateSource())
            {
                # Set the message such that the user knows that this program will try to
                #  update the project's source files.
                $decipherNiceString = "I will try to update the project's source files when possible to the latest changes.";
            } # if : Update the Project's Source Files

            # The program is not supposed to update the project's source files
            else
            {
                # Set the message such that the user knows that this program will not try to update the project's source files.
                $decipherNiceString = "I will not update the project's source files."
            } # else : Do not Update the Project's Source Files


            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Update Source menu
            [CommonCUI]::DrawSectionHeader("Update Project Files");

            # Show to the user the current state of the Update Source presently set within the program
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuUpdateSource();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestUpdateSource($userInput);
        } while ($menuLoop);
    } # UpdateSource()




   <# Draw Menu: Update Source
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the Update Source Files
    #  functionality.
    # -------------------------------
    #>
    hidden static [void] DrawMenuUpdateSource()
    {
        # Display the Menu List

        # Enable the Update Source feature
        [CommonCUI]::DrawMenuItem('U', `
                                "Update Project's Source Files", `
                                "Update the project to the current changes available on the remote master server.", `
                                $true);


        # Disable the Update Source feature
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not Update Project's Source Files", `
                                "Do not update the project's source files with the latest changes made from the remote master server.", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuUpdateSource()




   <# Evaluate and Execute User's Request: Locate Git Path
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
    hidden static [bool] EvaluateExecuteUserRequestUpdateSource([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Allow the Project Source to be Updated
            #  NOTE: Allow the user's request when they type: 'Update', 'Update Project',
            #           as well as 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "Update") -or `
                ($_ -eq "Update Project")}
            {
                # Allow the ability to update the project' source files.
                $gitControl.SetUpdateSource($true);


                # Finished
                break;
            } # Update Source


            # Disallow the Project Source to be Updated
            #  NOTE: Allow the user's request when they type: 'Do not update', 'Do not Update Project',
            #           as well as 'N'.
            {($_ -eq "N") -or `
                ($_ -eq "Do not update") -or `
                ($_ -eq "Do not update Project")}
            {
                # Allow the ability to update the project' source files.
                $gitControl.SetUpdateSource($false);


                # Finished
                break;
            } # Do not Update Source


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
    } # EvaluateExecuteUserRequestUpdateSource()
    #endregion





    #region Size of Commit ID
    #                                     Size of Commit ID
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Size of Commit ID
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to alter the length of the Commit ID that is
    #   retrieved from the Git executable.
    # -------------------------------
    #>
    hidden static [void] SizeCommitID()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Size of Commit ID Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Size of Commit ID variable, then make it easier
            #  for the user to understand the current setting.
            switch ($gitControl.GetLengthCommitID())
            {
                "Short"
                {
                    # Set the message such that the user knows that the short Commit ID will be retrieved.
                    $decipherNiceString = "I will use the short Commit SHA ID";

                    # Finished
                    break;
                } # Short


                "Long"
                {
                    # Set the message such that the user knows that the long Commit ID will be retrieved.
                    $decipherNiceString = "I will use the long Commit SHA ID";

                    # Finished
                    break;
                } # Long
            } # Switch : Commit ID Size


            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Size of Commit ID menu
            [CommonCUI]::DrawSectionHeader("Commit ID Length");

            # Show to the user the current state of the Update Source presently set within the program
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuSizeCommitID();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestSizeCommitID($userInput);
        } while ($menuLoop);
    } # SizeCommitID()




   <# Draw Menu: Update Source
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the Length of
    #   the Commit ID retrieved from the Git Executable.
    # -------------------------------
    #>
    hidden static [void] DrawMenuSizeCommitID()
    {
        # Display the Menu List

        # Enable the Update Source feature
        [CommonCUI]::DrawMenuItem('S', `
                                "Short Commit SHA ID", `
                                "$($NULL)", `
                                $true);


        # Disable the Update Source feature
        [CommonCUI]::DrawMenuItem('L', `
                                "Long Commit SHA ID", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuSizeCommitID()




   <# Evaluate and Execute User's Request: Commit SHA ID Length
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
    hidden static [bool] EvaluateExecuteUserRequestSizeCommitID([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Provide the Short Commit ID
            #  NOTE: Allow the user's request when they type: "Short", "Small", "Short Commit SHA ID"
            #           as well as 'S'.
            {($_ -eq "S") -or `
                ($_ -eq "Short") -or `
                ($_ -eq "Small") -or `
                ($_ -eq "Short Commit SHA ID")}
            {
                # Only retrieve short Commit SHA ID's
                $gitControl.SetLengthCommitID([GitCommitLength]::short);

                # Finished
                break;
            } # Short Commit SHA ID


            # Provide the Long Commit ID
            #  NOTE: Allow the user's request when they type: "Long", "Large", "Long Commit SHA ID"
            #           as well as 'L'.
            {($_ -eq "L") -or `
                ($_ -eq "Long") -or `
                ($_ -eq "Large") -or `
                ($_ -eq "Lonmg Commit SHA ID")}
            {
                # Only retrieve Long Commit SHA ID's
                $gitControl.SetLengthCommitID([GitCommitLength]::long);

                # Finished
                break;
            } # Long Commit SHA ID



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
    } # EvaluateExecuteUserRequestSizeCommitID()
    #endregion





    #region History
    #                                     History
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# History
    # -------------------------------
    # Documentation:
    #  This function will allow the user to specify if they want the program to retrieve a list
    #   of history (or a changelog) regarding all or some of the changes that had occurred into
    #   the project's repository.
    # -------------------------------
    #>
    hidden static [void] History()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the History Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the History variable, then make it easier
            #  for the user to understand the current setting.
            # Obtain a history log
            if ($gitControl.GetFetchChangelog())
            {
                # Set the message such that the user knows that the History will be retrieved.
                $decipherNiceString = "I will retrieve a history changelog.";
            } # if : Retrieve History

            # Do not obtain history
            else
            {
                # Set the message such that the user knows that the History will not be obtained.
                $decipherNiceString = "I will not retrieve a history changelog.";
            } # else : Do not retrieve history


            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the History Changelog menu
            [CommonCUI]::DrawSectionHeader("History Changelog");

            # Show to the user the current state of the History Changelog presently set within the program
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuHistory();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestHistory($userInput);
        } while ($menuLoop);
    } # History()




   <# Draw Menu: History Changelog
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the ability
    #   to specify if the history changelog is to be retrieved from the project's repository.
    # -------------------------------
    #>
    hidden static [void] DrawMenuHistory()
    {
        # Display the Menu List

        # Retrieve the History Changelog
        [CommonCUI]::DrawMenuItem('H', `
                                "Retrieve History", `
                                "$($NULL)", `
                                $true);


        # Do not retrieve the History Changelog
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not Retrieve History", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuHistory()




   <# Evaluate and Execute User's Request: History Changelog
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
    hidden static [bool] EvaluateExecuteUserRequestHistory([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Obtain the History
            #  NOTE: Allow the user's request when they type: "Retrieve History", "Retrieve Changelog", "History"
            #           as well as 'H'.
            {($_ -eq "H") -or `
                ($_ -eq "Retrieve History") -or `
                ($_ -eq "Retrieve Changelog") -or `
                ($_ -eq "History")}
            {
                # Retrieve the history
                $gitControl.SetFetchChangelog($true);

                # Finished
                break;
            } # Obtain the History


            # Do not obtain the History
            #  NOTE: Allow the user's request when they type: "Do not retrieve History", "Do not tetrieve Changelog", as well as 'N'.
            {($_ -eq "N") -or `
                ($_ -eq "Do not retrieve History") -or `
                ($_ -eq "Do not retrieve Changelog")}
            {
                # Retrieve the history
                $gitControl.SetFetchChangelog($false);

                # Finished
                break;
            } # Do not obtain the History


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
    } # EvaluateExecuteUserRequestHistory()
    #endregion





    #region History Commit Size
    #                                     History Commit Size
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# History Commit Size
    # -------------------------------
    # Documentation:
    #  When the history (or changelog) is allowed to be retrieved, it is possible to specify how
    #   many commits (or changes) are to be recorded into the changelog file.
    # -------------------------------
    #>
    hidden static [void] HistoryCommitSize()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the History Commit Size Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current limit of how many commits are to be recorded in to the changelog file.
            $decipherNiceString = "I will retrieve $($gitControl.GetChangelogLimit()) changes.";


            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the History Commit Size menu
            [CommonCUI]::DrawSectionHeader("History Changelog Size Limit");

            # Show to the user the current state of the History Commit Size presently set within the program
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuHistoryCommitSize();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestHistoryCommitSize($userInput);
        } while ($menuLoop);
    } # History()




   <# Draw Menu: History Changelog Size
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the user the ability to change the History size
    #   limit or to leave the setting as is.
    # -------------------------------
    #>
    hidden static [void] DrawMenuHistoryCommitSize()
    {
        # Display the Menu List

        # Change the History Changelog Commit Size Limit
        [CommonCUI]::DrawMenuItem('C', `
                                "Change changelog size limit", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuHistoryCommitSize()




   <# Evaluate and Execute User's Request: History Changelog Limit
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
    hidden static [bool] EvaluateExecuteUserRequestHistoryCommitSize([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the History Size Limit
            #  NOTE: Allow the user's request when they type: "Change changelog size limit", "Size", as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change changelog size limit") -or `
                ($_ -eq "Size")}
            {
                # Retrieve the history
                [SettingsGit]::HistoryCommitSizeNewSize();

                # Finished
                break;
            } # Change History Commit Size


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
    } # EvaluateExecuteUserRequestHistoryCommitSize()




   <# Configure History Commit Size
    # -------------------------------
    # Documentation:
    #  This function will provide the user the ability to specify how many
    #   commits are to be recorded.
    # -------------------------------
    #>
    hidden static [void] HistoryCommitSizeNewSize()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the new number provided by the user's input.
        [int] $newSize = 0;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide a message to the user asking how many changes should be recorded.
        [Logging]::DisplayMessage("How many commits should be recorded? ");

        # Obtain the user's input
        $newSize = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

        # Make sure that the user did not provide 'Cancel' or 'X'; we do not want to
        #  store string\char values as an integer.
        if (("$($newSize)" -ne "Cancel") -and `
            ("$($newSize)" -ne "x"))
        {
            # Set the new size accordingly
            $gitControl.SetChangelogLimit($newSize);
        } # If : Cancel not Provided
    } # HistoryCommitSizeNewSize()
    #endregion





    #region Generate Report
    #                                        Generate Report
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Generate Report
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to request a report once the archive
    #   data file has been generated.
    # -------------------------------
    #>
    hidden static [void] GenerateReport()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Generate Report Menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Generate Report variable and make it nicer for the user to understand.
            #  Is the Generate Report presently enabled?
            if ($gitControl.GetGenerateReport())
            {
                # Generate Report is presently set as enabled.
                $decipherNiceString = "I will create a report regarding the project's repository.";
            } # if: Generate Report

            # Is the Generate Report presently disabled?
            else
            {
                # Generate Report is not presently set as enabled.
                $decipherNiceString = "I will not create a report regarding the project's repository.";
            } # else: Do not a Generate Report



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Generate Report menu
            [CommonCUI]::DrawSectionHeader("Generate Report");

            # Show the user the current state of the 'Generate Report' variable that is presently set within the program.
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::DrawMenuGenerateReport();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput("WaitingOnYourResponse");

            # Execute the user's request
            $menuLoop = [SettingsGit]::EvaluateExecuteUserRequestGenerateReport($userInput);
        } while ($menuLoop);
    } # GenerateReport()




   <# Draw Menu: Generate Report
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Generate Report.
    #   This provides the option if the user wants to have a report available for
    #   the compiled project build.
    # -------------------------------
    #>
    hidden static [void] DrawMenuGenerateReport()
    {
        # Display the Menu List

        # Generate a new report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('R', `
                                "Generate a report file", `
                                "Generate a new technical report regarding the project's repository.", `
                                $true);


        # Do not generate a new report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not generate a report file.", `
                                "Do not create a technical report regarding the project's repository.", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $true);
    } # DrawMenuGenerateReport()




   <# Evaluate and Execute User's Request: Generate Report
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
    hidden static [bool] EvaluateExecuteUserRequestGenerateReport([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Generate Report
            #  NOTE: Allow the user's request when they type: "Create reports", "Generate reports", "Make reports", as well as "R".
            {($_ -eq "R") -or `
                ($_ -eq "Create report") -or `
                ($_ -eq "Generate report") -or `
                ($_ -eq "Make report")}
            {
                # The user had selected to have technical reports generated regarding newly compiled project build.
                $gitControl.SetGenerateReport($true);

                # Finished
                break;
            } # Selected Generate Reports


            # Do not Generate Reports
            #  NOTE: Allow the user's request when they type: "Do not create reports", "do not generate reports", "Do not make reports", as well as "N".
            {($_ -eq "N") -or `
                ($_ -eq "Do not create reports") -or `
                ($_ -eq "do not generate reports") -or `
                ($_ -eq "Do not make reports")}
            {
                # The user had selected to not have technical reports generated regarding the newly compiled project builds.
                $gitControl.SetGenerateReport($false);

                # Finished
                break;
            } # Selected Do not Generate Reports


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
    } # EvaluateExecuteUserRequestGenerateReport()
    #endregion
} # SettingsGit