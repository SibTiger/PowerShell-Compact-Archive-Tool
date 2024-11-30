<# PowerShell Compact-Archive Tool
 # Copyright (C) 2025
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

        # Latch onto the single instance of the Zip object
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
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
            [SettingsZip]::__DrawMenu();

            # If the Internal Zip functionality is not available, do not allow the user to provide a response.
            #   Otherwise, the user could be stuck in an endless loop or essentially cannot perform any useful
            #   action.
            if ($defaultCompress.DetectCompressModule())
            {
                # Capture the user's feedback
                $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

                # Execute the user's request
                $menuLoop = [SettingsZip]::__EvaluateExecuteUserRequest($userInput);
            } # if : Internal Zip is Available

            # Internal Zip is _not_ available
            else
            {
                # Because the Internal Zip does not exist, there's nothing that the user can do.
                #  Instead, we will ensure that the user safely leaves from this menu.
                $menuLoop = $false;
            } # else : Internal Zip is not Available
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
        [string] $currentSettingCompressionLevel = $NULL;       # Compression Level
        [string] $currentSettingVerifyBuild = $NULL;            # Verify Build
        [string] $currentSettingGenerateReport = $NULL;         # Generate Report
        [string] $moduleName = $NULL;                           # The POSH Module Name
        # ----------------------------------------


        # Retrieve the current settings and determine the wording before we generate the menu.
        [SettingsZip]::__DrawMenuDecipherCurrentSettings([ref] $currentSettingCompressionLevel, `   # Compression Level
                                                        [ref] $currentSettingVerifyBuild, `         # Verify Build
                                                        [ref] $currentSettingGenerateReport, `      # Generate Report
                                                        [ref] $moduleName);                         # PowerShell Module Name



        # Display the menu list


        # Specify Compression Level
        [CommonCUI]::DrawMenuItem('C', `
                                "Compression Level", `
                                "How tightly is the data going to be compacted into the compressed file.", `
                                "Compression level to use: $($currentSettingCompressionLevel)", `
                                $true);


        # Toggle the ability to check file's integrity
        [CommonCUI]::DrawMenuItem('V', `
                                "Verify Build after Compression", `
                                "Assure that the data within the compressed file is healthy.", `
                                "Verify integrity of the newly generated build: $($currentSettingVerifyBuild)", `
                                $true);


        # Allow or disallow the ability to generate a report
        [CommonCUI]::DrawMenuItem('R', `
                                "Generate Report of the Archive Datafile", `
                                "Provides a detailed report regarding the newly generated compressed file.", `
                                "Create a report of the newly generated build: $($currentSettingGenerateReport)", `
                                $true);


        # Update PowerShell Module
        [CommonCUI]::DrawMenuItem('U', `
                                "Update the Compression Software", `
                                "Perform an update on the compression software if available.", `
                                "PowerShell Module Name: $($moduleName).", `
                                $true);


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
    #  [string] (REFERENCE) Compression Level
    #   Determines the current compression level that is presently configured.
    #  [string] (REFERENCE) Verify Build
    #   Determines if the newly generated build will be tested to assure its integrity.
    #  [string] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the newly generated compressed build.
    #  [string] (REFERENCE) PowerShell Module Name
    #   The PowerShell Module for the Compression implementation.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDecipherCurrentSettings([ref] $compressionLevel, `   # Compression Level
                                                            [ref] $verifyBuild, `       # Verify Build
                                                            [ref] $generateReport, `    # Generate Report
                                                            [ref] $moduleName)          # PowerShell Module Name
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the dotNET Archive object.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Compression Level
        switch ($defaultCompress.GetCompressionLevel())
        {
            # Best Compression Possible
            ([DefaultCompressionLevel]::Optimal)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "Optimal Compression";

                # Break from the switch
                break;
            } # Optimal Compression


            # Favor Speed over Compression
            ([DefaultCompressionLevel]::Fastest)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "Fastest Compression";

                # Break from the switch
                break;
            } # Fastest Compression


            # Store; no compression
            ([DefaultCompressionLevel]::NoCompression)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "No Compression";

                # Break from the switch
                break;
            } # Store - No Compression


            # Unknown case
            Default
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "ERROR";

                # Break from the switch
                break;
            } # Error Case
        } # Switch : Decipher Enumerator Value



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Verify Build
        # Test the archive datafile's integrity
        if ($defaultCompress.GetVerifyBuild())
        {
            # The user wishes to have the archive datafile tested, to assure
            #  that it was compressed correctly.
            $verifyBuild.Value = "Yes";
        } # if: Test Archive Datefile

        # Do not test the archive datafile's integrity
        else
        {
            # The user does not wish to have the archive datafile tested.
            $verifyBuild.Value = "No";
        } # else: Do not test Archive Datafile



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Generate Report
        # Provide a new report regarding the newly generated archive file
        if ($defaultCompress.GetGenerateReport())
        {
            # The user wants to have a report generated regarding the archive datafile.
            $generateReport.Value = "Yes";
        } # if: Create report

        # Do not provide a new report regarding the newly generated archive file.
        else
        {
            # The user does not want to have a report generated of the archive datafile.
            $generateReport.Value = "No";
        } # else: Do not create report



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Obtain the PowerShell Module Name of the Compression functionality.
        $moduleName.Value = $defaultCompress.GetPowerShellModuleName();
    } # __DrawMenuDecipherCurrentSettings()




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
        # Retrieve the dotNET Archive object.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------



        switch ($userRequest)
        {
            # Compression Level
            #  NOTE: Allow the user's request when they type: 'Compression Level' and 'C'.
            {(($_ -eq "C") -or `
                ($_ -eq "Compression Level"))}
            {
                # Allow the user to customize the compression level setting.
                [SettingsZip]::__CompressionLevel();


                # Finished
                break;
            } # Compression Level



            # Verify Build after Compression
            #  NOTE: Allow the user's request when they type: 'Verify Build after Compression', 'Verify',
            #           'Verify Build', 'Test Build', 'Test', as well as 'V'.
            {(($_ -eq "V") -or `
                ($_ -eq "Verify Build after Compression") -or `
                ($_ -eq "Verify") -or `
                ($_ -eq "Verify Build") -or `
                ($_ -eq "Test Build") -or `
                ($_ -eq "Test"))}
            {
                # Allow the user the ability to verify a newly generated project build.
                [SettingsZip]::__VerifyBuild();


                # Finished
                break;
            } # Verify Build after Compression



            # Generate Report of Archive Datafile
            #  NOTE: Allow the user's request when they type: 'Report', 'Generate Report',
            #           'Generate Report of Archive Datafile', as well as 'R'.
            {(($_ -eq "R") -or `
                ($_ -eq "Generate Report") -or `
                ($_ -eq "Report") -or `
                ($_ -eq "Generate Report of Archive Datafile"))}
            {
                # Allow the user the ability to request reports for the newly generated archive datafile.
                [SettingsZip]::__GenerateReport();


                # Finished
                break;
            } # Generate Report of Archive Datafile



            # Update the PowerShell Module
            #  NOTE: Allow the user's request when the type: 'Update', 'Upgrade',
            #           'Update Compression Software', 'Update Module', 'Update Compression Module',
            #           'Upgrade Compression Software', 'Upgrade Module', Upgrade Compression Module',
            #           as well as 'U'.
            {($_ -eq "U") -or `
                ($_ -eq "Update") -or `
                ($_ -eq "Upgrade") -or `
                ($_ -eq "Update Compression Software") -or `
                ($_ -eq "Update Module") -or `
                ($_ -eq "Update Compression Module") -or `
                ($_ -eq "Upgrade Compression Software") -or `
                ($_ -eq "Upgrade Module") -or `
                ($_ -eq "Upgrade Compression Module")}
            {
                # Update the PowerShell Module as requested
                $defaultCompress.UpdateModule();


                # Finished
                break;
            } # Update PowerShell Module



            # Access the Help Program's Documentation
            #  NOTE: Allow the user's request when they type: 'Help', 'Helpme',
            #           'Help me', as well as '?'.
            {($_ -eq "?") -or `
                ($_ -eq "help") -or `
                ($_ -eq "helpme") -or `
                ($_ -eq "help me")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMSITEWIKI_,               ` # Program's Wiki
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Wiki"))      ` # Show page title
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
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
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





    #region Compression Level
    #                                     Use Compression Level
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compression Level
    # -------------------------------
    # Documentation:
    #  This function will allow the user with an ability to customize the compression level offered
    #   by the ZipArchive class.
    # -------------------------------
    #>
    hidden static [void] __CompressionLevel()
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
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Compression Level Menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Compression Level variable and make it nicer for the user to understand.
            switch ($defaultCompress.GetCompressionLevel())
            {
                ([DefaultCompressionLevel]::Optimal)
                {
                    # Compression Level is currently set at the optimal setting
                    $decipherNiceString = "I will use the optimal compression setting while compacting the project files.";

                    # Finished
                    break;
                } # Optimal


                ([DefaultCompressionLevel]::Fastest)
                {
                    # Compression Level is currently set at the fastest setting
                    $decipherNiceString = "I will use the fastest compression rate possible while compacting the project files.";

                    # Finished
                    break;
                } # Fastest


                ([DefaultCompressionLevel]::NoCompression)
                {
                    # Compression Level is currently set at no compression setting.
                    $decipherNiceString = "I will not use any compression while compacting the project files.";

                    # Finished
                    break;
                } # NoCompression
            } # Switch: Decipher Message



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Compression Level
            [CommonCUI]::DrawSectionHeader("Compression Level");

            # Show to the user the current state of the 'Compression Level' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsZip]::__DrawMenuUseCompressionLevel();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsZip]::__EvaluateExecuteUserRequestCompressionLevel($userInput);
        } while ($menuLoop);
    } # __CompressionLevel()




   <# Draw Menu: Use Compression Level
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Level
    #   rates that are available from the ZipArchive class from the dotNEt Core Framework.
    #   Thus, this provides what compression levels that are available to the user.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuUseCompressionLevel()
    {
        # Display the Menu List

        # Optimal Compression
        [CommonCUI]::DrawMenuItem('O', `
                                "Optimal Compression", `
                                "Tightly compress the contents; requires more time and resources.", `
                                $NULL, `
                                $true);


        # Fastest Compression
        [CommonCUI]::DrawMenuItem('F', `
                                "Fastest Compression", `
                                "Quickly compress the contents; expedites the compression while using little resources.", `
                                $NULL, `
                                $true);


        # No Compression
        [CommonCUI]::DrawMenuItem('N', `
                                "No Compression", `
                                "Do not compress the contents; only store the contents which requires hardly any resources.", `
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
    } # __DrawMenuUseCompressionLevel()




   <# Evaluate and Execute User's Request: Compression Level
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
    hidden static [bool] __EvaluateExecuteUserRequestCompressionLevel([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Optimal Compression
            #  NOTE: Allow the user's request when they type: "Optimal", "Optimal Compression", as well as "O".
            {($_ -eq "O") -or `
                ($_ -eq "Optimal") -or `
                ($_ -eq "Optimal Compression")}
            {
                # The user had selected to use the optimal compression setting.
                $defaultCompress.SetCompressionLevel([DefaultCompressionLevel]::Optimal);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Optimal Compression


            # Fastest Compression
            #  NOTE: Allow the user's request when they type: "Fastest", "Fastest Compression", "Fast", as well as "F".
            {($_ -eq "F") -or `
                ($_ -eq "Fastest") -or `
                ($_ -eq "Fastest Compression") -or `
                ($_ -eq "Fast")}
            {
                # The user had selected to use the fastest compression setting.
                $defaultCompress.SetCompressionLevel([DefaultCompressionLevel]::Fastest);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Fastest Compression


            # No Compression
            #  NOTE: Allow the user's request when they type: "No compression", "Store", as well as "N".
            {($_ -eq "N") -or `
                ($_ -eq "No Compression") -or `
                ($_ -eq "Store")}
            {
                # The user had selected to not use any compression while compacting files.
                $defaultCompress.SetCompressionLevel([DefaultCompressionLevel]::NoCompression);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected No Compression


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
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
    } # __EvaluateExecuteUserRequestCompressionLevel()
    #endregion





    #region Verify Build
    #                                        Verify Build
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Verify Build
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to specify if the generated build should be
    #   verified to assure a healthy archive datafile.
    # -------------------------------
    #>
    hidden static [void] __VerifyBuild()
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
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Verify Build Menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Verify Build variable and make it nicer for the user to understand.
            #  Is the Verify Build presently enabled?
            if ($defaultCompress.GetVerifyBuild())
            {
                # Verify Build is presently set as enabled.
                $decipherNiceString = "I will verify the newly compiled build's file integrity is healthy.";
            } # if: Verify Build

            # Is the Verify Build presently disabled?
            else
            {
                # Verify Build is not presently set as enabled.
                $decipherNiceString = "I will not verify the health of the newly compiled build.";
            } # else: Do not verify build



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Verify Build menu
            [CommonCUI]::DrawSectionHeader("Verify Build");

            # Show the user the current state of the 'Verify Build' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [SettingsZip]::__DrawMenuVerifyBuild();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsZip]::__EvaluateExecuteUserRequestVerifyBuild($userInput);
        } while ($menuLoop);
    } # __VerifyBuild()




   <# Draw Menu: Verify Build
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Verify Build.
    #  This provides the option if the user wants to test the newly generated
    #  archive datafile's integrity or to skip the verification phase.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuVerifyBuild()
    {
        # Display the Menu List

        # Verify the integrity of the archive datafile.
        [CommonCUI]::DrawMenuItem('V', `
                                "Verify Build", `
                                "Test the compiled build to assure that it is healthy.", `
                                $NULL, `
                                $true);


        # Do not verify the integrity of the archive datafile.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not verify build", `
                                "Do not test the health of the compiled build.", `
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
    } # __DrawMenuVerifyBuild()




   <# Evaluate and Execute User's Request: Verify Build
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
    hidden static [bool] __EvaluateExecuteUserRequestVerifyBuild([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Verify Build
            #  NOTE: Allow the user's request when they type: "Verify", "Verify Build", "Test", "Test Build", as well as "V".
            {($_ -eq "V") -or `
                ($_ -eq "Verify") -or `
                ($_ -eq "Verify Build") -or `
                ($_ -eq "Test") -or `
                ($_ -eq "Test Build")}
            {
                # The user had selected to verify the newly generated project build.
                $defaultCompress.SetVerifyBuild($true);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Verify Build


            # Do not Verify Build
            #  NOTE: Allow the user's request when they type: "Do not verify build", "Do not verify", as well as "N".
            {($_ -eq "N") -or `
                ($_ -eq "Do not verify build") -or `
                ($_ -eq "Do not verify")}
            {
                # The user had selected to not verify the newly generated project build.
                $defaultCompress.SetVerifyBuild($false);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Fastest Compression


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
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
    } # __EvaluateExecuteUserRequestVerifyBuild()
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

        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();

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
            if ($defaultCompress.GetGenerateReport())
            {
                # Generate Report is presently set as enabled.
                $decipherNiceString = "I will create a report regarding the newly generated compiled project build.";
            } # if: Generate Report

            # Is the Generate Report presently disabled?
            else
            {
                # Generate Report is not presently set as enabled.
                $decipherNiceString = "I will not create a report regarding any new builds compiled.";
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
            [SettingsZip]::__DrawMenuGenerateReport();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [SettingsZip]::__EvaluateExecuteUserRequestGenerateReport($userInput);
        } while ($menuLoop);
    } # __GenerateReport()




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

        # Generate a new report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('R', `
                                "Generate a report file", `
                                "Generate a new technical report regarding the project's compiled build.", `
                                $NULL, `
                                $true);


        # Do not generate a new report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not generate a report file.", `
                                "Do not create a technical report regarding the compiled build.", `
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
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
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
                $defaultCompress.SetGenerateReport($true);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

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
                $defaultCompress.SetGenerateReport($false);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Do not Generate Reports


            # Access the Program's Bug Tracker
            #  NOTE: Allow the user's request when they type: 'Report' or '#'.
            {($_ -eq "#") -or `
                ($_ -eq "Report")}
            {
                # Open the webpage as requested
                if (![WebsiteResources]::AccessWebSite_General($Global:_PROGRAMREPORTBUGORFEATURE_,             ` # Program's Bug Tracker
                                                            "$($GLOBAL:_PROGRAMNAMESHORT_) Bug Tracker"))       ` # Show page title
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
} # SettingsZip