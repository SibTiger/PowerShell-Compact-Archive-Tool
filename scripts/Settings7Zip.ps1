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
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

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
        # Declarations and Initializations
        # ----------------------------------------
        # Here are some variables that are used to help the user to understand the
        #  meaning behind a particular setting.  Thus, instead of saying "True" or
        #  an enumerator value that is not easy to decipher, we can break it down in
        #  a way that it is easier to convey the point across to the user.
        [string] $currentSettingCompressionLevel = $NULL;           # Compression Level
        [string] $currentSettingVerifyBuild = $NULL;                # Verify Build
        [string] $currentSettingGenerateReport = $NULL;             # Generate Report
        [string] $currentSettingMultithreadedOperations = $NULL;    # Multithreaded Operations
        [string] $currentSettingCompressionMethod = $NULL;          # Compression Method

        # Retrieve the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Retrieve the current settings and determine the wording before we generate the menu.
        [Settings7Zip]::DrawMenuDecipherCurrentSettings([ref] $currentSettingCompressionMethod, `           # Compression Level
                                                        [ref] $currentSettingMultithreadedOperations, `     # Multithreaded Operations
                                                        [ref] $currentSettingCompressionLevel, `            # Compression Level
                                                        [ref] $currentSettingVerifyBuild, `                 # Verify Build
                                                        [ref] $currentSettingGenerateReport);               # Generate Report



        # Display the menu list


        # Find the 7Zip Application
        [CommonCUI]::DrawMenuItem('B', `
                                "Locate the 7Zip Application", `
                                "Find the 7Zip application on your computer.", `
                                "7Zip is located at: $($sevenZip.GetExecutablePath())", `
                                $true);


        # Select a Compression Method
        [CommonCUI]::DrawMenuItem('S', `
                                "Select Compression Method", `
                                "Allows the ability to compact data using either Zip or 7Zip technology.", `
                                "Use the desired Compression Method: $($currentSettingCompressionMethod)", `
                                $true);


        # Select a Zip Algorithm
        [CommonCUI]::DrawMenuItem('Z', `
                                "Change Zip Algorithms", `
                                "Allows the ability to use a different algorithm while using the Zip Compression Method", `
                                "Current Zip Algorithm: $($sevenZip.GetAlgorithmZip())", `
                                $true);


        # Select a 7Zip Algorithm
        [CommonCUI]::DrawMenuItem('7', `
                                "Change 7Zip Algorithm", `
                                "Allows the ability to use a different algorithm while using the 7Zip Compression Method", `
                                "Current 7Zip Algorithm: $($sevenZip.GetAlgorithm7Zip())", `
                                $true);


        # Allow or disallow the ability to use Multithreading
        [CommonCUI]::DrawMenuItem('M', `
                                "Multithread Operations", `
                                "Provides the ability to use more than one core or microprocessor.", `
                                "Multithreaded Operations is presently: $($currentSettingMultithreadedOperations)", `
                                $true);


        # Specify Compression Level
        [CommonCUI]::DrawMenuItem('C',
                                "Compression Level",
                                "How tightly is the data going to be compacted into the compressed file.",
                                "Compression level to use: $($currentSettingCompressionLevel)", `
                                $true);


        # Toggle the ability to check file's integrity
        [CommonCUI]::DrawMenuItem('V',
                                "Verify Build after Compression",
                                "Assure that the data within the compressed file is healthy.",
                                "Verify integrity of the newly generated build: $($currentSettingVerifyBuild)", `
                                $true);


        # Allow or disallow the ability to generate a report
        [CommonCUI]::DrawMenuItem('R',
                                "Generate Report of the Archive Datafile",
                                "Provides a detailed report regarding the newly generated compressed file.",
                                "Create a report of the newly generated build: $($currentSettingGenerateReport)", `
                                $true);


        # Help Documentation
        [CommonCUI]::DrawMenuItem('?',
                                "Help Documentation",
                                "Access the $($GLOBAL:_PROGRAMNAMESHORT_) Wiki documentation online.", `
                                "$($NULL)", `
                                $true);


        # Return back to the Main Menu
        [CommonCUI]::DrawMenuItem('X',
                                "Go back to previous Menu",
                                "$($NULL)",
                                "$($NULL)", `
                                $true);


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n");
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
    #  [string] (REFERENCE) Compression Method
    #   Determines which compression method will be used, either 7Zip or Zip.
    #  [string] (REFERENCE) Multithreaded Operations
    #   Specifies if 7Zip can utilize more than just one Core\Microprocessor from the host.
    #  [string] (REFERENCE) Compression Level
    #   Determines the current compression level that is presently configured.
    #  [string] (REFERENCE) Verify Build
    #   Determines if the newly generated build will be tested to assure its integrity.
    #  [string] (REFERENCE) Generate Report
    #   Determines if the user wanted a report of the newly generated report of the
    #    newly generated compressed build.
    # -------------------------------
    #>
    hidden static [void] DrawMenuDecipherCurrentSettings([ref] $compressionMethod, `        # Compression Method
                                                        [ref] $multithreadedOperations, `   # Multithreaded Operations
                                                        [ref] $compressionLevel, `          # Compression Level
                                                        [ref] $verifyBuild, `               # Verify Build
                                                        [ref] $generateReport)              # Generate Report
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



        # Multithreaded Operations
        # Allow 7Zip to use more than one Core\Microprocessor
        if($sevenZip.GetUseMultithread())
        {
            # Set the string that will be displayed
            $multithreadedOperations.Value = "Yes";
        } # if: Use more than one Core\Processor

        # Do not allow 7Zip to use more than one Core\Microprocessor
        else
        {
            # Set the string that will be displayed
            $multithreadedOperations.Value = "No";
        } # else: Do not use more than one Core\Processor



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
    } # DrawMenuDecipherCurrentSettings()




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
                # Allow the user to configure the compression method when using 7Zip.
                [Settings7Zip]::CompressionMethod();


                # Finished
                break;
            } # Compression Method



            # Zip Algorithm
            #  NOTE: Allow the user's request when they type: 'Zip Algorithm' and 'Z'.
            {($_ -eq "Z") -or `
                ($_ -eq "Zip Algorithm")}
            {
                # Allow the user to configure the Zip algorithm
                [Settings7Zip]::AlgorithmsZip()


                # Finished
                break;
            } # Zip Algorithm



            # 7Zip Algorithm
            #  NOTE: Allow the user's request when they type: '7Zip Algorithm' and '7'.
            {($_ -eq "7") -or `
                ($_ -eq "7Zip Algorithm")}
            {
                # Allow the user to configure the 7Zip algorithm
                [Settings7Zip]::Algorithms7Zip()


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
                # Allow the user to enable or disable the Multithread feature in 7Zip
                [Settings7Zip]::UseMultithread();


                # Finished
                break;
            } # Multithreaded Operations



            # Compression Level
            #  NOTE: Allow the user's request when they type: 'Compression Level' and 'C'.
            {($_ -eq "C") -or `
                ($_ -eq "Compression Level")}
            {
                # Allow the user to customize the compression level while using 7Zip.
                [Settings7Zip]::CompressionLevel();


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
                # Allow the user the ability to verify a newly generated project build.
                [Settings7Zip]::VerifyBuild();


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
                # Allow the user the ability to request reports for the newly generated archive datafile.
                [SettingsZip]::GenerateReport();


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
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

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

        # Automatically find 7Zip
        [CommonCUI]::DrawMenuItem('A', `
                                "Automatically find 7Zip", `
                                "Try to automatically find the 7Zip application.", `
                                "$($NULL)", `
                                $true);


        # Manually find 7Zip
        [CommonCUI]::DrawMenuItem('M', `
                                "Manually find 7Zip", `
                                "Manually locate the 7Zip application.", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
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
                [Settings7Zip]::Locate7ZipPathAutomatically();


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
                [Settings7Zip]::Locate7ZipPathManually();


                # Finished
                break;
            } # Manually Find 7Zip



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




   <# Configure Locate 7Zip Path Automatically
    # -------------------------------
    # Documentation:
    #  This function will try to find the 7Zip application automatically
    #   for the user.
    # -------------------------------
    #>
    hidden static [void] Locate7ZipPathAutomatically()
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
            # Because we are unable to find 7Zip automatically, there's
            #  really nothing that we can do.
            [Logging]::DisplayMessage("Unable to find the 7Zip application!`r`nPlease be sure that it had been properly installed on your system!");
        } # If : Cannot Find 7Zip Automatically


        # We were able to obtain a new location of where the 7Zip Application resides within the system.
        else
        {
            # Because we were able to find the 7Zip application, we can use the new value.
            $sevenZip.SetExecutablePath("$($find7ZipResults)");

            # Let the user know that we were able to successfully find the 7Zip Application
            [Logging]::DisplayMessage("Successfully found the 7Zip Application in:`r`n$($find7ZipResults)");
        } # Else: Found 7Zip


        # Wait for the user to provide feedback; thus allowing the user to read the message.
        [logging]::GetUserEnterKey();
    } # Locate7ZipPathAutomatically()




   <# Configure Locate 7Zip Path Manually
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to manually configure
    #   the path of the 7Zip directory.
    # -------------------------------
    #>
    hidden static [void] Locate7ZipPathManually()
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
    } # Locate7ZipPathManually()
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
    hidden static [void] CompressionMethod()
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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuCompressionMethod();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestCompressionMethod($userInput);
        } while ($menuLoop);
    } # CompressionMethod()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Method to the user.
    #   Thus, this provides what options are available in relation to the Compression Method in 7Zip.
    # -------------------------------
    #>
    hidden static [void] DrawMenuCompressionMethod()
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


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuCompressionMethod()




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
    hidden static [bool] EvaluateExecuteUserRequestCompressionMethod([string] $userRequest)
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


                # Finished
                break;
            } # Selected Zip Compression


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
    } # EvaluateExecuteUserRequestCompressionMethod()
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
    hidden static [void] AlgorithmsZip()
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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuAlgorithmZip();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestAlgorithmZip($userInput);
        } while ($menuLoop);
    } # AlgorithmsZip()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Algorithm Zip to the user.
    #   Thus, this provides what options are available in relation to the Algorithms for Zip in 7Zip.
    # -------------------------------
    #>
    hidden static [void] DrawMenuAlgorithmZip()
    {
        # Display the Menu List

        # Deflate
        [CommonCUI]::DrawMenuItem('D', `
                                "Deflate", `
                                "Standard compression algorithm; expeditiously compacts files and extracting resources at run-time.", `
                                "Strengths: All general media", `
                                $true);


        # LZMA
        [CommonCUI]::DrawMenuItem('L', `
                                "LZMA", `
                                "Fastest ability to immediately decompress files at run-time, while takes much more time to compact files.", `
                                "Strengths: All general media", `
                                $true);


        # BZip2
        [CommonCUI]::DrawMenuItem('B', `
                                "BZip2", `
                                "Compresses more efficiently than Deflate, but takes longer to compact the files into a container.", `
                                "Strengths: Text files", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuAlgorithmZip()




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
    hidden static [bool] EvaluateExecuteUserRequestAlgorithmZip([string] $userRequest)
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


                # Finished
                break;
            } # Selected BZip2 Compression


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
    } # EvaluateExecuteUserRequestAlgorithmZip()
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
    hidden static [void] Algorithms7Zip()
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
                    $decipherNiceString = "I will have 7Zip use the LZMA2 algorithm when compiling new builds.";

                    # Finished
                    break;
                } # LZMA2


                ([SevenZipAlgorithm7Zip]::LZMA)
                {
                    # Set the message such that the user knows that the 'LZMA' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the LZMA algorithm when compiling new builds.";

                    # Finished
                    break;
                } # LZMA


                ([SevenZipAlgorithm7Zip]::BZip2)
                {
                    # Set the message such that the user knows that the 'BZip2' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the BZip2 algorithm when compiling new builds.";

                    # Finished
                    break;
                } # BZip2


                ([SevenZipAlgorithm7Zip]::PPMd)
                {
                    # Set the message such that the user knows that the 'PPMd' algorithm is currently set.
                    $decipherNiceString = "I will have 7Zip use the PPMd algorithm when compiling new builds.";

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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuAlgorithm7Zip();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestAlgorithm7Zip($userInput);
        } while ($menuLoop);
    } # Algorithms7Zip()




   <# Draw Menu: Compression Method
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Algorithm 7Zip to the user.
    #   Thus, this provides what options are available in relation to the Algorithms for 7Zip in 7Zip.
    # -------------------------------
    #>
    hidden static [void] DrawMenuAlgorithm7Zip()
    {
        # Display the Menu List

        # LZMA2
        [CommonCUI]::DrawMenuItem('2', `
                                "LZMA2", `
                                "$($NULL)", `
                                "$($NULL)", `
                                $true);


        # LZMA
        [CommonCUI]::DrawMenuItem('L', `
                                "LZMA", `
                                "$($NULL)", `
                                "$($NULL)", `
                                $true);


        # BZip2
        [CommonCUI]::DrawMenuItem('B', `
                                "BZip2", `
                                "$($NULL)", `
                                "$($NULL)", `
                                $true);


        # PPMd
        [CommonCUI]::DrawMenuItem('P', `
                                "PPMd", `
                                "$($NULL)", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuAlgorithm7Zip()




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
    hidden static [bool] EvaluateExecuteUserRequestAlgorithm7Zip([string] $userRequest)
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


                # Finished
                break;
            } # Selected PPMd Compression


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
    } # EvaluateExecuteUserRequestAlgorithm7Zip()
    #endregion





    #region Use Multithread
    #                                      Use Multithread
    # ==========================================================================================
    # ------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------
    # ==========================================================================================





   <# UseMultithread
    # -------------------------------
    # Documentation:
    #  This function will allow the user the ability to enable 7Zip's Multithreaded operations (if available).
    # -------------------------------
    #>
    hidden static [void] UseMultithread()
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


        # Open the Use Multithread Configuration menu
        #  Keep the user within the menu until they request to return back to the previous menu.
        do
        {
            # Determine the current state of the Use Multithread variable, then make it easier for the user
            #  to understand the current setting.
            # Multithreaded Operations are enabled
            if ($sevenZip.GetUseMultithread())
            {
                # Set the message that the Multithreaded option is presently activated.
                $decipherNiceString = "I will have 7Zip use multithreaded operations where available.";
            } # If : Multithread is Enabled

            # Multithreaded Operations are disabled
            else
            {
                # Set the message that the multithreaded option is presently deactivated.
                $decipherNiceString = "I will not have 7Zip use multithreaded operations.";
            } # Else : Multithread is Disabled



            # Clear the terminal of all previous text; keep the space clean so that it is easy
            #  for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Use Multithread menu
            [CommonCUI]::DrawSectionHeader("Use Multithread");

            # Show to the user the current state of the 'Use Multithread' variable that is presently set within the program.
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuUseMultithread();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestUseMultithread($userInput);
        } while ($menuLoop);
    } # UseMultithread()




   <# Draw Menu: Use Multithread
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Use Multithreaded operations.
    #   Thus, this provides the ability to enable or disable the use of Multithreaded operations in 7Zip.
    # -------------------------------
    #>
    hidden static [void] DrawMenuUseMultithread()
    {
        # Display the Menu List

        # Enable Multithreaded Operations
        [CommonCUI]::DrawMenuItem('E', `
                                "Enable Multithreaded Operations", `
                                "Use multithreaded operations where available; this may speed up larger operations.", `
                                "$($NULL)", `
                                $true);


        # Disable Multithreaded Operations
        [CommonCUI]::DrawMenuItem('D', `
                                "Disable Multithreaded Operations", `
                                "Do not use multithreaded operations.", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuUseMultithread()




   <# Evaluate and Execute User's Request: Use Multithread
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
    hidden static [bool] EvaluateExecuteUserRequestUseMultithread([string] $userRequest)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this instance so that we can apply the new changes to the object.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Evaluate the user's request
        switch ($userRequest)
        {
            # Enable the Use Multithread
            #  NOTE: Allow the user's request when they type: "True", "T", "On", as well as "E".
            {($_ -eq "E") -or `
                ($_ -eq "On") -or `
                ($_ -eq "T") -or `
                ($_ -eq "True")}
            {
                # Enable the use of Multithreaded Operations in 7Zip
                $sevenZip.SetUseMultithread($true);


                # Finished
                break;
            } # Selected Enable Multithread


            # Disable the Use Multithread
            #  NOTE: Allow the user's request when they type: "False", "F", "Off", as well as "D".
            {($_ -eq "D") -or `
                ($_ -eq "Off") -or `
                ($_ -eq "F") -or `
                ($_ -eq "False")}
            {
                # Disable the use of Multithreaded Operations in 7Zip
                $sevenZip.SetUseMultithread($false);


                # Finished
                break;
            } # Selected Disabled Multithread


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
    } # EvaluateExecuteUserRequestUseMultithread()
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
    hidden static [void] CompressionLevel()
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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuCompressionLevel();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserCompressionLevel($userInput);
        } while ($menuLoop);
    } # CompressionLevel()




   <# Draw Menu: Compression Level
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Compression Level to the user.
    #   Thus, this provides a list of available compression levels that are available to the user
    #   while using 7Zip.
    # -------------------------------
    #>
    hidden static [void] DrawMenuCompressionLevel()
    {
        # Display the Menu List

        # Store
        [CommonCUI]::DrawMenuItem('S', `
                                "Store", `
                                "Do not compress the contents; only store the contents which requires hardly any resources.", `
                                "$($NULL)", `
                                $true);


        # Minimal
        [CommonCUI]::DrawMenuItem('L', `
                                "Minimal", `
                                "Lightly compress the contents; minimal compression requires very little resources.", `
                                "$($NULL)", `
                                $true);


        # Normal
        [CommonCUI]::DrawMenuItem('N', `
                                "Normal", `
                                "Normally compress the contents; normal compression requires the standard use of resources.", `
                                "$($NULL)", `
                                $true);


        # Maximum
        [CommonCUI]::DrawMenuItem('M', `
                                "Maximum", `
                                "Tightly compress the contents; requires more time and resources.", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuCompressionLevel()




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
    hidden static [bool] EvaluateExecuteUserCompressionLevel([string] $userRequest)
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


                # Finished
                break;
            } # Selected Maximum


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
    } # EvaluateExecuteUserCompressionLevel()
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
    hidden static [void] VerifyBuild()
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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuVerifyBuild();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestVerifyBuild($userInput);
        } while ($menuLoop);
    } # VerifyBuild()




   <# Draw Menu: Verify Build
    # -------------------------------
    # Documentation:
    #  This function will essentially draw the menu list for the Verify Build.
    #  This provides the option if the user wants to test the newly generated
    #  archive datafile's integrity or to skip the verification phase.
    # -------------------------------
    #>
    hidden static [void] DrawMenuVerifyBuild()
    {
        # Display the Menu List

        # Verify the integrity of the archive datafile.
        [CommonCUI]::DrawMenuItem('V', `
                                "Verify Build", `
                                "Test the compiled build to assure that it is healthy.", `
                                "$($NULL)", `
                                $true);


        # Do not verify the integrity of the archive datafile.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not verify build", `
                                "Do not test the health of the compiled build.", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
                                $true);
    } # DrawMenuVerifyBuild()




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
    hidden static [bool] EvaluateExecuteUserRequestVerifyBuild([string] $userRequest)
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

                # Finished
                break;
            } # Selected Fastest Compression


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
    } # EvaluateExecuteUserRequestVerifyBuild()
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
            [Logging]::DisplayMessage("$($decipherNiceString)");

            # Provide some extra white spacing so that it is easier to read for the user
            [Logging]::DisplayMessage("`r`n`r`n");

            # Display the instructions to the user
            [CommonCUI]::DrawMenuInstructions();

            # Draw the menu list to the user
            [Settings7Zip]::DrawMenuGenerateReport();

            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Execute the user's request
            $menuLoop = [Settings7Zip]::EvaluateExecuteUserRequestGenerateReport($userInput);
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
                                "Generate a new technical report regarding the project's compiled build.", `
                                "$($NULL)", `
                                $true);


        # Do not generate a new report regarding the archive datafile.
        [CommonCUI]::DrawMenuItem('N', `
                                "Do not generate a report file.", `
                                "Do not create a technical report regarding the compiled build.", `
                                "$($NULL)", `
                                $true);


        # Return back to the previous menu
        [CommonCUI]::DrawMenuItem('X', `
                                "Cancel", `
                                "Return back to the previous menu.", `
                                "$($NULL)", `
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
                $sevenZip.SetGenerateReport($false);

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
} # Settings7Zip