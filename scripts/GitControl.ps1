<# Git Control
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds settings regarding the use of Git and
 #  its features, but also holds functions to perform various
 #  tasks related to using Git.
 # NOTE: In order to use git, it must first already be
 #  installed within the host system.  We are merely going to
 #  use the binary to perform the tasks we want; if the
 #  binary is not available - then nothing is used.
 #>




class GitControl
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Git Executable Path
    # ---------------
    # The path in which the executable 'git.exe' resides.
    Hidden [string] $__executablePath;


    # Update Source
    # ---------------
    # When true, try to update the source when possible.
    Hidden [bool] $__updateSource;


    # Length Commit ID
    # ---------------
    # Set how long the commit ID should be when retrieving it.
    Hidden [GitCommitLength] $__lengthCommitID;


    # Fetch Latest Commit ID
    # ---------------
    # When true, try to fetch the latest commit ID.
    Hidden [bool] $__fetchCommitID;

    
    # Fetch Changelog History
    # ---------------
    # When true, try to retrieve a commit history.
    Hidden [bool] $__fetchChangelog;

    
    # Changelog History Limit
    # ---------------
    # The maximum commits to record in the changelog.
    Hidden [int] $__changelogLimit;


    # Generate Report
    # ---------------
    # Generate a report regarding the project's
    #  git repository.
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
    GitControl()
    {
        # git.exe Path
        $this.__executablePath = "git.exe";

        # Update Source
        $this.__updateSource = $true;

        # Length Commit ID
        $this.__lengthCommitID = 0;

        # Fetch Commit ID
        $this.__fetchCommitID = $true;

        # Fetch changelog
        $this.__fetchChangelog = $true;

        # Changelog history limits
        $this.__changelogLimit = 50;

        # Generate Report
        $this.__generateReport = $true;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\git";

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
    GitControl([string]$executablePath,
                [bool]$updateSource,
                [GitCommitLength]$lengthCommitID,
                [bool]$fetchCommitID,
                [bool]$fetchChangelog,
                [int]$changelogLimit,
                [bool]$generateReport)
    {
        # git.exe Path
        $this.__executablePath = $executablePath;

        # Update Source
        $this.__updateSource = $updateSource;

        # Length of the Commit ID
        $this.__lengthCommitID = $lengthCommitID;

        # Fetch the Commit ID
        $this.__fetchCommitID = $fetchCommitID;

        # Fetch the Changelog History
        $this.__fetchChangelog = $fetchChangelog;

        # Changelog Limit
        $this.__changelogLimit = $changelogLimit;

        # Generate Report
        $this.__generateReport = $generateReport;

        # Log Root Directory
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\git";

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
    #   the value of the Executable Path to git.exe.
    # -------------------------------
    #>
    [string] GetExecutablePath()
    {
        return $this.__executablePath;
    } # GetExecutablePath()




   <# Get Update Source Flag
    # -------------------------------
    # Documentation:
    #  Returns the value of the Update Source variable.
    # -------------------------------
    # Output:
    #  [bool] Update Source
    #   the value of the Update Source.
    # -------------------------------
    #>
    [bool] GetUpdateSource()
    {
        return $this.__updateSource;
    } # GetUpdateSource()




   <# Get Git Commit Length
    # -------------------------------
    # Documentation:
    #  Returns the value of the Git Commit Length variable.
    # -------------------------------
    # Output:
    #  [GitCommitLength] Git Commit Length
    #   the value of the Git Commit Length.
    # -------------------------------
    #>
    [GitCommitLength] GetLengthCommitID()
    {
        return $this.__lengthCommitID;
    } # GetLengthCommitID()




   <# Get Fetch Commit ID
    # -------------------------------
    # Documentation:
    #  Returns the value of the Fetch Commit ID variable.
    # -------------------------------
    # Output:
    #  [bool] Fetch Commit ID
    #   the value of the Fetch Commit ID.
    # -------------------------------
    #>
    [bool] GetFetchCommitID()
    {
        return $this.__fetchCommitID;
    } # GetFetchCommitID()




   <# Get Fetch Changelog
    # -------------------------------
    # Documentation:
    #  Returns the value of the Fetch Changelog variable.
    # -------------------------------
    # Output:
    #  [bool] Fetch Changelog
    #   the value of the Fetch Changelog.
    # -------------------------------
    #>
    [bool] GetFetchChangelog()
    {
        return $this.__fetchChangelog;
    } # GetFetchChangelog()




   <# Get Changelog Limit
    # -------------------------------
    # Documentation:
    #  Returns the value of the Changelog Limit variable.
    # -------------------------------
    # Output:
    #  [int] Changelog Limit
    #   the value of the Changelog Limit.
    # -------------------------------
    #>
    [int] GetChangelogLimit()
    {
        return $this.__changelogLimit;
    } # GetChangelogLimit()




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




   <# Set Update Source Flag
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Update Source variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUpdateSource([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__updateSource = $newVal;

        # Successfully updated.
        return $true;
    } # SetUpdateSource()




   <# Set Git Commit Length
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Git Commit Length variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLengthCommitID([GitCommitLength] $newVal)
    {
        # Because the value must fit within the 'GitCommitLength'
        #  datatype, there really is no point in checking if the
        #  new requested value is 'legal'.  Thus, we are going
        #  to trust the value and automatically return success.
        $this.__lengthCommitID = $newVal;

        # Successfully updated.
        return $true;
    } # SetLengthCommitID()




   <# Set Fetch Commit ID
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Fetch Commit ID variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFetchCommitID([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__fetchCommitID = $newVal;

        # Successfully updated.
        return $true;
    } # SetFetchCommitID()




   <# Set Fetch Changelog
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Fetch Changelog variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFetchChangelog([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__fetchChangelog = $newVal;

        # Successfully updated.
        return $true;
    } # SetFetchChangelog()




   <# Set Changelog Limit
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Changelog Limit variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetChangelogLimit([int] $newVal)
    {
        # Make sure the requested change is actually legal.
        #  Prevent negative numbers
        if ($newVal -lt 0)
        {
            # The request was a negative number, we can not
            #  use it.  It must be a zero or non-negative
            #  value.
            return $false;
        } # IF : Negative Value

        # Legal number, we can use it.
        $this.__changelogLimit = $newVal;

        # Successfully updated.
        return $true;
    } # SetChangelogLimit()




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
    #   - \git
    #   - \git\logs
    #   - \git\reports
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
    #   - \git
    #   - \git\logs
    #   - \git\reports
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

    #endregion



    #region Public Functions

   <# Detect Git Executable
    # -------------------------------
    # Documentation:
    #  This function will check if the Git executable
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
    [bool] DetectGitExist()
    {
        # Check if the git executable was found
        if (([IOCommon]::DetectCommand("$($this.__executablePath)", "Application")) -eq $true)
        {
            return $true;
        } # If : Detected
        else
        {
            return $false;
        } # Else : Not Detected
    } # DetectGitExist()




   <# Update Local Working Copy
    # -------------------------------
    # Documentation:
    #  This function will update the project's Local
    #   Working Copy by fetching any of the latest
    #   changes made to the centralized repository
    #   server. 
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [bool] Status
    #    $false = Failure to detect the external executable.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    [bool] UpdateLocalWorkingCopy([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "pull";          # Arguments for the external command
                                                #  Fetch updates from the remote repository.
        [string] $execReason = "Update LWC";    # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected.
            return $false;
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error.
            return $false;
        } # if : the Project Path does not exist
        
        # ---------------------------
        # - - - - - - - - - - - - - -


        # Are we allowed to update the source?
        if ($($this.__updateSource) -eq $false)
        {
            # User does not want use to update the source.
            return $false;
        } # If : Do not update source


        # Try to update the LWC
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                                "$($extCMDArgs)", `
                                "$($projectPath)", `
                                "$($this.__logPath)", `
                                "$($this.__logPath)", `
                                "$($this.__reportPath)", `
                                "$($execReason)", `
                                $logging, `
                                $false, `
                                $false, `
                                $null) -eq 0)
        {
            # Successfully update the source
            return $true;
        } # If : Successfully updated the source

        
        # Failure occurred
        return $false;
    } # UpdateLocalWorkingCopy()




   <# Switch Local Branch
    # -------------------------------
    # Documentation:
    #  This function will switch the project's local
    #   repository to the requested branch - if possible.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    #  [string] Requested Branch
    #   The requested branch to switch to in the local
    #    repository.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure to switch to requested branch.
    #    $true  = Successfully switched to requested branch.
    # -------------------------------
    #>
    [bool] SwitchLocalBranch([string] $projectPath, [bool] $logging, [string] $requestedBranch)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "checkout $($requestedBranch)";  # Arguments for the external command
                                                                #  This will allow us to switch to
                                                                #  another branch.
        [string] $execReason = "Switch Branch";                 # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected.
            return $false;
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error.
            return $false;
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $false, `
                            [ref]$null) -eq 0)
        {
            # Successfully switched from one branch to another branch.
            return $true;
        } # If : Switch Branches


        # Failure to switch branches.
        return $false;
    } # SwitchLocalBranch()




   <# Fetch Current Commit ID
    # -------------------------------
    # Documentation:
    #  This function will retrieve the latest
    #   Commit ID from the project repository.
    #  Two possible ways of getting the Commit
    #   ID are the following:
    #    - Short: 7chars
    #    - Long: 40chars
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Commit ID
    #    The latest commit ID from the project's repository.
    #    - ERROR and NON-ERROR VALUES
    #       - "DEV"
    #           User did not want a commit ID to be retrieved.
    #       - "ERR"
    #            Failure retrieving the commit ID.
    # -------------------------------
    #>
    [string] FetchCommitID([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $commitID = $null;                 # This will hold the commit ID
                                                    #  This will also be returned.
        [string] $extCMDArgs = $null;               # Arguments for the external command
                                                    #  This will contain the commit ID
                                                    #  argument; though determined by
                                                    #  user's request.
        [string] $execReason = "Fetch CommitID";    # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw the default message instead.
            return "DEV";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return the default
            #  message instead.
            return "DEV";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Does the user want the commit ID?
        if ($this.__fetchCommitID -eq $false)
        {
            # Immediately leave this function while
            #  returning a default non-commit ID
            #  value.
            return "DEV";
        } # If : User didn't request commit ID


        # Determine what type of commit ID the user wants
        if($($this.__lengthCommitID) -eq 0)
        {
            # Short Commit ID
            $extCMDArgs = "rev-parse --short HEAD";
        } # If : Short Commit ID
        else
        {
            # Long Commit ID
            $extCMDArgs = "rev-parse HEAD";
        } # Else : Long Commit ID


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$commitID) | Out-Null;


        # Just for assurance; make sure that we have the Commit ID.
        #  If in case the commit ID was not retrieved successfully,
        #  than place 'ERR' to signify that an issue occurred, but
        #  still providing a value.
        if ("$($commitID)" -eq "$($null)")
        {
            $commitID = "ERR";
        } # If : Commit ID is not valid


        # Return the Commit ID
        return $commitID;
    } # FetchCommitID()




   <# Fetch Commit History (Changelog)
    # -------------------------------
    # Documentation:
    #  This function is designed to grab the Commit History
    #   from a specific repository and place the information
    #   into a textfile.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    #  [string] Output Path
    #   The absolute location to place the Commit History.
    #   - NOTE: We will use the Report functionality to
    #           create the file; this gives us full power
    #           to dictate where to put the file and how
    #           it'll be named.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure to create a report.
    #    $true  = Successfully created the report.
    # -------------------------------
    #>
    [bool] FetchCommitHistory([string] $projectPath, [bool] $logging, [string] $outputPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "Changelog.txt"                    # The filename of the commit history (changelog)
        [string] $changelogSize = $null;                        # The size of the changelog
        [string] $changelogPath = "$($outputPath)\$($fileName)";# Location of the commit history (changelog)
        [string] $prettyType = "fuller";                        # The type of 'Pretty' format to be used.
                                                                #  More Info: https://git-scm.com/docs/pretty-formats
        [string] $extCMDArgs = $null;                           # Arguments for the external command
                                                                #  This will contain args. to get the
                                                                #  commit history.  This'll be generated
                                                                #  by user's request.
        [string] $execReason = "Fetch Commit History";          # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected.
            return $false;
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error.
            return $false;
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Does the user want the commit history (changelog)?
        if ($this.__fetchChangelog -eq $false)
        {
            # Immediately leave this function; user's request.
            #  We will return true because no actual error happened.
            return $true;
        } # If : User didn't request commit history.



        # Commit History Size
        # ++++++++++++++++++++


        # How many commits does the user want?
        #  Number-Line (because I am a visual person)
        #  <(-----------0+++++++++++)>
        if ($this.__changelogLimit -eq 0)
        {
            # User wants ALL of the commits made into the project.
            #  Do not use the size parameter; this will give us
            #  the entire commit history that is in the repository.
            $changelogSize = "";
        } # If : All Commits


        #  We want to also make sure that if a negative number exists (it shouldn't happen),
        #   but we should also negate it - thus making it a positive number.
        ElseIf($this.__changelogLimit -lt 0)
        {
            # Negative number, make it a positive number and use that as the new size.
            $changelogSize = "-$($this.__changelogLimit * (-1))";
        } # If : Negated number; flip it (Error Protection)


        # Number that is greater than zero
        else
        {
            # Because it's a supported number, just use it as is.
            $changelogSize = "-$($this.__changelogLimit)";
        } # Else : Number greater than 0



        # Arguments Builder Constructor
        # ++++++++++++++++++++


        $extCMDArgs = "log --pretty=$($prettyType) $($changelogSize)";



        # Execute the Command
        # ++++++++++++++++++++


        # Execute the command
        if([IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($changelogPath)", `
                            "$($execReason)", `
                            $logging, `
                            $true, `
                            $false, `
                            $null) -eq 0)
        {
            # Successfully retrieved the commit history.
            return $true;
        } # If : Successfully retrieved the commit history.


        # Failure to retrieve the commit history or a general error had occurred.
        return $false;
    } # FetchCommitHistory()




   <# Fetch Current Branch
    # -------------------------------
    # Documentation:
    #  This function will retrieve the current
    #   branch that is active in the project's 
    #   local repository.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Current and Active Branch
    #    The current branch selected (or active).
    # -------------------------------
    #>
    [string] FetchCurrentBranch([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "rev-parse --abbrev-ref HEAD";   # Arguments for the external command
                                                                #  This will only show the selected
                                                                #  branch.
        [string] $outputResult = $null;                         # Holds the value of the current
                                                                #  branch provided by the extCMD.
        [string] $execReason = "Fetch Current Branch";          # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw the default message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return the default
            #  message instead.
            return "ERR";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have the current branch.
        #  If in case the current branch was not retrieved successfully,
        #  than place 'ERR' to signify that an issue occurred, but
        #  still providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : Current Branch is not valid


        # Return the Current (active) Branch
        return $outputResult;
    } # FetchCurrentBranch()




   <# Fetch all available Branches
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the available
    #   branches in the project's repository.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Branches
    #    All available branches that are in the project's
    #     repository.
    #    - NOTE: This does not really return a 'list' type,
    #            but this string will capture the newline chars
    #            and will be added to the string.
    #            For example:
    #            master[CR][LF]The Mega Branch![CR][LF]Lame Branch
    # -------------------------------
    #>
    [string] FetchAllBranches([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "branch";                # Arguments for the external command
                                                        #  This will display all the branches
                                                        #  available in the local repository.
        [string] $outputResult = $null;                 # Holds the value of the current
                                                        #  branch provided by the extCMD.
        [string] $execReason = "Fetch All Branches";    # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw the error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return the default
            #  error message instead.
            return "ERR";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have all of the branches.
        #  If in case the branches was not retrieved successfully, then
        #  place 'ERR' to signify that an issue occurred, but still
        #  providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : Branches is not valid


        # Return all available Branches
        return $outputResult;
    } # FetchAllBranches()




   <# Fetch all available Branches with Last-Known Activity
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the available
    #   branches in the project's repository and determine
    #   when it was last active.
    #  NOTE: This function will use branches that are
    #        available on the remote-repository, not
    #        the local-repository.  This is done to assure
    #        that all official branches have been detected.
    #        If we were to rely on the local-repository, we
    #        would be bounded to what is available to the
    #        local-repository -- when the local-repository
    #        only has five branches available, but the
    #        remote has more than ten available.
    #        As such, we will use the Remote-Repository to
    #        assure we have all of the branches.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Branches with Last-Known Activity
    #    All available branches that are in the project's
    #     repository, and when they were last active.
    #    - NOTE: This does not really return a 'list' type,
    #            but this string will capture the newline chars
    #            and will be added to the string.
    #            For example:
    #            master[CR][LF]The Mega Branch![CR][LF]Lame Branch
    # -------------------------------
    #>
    [string] FetchAllBranchesActivity([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = $null;                   # Arguments for the external command
                                                        #  This will display all the branches
                                                        #  available in the local repository,
                                                        #  once the variable has been built.
        [string] $outputResult = $null;                 # Holds the value of the current
                                                        #  branch provided by the extCMD.
        [string] $execReason = "Fetch Active Branches"  # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error
            #  message instead.
            return "ERR";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Arguments Builder Constructor
        # ++++++++++++++++++++


        # This should provide us with the following example:
        # *(BRANCH) - (RELATIVE_DATE)
        # Source: https://stackoverflow.com/a/30076212
        $extCMDArgs = "branch -r --sort=-committerdate" + `
                      " --format=`"%(refname:short)" + `
                      " (%(committerdate:relative))`"";



        # Execute the command
        # ++++++++++++++++++++


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have all of the branches.
        #  If in case the branches was not retrieved successfully, then
        #  place 'ERR' to signify that an issue occurred, but still
        #  providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : Branches is not valid


        # Return all available Branches
        return $outputResult;
    } # FetchAllBranches()




   <# Fetch All Contributors
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the contributors
    #   that have been involved within the project, as well
    #   how many commits have been pushed into the project
    #   by those users.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Contributors
    #    All contributors that have been involved with the project.
    #     repository.
    #    - NOTE: This does not really return a 'list' type,
    #            but this string will capture the newline chars
    #            and will be added to the string.
    #            For example:
    #            John[CR][LF]Amber[CR][LF]Hammingway
    # -------------------------------
    #>
    [string] FetchAllContributors([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = `                        # Arguments for the external command
                "shortlog --summary --email";           #  This will provide all contributors
                                                        #  with a valid email address.
        [string] $outputResult = $null;                 # Holds the value of all contributors
                                                        #  that have been involved within the
                                                        #  project.
        [string] $execReason = "Fetch All Contributors";# Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, return an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error message instead.
            return "ERR";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have all of the contributors.
        #  If in case the contributors was not retrieved successfully, then
        #  place 'ERR' to signify that an issue occurred, but still
        #  providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : Contributors is not valid


        # Return all contributors
        return $outputResult;
    } # FetchAllContributors()




   <# Generate Graph
    # -------------------------------
    # Documentation:
    #  This function will retrieve a simple visual graph-line
    #   with the commit description, date when it was committed
    #   into the repository, and by whom.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
    #  [bool] Logging
    #   User's preference in logging information.
    #    When true, the program will log the
    #    operations performed.
    #   - Does not effect main program logging.
    # -------------------------------
    # Output:
    #  [string] Commit Graph & info
    #    Simple line-graph with commit information
    #    - NOTE: This is a giant string.
    # -------------------------------
    #>
    [string] MakeCommitGraphInfo([string] $projectPath, [bool] $logging)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = $null;                   # Arguments for the external command
                                                        #  This will display the graph and the
                                                        #  commit information once it has been
                                                        #  constructed.
        [string] $gitArgsLong = $null;                  # Long-wordy arguments
        [string] $gitArgsFormat = $null;                # Formatting for the commit information args.
        [string] $outputResult = $null;                 # Holds the graph and commit information.
        [string] $execReason = "Graph Log";             # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # Project Path does not exist, return an error message instead.
            return "ERR";
        } # if : the Project Path does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Arguments Builder Constructor
        # ++++++++++++++++++++

        # This was a major help in figuring out how to accomplish this task:
        #  https://stackoverflow.com/a/9074343
        # Formatting Help:
        #  https://git-scm.com/docs/pretty-formats

        # Long wordy arguments
        $gitArgsLong = "log --graph --abbrev-commit --decorate --all";


        # Formatting for the commit information
        $gitArgsFormat = "--format=`"[%h] - %aD (%ar) %d%n%x09By: %an%n%x09%s%n`"";


        # Construct the arguments into one variable,
        #  this will be used when calling the extCMD.
        $extCMDArgs = "$($gitArgsLong) $($gitArgsFormat)";



        # Execute the Command
        # ++++++++++++++++++++


        # Execute the command
        [IOCommon]::ExecuteCommand("$($this.__executablePath)", `
                            "$($extCMDArgs)", `
                            "$($projectPath)", `
                            "$($this.__logPath)", `
                            "$($this.__logPath)", `
                            "$($this.__reportPath)", `
                            "$($execReason)", `
                            $logging, `
                            $false, `
                            $true, `
                            [ref]$outputResult) | Out-Null;


        # Just for assurance; make sure that we have all of the information.
        #  If in case the graph and information was not retrieved successfully,
        #  then place 'ERR' to signify that an issue occurred, but still
        #  providing a value.
        if ("$($outputResult)" -eq "$($null)")
        {
            $outputResult = "ERR";
        } # If : Information is not valid


        # Return the graph and commit information
        return $outputResult;
    } # MakeCommitGraphInfo()




   <# Create a new Report
    # -------------------------------
    # Documentation:
    #  This function will create a report based upon
    #   the project's repository.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's root directory that
    #   contains the .git directory.  If that directory
    #   lacks that specific '.git' directory, this
    #   will fail to work.
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
    [bool] CreateNewReport([string] $projectPath, `
                           [bool] $logging, `
                           [bool] $makePDF)
    {
        # Declarations and Initializations
        # ----------------------------------------
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
        [string] $fileNameTXT = "$($this.__reportPath)\$([ProjectInformation]::projectName) - $($dateTime).txt";
        
        # >> Portable Document File (PDF)
        [string] $fileNamePDF = "$($this.__reportPath)\$([ProjectInformation]::projectName) - $($dateTime).pdf";
        # - - - -

        # This variable will hold the output
        #  provided by the functions.  Because
        #  some data might be excessively large
        #  and to help minimize requiring
        #  massive heap space, we will only
        #  store only ONE output at a time.
        #  If we store MORE THAN ONE, depending
        #  on the project size, this could demand
        #  a lot on main memory.  Lets try to
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

        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected.
            return $false;
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
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
                    $outputContent = "+--------------------------------------------------+`r`n" + `
                                     "|   _____ _ _     _____                       _    |`r`n" + `
                                     "|  / ____(_) |   |  __ \                     | |   |`r`n" + `
                                     "| | |  __ _| |_  | |__) |___ _ __   ___  _ __| |_  |`r`n" + `
                                     "| | | |_ | | __| |  _  // _ \ '_ \ / _ \| '__| __| |`r`n" + `
                                     "| | |__| | | |_  | | \ \  __/ |_) | (_) | |  | |_  |`r`n" + `
                                     "|  \_____|_|\__| |_|  \_\___| .__/ \___/|_|   \__| |`r`n" + `
                                     "|                           | |                    |`r`n" + `
                                     "|                           |_|                    |`r`n" + `
                                     "+--------------------------------------------------+`r`n" + `
                                     "`r`n`r`n" + `
                                     "Synopsis`r`n" + `
                                     "----------`r`n" + `
                                     "This report was generated on $($dateNow) at $($timeNow) for the" + `
                                     " $([ProjectInformation]::projectName) project.  This report contains" + `
                                     " an overview of the project's activity and work flow." + `
                                     "  However, all information is based on the local repository -" + `
                                     " not directly from the remote repository.  If the local repository is caught" + `
                                     " up with the remote repository then all of the information is current with the" + `
                                     " centralized repository." + `
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
                                     "2) Contributors`r`n" + `
                                     "3) Branches`r`n" + `
                                     "4) Commits overview`r`n" + `
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


                # SECTION - Contributors
                3
                {
                    # Build the output
                    $outputContent = "2) CONTRIBUTORS`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is a list of contributors that have" + `
                                     " sent commits to this project's git repository.`r`n`r`n" + `
                                     "List of Contributors:`r`n" + `
                                     "$($this.FetchAllContributors($projectPath, $logging))`r`n`r`n";


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
                } # Case : SECTION - Contributors

                
                # SECTION - Branch
                4
                {
                    # Build the output
                    $outputContent = "3) BRANCHES`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is list of branches that are" + `
                                     " available in this repository.`r`n`r`n" + `
                                     "List of Branches:`r`n" + `
                                     "$($this.FetchAllBranchesActivity($projectPath, $logging))`r`n`r`n";


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
                } # Case : SECTION - Branch


                # SECTION - Commits Overview
                5
                {
                    # Build the output
                    $outputContent = "4) COMMITS OVERVIEW`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is an overview of commits that" + `
                                     "  have been submitted to this project's repository.`r`n`r`n" + `
                                     "List of Commits:`r`n" + `
                                     "$($this.MakeCommitGraphInfo($projectPath, $logging))";


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
                } # Case : SECTION - Commits Overview


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
} # GitControl




<# Git Commit Type [ENUM]
 # -------------------------------
 # Associated with what type of commit ID the end-user
 #  prefers when retrieving the Commit ID.
 # -------------------------------
 #>
enum GitCommitLength
{
    short = 0;   # usually contains seven chars.
    long = 1;    # usually about forty-one chars. [Lunacy!]
} # GitCommitType