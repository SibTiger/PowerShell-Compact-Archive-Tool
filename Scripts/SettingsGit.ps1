<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #>




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
            [SettingsGit]::__DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequest($userInput);
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
    hidden static [void] __DrawMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Here are some variables that are used to help the user to understand the
        #  meaning behind a particular setting.  Thus, instead of saying "True" or
        #  an enumerator value that is not easy to decipher, we can break it down in
        #  a way that it is easier to convey the point across to the user.
        [string] $currentSettingUpdateSource = $NULL;           # Update Source
        [string] $currentSettingCommitIDLength = $NULL;         # Commit ID Size
        [string] $currentSettingRetrieveHistory = $NULL;        # Retrieve History
        [string] $currentSettingHistoryCommitSize = $NULL;      # Changelog Size
        [string] $currentSettingGenerateReport = $NULL;         # Generate Report
        [string] $currentSettingGenerateReportPDF = $NULL;      # Generate PDF Report

        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuLocateGit = $true;          # Locate Git
        [bool] $showMenuUpdateSource = $true;       # Update Source
        [bool] $showMenuCommitIDSize = $true;       # Commit ID Size
        [bool] $showMenuRetrieveHistory = $true;    # Retrieve History
        [bool] $showMenuHistorySize = $true;        # History Size
        [bool] $showMenuGenerateReport = $true;     # Generate Report
        [bool] $showMenuUseTool = $true;            # Use Git functionality

        # Retrieve the Git Control object
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Retrieve the current settings and determine the wording before we generate the menu.
        [SettingsGit]::__DrawMenuDecipherCurrentSettings([ref] $currentSettingUpdateSource, `           # Update Source
                                                            [ref] $currentSettingCommitIDLength, `      # Commit ID Size
                                                            [ref] $currentSettingRetrieveHistory, `     # Retrieve History
                                                            [ref] $currentSettingHistoryCommitSize, `   # Changelog Size
                                                            [ref] $currentSettingGenerateReport, `      # Generate Report
                                                            [ref] $currentSettingGenerateReportPDF);    # Generate PDF Report


        # Determine what menus are to be displayed to the user.
        [SettingsGit]::__DrawMenuDetermineHiddenMenus([ref] $showMenuLocateGit, `           # Locate Git
                                                        [ref] $showMenuUpdateSource, `      # Update Source
                                                        [ref] $showMenuCommitIDSize, `      # Commit ID Size
                                                        [ref] $showMenuRetrieveHistory, `   # Retrieve History
                                                        [ref] $showMenuHistorySize, `       # History Size
                                                        [ref] $showMenuGenerateReport, `    # Generate Report
                                                        [ref] $showMenuUseTool);            # Use Get functionality



        # Display the menu list


        # Ask the user if they wish to use the Git-SCM functionality.
        if (!($showMenuUseTool))
        {
            [CommonCUI]::DrawMenuItem('G', `
                                    "Git-SCM", `
                                    "Use Git-SCM to manage your local repository and obtain project development information.", `
                                    $NULL, `
                                    $true);
        } # if: Ask to use Git-SCM Functionality

        # Ask the user if they wish to disable the Git-SCM functionality.
        else
        {
            [CommonCUI]::DrawMenuItem('G', `
                                    "Git-SCM", `
                                    "Disable Git-SCM functionality.", `
                                    $NULL, `
                                    $true);
        } # else : Ask to disable Git-SCM Functionality



        # - - - - - - - - - - - -
        # - - - - - - - - - - - -



        # Find Git
        if ($showMenuLocateGit)
        {
            [CommonCUI]::DrawMenuItem('B', `
                                    "Locate the Git Application", `
                                    "Find the Git application on your computer.", `
                                    "Git is located at: $($gitControl.GetExecutablePath())", `
                                    $true);
        } # If: Show Locate Git


        # Allow or disallow the local repo. to be updated
        if ($showMenuUpdateSource)
        {
            [CommonCUI]::DrawMenuItem('U', `
                                    "Update Source", `
                                    "Allows the ability to update $([ProjectInformation]::projectName) project files.", `
                                    "Update $([ProjectInformation]::projectName) project files: $($currentSettingUpdateSource)", `
                                    $true);
        } # If: Show Update Source


        # Determine length of Hash size
        if ($showMenuCommitIDSize)
        {
            [CommonCUI]::DrawMenuItem('S', `
                                    "Size of Commit ID", `
                                    "When retrieving the latest commit SHA1 Commit ID, it can come in two sizes: Small or Large.", `
                                    "The Commit ID Size to use: $($currentSettingCommitIDLength)", `
                                    $true);
        } # If: Show Commit ID Size


        # Allow or disallow ability to retrieve changelog
        if ($showMenuRetrieveHistory)
        {
            [CommonCUI]::DrawMenuItem('H', `
                                    "Retrieve History", `
                                    "Allows the ability to retrieve a history changelog of $([ProjectInformation]::projectName)'s development.", `
                                    "Obtain a changelog history of the project: $($currentSettingRetrieveHistory)", `
                                    $true);
        } # If: Show Retrieve History


        # Specify the length of changes retrieved
        if ($showMenuHistorySize)
        {
            [CommonCUI]::DrawMenuItem('L', `
                                    "History Commit Size", `
                                    "Specifies how many commits are to be recorded into the Changelog history file.", `
                                    "How many commits will be recorded: $($currentSettingHistoryCommitSize)", `
                                    $true);
        } # If: Show History Size


        # Enable or disable the ability to generate a report
        if ($showMenuGenerateReport)
        {
            [CommonCUI]::DrawMenuItem('R', `
                                    "Generate Report of Project Repository", `
                                    "Provides a detailed report regarding $([ProjectInformation]::projectName)'s development.", `
                                    "Create a report of the latest developments: $($currentSettingGenerateReport) $($currentSettingGenerateReportPDF)", `
                                    $true);
        } # If: Show Generate Report


        # Help Documentation
        [CommonCUI]::DrawMenuItem('?', `
                                "Help Documentation", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Go back to previous Menu", `
                                $NULL, `
                                $NULL, `
                                $true);


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
    } # __DrawMenu()




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
    #  [string] (REFERENCE) Update Source
    #   Specifies if the local repository is to be updated on the host.
    #  [string] (REFERENCE) Commit ID Length
    #   Determines which size of the SHA1 Commit ID is to be obtained.
    #  [string] (REFERENCE) Retrieve History
    #   Determines if the Changelog History is to be retrieved.
    #  [string] (REFERENCE) History Commit Size
    #   Determines how many commits are to be recorded into the Changelog.
    #  [string] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the project's latest developments.
    #  [string] (REFERENCE) Generate PDF Report
    #   Determines if the user wanted a PDF report of the project's latest developments.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDecipherCurrentSettings([ref] $updateSource, `           # Update Project Files
                                                            [ref] $commitIDLength, `        # Commit ID Length
                                                            [ref] $retrieveHistory, `       # Retrieve History
                                                            [ref] $historyCommitSize, `     # History Commit Size
                                                            [ref] $generateReport, `        # Generate Report
                                                            [ref] $generateReportPDF)       # Generate PDF Report
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the Git Control object
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Update Source
        # Allow the local repository to be updated
        if ($gitControl.GetUpdateSource())
        {
            # Set the string that will be displayed
            $updateSource.Value = "Yes";
        } # if: Update project files

        # Do not update the local repository
        else
        {
            # Set the string that will be displayed
            $updateSource.Value = "No";
        } # else: Do not update the project files



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Commit ID Length
        switch ($gitControl.GetLengthCommitID())
        {
            # SHA1 Size: Short
            ([GitCommitLength]::short)
            {
                # Set the string that will be displayed
                $commitIDLength.Value = "Short";

                # Break from the switch
                break;
            } # Short


            # SHA Size: Long
            ([GitCommitLength]::long)
            {
                # Set the string that will be displayed
                $commitIDLength.Value = "Long";

                # Break from the switch
                break;
            } # Long


            # Unknown case
            Default
            {
                # Set the string that will be displayed
                $commitIDLength.Value = "ERROR";

                # Break from the switch
                break;
            } # Error Case
        } # Switch : Decipher Enumerator Value



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Retrieve History Changelog
        # Allow the ability to obtain the project's history changelog.
        if ($gitControl.GetFetchChangelog())
        {
            # Set the string that will be displayed
            $retrieveHistory.Value = "Yes";
        } # if: Obtain a changelog

        # Do not obtain the project's history changelog.
        else
        {
            # Set the string that will be displayed
            $retrieveHistory.Value = "No";
        } # else: Do not obtain a changelog



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Changelog History Size
        # Are we supposed to retrieve all of the commits?
        if ($gitControl.GetChangelogLimit() -eq 0)
        {
            # Set the string that will be displayed
            $historyCommitSize.Value = "All commits";
        } # If: Record all commits

        # Show the numeric value instead
        else
        {
            # Set the string that will be displayed
            $historyCommitSize.Value = [string]$gitControl.GetChangelogLimit();
        } # else: Show numeric value



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Generate Report
        # Provide a new report regarding the latest developments within
        #  the local repository
        if ($gitControl.GetGenerateReport())
        {
            # The user wants to have a report generated regarding the local repository.
            $generateReport.Value = "Yes";
        } # if: Create report

        # Do not provide a new report regarding the latest developments
        #  within the local repository
        else
        {
            # The user does not want us to have a report generated regarding the local repository.
            $generateReport.Value = "No";
        } # else: Do not create report



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Generate PDF Report
        # Provide a new PDF report regarding the local repository.
        if ($gitControl.GetGenerateReportFilePDF() -and `
            $gitControl.GetGenerateReport())
        {
            # The user wants to have a PDF report generated regarding the local repository.
            $generateReportPDF.Value = "[PDF]";
        } # if: Create PDF report

        # Do not provide a PDF report regarding the local repository.
        else
        {
            # The user does not want to have a report generated of the local repository.
            $generateReportPDF.Value = $null;
        } # else: Do not create PDF report
    } # __DrawMenuDecipherCurrentSettings()




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
    #  [bool] (REFERENCE) Locate Git
    #   Browse for the Git Application on the host system.
    #  [bool] (REFERENCE) Update Source
    #   Update the local repository source files.
    #  [bool] (REFERENCE) Commit ID Size
    #   Determines the length of the SHA Commit ID Size
    #  [bool] (REFERENCE) Retrieve History
    #   Ability to retrieve a history changelog of the development.
    #  [bool] (REFERENCE) History Size
    #   How many commits will be recorded.
    #  [bool] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the project's latest developments.
    #  [bool] (REFERENCE) Use Tool
    #   Determines if the Git-SCM application functionality had been enabled.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenuLocateGit, `         # Locate Git
                                                        [ref] $showMenuUpdateSource, `      # Update Source
                                                        [ref] $showMenuCommitIDSize, `      # Commit ID Size
                                                        [ref] $showMenuRetrieveHistory, `   # Retrieve History
                                                        [ref] $showMenuHistorySize, `       # History Size
                                                        [ref] $showMenuGenerateReport, `    # Generate Report
                                                        [ref] $showMenuUseTool)             # Use Git-SCM functionality
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the Git Control object
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # Retrieve the User Preferences object
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Are we able to locate the Git-SCM application?
        if (!([CommonFunctions]::IsAvailableGit()))
        {
            # Because we are not able to find the Git-SCM application, hide all options associated
            #   with Git's configuration.
            $showMenuUpdateSource.Value     = $false;   # Update Source
            $showMenuCommitIDSize.Value     = $false;   # Commit ID Size
            $showMenuRetrieveHistory.Value  = $false;   # Retrieve History
            $showMenuHistorySize.Value      = $false;   # History Size
            $showMenuGenerateReport.Value   = $false;   # Generate Report
            $showMenuUseTool.Value          = $true;    # Use Tool


            # Allow the user to locate the Git-SCM Executable.
            $showMenuLocateGit.Value        = $true;    # Browse Git Software


            # Finished
            return;
        } # If : Unable to find Git-SCM



        # Did the user disable Git-SCM functionality?
        if ($userPreferences.GetVersionControlTool() -ne [UserPreferencesVersionControlTool]::GitSCM)
        {
            # Because the user wishes to not use any Git-SCM functionality, hide all options associated with
            #   the version control.
            $showMenuLocateGit.Value        = $false;   # Browse Git-SCM Software
            $showMenuUpdateSource.Value     = $false;   # Update Source
            $showMenuCommitIDSize.Value     = $false;   # Commit ID Size
            $showMenuRetrieveHistory.Value  = $false;   # Retrieve History
            $showMenuHistorySize.Value      = $false;   # History Size
            $showMenuGenerateReport.Value   = $false;   # Generate Report


            # Ask the user if they wish to enable Git-SCM functionality?
            $showMenuUseTool.Value          = $false;   # Use Tool


            # Finished
            return;
        } # If : Git-SCM Disabled



        # If we made it here, then that would indicate that the user is presently utilizing the Git-SCM software.
        #   Show the menu items that are associated with the Git-SCM application, however some menu items may
        #   be hidden due to dependent options.


        $showMenuLocateGit.Value        = $true;    # Browse Git-SCM Software
        $showMenuUpdateSource.Value     = $true;    # Update Source
        $showMenuCommitIDSize.Value     = $true;    # Commit ID Size
        $showMenuRetrieveHistory.Value  = $true;    # Retrieve History
        $showMenuGenerateReport.Value   = $true;    # Generate Report



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Retrieve History Size
        #  When the user had requested to retrieve commit history, the user can also specify how many
        #   commits are to be logged.
        if ($gitControl.GetFetchChangelog())
        {
            $showMenuHistorySize.Value = $true;
        } # If : Retrieve History Size is Visible

        # Retrieve History Size
        else
        {
            $showMenuHistorySize.Value = $false;
        } # else : Retrieve History Size is Hidden
    } # __DrawMenuDetermineHiddenMenus()




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
    hidden static [bool] __EvaluateExecuteUserRequest([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the User Preferences object
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();


        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuLocateGit = $true;          # Locate Git
        [bool] $showMenuUpdateSource = $true;       # Update Source
        [bool] $showMenuCommitIDSize = $true;       # Commit ID Size
        [bool] $showMenuRetrieveHistory = $true;    # Retrieve History
        [bool] $showMenuHistorySize = $true;        # History Size
        [bool] $showMenuGenerateReport = $true;     # Generate Report
        [bool] $showMenuUseTool = $true;            # Use Git-SCM functionality
        # ----------------------------------------


        # Determine what menus are available to the user.
        [SettingsGit]::__DrawMenuDetermineHiddenMenus([ref] $showMenuLocateGit, `           # Locate Git
                                                        [ref] $showMenuUpdateSource, `      # Update Source
                                                        [ref] $showMenuCommitIDSize, `      # Commit ID Size
                                                        [ref] $showMenuRetrieveHistory, `   # Retrieve History
                                                        [ref] $showMenuHistorySize, `       # History Size
                                                        [ref] $showMenuGenerateReport, `    # Generate Report
                                                        [ref] $showMenuUseTool)             # Use Git-SCM functionality



        switch ($userRequest)
        {
            # Use Tool - Disabled
            #  NOTE: Allow the user's request when they type: "enable" as well as 'G'.
            {((($showMenuUseTool) -eq $false) -and `
                (($_ -eq "G") -or `
                 ($_ -eq "enable")))
            }
            {
                # The user had selected to enable Git-SCM functionality.
                $userPreferences.SetVersionControlTool([UserPreferencesVersionControlTool]::GitSCM);


                # Finished
                break;
            } # Selected Enable Git-SCM



            # Use Tool - Enabled
            #  NOTE: Allow the user's request when they type: "disable" as well as 'G'.
            {(($showMenuUseTool) -and `
                (($_ -eq "G") -or `
                 ($_ -eq "disable")))
            }
            {
                # The user had selected to dis4able Git-SCM functionality.
                $userPreferences.SetVersionControlTool([UserPreferencesVersionControlTool]::GitSCM);


                # Finished
                break;
            } # Selected Disabled Git-SCM



            # Browse for Git
            #  NOTE: Allow the user's request when they type: 'Browse for Git', 'Find Git',
            #           'Locate Git', 'Browse Git', as well as 'B'.
            {($showMenuLocateGit) -and `
                (($_ -eq "B") -or `
                    ($_ -eq "Browse for Git") -or `
                    ($_ -eq "Find Git") -or `
                    ($_ -eq "Locate Git") -or `
                    ($_ -eq "Browse Git"))}
            {
                # Allow the user to locate the path to Git or verify Git's path.
                [SettingsGit]::__LocateGitPath();


                # Finished
                break;
            } # Browse for Git



            # Update Source
            #  NOTE: Allow the user's request when they type: 'Update Source', 'Update Project',
            #           'Update', as well as 'U'.
            {($showMenuUpdateSource) -and `
                (($_ -eq "U") -or `
                    ($_ -eq "Update") -or `
                    ($_ -eq "Update Source") -or `
                    ($_ -eq "Update Project"))}
            {
                # Allow the user the ability to choose if they want to update the project's
                #  source files or not to update the project's files.
                [SettingsGit]::__UpdateSource();


                # Finished
                break;
            } # Update Source



            # Length of the Commit SHA ID
            #  NOTE: Allow the user's request when they type: 'Size', 'Size of Commit ID',
            #           as well as 'S'.
            {($showMenuCommitIDSize) -and `
                (($_ -eq "S") -or `
                    ($_ -eq "Size") -or `
                    ($_ -eq "Size of Commit ID"))}
            {
                # Allow the user the ability to choose the size of the commit ID regarding the
                #  project's repository.
                [SettingsGit]::__SizeCommitID();


                # Finished
                break;
            } # Size of Commit ID



            # History
            #  NOTE: Allow the user's request when they type: 'History', 'Changelog',
            #           as well as 'H'.
            {($showMenuRetrieveHistory) -and `
                (($_ -eq "H") -or `
                    ($_ -eq "History") -or `
                    ($_ -eq "Changelog"))}
            {
                # Allow the ability for the user to specify if they wish to have the history
                #  changelog from the project's repository.
                [SettingsGit]::__History();


                # Finished
                break;
            } # History



            # History Commit Size
            #  NOTE: Allow the user's request when they type: 'History Commit Size' or 'L'
            {($showMenuHistorySize) -and `
                (($_ -eq "L") -or `
                ($_ -eq "History Commit Size"))}
            {
                # Allow the user to change how many commits are to be recorded into the
                #  changelog history.
                [SettingsGit]::__HistoryCommitSize();


                # Finished
                break;
            } # History Commit Size



            # Generate Report of Project's Repository
            #  NOTE: Allow the user's request when they type: 'Report', 'Generate Report',
            #           as well as 'R'.
            {($showMenuGenerateReport) -and `
                (($_ -eq "R") -or `
                    ($_ -eq "Generate Report") -or `
                    ($_ -eq "Report"))}
            {
                # Allow the user the ability to request reports regarding the project's repository.
                [SettingsGit]::__GenerateReport();


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
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,                   ` # Program's Wiki
                                                            "$([ProjectInformation]::projectName) Wiki",    ` # Show page title
                                                            $false))                                        ` # Do not force Web Browser functionality.
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch: Option Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequest()





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
    hidden static [void] __LocateGitPath()
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
                [Logging]::DisplayMessage("I cannot find the Git application within the provided path:");
            } # Else: Git's path was not found


            # Output the project's path
            [Logging]::DisplayMessage("`t$($gitControl.GetExecutablePath())");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuLocateGitPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestLocateGitPath($userInput);
        } while ($menuLoop);
    } # __LocateGitPath()




   <# Draw Menu: Locate Git Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate Git Path to the user.
    #   thus this provides what options are available to the user in order to configure the Git
    #   path.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuLocateGitPath()
    {
        # Display the Menu List

        # Automatically find Git
        [CommonCUI]::DrawMenuItem('A', `
                                "Automatically find Git", `
                                "Try to automatically find the Git Application.", `
                                $NULL, `
                                $true);


        # Manually find Git
        [CommonCUI]::DrawMenuItem('M', `
                                "Manually find Git", `
                                "Manually locate the Git Application.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuLocateGitPath()




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
    hidden static [bool] __EvaluateExecuteUserRequestLocateGitPath([string] $userRequest)
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
                [SettingsGit]::__LocateGitPathAutomatically();


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
                [SettingsGit]::__LocateGitPathManually();


                # Finished
                break;
            } # Manually find Git



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestLocateGitPath()




   <# Configure Locate Git Path Automatically
    # -------------------------------
    # Documentation:
    #  This function will try to find the Git application automatically
    #   for the user.
    # -------------------------------
    #>
    hidden static [void] __LocateGitPathAutomatically()
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
            # Alert the user that the path is incorrect.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Because we are unable to find Git automatically, there's
            #  really nothing that we can do.
            [Logging]::DisplayMessage("Unable to find the Git application!`r`nPlease be sure that it had been properly installed on your system!");
        } # If : Cannot Find Git Automatically


        # We were able to obtain a new location of where the Git Application resides within the system.
        else
        {
            # Because we were able to find the Git Application, we can use the new value.
            $gitControl.SetExecutablePath($findGitResults);

            # Let the user know that we were able to successfully find the Git Application
            [Logging]::DisplayMessage("Successfully found the Git Application in:`r`n$($findGitResults)");
        } # Else: Found Git


        # Wait for the user to provide feedback; thus allowing the user to read the message.
        [logging]::GetUserEnterKey();
    } # __LocateGitPathAutomatically()




   <# Configure Locate Git Path Manually
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to manually configure
    #   the path of the Git directory.
    # -------------------------------
    #>
    hidden static [void] __LocateGitPathManually()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  Git Path variable.
        [System.Collections.ArrayList] $newPath = [System.Collections.ArrayList]::new();

        # We will use this instance so that we can apply the new location to the object.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine if the path that were provided is valid and can be used by the program.
        if ([UserExperience]::BrowseForFile("Provide full path to git.exe",             ` # Title
                                            "exe",                                      ` # Extension we are wanting
                                            "Executable (*.exe) | *.exe",               ` # Additional Extensions
                                            $false,                                     ` # Select multiple files
                                            [BrowserInterfaceStyle]::Modern,            ` # GUI Style
                                            $newPath))                                  ` # Selected files
        {
            # Because the path is valid, we will use the requested target directory.
            $gitControl.SetExecutablePath($newPath[0]);
        } # if: Path is valid

        # The provided path is not valid
        else
        {
            # Alert the user that the path is incorrect.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Because the path is not valid, let the user know that the path does not exist
            #  and will not be used.
            [Logging]::DisplayMessage("`r`n" + `
                                    "The provided path does not exist and cannot be used." + `
                                    "`r`n`r`n");


            # Wait for the user to provide feedback; thus allowing the user to see the message.
            [Logging]::GetUserEnterKey();
        } # else : Path is invalid
    } # __LocateGitPathManually()
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
    hidden static [void] __UpdateSource()
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
                $decipherNiceString = "I will not update the project's source files.";
            } # else : Do not Update the Project's Source Files


            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Update Source menu
            [CommonCUI]::DrawSectionHeader("Update Project Files");

            # Show to the user the current state of the Update Source presently set within the program
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuUpdateSource();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestUpdateSource($userInput);
        } while ($menuLoop);
    } # __UpdateSource()




   <# Draw Menu: Update Source
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the Update Source Files
    #  functionality.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuUpdateSource()
    {
        # Display the Menu List

        # Enable the Update Source feature
        [CommonCUI]::DrawMenuItem('U', `
                                "Update Project's Source Files", `
                                "Update the project to the current changes available on the remote master server.", `
                                $NULL, `
                                $true);


        # Disable the Update Source feature
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not Update Project's Source Files", `
                                "Do not update the project's source files with the latest changes made from the remote master server.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuUpdateSource()




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
    hidden static [bool] __EvaluateExecuteUserRequestUpdateSource([string] $userRequest)
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


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation


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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestUpdateSource()
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
    hidden static [void] __SizeCommitID()
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
                ([GitCommitLength]::short)
                {
                    # Set the message such that the user knows that the short Commit ID will be retrieved.
                    $decipherNiceString = "I will use the short Commit SHA ID";

                    # Finished
                    break;
                } # Short


                ([GitCommitLength]::long)
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
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuSizeCommitID();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestSizeCommitID($userInput);
        } while ($menuLoop);
    } # __SizeCommitID()




   <# Draw Menu: Update Source
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the Length of
    #   the Commit ID retrieved from the Git Executable.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuSizeCommitID()
    {
        # Display the Menu List

        # Enable the Update Source feature
        [CommonCUI]::DrawMenuItem('S', `
                                "Short Commit SHA ID", `
                                "Contains about seven characters.", `
                                $NULL, `
                                $true);


        # Disable the Update Source feature
        [CommonCUI]::DrawMenuItem('L', `
                                "Long Commit SHA ID", `
                                "Contains about forty-one characters.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuSizeCommitID()




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
    hidden static [bool] __EvaluateExecuteUserRequestSizeCommitID([string] $userRequest)
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



            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation



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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestSizeCommitID()
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
    hidden static [void] __History()
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
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuHistory();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestHistory($userInput);
        } while ($menuLoop);
    } # __History()




   <# Draw Menu: History Changelog
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the menu list regarding the ability
    #   to specify if the history changelog is to be retrieved from the project's repository.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuHistory()
    {
        # Display the Menu List

        # Retrieve the History Changelog
        [CommonCUI]::DrawMenuItem('H', `
                                "Retrieve History", `
                                "Records the latest developments within the $([ProjectInformation]::projectName) project.", `
                                $NULL, `
                                $true);


        # Do not retrieve the History Changelog
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not Retrieve History", `
                                "No changelog will be retrieved.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuHistory()




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
    hidden static [bool] __EvaluateExecuteUserRequestHistory([string] $userRequest)
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


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation


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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestHistory()
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
    hidden static [void] __HistoryCommitSize()
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
            if ($gitControl.GetChangelogLimit() -eq 0)
            {
                # Retrieve _ALL_ changes possible
                $decipherNiceString = "I will retrieve all changes.";
            } # If: Record all changes

            # Retrieve only a specific number of commits
            else
            {
                # Only retrieve a specific number
                $decipherNiceString = "I will retrieve $($gitControl.GetChangelogLimit()) changes.";
            } # else: Limited amount of commits to record



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the History Commit Size menu
            [CommonCUI]::DrawSectionHeader("History Changelog Size Limit");

            # Show to the user the current state of the History Commit Size presently set within the program
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuHistoryCommitSize();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestHistoryCommitSize($userInput);
        } while ($menuLoop);
    } # __History()




   <# Draw Menu: History Changelog Size
    # -------------------------------
    # Documentation:
    #  This function will essentially provide the user the ability to change the History size
    #   limit or to leave the setting as is.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuHistoryCommitSize()
    {
        # Display the Menu List

        # Change the History Changelog Commit Size Limit
        [CommonCUI]::DrawMenuItem('C', `
                                "Change changelog size limit", `
                                "Specifies how many commits will be recorded into the History Changelog file.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuHistoryCommitSize()




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
    hidden static [bool] __EvaluateExecuteUserRequestHistoryCommitSize([string] $userRequest)
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
                [SettingsGit]::__HistoryCommitSizeNewSize();

                # Finished
                break;
            } # Change History Commit Size


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation


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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestHistoryCommitSize()




   <# Configure History Commit Size
    # -------------------------------
    # Documentation:
    #  This function will provide the user the ability to specify how many
    #   commits are to be recorded.
    # -------------------------------
    #>
    hidden static [void] __HistoryCommitSizeNewSize()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the new number provided by the user's input.
        [string] $newSize = 0;

        # Retrieve the current instance of the Git object; this contains the user's settings
        #  when using the Git application.
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide a message to the user asking how many changes should be recorded.
        [Logging]::DisplayMessage("How many commits should be recorded?`r`nNOTE: To retrieve all changes, use '0'.`r`n");

        # Obtain the user's input
        $newSize = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::ProvideNumericValue);


        # Cancel the operation if the user provided 'Cancel' or 'X'
        if (($newSize -eq "Cancel") -or `
            ($newSize -eq "x"))
        {
            # Abort the operation
            return;
        } # If : Cancel not Provided



        # Input validation check
        # - - - - - - - - - - - - -

        # Make sure that the user provided only numeric values; no symbols or alphabet characters
        if ($newSize -notmatch "^\d+$")
        {
            # Not all of the characters are numeric based
            [Logging]::DisplayMessage("`r`n" + `
                                    "The provided value is not entirely a numeric value." + `
                                    "`r`n`r`n");

            # Wait for the user to provide feedback; thus allowing the user to see the message.
            [Logging]::GetUserEnterKey();

            # Do not proceed any further
            return;
        } # If: Input provided is not a valid


        # Set the new size accordingly
        $gitControl.SetChangelogLimit([uint32]$newSize);
    } # __HistoryCommitSizeNewSize()
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
    hidden static [void] __GenerateReport()
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
                # Determine if the PDF is to also be generated
                if ($gitControl.GetGenerateReportFilePDF())
                {
                    $decipherNiceString = "I will create a PDF report regarding the project's repository.";
                } # if : Generate PDF Report

                # If a regular report is to only be generated
                else
                {
                    # Generate Report is presently set as enabled.
                    $decipherNiceString = "I will create a report regarding the project's repository.";
                } # else : Generate Report
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
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsGit]::__DrawMenuGenerateReport();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsGit]::__EvaluateExecuteUserRequestGenerateReport($userInput);
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
    hidden static [void] __DrawMenuGenerateReport()
    {
        # Display the Menu List

        # Generate a new report regarding the project's repository.
        [CommonCUI]::DrawMenuItem('R', `
                                "Generate a report file", `
                                "Generate a new technical report regarding the project's repository.", `
                                $NULL, `
                                $true);


        # Generate a new PDF report regarding the project's repository.
        [CommonCUI]::DrawMenuItem('P', `
                                "Generate a PDF report file", `
                                "Generate a new technical PDF report regarding the project's repository.", `
                                $NULL, `
                                $true);


        # Do not generate a report regarding the project's repository.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not generate a report file.", `
                                "Do not create a technical report regarding the project's repository.", `
                                $NULL, `
                                $true);


        # Report an Issue or Feature
        [CommonCUI]::DrawMenuItem('#', `
                                "Report an issue or feature", `
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Online Bug Tracker.", `
                                $NULL, `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMenuGenerateReport()




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
    hidden static [bool] __EvaluateExecuteUserRequestGenerateReport([string] $userRequest)
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
                # The user had selected to have technical reports generated regarding the project's repository.
                $gitControl.SetGenerateReport($true);

                # The user does not wish to generate PDF reports
                $gitControl.SetGenerateReportFilePDF($false);

                # Finished
                break;
            } # Selected Generate Reports


            # Generate PDF Report
            #  NOTE: Allow the user's request when they type: "Create PDF reports", "Generate PDF reports", "Make PDF reports",
            #           "Create PDF", "Generate PDF", "Make PDF", as well as "P".
            {($_ -eq "P") -or `
                ($_ -eq "Create PDF report") -or `
                ($_ -eq "Generate PDF report") -or `
                ($_ -eq "Make PDF report") -or `
                ($_ -eq "Create PDF") -or `
                ($_ -eq "Generate PDF") -or `
                ($_ -eq "Make PDF")}
            {
                # The user had selected to have technical reports generated regarding the project's repository.
                $gitControl.SetGenerateReport($true);

                # The user wishes to generate PDF reports
                $gitControl.SetGenerateReportFilePDF($true);

                # Finished
                break;
            } # Selected Generate PDF Reports


            # Do not Generate Reports
            #  NOTE: Allow the user's request when they type: "Do not create reports", "do not generate reports", "Do not make reports", as well as "N".
            {($_ -eq "N") -or `
                ($_ -eq "Do not create reports") -or `
                ($_ -eq "do not generate reports") -or `
                ($_ -eq "Do not make reports")}
            {
                # The user had selected to not have technical reports generated regarding the project's repository.
                $gitControl.SetGenerateReport($false);

                # The user does not wish to generate PDF reports
                $gitControl.SetGenerateReportFilePDF($false);

                # Finished
                break;
            } # Selected Do not Generate Reports


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,                 ` # Program's Bug Tracker
                                                            "$([ProjectInformation]::projectName) Bug Tracker",     ` # Show page title
                                                            $true))                                                 ` # Override the user's settings; access webpage
                {
                    # Alert the user that the web functionality did not successfully work as intended.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
                } # If : Failed to Provide Webpage


                # Finished
                break;
            } # Access Help Program's Documentation


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
                # Alert the user that they had provided an incorrect option.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);


                # Provide an error message to the user that the option they chose is
                #  not available.
                [CommonCUI]::DrawIncorrectMenuOption();


                # Finished
                break;
            } # Unknown Option
        } # Switch : Evaluate User's Request



        # Finished with the operation; return back to the current menu.
        return $true;
    } # __EvaluateExecuteUserRequestGenerateReport()
    #endregion
} # SettingsGit