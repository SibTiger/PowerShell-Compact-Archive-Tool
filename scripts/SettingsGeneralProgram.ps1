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

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequest($userInput);
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
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the user's preferences
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();


        # Here are some variables that are used to help the user to understand the
        #  meaning behind a particular setting.  Thus, instead of saying "True" or
        #  an enumerator value that is not easy to decipher, we can break it down in
        #  a way that it is easier to convey the point across to the user.
        [string] $currentSettingCompressionTool = $NULL;    # Compression Tool
        [string] $currentSettingGitFeatures = $NULL;        # Git Features
        [string] $currentSettingWindowsExplorer = $NULL;    # Windows Explorer
        [string] $currentSettingNotification = $NULL;       # Notifications

        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuCompressionTool = $true;            # Compression Tool
        [bool] $showMenuGitFeatures = $true;                # Git Features
        [bool] $showMenuWindowsFeatures = $true;            # Windows Features
        # ----------------------------------------


        # Retrieve the current settings and determine the wording before we generate the menu.
        [SettingsGeneralProgram]::DrawMenuDecipherCurrentSettings([ref] $currentSettingCompressionTool, `
                                                                [ref] $currentSettingGitFeatures, `
                                                                [ref] $currentSettingWindowsExplorer, `
                                                                [ref] $currentSettingNotification); `


        # Determine what menus are to be displayed to the user.
        [SettingsGeneralProgram]::DrawMenuDetermineHiddenMenus([ref] $showMenuCompressionTool, `    # Compression Tool
                                                                [ref] $showMenuGitFeatures, `       # Git Features
                                                                [ref] $showMenuWindowsFeatures);    # Windows Features



        # Display the menu list

        # Paths
        # - - - - - - -
        # Find Project Path
        [CommonCUI]::DrawMenuItem('P', `
                                "Locate Project Path", `
                                "The directory that contains the $([ProjectInformation]::projectName) ($([ProjectInformation]::codeName)) project files", `
                                "Project is located at: $($userPreferences.GetProjectPath())", `
                                $true);

        # Specify Output Path
        [CommonCUI]::DrawMenuItem('O', `
                                "Compiled Builds Output Path", `
                                "The directory that will contain all of the compiled builds generated by the $($GLOBAL:_PROGRAMNAME_).", `
                                "Compiled Builds are located at: $($userPreferences.GetProjectBuildsPath())", `
                                $true);



        # Tools and Features
        # - - - - - - -
        # Specify Compression Tool
        if ($showMenuCompressionTool)
        {
            [CommonCUI]::DrawMenuItem('C', `
                                    "Compression Tool", `
                                    "Provides the ability to use a specific compression software to compile the $([ProjectInformation]::projectName) project files.", `
                                    "Desired Compression Tool to use: $($currentSettingCompressionTool)", `
                                    $true);
        } # if: Show Compression Tool

        # Allow or disallow Git Functionality
        if ($showMenuGitFeatures)
        {
            [CommonCUI]::DrawMenuItem('G', `
                                    "Git Features", `
                                    "Utilize Git's unique features during compiling the $([ProjectInformation]::projectName) project", `
                                    "Ability to use Git Features is currently: $($currentSettingGitFeatures)", `
                                    $true);
        } # if: Show Git Features

        # Enable or disable the use of Windows Explorer features
        if ($showMenuWindowsFeatures)
        {
            [CommonCUI]::DrawMenuItem('E', `
                                    "Graphical User Interface Features", `
                                    "Utilize Windows Explorer features where possible [Windows Only]", `
                                    "Ability to use Windows Explorer: $($currentSettingWindowsExplorer)", `
                                    $true);
        } # if: Show Windows Features

        # Notifications
        [CommonCUI]::DrawMenuItem('N', `
                                "Notifications", `
                                "The ability for $($GLOBAL:_PROGRAMNAME_) to notify you of certain events.", `
                                "Notifications are currently set to: $($currentSettingNotification)", `
                                $true);



        # Help Documentation
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online", `
                                $NULL, `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to previous menu", `
                                $NULL, `
                                $NULL, `
                                $false);
    } # DrawMenu()




   <# Draw Menu: Decipher Current Settings
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the current settings to the desired
    #   user's preferences in a way that it is to be drawn onto the menu.  The
    #   settings, either as boolean or enumerators, will be translated such that
    #   the user can easily see the current value and make a determination if
    #   they wish to alter their settings.
    # -------------------------------
    # Input:
    #  [string] (REFERENCE) Compression Tool
    #   Determines which compression tool had been selected for compacting files.
    #  [string] (REFERENCE) Git Features
    #   Determines if the program is to use Git Features or not.
    #  [string] (REFERENCE) Windows Explorer
    #   Determines if the program will use Windows Explorer features or not.
    #  [string] (REFERENCE) Notification Type
    #   Determines how the notifications will be brought to the user's focus.
    # -------------------------------
    #>
    hidden static [void] DrawMenuDecipherCurrentSettings([ref] $compressionTool, `  # Desired Compression Tool
                                                        [ref] $gitFeatures, `       # Git Features
                                                        [ref] $windowsExplorer, `   # Windows Explorer Features
                                                        [ref] $notification)        # Notification Type
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the user's preferences
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Compression Tool
        switch ($userPreferences.GetCompressionTool())
        {
            # dotNET Zip Archive (Built-in functionality)
            ([UserPreferencesCompressTool]::InternalZip)
            {
                # Set the string that will be displayed
                $compressionTool.Value = "Internal Zip";

                # Break from the switch
                break;
            } # InternalZip


            # 7Zip (External resource)
            ([UserPreferencesCompressTool]::SevenZip)
            {
                # Set the string that will be displayed
                $compressionTool.Value = "7Zip";

                # Break from the switch
                break;
            } # 7Zip


            # Unknown case
            Default
            {
                # Set the string that will be displayed
                $compressionTool.Value = "ERROR";

                # Break from the switch
                break;
            } # Error Case
        } # Switch : Decipher Enumerator Value



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Git Features
        # Git Features are enabled
        if ($userPreferences.GetUseGitFeatures())
        {
            # The user currently has the Git Features presently activated
            $gitFeatures.Value = "On";
        } # if: Git Features are enabled

        # Git features are not enabled
        else
        {
            # The user currently has the Git Features presently deactivated
            $gitFeatures.Value = "Off";
        } # else: Git Features are disabled



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Windows Explorer
        # Windows Explorer are enabled
        if ($userPreferences.GetUseWindowsExplorer())
        {
            # The user currently has the Windows Explorer functionality presently activated
            $windowsExplorer.Value = "On";
        } # if: Windows Explorer are enabled

        # Windows Explorer are not enabled
        else
        {
            # The user currently has the Windows Explorer presently deactivated
            $windowsExplorer.Value = "Off";
        } # else: Windows Explorer are disabled



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Notification Types
        switch ($userPreferences.GetBellEvents())
        {
            ([UserPreferencesEventAlarm]::Everything)
            {
                # Set the message such that the user knows that 'everything' is presently activated.
                $notification.Value = "Everything";

                # Finished
                break;
            } # Everything


            ([UserPreferencesEventAlarm]::Success)
            {
                # Set the message such that the user knows that 'success' is presently activated.
                $notification.Value = "Successful Operations";

                # Finished
                break;
            } # Success


            ([UserPreferencesEventAlarm]::Errors)
            {
                # Set the message such that the user knows that 'errors' is presently activated.
                $notification.Value = "Errors only";

                # Finished
                break;
            } # Errors


            ([UserPreferencesEventAlarm]::Warnings)
            {
                # Set the message such that the user knows that 'Warnings' is presently activated.
                $notification.Value = "Warnings only";

                # Finished
                break;
            } # Warnings


            ([UserPreferencesEventAlarm]::Disable)
            {
                # Set the message such that the user knows that 'Disable' is presently activated.
                $notification.Value = "Disabled";

                # Finished
                break;
            } # Disable
        } # Switch: Decipher Notification Type
    } # DrawMenuDecipherCurrentSettings()




   <# Draw Menu: Determine Hidden Menus
    # -------------------------------
    # Documentation:
    #  This function will determine what menus and options are to be displayed
    #   to the user.  Menus can be considered hidden if a particular setting,
    #   feature, or environment is not available to the user or is not considered
    #   ready to be used.  This can happen if a parent feature had been disabled,
    #   thus causes a sub-feature to be hidden from the user.
    #  This helps to declutter the menu screen by hiding sub-menus from the user
    #   in-which have no effect as the main feature is disabled or configured in
    #   a way that has no real effect.
    # -------------------------------
    # Input:
    #  [bool] (REFERENCE) Compression Tool
    #   User provides their preferred Compression Tool softwar.e
    #  [bool] (REFERENCE) Use Git Features
    #   Provides the ability to allow the use of Git Features.
    #  [bool] (REFERENCE) Use Windows Features
    #   Provides the ability to use Windows specific Features, where available.
    # -------------------------------
    #>
    hidden static [void] DrawMenuDetermineHiddenMenus([ref] $showMenuCompressionTool, `     # Compression Tool
                                                    [ref] $showMenuGitFeatures, `           # Git Features
                                                    [ref] $showMenuWindowsFeatures)         # Windows Features
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the User Preferences object
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Show Menu: Compression Tool
        #  Show the Compression Tool if the following conditions are true:
        #   - Found dotNET Zip Archive
        #   - Found 7Zip
        #   OR
        #   - Show Hidden Menus
        if(([CommonFunctions]::IsAvailableZip() -and [CommonFunctions]::IsAvailable7Zip()) -or `
            $userPreferences.GetShowHiddenMenu())
        {
            $showMenuCompressionTool.Value = $true;
        } # If: Compression Tool is Visible

        # Compression Tool is hidden
        else
        {
            $showMenuCompressionTool.Value = $false;
        } # Else: Compression Tool is hidden




        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -




        # Show Menu: Git Features
        #  Show the Git Features if the following conditions are true:
        #   - Found Git
        #   OR
        #   - Show Hidden Menus
        if ([CommonFunctions]::IsAvailableGit() -or $userPreferences.GetShowHiddenMenu())
        {
            $showMenuGitFeatures.Value = $true;
        } # If: Git Features is Visible

        # Git Features is hidden
        else
        {
            $showMenuGitFeatures.Value = $false;
        } # Else: Git Features is Hidden




        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -




        # Show Menu: Windows Features
        #  Show the Windows Features if the following conditions are true:
        #   - Operating System is Windows
        #   OR
        #   - Show Hidden Menus
        if (([SystemInformation]::OperatingSystem() -eq [SystemInformationOperatingSystem]::Windows) -or `
            $userPreferences.GetShowHiddenMenu())
        {
            $showMenuWindowsFeatures.Value = $true;
        } # If: Windows Features is Visible

        # Windows Features is hidden
        else
        {
            $showMenuWindowsFeatures.Value = $false;
        } # Else: Windows Features is Hidden
    } # DrawMenuDetermineHiddenMenus()




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
        # Declarations and Initializations
        # ----------------------------------------
        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuCompressionTool = $true;            # Compression Tool
        [bool] $showMenuGitFeatures = $true;                # Git Features
        [bool] $showMenuWindowsFeatures = $true;            # Windows Features
        # ----------------------------------------


        # Determine what menus are to be displayed to the user.
        [SettingsGeneralProgram]::DrawMenuDetermineHiddenMenus([ref] $showMenuCompressionTool, `    # Compression Tool
                                                                [ref] $showMenuGitFeatures, `       # Git Features
                                                                [ref] $showMenuWindowsFeatures);    # Windows Features



        # Evaluate the user's request
        switch ($userRequest)
        {
            # Locate the Project Path
            #  NOTE: Allow the user's request when they type: 'Locate Project'
            #           'Locate Project Path', as well as 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "Locate Project Path") -or `
                ($_ -eq "Locate Project")}
            {
                # Allow the user to update or verify the project path.
                [SettingsGeneralProgram]::LocateProjectPath();


                # Finished
                break;
            } # Locate the Project Path



            # Compiled Builds Output Path
            #  NOTE: Allow the user's request when they type: 'Compiled Builds Output Path',
            #           'Builds Output Path', 'Output Path', 'Compiled Output Path', as well as 'O'.
            {($_ -eq "O") -or `
                ($_ -eq "Compiled Builds Output Path") -or `
                ($_ -eq "Builds Output Path") -or `
                ($_ -eq "Output Path") -or `
                ($_ -eq "Compiled Output Path")}
            {
                # Allow the user to specify where the output\compiled builds are to be placed after
                #  being generated.
                [SettingsGeneralProgram]::CompiledBuildsOutputPath();


                # Finished
                break;
            } # Compiled Builds Output Path



            # Compression Tool
            #  NOTE: Allow the user's request when they type: 'Compression Tool', 'Compression',
            #           as well as 'C'.
            {($showMenuCompressionTool) -and `
                (($_ -eq "C") -or `
                 ($_ -eq "Compression Tool") -or `
                 ($_ -eq "Compression"))}
            {
                # Allow the user to specify their desired compression tool that the program will use
                #  while generating archive data files.
                [SettingsGeneralProgram]::CompressionTool();


                # Finished
                break;
            } # Compression Tool



            # Git Features
            #  NOTE: Allow the user's request when they type: 'Git Features', 'Git',
            #           as well as 'G'.
            {($showMenuGitFeatures) -and `
                (($_ -eq "G") -or `
                 ($_ -eq "Git Features") -or `
                 ($_ -eq "Git"))}
            {
                # Allow the user to configure the state of the Use Git Features variable, thus giving
                #  them the ability to use or not use Git Features while compiling the project.
                [SettingsGeneralProgram]::UseGitFeatures();


                # Finished
                break;
            } # Git Features



            # Graphical User Interface Features
            #  NOTE: Allow the user's request when they type: 'Graphical User Interface Features',
            #           'GUI Features', as well as 'E'.
            {($showMenuWindowsFeatures) -and `
                (($_ -eq "E") -or `
                 ($_ -eq "Graphical User Interface Features") -or `
                 ($_ -eq "GUI Features"))}
            {
                # Allow the user to configure the state of the Use Windows Explorer variable, thus giving
                #  the user the ability to benefit - if chosen so - of using Windows Explorer functionality.
                [SettingsGeneralProgram]::UseWindowsExplorer();


                # Finished
                break;
            } # Graphical User Interface Features



            # Notifications
            #  NOTE: Allow the user's request when they type: 'Notifications', 'Notify', and 'N'.
            {($_ -eq "N") -or `
                ($_ -eq "Notifications") -or `
                ($_ -eq "Notify")}
            {
                # Allow the user the ability to customize the notifications in which this program may
                #  provide based on certain events and operations.
                [SettingsGeneralProgram]::NotificationTypes();


                # Finished
                break;
            } # Notifications



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
                [WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,                    ` # Project's Repository
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





    #region Locate Project Path
    #                                    Locate Project Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize the Project Path, so that this program
    #   can perform compact the project as expected.
    # -------------------------------
    #>
    hidden static [void] LocateProjectPath()
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
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Open the Locate Project Path Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Locate Project Path
            [CommonCUI]::DrawSectionHeader("Locate Project Path");


            # Provide the current project path
            #  Determine how to present to the user that the path is valid or not.
            if ([CommonIO]::CheckPathExists($userPreferences.GetProjectPath(), $true))
            {
                # The path was found, so provide a nice message to the user - letting them know
                #  that the program can find the project files.
                [Logging]::DisplayMessage("I can find the $($GLOBAL:projectName) Project files within the following path:");
            } # if: Project Path was Found

            # Display that the path is not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know
                #  that the program cannot find the project files.
                [Logging]::DisplayMessage("I cannot find the $($GLOBAL:projectName) Project files within the following path:");
            } # else: Project Path was Not Found


            # Output the project's path
            [Logging]::DisplayMessage("`t$($userPreferences.GetProjectPath())");

            # Provide some extra whitespacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuLocateProjectPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestLocateProjectPath($userInput);
        } while ($menuLoop);
    } # LocateProjectPath()




   <# Draw Menu: Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate Project Path to the user.
    #   Thus this provides what options are available to the user in order to configure the
    #   project path.
    # -------------------------------
    #>
    hidden static [void] DrawMenuLocateProjectPath()
    {
        # Display the Menu List

        # Change the Project Path
        [CommonCUI]::DrawMenuItem('C', `
                                "Change Path", `
                                "Locate the directory that contains that $([ProjectInformation]::projectName) source files." , `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $false);
    } # DrawMenuLocateProjectPath()




   <# Evaluate and Execute User's Request: Locate Project Path
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
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] EvaluateExecuteUserRequestLocateProjectPath([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the Project Path
            #  NOTE: Allow the user's request when they type: 'Change Path', 'Change',
            #           'Update Path', 'Update', as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change Path") -or `
                ($_ -eq "Change") -or `
                ($_ -eq "Update Path") -or `
                ($_ -eq "Update")}
            {
                # Configure the path of the project source directory.
                [SettingsGeneralProgram]::LocateProjectPathNewPath();


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
    } # EvaluateExecuteUserRequestLocateProjectPath()




   <# Configure Locate Project Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the Project source directory.
    # -------------------------------
    #>
    hidden static [void] LocateProjectPathNewPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Project Path variable.
        [string] $newProjectPath = $NULL;

        # We will use this instance so that we can apply the new location to the project.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");



        # Determine if the path that were provided is valid and can be used by the program.
        if ([CommonCUI]::BrowseForTargetFile([ref] $newProjectPath))
        {
            # Because the path is valid, we will use the requested target directory.
            $userPreferences.SetProjectPath($newProjectPath);
        } # if: Path is valid

        # The provided path is not valid
        else
        {
            # If the user provided "Cancel" or "X", then do not bother the user with an error message.
            #  Otherwise, provide an error message as the path is incorrect.
            if (($newProjectPath -ne "Cancel") -and `
                ($newProjectPath -ne "x"))
            {
                # Because the path is not valid, let the user know that the path does not exist
                #  and will not be used as part of the project directory.
                [Logging]::DisplayMessage("`r`n" + `
                                        "The provided path does not exist and cannot be used as the Project Directory." + `
                                        "`r`n`r`n");


                # Wait for the user to provide feedback; thus allowing the user to see the message.
                [Logging]::GetUserEnterKey();
            } # if : User Provided incorrect path
        } # else : Path is invalid
    } # LocateProjectPathNewPath()
    #endregion





    #region Compiled Builds Output Path
    #                                Compiled Builds Output Path
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will allow the ability for the user to customize the Output Path, in which will
    #   hold all compiled builds generated by this program.
    # -------------------------------
    #>
    hidden static [void] CompiledBuildsOutputPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $NULL;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Open the Compiled Build Output Path Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user tha3t they are at the Compiled Builds Output Path
            [CommonCUI]::DrawSectionHeader("Compiled Builds Output Path");


            # Provide the current output path
            #  Determine how to present to the user that the path is valid or not.
            if ([CommonIO]::CheckPathExists($userPreferences.GetProjectBuildsPath(), $true))
            {
                # The path waws found, so provide a nice message to the user - letting them know
                #  that the program can find the output path.
                [Logging]::DisplayMessage("I can find the Compiled Builds Output Path directory:");
            } # if: Found the Compiled Builds Output Directory

            # Display that the4 path was not valid
            else
            {
                # The path was not found, so provide a nice message to the user - letting them know
                #  That the program cannot find the compiled builds output directory.
                [Logging]::DisplayMessage("I cannot find the Compiled Builds Output Path directory:");
            } # else: Compiled Builds Output Path was Not Found


            # Display the Compiled Build Output Path
            [Logging]::DisplayMessage("`t$($userPreferences.GetProjectBuildsPath())");

            # Provide some extra whitespacing so that it is easier to read for the user.
            [Logging]::DisplayMessage("`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuCompiledBuildsOutputPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestCompiledBuildsOutputPath($userInput);
        } while ($menuLoop);
    } # CompiledBuildsOutputPath()




   <# Draw Menu: Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compiled Builds Output Path to the user.
    #   Thus this provides what options are available to the user in order to configure the
    #   Output path.
    # -------------------------------
    #>
    hidden static [void] DrawMenuCompiledBuildsOutputPath()
    {
        # Display the Menu List

        # Change the Compiled Builds Output Path
        [CommonCUI]::DrawMenuItem('C', `
                                "Change Path", `
                                "Specify a new directory that will contain newly compiled builds generated by the $($GLOBAL:_PROGRAMNAMESHORT_) program.", `
                                $NULL, `
                                $true);

        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $false);
    } # DrawMenuCompiledBuildsOutputPath()




   <# Evaluate and Execute User's Request: Compiled Builds Output Path
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
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] EvaluateExecuteUserRequestCompiledBuildsOutputPath([string] $userInput)
    {
        # Evaluate the user's request
        switch ($userInput)
        {
            # Change the Compiled Builds Output Path
            #  NOTE: Allow the user's request when they type: 'Change Path', 'Change',
            #           'Update Path', 'Update', as well as 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Change Path") -or `
                ($_ -eq "Change") -or `
                ($_ -eq "Update Path") -or `
                ($_ -eq "Update")}
            {
                # Configure the path of the project source directory.
                [SettingsGeneralProgram]::CompiledBuildsOutputPathNewPath();


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
    } # EvaluateExecuteUserRequestCompiledBuildsOutputPath()




   <# Configure Compiled Builds Output Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to configure the path of
    #   the Compiled Builds Output directory.
    # -------------------------------
    #>
    hidden static [void] CompiledBuildsOutputPathNewPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Compiled Builds Output Path variable.
        [string] $newProjectPath = $NULL;

        # We will use this instance so that we can apply the new location to the Compiled
        #  Builds Output Path.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");



        # Determine if the path that were provided is valid and can be used by the program.
        if ([CommonCUI]::BrowseForTargetFile([ref] $newProjectPath))
        {
            # Because the path is valid, we will use the requested target directory.
            $userPreferences.SetProjectBuildsPath($newProjectPath);
        } # if: Path is Valid

        # The provided path is not valid
        else
        {
            # If the user provided "Cancel" or "X", then do not bother the user with an error message.
            #  Otherwise, provide an error message as the path is incorrect.
            if (($newProjectPath -ne "Cancel") -and `
                ($newProjectPath -ne "x"))
            {
                # Because the path is not valid, let the user know that the path does not exist
                #  and will not be used as part of the Compiled Builds Output directory.
                [Logging]::DisplayMessage("`r`n" + `
                                        "The provided path does not exist and cannot be used as the Compiled Builds Output Directory." + `
                                        "`r`n`r`n");


                # Wait for the user to provide feedback; thus allowing the user to see the message.
                [Logging]::GetUserEnterKey();
            } # if : User Provided incorrect path
        } # else : Path is invalid
    } # CompiledBuildsOutputPathNewPath()
    #endregion





    #region Compression Tool
    #                                     Compression Tool
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compression Tool
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to customize which compression tool that
    #   will be utilized by this program.
    # -------------------------------
    #>
    hidden static [void] CompressionTool()
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
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();

        # We will use this string so that the user can understand the meaning of the enumerator value.
        #  Generally speaking, the enumerator - while is a simple string, it is not meant to be displayed
        #  as-is to the user.  thus, we will have to translate the meaning so the user knows the meaning
        # behind the value.
        [string] $selectedCompressionTool = $null;
        # ----------------------------------------


        # Open the Compression Tool Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Determine the value of the selected compression tool and translate it so that the user
            #  can understand the value.  Otherwise, it may confuse the user as they try to decipher
            #  the meaning of the enumerator value as-is.
            switch ($userPreferences.GetCompressionTool())
            {
                # dotNET Zip Archive (Built-in functionality)
                ([UserPreferencesCompressTool]::InternalZip)
                {
                    # Set the string that will be displayed
                    $selectedCompressionTool = "Internal Zip";

                    # Break from the switch
                    break;
                } # InternalZip


                # 7Zip (External resource)
                ([UserPreferencesCompressTool]::SevenZip)
                {
                    # Set the string that will be displayed
                    $selectedCompressionTool = "7Zip";

                    # Break from the switch
                    break;
                } # 7Zip


                # Unknown case
                Default
                {
                    # Set the string that will be displayed
                    $selectedCompressionTool = "ERROR";

                    # Break from the switch
                    break;
                } # Error Case
            } # Switch : Translate Enumerator Value



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Compression Tool
            [CommonCUI]::DrawSectionHeader("Compression Tool");

            # Show to the user which Compression Tool is presently selected within the program.
            [Logging]::DisplayMessage("I will use $($selectedCompressionTool) for compacting project files.");

            #Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuCompressionTool();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestCompressionTool($userInput);
        } while ($menuLoop);
    } # CompressionTool()




   <# Draw Menu: Compression Tool
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Tool to the user.
    #   Thus this provides what options are available to the user in order to configure what
    #   compression tool that will be utilized by the program.
    # -------------------------------
    #>
    hidden static [void] DrawMenuCompressionTool()
    {
        # Display the Menu List

        # Use the Internal Zip support (this is from the .NET Core)
        [CommonCUI]::DrawMenuItem('Z', `
                                "Internal Zip", `
                                "Use the built-in Zip functionality to create ZDoom PK3 WAD files.", `
                                $NULL, `
                                $true);


        # Use the 7Zip support (User must already have this installed)
        [CommonCUI]::DrawMenuItem('7', `
                                "7Zip", `
                                "When available, use 7Zip's functionality to create ZDoom PK3 or PK7 WAD files.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # DrawMenuCompressionTool()




   <# Evaluate and Execute User's Request: Compression Tool
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
    #       $true  = User is to remain at the Menu.
    #       $false = User requested to leave the Menu.
    # -------------------------------
    #>
    hidden static [bool] EvaluateExecuteUserRequestCompressionTool([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Internal Zip (.NET Core)
            #  NOTE: Allow the user's request when they type: "Internal Zip", "Zip", "Default"
            #           as well as 'Z'.
            {($_ -eq "Z") -or `
                ($_ -eq "Internal Zip") -or `
                ($_ -eq "Zip") -or `
                ($_ -eq "Default")}
            {
                # The user had selected to use the Internal Zip Compression Tool.
                $userPreferences.SetCompressionTool([UserPreferencesCompressTool]::InternalZip);

                # Finished
                break;
            } # Selected Internal Zip



            # 7Zip (External Tool; yet extremely handy and widely used)
            #  NOTE: Allow the user's request when they type: "7Zip", "7Z", as well as "7"
            {($_ -eq "7") -or `
                ($_ -eq "7Zip") -or `
                ($_ -eq "7Z")}
            {
                # The user had selected to use the 7Zip Compression Tool.
                $userPreferences.SetCompressionTool([UserPreferencesCompressTool]::SevenZip);

                # Finished
                break;
            } # Selected 7Zip



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
    } # EvaluateExecuteUserRequestCompressionTool()
    #endregion





    #region Use Git Features
    #                                     Use Git Features
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Use Git Features
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to determine if they wish to utilize Git
    #   features and functionality while generating their builds with this program.
    # -------------------------------
    #>
    hidden static [void] UseGitFeatures()
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
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $useGitFeatureNiceString = $null;
        # ----------------------------------------


        # Open the Use Git Features Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Determine the current state of the Use Git Features variable and make it nicer for the user to understand.
            if ($userPreferences.GetUseGitFeatures())
            {
                # The user currently has the Git Features presently activated
                $useGitFeatureNiceString = "I will use Git features while managing and compacting the project files.";
            } # if: Git Features are enabled

            # Git features are not enabled
            else
            {
                # The user currently has the Git Features presently deactivated
                $useGitFeatureNiceString = "I will not use any Git features while managing and compacting the project files.";
            } # else: Git Features are disabled



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Git Features
            [CommonCUI]::DrawSectionHeader("Git Features");

            # Show to the user the current state of the 'Use Git Features' variable that is presently set within the program.
            [Logging]::DisplayMessage($useGitFeatureNiceString);

            #Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuUseGitFeatures();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestUseGitFeatures($userInput);
        } while ($menuLoop);
    } # UseGitFeatures()




   <# Draw Menu: Use Git Features
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Use Git Features functionality
    #   to the user.  Thus, this provides what options are available to the user in order to
    #   configure the Git Features state for the program.
    # -------------------------------
    #>
    hidden static [void] DrawMenuUseGitFeatures()
    {
        # Display the Menu List

        # Allow the ability to utilize Git Features where available
        [CommonCUI]::DrawMenuItem('E', `
                                "Enable", `
                                "Allow the ability to utilize Git features within the program automatically.", `
                                $NULL, `
                                $true);


        # Disallow the ability to utilize Git Features within the program.
        [CommonCUI]::DrawMenuItem('D', `
                                "Disable", `
                                "Do not use any Git features within the program.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # DrawMenuUseGitFeatures()




   <# Evaluate and Execute User's Request: Use Git Features
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
    hidden static [bool] EvaluateExecuteUserRequestUseGitFeatures([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Allow Git Features
            #  NOTE: Allow the user's request when they type: "True", "T", "On", as well as "E".
            {($_ -eq "E") -or `
                ($_ -eq "On") -or `
                ($_ -eq "T") -or `
                ($_ -eq "True")}
            {
                # The user had selected to enable the utilization of Git Features and Functionality
                #  within the program.
                $userPreferences.SetUseGitFeatures($true);

                # Finished
                break;
            } # Selected Enable Git Features


            # Disallow Git Features
            #  NOTE: Allow the user's request when they type: "False", "F", "Off", as well as "D".
            {($_ -eq "D") -or `
                ($_ -eq "Off") -or `
                ($_ -eq "F") -or `
                ($_ -eq "False")}
            {
                # The user had selected to disable all utilization of Git Features and Functionality
                #  within the program.
                $userPreferences.SetUseGitFeatures($false);

                # Finished
                break;
            } # Selected Disable Git Features


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
    } # EvaluateExecuteUserRequestUseGitFeatures()
    #endregion





    #region Notifications
    #                                       Notifications
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Notifications
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to customize the notifications in which the program
    #   will send alerts to the user based on certain events.
    # -------------------------------
    #>
    hidden static [void] NotificationTypes()
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
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Notification Types Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Determine the current state of the Notification Type variable and make it so that it is easier
            #  for the user to understand the meaning of it's current setting.
            switch ($userPreferences.GetBellEvents())
            {
                ([UserPreferencesEventAlarm]::Everything)
                {
                    # Set the message such that the user knows that 'everything' is presently activated.
                    $decipherNiceString = "I will alert you for all events that occur.";

                    # Finished
                    break;
                } # Everything


                ([UserPreferencesEventAlarm]::Success)
                {
                    # Set the message such that the user knows that 'success' is presently activated.
                    $decipherNiceString = "I will only alert you if an operation was successful.";

                    # Finished
                    break;
                } # Success


                ([UserPreferencesEventAlarm]::Errors)
                {
                    # Set the message such that the user knows that 'errors' is presently activated.
                    $decipherNiceString = "I will only alert you if an operation had failed.";

                    # Finished
                    break;
                } # Errors


                ([UserPreferencesEventAlarm]::Warnings)
                {
                    # Set the message such that the user knows that 'Warnings' is presently activated.
                    $decipherNiceString = "I will only alert you if a warning event had occurred.";

                    # Finished
                    break;
                } # Warnings


                ([UserPreferencesEventAlarm]::Disable)
                {
                    # Set the message such that the user knows that 'Disable' is presently activated.
                    $decipherNiceString = "I will not notify you regardless of an event.";

                    # Finished
                    break;
                } # Disable
            } # Switch: Decipher Notification Type



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Notifications Menu
            [CommonCUI]::DrawSectionHeader("Notifications");

            # Show to the user the current state of the 'Notifications' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            #Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuUseNotificationTypes();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestNotificationTypes($userInput);
        } while ($menuLoop);
    } # NotificationTypes()




   <# Draw Menu: Notification Types
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the types of Notifications that are
    #   possible within this program.  With this ability, the user may choose to specify which
    #   events to receive notifications - if any.
    # -------------------------------
    #>
    hidden static [void] DrawMenuUseNotificationTypes()
    {
        # Display the Menu List

        # Notifications for all events
        [CommonCUI]::DrawMenuItem('A', `
                                "Everything", `
                                "Provide notifications for all events.", `
                                $NULL, `
                                $true);


        # Notifications for successful events
        [CommonCUI]::DrawMenuItem('S', `
                                "Successful Operations", `
                                "Provide notifications for only successful events.", `
                                $NULL, `
                                $true);


        # Notifications for errors events
        [CommonCUI]::DrawMenuItem('E', `
                                "Errors", `
                                "Provide notifications for only error events.", `
                                $NULL, `
                                $true);


        # Notifications for warning events
        [CommonCUI]::DrawMenuItem('W', `
                                "Warnings", `
                                "Provide notifications for only warning events.", `
                                $NULL, `
                                $true);


        # Notifications for all events
        [CommonCUI]::DrawMenuItem('D', `
                                "Disable", `
                                "Do not provide any notifications regardless of an event.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # DrawMenuUseNotificationTypes()




   <# Evaluate and Execute User's Request: Notification Type
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
    hidden static [bool] EvaluateExecuteUserRequestNotificationTypes([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Notify the user for ALL events
            #  NOTE: Allow the user's request when they type: "Everything", "All Events", "All",
            #   as well as "A"
            {($_ -eq "A") -or `
                ($_ -eq "Everything") -or `
                ($_ -eq "All Events") -or `
                ($_ -eq "All")}
            {
                # The user had selected to be notified for ALL events.
                $userPreferences.SetBellEvents([UserPreferencesEventAlarm]::Everything);

                # Finished
                break;
            } # Selected Notification Type: All


            # Notify the user for only successful operations
            #  NOTE: Allow the user's request when they type: "Successful Operations", "Success",
            #   "Successful", as well as "S".
            {($_ -eq "S") -or `
                ($_ -eq "Successful Operations") -or `
                ($_ -eq "Success") -or `
                ($_ -eq "Successful")}
            {
                # The user had selected to be notified for successful operations only.
                $userPreferences.SetBellEvents([UserPreferencesEventAlarm]::Success);

                # Finished
                break;
            } # Selected Notification Type: Successful Operations


            # Notify the user for only Error events
            #  NOTE: Allow the user's request when they type: "Errors", "Error", "Error Events", as well as "E".
            {($_ -eq "E") -or `
                ($_ -eq "Errors") -or `
                ($_ -eq "Error") -or `
                ($_ -eq "Error Events")}
            {
                # The user had selected to be notified for error events only.
                $userPreferences.SetBellEvents([UserPreferencesEventAlarm]::Errors);

                # Finished
                break;
            } # Selected Notification Type: Error Events


            # Notify the user only for Warnings that had occurred
            #  NOTE: Allow the user's request when they type: "Warnings", "Warning", "Warning Events", as well as "W".
            {($_ -eq "W") -or `
                ($_ -eq "Warnings") -or `
                ($_ -eq "Warning") -or `
                ($_ -eq "Warning Events")}
            {
                # The user had selected to be notified for warning events only.
                $userPreferences.SetBellEvents([UserPreferencesEventAlarm]::Warnings);

                # Finished
                break;
            } # Selected Notification Type: Warning Events


            # Do not notify the user any events that had occurred.
            #  NOTE: Allow the user's request when they type: "Disable" or "D".
            {($_ -eq "D") -or `
                ($_ -eq "Disable")}
            {
                # The user does not wish to have any notifications regardless of an event that may occur.
                $userPreferences.SetBellEvents([UserPreferencesEventAlarm]::Disable);

                # Finished
                break;
            } # Selected Notification Type: Disable Notifications


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
    } # EvaluateExecuteUserRequestNotificationTypes()
    #endregion





    #region Use Windows Explorer
    #                                   Use Windows Explorer
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Use Windows Explorer
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to specify if the Windows Explorer
    #   features and functionalities can be utilized within this program.
    # -------------------------------
    #>
    hidden static [void] UseWindowsExplorer()
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
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Use Windows Explorer Configuration Menu
        #  Keep the user within the menu until the request to return back to the previous menu.
        do
        {
            # Determine the current state of the Use Windows Explorer variable and make it nicer for the user to understand.
            if ($userPreferences.GetUseWindowsExplorer())
            {
                # The user currently has the Windows Explorer functionality presently activated
                $decipherNiceString = "I will utilize the Windows Explorer to make it easier for you to find your files and to open websites.";
            } # if: Windows Explorer are enabled

            # Windows Explorer features not to be used within the program.
            else
            {
                # The user currently has the Windows Explorer presently deactivated
                $decipherNiceString = "I will not utilize any Windows Explorer's functionality.";
            } # else: Windows Explorer are disabled



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Windows Explorer menu
            [CommonCUI]::DrawSectionHeader("Windows Explorer");

            # Show to the user the current state of the 'Use Windows Explorer' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            #Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGeneralProgram]::DrawMenuUseWindowsExplorer();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGeneralProgram]::EvaluateExecuteUserRequestUseWindowsExplorer($userInput);
        } while ($menuLoop);
    } # UseWindowsExplorer()




   <# Draw Menu: Use Windows Explorer
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Use Windows Explorer functionality to the user.
    #   Thus, this provides the ability to configure the state of Windows Explorer functionality within the program.
    # -------------------------------
    #>
    hidden static [void] DrawMenuUseWindowsExplorer()
    {
        # Display the Menu List

        # Allow the ability to utilize Windows Explorer functionality where available
        [CommonCUI]::DrawMenuItem('E', `
                                "Enable", `
                                "Allow the program to open new windows and websites for you automatically.", `
                                $NULL, `
                                $true);


        # Disallow the ability to utilize Windows Explorer functionality within the program.
        [CommonCUI]::DrawMenuItem('D', `
                                "Disable", `
                                "Do not use any features from Windows Explorer within the program.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # DrawMenuUseWindowsExplorer()




   <# Evaluate and Execute User's Request: Use Windows Explorer
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
    hidden static [bool] EvaluateExecuteUserRequestUseWindowsExplorer([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Allow Windows Explorer specific features
            #  NOTE: Allow the user's request when they type: "True", "T", "On", as well as "E".
            {($_ -eq "E") -or `
                ($_ -eq "On") -or `
                ($_ -eq "T") -or `
                ($_ -eq "True")}
            {
                # The user had selected to enable the utilization of Windows Explorer functionality
                #  within the program.
                $userPreferences.SetUseWindowsExplorer($true);

                # Finished
                break;
            } # Selected Enable Windows Explorer


            # Disallow Windows Explorer
            #  NOTE: Allow the user's request when they type: "False", "F", "Off", as well as "D".
            {($_ -eq "D") -or `
                ($_ -eq "Off") -or `
                ($_ -eq "F") -or `
                ($_ -eq "False")}
            {
                # The user had selected to disable all utilization of Windows Explorer functionality
                #  within the program.
                $userPreferences.SetUseWindowsExplorer($false);

                # Finished
                break;
            } # Selected Disable Windows Explorer


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
    } # EvaluateExecuteUserRequestUseWindowsExplorer()
    #endregion
} # SettingsGeneralProgram