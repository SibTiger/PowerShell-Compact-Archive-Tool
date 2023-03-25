<# PowerShell Compact-Archive Tool
 # Copyright (C) 2023
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
            [Settings7Zip]::__DrawMenu();

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequest($userInput);
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
        [string] $currentSettingCompressionLevel = $NULL;           # Compression Level
        [string] $currentSettingVerifyBuild = $NULL;                # Verify Build
        [string] $currentSettingGenerateReport = $NULL;             # Generate Report
        [string] $currentSettingGenerateReportPDF = $NULL;          # Generate PDF Report
        [string] $currentSettingCompressionMethod = $NULL;          # Compression Method

        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuLocate7Zip = $true;             # Locate 7Zip
        [bool] $showMenuCompressionMethod = $true;      # Compression Method
        [bool] $showMenuZipAlgorithms = $true;          # Zip Algorithms
        [bool] $showMenu7ZipAlgorithms = $true;         # 7Zip Algorithms
        [bool] $showMenuCompressionLevel = $true;       # Compression Level
        [bool] $showMenuVerifyBuild = $true;            # Verify Build
        [bool] $showMenuGenerateReport = $true;         # Generate Report
        [bool] $showMenuUseTool = $true;                # Use 7Zip functionality

        # Retrieve the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Retrieve the current settings and determine the wording before we generate the menu.
        [Settings7Zip]::__DrawMenuDecipherCurrentSettings([ref] $currentSettingCompressionMethod, `             # Compression Level
                                                            [ref] $currentSettingCompressionLevel, `            # Compression Level
                                                            [ref] $currentSettingVerifyBuild, `                 # Verify Build
                                                            [ref] $currentSettingGenerateReport, `              # Generate Report
                                                            [ref] $currentSettingGenerateReportPDF);            # Generate PDF Report


        # Determine what menus are to be displayed to the user.
        [Settings7Zip]::__DrawMenuDetermineHiddenMenus([ref] $showMenuLocate7Zip, `             # Locate 7Zip
                                                        [ref] $showMenuCompressionMethod, `     # Compression Method
                                                        [ref] $showMenuZipAlgorithms, `         # Zip Algorithms
                                                        [ref] $showMenu7ZipAlgorithms, `        # 7Zip Algorithms
                                                        [ref] $showMenuCompressionLevel, `      # Compression Level
                                                        [ref] $showMenuVerifyBuild, `           # Verify Build
                                                        [ref] $showMenuGenerateReport, `        # Generate Report
                                                        [ref] $showMenuUseTool);                # Use 7Zip functionality



        # Display the menu list


        # Ask the user if they wish to change compression software
        if (!($showMenuUseTool))
        {
            [CommonCUI]::DrawMenuItem('7', `
                                    "7Zip", `
                                    "Use 7Zip's functionality to create ZDoom PK3 or PK7 WAD files.", `
                                    $NULL, `
                                    $true);
        } # if : Ask to Use Tool


        # Find the 7Zip Application
        if ($showMenuLocate7Zip)
        {
            [CommonCUI]::DrawMenuItem('B', `
                                    "Locate the 7Zip Application", `
                                    "Find the 7Zip application on your computer.", `
                                    "7Zip is located at: $($sevenZip.GetExecutablePath())", `
                                    $true);
        } # If: Show Locate 7Zip


        # Select a Compression Method
        if ($showMenuCompressionMethod)
        {
            [CommonCUI]::DrawMenuItem('S', `
                                    "Select Compression Method", `
                                    "Allows the ability to compact data using either Zip or 7Zip technology.", `
                                    "Use the desired Compression Method: $($currentSettingCompressionMethod)", `
                                    $true);
        } # If: Show Compression Method


        # Select a Zip Algorithm
        if ($showMenuZipAlgorithms)
        {
            [CommonCUI]::DrawMenuItem('Z', `
                                    "Change Zip Algorithms", `
                                    "Allows the ability to use a different algorithm while using the Zip Compression Method", `
                                    "Current Zip Algorithm: $($sevenZip.GetAlgorithmZip())", `
                                    $true);
        } # If: Show Zip Algorithm


        # Select a 7Zip Algorithm
        if ($showMenu7ZipAlgorithms)
        {
            [CommonCUI]::DrawMenuItem('7', `
                                    "Change 7Zip Algorithm", `
                                    "Allows the ability to use a different algorithm while using the 7Zip Compression Method", `
                                    "Current 7Zip Algorithm: $($sevenZip.GetAlgorithm7Zip())", `
                                    $true);
        } # If: Show 7Zip Algorithm


        # Specify Compression Level
        if ($showMenuCompressionLevel)
        {
            [CommonCUI]::DrawMenuItem('C', `
                                    "Compression Level", `
                                    "How tightly is the data going to be compacted into the compressed file.", `
                                    "Compression level to use: $($currentSettingCompressionLevel)", `
                                    $true);
        } # If: Show Compression Level


        # Toggle the ability to check file's integrity
        if ($showMenuVerifyBuild)
        {
            [CommonCUI]::DrawMenuItem('V', `
                                    "Verify Build after Compression", `
                                    "Assure that the data within the compressed file is healthy.", `
                                    "Verify integrity of the newly generated build: $($currentSettingVerifyBuild)", `
                                    $true);
        } # If: Show Verify Build


        # Allow or disallow the ability to generate a report
        if ($showMenuGenerateReport)
        {
            [CommonCUI]::DrawMenuItem('R', `
                                    "Generate Report of the Archive Datafile", `
                                    "Provides a detailed report regarding the newly generated compressed file.", `
                                    "Create a report of the newly generated build: $($currentSettingGenerateReport) $($currentSettingGenerateReportPDF)", `
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
    #  [string] (REFERENCE) Compression Method
    #   Determines which compression method will be used, either 7Zip or Zip.
    #  [string] (REFERENCE) Compression Level
    #   Determines the current compression level that is presently configured.
    #  [string] (REFERENCE) Verify Build
    #   Determines if the newly generated build will be tested to assure its integrity.
    #  [string] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the newly generated report of the
    #    newly generated compressed build.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDecipherCurrentSettings([ref] $compressionMethod, `          # Compression Method
                                                            [ref] $compressionLevel, `          # Compression Level
                                                            [ref] $verifyBuild, `               # Verify Build
                                                            [ref] $generateReport, `            # Generate Report
                                                            [ref] $generateReportPDF)           # Generate PDF Report
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Compression Method
        switch ($sevenZip.GetCompressionMethod())
        {
            # Use Zip
            ([SevenZipCompressionMethod]::Zip)
            {
                # Set the string that will be displayed
                $compressionMethod.Value = "Zip [PK3]";

                # Break from the switch
                break;
            } # Use Zip


            # Use 7Zip
            ([SevenZipCompressionMethod]::SevenZip)
            {
                # Set the string that will be displayed
                $compressionMethod.Value = "7Zip [PK7]";

                # Break from the switch
                break;
            } # Use 7Zip


            # Unknown case
            Default
            {
                # Set the string that will be displayed
                $compressionMethod.Value = "ERROR";

                # Break from the switch
                break;
            } # Error Case
        } # Switch : Decipher Enumerator Value



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # Compression Level
        switch ($sevenZip.GetCompressionLevel())
        {
            # Store; no compression
            ([SevenZipCompressionLevel]::Store)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "No Compression";

                # Break from the switch
                break;
            } # Store - No Compression


            # Minimal Compression
            ([SevenZipCompressionLevel]::Minimal)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "Fastest Compression";

                # Break from the switch
                break;
            } # Minimal Compression


            # Normal Compression
            ([SevenZipCompressionLevel]::Normal)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "Standard Compression";

                # Break from the switch
                break;
            } # Normal Compression


            # Maximum Compression
            ([SevenZipCompressionLevel]::Maximum)
            {
                # Set the string that will be displayed
                $compressionLevel.Value = "Optimal Compression";

                # Break from the switch
                break;
            } # Maximum Compression


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
        if ($sevenZip.GetVerifyBuild())
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
        if ($sevenZip.GetGenerateReport())
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



        # Generate PDF Report
        # Provide a new PDF report regarding the newly generated archive file
        if ($sevenZip.GetGenerateReportFilePDF() -and `
            $sevenZip.GetGenerateReport())
        {
            # The user wants to have a PDF report generated regarding the archive datafile.
            $generateReportPDF.Value = "[PDF]";
        } # if: Create PDF report

        # Do not provide a PDF report regarding the newly generated archive file.
        else
        {
            # The user does not want to have a report generated of the archive datafile.
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
    #  [bool] (REFERENCE) Locate 7Zip
    #   Browse for the 7Zip Application on the host system.
    #  [bool] (REFERENCE) Compression Method
    #   Provides the ability for the user to switch between Zip and 7Zip.
    #  [bool] (REFERENCE) Zip Algorithm
    #   Provides the ability to use a specific Zip Algorithm.
    #  [bool] (REFERENCE) 7Zip Algorithm
    #   Provides the ability to use a specific 7Zip Algorithm.
    #  [bool] (REFERENCE) Compression Level
    #   Determines how tightly to compact the data within the archive datafile.
    #  [bool] (REFERENCE) Verify Build
    #   Determines if the archive datafile is to undergo an integrity check.
    #  [bool] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the project's latest developments.
    #  [bool] (REFERENCE) Use Tool
    #   Determines if the 7Zip application functionality had been enabled.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuDetermineHiddenMenus([ref] $showMenuLocate7Zip, `            # Locate 7Zip
                                                        [ref] $showMenuCompressionMethod, `     # Compression Method
                                                        [ref] $showMenuZipAlgorithms, `         # Zip Algorithms
                                                        [ref] $showMenu7ZipAlgorithms, `        # 7Zip Algorithms
                                                        [ref] $showMenuCompressionLevel, `      # Compression Level
                                                        [ref] $showMenuVerifyBuild, `           # Verify Build
                                                        [ref] $showMenuGenerateReport, `        # Generate Report
                                                        [ref] $showMenuUseTool)                 # Use 7Zip functionality
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # Retrieve the User Preferences object
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------



        # Are we able to locate the 7Zip application?
        if (!([CommonFunctions]::IsAvailable7Zip()))
        {
            # Because we were not able to find the 7Zip application, hide all options associated
            #   with 7Zip's configuration.
            $showMenuCompressionMethod.Value    = $false;       # Compression Method
            $showMenuZipAlgorithms.Value        = $false;       # Zip Algorithms
            $showMenu7ZipAlgorithms.Value       = $false;       # 7Zip Algorithms
            $showMenuCompressionLevel.Value     = $false;       # Compression Level
            $showMenuVerifyBuild.Value          = $false;       # Verify Build
            $showMenuGenerateReport.Value       = $false;       # Generate Report
            $showMenuUseTool.Value              = $true;        # Use Tool


            # Allow the user to locate the 7Zip Executable
            $showMenuLocate7Zip.Value           = $true;       # Browse 7Zip software


            # Finished
            return;
        } # if : Unable to find 7Zip



        # Is the user utilizing some other compression software tool?
        if ($userPreferences.GetCompressionTool() -ne [UserPreferencesCompressTool]::SevenZip)
        {
            # Because the user is using another compression software, hide all options associated with this tool.
            $showMenuLocate7Zip.Value           = $false;       # Browse 7Zip software
            $showMenuCompressionMethod.Value    = $false;       # Compression Method
            $showMenuZipAlgorithms.Value        = $false;       # Zip Algorithms
            $showMenu7ZipAlgorithms.Value       = $false;       # 7Zip Algorithms
            $showMenuCompressionLevel.Value     = $false;       # Compression Level
            $showMenuVerifyBuild.Value          = $false;       # Verify Build
            $showMenuGenerateReport.Value       = $false;       # Generate Report


            # Ask the user if they wish to change settings.
            $showMenuUseTool.Value              = $false;       # Use Tool


            # Finished
            return;
        } # if : Not using 7Zip Functionality



        # If we made it here, then that would indicate that the user is presently utilizing the 7Zip software.
        #   Show the menu items that are associated with the 7Zip application, however some menu items may be
        #   hidden due to dependent options.


        $showMenuLocate7Zip.Value           = $false;      # Browse 7Zip software
        $showMenuCompressionMethod.Value    = $true;       # Compression Method
        $showMenuCompressionLevel.Value     = $true;       # Compression Level
        $showMenuVerifyBuild.Value          = $true;       # Verify Build
        $showMenuGenerateReport.Value       = $true;       # Generate Report
        $showMenuUseTool.Value              = $true;       # Use Tool



        # - - - - - - - - - - - - - - - - - - - - - -
        # - - - - - - - - - - - - - - - - - - - - - -



        # 7Zip \ Zip Algorithms
        #  Show the 7Zip Algorithm if and only if the Compression Method is set to _7Zip_.
        #  Show the Zip Algorithm if and only if the Compression Method is set to _Zip_.
        if ($sevenZip.GetCompressionMethod() -eq [SevenZipCompressionMethod]::Zip)
        {
            $showMenu7ZipAlgorithms.Value   = $false;   # Hide 7Zip Algo.
            $showMenuZipAlgorithms.Value    = $true;    # Show Zip Algo.
        } # If: Zip Algorithm is Visible

        # 7Zip Algorithm is Visible
        else
        {
            $showMenu7ZipAlgorithms.Value   = $true;    # Show 7Zip Algo.
            $showMenuZipAlgorithms.Value    = $false;   # Hide Zip Algo.
        } # Else: 7Zip Algorithm is Visible
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
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();


        # These variables will determine what menus are to be hidden from the user,
        #  as the options are possibly not available or not ready for the user to
        #  configure.
        [bool] $showMenuLocate7Zip = $true;             # Locate 7Zip
        [bool] $showMenuCompressionMethod = $true;      # Compression Method
        [bool] $showMenuZipAlgorithms = $true;          # Zip Algorithms
        [bool] $showMenu7ZipAlgorithms = $true;         # 7Zip Algorithms
        [bool] $showMenuCompressionLevel = $true;       # Compression Level
        [bool] $showMenuVerifyBuild = $true;            # Verify Build
        [bool] $showMenuGenerateReport = $true;         # Generate Report
        [bool] $showMenuUseTool = $true;                # Use 7Zip functionality
        # ----------------------------------------


        # Determine what menus are available to the user.
        [Settings7Zip]::__DrawMenuDetermineHiddenMenus([ref] $showMenuLocate7Zip, `             # Locate 7Zip
                                                        [ref] $showMenuCompressionMethod, `     # Compression Method
                                                        [ref] $showMenuZipAlgorithms, `         # Zip Algorithms
                                                        [ref] $showMenu7ZipAlgorithms, `        # 7Zip Algorithms
                                                        [ref] $showMenuCompressionLevel, `      # Compression Level
                                                        [ref] $showMenuVerifyBuild, `           # Verify Build
                                                        [ref] $showMenuGenerateReport, `        # Generate Report
                                                        [ref] $showMenuUseTool);                # Use 7Zip functionality



        switch ($userRequest)
        {
            # Use Tool
            #  NOTE: Allow the user's request when they type: "7Zip", "7Z", as well as "7"
            {((($showMenuUseTool) -eq $false) -and `
                (($_ -eq "7") -or `
                 ($_ -eq "7Zip") -or `
                 ($_ -eq "7Z")))}
            {
                # The user had selected to use the 7Zip Compression Tool.
                $userPreferences.SetCompressionTool([UserPreferencesCompressTool]::SevenZip);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected 7Zip



            # Browse for 7Zip
            #  NOTE: Allow the user's request when they type: 'Browse for 7Zip', 'Find 7Zip',
            #           'Locate 7Zip', 'Browse 7Zip', as well as 'B'.
            {($showMenuLocate7Zip) -and `
                (($_ -eq "B") -or `
                    ($_ -eq "Browse for 7Zip") -or `
                    ($_ -eq "Find 7Zip") -or `
                    ($_ -eq "Locate 7Zip") -or `
                    ($_ -eq "Browse 7Zip"))}
            {
                # Allow the user to locate the path to 7Zip or verify 7Zip's path.
                [Settings7Zip]::__Locate7ZipPath();


                # Finished
                break;
            } # Browse for 7Zip



            # Compression Method
            #  NOTE: Allow the user's request when they type: 'Compression Method' and 'S'.
            {($showMenuCompressionMethod) -and `
                (($_ -eq "S") -or `
                    ($_ -eq "Compression Method"))}
            {
                # Allow the user to configure the compression method when using 7Zip.
                [Settings7Zip]::__CompressionMethod();


                # Finished
                break;
            } # Compression Method



            # Zip Algorithm
            #  NOTE: Allow the user's request when they type: 'Zip Algorithm' and 'Z'.
            {($showMenuZipAlgorithms) -and `
                (($_ -eq "Z") -or `
                    ($_ -eq "Zip Algorithm"))}
            {
                # Allow the user to configure the Zip algorithm
                [Settings7Zip]::__AlgorithmsZip();


                # Finished
                break;
            } # Zip Algorithm



            # 7Zip Algorithm
            #  NOTE: Allow the user's request when they type: '7Zip Algorithm' and '7'.
            {($showMenu7ZipAlgorithms) -and `
                (($_ -eq "7") -or `
                    ($_ -eq "7Zip Algorithm"))}
            {
                # Allow the user to configure the 7Zip algorithm
                [Settings7Zip]::__Algorithms7Zip();


                # Finished
                break;
            } # 7Zip Algorithm



            # Compression Level
            #  NOTE: Allow the user's request when they type: 'Compression Level' and 'C'.
            {($showMenuCompressionLevel) -and `
                (($_ -eq "C") -or `
                    ($_ -eq "Compression Level"))}
            {
                # Allow the user to customize the compression level while using 7Zip.
                [Settings7Zip]::__CompressionLevel();


                # Finished
                break;
            } # Compression Level



            # Verify Build after Compression
            #  NOTE: Allow the user's request when they type: 'Verify Build after Compression', 'Verify',
            #           'Verify Build', 'Test Build', 'Test', as well as 'V'.
            {($showMenuVerifyBuild) -and `
                (($_ -eq "V") -or `
                    ($_ -eq "Verify Build after Compression") -or `
                    ($_ -eq "Verify") -or `
                    ($_ -eq "Verify Build") -or `
                    ($_ -eq "Test Build") -or `
                    ($_ -eq "Test"))}
            {
                # Allow the user the ability to verify a newly generated project build.
                [Settings7Zip]::__VerifyBuild();


                # Finished
                break;
            } # Verify Build after Compression



            # Generate Report of Archive Datafile
            #  NOTE: Allow the user's request when they type: 'Report', 'Generate Report',
            #           'Generate Report of Archive Datafile', as well as 'R'.
            {($showMenuGenerateReport) -and `
                (($_ -eq "R") -or `
                    ($_ -eq "Generate Report") -or `
                    ($_ -eq "Report") -or `
                    ($_ -eq "Generate Report of Archive Datafile"))}
            {
                # Allow the user the ability to request reports for the newly generated archive datafile.
                [Settings7Zip]::__GenerateReport();


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
    hidden static [void] __Locate7ZipPath()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
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
            if ($sevenZip.Detect7ZipExist())
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
                [Logging]::DisplayMessage("I cannot find the 7Zip application within the provided path:");
            } # Else: 7Zip's path was not found


            # Output the project's path
            [Logging]::DisplayMessage("`t$($sevenZip.GetExecutablePath())");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::__DrawMenuLocate7ZipPath();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestLocate7ZipPath($userInput);
        } while ($menuLoop);
    } # __Locate7ZipPath()




   <# Draw Menu: Locate 7Zip Path
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Locate 7Zip Path to the user.
    #   thus this provides what options are available to the user in order to configure the 7Zip
    #   path.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuLocate7ZipPath()
    {
        # Display the Menu List

        # Automatically find 7Zip
        [CommonCUI]::DrawMenuItem('A', `
                                "Automatically find 7Zip", `
                                "Try to automatically find the 7Zip application.", `
                                $NULL, `
                                $true);


        # Manually find 7Zip
        [CommonCUI]::DrawMenuItem('M', `
                                "Manually find 7Zip", `
                                "Manually locate the 7Zip application.", `
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
    } # __DrawMenuLocate7ZipPath()




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
    hidden static [bool] __EvaluateExecuteUserRequestLocate7ZipPath([string] $userRequest)
    {
        # Evaluate the user's request
        switch ($userRequest)
        {
            # Automatically find 7Zip
            #  NOTE: Allow the user's request when they type: 'Automatically find 7Zip',
            #           'Automatically find', 'Automatically', 'Automatic', as well as 'A'.
            {($_ -eq "A") -or `
                ($_ -eq "Automatically find 7Zip") -or `
                ($_ -eq "Automatically find") -or `
                ($_ -eq "Automatically") -or `
                ($_ -eq "Automatic")}
            {
                # Try to find the 7Zip Application automatically.
                [Settings7Zip]::__Locate7ZipPathAutomatically();

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Automatically Find 7Zip



            # Manually find 7Zip
            #  NOTE: Allow the user's request when they type: 'Manually Find 7Zip',
            #           'Manually', 'Manual', as well as 'M'.
            {($_ -eq "M") -or `
                ($_ -eq "Manually Find 7Zip") -or `
                ($_ -eq "Manually") -or `
                ($_ -eq "Manual")}
            {
                # Find the 7Zip Application manually.
                [Settings7Zip]::__Locate7ZipPathManually();

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Manually Find 7Zip



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
    } # __EvaluateExecuteUserRequestLocate7ZipPath()




   <# Configure Locate 7Zip Path Automatically
    # -------------------------------
    # Documentation:
    #  This function will try to find the 7Zip application automatically
    #   for the user.
    # -------------------------------
    #>
    hidden static [void] __Locate7ZipPathAutomatically()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the results provided by the 7Zip Finder.
        [string] $find7ZipResults = $null;

        # Instantiate the 7Zip Object so that we may utilize the
        #  functions and properties as needed.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Capture the results from the finder
        $find7ZipResults = $sevenZip.Find7Zip();


        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Now that we have the results from the finder, now determine
        #  if we were able to automatically detect the 7Zip Application.
        if ($null -eq $find7ZipResults)
        {
            # Alert the user that the path is incorrect.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Because we are unable to find 7Zip automatically, there's
            #  really nothing that we can do.
            [Logging]::DisplayMessage("Unable to find the 7Zip application!`r`nPlease be sure that it had been properly installed on your system!");
        } # If : Cannot Find 7Zip Automatically


        # We were able to obtain a new location of where the 7Zip Application resides within the system.
        else
        {
            # Because we were able to find the 7Zip application, we can use the new value.
            $sevenZip.SetExecutablePath($find7ZipResults);

            # Let the user know that we were able to successfully find the 7Zip Application
            [Logging]::DisplayMessage("Successfully found the 7Zip Application in:`r`n$($find7ZipResults)");
        } # Else: Found 7Zip


        # Wait for the user to provide feedback; thus allowing the user to read the message.
        [logging]::GetUserEnterKey();
    } # __Locate7ZipPathAutomatically()




   <# Configure Locate 7Zip Path Manually
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to manually configure
    #   the path of the 7Zip directory.
    # -------------------------------
    #>
    hidden static [void] __Locate7ZipPathManually()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will temporarily hold the user's requested path; if the path is valid -
        #  then we will use the value already given from this variable to store it to the
        #  7Zip Path variable.
        [System.Collections.ArrayList] $newPath = [System.Collections.ArrayList]::new();

        # We will use this instance so that we can apply the new location to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------



        # Provide some extra spacing as we will continue to use the same content
        #  area without clearing the terminal screen.  Thus, we are going to move
        #  a few lines down and apply the newer content below.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine if the path that were provided is valid and can be used by the program.
        if ([UserExperience]::BrowseForFile("Provide full path to 7Zip.exe",            ` # Title
                                            "exe",                                      ` # Extension we are wanting
                                            "Executable (*.exe) | *.exe",               ` # Additional Extensions
                                            $false,                                     ` # Select multiple files
                                            [BrowserInterfaceStyle]::Modern,            ` # GUI Style
                                            $newPath))                                  ` # Selected files
        {
            # Because the path is valid, we will use the requested target directory.
            $sevenZip.SetExecutablePath($newPath[0]);
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
    } # __Locate7ZipPathManually()
    #endregion





    #region Compression Method
    #                                    Compression Method
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compression Method
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to decide which compression methodology
    #   will be used when compacting a project's source into an archive datafile.
    # -------------------------------
    #>
    hidden static [void] __CompressionMethod()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Compression Method Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Compression Methodology variable, then make it easier for
            #  the user to understand the current setting.
            switch ($sevenZip.GetCompressionMethod())
            {
                ([SevenZipCompressionMethod]::Zip)
                {
                    # Set the message such that the user knows that 'Zip' is presently set.
                    $decipherNiceString = "I will have 7Zip create Zip archive datafiles while compiling new builds.";

                    # Finished
                    break;
                } # Zip

                ([SevenZipCompressionMethod]::SevenZip)
                {
                    # Set the message such that the user knows that '7Zip' is presently set.
                    $decipherNiceString = "I will have 7Zip create 7Zip archive datafiles while compiling new builds.";

                    # Finished
                    break;
                } # 7Zip
            } # Switch: Decipher Compression Method



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Compression Method menu
            [CommonCUI]::DrawSectionHeader("Compression Method");

            # Show to the user the current state of the 'Compression Method' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::__DrawMenuCompressionMethod();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestCompressionMethod($userInput);
        } while ($menuLoop);
    } # CompressionMethod()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Method to the user.
    #   Thus, this provides what options are available in relation to the Compression Method in 7Zip.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuCompressionMethod()
    {
        # Display the Menu List

        # 7Zip Compression Data Structure
        [CommonCUI]::DrawMenuItem('7', `
                                "7Zip", `
                                "Use 7Zip compression to create PK7 files.", `
                                "Offers the best compression possible, but retrieving resources at run-time takes much longer.", `
                                $true);


        # Zip Compression Data Structure
        [CommonCUI]::DrawMenuItem('Z', `
                                "Zip", `
                                "Use Zip compression to create PK3 files.", `
                                "Provides the best run-time experience, but compression will not be as strong as 7Zip files.", `
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
    } # __DrawMenuCompressionMethod()




   <# Evaluate and Execute User's Request: Compression Method
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
    hidden static [bool] __EvaluateExecuteUserRequestCompressionMethod([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change to 7Zip Compression Method
            #  NOTE: Allow the user's request when they type: '7Zip', '7Z', '7Za', as well as '7'.
            {($_ -eq "7") -or `
                ($_ -eq "7Zip") -or `
                ($_ -eq "7Z") -or `
                ($_ -eq "7Za")}
            {
                # Use the 7Zip Compression Methodology
                $sevenZip.SetCompressionMethod([SevenZipCompressionMethod]::SevenZip);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected 7Zip Compression


            # Change to Zip Compression Method
            #  NOTE: Allow the user's request when they type: 'Zip' or 'Z'.
            {($_ -eq "Z") -or `
                ($_ -eq "Zip")}
            {
                # Use the Zip Compression Methodology
                $sevenZip.SetCompressionMethod([SevenZipCompressionMethod]::Zip);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Zip Compression


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
    } # __EvaluateExecuteUserRequestCompressionMethod()
    #endregion





    #region Algorithms using Zip
    #                                    Algorithms using Zip
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Algorithms Zip
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to determine which algorithm will be enabled
    #  while utilizing the Zip Compression Methodology within the program.
    # -------------------------------
    #>
    hidden static [void] __AlgorithmsZip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Algorithm Zip Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Algorithm Zip variable, then make it easier for
            #  the user to understand the current setting.
            switch ($sevenZip.GetAlgorithmZip())
            {
                ([SevenZipAlgorithmZip]::Deflate)
                {
                    # Set the message such that the user knows that the 'Deflate' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the Deflate algorithm when compiling new Zip builds.";

                    # Finished
                    break;
                } # Deflate

                ([SevenZipAlgorithmZip]::LZMA)
                {
                    # Set the message such that the user knows that the 'LZMA' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the LZMA algorithm when compiling new Zip builds.";

                    # Finished
                    break;
                } # LZMA

                ([SevenZipAlgorithmZip]::BZip2)
                {
                    # Set the message such that the user knows that the 'BZip2' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the BZip2 algorithm when compiling new Zip builds.";

                    # Finished
                    break;
                } # BZip2
            } # Switch: Decipher Algorithm Zip



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Algorithms using Zip menu
            [CommonCUI]::DrawSectionHeader("Algorithms using Zip");

            # Show to the user the current state of the 'Algorithm Zip' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::__DrawMenuAlgorithmZip();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestAlgorithmZip($userInput);
        } while ($menuLoop);
    } # __AlgorithmsZip()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Algorithm Zip to the user.
    #   Thus, this provides what options are available in relation to the Algorithms for Zip in 7Zip.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuAlgorithmZip()
    {
        # Display the Menu List

        # Deflate
        [CommonCUI]::DrawMenuItem('D', `
                                "Deflate", `
                                "Standard compression algorithm; expeditiously compacts files and extracting resources at run-time.", `
                                "Best for: All general media", `
                                $true);


        # LZMA
        [CommonCUI]::DrawMenuItem('L', `
                                "LZMA", `
                                "Fastest ability to immediately decompress files at run-time, while takes much more time to compact files.", `
                                "Best for: All general media", `
                                $true);


        # BZip2
        [CommonCUI]::DrawMenuItem('B', `
                                "BZip2", `
                                "Compresses more efficiently than Deflate, but takes longer to compact the files into a container.", `
                                "Best for: Text files", `
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
    } # __DrawMenuAlgorithmZip()




   <# Evaluate and Execute User's Request: Algorithm Zip
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
    hidden static [bool] __EvaluateExecuteUserRequestAlgorithmZip([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this instance so that we can apply the new changes to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the Zip Algorithm to Deflate
            #  NOTE: Allow the user's request when they type: 'Deflate' or 'D'.
            {($_ -eq "D") -or `
                ($_ -eq "Deflate")}
            {
                # Use the Deflate Algorithm when using the Zip Compression Methodology
                $sevenZip.SetAlgorithmZip([SevenZipAlgorithmZip]::Deflate);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Deflate Algorithm


            # Change the Zip Algorithm to LZMA
            #  NOTE: Allow the user's request when they type: 'LZMA' or 'L'.
            {($_ -eq "L") -or `
                ($_ -eq "LZMA")}
            {
                # Use the LZMA Algorithm when using the Zip Compression Methodology
                $sevenZip.SetAlgorithmZip([SevenZipAlgorithmZip]::LZMA);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected LZMA Compression


            # Change the Zip Algorithm to BZip2
            #  NOTE: Allow the user's request when they type: 'BZip2' or 'B'.
            {($_ -eq "B") -or `
                ($_ -eq "BZip2")}
            {
                # Use the BZip2 Algorithm when using the Zip Compression Methodology
                $sevenZip.SetAlgorithmZip([SevenZipAlgorithmZip]::BZip2);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected BZip2 Compression


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
    } # __EvaluateExecuteUserRequestAlgorithmZip()
    #endregion





    #region Algorithms using 7Zip
    #                                    Algorithms using 7Zip
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Algorithms 7Zip
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to determine which algorithm will be enabled
    #  while utilizing the 7Zip Compression Methodology within the program.
    # -------------------------------
    #>
    hidden static [void] __Algorithms7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave from the menu.
        [bool] $menuLoop = $true;

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Algorithm 7Zip Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Algorithm 7Zip variable, then make it easier for
            #  the user to understand the current setting.
            switch ($sevenZip.GetAlgorithm7Zip())
            {
                ([SevenZipAlgorithm7Zip]::LZMA2)
                {
                    # Set the message such that the user knows that the 'LZMA2' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the LZMA2 algorithm when compiling new 7Zip builds.";

                    # Finished
                    break;
                } # LZMA2


                ([SevenZipAlgorithm7Zip]::LZMA)
                {
                    # Set the message such that the user knows that the 'LZMA' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the LZMA algorithm when compiling new 7Zip builds.";

                    # Finished
                    break;
                } # LZMA


                ([SevenZipAlgorithm7Zip]::BZip2)
                {
                    # Set the message such that the user knows that the 'BZip2' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the BZip2 algorithm when compiling new 7Zip builds.";

                    # Finished
                    break;
                } # BZip2


                ([SevenZipAlgorithm7Zip]::PPMd)
                {
                    # Set the message such that the user knows that the 'PPMd' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the PPMd algorithm when compiling new 7Zip builds.";

                    # Finished
                    break;
                } # PPMd
            } # Switch: Decipher Algorithm 7Zip



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Algorithms using 7Zip menu
            [CommonCUI]::DrawSectionHeader("Algorithms using 7Zip");

            # Show to the user the current state of the 'Algorithm 7Zip' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::__DrawMenuAlgorithm7Zip();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestAlgorithm7Zip($userInput);
        } while ($menuLoop);
    } # __Algorithms7Zip()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Algorithm 7Zip to the user.
    #   Thus, this provides what options are available in relation to the Algorithms for 7Zip in 7Zip.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuAlgorithm7Zip()
    {
        # Display the Menu List

        # LZMA2
        [CommonCUI]::DrawMenuItem('2', `
                                "LZMA2", `
                                "Enhanced version of LZMA; provides multithreading functionalities.", `
                                "Best for: All general media", `
                                $true);


        # LZMA
        [CommonCUI]::DrawMenuItem('L', `
                                "LZMA", `
                                "Fastest ability to immediately decompress files at run-time, while takes much more time to compact files.", `
                                "Best for: All general media", `
                                $true);


        # BZip2
        [CommonCUI]::DrawMenuItem('B', `
                                "BZip2", `
                                "Compresses more efficiently than Deflate, but takes longer to compact the files into a container.", `
                                "Best for: Text files", `
                                $true);


        # PPMd
        [CommonCUI]::DrawMenuItem('P', `
                                "PPMd", `
                                "Compresses text-based data much more efficiently than the BZip2 algorithm, but takes longer to compact.", `
                                "Best for: Text files", `
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
    } # __DrawMenuAlgorithm7Zip()




   <# Evaluate and Execute User's Request: Algorithm 7Zip
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
    hidden static [bool] __EvaluateExecuteUserRequestAlgorithm7Zip([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this instance so that we can apply the new changes to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the 7Zip Algorithm to LZMA2
            #  NOTE: Allow the user's request when they type: 'LZMA2' or '2'.
            {($_ -eq "2") -or `
                ($_ -eq "LZMA2")}
            {
                # Use the LZMA2 Algorithm when using the 7Zip Compression Methodology
                $sevenZip.SetAlgorithm7Zip([SevenZipAlgorithm7Zip]::LZMA2);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected LZMA2 Algorithm


            # Change the 7Zip Algorithm to LZMA
            #  NOTE: Allow the user's request when they type: 'LZMA' or 'L'.
            {($_ -eq "L") -or `
                ($_ -eq "LZMA")}
            {
                # Use the LZMA Algorithm when using the 7Zip Compression Methodology
                $sevenZip.SetAlgorithm7Zip([SevenZipAlgorithm7Zip]::LZMA);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected LZMA Compression


            # Change the 7Zip Algorithm to BZip2
            #  NOTE: Allow the user's request when they type: 'BZip2' or 'B'.
            {($_ -eq "B") -or `
                ($_ -eq "BZip2")}
            {
                # Use the BZip2 Algorithm when using the Zip Compression Methodology
                $sevenZip.SetAlgorithm7Zip([SevenZipAlgorithm7Zip]::BZip2);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected BZip2 Compression


            # Change the 7Zip Algorithm to PPMd
            #  NOTE: Allow the user's request when they type: 'PPMd' or 'P'.
            {($_ -eq "P") -or `
                ($_ -eq "PPMd")}
            {
                # Use the PPMd Algorithm when using the 7Zip Compression Methodology
                $sevenZip.SetAlgorithm7Zip([SevenZipAlgorithm7Zip]::PPMd);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected PPMd Compression


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
    } # __EvaluateExecuteUserRequestAlgorithm7Zip()
    #endregion





    #region Compression Level
    #                                     Compression Level
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# Compression Level
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to determine which compression level will
    #   be used during the compiling operation.
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

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # We will use this variable to make the string that is displayed to the user - a bit easier to read.
        #  Further, we could use a simple if conditional statement below where we ultimately just display the
        #  results, but lets keep the code nicer to read for our own benefit instead.
        [string] $decipherNiceString = $null;
        # ----------------------------------------


        # Open the Compression Level Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Compression Level enumerator value, then make it easier for
            #  the user to understand the current setting.
            switch ($sevenZip.GetCompressionLevel())
            {
                ([SevenZipCompressionLevel]::Store)
                {
                    # Set the message such that the user knows that the compression level is set to "Store".
                    $decipherNiceString = "I will have 7Zip only store the contents into an compiled build.";

                    # Finished
                    break;
                } # Store


                ([SevenZipCompressionLevel]::Minimal)
                {
                    # Set the message such that the user knows that the compression level is set to "Minimal".
                    $decipherNiceString = "I will have 7Zip use minimal compression while compiling the project build.";

                    # Finished
                    break;
                } # Minimal


                ([SevenZipCompressionLevel]::Normal)
                {
                    # Set the message such that the user knows that the compression level is set to "Normal".
                    $decipherNiceString = "I will have 7Zip use normal compression while compiling the project build.";

                    # Finished
                    break;
                } # Normal


                ([SevenZipCompressionLevel]::Maximum)
                {
                    # Set the message such that the user knows that the compression level is set to "Maximum".
                    $decipherNiceString = "I will have 7Zip use the maximum possible compression while compiling the project build.";

                    # Finished
                    break;
                } # Maximum
            } # Switch: Decipher Compression Level



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Compression Level menu
            [CommonCUI]::DrawSectionHeader("Compression Level");

            # Show to the user the current state of the 'Compression Level' variable that is presently set within the program.
            [Logging]::DisplayMessage($decipherNiceString);

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::__DrawMenuCompressionLevel();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserCompressionLevel($userInput);
        } while ($menuLoop);
    } # __CompressionLevel()




   <# Draw Menu: Compression Level
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Level to the user.
    #   Thus, this provides a list of available compression levels that are available to the user
    #   while using 7Zip.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuCompressionLevel()
    {
        # Display the Menu List

        # Store
        [CommonCUI]::DrawMenuItem('S', `
                                "Store", `
                                "Do not compress the contents; only store the contents which requires hardly any resources.", `
                                $NULL, `
                                $true);


        # Minimal
        [CommonCUI]::DrawMenuItem('L', `
                                "Minimal", `
                                "Lightly compress the contents; minimal compression requires very little resources.", `
                                $NULL, `
                                $true);


        # Normal
        [CommonCUI]::DrawMenuItem('N', `
                                "Normal", `
                                "Normally compress the contents; normal compression requires the standard use of resources.", `
                                $NULL, `
                                $true);


        # Maximum
        [CommonCUI]::DrawMenuItem('M', `
                                "Maximum", `
                                "Tightly compress the contents; requires more time and resources.", `
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
    } # __DrawMenuCompressionLevel()




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
    hidden static [bool] __EvaluateExecuteUserCompressionLevel([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this instance so that we can apply the new changes to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Change the Compression Level to Store
            #  NOTE: Allow the user's request when they type: 'Store' or 'S'.
            {($_ -eq "S") -or `
                ($_ -eq "Store")}
            {
                # Use the Store Compression Level
                $sevenZip.SetCompressionLevel([SevenZipCompressionLevel]::Store);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Store


            # Change the Compression Level to Minimal
            #  NOTE: Allow the user's request when they type: 'Minimal' or 'L'.
            {($_ -eq "L") -or `
                ($_ -eq "Minimal")}
            {
                # Use the Minimal Compression Level
                $sevenZip.SetCompressionLevel([SevenZipCompressionLevel]::Minimal);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Minimal


            # Change the Compression Level to Normal
            #  NOTE: Allow the user's request when they type: 'Normal' or 'N'.
            {($_ -eq "N") -or `
                ($_ -eq "Normal")}
            {
                # Use the Normal Compression Level
                $sevenZip.SetCompressionLevel([SevenZipCompressionLevel]::Normal);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Normal


            # Change the Compression Level to Maximum
            #  NOTE: Allow the user's request when they type: 'Maximum' or 'M'.
            {($_ -eq "M") -or `
                ($_ -eq "Maximum")}
            {
                # Use the Maximum Compression Level
                $sevenZip.SetCompressionLevel([SevenZipCompressionLevel]::Maximum);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

                # Finished
                break;
            } # Selected Maximum


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
    } # __EvaluateExecuteUserCompressionLevel()
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

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

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
            if ($sevenZip.GetVerifyBuild())
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
            [Settings7Zip]::__DrawMenuVerifyBuild();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestVerifyBuild($userInput);
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
        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
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
                $sevenZip.SetVerifyBuild($true);

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
                $sevenZip.SetVerifyBuild($false);

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

        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

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
            if ($sevenZip.GetGenerateReport())
            {
                # Determine if the PDF is to also be generated
                if ($sevenZip.GetGenerateReportFilePDF())
                {
                    $decipherNiceString = "I will create a PDF report regarding the newly generated compiled project build.";
                } # if : Generate PDF Report

                # If a regular report is to only be generated
                else
                {
                    # Generate Report is presently set as enabled.
                    $decipherNiceString = "I will create a report regarding the newly generated compiled project build.";
                } # else : Generate Report
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
            [Settings7Zip]::__DrawMenuGenerateReport();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::__EvaluateExecuteUserRequestGenerateReport($userInput);
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


        # Generate a new PDF report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('P', `
                                "Generate a PDF report file", `
                                "Generate a new technical PDF report regarding the project's compiled build.", `
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
        # Retrieve the current instance of the 7Zip object; this contains the user's settings
        #  when using the 7Zip application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
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
                $sevenZip.SetGenerateReport($true);

                # The user does not wish to generate PDF reports
                $sevenZip.SetGenerateReportFilePDF($false);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

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
                # The user had selected to have technical reports generated regarding newly compiled project build.
                $sevenZip.SetGenerateReport($true);

                # The user wishes to generate PDF reports
                $sevenZip.SetGenerateReportFilePDF($true);

                # Update the user's configuration with the latest changes.
                [LoadSaveUserConfiguration]::SaveUserConfiguration();

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
                # The user had selected to not have technical reports generated regarding the newly compiled project builds.
                $sevenZip.SetGenerateReport($false);

                # The user does not wish to generate PDF reports
                $sevenZip.SetGenerateReportFilePDF($false);

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
} # Settings7Zip