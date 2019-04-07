<# Seven Zip
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds settings regarding the use of 7Zip
 #  aswell as functions in order to perform specific
 #  operations relating to compacting archive datafiles.
 #  This is an optional setting and must be enabled by
 #  the user in order to use it.
 # NOTE: This is required in order to generate 7Z (PK7)
 #   archive data files.
 # IMPORTANT NOTE:
 #  In order to use 7Zip features in this program, the
 #   end-user must also have 7Zip installed on the host
 #   system.  If the program is not installed, then the
 #   features are not available for use.
 #>




class SevenZip
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # 7Zip Executable Path
    # ---------------
    # The path in which the executable '7z.exe' resides.
    Hidden [string] $__executablePath;


    # Compression Method
    # ---------------
    # The method in which to compact the archive datafile.
    Hidden [SevenZipCompressionMethod] $__compressionMethod;


    # Algorithm [PK3|Zip]
    # ---------------
    # The algorithm to use when using the Zip Method
    Hidden [SevenZipAlgorithmZip] $__algorithmZip;


    # Algorithm [PK7|7Zip]
    # ---------------
    # The algorithm to use when using the 7Zip Method
    Hidden [SevenZipAlgorithm7Zip] $__algorithm7Zip;


    # Use Multithread
    # ---------------
    # When true, this will allow 7Zip to use multithreaded
    #  operations when available.
    Hidden [bool] $__useMultithread;


    # Compression Level
    # ---------------
    # How tightly to compact the files.
    Hidden [SevenCompressionLevel] $__compressionLevel;


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
    SevenZip()
    {
        # 7z.exe Path
        $this.__executablePath = "$($this.Find7Zip())";

        # Compression Method
        $this.__compressionMethod = 0;

        # Algorithm [Zip]
        $this.__algorithmZip = 0;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = 0;

        # Multithread
        $this.__useMultithread = $true;

        # Compress Level
        $this.__compressionLevel = 2;

        # Verify Build
        $this.__verifyBuild = $true;

        # Generate Report
        $this.__generateReport = $false;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Path
        $this.__logPath = "$($this.__rootLogPath)\logs";


        # ==================
        # Functions

        # Create the necessary directories
        $this.__CreateDirectories() | Out-Null;
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
        # 7z.exe Path
        $this.__executablePath = $executablePath;

        # Compression Method
        $this.__compressionMethod = $compressionMethod;

        # Algorithm [Zip]
        $this.__algorithmZip = $algorithmZip;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = $algorithm7Zip;

        # Multithread
        $this.__useMultithread = $useMultithread;

        # Compress Level
        $this.__compressionLevel = $compressionLevel;

        # Verify Build
        $this.__verifyBuild = $verifyBuild;

        # Generate Report
        $this.__generateReport = $generateReport;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Path
        $this.__logPath = "$($this.__rootLogPath)\logs";


        # ==================
        # Functions

        # Create the necessary directories
        $this.__CreateDirectories() | Out-Null;
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

    <# Get Executable Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Executable Path variable.
    # -------------------------------
    # Output:
    #  [string] Executable Path
    #   the value of the Executable Path to 7z.exe.
    # -------------------------------
    #>
    [string] GetExecutablePath()
    {
        return $this.__executablePath;
    } # GetExecutablePath()




   <# Get Compression Method
    # -------------------------------
    # Documentation:
    #  Returns the value of the Compression Method variable.
    # -------------------------------
    # Output:
    #  [SevenZipCompressionMethod] Compression Method
    #   the value of the Compression Method.
    # -------------------------------
    #>
    [SevenZipCompressionMethod] GetCompressionMethod()
    {
        return $this.__compressionMethod;
    } # GetCompressionMethod()




   <# Get Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the Algorithm variable.
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithmZip] Algorithm [ZIP]
    #   the value of the Compression Algorithm.
    # -------------------------------
    #>
    [SevenZipAlgorithmZip] GetAlgorithmZip()
    {
        return $this.__algorithmZip;
    } # GetAlgorithmZip()




   <# Get Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the Algorithm variable.
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithm7Zip] Algorithm [7Zip]
    #   the value of the Compression Algorithm.
    # -------------------------------
    #>
    [SevenZipAlgorithm7Zip] GetAlgorithm7Zip()
    {
        return $this.__algorithm7Zip;
    } # GetAlgorithm7Zip()




   <# Get Use Multithread
    # -------------------------------
    # Documentation:
    #  Returns the value of the Use Multithread variable.
    # -------------------------------
    # Output:
    #  [bool] Use Multithread
    #   the value of the Use Multithread.
    # -------------------------------
    #>
    [bool] GetUseMultithread()
    {
        return $this.__useMultithread;
    } # GetUseMultithread()




   <# Get Compression Level
    # -------------------------------
    # Documentation:
    #  Returns the value of the Compression Level variable.
    # -------------------------------
    # Output:
    #  [SevenCompressionLevel] Compression Level
    #   the value of the Compression Level.
    # -------------------------------
    #>
    [SevenCompressionLevel] GetCompressionLevel()
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

   <# Set Executable Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Executable Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetExecutablePath([string] $newVal)
    {
        # Because we are testing for an actual file,
        #  we have to assure that the file really exists
        #  within the host's filesystem.
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
    #  Sets a new value for the Compression Method variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionMethod([SevenZipCompressionMethod] $newVal)
    {
        # Because the value must fit within the
        #  'SevenZipCompressionMethod' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__compressionMethod = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionMethod()




   <# Set Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Algorithm variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithmZip([SevenZipAlgorithmZip] $newVal)
    {
        # Because the value must fit within the
        #  'SevenZipAlgorithmZip' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__algorithmZip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithmZip()




   <# Set Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Algorithm variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithm7Zip([SevenZipAlgorithm7Zip] $newVal)
    {
        # Because the value must fit within the
        #  'SevenZipAlgorithm7Zip' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__algorithm7Zip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithm7Zip()




   <# Set Use Multithread
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Use Multithread variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUseMultithread([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__useMultithread = $newVal;

        # Successfully updated.
        return $true;
    } # SetUseMultithread()




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
    [bool] SetCompressionLevel([SevenCompressionLevel] $newVal)
    {
        # Because the value must fit within the
        #  'SevenCompressionLevel' datatype, there really is
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


   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function was created to check the directories
    #   that this class requires.
    #
    # ----
    #
    #  Directories to Check:
    #   - \7Zip
    #   - \7Zip\logs
    #   - \7Zip\reports
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
    #   - \7Zip
    #   - \7Zip\logs
    #   - \7Zip\reports
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
        if(($this.__CheckRequiredDirectories())-eq $true)
        {
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
                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Report Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if(($this.__CheckRequiredDirectories())-eq $true)
        {
            # The directories exist
            return $true;
        } # IF : Check if Directories Exists

        
        # A general error occurred, the directories could not be created.
        return $false;
    } # __CreateDirectories()
    



   <# Supported Hash Algorithms
    # -------------------------------
    # Documentation:
    #  This function will check to make sure
    #   that hash algorithm is supported in 7Zip.
    #
    #  List of available Hash Algorithms:
    #   https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
    # -------------------------------
    # Input:
    #  [string] Requested Hash Algorithm
    #    This will contain the requested algorithm to be used
    #     in 7Zip.  This will be checked against a list of
    #     available algorithms known to be supported.
    # -------------------------------
    # Output:
    #  [bool] Supported Status
    #    $false = The hash algorithm requested is not supported.
    #    $true  = The hash algorithm requested is supported.
    # -------------------------------
    #>
    hidden [bool] __SupportedHashAlgorithms([string] $hashAlgo)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $knownAlgos = @("crc32", `
                                   "crc64", `
                                   "sha1", `
                                   "sha256", `
                                   "blake2sp");
        # ----------------------------------------


        # Scan the list against the requested hash algorithm
        foreach ($algo in $knownAlgos)
        {
            # Scan through the list and compare each algorithm
            #  against the requested hash algorithm.
            if ("$($algo)" -eq "$($hashAlgo)")
            {
                # The requested algo is supported.
                return $true
            } # if : Algos Matches
        } # foreach : Compare Algos


        # We didn't find a match, return false.
        return $false;
    } # __SupportedHashAlgorithms()

    #endregion
    
    
    #region Public Functions
    
    #region 7Zip Detection

   <# Detect 7Zip Executable
    # -------------------------------
    # Documentation:
    #  This function will check if the 7Zip executable
    #   was detected.  To accomplish this, we will
    #   investigate the dedicated variable that
    #   contains the path and determine if the path
    #   is valid or not.
    # -------------------------------
    # Output:
    #  [bool] Detected Code
    #    $false = Failure to detect the external executable.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    [bool] Detect7ZipExist()
    {
        # Make sure that it is not null
        if ($this.__executablePath -eq $null)
        {
            # Executable does not exist or was not set properly.
            #  Return false to signify that it doesn't exist.
            return $false;
        } # if : Executable Path is Null
        
        
        # Check if the 7Zip executable was found
        if (([IOCommon]::DetectCommand("$($this.__executablePath)", "Application")) -eq $true)
        {
            return $true;
        } # If : Detected
        else
        {
            return $false;
        } # Else : Not Detected
    } # Detect7ZipExist()




   <# Find 7Zip
    # -------------------------------
    # Documentation:
    #  This function will try to find the 7Zip executable by
    #   checking the common locations within the host's
    #   filesystem.
    # -------------------------------
    # Output:
    #  [string] 7Zip.exe Absolute Path
    #    $null = When the path was not discoverable,
    #             then '$null' will be returned.
    # -------------------------------
    #>
    [string] Find7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $path = @("7z.exe",`                             # Location: %PATH%
                             "7za.exe", `                           # Location: %PATH% {7Zip CLI; Stand-Alone}
                         "${env:PROGRAMFILES}\7-Zip\7z.exe", `      # Location: %ProgramFiles%       {x86_32}
                         "${env:PROGRAMFILES(x86)}\7-Zip\7z.exe");  # Location: %ProgramFiles(x86)%  {x86_64}
        # ----------------------------------------


        # Inspect each path in the array
        foreach ($index in $path)
        {
            # Test if the executable exists at the given path
            if([IOCommon]::DetectCommand("$($index)", "Application") -eq $true)
            {
                # We found the executable, return its location.
                return "$($index)";
            } # if : Command Detected
        } # Foreach : Path


        # If and only if the executable was not found,
        #  than will signify that we couldn't find it.
        return $null;
    } # Find7Zip()

    #endregion


    #region Inspect Archive

   <# Archive-File Hash
    # -------------------------------
    # Documentation:
    #  This function will try to get the archive data
    #   file's hash value directly from 7Zip.  In addition,
    #   if the archive file is corrupted or the output
    #   provided is not what we are expecting, this algorithm
    #   will return an error message or 'ERR'.
    #
    # NOTE: Because 7Zip does NOT have a simple clean
    #       way of just outputting the hash value only, we
    #       have to manipulate the text a bit by using some
    #       RegEx!
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file that will be used by 7Zip to get the hash value.
    #  [string] Hashing Algorithm
    #   The supported Hash Algorithm that will be used in 7Zip.
    #    NOTE: For a list of supported algorithms, please check this website:
    #          https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Hash Value
    #    ERR = Error; Unable to get the hash-value or the
    #             archive data file is corrupted.
    # -------------------------------
    #>
    [string] ArchiveHash([string] $file, [string] $hashAlgorithm, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"  # Working Directory when executing the
                                                                    #  extCMD.
        [string] $extCMDArgs = "h -scrc$($hashAlgorithm) $($file)"; # Arguments for the external command
                                                                    #  This will get 7zip to generate the
                                                                    #  requested hash value.
        [string] $outputResult = $null;                             # Holds the hash value provided by the
                                                                    #  extCMD 7z
        [string] $execReason = "Generate $($hashAlgorithm) Hash";   # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the requested hash algorithm is
        #  supported before trying to use it.
        if ($this.__SupportedHashAlgorithms($hashAlgorithm) -eq $false)
        {
            # The requested hash algorithm is not supported;
            #  we can not use it.
            return "ERR";
        } # if : Hash Algorithm not Supported

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command and cache the value
        if ($([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult)) -ne 0)
        {
            # 7Zip closed with an error
            return "ERR";
        } # if : 7Zip Closed with Error


        # Evaluation Requirement Check
        # - - - - - - - - - - - - - -
        # Before we perform some various operations using Regular Expression,
        #  we first need to make sure that the output result meets the basic
        #  requirements.  Requirements are the following:
        #   - The data is NOT null or empty
        #   - The data contains an expected key phrase, which is necessary to
        #      recognize that the output is correct.  All other values could mean
        #      that the file was corrupted, unsupported hash value, or anything else.
        #  If the requirements are not meant, then it is not possibly to get the
        #   hash value.
        # ---------------------------

        # Just for assurance, make sure that we actually have some
        #  sort of data to work with before trying to evaluate it.
        if ("$($outputResult)" -eq "$($null)")
        {
            # The output cannot be evaluated; there's nothing to
            #  inspect.
            return "ERR";
        } # if : Output Result is Empty


        # The most important part, can we try to pick up the key-phrase?
        #  If we have that key-phrase - we have the correct output to evaluate
        # KEY-PHRASE(RegEx): Everything\ is\ Ok\r\n$
        if ($($($outputResult) -match "Everything Is Ok`r`n$") -eq $false)
        {
            # The key-phrase was not detected, we cannot evaluate the text.
            return "ERR";
        } # if : Key-Phrase not Detected

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Now, to do some RegEx'ing!
        # - - - - - - - - - - - - - -
        # ---------------------------
        # To make this easier to follow, we will do one step at a time.
        #  This is essentially a brute-force method, but best for post-maintenance.
        #  This might be a bit costly in performance - but it is also important
        #  to know how the algorithm is implemented.  If something breaks in the
        #  future we need to know how to resolve the issue, and step-wise is more
        #  easier to work with in this matter - especially more with RegEx operations.


        # REGEX PASS 1
        # Replace 'Everything is Okay' with nothing
        #  NOTE: PowerShell RegEx Commands
        #   `r`n = New Line
        #      $ = End of Line
        $outputResult = $($outputResult -replace "`r`n`r`nEverything Is Ok`r`n$", "")


        # REGEX PASS 2
        # We now want to home-in on our target, which is our Hash Value.
        #  Check to make sure we are locked into the hash value explicitly,
        #  if not - we got something else unexpectedly.
        if ("$($($outputResult) -match "\s\w+$")" -eq $false)
        {
            # We got a value that was not expected, immediately leave
            #  and return an error.
            return "ERR";
        } # if : Unexpected Value Reached - Error


        # FINAL
        # Get the final result, which should now only be the hash value itself.
        # Because we reached the end and we have the hash value, simply return it.
        return "$($matches[0])"
    } # ArchiveHash()




   <# Verify Archive
    # -------------------------------
    # Documentation:
    #  This function will test the archive datafile by making sure
    #   that it is not damaged or corrupted.  To do this, we will
    #   use 7Zip's Verification functionality.
    #
    #  Test Integrity Informatoin:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/test.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file that will be tested upon through the
    #    verification process.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Archive file failed verification process.
    #    $true = Archive file passed verification process
    #             or user did not request the file archive
    #             to be tested.
    # -------------------------------
    #>
    [bool] VerifyArchive([string] $file, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "$(Split-Path $file -leaf)";           # Get only the filename from $file, 
                                                                    #  while omitting the entire path to
                                                                    #  get to that file.
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"; # Working Directory when executing the
                                                                    #  extCMD.
        [string] $extCMDArgs = "t $($file)";                        # Arguments for the external command
                                                                    #  This will get 7zip to test the
                                                                    #  requested archive datafile.
        [string] $execReason = "Verifying $($fileName)";            # Description; used for logging
        # ----------------------------------------


        # Did the user want the archive file tested?
        if ($this.__verifyBuild -eq $false)
        {
            # Because the user did not want the file tested,
            #  just return 'true' instead.
            return $true;
        } # if : Do not test archive file


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the target file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  test something that simply doesn't exist.  Return
            #  a failure.
            return $false;
        } # if : Target file does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ($([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $false, `
                            $null)) -ne 0)
        {
            # Archive file did not pass the verification test
            return $false;
        } # if : Verification Test Failed


        # Verification Test Passed!
        return $true;
    } # VerifyArchive()




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
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Hash Values
    #    A string list of all hash values
    #    associated with that specific archive
    #    file.
    # -------------------------------
    #>
    [string] FetchHashInformation([string] $file, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $archiveInfo = $null;      # This will hold our list of hash values
        # ----------------------------------------

        # Get all of the hash values that is associated with the archive file.
        $archiveInfo =
                "CRC32:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "crc32", "$($logging)"))`r`n`r`n" + `
                "CRC64:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "crc64", "$($logging)"))`r`n`r`n" + `
                "SHA1:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "sha1", "$($logging)"))`r`n`r`n" + `
                "CRC256:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "sha256", "$($logging)"))`r`n`r`n" + `
                "BLAKE2sp:`r`n" + `
                "  $($this.ArchiveHash("$($file)", "blake2sp", "$($logging)"))`r`n`r`n" + `
                "MD5:`r`n" + `
                "   $([IOCommon]::FileHash("$($file)", "md5"))`r`n`r`n";


        # Return all of the hash values
        return $archiveInfo;
    } # FetchHashInformation()




   <# List Files in Archive
    # -------------------------------
    # Documentation:
    #  This function will list all of the files that are
    #   within the target archive file.
    #
    #  List Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/list.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive file that will contain the files that we
    #    want to list.
    #  [bool] Show Technical Information
    #   When true, this will show All Technical Infomation.
    #    This uses the '-slt' argument when listing all of
    #    the files within the archive file.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] File List
    #    List of files that exists within the archive data file.
    # -------------------------------
    #>
    [string] ListFiles([string] $file, [bool] $showTechInfo, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "$(Split-Path $file -leaf)";           # Get only the filename from $file, 
                                                                    #  while omitting the entire path to
                                                                    #  get to that file.
        [string] $sourceDir = "$($(Get-Item $file).DirectoryName)"; # Working Directory when executing the
                                                                    #  extCMD.
        [string] $extCMDArgs = "l $($file)";                        # Arguments for the external command
                                                                    #  This will get 7zip to list all of
                                                                    #  the files within the requested
                                                                    #  archive datafile.
        [string] $outputResult = $null;                             # This will hold the value of all of
                                                                    #  the files that are within the archive
                                                                    #  datafile.
        [string] $execReason = "List From $($fileName)";            # Description; used for logging
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the target file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  test something that simply doesn't exist.  Return
            #  a failure.
            return "ERR";
        } # if : Target file does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Should the technical information be added in the output?
        #  If requested, append the argument to the command parameter.
        if ($showTechInfo -eq $true)
        {
            # There was a request to display all of the technical information
            #  for each file within the archive data file.
            $extCMDArgs = "$($extCMDArgs) -slt";
        } # if : Show Technical


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have an actual list
        #  from the archive file.  If in case the list was not
        #  retrieved successfully, then place 'ERR' to signify that
        #  an issue occurred, but still providing a value.
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
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/extract.htm
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
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while extracting contents.
    #    $true  = Successfully extracted contents.
    # -------------------------------
    #>
    [bool] ExtractArchive([string] $file, [string] $outputPath, [ref] $directoryOutput, [bool] $logging)
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
        [string] $extCMDArgs = "x $($file)";                        # Arguments for the external command
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

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the target file actually exists
        if ($([IOCommon]::CheckPathExists("$($file)")) -eq $false)
        {
            # The archive data file does not exist, we can not
            #  test something that simply doesn't exist.  Return
            #  a failure.
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



        # EXECUTE THE 7ZIP EXTRACT TASK
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Attach the output directory to the extCMD Arguments
        $extCMDArgs = "$($extCMDArgs) -o$($finalOutputPath)";
        

        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($sourceDir)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
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
    #  This function will allow the ability to
    #   create new archive data files with the help of 7Zip!
    #   This function is primarily intended for bulk operation
    #   instead of small individual file additions.  Meaning,
    #   this function mainly accepts a parent directory that
    #   already contains all of the files and subdirectories
    #   that will be added into the archive file.
    #
    #  Extract Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/add.htm
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
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while creating the archive.
    #    $true  = Successfully created the archive.
    # -------------------------------
    #>
    [bool] CreateArchive([string] $archiveFileName, [string] $outputPath, [string] $targetDirectory, [ref] $archivePath, [bool] $logging)
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

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the output directory exists
        if ($([IOCommon]::CheckPathExists("$($outputPath)")) -eq $false)
        {
            # The output directory does not exist;
            #  we need a valid location to output this archive file.
            return $false;
        } # if : Output directory does not exist


        # Make sure that the target directory (the contents that will be
        #  in our newly created archive file) exists.
        if ($([IOCommon]::CheckPathExists("$($targetDirectory)")) -eq $false)
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
        $extCMDArgs = "$($extCMDArgs) $($finalArchiveFileName)";


        # Attach the target directory
        $extCMDArgs = "$($extCMDArgs) $($targetDirectory)\*";
        

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
                            $logging, `
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
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
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
                           [bool] $logging, `
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

        # Make sure that the 7Zip executable was detected.
        if ($($this.Detect7ZipExist()) -eq $false)
        {
            # 7Zip was not detected.
            return $false;
        } # if : 7Zip was not detected


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
                    $traverse = $traverse + 1;


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
                    $traverse = $traverse + 1;


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
                    $traverse = $traverse + 1;
                    

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
                    $traverse = $traverse + 1;
                    

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

                                     "$($this.FetchHashInformation("$($ArchiveFile)", $logging))";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse = $traverse + 1;
                    

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
                                     "$($this.ListFiles("$($ArchiveFile)", $true, $logging))";


                    # Write to file
                    if ([IOCommon]::WriteToFile("$($fileNameTXT)", "$($outputContent)") -eq $false)
                    {
                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable
                    $traverse = $traverse + 1;


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