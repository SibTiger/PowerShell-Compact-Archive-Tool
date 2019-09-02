<# Default Compress
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds settings regarding the use of .NET's
 #  System.IO.Compression (aka: .NET Compression).
 #  Because this was part of .NET 4.5 version and later,
 #  it is now possible for end-user's to use the native
 #  Zip provided - without requiring external API's or
 #  3rd party applications.  This should hypothetically
 #  support all targeted versions of Windows platforms.
 # Requirements: .NET Framework 4.5
 #>



class DefaultCompress
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Compression Level
    # ---------------
    # The compression level when generating an
    #  archive datafile.
    Hidden [DefaultCompressionLevel] $__compressionLevel;


    # Verify Build
    # ---------------
    # Test the archive datafile to assure it is not
    #  corrupted.
    Hidden [bool] $__verifyBuild;


    # Generate Report
    # ---------------
    # Generate a report about the archive datafile.
    Hidden [bool] $__generateReport;


    # Log Root
    # ---------------
    # The main root of the log directories.
    Hidden [string] $__rootLogPath;


    # Report Path
    # ---------------
    # The absolute path to store the reports that
    #  has been generated.
    Hidden [string] $__reportPath;


    # Log Root Path
    # ---------------
    # The absolute path to place the logs from the
    #  executable.
    Hidden [string] $__logPath;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================



    #region Constructor Functions

    # Default Constructor
    DefaultCompress()
    {
        # Compression Level
        $this.__compressionLevel = 0;

        # Verify Build
        $this.__verifyBuild = $true;

        # Generate report
        $this.__generateReport = $false;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\PSArchive";

        # Report Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Path
        $this.__logPath = "$($this.__rootLogPath)\logs";
    } # Default Constructor




    # User Preference : On-Load
    DefaultCompress([DefaultCompressionLevel] $compressionLevel,
                    [bool] $verifyBuild,
                    [bool] $generateReport)
    {
        # Compression Level
        $this.__compressionLevel = $compressionLevel;

        # Verify Build
        $this.__verifyBuild = $verifyBuild;

        # Generate report
        $this.__generateReport = $generateReport;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\PSArchive";

        # Report Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Path
        $this.__logPath = "$($this.__rootLogPath)\logs";
    } # Default Constructor

    #endregion



    #region Getter Functions

   <# Get Compression Level
    # -------------------------------
    # Documentation:
    #  Returns the value of the Compression Level variable.
    # -------------------------------
    # Output:
    #  [DefaultCompressionLevel] Compression Level
    #   the value of the Compression Level.
    # -------------------------------
    #>
    [DefaultCompressionLevel] GetCompressionLevel()
    {
        return $this.__compressionLevel;
    } # GetCompressionLevel()




   <# Get Verify Build
    # -------------------------------
    # Documentation:
    #  Returns the value of the Verify Build variable.
    # -------------------------------
    # Output:
    #  [bool] Verify Build
    #   the value of the Verify Build.
    # -------------------------------
    #>
    [bool] GetVerifyBuild()
    {
        return $this.__verifyBuild;
    } # GetVerifyBuild()




   <# Get Generate Report
    # -------------------------------
    # Documentation:
    #  Returns the value of the Generate Report variable.
    # -------------------------------
    # Output:
    #  [bool] Generate Report
    #   the value of the Generate Report.
    # -------------------------------
    #>
    [bool] GetGenerateReport()
    {
        return $this.__generateReport;
    } # GetGenerateReport()




   <# Get Report Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Report Path variable.
    # -------------------------------
    # Output:
    #  [string] Report Path
    #   the value of the Report Path.
    # -------------------------------
    #>
    [string] GetReportPath()
    {
        return $this.__reportPath;
    } # GetReportPath()




   <# Get Log Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Log Path variable.
    # -------------------------------
    # Output:
    #  [string] Log Path
    #   the value of the Log Path.
    # -------------------------------
    #>
    [string] GetLogPath()
    {
        return $this.__logPath;
    } # GetLogPath()




   <# Get Root Log Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Root Log Path variable.
    # -------------------------------
    # Output:
    #  [string] Root Log Path
    #   the value of the Log Root Path.
    # -------------------------------
    #>
    [string] GetRootLogPath()
    {
        return $this.__rootLogPath;
    } # GetRootLogPath()

    #endregion



    #region Setter Functions

   <# Set Compression Level
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Compression Level variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionLevel([DefaultCompressionLevel] $newVal)
    {
        # Because the value must fit within the
        #  'DefaultCompressionLevel' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__compressionLevel = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionLevel()




   <# Set Verify Build
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Verify Build variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVerifyBuild([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__verifyBuild = $newVal;

        # Successfully updated.
        return $true;
    } # SetVerifyBuild()




   <# Set Generate Report
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Generate Report variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGenerateReport([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__generateReport = $newVal;

        # Successfully updated.
        return $true;
    } # SetGenerateReport()




   <# Set Root Log Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Root Log Path variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!
    #   IT IS RECOMMENDED TO _NOT_ REVISE THIS VARIABLE
    #   UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetRootLogPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__rootLogPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetRootLogPath()




   <# Set Log Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Log Path variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!
    #   IT IS RECOMMENDED TO _NOT_ REVISE THIS VARIABLE
    #   UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLogPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__logPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetLogPath()




   <# Set Report Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Report Path variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!
    #   IT IS RECOMMENDED TO _NOT_ REVISE THIS VARIABLE
    #   UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetReportPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__reportPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetReportPath()

    #endregion


    #region Private Functions


   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories
    #   required for this class to operate successfully.
    #  If the directories do not exist, then the directories
    #   are to be created on the user's filesystem.
    #  If the directories does exist, then nothing will be
    #   created nor changed.
    #
    # ----
    #
    #  Directories to be created:
    #   - \PSArchive
    #   - \PSArchive\logs
    #   - \PSArchive\reports
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure creating the new directories.
    #    $true  = Successfully created the new directories
    #             OR
    #             Directories already existed, nothing to do.
    # -------------------------------
    #>
    Hidden [bool] __CreateDirectories()
    {
        # First, check if the directories already exist?
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The Default Compress (dotNET Core) logging directories already exists;" + `
                                    " there is no need to create the directories again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Default Compress Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory is:`t`t$($this.__rootLogPath)`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.__logPath)`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.__reportPath)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # Root Log Directory
        if(([IOCommon]::CheckPathExists("$($this.__rootLogPath)")) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__rootLogPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Default Compress's (dotNET Core) root logging and report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The root directory path is: $($this.__rootLogPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Root Log Directory


        # ----


        # Log Directory
        if(([IOCommon]::CheckPathExists("$($this.__logPath)")) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__logPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Default Compress's (dotNET Core) logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The logging directory path is: $($this.__logPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Log Directory


        # ----


        # Report Directory
        if(([IOCommon]::CheckPathExists("$($this.__reportPath)")) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__reportPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Default Compress's (dotNET Core) report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The report directory path is: $($this.__reportPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Report Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created the Default Compress (dotNET Core) logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Default Compress Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory is:`t`t$($this.__rootLogPath)`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.__logPath)`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.__reportPath)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *

            # The directories exist
            return $true;
        } # IF : Check if Directories Exists

        # ONLY REACHED UPON ERROR
        # If the directories could not be detected, despite being created on the filesystem.
        else
        {
            # The directories couldn't be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the Default Compress (dotNET Core) required logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Default Compress Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory was:`t`t$($this.__rootLogPath)`r`n" + `
                                        "`t`tThe Logging Directory was:`t$($this.__logPath)`r`n" + `
                                        "`t`tThe Report Directory was:`t$($this.__reportPath)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : If Directories Not Found


        # A general error occurred, the directories could not be created.
        return $false;
    } # __CreateDirectories()




   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function was created to check the directories
    #   that this class requires.
    #
    # ----
    #
    #  Directories to Check:
    #   - \PSArchive
    #   - \PSArchive\logs
    #   - \PSArchive\reports
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Hidden [bool] __CheckRequiredDirectories()
    {
        # Check Root Log Directory
        if ((([IOCommon]::CheckPathExists("$($this.__rootLogPath)")) -eq $true) -and `

        # Check Report Path
        (([IOCommon]::CheckPathExists("$($this.__reportPath)")) -eq $true) -and `

        # Check Log Path
        (([IOCommon]::CheckPathExists("$($this.__logPath)") -eq $true)))
        {
            # All of the directories exists
            return $true;
        } # If : Check Directories Exists

        else
        {
            # Directories does not exist.
            return $false;
        } # Else : Directories does not exist
    } # __CheckRequiredDirectories()


    #endregion


    #region Public Functions


   <# Detect Compression Module
    # -------------------------------
    # Documentation:
    #  This function will try to detect if the host
    #   system has the Archive module installed.
    #   This validation is required in order to
    #   utilize the Archive functionality within
    #   the PowerShell and .NET Framework.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = Archive module was not detected.
    #   $true = Archive module was successfully detected.
    # -------------------------------
    #>
    [bool] DetectCompressModule()
    {
        # We are going to try to detect if the module
        #  itself is installed and ready within this
        #  PowerShell instance.  If not, we will have
        #  to return 'false'.
        # NOTE: If there is ANY output, than this function will return true.
        # Reference: https://stackoverflow.com/a/28740512
        if ($(Get-Module -ListAvailable -Name Microsoft.PowerShell.Archive))
        {
            # Detected the module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Found the dotNET Core PSArchive module!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "It is possible to use the default archive that is built-in with dotNET 2.2 and later.";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that we detected the module
            return $true;
        } # if : Module is installed

        # When the module was not detected
        else
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Could not find the dotNET Core PSArchive module!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("It is not possible to use the default archive that is built-in with dotNET 2.2 and later." + `
                                        "`tPlease consider downloading the newest version possible from the following link below:" + `
                                        "`t`thttps://dotnet.microsoft.com/download");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : Module not detected


        # Because the module was not detected.
        return $false;
    } # DetectCompressModule()



    #region Inspect Archive

   <# Fetch Hash Information
    # -------------------------------
    # Documentation:
    #  This function will retrieve and return
    #   all hash values that is associated with
    #   the archive data file.  Hash values are
    #   essentially a finger print of a specific
    #   file that was generated at a specific time.
    #   If the hash value differs to a specific
    #   file, that could mean that the file is
    #   different (overall) or corrupted.
    # -------------------------------
    # Input:
    #  [string] Archive datafile Path
    #   The archive file that will be inspected.
    #    The path provided should be in absolute
    #    form.
    # -------------------------------
    # Output:
    #  [string] Hash Values
    #    A string list of all hash values
    #    associated with that specific archive
    #    file.
    # -------------------------------
    #>
    [string] FetchHashInformation([string] $file)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $archiveInfo = $null;      # This will hold our list of hash values
        # ----------------------------------------

        # Get all of the hash values that is associated with the archive file.
        $archiveInfo =
                "SHA256:`r`n" + `
                "  $([IOCommon]::FileHash("$($file)", "sha256"))`r`n`r`n" + `
                "SHA384:`r`n" + `
                "  $([IOCommon]::FileHash("$($file)", "sha384"))`r`n`r`n" + `
                "SHA512:`r`n" + `
                "  $([IOCommon]::FileHash("$($file)", "sha512"))`r`n`r`n" + `
                "MD5:`r`n" + `
                "  $([IOCommon]::FileHash("$($file)", "md5"))`r`n`r`n";


        # Return all of the hash values
        return $archiveInfo;
    } # FetchHashInformation()




   <# Verify Archive
    # -------------------------------
    # Documentation:
    #  This function will test the archive data file by making
    #   sure that all of the contents within the archive are
    #   readable.  If the files within the archive are corrupted
    #   or damaged, the test will fail - as the integrity of the
    #   archive file has been compromised.
    #
    # NOTE: Because the .NET Framework does not include a test
    #        functionality, the only way to really perform an
    #        integrity test - we have to extract all of the data.
    #       - Some individuals suggest using 'listing' as a way to
    #         check if the archive file was corrupted.  With my
    #         testing of manipulating an archive file via HexEditor,
    #         I can safely say that it isn't enough.  The best way
    #         to tell if the archive file is corrupted, is to
    #         extract all the contents.  If the extract operation
    #         fails, then the archive file is damaged or corrupted.
    #
    # Extract Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/Expand-Archive
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file that will be tested upon through the
    #    verification process.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Archive file failed verification process.
    #    $true = Archive file passed verification process
    #             or user did not request the file archive
    #             to be tested.
    # -------------------------------
    #>
    [bool] VerifyArchive([string] $targetFile)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $tmpDirectory = $null;         # This will hold the directory path in
                                                #  %TEMP% that we will use to temporarily
                                                #  extract the contents.
        [bool] $testResult = $true;             # This will hold our test result if the
                                                #  operation was successful or failed.
        # - - - - - - - - - - -
        # The archive file name; used for the description of the logfiles.
        [string] $targetFileName = "$($(Get-Item $targetFile).Name)";

        # Description; used for logging.
        [string] $execReason = "Verifying $($targetFileName)";

        # This will hold the STDOUT Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDOUT = [System.Object]::new();

        # This will hold the STDERR Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDERR = [System.Object]::new();

        # This will hold the STDOUT as a normal string datatype;
        #  converted output result from the STDOUT Object.
        [string] $strSTDOUT = $null;

        # This will hold the STDERR as a normal string datatype;
        #  Converted output result from the STDERR Object.
        [string] $strSTDERR = $null;
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the .NET Compress Archive Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : .NET Archive Logging Directories


        # Check to make sure that the host-system support the archive functionality.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the archive support functionality was not found, we can
            #  not proceed.  For the validation process.
            return $false;
        } # if : PowerShell Archive Support Missing


        # Make sure that the target file actually exists
        if ($([IOCommon]::CheckPathExists("$($targetFile)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  test something that simply doesn't exist.  Return
            #  a failure.
            return $false;
        } # if : Target file does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -
        


        # First, lets request a new directory in the %TEMP%;
        #  this is necessary to extract the contents from the
        #  archive file.
        if ($([IOCommon]::MakeTempDirectory("Verify", [ref] $tmpDirectory)) -eq $false)
        {
            # Because we couldn't make a temporary directory, we
            #  cannot test the archive data file.
            return $false;
        } # if : Failure creating Temp. Directory


        # Secondly, now lets test the archive file by actually extracting all of the contents.
        try
        {
            # Extract the contents
            Expand-Archive -LiteralPath "$($targetFile)" `
                           -DestinationPath "$($tmpDirectory)" `
                           -ErrorAction Stop `
                           -PassThru `
                           -OutVariable execSTDOUT `
                           -ErrorVariable execSTDERR;
        } # try : Execute Extract Task

        # - Error
        catch
        {
            # A failure occurred while extracting the contents, we
            #  will assume that the archive file was corrupted.
            $testResult = $false;

            # Display error
            Write-Host "ERROR CAUGHT: $($_)";
        } # catch : Caught Error in Extract Task

        # - Finally-Do
        finally
        {
            # Thrash the temporary directory, we no longer need it.
            [IOCommon]::DeleteDirectory("$($tmpDirectory)") | Out-Null;
        } # Final : Delete the temporary data



        # Logging Section
        # =================
        # - - - - - - - - -

        # Did the user wanted logfiles?
        if ([Logging]::DebugLoggingState() -eq $true)
        {
            # If the STDOUT contains an array-list, then we will
            #  convert it as a typical string.  If necessary,
            #  add any remarks that should be in the logfile.
            if ($execSTDOUT -ne $null)
            {
                # Because some data exists in the STDOUT, we will
                #  now try to make it readable in the logfile.  We
                #  want to assure that if the user does look over
                #  the logfile - they should be able to understand
                #  it clearly.
                
                # HEADER
                # - - - - - -
                # Logfile Header

                $strSTDOUT = "Successfully verified archive data file named $($targetFileName).`r`n" + `
                                "Below is a list files that resides within the archive file and has been tested:`r`n" + `
                                "`r`n" + `
                                " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n" + `
                                "`r`n";

                # BODY
                # - - - - - -
                # Logfile Body (List of files)

                foreach ($item in $execSTDOUT)
                {
                    $strSTDOUT = "$($strSTDOUT)" + `
                                    "File: $([string]$($item))`r`n";
                } # foreach : File in List

                # FOOTER
                # - - - - - -
                # Logfile Footer
                $strSTDOUT = "$($strSTDOUT)" + `
                                "`r`n" + `
                                "`r`n" + `
                                " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n";
            } # if : STDOUT Is not null



            # If the STDERR contains information, then store
            #  it as a standard string datatype.  Luckily the
            #  information provided within the object requires
            #  no real changes or data manipulation, we can
            #  just cast it and it works like magic!  I love
            #  the simplicity!
            if ($execSTDERR -ne $null)
            {
                # No need to filter or manipulate the data, just
                #  cast it as is.  Everything we need is already
                #  available and readable.
                $strSTDERR = "$([string]$($execSTDERR))";
            } # if : STDERR Is not null


            # Create the logfiles
            [IOCommon]::PSCMDLetLogging($this.__logPath, `
                                $this.__logPath, `
                                $this.__reportPath, `
                                $false, `
                                $false, `
                                "$($execReason)", `
                                $null, `
                                [ref] $strSTDOUT, `
                                [ref] $strSTDERR );
        } # if : User Requested Logging
        
        # - - - - - - - - -
        # =================


        # Return the results
        return $testResult;
    } # VerifyArchive()




   <# List Files in Archive
    # -------------------------------
    # Documentation:
    #  This function will list all of the files that are
    #   within the target archive data file.
    #
    #  List Files Information:
    #    https://stackoverflow.com/a/14204577
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file that will contain the files that we
    #    want to list.
    #  [bool] Show Technical Information
    #   When true, this will show all of the technical
    #    information regarding each file within the data
    #    archive file.
    #   Technical Information will contain some of the following:
    #    - CRC32 checksum
    #    - FullName
    #    - Name
    #    - Compressed Size
    #    - Size
    #    - Last Write-Time
    # -------------------------------
    # Output:
    #  [string] File List
    #    List of files that exists within the archive data file.
    #    NOTE: "ERR" signifies that an error occurred.
    # -------------------------------
    #>
    [string] ListFiles([string] $file, [bool] $showTechInfo)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [System.IO.Compression.ZipArchive] $archiveData = $null;        # This will hold the archive data file information
        [string] $strFileList = $null;                                  # This will contain a list of files that is within
                                                                        #  the source archive file, with or without
                                                                        #  technical information.
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the .NET Compress Archive Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : .NET Archive Logging Directories


        # Check to make sure that the host-system support the archive functionality.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the archive support functionality was not found, we can
            #  not proceed with the validation process.
            return "ERR";
        } # if : PowerShell Archive Support Missing


        # Make sure that the archive file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  examine something that simply doesn't exist.  Return
            #  a failure.
            return "ERR";
        } # if : Target file does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Read the file information that currently exists within the source
        #  archive data file.
        $archiveData = $([IO.Compression.ZipFile]::OpenRead("$($file)"));


        # Now determine what kind of information was requested:
        # Technical Information
        if ($showTechInfo -eq $true)
        {
            # The user requested to view the technical information.
            foreach ($item in $archiveData.Entries)
            {
                # Iterate through each object in the ZipArchive type
                #  and save all information regarding each entry.
                $strFileList = "$($strFileList)" + `
                                $($item | Out-String | Foreach-Object {$_});
            } # foreach : Get technical info. for each file entry
        } # if : Technical Information

        # Simple File Information
        else
        {
            # The user requested to view only the list of files.
            foreach ($item in $archiveData.Entries)
            {
                # Save the file name.
                $strFileList = "$($strFileList)" + `
                                "File: " + $item.FullName + `
                                "`r`n";
            } # foreach : Get files in each file entry
        } # else : Standard File List


        # Return the file list
        return $strFileList;
    } # ListFiles()

    #endregion


    #region Archive File Management

   <# Extract Archive
    # -------------------------------
    # Documentation:
    #  This function will extract the requested archive data
    #   file to a specific directory.  However, the directory
    #   has to already exist in order to use that path.
    #   Within that directory, this function will create a new
    #   subdirectory named by the archive file to extract all
    #   the contents from the archive file.
    #  For Example:
    #   E:\Project\{{DESIRED_OUTPUT}}\{{FILENAME_EXTRACTED_FILES}}
    #
    #  Extract Files Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/expand-archive
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file contents that will be extracted.
    #  [string] Output Path
    #   The path to output all of the files from the archive file.
    #  [ref] {string} Directory Output
    #   The directory in which the data was extracted to within
    #   the filesystem.  This will hold the absolute path to the
    #   extracted directory.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while extracting contents.
    #    $true  = Successfully extracted contents.
    # -------------------------------
    #>
    [bool] ExtractArchive([string] $file, [string] $outputPath, [ref] $directoryOutput)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $finalOutputPath = $null;                          # This will hold the final output
                                                                    #  path that is unique.
        [string] $cacheOutputPath = $null;                          # This will help guide us to the
                                                                    #  final result; this is used as a
                                                                    #  working variable.
        [string] $getDateTime = $null;                              # This will hold the date and time,
                                                                    #  though to be only used if needing
                                                                    #  a unique directory for the output
                                                                    #  path.
        [string] $fileName = `                                      # Get the filename without the
          "$([System.IO.Path]::GetFileNameWithoutExtension($file))";#  path and file extension.
        [string] $fileNameExt = "$(Split-Path $file -leaf)";        # Get only the filename from $file, 
                                                                    #  while omitting the entire path to
                                                                    #  get to that file, extension is kept.
        [string] $execReason = "Extracting $($fileNameExt)";        # Description; used for logging
        [bool] $exitCode = $false;                                  # The exit code status provided by the
                                                                    #  Expand-Archive operation status.  If
                                                                    #  the operation was successful then
                                                                    #  true will be set, otherwise it'll be
                                                                    #  false to signify an error.
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # This will hold the STDOUT Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDOUT = [System.Object]::new();

        # This will hold the STDERR Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDERR = [System.Object]::new();

        # This will hold the STDOUT as a normal string datatype;
        #  converted output result from the STDOUT Object.
        [string] $strSTDOUT = $null;

        # This will hold the STDERR as a normal string datatype;
        #  Converted output result from the STDERR Object.
        [string] $strSTDERR = $null;
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the .NET Compress Archive Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : .NET Archive Logging Directories


        # Check to make sure that the host-system support the archive functionality.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the archive support functionality was not found, we can
            #  not proceed to extract the archive datafile.
            return $false;
        } # if : PowerShell Archive Support Missing


        # Make sure that the archive file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  extract the archive that simply doesn't exist.
            return $false;
        } # if : Target file does not exist


        # Make sure that the output path exists
        if ($([IOCommon]::CheckPathExists("$($outputPath)")) -eq $false)
        {
            # The output path does not exist, we can not extract the contents.
            return $false;
        } # if : Output Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -



        # CREATE THE OUTPUT DIRECTORY
        # - - - - - - - - - - - - - -
        # Before we can do the main operation, we
        #  first need to make sure that the output
        #  directory can be created and is also unique.
        # ---------------------------

        # Setup our Cache
        #  OutputPath + Filename
        $cacheOutputPath = "$($outputPath)\$($fileName)";


        # Does the output directory already exists?
        if ([IOCommon]::CheckPathExists("$($cacheOutputPath)") -eq $false)
        {
            # Because it is a unique directory, this is our final output destination.
            $finalOutputPath = $cacheOutputPath;

            # Create the new directory
            if([IOCommon]::MakeDirectory("$($finalOutputPath)") -eq $false)
            {
                # A failure occurred when trying to make the directory,
                #  we can not continue as the output is not available.
                return $false;
            } # INNER-if : Failed to create directory
        } # if : Does the output already exists?

        # The output directory already exists
        else
        {
            # Because the directory already exists, we need to make it unique.
            #  To accomplish this - we will timestamp the directory to make it
            #  unique while giving the data 'meaning' to it.
            #  Date and Time
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            $getDateTime = "$(Get-Date -UFormat "%d-%b-%Y_%H-%M-%S")";

            # Now put everything together
            $finalOutputPath = "$($cacheOutputPath)_$($getDateTime)";

            # Now try to make the directory, if this fails - we can't do anything more.
            if([IOCommon]::MakeDirectory("$($finalOutputPath)") -eq $false)
            {
                # A failure occurred when trying to make the directory,
                #  we can not continue as the output is not available.
                return $false;
            } # INNER-if : Failed to create directory (x2)
        } # else : Make a Unique Directory


        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the directory resides.
        #  Thus, the calling function can bring the new directory to the user's
        #  attention using whatever methods necessary.
        $directoryOutput.Value = "$($finalOutputPath)";


        # ---------------------------
        # - - - - - - - - - - - - - -



        # EXTRACT THE ARCHIVE DATAFILE
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Execute the Expand-Archive CMDLet
        try
        {
            # Extract the contents
            Expand-Archive -LiteralPath "$($file)" `
                           -DestinationPath "$($finalOutputPath)" `
                           -ErrorAction Stop `
                           -PassThru `
                           -OutVariable execSTDOUT `
                           -ErrorVariable execSTDERR;

            # Update the Exit Code status; the operation was successful.
            $exitCode = $true;
        } # try : Execute Extract Task

        # An error happened
        catch
        {
            # Display error
            Write-Host "ERROR CAUGHT: $($_)";

            # Update the Exit Code status; the operation failed.
            $exitCode = $false;
        } # catch : Caught Error in Extract Task

        # Log the activity in the logfiles (if requested)
        finally
        {
            # Does the user want logfiles?
            if ([Logging]::DebugLoggingState() -eq $true)
            {
                # If the STDOUT contains an array-list, then we will
                #  convert it as a typical string.  If necessary,
                #  add any remarks that should be in the logfile.
                if ($execSTDOUT -ne $null)
                {
                    # Get each file full name from the array-list
                    foreach ($item in $execSTDOUT)
                    {
                        $strSTDOUT = "$($strSTDOUT)" + `
                                        "File: $([string]$($item))`r`n";
                    } # foreach : File in List
                } # if : STDOUT Is not null



                # If the STDERR contains information, then store
                #  it as a standard string datatype.  Luckily the
                #  information provided within the object requires
                #  no real changes or data manipulation, we can
                #  just cast it and it works like magic!  I love
                #  the simplicity!
                if ($execSTDERR -ne $null)
                {
                    # No need to filter or manipulate the data, just
                    #  cast it as is.  Everything we need is already
                    #  available and readable.
                    $strSTDERR = "$([string]$($execSTDERR))";
                } # if : STDERR Is not null


                # Create the logfiles
                [IOCommon]::PSCMDLetLogging($this.__logPath, `
                                    $this.__logPath, `
                                    $this.__reportPath, `
                                    $false, `
                                    $false, `
                                    "$($execReason)", `
                                    $null, `
                                    [ref] $strSTDOUT, `
                                    [ref] $strSTDERR );
            } # if : User requested logging
        } # finally : Log the activity in the log files


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $exitCode;
    } # ExtractArchive()




   <# Create Archive File
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to create a new
    #   archive datafile.  This function is primarily intended
    #   for bulk operation instead of small individual file
    #   additions.  Meaning, this function mainly accepts a
    #   parent directory that already contains all of the files
    #   and subdirectories that will be added into the archive
    #   file.
    #
    #  Extract Files Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The archive file name that will be created.
    #  [string] Output Path
    #   The output path to place the archive file.
    #  [string] Target Directory
    #   The directory root that contains all of the data
    #   that we want to compact into a single archive data file.
    #  [ref] {string} Archive Path
    #   This will hold the newly created archive file's absolute
    #   path and file name.  This will be returned to the calling
    #   function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while creating the archive.
    #    $true  = Successfully created the archive.
    # -------------------------------
    #>
    [bool] CreateArchive([string] $archiveFileName, [string] $outputPath, [string] $targetDirectory, [ref] $archivePath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $targetDirectoryFiltered = `                       # This will contain a filtered version of the
            "$(Split-Path -Path "$($targetDirectory)" -Parent)";    #  targetDirectory variable.  The filtered
                                                                    #  version is mainly to ignore any wild-cards
                                                                    #  that might cause issues with directory
                                                                    #  validations.
        [string] $execReason = "Creating $($archiveFileName)";      # Description; used for logging
        [string] $getDateTime = $null;                              # This will hold the date and time,
                                                                    #  though to be only used if needing
                                                                    #  a unique archive file name.
        [string] $archiveFileExtension = "pk3";                     # This will hold the file extension for
                                                                    #  that archive file.  Because ZipFile class
                                                                    #  only supports Zip, we'll merely be using
                                                                    #  'pk3' as our default value.
                                                                    # NOTE: The Extensions will be recognized
                                                                    #  in ZDoom's standards.
                                                                    #   - ZIP == PK3
                                                                    #   - 7Z == PK7
        [string] $cacheArchiveFileName = $null;                     # When populated, this will contain a draft
                                                                    #  of the archive file name before it is
                                                                    #  actually used.
        [string] $finalArchiveFileName = $null;                     # When populated, this will contain the final
                                                                    #  version of the archive file name --
                                                                    #  essentially, this will be the archive file
                                                                    #  name.
        [bool] $exitCode = $false;                                  # The exit code status provided by the
                                                                    #  Compress-Archive operation status.  If
                                                                    #  the operation was successful then
                                                                    #  true will be set, otherwise it'll be
                                                                    #  false to signify an error.
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # This will hold the STDOUT Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDOUT = [System.Object]::new();

        # This will hold the STDERR Obj. from PowerShell's CMDLet.
        [System.Object] $execSTDERR = [System.Object]::new();

        # This will hold the STDOUT as a normal string datatype;
        #  converted output result from the STDOUT Object.
        [string] $strSTDOUT = $null;

        # This will hold the STDERR as a normal string datatype;
        #  Converted output result from the STDERR Object.
        [string] $strSTDERR = $null;

        # ----------------------------------------
        

        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the .NET Compress Archive Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : .NET Archive Logging Directories


        # Check to make sure that the host-system support the archive functionality.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the archive support functionality was not found, we can
            #  not proceed to extract the archive datafile.
            return $false;
        } # if : PowerShell Archive Support Missing


        # Make sure that the output directory exists
        if ($([IOCommon]::CheckPathExists("$($outputPath)")) -eq $false)
        {
            # The output directory does not exist;
            #  we need a valid location to output this archive file.
            return $false;
        } # if : Output directory does not exist


        # Make sure that the target directory (the contents that will be
        #  in our newly created archive file) exists.
        if ($([IOCommon]::CheckPathExists("$($targetDirectoryFiltered)")) -eq $false)
        {
            # The target directory does not exist, we
            #  can not create an archive if the directory
            #  root simply does not exist.
            return $false;
        } # if : Target Directory does not exist
        
        # ---------------------------
        # - - - - - - - - - - - - - -


        
        # DETERMINE ARCHIVE FILE NAME
        # - - - - - - - - - - - - - -
        # We need to determine the file name of the archive file,
        #  and then we also have to make sure that it is unique
        #  in the output directory.  If in case it is not unique,
        #  then we will merely throw a time stamp to the file
        #  name -- despite helping to be unique, it also gives
        #  it a meaning as well.
        # ---------------------------


        # Setup the base name and check it
        if ([IOCommon]::CheckPathExists("$($outputPath)\$($archiveFileName).$($archiveFileExtension)") -eq $false)
        {
            # Because the file does not exist, use it!
            $finalArchiveFileName = "$($outputPath)\$($archiveFileName).$($archiveFileExtension)";
        } # if : File Doesn't Exist at Path
        else
        {
            # Because the file already exists at the
            #  given output path, we will append a time
            #  stamp to the filename to assure that it
            #  is much more unique.  If in case that
            #  fails, the file already exists with that
            #  given time stamp, we can not proceed.

            # Setup the timestamp to help make it unique,
            #  but also to help supply some meaning to
            #  the file.
            #  Date and Time
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            $getDateTime = "$(Get-Date -UFormat "%d-%b-%Y_%H-%M-%S")";

            # Update the cache name for coding simplicity
            $cacheArchiveFileName = "$($archiveFileName)_$($getDateTime)";

            if ([IOCommon]::CheckPathExists("$($outputPath)\$($cacheArchiveFileName).$($archiveFileExtension)") -eq $false)
            {
                # Because the archive file is now unique, we can use that new name.
                $finalArchiveFileName = "$($outputPath)\$($cacheArchiveFileName).$($archiveFileExtension)";
            } # INNER-if : Archive File does not exist
            else
            {
                # Because the archive file name is still not unique enough, we
                #  simply can not proceed anymore.  We will have to return an error.
                return $false;
            } # INNER-else : Archive file does exist
        } # else : File Already Exists at Path


        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the archive file resides.
        #  Thus, the calling function can bring the new archive file to the user's
        #  attention using whatever methods necessary.
        $archivePath.Value = "$($finalArchiveFileName)";


        # ---------------------------
        # - - - - - - - - - - - - - -



        # CREATE ARCHIVE DATAFILE
        # - - - - - - - - - - - - - - -
        # -----------------------------
        
        # Execute the Compress-Archive CMDLet
        try
        {
            # Create the archive datafile.
            Compress-Archive -Path "$($targetDirectory)" `
                             -DestinationPath "$($finalArchiveFileName)" `
                             -CompressionLevel $this.__compressionLevel `
                             -ErrorAction Stop `
                             -PassThru `
                             -OutVariable execSTDOUT `
                             -ErrorVariable execSTDERR;

            # Update the Exit Code status; the operation was successful.
            $exitCode = $true;
        } # try : Execute Compression Task

        # An error happened
        catch
        {
            # Display error
            Write-Host "ERROR CAUGHT: $($_)";

            # Update the Exit Code status; the operation failed.
            $exitCode = $false;
        } # catch : Caught Error in Compression Task

        # Log the activity in the logfiles (if requested)
        finally
        {
            # Does the user want logfiles?
            if ([Logging]::DebugLoggingState() -eq $true)
            {
                # If the STDOUT contains an array-list, then we will
                #  convert it as a typical string.  If necessary,
                #  add any remarks that should be in the logfile.
                if ($execSTDOUT -ne $null)
                {
                    # Get each file full name from the array-list
                    foreach ($item in $execSTDOUT)
                    {
                        $strSTDOUT = "$($strSTDOUT)" + `
                                        "File: $([string]$($item))`r`n";
                    } # foreach : File in List
                } # if : STDOUT Is not null



                # If the STDERR contains information, then store
                #  it as a standard string datatype.  Luckily the
                #  information provided within the object requires
                #  no real changes or data manipulation, we can
                #  just cast it and it works like magic!  I love
                #  the simplicity!
                if ($execSTDERR -ne $null)
                {
                    # No need to filter or manipulate the data, just
                    #  cast it as is.  Everything we need is already
                    #  available and readable.
                    $strSTDERR = "$([string]$($execSTDERR))";
                } # if : STDERR Is not null


                # Create the logfiles
                [IOCommon]::PSCMDLetLogging($this.__logPath, `
                                    $this.__logPath, `
                                    $this.__reportPath, `
                                    $false, `
                                    $false, `
                                    "$($execReason)", `
                                    $null, `
                                    [ref] $strSTDOUT, `
                                    [ref] $strSTDERR );
            } # if : User requested logging
        } # finally : Log the activity in the log files



        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $exitCode;
    } # CreateArchive()

    #endregion


    #region Report

   <# Create a new Report
    # -------------------------------
    # Documentation:
    #  This function will create a report based upon
    #   the archive data file that is provided when
    #   calling this function.
    #  The report will contain information regarding
    #   the archive file, such as what files are in
    #   the file, hash information, and general
    #   information if available.
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The archive file that we are going to generate
    #    a report on.
    #  [bool] Create a PDF File
    #   When true, this will allow the ability to create
    #    a PDF document along with the textfile
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while writing the report.
    #    $true  = Successfully created the report or user
    #              did not request to generate a report.
    # -------------------------------
    #>
    [bool] CreateNewReport([string] $ArchiveFile, `
                           [bool] $makePDF)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Get the filename without the path and file extension.
        [string] $fileName ="$([System.IO.Path]::GetFileNameWithoutExtension($ArchiveFile))";

        # Get the filename without the path, extension is kept.
        [string] $fileNameExt = "$(Split-Path $ArchiveFile -leaf)";


        # This variable will hold the current date and
        #  time from the host system.  With this, it'll be accessed
        #  for the filename and inside the report.
        # >> Date
        [string] $dateNow = "$(Get-Date -UFormat "%d-%b-%y")";
        # >> Time
        [string] $timeNow = "$(Get-Date -UFormat "%H.%M.%S")";
        # >> Date && Time
        [string] $dateTime = "$($dateNow) $($timeNow)";

        # This will hold the report's filename.
        # - - - -
        # >> Standard Textfile
        [string] $fileNameTXT = "$($this.__reportPath)\$($fileNameExt) - $($dateTime).txt";
        
        # >> Portable Document File (PDF)
        [string] $fileNamePDF = "$($this.__reportPath)\$($fileNameExt) - $($dateTime).pdf";
        # - - - -

        # This variable will hold the output
        #  provided by the functions.  Because
        #  some data might be excessively large
        #  and to help minimize requiring
        #  massive heap space, we will only
        #  store only ONE output at a time.
        #  If we store MORE THAN ONE, depending
        #  on the information given, this could demand
        #  a lot from main memory.  Lets try to
        #  conserve on memory.
        # NOTE: CLR String Datatypes can reach
        #       near 3GB of memory usage.
        [string] $outputContent = $null;

        # This will be used to jump from one case to another.
        #  This will greatly help to keep the procedure organized
        #  and to assure that the data is being written properly.
        [int] $traverse = 0;

        # This variable is a small placeholder for the border
        #  that will be used for each section within this report.
        #  With this variable, it'll help avoid redundancy - by
        #  not having to retype the border over and over again.
        [string] $sectionBorder = $null;

        # This variable will be used to break out of the do-while
        #  loop.  This assures that the file is being written within
        #  the switch statement inside of the do-while loop.
        [bool] $readyToBreak = $false;
        # ----------------------------------------



        # Did the user wanted a report of an archive data file?
        if ($this.__generateReport -eq $false)
        {
            # Because the user did not want a report generated,
            #  merely return 'true'.
            return $true;
        } # if : Do not create report


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the .NET Compress Archive Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : .NET Archive Logging Directories


        # Check to make sure that the host-system support the archive functionality.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the archive support functionality was not found, we can
            #  not proceed to extract the archive datafile.
            return $false;
        } # if : PowerShell Archive Support Missing


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($ArchiveFile)")) -eq $false)
        {
            # Project Path does not exist, return an error.
            return $false;
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Before we begin creating the report, lets generate the
        #  bordering that will be used for each section in the report.
        $sectionBorder = "------------------------------`r`n" + `
                         "==============================`r`n" + `
                         "==============================`r`n";

        DO
        {
            # Begin writing the report
            switch ($traverse)
            {
                # Report Header
                0
                {
                    # Build the output
                    #  Word Art provided by this website:
                    #  http://patorjk.com/software/taag
                    #  FONT: Big
                    #  All other settings set to 'default'.
                    $outputContent = "+-------------------------------------------------------------------+`r`n" + `
                                     "|  _______       ______ _ _        _____                       _    |`r`n" + `
                                     "| |___  (_)     |  ____(_) |      |  __ \                     | |   |`r`n" + `
                                     "|    / / _ _ __ | |__   _| | ___  | |__) |___ _ __   ___  _ __| |_  |`r`n" + `
                                     "|   / / | | '_ \|  __| | | |/ _ \ |  _  // _ \ '_ \ / _ \| '__| __| |`r`n" + `
                                     "|  / /__| | |_) | |    | | |  __/ | | \ \  __/ |_) | (_) | |  | |_  |`r`n" + `
                                     "| /_____|_| .__/|_|    |_|_|\___| |_|  \_\___| .__/ \___/|_|   \__| |`r`n" + `
                                     "|         | |                                | |                    |`r`n" + `
                                     "|         |_|                                |_|                    |`r`n" + `
                                     "+-------------------------------------------------------------------+`r`n" + `
                                     "`r`n`r`n" + `
                                     "Synopsis`r`n" + `
                                     "----------`r`n" + `
                                     "This report was generated on $($dateNow) at $($timeNow) for the archive file" + `
                                     " named $($fileNameExt).  This report contains an overview of what is in the" + `
                                     " archive data file and information regarding the archive file it self." + `
                                     " The information provided can be helpful for validation purposes and assuring" + `
                                     " that archive data file itself is not damaged." + `
                                     "`r`n`r`n`r`n";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Finished with the header
                    break;
                } # Case : Report Header


                # Table of Contents
                1
                {
                    # Build the output
                    $outputContent = "Table of Contents:`r`n" + `
                                     "---------------------`r`n" + `
                                     "1) Project Information`r`n" + `
                                     "2) Archive File Information`r`n" + `
                                     "3) File Hash Details`r`n" + `
                                     "4) List of Files inside Archive`r`n" + `
                                     "`r`n`r`n";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Finished with the Table of Contents
                    break;
                } # Case : Table of Contents


                # SECTION - Project Information
                2
                {
                    # Build the output
                    $outputContent = "1) PROJECT INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is information regarding the project itself.`r`n`r`n" + `
                                     "Project Name:`r`n" + `
                                     "`t$([ProjectInformation]::projectName)`r`n`r`n" + `
                                     "Project Code Name:`r`n" + `
                                     "`t$([ProjectInformation]::codeName)`r`n`r`n" + `
                                     "Filename:`r`n" + `
                                     "`t$([ProjectInformation]::fileName)`r`n`r`n" + `
                                     "Project Website:`r`n" + `
                                     "`t$([ProjectInformation]::urlWebsite)`r`n`r`n" + `
                                     "Project's Documentation:`r`n" + `
                                     "`t$([ProjectInformation]::urlWiki)`r`n`r`n" + `
                                     "Project's Repository:`r`n" + `
                                     "`t$([ProjectInformation]::urlSource)`r`n" + `
                                     "`r`n`r`n";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Finished with the Project Info.
                    break;
                } # Case : SECTION - Project Information


                # SECTION - ARCHIVE INFORMATION
                3
                {
                    # Build the output
                    $outputContent = "2) ARCHIVE FILE INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is information regarding the archive" + `
                                     " file itself.  The information can be helpful to know" + `
                                     " the properties of the archive data file itself.`r`n`r`n" + `
                                     "File Property Information:`r`n" + `

                                     "File Base Name:`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").BaseName)`r`n`r`n" + `
                                     "File Exists in Directory:`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").DirectoryName)`r`n`r`n" + `
                                     "File Created:`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").CreationTime)`r`n`r`n" + `
                                     "File Created (UTC):`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").CreationTimeUtc)`r`n`r`n" + `
                                     "File Attributes:`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").Attributes)`r`n`r`n" + `
                                     "Size of File:`r`n" + `
                                     "  $($(Get-Item "$($ArchiveFile)").Length) bytes`r`n`r`n";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Finished with the Contributors
                    break;
                } # Case : SECTION - ARCHIVE INFORMATION

                
                # SECTION - FILE HASH INFORMATION
                4
                {
                    # Build the output
                    $outputContent = "3) FILE HASH INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "File Hash values are helpful to know if the archive" + `
                                     " file was: corrupted, damaged, or altered.  The Hash" + `
                                     " each file has is like a 'finger print', each hash" + `
                                     " is generally unique to that file at the given time." + `
                                     " When the hash value is different, in comparison to" + `
                                     " another file, it is likely that the finger-print has" + `
                                     " changed or the file itself was damaged\corrupted" + `
                                     " during transfer from one location to the next.`r`n" + `
                                     "Provided below is the list of Hash values regarding $($fileNameExt).`r`n`r`n" + `
                                     "File Hash Information:`r`n" + `

                                     "$($this.FetchHashInformation("$($ArchiveFile)"))";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Finished with the Branches
                    break;
                } # Case : SECTION - FILE HASH INFORMATION


                # SECTION - LIST OF FILES INSIDE ARCHIVE
                5
                {
                    # Build the output
                    $outputContent = "4) LIST OF FILES INSIDE ARCHIVE`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is a list of files that" + `
                                     " exists within the archive data file.`r`n`r`n" + `

                                     "List of Files inside $($fileNameExt):`r`n" + `
                                     "$($this.ListFiles("$($ArchiveFile)", $true))";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse++;


                    # Jump out of the Loop key
                    $readyToBreak = $true;


                    # Finished with the Commits Overview
                    break;
                } # Case : SECTION - LIST OF FILES INSIDE ARCHIVE


                # Default - ERROR; Run Away
                default
                {
                    # Something went horribly wrong
                    return $false;
                } # Case : DEFAULT
            } # switch()
        } While ($readyToBreak -eq $false);

        
        # Does the user also want a PDF file of the report?
        if ($makePDF -eq $true)
        {
            # Create the PDF file
            if(([IOCommon]::CreatePDFFile("$($fileNameTXT)", "$($fileNamePDF)")) -eq $false)
            {
                # Failure occurred while creating the PDF document.
                return $false;
            } # If : Failure while creating PDF
        } # If : Make PDF Report


        # Successfully wrote to the file
        return $true;

    } # CreateNewReport()

    #endregion


    #region File Management

   <# Thrash Logs and Reports
    # -------------------------------
    # Documentation:
    #  This function will expunge the log files as well
    #   as the reports generated by user's request.
    # -------------------------------
    # Input:
    #  [bool] Expunge reports
    #   When true, the reports will be thrashed.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more operations failed
    #   $true = Successfully expunged the files.
    #           OR
    #           Directories were not found
    # -------------------------------
    #>
    [bool] ThrashLogs([bool] $expungeReports)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $extLogs = @('*.err', '*.out');   # Array of log extensions
        [string[]] $extReports = @('*.txt');         # Array of report extensions
        # ----------------------------------------


        # First, make sure that the directories exist.
        #  If the directories are not available, than there
        #  is nothing that can be done.
        if (($this.__CheckRequiredDirectories()) -eq $false)
        {
            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            return $true;
        } # IF : Required Directories Exists


        # Because the directories exists, lets try to thrash the logs.
        if(([IOCommon]::DeleteFile("$($this.__logPath)", $extLogs)) -eq $false)
        {
            # Failure to remove the requested files
            return $false;
        } # If : failure to delete files


        # ----


        # Did the user also wanted to thrash the reports?
        if (($($expungeReports) -eq $true) -and `
        ([IOCommon]::DeleteFile("$($this.__reportPath)", $extReports)) -eq $false)
        {
            # Failure to remove the requested files
            return $false;
        } # If : thrash the reports



        # If we made it here, then everything went okay!
        return $true;
    } # ThrashLogs()

    #endregion
    #endregion
} # DefaultCompress




<# Default Compression Level [ENUM]
 # -------------------------------
 # Associated with what type of compression level the
 #  end-user prefers when compacting an archive datafile.
 # -------------------------------
 #>
enum DefaultCompressionLevel
{
    Optimal = 0;         # Best Compression (takes time)
    Fastest = 1;         # Light Compression (little time)
    NoCompression = 2;   # Store [No Compression]
} # DefaultCompressionLevel