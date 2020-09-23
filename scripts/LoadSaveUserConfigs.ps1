<# Load \ Save User Configuration
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability to load and save the user's configurations to or from
 #  a specific file location.  This will allow the ability for the user's preferences and
 #  settings from this program to be saved - making it usable for the next session.  Furthermore,
 #  loading from the user's preferences and settings - essentially picks up where the user last
 #  saved the program.  This process is to be painless and easy as possible, having the user to
 #  reconfigure their settings and preferences is not only inconvenient but will be extremely
 #  frustrating.  If this functionality doesn't work flawlessly - then people will no longer use
 #  this program.
 #
 # DEVELOPER NOTE: This class does NOT have a Default Constructor.  This is because we must have a
 #  legitimate path that is unique to the program.
 #>




 class LoadSaveUserConfiguration
 {
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # User Configuration Path
    # ---------------
    # The path in which the user configuration file will be located.
    Hidden [string] $__configPath;


    # User Configuration File
    # ---------------
    # The file name of the user configuration file.
    Hidden [string] $__configFileName;


    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # User Configuration : On-Load
    LoadSaveUserConfiguration([string] $configPath)
    {
        # Configuration Path
        $this.__configPath = "$($configPath)";


        # Configuration Filename
        $this.__configFileName = "UserConfig.xml";
    } # User Configuration : On-Load


    #endregion



    #region Getter Functions

   <# Get Configuration File Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Configuration Path' variable.
    # -------------------------------
    # Output:
    #  [string] Path of the Configuration
    #   The value of the 'Configuration Path' variable.
    # -------------------------------
    #>
    [string] GetConfigPath()
    {
        return $this.__configPath;
    } # GetConfigPath()




   <# Get Configuration Filename
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Configuration File Name' variable.
    # -------------------------------
    # Output:
    #  [string] Filename of the Configuration file
    #   The value of the 'Configuration file Name' variable.
    # -------------------------------
    #>
    [string] GetConfigFileName()
    {
        return $this.__configFileName;
    } # GetConfigFileName()


    #endregion



    #region Setter Functions

   <# Set Configuration File Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Configuration Path' variable.
    # -------------------------------
    # Input:
    #  [string] Configuration Path
    #   The new location of the 'Configuration Path' directory.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetConfigPath([string] $newVal)
    {
        # Before we can use the newly requested directory, we must first create it to assure
        #  that we can use that requested path.


        # Check if the directory already exists on the filesystem.
        if ($([IOCommon]::CheckPathExists("$($newVal)", $true)) -eq $false)
        {
            # Because the directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($newVal)")) -eq $true)
            {
                # Directory was successfully created, we will now use that path as requested.
                $this.__configPath = $newVal;


                # Successfully updated
                return $true
            } # If : Successfully Updated Path
        } # If : Directory does not Exist


        # Directory already exists
        else
        {
            # Use the directory as requested.
            $this.__configPath = $newVal;


            # Successfully updated
            return $true;
        } # else : Directory Exists


        # Failure to change value.
        return $false;
    } # SetConfigPath()




   <# Set Configuration Filename
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Configuration Filename' variable.
    # -------------------------------
    # Input:
    #  [string] Configuration Filename
    #   The new filename of the configuration file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetConfigFileName([string] $newVal)
    {
        # Filename of the output file.
        $this.__configFileName = $newVal;


        # Successfully updated.
        return $true;
    } # SetConfigFileName()


    #endregion



    #region Private Functions

   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories that will hold the User
    #   Configuration files that are generated from this class.  If the directories do
    #   not exist on the filesystem already, there is a chance that some operations might
    #   fail due to the inability to safely store the User Configuration files generated
    #   by the functions within this class.  If the directories do not already exist, this
    #   function will try to create them automatically - without interacting with the
    #   end-user.  If the directories already exist within the filesystem, then nothing
    #   will be performed.
    #
    # ----
    #
    #  Directories to be created:
    #   - User Configuration Path <Internal Program Defined>
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure creating the new directory.
    #    $true  = Successfully created the new directory
    #             OR
    #             Directory already existed, nothing to do.
    # -------------------------------
    #>
    Hidden [bool] __CreateDirectories()
    {
        # First, check if the directory already exist.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The User Configuration directory already exists;" + `
                                    " there is no need to create the directory again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Directory:`r`n" + `
                                        "`t`tThe User Configuration Directory is:`t`t$($this.__configPath)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directory exist, no action is required.
            return $true;
        } # IF : Check if Directory Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # User Configuration Directory
        if(([IOCommon]::CheckPathExists("$($this.__configPath)", $true)) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__configPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the User Configuration directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The User Configuration directory path is: $($this.__configPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected User Configuration Directory


        # ----


        # Fail-safe; final assurance that the directory have been created successfully.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created the User Configuration directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "User Configuration Directory: $($this.__configPath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directory exist
            return $true;
        } # IF : Check if Directory Exists


        # ONLY REACHED UPON ERROR
        # If the directory could not be detected - despite being created on the filesystem,
        #  then something went horribly wrong.
        else
        {
            # The directory could not be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the User Configuration directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "User Configuration Directory: $($this.__configPath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : If Directory Not Found


        # A general error occurred; the directory could not be created.
        return $false;
    } # __CreateDirectories()




   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function will check to make sure that the User Configuration directory,
    #   that is required for this class, currently exists within the host system's filesystem.
    #
    # ----
    #
    #  Directories to Check:
    #   - User Configuration Directory <Internal Program Defined>
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Hidden [bool] __CheckRequiredDirectories()
    {
        # Check User Configuration Directory
        if ([IOCommon]::CheckPathExists("$($this.__configPath)", $true) -eq $true)
        {
            # The User Configuration directory exists
            return $true;
        } # If : Check Directories Exists

        # The directory does not exist
        else
        {
            # The User Configuration Directory does not exist.
            return $false;
        } # Else : Directories does not exist
    } # __CheckRequiredDirectories()

    #endregion



    #region Public Functions

   <# Save User Configuration
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to save all of the user's settings and
    #   their preferences to a save file within the User's Configuration Directory.
    #
    # NOTE:
    #  All program data and objects must be known in order to use this function!
    # -------------------------------
    # Parameters:
    #  [UserPreferences] User Preferences
    #     User's general preferences when interacting within the program.
    #  [GitControl] Git Object
    #     User's preferences and settings for using the Git functionality.
    #  [SevenZip] 7Zip Object
    #     User's preferences and settings for using the 7Zip functionality.
    #  [DefaultCompress] PowerShell's Archive Object
    #     User's preferences and settings for using the PowerShell Archive functionality.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true = Successfully generated the user's configuration file.
    #   $false = Failure to generate the user's configuration file.
    # -------------------------------
    #>
    [bool] Save([UserPreferences] $userPref, `      # User's General Program Preferences
                [GitControl] $gitObj, `             # User's Git Settings
                [SevenZip] $sevenZipObj, `          # User's 7Zip Settings
                [DefaultCompress] $psArchive)       # .NET Core's ZipArchive Settings
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;          # Operation status of the execution performed.
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the user config. directory exists
        if ($this.__CheckRequiredDirectories() -eq $false)
        {
            # Because the directory does not exist, try to create it.
            if ($this.__CreateDirectories() -eq $false)
            {
                # Because we could not create the directory, we can not save the user's configuration.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to save the user's configuration file as the User Configuration Directory could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "User Configuration Directory: $($this.__configPath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Nothing more can be done, return an error.
            return $false;
            } # Inner-If : Try to Create Directories
        } # If : User Config. Directory Exists


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Try to export the preferences and settings to the requested file.
        try
        {
            Export-Clixml -Path "$($this.__configPath)\$($this.__configFileName)" `
                          -InputObject @($userPref, $gitObj, $sevenZipObj, $psArchive) `
                          -Encoding UTF8NoBOM `
                          -ErrorAction Stop;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully saved the user's configuration!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Directory: $($this.__configPath)`r`n" + `
                                            "`tUser Configuration File: $($this.__configFileName)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Update the status as successful
            $exitCode = $true;
        } # Try : Save User Configuration

        catch
        {
            # There was an error while saving the user's configuration file.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to save the user configuration!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Unable to save the user configuration!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Directory: $($this.__configPath)`r`n" + `
                                        "`tUser Configuration File: $($this.__configFileName)`r`n" + `
                                        "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                    "Error");                       # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Update the status as failure
            $exitCode = $false;
        } # Catch : Error Creating User Configuration


        # Return the results
        return $exitCode;
    } # Save()




   <# Load User Configuration
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to load the user's configuration and their settings that were
    #   previously generated from a previous instance.
    #
    # NOTE:
    #  All program data and objects will be updated to adjust to user's preferred settings and configurations.
    # -------------------------------
    # Parameters:
    #  [ref] {UserPreferences} User Preferences
    #     User's general preferences when interacting within the program.
    #  [ref] {GitControl} Git Object
    #     User's preferences and settings for using the Git functionality.
    #  [ref] {SevenZip} 7Zip Object
    #     User's preferences and settings for using the 7Zip functionality.
    #  [ref] {DefaultCompress} PowerShell's Archive Object
    #     User's preferences and settings for using the PowerShell Archive functionality.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true = Successfully loaded the user's configurations.
    #   $false = Failure to properly load the configuration file.
    # -------------------------------
    #>
    [bool] Load([UserPreferences] $userPref, `      # User's General Program Preferences
                [GitControl] $gitObj, `             # User's Git Settings
                [SevenZip] $sevenZipObj, `          # User's 7Zip Settings
                [DefaultCompress] $psArchive)       # .NET Core's ZipArchive Settings
    {
        # Declarations and Initializations
        # -----------------------------------------
        [bool] $exitCode = $false;              # Operation status of the execution performed.
        [Object[]] $cacheUserConfig = $null;    # This will hold the deserialized XML data containing the user's preferred
                                                #  settings and configurations regarding each object.

        # - - - - - - - - - - - - - - - - - - - - -
        # Objects:
        #  Create new instances of the objects so that we may use them with the user's preferred configurations.

        # User Preferences
        [UserPreferences] $userPrefNew = [UserPreferences]::new();

        # Git Settings
        [GitControl] $gitObjNew = [GitControl]::new();

        # 7Zip Settings
        [SevenZip] $sevenZipObjNew = [SevenZip]::new();

        # PowerShell's Archive Settings
        [DefaultCompress] $psArchiveNew = [DefaultCompress]::new();
        # -----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------


        # Make sure that the file exists at the given location.
        if ([IOCommon]::CheckPathExists("$($this.__configPath)\$($this.__configFileName)", $true) -eq $false)
        {
            # Because either the file or the directory does not exist at the provided location, we simply can not load anything.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to load the user's configuration file; User Configuration Directory or User Configuration File was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Directory: $($this.__configPath)`r`n" +
                                        "`tUser Configuration File: $($this.__configFileName)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the User Configuration file cannot be found, return an error.
            return $false;
        } # If : User Configuration File Exists


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Try to import the user's configuration preferences and settings from the file.
        #  Then try to update all of the settings in the current environment to match with
        #  the previously generated configuration file.
        try
        {
            # Retrieve and cache the user's configuration file from the filesystem.
            $cacheUserConfig = Import-Clixml -Path "$($this.__configPath)\$($this.__configFileName)" `
                                             -ErrorAction Stop;

            # Try to load the user's configuration into the objects safely.
            if ($this.LoadStepWise($cacheUserConfig,
                                   $userPref, `
                                   $gitObj, `
                                   $sevenZipObj, `
                                   $psArchive) -eq $true)
            {
                # Successfully updated the object's preferences to match with the user's preferred environment.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Successfully loaded the user's configurations and is loaded into the program's environment!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("User Configuration Directory: $($this.__configPath)`r`n" +
                                            "`tUser Configuration File: $($this.__configFileName)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Verbose");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Successfully loaded the user's environment.
                $exitCode = $true;
            } # if : Successfully loaded environment

            # If there was a general failure while loading the user's preferred environment, then immediately stop to avoid
            #  corrupting the current environment.  Because the user's configuration file might had been corrupted or damaged,
            #  The user might have to reconfigure their settings and generate a new save file.
            else
            {
                # Failure to load the user's settings.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Prep a message to display to the user for this error; temporary variable
                [string] $displayErrorMessage = "Unable to load the user configuration!";

                # Generate the initial message
                [string] $logMessage = "Unable to load the user configuration!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The User Configuration file could be corrupted!`r`n" + `
                                            "`tUser Configuration Directory: $($this.__configPath)`r`n" + `
                                            "`tUser Configuration File: $($this.__configFileName)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                        "Error");                       # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Update the operation status as a failure.
                $exitCode = $false;
            } # else : Failure to load environment
        } # Try : Try to load the user's configuration file


        # Something went horribly wrong; the user's configuration file cannot be loaded into the
        #  program's current environment.
        catch
        {
            # Because an error was caught - we cannot load the user's preferred environment.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to load the user configuration!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Unable to load the user configuration!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Directory: $($this.__configPath)`r`n" + `
                                        "`tUser Configuration File: $($this.__configFileName)`r`n" + `
                                        "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                    "Error");                       # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Update the status to indicate that a failure had been reached.
            $exitCode = $false;
        } # Catch : Exception Reached while Reading Configuration File


        # Return the results
        return $exitCode;
    } # Load()




   <# Load User Configuration - Stepwise
    # -------------------------------
    # Documentation:
    #  This function will try to properly load the user's
    #  configuration to the program through a stepwise
    #  process, this is a tedious process but assures that
    #  the settings are accurately loaded into the environment.
    #
    # NOTE:
    #  This function will require validation to assure the
    #  values are 'correct' to the program's specifications,
    #  yet are also what the user wants.  The point of
    #  validation is to assure that if the user variables
    #  changed or contain data that does not meet with the
    #  program's constraints, then the program will
    #  automatically adjust the variables to meet with the
    #  needs that the program is expecting.
    # -------------------------------
    # Parameters:
    #  [Object[]] Cached User Configuration
    #     The user's configuration that was deserialized.
    #  [ref] {UserPreferences} User Preferences
    #     User's general preferences when interacting
    #      within the program.
    #  [ref] {GitControl} Git Object
    #     User's preferences and settings for using the
    #      Git functionality.
    #  [ref] {SevenZip} 7Zip Object
    #     User's preferences and settings for using the
    #      7Zip functionality.
    #  [ref] {DefaultCompress} PowerShell's Archive Object
    #     User's preferences and settings for using the
    #      PowerShell Archive functionality.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = Failure to properly load configuration
    #             file.
    #   $true = Successfully loaded user's configurations.
    # -------------------------------
    #>
    [bool] LoadStepWise([Object[]] $cachedUserConfig, `
                        [UserPreferences] $userPref, `
                        [GitControl] $gitObj, `
                        [SevenZip] $sevenZipObj, `
                        [DefaultCompress] $psArchive)
    {
        # STEPWISE ALGORITHM - WITH VALIDATION
        # =====================================
        # - - - - - - - - - - - - - - - - - - -
        # =====================================




        # STEP 1 - USER PREFERENCES
        # -------------------------------------
        # -------------------------------------
        # -------------------------------------



        # USER PREFERENCES -- COMPRESSION TOOL
        try
        {
            # Set: Compression Tool
            $userPref.SetCompressionTool([int32]$cachedUserConfig[0].__compressionTool);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __compressionTool FROM User Preferences!`r`n" `
                       " - Tried to use value [$($[int32]$cachedUserConfig[0].__compressionTool)] using $($userPref.GetCompressionTool()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- NOTIFICATION TYPE
        try
        {
            # Set: Notification Type
            $userPref.SetBellEvents([int32]$cachedUserConfig[0].__notificationType);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __notificationType FROM User Preferences!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[0].__notificationType)] using $($userPref.GetBellEvents()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- OUTPUT BUILDS PATH
        try
        {
            # Set: Output Builds Path
            $userPref.SetProjectBuildsPath([string]$cachedUserConfig[0].__outputBuildsPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __outputBuildsPath FROM User Preferences!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[0].__outputBuildsPath)] using $($userPref.GetProjectBuildsPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- PROJECT PATH
        try
        {
            # Set: Project Path
            $userPref.SetProjectPath([string]$cachedUserConfig[0].__projectPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __projectPath FROM User Preferences!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[0].__projectPath)] using $($userPref.GetProjectPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- USE BELL
        try
        {
            # Set: Use Bell
            $userPref.SetUseBell([bool]$cachedUserConfig[0].__ringMyDingaling);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __ringMyDingaling FROM User Preferences!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[0].__ringMyDingaling)] using $($userPref.GetUseBell()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- USE GIT FEATURES
        try
        {
            # Set: Use Git Features
            $userPref.SetUseGitFeatures([bool]$cachedUserConfig[0].__useGitFeatures);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __useGitFeatures FROM User Preferences!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[0].__useGitFeatures)] using $($userPref.GetUseGitFeatures()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # USER PREFERENCES -- USE WINDOWS EXPLORER
        try
        {
            # Set: Use Windows Explorer
            $userPref.SetUseWindowsExplorer([bool]$cachedUserConfig[0].__useWindowsExplorer);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __useWindowsExplorer FROM User Preferences!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[0].__useWindowsExplorer)] using $($userPref.GetUseWindowsExplorer()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.




        # STEP 2 - GIT SETTINGS
        # -------------------------------------
        # -------------------------------------
        # -------------------------------------
        


        # GIT SETTINGS -- CHANGELOG LIMIT
        try
        {
            # Set: Changelog Limit
            $gitObj.SetChangelogLimit([int32]$cachedUserConfig[1].__changelogLimit);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __changelogLimit FROM Git Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[1].__changelogLimit)] using $($gitObj.GetChangelogLimit()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- EXECUTABLE PATH
        try
        {
            # Set: Executable Path
            $gitObj.SetExecutablePath([string]$cachedUserConfig[1].__executablePath, $userPref.GetLogging());
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __executablePath FROM Git Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[1].__executablePath)] using $($gitObj.GetExecutablePath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- FETCH CHANGELOG
        try
        {
            # Set: Fetch Changelog
            $gitObj.SetFetchChangelog([bool]$cachedUserConfig[1].__fetchChangelog);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __fetchChangelog FROM Git Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[1].__fetchChangelog)] using $($gitObj.GetFetchChangelog()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- GENERATE REPORT
        try
        {
            # Set: Generate Report
            $gitObj.SetGenerateReport([bool]$cachedUserConfig[1].__generateReport);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __generateReport FROM Git Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[1].__generateReport)] using $($gitObj.GetGenerateReport()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- COMMIT ID LENGTH
        try
        {
            # Set: Commit ID Length
            $gitObj.SetLengthCommitID([int32]$cachedUserConfig[1].__lengthCommitID);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __lengthCommitID FROM Git Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[1].__lengthCommitID)] using $($gitObj.GetLengthCommitID()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- UPDATE SOURCE
        try
        {
            # Set: Update Source
            $gitObj.SetUpdateSource([bool]$cachedUserConfig[1].__updateSource);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __updateSource FROM Git Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[1].__updateSource)] using $($gitObj.GetUpdateSource()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- ROOT LOG PATH
        try
        {
            # Set: Root Log Path
            $gitObj.SetRootLogPath([string]$cachedUserConfig[1].__rootLogPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __rootLogPath FROM Git Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[1].__rootLogPath)] using $($gitObj.GetRootLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- LOG PATH
        try
        {
            # Set: Log Path
            $gitObj.SetLogPath([string]$cachedUserConfig[1].__logPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __logPath FROM Git Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[1].__logPath)] using $($gitObj.GetLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # GIT SETTINGS -- REPORT PATH
        try
        {
            # Set: Report Path
            $gitObj.SetReportPath([string]$cachedUserConfig[1].__reportPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __reportPath FROM Git Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[1].__reportPath)] using $($gitObj.GetReportPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.


        
        
        # STEP 3 - 7ZIP SETTINGS
        # -------------------------------------
        # -------------------------------------
        # -------------------------------------



        # 7ZIP SETTINGS -- EXECUTABLE PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Executable Path
            $sevenZipObj.SetExecutablePath([string]$cachedUserConfig[2].__executablePath, $userPref.GetLogging());
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __executablePath FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[2].__executablePath)] using $($sevenZipObj.GetExecutablePath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- 7ZIP ALGORITHM
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: 7Zip Algorithm
            $sevenZipObj.SetAlgorithm7Zip([int32]$cachedUserConfig[2].__algorithm7Zip);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __algorithm7Zip FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[2].__algorithm7Zip)] using $($sevenZipObj.GetAlgorithm7Zip()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- ZIP ALGORITHM
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Zip Algorithm
            $sevenZipObj.SetAlgorithmZip([int32]$cachedUserConfig[2].__algorithmZip);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __algorithmZip FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[2].__algorithmZip)] using $($sevenZipObj.GetAlgorithmZip()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- COMPRESSION LEVEL
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Compression Level
            $sevenZipObj.SetCompressionLevel([int32]$cachedUserConfig[2].__compressionLevel);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __compressionLevel FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[2].__compressionLevel)] using $($sevenZipObj.GetCompressionLevel()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- COMPRESSION METHOD
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Compression Method
            $sevenZipObj.SetCompressionMethod([int32]$cachedUserConfig[2].__compressionMethod);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __compressionMethod FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[2].__compressionMethod)] using $($sevenZipObj.GetCompressionMethod()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- GENERATE REPORT
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Generate Report
            $sevenZipObj.SetGenerateReport([bool]$cachedUserConfig[2].__generateReport);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __generateReport FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[2].__generateReport)] using $($sevenZipObj.GetGenerateReport()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- USE MULTITHREADING
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Use Multithreading
            $sevenZipObj.SetUseMultithread([bool]$cachedUserConfig[2].__useMultithread);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __useMultithread FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[2].__useMultithread)] using $($sevenZipObj.GetUseMultithread()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- VERIFY BUILD
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Verify Build
            $sevenZipObj.SetVerifyBuild([bool]$cachedUserConfig[2].__verifyBuild);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __verifyBuild FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[2].__verifyBuild)] using $($sevenZipObj.GetVerifyBuild()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- ROOT LOG PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Root Log Path
            $sevenZipObj.SetRootLogPath([string]$cachedUserConfig[2].__rootLogPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __rootLogPath FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[2].__rootLogPath)] using $($sevenZipObj.GetRootLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- LOG PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Log Path
            $sevenZipObj.SetLogPath([string]$cachedUserConfig[2].__logPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __logPath FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[2].__logPath)] using $($sevenZipObj.GetLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # 7ZIP SETTINGS -- REPORT PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Report Path
            $sevenZipObj.SetReportPath([string]$cachedUserConfig[2].__reportPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __reportPath FROM 7Zip Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[2].__reportPath)] using $($sevenZipObj.GetReportPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.




        # STEP 4 - POWERSHELL'S ARCHIVE SETTINGS
        # -------------------------------------
        # -------------------------------------
        # -------------------------------------



        # POWERSHELL'S ARCHIVE SETTINGS -- COMPRESSION LEVEL
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Compression Level
            $psArchive.SetCompressionLevel([int32]$cachedUserConfig[3].__compressionLevel);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __compressionLevel FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([int32]$cachedUserConfig[3].__compressionLevel)] using $($psArchive.GetCompressionLevel()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # POWERSHELL'S ARCHIVE SETTINGS -- GENERATE REPORT
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Generate Report
            $psArchive.SetGenerateReport([bool]$cachedUserConfig[3].__generateReport);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __generateReport FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[3].__generateReport)] using $($psArchive.GetGenerateReport()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # POWERSHELL'S ARCHIVE SETTINGS -- VERIFY BUILD
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Verify Build
            $psArchive.SetVerifyBuild([bool]$cachedUserConfig[3].__verifyBuild);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __verifyBuild FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([bool]$cachedUserConfig[3].__verifyBuild)] using $($psArchive.GetVerifyBuild()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # POWERSHELL'S ARCHIVE SETTINGS -- ROOT LOG PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Root Log Path
            $psArchive.SetRootLogPath([string]$cachedUserConfig[3].__rootLogPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __rootLogPath FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[3].__rootLogPath)] using $($psArchive.GetRootLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # POWERSHELL'S ARCHIVE SETTINGS -- LOG PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Log Path
            $psArchive.SetLogPath([string]$cachedUserConfig[3].__logPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __logPath FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[3].__logPath)] using $($psArchive.GetLogPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.



        # POWERSHELL'S ARCHIVE SETTINGS -- REPORT PATH
        # - - - - - - - - - - - - - - - - - - - - - - -
        try
        {
            # Set: Report Path
            $psArchive.SetReportPath([string]$cachedUserConfig[3].__reportPath);
        } # Try : Load Value from Config
        catch
        {
            # Because the value was unknown, we will keep what value is already stored.
            Write-Host "An error occurred while trying to set: __reportPath FROM PowerShell's Archive Settings!`r`n" `
                       " - Tried to use value [$([string]$cachedUserConfig[3].__reportPath)] using $($psArchive.GetReportPath()) instead.`r`n"
                       " - Error Message Provided: $($_)";
        } # Catch : Unknown Value from Config.


        # Everything was okay, return successful operation
        return $true;
    } # LoadStepWise()
    #endregion
 } # LoadSaveUserConfiguration