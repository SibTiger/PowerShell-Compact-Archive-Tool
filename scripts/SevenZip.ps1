<# Seven Zip
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the possibility to utilize 7Zip functionality within the program.  7Zip
 #  is a popular compression tool that supports common archive data file formats such as: ZIP,
 #  GZIP, and 7Z.  For the best compression, 7Z is preferred - though it has a greater performance
 #  impact when it comes to expeditious unpacking of data in RealTime environments.  For the best
 #  performance with compression, ZIP is preferred.  With this object, it is possible to: list
 #  files, verify, extract, and create a new archive data file.  However, the use of 7Zip is
 #  merely an optional setting.  Because 7Zip is an external command (external executable), it is
 #  not required for the user to already have this particular software installed on the host system.
 #  But, in order to use 7Zip's functionality or to compact and extract a 7Z file format, then it
 #  is a requirement to install the 7Zip program from that point onward.
 # NOTE:
 #  - This is only required if wanting to: verify, list files from, generate, or extract a 7Z (or
 #     PK7 for ZDoom's mods) file.
 #  - In order to utilize 7Zip functionality within this program, the 7Zip software must first be
 #     installed properly on the host system.  Otherwise, the features may not be readily available.
 # DEPENDENCIES (Optional):
 #  7Zip version 19.00 or later.
 #   - https://www.7-zip.org/
 #>




class SevenZip
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # 7Zip Executable Path
    # ---------------
    # The path to the '7z.exe' executable within the Windows environment.
    Hidden [string] $__executablePath;


    # Compression Method
    # ---------------
    # The compression method in which to compact the newly generated archive
    #  data files.  Possible options can be:
    #   - Zip [PK3]
    #   - 7Zip [PK7]
    Hidden [SevenZipCompressionMethod] $__compressionMethod;


    # Algorithm [PK3|Zip]
    # ---------------
    # The compression algorithm that will be used when compacting the Zip (PK3)
    #  archive files.
    Hidden [SevenZipAlgorithmZip] $__algorithmZip;


    # Algorithm [PK7|7Zip]
    # ---------------
    # The compression algorithm that will be used when compacting the 7Zip (PK7)
    #  archive files.
    Hidden [SevenZipAlgorithm7Zip] $__algorithm7Zip;


    # Use Multithread
    # ---------------
    # 7Zip's multithreaded functionality
    #  When this is true, 7Zip will use multiple threads for compression and
    #  decompression operations - if supported by the various algorithms used
    #  for the archive compression methods.
    #   Supported Algorithms in Zip:
    #    - BZip2
    #   Supported Algorithms in 7Zip:
    #    - LZMA
    #    - LZMA2
    #    - BZip2
    Hidden [bool] $__useMultithread;


    # Compression Level
    # ---------------
    # How tightly to compress the files going inside the archive data file that
    #  is currently being generated.  Levels of compression range from 0 to 9.
    #  Where:
    #   - 0 is no compression
    #   - 5 is standard compression
    #   - 9 is the maximum compression possible
    Hidden [SevenCompressionLevel] $__compressionLevel;


    # Verify Build
    # ---------------
    # Test the integrity of the archive data file and the files that are within
    #  the compressed file.
    Hidden [bool] $__verifyBuild;


    # Generate Report
    # ---------------
    # Allow the possibility to generate a report about the archive datafile.
    #  Reports provide some insight about the archive datafile and the
    #  contents that are within the file itself.
    Hidden [bool] $__generateReport;


    # Log Root
    # ---------------
    # The main parent directory's absolute path that will hold this object's
    #  logs and reports directories.
    Hidden [string] $__rootLogPath;


    # Report Path
    # ---------------
    # This directory, in absolute form, will hold reports that were generated
    #  from this object.  Reports provide some insight about the archive datafile
    #  and the contents that are within the file itself.
    Hidden [string] $__reportPath;


    # Log Root Path
    # ---------------
    # This directory, in absolute form, will hold logfiles that were generated
    #  from this object when creating, verifying, extracting, and listing
    #  contents from within an archive datafile.
    Hidden [string] $__logPath;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    SevenZip()
    {
        # Executable path to the 7z.exe
        $this.__executablePath = "$($this.Find7Zip($true))";

        # Compression Method
        $this.__compressionMethod = 0;

        # Algorithm [Zip]
        $this.__algorithmZip = 0;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = 0;

        # Multithreaded Support
        $this.__useMultithread = $true;

        # Compression Level
        $this.__compressionLevel = 2;

        # Verify Build
        $this.__verifyBuild = $true;

        # Generate Report
        $this.__generateReport = $false;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";
    } # Default Constructor




    # User Preference : On-Load
    SevenZip([string] $executablePath,
            [SevenZipCompressionMethod] $compressionMethod,
            [SevenZipAlgorithmZip] $algorithmZip,
            [SevenZipAlgorithm7Zip] $algorithm7Zip,
            [bool] $useMultithread,
            [SevenCompressionLevel] $compressionLevel,
            [bool] $verifyBuild,
            [bool] $generateReport)
    {
        # Executable path to the 7z.exe
        $this.__executablePath = $executablePath;

        # Compression Method
        $this.__compressionMethod = $compressionMethod;

        # Algorithm [Zip]
        $this.__algorithmZip = $algorithmZip;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = $algorithm7Zip;

        # Multithreaded Support
        $this.__useMultithread = $useMultithread;

        # Compression Level
        $this.__compressionLevel = $compressionLevel;

        # Verify Build
        $this.__verifyBuild = $verifyBuild;

        # Generate Report
        $this.__generateReport = $generateReport;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

   <# Get Executable Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Executable Path' variable.
    # -------------------------------
    # Output:
    #  [string] Executable Path
    #   The value of the 'Executable Path' to the 7z.exe binary file.
    # -------------------------------
    #>
    [string] GetExecutablePath()
    {
        return $this.__executablePath;
    } # GetExecutablePath()




   <# Get Compression Method
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compression Method' variable.
    # -------------------------------
    # Output:
    #  [SevenZipCompressionMethod] Compression Method
    #   The value of the 'Compression Method'.
    # -------------------------------
    #>
    [SevenZipCompressionMethod] GetCompressionMethod()
    {
        return $this.__compressionMethod;
    } # GetCompressionMethod()




   <# Get Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Algorithm' variable used with Zip method..
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithmZip] Algorithm [ZIP]
    #   The value of the 'Compression Algorithm'.
    # -------------------------------
    #>
    [SevenZipAlgorithmZip] GetAlgorithmZip()
    {
        return $this.__algorithmZip;
    } # GetAlgorithmZip()




   <# Get Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Algorithm' variable used with 7Zip method.
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithm7Zip] Algorithm [7Zip]
    #   The value of the Compression Algorithm.
    # -------------------------------
    #>
    [SevenZipAlgorithm7Zip] GetAlgorithm7Zip()
    {
        return $this.__algorithm7Zip;
    } # GetAlgorithm7Zip()




   <# Get Use Multithread
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Use Multithread' variable.
    # -------------------------------
    # Output:
    #  [bool] Use Multithread
    #   The value of the 'Use Multithread'.
    # -------------------------------
    #>
    [bool] GetUseMultithread()
    {
        return $this.__useMultithread;
    } # GetUseMultithread()




   <# Get Compression Level
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compression Level' variable.
    # -------------------------------
    # Output:
    #  [SevenCompressionLevel] Compression Level
    #   The value of the 'Compression Level'.
    # -------------------------------
    #>
    [SevenCompressionLevel] GetCompressionLevel()
    {
        return $this.__compressionLevel;
    } # GetCompressionLevel()




   <# Get Verify Build
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Verify Build' variable.
    # -------------------------------
    # Output:
    #  [bool] Verify Build
    #   The value of the 'Verify Build'.
    # -------------------------------
    #>
    [bool] GetVerifyBuild()
    {
        return $this.__verifyBuild;
    } # GetVerifyBuild()




   <# Get Generate Report
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Generate Report' variable.
    # -------------------------------
    # Output:
    #  [bool] Generate Report
    #   The value of the 'Generate Report'.
    # -------------------------------
    #>
    [bool] GetGenerateReport()
    {
        return $this.__generateReport;
    } # GetGenerateReport()




   <# Get Report Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Report Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Report Path
    #   The value of the 'Report Directory Path'.
    # -------------------------------
    #>
    [string] GetReportPath()
    {
        return $this.__reportPath;
    } # GetReportPath()




   <# Get Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Log Path
    #   The value of the 'Log Directory Path'.
    # -------------------------------
    #>
    [string] GetLogPath()
    {
        return $this.__logPath;
    } # GetLogPath()




   <# Get Root Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Root Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Root Log Path
    #   The value of the 'Log Root Directory Path'.
    # -------------------------------
    #>
    [string] GetRootLogPath()
    {
        return $this.__rootLogPath;
    } # GetRootLogPath()


    #endregion



    #region Setter Functions

   <# Set Executable Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Executable Path' variable.
    # -------------------------------
    # Input:
    #  [string] Executable Path
    #   The location of the 7Zip executable within the host system.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetExecutablePath([string] $newVal)
    {
        # Because we are testing for an actual file, we have to assure
        #  that the file really exists within the host's filesystem.
        if(([IOCommon]::DetectCommand("$($newVal)", "Application")) -eq $false)
        {
            # Could not find the executable.
            return $false;
        } # If : Command Not Found


        # Set the path
        $this.__executablePath = $newVal;

        # Successfully updated.
        return $true;
    } # SetExecutablePath()




   <# Set Compression Method
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compression Method' variable.
    # -------------------------------
    # Input:
    #  [SevenZipCompressionMethod] Compress Method
    #   The choice between 7Zip or Zip archive data file format.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionMethod([SevenZipCompressionMethod] $newVal)
    {
        # Because the value must fit within the 'SevenZipCompressionMethod'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__compressionMethod = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionMethod()




   <# Set Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Zip Algorithm' variable.
    # -------------------------------
    # Input:
    #  [SevenZipAlgorithmZip] Algorithm Zip
    #   The algorithm that will be used when compacting a new Zip archive data file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithmZip([SevenZipAlgorithmZip] $newVal)
    {
        # Because the value must fit within the 'SevenZipAlgorithmZip'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__algorithmZip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithmZip()




   <# Set Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the '7Zip Algorithm' variable.
    # -------------------------------
    # Input:
    #  [SevenZipAlgorithm7Zip] Algorithm 7Zip
    #   The algorithm that will be used when compacting a new 7Zip archive data file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithm7Zip([SevenZipAlgorithm7Zip] $newVal)
    {
        # Because the value must fit within the 'SevenZipAlgorithm7Zip'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__algorithm7Zip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithm7Zip()




   <# Set Use Multithread
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Use Multithread' variable.
    # -------------------------------
    # Input:
    #  [bool] Use Multithread
    #   When true, this will allow 7Zip to utilize multiple threads on
    #    the host system's CPU.  Otherwise, only one thread will be used.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUseMultithread([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__useMultithread = $newVal;

        # Successfully updated.
        return $true;
    } # SetUseMultithread()




   <# Set Compression Level
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compression Level' variable.
    # -------------------------------
    # Input:
    #  [SevenCompressionLevel] Compression Level
    #   The desired compression level for compacting newly generated
    #    archive data files.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionLevel([SevenCompressionLevel] $newVal)
    {
        # Because the value must fit within the 'SevenCompressionLevel'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__compressionLevel = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionLevel()




   <# Set Verify Build
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Verify Build' variable.
    # -------------------------------
    # Input:
    #  [bool] Verify Archive
    #   When true, allow the possibility to test the archive datafile's
    #    integrity.  Otherwise, do not allow the possibility to
    #    examine the archive file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVerifyBuild([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__verifyBuild = $newVal;

        # Successfully updated.
        return $true;
    } # SetVerifyBuild()




   <# Set Generate Report
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Generate Report' variable.
    # -------------------------------
    # Input:
    #  [bool] Generate Report
    #   When true, this will allow the report functionality to be
    #    executed.  Otherwise the report functionality will be turned
    #    off.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGenerateReport([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__generateReport = $newVal;

        # Successfully updated.
        return $true;
    } # SetGenerateReport()




   <# Set Root Log Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Root Log Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Root Log Path
    #   The new location of the Root Log directory.
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
    #  Sets a new value for the 'Log Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Log Path
    #   The new location of the Logging directory.
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
    #  Sets a new value for the 'Report Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Report Path
    #   The new location of the Report directory.
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


   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function will check to make sure that the log and report directories,\
    #   that are used in this class, currently exists within the host system's filesystem.
    #
    # ----
    #
    #  Directories to be checked:
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\reports
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
        if ((([IOCommon]::CheckPathExists("$($this.__rootLogPath)", $true)) -eq $true) -and `

        # Check Report Path
        (([IOCommon]::CheckPathExists("$($this.__reportPath)", $true)) -eq $true) -and `

        # Check Log Path
        (([IOCommon]::CheckPathExists("$($this.__logPath)", $true) -eq $true)))
        {
            # All of the directories exists
            return $true;
        } # If : Check Directories Exists

        # One or more of the required directories was not found.
        else
        {
            # Directories does not exist.
            return $false;
        } # Else : Directories does not exist
    } # __CheckRequiredDirectories()




   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories that will hold the log and
    #   report files that are generated from this class.  If the directories does not
    #   exist on the filesystem already, there is a change that some operations might
    #   fail due to the inability to properly store the log and\or the report files
    #   generated by the functions within this class.  If the directories does not
    #   already exist, this function will try to create them automatically - without
    #   interacting with the end-user.  If the directories already exist within the
    #   filesystem, then nothing will be performed.
    #
    # ----
    #
    #  Directories to be created:
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\reports
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
        # First, check if the directories already exist.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The 7Zip logging directories already exists;" + `
                                    " there is no need to create the directories again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
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
        if(([IOCommon]::CheckPathExists("$($this.__rootLogPath)", $true)) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__rootLogPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip root logging and report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The root directory path is: $($this.__rootLogPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; couldn't create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Root Log Directory


        # ----


        # Log Directory
        if(([IOCommon]::CheckPathExists("$($this.__logPath)", $true)) -eq $false)
        {
            # Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__logPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The logging directory path is: $($this.__logPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; couldn't create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Log Directory


        # ----


        # Report Directory
        if(([IOCommon]::CheckPathExists("$($this.__reportPath)", $true)) -eq $false)
        {
            # Report Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$($this.__reportPath)")) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The report directory path is: $($this.__reportPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; couldn't create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Report Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created the 7Zip logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
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
        # If the directories could not be detected - despite being created on the filesystem,
        #  then something went horribly wrong.
        else
        {
            # The directories couldn't be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the 7Zip required logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
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


    #endregion



    #region Public Functions


    #region 7Zip Detection


   <# Detect 7Zip Executable
    # -------------------------------
    # Documentation:
    #  This function will try to detect the 7Zip executable by making sure that the
    #   assigned member variable is setup properly.  To accomplish this task, this
    #   function will make sure that the variable contains some sort of data and to
    #   make sure that the variable is pointing to a binary file.  After investigating
    #   the variable, this function will return the result in boolean form.
    # -------------------------------
    # Output:
    #  [bool] Detected Code
    #    $false = Failed to detect the external executable.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    [bool] Detect7ZipExist()
    {
        # Make sure that the value is not empty (or null).
        if ($this.__executablePath -eq $null)
        {
            # No value was provided; unable to perform a check as nothing was provided.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the 7Zip executable as there was no path provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the value is empty, this function was unable to detect the
            #  executable file.
            return $false;
        } # if : Executable Path is Empty


        # Check if the 7Zip executable was found.
        if (([IOCommon]::DetectCommand("$($this.__executablePath)", "Application")) -eq $true)
        {
            # Successfully located the 7Zip executable.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully located the 7Zip executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable was found.
            return $true;
        } # If : Detected 7Zip

        # Failed to detect the executable.
        else
        {
            # The path provided already does not point to a valid executable or
            #  the path does not exist.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the 7Zip executable as the path was not valid!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable could not be found.
            return $false;
        } # Else : Unable to Detected 7zip
    } # Detect7ZipExist()




   <# Find 7Zip
    # -------------------------------
    # Documentation:
    #  This function will try to automatically find the 7Zip executable by checking
    #   some prevalent locations within the host's filesystem.  If this function was
    #   able to successfully detect the executable, then the path to the binary file
    #   will be returned.  Otherwise, if the application was not found, then '$null'
    #   will be returned instead.
    # -------------------------------
    # Output:
    #  [string] 7Zip Executable (Absolute) Path
    #    Returns the location of where the 7Zip application resides.
    #    NOTE:
    #       $null - signifies that the 7Zip executable could not be found in the common
    #                locations.
    # -------------------------------
    #>
    [string] Find7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $path = @("7z.exe",`                                 # Location: %PATH%
                             "7za.exe", `                               # Location: %PATH% {7Zip CLI; Stand-Alone}
                            "${env:PROGRAMFILES}\7-Zip\7z.exe", `       # Location: %ProgramFiles%       {x86_32}
                            "${env:PROGRAMFILES(x86)}\7-Zip\7z.exe");   # Location: %ProgramFiles(x86)%  {x86_64}
        # ----------------------------------------


        # Try to automatically find the 7Zip executable by inspecting each path within the array.
        foreach ($index in $path)
        {
            # Check the path to see if the 7Zip application was found with the given path.
            if([IOCommon]::DetectCommand("$($index)", "Application") -eq $true)
            {
                # Successfully found the executable


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Successfully located the 7Zip executable!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "7Zip was found in: $($index)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Verbose");                 # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Successfully found the executable; return the path.
                return "$($index)";
            } # if : Inspect the Individual Path
        } # Foreach : Check all Common Paths



        # Could not find the 7Zip executable


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Could not automatically locate the 7Zip executable!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Places to automatically look:`r`n" + `
                                    "`t`t- $($path -join "`r`n`t`t- ")");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                    "$($logAdditionalMSG)", `   # Additional information
                                    "Warning");                 # Message level

        # * * * * * * * * * * * * * * * * * * *


        # If the application could not be found, then return nothing ($null) to signify
        #  that this function was unable to find the application.
        return $null;
    } # Find7Zip()

    #endregion


    #region Inspect Archive

   <# Archive-File Hash
    # -------------------------------
    # Documentation:
    #  This function will generate and provide the desired hash value from the
    #   requested archive data file.  If incase the hash value is unobtainable,
    #   such as the archive data file being corrupted; file was not found; hash
    #   failed to be generated; or any reason at all, then this function will
    #   return 'ERR' to signify that an error had occurred.
    #
    # DEVELOPER NOTES:  Because 7Zip does _NOT_ provide clean output, such as
    #       returning only the hash value, the use of Regular Expression is
    #       required to parse the output.  PowerShell, luckily, supports RegEx!
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that the hash value will be generated from.
    #  [FileHashAlgorithm7Zip] Hashing Algorithm
    #   The requested hash algorithm to generate from the desired archive data file.
    #    NOTE: For a list of supported algorithms, please check this website:
    #          https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
    # -------------------------------
    # Output:
    #  [string] Hash Value
    #   The generated hash value from the requested archive file.
    #    NOTE:
    #       ERR - signifies that an error has been reached, the hash value could not
    #               be generated.
    # -------------------------------
    #>
    [string] ArchiveHash([string] $file,                            # The archive file that the hash value is generated from.
                        [FileHashAlgorithm7Zip] $hashAlgorithm)     # The desired hash algorithm to generate.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)";     # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "h -scrc$($hashAlgorithm) `"$($file)`""; # Arguments to be used when invoking the 7Zip executable.
                                                                        #  This will allow 7Zip to generate the desired Hash information
                                                                        #  based from the archive datafile.
        [string] $outputResult = $null;                                 # This variable will hold the newly generated hash value from the
                                                                        #  7Zip executable.
        [string] $execReason = "Generate $($hashAlgorithm) Hash";       # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the logging requirements are met.
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the hash value of the desired archive file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we can not run the operation.
            return "ERR";
        } # If : Logging Requirements are Met


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the Hash value as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip executable was not found, it is not possible" + `
                                        " to generate the requested hash value.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the 7Zip executable was not found, it is not possible to generate the Hash value.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($file)", $true)) -eq $false)
        {
            # The requested file does not exist.  We cannot generate a hash value without the archive datafile.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the Hash value as the archive data file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the archive data file does not exist with the given path.
            return "ERR";
        } # if : File does not exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command to generate the desired hash information.
        if ($([IOCommon]::ExecuteCommand("$($this.__executablePath)", `     # 7Zip Executable Path
                                        "$($extCMDArgs)", `                 # Arguments to generate the hash from the archive data file.
                                        "$($sourceDir)", `                  # The working directory that 7Zip will start from.
                                        "$($this.__logPath)", `             # The Standard Output Directory path.
                                        "$($this.__logPath)", `             # The Error Output Directory path.
                                        "$($this.__reportPath)", `          # The Report Directory path.
                                        "$($execReason)", `                 # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                           # Are we building a report?
                                        $true, `                            # We will be capturing the STDOUT - we will need to process it.
                                        [ref]$outputResult)) -ne 0)         # Variable containing the STDOUT; used for processing.
        {
            # 7Zip closed with an error


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to fetch the Hash value as 7Zip returned an error!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application returned an error, it was not" + `
                                        " possible to fetch the requested Hash value.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # This function will return an error as the 7Zip executable reported a possible failure.
            return "ERR";
        } # if : 7Zip Closed with Error


        # Evaluation Requirement Check
        # - - - - - - - - - - - - - -
        # Before we can perform some various operations using Regular Expression, we
        #  first need to make sure that the output, generated by 7Zip, meets the basic
        #  requirements for this function to operate successfully.
        #  Requirements are the following:
        #   - The data is NOT null or empty.
        #   - The data contains a recognizable key phrase.  This key phrase is necessary
        #      in order to make sure that the data provided by the 7Zip executable was valid.
        #      All other values could possibly mean that the archive file was corrupted,
        #      unsupported hash value, or something just went horribly wrong.
        #  If the requirements are not meant - then it is simply not possibly to get the
        #   hash value or to properly parse the data.
        # ---------------------------

        # Make sure that the variable containing the Hash information, from 7Zip, is not empty.
        #  We need the variable to be initialized with some sort of data, if the data provided
        #  was empty (or null) - it is not possible to properly evaluate the output as needed.
        if ("$($outputResult)" -eq "$($null)")
        {
            # The output cannot be evaluated; there's nothing to inspect.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Could not obtain the Hash value as the value was either empty or lost!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("An error occurred were the Hash value was either not provided by" + `
                                        " 7Zip or was lost internally.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the hash value was not fully captured, this function will have to return an error.
            return "ERR";
        } # if : Output Result is Empty


        # The most important part, does the key-phrase exists within the output?  If the
        #  key-phrase was found, it is possible to proceed further within this function.
        #
        #  KEY-PHRASE(RegEx):
        #    "Everything\ is\ Ok\r\n$"
        if ($($($outputResult) -match "Everything Is Ok`r`n$") -eq $false)
        {
            # The key-phrase was not detected, it is not possible to parse the data correctly.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to prase the Hash value provided by the 7Zip application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Unable to parse the Hash Value as the Key-Phrase was not found as expected!`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the Key-Phrase was not found in 7Zip's output.
            return "ERR";
        } # if : Key-Phrase not Detected

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Now, to do some RegEx'ing!
        # - - - - - - - - - - - - - -
        # ---------------------------
        # To assure that I - as well as others - are able to follow the parsing protocol,
        #  the procedure has been split up into several steps to insure that it is easy
        #  to follow and to maintain in the future.
        # Please see this link for PowerShell RegEx
        #  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions


        # REGEX PASS 1
        # Replace 'Everything is Okay' with nothing
        #  NOTE: PowerShell RegEx Commands
        #   `r`n = New Line
        #      $ = End of Line
        $outputResult = $($outputResult -replace "`r`n`r`nEverything Is Ok`r`n$", "")


        # REGEX PASS 2
        # Capture the Hash Value from the end of the output provided by the 7Zip executable.
        #  Check to make sure that the Hash Value was found at the end of the output string,
        #  if not detected - then something else was unexpectedly found.
        if ("$($($outputResult) -match "\s\w+$")" -eq $false)
        {
            # The hash value was not found as expected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to parse the Hash value successfully!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Unable to properly prase the output that was gathered by the 7Zip application." + `
                                        "  Expected to find the Hash Value at Pass 2.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The parsing value did not match with what was expected, immediately leave
            #  and return an error.
            return "ERR";
        } # if : Unexpected Value Reached - Error


        # FINAL
        # Return the final result, which should only contain the parsed Hash Value that was
        #  generated by the 7Zip executable.
        return "$($matches[0])"
    } # ArchiveHash()




   <# Verify Archive
    # -------------------------------
    # Documentation:
    #  This function will initiate 7Zip's ability to test the file contents
    #   that currently resides within the archive data file as well as verify
    #   the archive file's data structure.  With this function, it is possible
    #   to identify if the data within the archive is corrupted or if the
    #   archive's structure was damaged.
    #
    #  Test Integrity Informatoin:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/test.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that will be verified.  This
    #    verification process checks the compact file's data structure and
    #    the data within the compressed file itself.
    # -------------------------------
    # Output:
    #  [bool] Verification Process Code
    #    $false = The archive data file is corrupted.
    #    $true = The archive data file is healthy.
    # -------------------------------
    #>
    [bool] VerifyArchive([string] $file)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "$(Split-Path $file -leaf)";           # Obtain only just the file name itself while omitting
                                                                    #  the absolute path.
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"; # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "t `"$($file)`"";                    # Arguments to be used when invoking the 7Zip executable.
                                                                    #  This will allow 7Zip to perform a verification test on
                                                                    #  the specified archive data file.
        [string] $outputResult = $null;                             # This variable will hold the output that is generated by
                                                                    #  the 7Zip executable.
        [string] $execReason = "Verifying $($fileName)";            # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------


        # Make sure that the logging requirements are met.
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file due to logging complications!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tArchive data file to verify: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to test the desired " + `
                                        "archive data file's integrity.`r`n" + `
                                        "`tArchive data file to verify: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return false to signify that the operation had failed.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($file)", $true)) -eq $false)
        {
            # The archive data file does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file as the compact file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tArchive data file to verify: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the archive file was not found, it is not possible to perform a test.
            return $false;
        } # if : File does not exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ($([IOCommon]::ExecuteCommand("$($this.__executablePath)", `     # 7Zip Executable Path
                                        "$($extCMDArgs)", `                 # Arguments to generate the hash from the archive data file.
                                        "$($sourceDir)", `                  # The working directory that 7Zip will start from.
                                        "$($this.__logPath)", `             # The Standard Output Directory path.
                                        "$($this.__logPath)", `             # The Error Output Directory path.
                                        "$($this.__reportPath)", `          # The Report Directory path.
                                        "$($execReason)", `                 # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                           # Are we building a report?
                                        $true, `                            # We will be capturing the STDOUT - we will need to process it.
                                        $outputResult)) -ne 0)              # Variable containing the STDOUT; used for processing.
        {
            # 7Zip closed with an error; the archive file did not pass the verification test.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "7Zip detected that the archive data file may had been corrupted or damaged!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because 7Zip reported that the archive data file is corrupted or damaged, " + `
                                        "it may not be possible to recover the data or to access the contents within " + `
                                        "the archive file.`r`n" + `
                                        "`tArchive data file to verify: $($file)`r`n" + `
                                        "`tPossible Output from 7Zip: $($outputResult)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # 7Zip had detected that the archive file is corrupted.
            return $false;
        } # if : Verification Test Failed


        # Verification Test Passed!
        return $true;
    } # VerifyArchive()




   <# Fetch Hash Information
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the possible hash information
    #   associated with the desired archive data file.
    #  The file hashes are essentially a finger print to that specific
    #   file.  If the hash provided differs from the previously known
    #   hash information, then it could mean that the file could have
    #   been corrupted or was modified.
    # -------------------------------
    # Input:
    #  [string] Archive File Path
    #   The absolute path to the desired archive data file to inspect.
    # -------------------------------
    # Output:
    #  [string] Hash Values
    #   A string list of all supported hash values that are associated
    #    with the desired archive data file.
    # -------------------------------
    #>
    [string] FetchHashInformation([string] $file)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $archiveInfo = $null;      # This will hold our list of the hash values
        # ----------------------------------------

        # Get all of the hash values that is associated with the archive file.
        #  NOTE: MD5 is also attached to the list as it is still commonly used and widely accepted.
        $archiveInfo =(
                "CRC32:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "crc32"))`r`n`r`n" + `
                "CRC64:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "crc64"))`r`n`r`n" + `
                "SHA1:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "sha1"))`r`n`r`n" + `
                "CRC256:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "sha256"))`r`n`r`n" + `
                "BLAKE2sp:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "blake2sp"))`r`n`r`n" + `
                "MD5:`r`n" + `
                "   $([IOCommon]::FileHash("$($file)", "md5"))`r`n`r`n");


        # Return the file hash information.
        return $archiveInfo;
    } # FetchHashInformation()




   <# List Files in Archive
    # -------------------------------
    # Documentation:
    #  This function will provide a list of files that currently resides within the archive data file.
    #   The list generated will be returned to the calling function.
    #
    #  List Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/list.htm
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The archive file that will be inspected.
    #  [bool] Show Technical Information
    #   When true, this will show All Technical Information - provided by 7Zip.
    #    This will use the '-slt' argument when providing a list of all of the
    #    files that is associated within the archive data file.
    # -------------------------------
    # Output:
    #  [string] File List
    #    List of files that exists within the archive file.
    #    NOTE:
    #       ERR - signifies that an error has been reached, the list could not
    #               be generated.
    # -------------------------------
    #>
    [string] ListFiles([string] $file,              # The Archive File to Inspect
                        [bool] $showTechInfo)       # Provide Verbose Information regarding Each File
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "$(Split-Path $file -leaf)";           # Obtain only just the file name itself while omitting
                                                                    #  the absolute path.
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"; # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "l `"$($file)`"";                    # Arguments to be used when invoking the 7Zip executable.
                                                                    #  This will allow 7Zip to retrieve a list of all of the
                                                                    #  files that exists within the archive file.
        [string] $outputResult = $null;                             # This variable will hold the output that is generated by
                                                                    #  the 7Zip executable.
        [string] $execReason = "List From $($fileName)";            # Description; used for logging
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file due to logging complications!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tArchive data to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we can not run the operation.
            return "ERR";
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to retrieve a list of files" + `
                                        " that currently resides within the archive data file.`r`n" + `
                                        "`tArchive data file to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return an error to signify that the operation had failed.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($file)", $true)) -eq $false)
        {
            # The archive data file does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file as the compact file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tAbsolute Path of the Archive file: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # It is not possible to inspect the archive file as it was not found.
            return "ERR";
        } # if : File does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # If the user requested verbose information regarding each file, then just
        #  append that argument to the parameter list.
        if ($showTechInfo -eq $true)
        {
            # This will append the 'Technical Information' argument to the parameter
            #  list.  With that argument, it will provide verbose information regarding
            #  each file within the archive data file.
            $extCMDArgs = "$($extCMDArgs) -slt";
        } # if : Provide Technical Information


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `   # 7Zip Executable Path
                                "$($extCMDArgs)", `                 # Arguments to provide a list of all files within the archive file.
                                "$($sourceDir)", `                  # The working directory that 7Zip will start from.
                                "$($this.__logPath)", `             # The Standard Output Directory path.
                                "$($this.__logPath)", `             # The Error Output Directory path.
                                "$($this.__reportPath)", `          # The Report Directory path.
                                "$($execReason)", `                 # The reason why we are running 7Zip; used for logging purposes.
                                $false, `                           # Are we building a report?
                                $true, `                            # We will be capturing the STDOUT - we will need to process it.
                                [ref]$outputResult) | Out-Null;     # Variable containing the STDOUT; used for processing.


        # Just for assurance; make sure that we have an actual list from the archive
        #  file.  If in case the list was not  retrieved successfully, then place an
        #  'ERR' to signify that an issue occurred, but still providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : List was not valid


        # Output the final result
        return $outputResult;
    } # ListFiles()

    #endregion


    #region Archive File Management

   <# Extract Archive
    # -------------------------------
    # Documentation:
    #  This function will extract all of the contents that reside within the
    #   provided archive data file to the desired output directory.  This
    #   function will create a new directory with the same name as the archive
    #   file, omitting the file extension, within the desired output path given
    #   - this will be our extracting directory.  If incase the final extracting
    #   directory already exists, then this function will try to make a unique
    #   directory by attaching a time and data stamp to the directory's name.
    #   Though, if this function is incapable of creating a unique directory
    #   then the entire operation will be aborted as there is no valid directory
    #   to store the data that would be extracted.
    #  For Example:
    #   E:\User\JackMass\Documents\{{DESIRED_OUTPUT}}\{{ARCHIVE_FILENAME_EXTRACTED_FILES}}\*
    #  OR
    #   E:\User\JackMass\Documents\{{DESIRED_OUTPUT}}\{{FILENAME_EXTRACTED_FILES}}{{DATE_TIME_STAMP}}\*
    #
    #  Extract Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/extract.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that will be extracted.
    #  [string] Output Path
    #   The absolute path of where to extract all of the contents within the desired
    #    archive file.
    #  [string] (REFERENCE) Directory Output
    #   The extracting directory's absolute path of where the contents of the archive file
    #    have been placed within the system's filesystem.  This path will be returned back
    #    to the calling function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = A failure occurred while extracting contents from the archive file.
    #    $true  = Successfully extracted contents from the archive file.
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
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"; # Working Directory when executing the
                                                                    #  extCMD.
        [string] $extCMDArgs = "x `"$($file)`"";                    # Arguments for the external command
                                                                    #  This will get 7zip to list all of
                                                                    #  the files within the requested
                                                                    #  archive datafile.
        [string] $execReason = "Extracting $($fileNameExt)";        # Description; used for logging
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            # Because the logging features are required, we can not run the operation.
            return $false;
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the target file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)", $true)) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  test something that simply doesn't exist.  Return
            #  a failure.
            return $false;
        } # if : Target file does not exist


        # Make sure that the output path exists
        if ($([IOCommon]::CheckPathExists("$($outputPath)", $true)) -eq $false)
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
        if ([IOCommon]::CheckPathExists("$($cacheOutputPath)", $true) -eq $false)
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



        # EXECUTE THE 7ZIP EXTRACT TASK
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Attach the output directory to the extCMD Arguments
        $extCMDArgs = "$($extCMDArgs) -o`"$($finalOutputPath)`"";
        

        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $false, `
                            $false, `
                            $null) -ne 0)
        {
            # 7Zip reached an error
            return $false;
        } # if : Extraction Operation Failed


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $true;
    } # ExtractArchive()




   <# Create Archive File
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to create a new archive data
    #   file by using the 7Zip application.  Though, this functionality
    #   only works with bulk operations instead of minor additions by
    #   updating an already existing archive file.  Meaning, this function
    #   mainly accepts a parent directory that already contains all of the
    #   files and subdirectories that will be added into the compressed file.
    #
    #  Extract Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/add.htm
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The name of the archive file that will be created during this operation.
    #  [string] Output Path
    #   The path to place the newly created archive data file.
    #  [string] Target Directory
    #   The root of the directory that contains all of the data that we want to compact
    #    into a single archive data file.
    #   NOTE: This argument might contain wildcards, for example:
    #       D:\Users\Admin\Desktop\TopSecret\*.*
    #  [string] (REFERENCE) Archive File Path
    #   This will hold the absolute path, including the file name, of the newly
    #    created archive file's final destination within the system's filesystem.
    #    This path will be returned back to the calling function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = A failure occurred while creating the archive file.
    #    $true  = Successfully created the archive file.
    # -------------------------------
    #>
    [bool] CreateArchive([string] $archiveFileName, `       # The name of the archive that will be created.
                        [string] $outputPath, `             # The destination path of the archive file.
                        [string] $targetDirectory, `        # The directory we want to compact; may contain wildcards.
                        [ref] $archivePath)                 # The full path of the archive file's location.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $sourceDir = "$(Get-Item $targetDirectory)";       # Working Directory when executing the
                                                                    #  extCMD.
        [string] $extCMDArgs = $null;                               # Arguments for the external command
                                                                    #  When populated, this will contain
                                                                    #  the arguments needed to create an
                                                                    #  archive file.  However, when built,
                                                                    #  this will contain the user's settings
                                                                    #  when compacting the archive file.
                                                                    #  For example, preferred algorithm,
                                                                    #  compression level, etc.
        [string] $execReason = "Creating $($archiveFileName)";      # Description; used for logging
        # = = = = = = = = = = = = = = = = = = = = =
        [string] $getDateTime = $null;                              # This will hold the date and time,
                                                                    #  though to be only used if needing
                                                                    #  a unique archive file name.
        [string] $archiveFileExtension = $null;                     # When populated, this will hold the
                                                                    #  file extension for that archive file.
                                                                    #  NOTE: The Extensions will be recognized
                                                                    #  in ZDoom's standards.  Thus, ZIP == PK3
                                                                    #  and 7Z == PK7.
        [string] $cacheArchiveFileName = $null;                     # When populated, this will contain a draft
                                                                    #  of the archive file name before it is
                                                                    #  actually used.
        [string] $finalArchiveFileName = $null;                     # When populated, this will contain the final
                                                                    #  version of the archive file name --
                                                                    #  essentially, this will be the archive file
                                                                    #  name.
        # ----------------------------------------
        

        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            # Because the logging features are required, we can not run the operation.
            return $false;
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the output directory exists
        if ($([IOCommon]::CheckPathExists("$($outputPath)", $true)) -eq $false)
        {
            # The output directory does not exist;
            #  we need a valid location to output this archive file.
            return $false;
        } # if : Output directory does not exist


        # Make sure that the target directory (the contents that will be
        #  in our newly created archive file) exists.
        if ($([IOCommon]::CheckPathExists("$($targetDirectory)", $true)) -eq $false)
        {
            # The target directory does not exist, we
            #  can not create an archive if the directory
            #  root simply does not exist.
            return $false;
        } # if : Target Directory does not exist
        
        # ---------------------------
        # - - - - - - - - - - - - - -


        
        # DETERMINE ARCHIVE FILE EXTENSION
        # - - - - - - - - - - - - - - - - -
        # We will need to figure out what the preferred
        #  file extension is before we can append it to
        #  the filename and the main compacting process.
        # ---------------------------------
        
        # Inspect user's choice
        switch ($this.__compressionMethod)
        {
            "Zip"
            {
                # Zip {PK3} Compression Method
                $archiveFileExtension = "pk3";
                break;
            } # Zip | PK3

            "SevenZip"
            {
                # 7Zip {PK7} Compression Method
                $archiveFileExtension = "pk7";
                break;
            } # 7Zip | PK7

            default
            {
                # The compression method selected
                #  is unknown, we must have a valid
                #  compression method before we can
                #  continue.
                return $false;
            } # Unknown
        } # switch


        # ---------------------------------
        # - - - - - - - - - - - - - - - - -
        


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
        if ([IOCommon]::CheckPathExists("$($outputPath)\$($archiveFileName).$($archiveFileExtension)", $true) -eq $false)
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

            if ([IOCommon]::CheckPathExists("$($outputPath)\$($cacheArchiveFileName).$($archiveFileExtension)", $true) -eq $false)
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



        # BUILD-UP THE ARGUMENTS
        # - - - - - - - - - - - -
        # Append all of the user's settings
        #  in the extCMD's parameter string.
        # -----------------------


        # Since we are going to create a new
        #  archive file, add the 'add' switch
        #  to the extCMD parameters.
        $extCMDArgs = "a";


        # Attach the archive file name
        $extCMDArgs = "$($extCMDArgs) `"$($finalArchiveFileName)`"";


        # Attach the target directory
        $extCMDArgs = "$($extCMDArgs) `"$($targetDirectory)`"\*";
        

        # Now determine the compression method
        #  that the user wanted to build and
        #  also attach the requested compression
        #  algorithm.
        switch ($this.__compressionMethod)
        {
            "Zip"
            {
                # Zip {PK3} Compression Method
                $extCMDArgs = "$($extCMDArgs) -tzip -mm=$($this.__algorithmZip)";
                break;
            } # Zip | PK3

            "SevenZip"
            {
                # 7Zip {PK7} Compression Method
                $extCMDArgs = "$($extCMDArgs) -t7z -mm=$($this.__algorithm7Zip)";
                break;
            } # 7Zip | PK7

            default
            {
                # The compression method selected
                #  is unknown, we must have a valid
                #  compression method before we can
                #  continue.
                return $false;
            } # Unknown
        } # switch
        

        
        # Append the Multithreading Value
        if ($this.__useMultithread -eq $true)
        {
            # Ensure that multithreaded operations are enabled.
            $extCMDArgs = "$($extCMDArgs) -mmt=ON";
        } # if : Enable Multithreading

        else
        {
            # Ensure that multithreaded operations are disabled.
            $extCMDArgs = "$($extCMDArgs) -mmt=OFF";
        } # else : Disable Multithreading

        

        # Now to append the compression level
        switch ($this.__compressionLevel)
        {
            "Store"
            {
                $extCMDArgs = "$($extCMDArgs) -mx=0";
                break;
            } # Store {No Compression}

            "Minimal"
            {
                $extCMDArgs = "$($extCMDArgs) -mx=3";
                break;
            } # Minimal Compression

            "Normal"
            {
                $extCMDArgs = "$($extCMDArgs) -mx=5";
                break;
            } # Standard Compression

            "Maximum"
            {
                $extCMDArgs = "$($extCMDArgs) -mx=9";
                break;
            } # Maximum Compression
            
            Default
            {
                # The compression value is unknown,
                #  we must have a value before moving
                #  forward.  Return an error.
                return $false;
            } # Unknown Value
        } # switch : Compression Level
        

        # -----------------------
        # - - - - - - - - - - - -

        

        # EXECUTE THE 7ZIP CREATION TASK
        # - - - - - - - - - - - - - - -
        # -----------------------------
        
        
        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $false, `
                            $false, `
                            $null) -ne 0)
        {
            # 7Zip reached an error
            return $false;
        } # if : Archive File Creation Failed


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $true;
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

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            # Because the logging features are required, we can not run the operation.
            return $false;
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($ArchiveFile)", $true)) -eq $false)
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
                    $outputContent = "+-------------------------------------------------------------------------+`r`n" + `
                                     "|  ______ ___________ _____    _____  ______ _____   ____  _____ _______  |`r`n" + `
                                     "| |____  |___  /_   _|  __ \  |  __ \|  ____|  __ \ / __ \|  __ \__   __| |`r`n" + `
                                     "|     / /   / /  | | | |__) | | |__) | |__  | |__) | |  | | |__) | | |    |`r`n" + `
                                     "|    / /   / /   | | |  ___/  |  _  /|  __| |  ___/| |  | |  _  /  | |    |`r`n" + `
                                     "|   / /   / /__ _| |_| |      | | \ \| |____| |    | |__| | | \ \  | |    |`r`n" + `
                                     "|  /_/   /_____|_____|_|      |_|  \_\______|_|     \____/|_|  \_\ |_|    |`r`n" + `
                                     "+-------------------------------------------------------------------------+`r`n" + `
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
} # SevenZip




<# File Hash Algorithm (7Zip) [ENUM]
# -------------------------------
# Contains a list of known and supported hash algorithms
#  for the 7Zip executable.
#
# List of supported hash algorithms:
#  https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
# -------------------------------
#>
enum FileHashAlgorithm7Zip
{
    crc32 = 0;
    crc64 = 1;
    sha1 = 2;
    sha256 = 3;
    blake2sp = 4;
} # FileHashAlgorithm7Zip




<# 7Zip Compression Method [ENUM]
 # -------------------------------
 # Associated with what type of 7Z Method the end-user
 #  prefers when compacting an archive datafile.
 # -------------------------------
 #>
enum SevenZipCompressionMethod
{
    Zip = 0;      # Zip format [PK3]
    SevenZip = 1; # 7Zip format [PK7]
} # SevenZipCompressionMethod




<# 7Zip Algorithm Zip [ENUM]
 # -------------------------------
 # Associated with what type of 7Z Compression Algorithm
 #  the end-user prefers when compacting an archive
 #  datafile.
 # -------------------------------
 #>
enum SevenZipAlgorithmZip
{
    Deflate = 0;  # Default
    LZMA = 1;     # LZMA Algo.
    BZip2 = 2;    # BZip2 Algo.
} # SevenZipAlgorithmZip




<# 7Zip Algorithm 7Zip [ENUM]
 # -------------------------------
 # Associated with what type of 7Z Compression Algorithm
 #  the end-user prefers when compacting an archive
 #  datafile.
 # -------------------------------
 #>
enum SevenZipAlgorithm7Zip
{
    LZMA2 = 0;    # Default
    LZMA = 1;     # LZMA Algo.
    BZip2 = 2;    # BZip2 Algo.
    PPMd = 3;     # PPMd Algo.
} # SevenZipAlgorithm7Zip




<# 7Zip Compression Level [ENUM]
 # -------------------------------
 # Associated with what type of compression level the
 #  end-user prefers when compacting an archive datafile.
 # -------------------------------
 #>
enum SevenCompressionLevel
{
    Store = 0;    # Store [No Compression] {0}
    Minimal = 1;  # Minimal compression    {3}
    Normal = 2;   # Standard compression   {5}
    Maximum = 3;  # Maximum compression    {9}
} # DefaultCompressionLevel