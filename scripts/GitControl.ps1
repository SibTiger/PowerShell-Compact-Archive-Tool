<# Git Version Control
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the possibility to utilize Git features and functionality 
 #  within this program.  With using Git, it is possible to update the project source,
 #  retrieve information regarding the latest commit or retrieve a history changelog
 #  of previous commits, obtain a short-hand SHA1 of the latest commit, get information
 #  regarding the contributors of the project, and various other functionalities.
 #  However, using Git is only optional - not a requirement within the program.  Because
 #  Git is an external command (external executable), it is not required for the user to
 #  already have this software installed on the host system.  But, however, in order to
 #  use Git's functionality, then it is necessary to first install the Git version control
 #  software from that point onward.
 # NOTE:
 #  - This is only required if wanting to: Retrieve history information, contributors,
 #     small SHA1 of the latest commit, updates to the local repository, and such other
 #     features.
 #  - In order to utilize Git functionality within this program, the Git Version Control
 #     must first be installed properly on the host system.  Otherwise, the features may
 #     not be readily available.
 # DEPENDENCIES (Optional):
 #  GitHub Desktop (Windows)
 #   - https://desktop.github.com/
 #  OR
 #  Git (Windows)
 #   - https://git-scm.com/
 #>




class GitControl
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Git Executable Path
    # ---------------
    # The path to the 'git.exe' executable within the Windows Environment.
    Hidden [string] $__executablePath;


    # Update Source
    # ---------------
    # When this is true, this program will try to update the repository (project)
    #  when possible to assure that the repository has the latest changes available.
    Hidden [bool] $__updateSource;


    # Length Commit ID
    # ---------------
    # Determines how the Commit ID, the SHA1 hash, is presented from the Git
    #  Application.  Thus, it is possible to trim a long Commit ID or to keep
    #  the long form of the Commit ID.
    # Supported Values:
    #  Short - Might contain seven characters
    #  Long  - Might contain forty-one characters
    Hidden [GitCommitLength] $__lengthCommitID;


    # Fetch Changelog History
    # ---------------
    # When this is true, this will allow the possibility to retrieve a changelog
    #  history (or commit changelog) of the desired local repository.  This can
    #  be helpful when wanting to see what changes took place, analysis, or testing
    #  purposes.  When this is set to false, however, the changelog will not be
    #  retrieved.
    Hidden [bool] $__fetchChangelog;


    # Changelog History Limit
    # ---------------
    # This will provide a limit as to how many commits will appear in the changelog.
    #  With this variable, it will help to avoid clutter in the changelog by only limiting
    #  to just the recent activity or a focus range of history.  Setting the value to zero
    #  may allow for all changes to be logged.
    Hidden [int] $__changelogLimit;


    # Generate Report
    # ---------------
    # When this is true, this will provide the ability to generate reports upon request.
    #  A report will provide information regarding the repository from those that contribute,
    #  the commit history, forks, branches, and potentially much more.  When this is false,
    #  however, the report functionality will not be available.
    Hidden [bool] $__generateReport;


    # Log Root
    # ---------------
    # The main parent directory's absolute path that will hold this object's logs and
    #  reports directories.
    Hidden [string] $__rootLogPath;


    # Report Path
    # ---------------
    # This directory, in absolute form, will hold reports that were generated from this
    #  object.  Reports provide some insight and outlook regarding a specific git repository.
    Hidden [string] $__reportPath;


    # Log Root Path
    # ---------------
    # This directory, in absolute form, will hold logfiles that were generated from this
    #  object when updating, retrieving the Commit ID, switching branches, and potentially
    #  much more when using Git features.
    Hidden [string] $__logPath;


    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    GitControl()
    {
        # Executable path to the Git.exe
        $this.__executablePath = "git.exe";

        # Update Source
        $this.__updateSource = $true;

        # Length of the Commit ID
        $this.__lengthCommitID = 0;

        # Fetch the changelog History
        $this.__fetchChangelog = $true;

        # Changelog history limit
        $this.__changelogLimit = 50;

        # Generate Report
        $this.__generateReport = $true;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\Git";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";
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
        # Executable path to the Git.exe
        $this.__executablePath = $executablePath;

        # Update Source
        $this.__updateSource = $updateSource;

        # Length of the Commit ID
        $this.__lengthCommitID = $lengthCommitID;

        # Fetch the Changelog History
        $this.__fetchChangelog = $fetchChangelog;

        # Changelog history limit
        $this.__changelogLimit = $changelogLimit;

        # Generate Report
        $this.__generateReport = $generateReport;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\Git";

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
    #   The value of the 'Executable Path' to the git.exe binary file.
    # -------------------------------
    #>
    [string] GetExecutablePath()
    {
        return $this.__executablePath;
    } # GetExecutablePath()




   <# Get Update Source Flag
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Update Source' variable.
    # -------------------------------
    # Output:
    #  [bool] Update Source
    #   The value of the 'Update Source'.
    # -------------------------------
    #>
    [bool] GetUpdateSource()
    {
        return $this.__updateSource;
    } # GetUpdateSource()




   <# Get Commit ID Length
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Commit ID Length' variable.
    # -------------------------------
    # Output:
    #  [GitCommitLength] Commit ID Length
    #   The value of the 'Commit ID Length'.
    # -------------------------------
    #>
    [GitCommitLength] GetLengthCommitID()
    {
        return $this.__lengthCommitID;
    } # GetLengthCommitID()




   <# Get Fetch History Changelog
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Fetch History Changelog' variable.
    # -------------------------------
    # Output:
    #  [bool] Fetch Changelog
    #   The value of the 'Fetch History Changelog'.
    # -------------------------------
    #>
    [bool] GetFetchChangelog()
    {
        return $this.__fetchChangelog;
    } # GetFetchChangelog()




   <# Get Changelog History Limit
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Changelog History Limit' variable.
    # -------------------------------
    # Output:
    #  [int] Changelog History Limit
    #   The value of the 'Changelog History Limit'.
    # -------------------------------
    #>
    [int] GetChangelogLimit()
    {
        return $this.__changelogLimit;
    } # GetChangelogLimit()




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
    #   The location of the Git executable within the host system.
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
    #  Sets a new value for the 'Update Source' variable.
    # -------------------------------
    # Input:
    #  [bool] Update Source flag
    #   The option to update the localized repository against the centralized
    #    repository (usually from a server host).
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUpdateSource([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__updateSource = $newVal;

        # Successfully updated.
        return $true;
    } # SetUpdateSource()




   <# Set Commit ID Length
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Commit ID Length' variable.
    # -------------------------------
    # Input:
    #  [GitCommitLength] Commit ID Length
    #   The choice as to how the SHA1 hash is presented.  Long form, which is
    #    forty-one characters.  Short form, however, only seven characters.
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




   <# Set Fetch Changelog History
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Fetch Changelog History' variable.
    # -------------------------------
    # Input:
    #  [bool] Fetch Commit ID
    #   The choice if the Commit ID is to be retrieved from the desired repository.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFetchChangelog([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__fetchChangelog = $newVal;

        # Successfully updated.
        return $true;
    } # SetFetchChangelog()




   <# Set Changelog History Limit
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Changelog History Limit' variable.
    # -------------------------------
    # Input:
    #  [int] Changelog History Limit
    #   A maximum limit of commits are shown within the Changelog history.
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
    #  This function will check to make sure that the log and report directories,
    #   that are used in this class, currently exists within the host system's filesystem.
    #
    # ----
    #
    #  Directories to be checked:
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git\reports
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
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\Git\reports
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
            [string] $logMessage = ("The Git logging directories already exists;" + `
                                    " there is no need to create the directories again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Git Logging Directories:`r`n" + `
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
                [string] $logMessage = "Couldn't create the Git root logging and report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The root directory path is: $($this.__rootLogPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
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
                [string] $logMessage = "Couldn't create the Git logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The logging directory path is: $($this.__logPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
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
                [string] $logMessage = "Couldn't create the Git report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The report directory path is: $($this.__reportPath)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Error");                   # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
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
            [string] $logMessage = "Successfully created the Git logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Git Logging Directories:`r`n" + `
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
            # The directories could not be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the Git required logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Git Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory was:`t`t$($this.__rootLogPath)`r`n" + `
                                        "`t`tThe Logging Directory was:`t$($this.__logPath)`r`n" + `
                                        "`t`tThe Report Directory was:`t$($this.__reportPath)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : If Directories Not Found


        # A general error occurred; the directories could not be created.
        return $false;
    } # __CreateDirectories()



    #endregion



    #region Public Functions


    #region Git Detection


   <# Detect Git Executable
    # -------------------------------
    # Documentation:
    #  This function will try to detect the Git executable by making sure that the
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
    [bool] DetectGitExist()
    {
        # Make sure that the value is not empty (or null).
        if ($this.__executablePath -eq $null)
        {
            # No value was provided; unable to perform a check as nothing was provided.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the Git executable as there was no path provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the value is empty, this function was unable to detect the
            #  executable file.
            return $false;
        } # if : Executable Path is Empty


        # Check if the Git executable was found.
        if (([IOCommon]::DetectCommand("$($this.__executablePath)", "Application")) -eq $true)
        {
            # Successfully located the Git executable.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully located the Git executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable was found.
            return $true;
        } # If : Detected Git


        # Failed to detect the executable.
        else
        {
            # The path provided already does not point to a valid executable or
            #  the path does not exist.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the Git executable as the path was not valid!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git Executable Path is: $($this.__executablePath)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable could not be found.
            return $false;
        } # Else : Unable to Detect Git
    } # DetectGitExist()




   <# Find Git
    # -------------------------------
    # Documentation:
    #  This function will try to automatically find the Git executable by checking
    #   some prevalent locations within the host's filesystem.  If this function was
    #   able to successfully detect the executable, then the path to the binary file
    #   will be returned.  Otherwise, if the application was not found, then '$null'
    #   will be returned instead.
    # -------------------------------
    # Output:
    #  [string] Git Executable (Absolute) Path
    #    Returns the location of where the Git application resides.
    #    NOTE:
    #       $null - signifies that the Git executable could not be found in the common
    #                locations.
    # -------------------------------
    #>
    [string] FindGit()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Initialize a list of common absolute paths that could contain the Git
        #  executable within the user's system.
        [string[]] $listDirectoryPath = @(
                                        # Github for Windows
                                        # This should encompass a lot of users as many utilize this tool.
                                        #  Github for Windows provides the Git.exe executable within the
                                        #  Program Data under %LocalAppData%.
                                        # ====================
                                        # --------------------
                                        "$($env:LOCALAPPDATA)\GithubDesktop\"
                                        # ------------------------------------------


                                        # Git for Windows
                                        # ====================
                                        # --------------------
                                        # {AMD64}
                                        # ---------
                                        "$($env:ProgramFiles)\Git\",
                                        # - - - - -
                                        # {x86_32}
                                        # ---------
                                        "${env:ProgramFiles(x86)}\Git\",
                                        # ------------------------------------------


                                        # Visual Studio 2019 Community Edition {x86_32 && AMD64}
                                        # ====================
                                        # --------------------
                                        # {AMD64}
                                        # ---------
                                        "$($env:ProgramFiles)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\",

                                        # - - - - -
                                        # {x86_32}
                                        # ---------
                                        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\",
                                        # ------------------------------------------


                                        # Visual Studio (Any Possible Installations) {x86_32 && AMD64}
                                        # ====================
                                        # --------------------
                                        # {AMD64}
                                        # ---------
                                        "$($env:ProgramFiles)\Microsoft Visual Studio\",

                                        # - - - - -
                                        # {x86_32}
                                        # ---------
                                        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\"
                                        # ------------------------------------------
                                        );

        # This will hold the search results that were performed by another function.  If the first result was $null, 
        [System.IO.FileSystemInfo[]] $searchResult = $null;
        # ----------------------------------------


        # First, lets try to test the system's %PATH%
        if ([IOCommon]::DetectCommand("git.exe", "Application") -eq $true)
        {
            # Successfully located Git within the host system's %PATH%.  Because the executable was found, we can stop this search.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully located the Git executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git was found within the system's %PATH%";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Verbose");                 # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git executable was found via the system's $PATH, return 'git.exe'.
            return "git.exe"
        } # If : Git Reachable via %PATH%


        # Try to find the Git executable by inspecting each element within the array.
        foreach ($index in $listDirectoryPath)
        {
            # Grab all of the results possible from this array's index.
            $searchResult = [IOCommon]::SearchFile("$($index)", "git.exe")

            # Determine if there was any valid results from the search.
            if ($searchResult -ne $null)
            {
                # Successfully found the executable!


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Successfully located the Git executable!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "Git was found in: $($searchResult[0].FullName)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            "Verbose");                 # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Return the first result back to the calling function.
                return "$($searchResult[0].FullName)";
            } # If : Search Found Git
        } # Foreach : Scan Known Directory List

        # Could not find the Git executable


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Could not automatically locate the Git executable!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Places to automatically look:`r`n" + `
                                    "`t`t- $($listDirectoryPath -join "`r`n`t`t- ")");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                    "$($logAdditionalMSG)", `   # Additional information
                                    "Warning");                 # Message level

        # * * * * * * * * * * * * * * * * * * *


        # If the application could not be found, then return nothing ($null) to signify
        #  that this function was unable to find the application.
        return $null;
    } # FindGit()

    #endregion



   <# Update Local Working Copy
    # -------------------------------
    # Documentation:
    #  This function will update the project's localized repository by synchronizing with the centralized
    #   (or master) repository server.  Upon updating the localized repository from the centralized
    #   repository, the updates will only effect the currently selected branch.  Thus, all other branches
    #   will not be synchronized unless manually switching to another branch and performing the update again.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    $false = Failure to update the localized repository.
    #    $true  = Successfully updated the localized repository.
    #             OR
    #             User did not request for the local repo. to be updated (User Setting)
    # -------------------------------
    #>
    [bool] UpdateLocalRepository([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "pull";              # Arguments to be used when invoking the Git executable.
                                                    #  This will allow the Git to update the local repository
                                                    #  at the current selected Branch.
        [string] $execReason = "Update LWC";        # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the project's local repository due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the project's local repository; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to update the project's local repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the project's local repository; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Did the user wanted the project's local repository to be updated?
        if ($($this.__updateSource) -eq $false)
        {
            # The user did not want the project's local repository to be updated; abort the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the project's files because the user did not request the project to be updated (User Settings).";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Current User Setting: $($this.__updateSource)`r`n" + `
                                        "`tPath of the Target Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Warning");                 # Message level

            # * * * * * * * * * * * * * * * * * * *

            # Because the user did not want the project's local repository updated, return 'true'.
            #  Technically the operation did not fail - instead the user did not request for the
            #  local repository to be updated with the remote repository.
            return $true;
        } # If : Do not update source


        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `       # Git Executable Path
                                        "$($extCMDArgs)", `                 # Arguments to update the local repo.
                                        "$($projectPath)", `                # The working directory that Git will start from.
                                        "$($this.__logPath)", `             # The Standard Output Directory Path.
                                        "$($this.__logPath)", `             # The Error Output Directory Path.
                                        "$($this.__reportPath)", `          # The Report Directory Path.
                                        "$($execReason)", `                 # The reason why we are running Git; used for logging purposes.
                                        $false, `                           # Are we building a report?
                                        $false, `                           # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                       # Variable containing the STDOUT; if we need to process it.
        {
            # A failure had been reached; unable to update the local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to update the project's local repository.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Path of the Target Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The operation had failed -- the local repository could not be updated.
            return $false;
        } # If : Update Local Repo. Operation Failed


        # Successfully updated the project's local repository.
        return $true;
    } # UpdateLocalRepository()




   <# Switch Local Branch
    # -------------------------------
    # Documentation:
    #  This function will change the project's local repository's current branch to another, if the desired
    #   branch is available to select.  Changing branches could be a necessity to select from stable build
    #   to an experimental build or vice versa.  Once the local repository had been switched to another
    #   branch, the files will switch to match with that branch.
    #
    # Use this function with caution if one where to be active within this project's files.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    #  [string] Requested Branch
    #   The desired branch in which to switch to within the project's local repository.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure to switch to the requested branch.
    #    $true  = Successfully switched to the requested branch.
    # -------------------------------
    #>
    [bool] SwitchLocalBranch([string] $projectPath,         # Project's Local Repository Path
                            [string] $requestedBranch)      # Switch to the Requested Branch.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "checkout $($requestedBranch)";  # Arguments to be used when invoking the Git Executable.
                                                                #  This will allow Git to switch the local repository
                                                                #  to another branch.
        [string] $execReason = "Switch Branch";                 # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to switch the project's local repository branch due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)`r`n" + `
                                        "`tRequested Branch to Switch: $($requestedBranch)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to switch the project's local repository branch; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to switch the project's local repository branch.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)`r`n" + `
                                        "`tRequested Branch to Switch: $($requestedBranch)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to switch the project's local repository branch; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)`r`n" + `
                                        "`tRequested Branch to Switch: $($requestedBranch)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `       # Git Executable Path
                                        "$($extCMDArgs)", `                 # Arguments to switch the local repo's branch
                                        "$($projectPath)", `                # The working directory that Git will start from.
                                        "$($this.__logPath)", `             # The Standard Output Directory Path.
                                        "$($this.__logPath)", `             # The Error Output Directory Path.
                                        "$($this.__reportPath)", `          # The Report Directory Path.
                                        "$($execReason)", `                 # The reason why we are running Git; used for logging purposes.
                                        $false, `                           # Are we building a report?
                                        $false, `                           # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$null) -ne 0)                  # Variable containing the STDOUT; if we need to process it.
        {
            # A failure had been reached; unable to switch the project's local repository branch.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to switch the project's local repository branch.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Path of the Target Directory: $($projectPath)`r`n" + `
                                        "`tRequested Branch to Switch: $($requestedBranch)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The operation had failed -- the local repository's branch could not be changed to the requested branch.
            return $false;
        } # If : Switch Local Repo. Branch Operation Failed


        # Successfully switched from one branch to another branch.
        return $true;
    } # SwitchLocalBranch()




   <# Fetch Current Commit ID
    # -------------------------------
    # Documentation:
    #  This function will retrieve the latest Commit ID from the Project's local Git Repository
    #   from the selected Branch.  If the local git repository is behind or ahead of the remote
    #   repository, only the local local repository's Commit ID will be used.  Meaning that this function only
    #   cares about the Commit ID retrieved from the project's localized git repository.
    #
    #  Two possible Commit ID forms:
    #   - Short Form: 7 Characters
    #   - Long Form: 40 Characters
    #  The length of the Commit ID is determined by the user's preference.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Commit ID
    #   The Commit ID that was retrieved from the project's local git repository.
    #   NOTE:
    #       $null - Signifies that the Commit ID could not be provided due to complications.
    # -------------------------------
    #>
    [string] FetchCommitID([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $commitID = $null;                 # This will hold the commit ID that was retrieved from
                                                    #  Git executable.  If the Git executable was successful
                                                    #  in retrieving the Commit ID value, then this variable
                                                    #  will be returned to the calling function.
        [string] $extCMDArgs = $null;               # Arguments to be used when invoking the Git executable.
                                                    #  This will allow the Git to retrieve the commit ID from
                                                    #  project's local Git repository.
        [string] $execReason = "Fetch CommitID";    # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's current Commit ID due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's current Commit ID; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve the Commit ID from the project's local repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository current Commit ID; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Build the arguments necessary for retrieving the Commit ID by applying the user's request.
        if($($this.__lengthCommitID) -eq 0)
        {
            # Use Short Commit ID
            $extCMDArgs = "rev-parse --short HEAD";
        } # If : Short Commit ID
        else
        {
            # Use Long Commit ID
            $extCMDArgs = "rev-parse HEAD";
        } # Else : Long Commit ID


        # Execute the command
        if ([IOCommon]::ExecuteCommand("$($this.__executablePath)", `       # Git Executable Path
                                        "$($extCMDArgs)", `                 # Arguments to retrieve the Commit ID from Local Repo.
                                        "$($projectPath)", `                # The working directory that Git will start from.
                                        "$($this.__logPath)", `             # The Standard Output Directory Path.
                                        "$($this.__logPath)", `             # The Error Output Directory Path.
                                        "$($this.__reportPath)", `          # The Report Directory Path.
                                        "$($execReason)", `                 # The reason why we are running Git; used for logging purposes.
                                        $false, `                           # Are we building a report?
                                        $true, `                            # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$commitID) -ne 0)              # Variable containing the STDOUT; if we need to process it.)
        {
            # A failure had been reached; unable to retrieve the Commit ID from the project's local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve the project's local repository's current Commit ID.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Path of the Target Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        "Error");                   # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        }


        # Successfully retrieved the Commit ID from the project's local repo.
        return $commitID;
    } # FetchCommitID()




   <# Fetch Commit History (Changelog)
    # -------------------------------
    # Documentation:
    #  This function will retrieve a history of all or a specific range of commits that had been
    $   submitted to the project's local repository and remote repository.  The readable information
    $   retrieved from the repository - will be stored in within a standard textfile (.txt) file.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    #  [string] Output Path
    #   The absolute path of where the output file, containing the Project's Commit History, will be located
    #    within the host's filesystem.
    #
    #   - NOTE: We will use the Report functionality to create the file; this gives us full power to dictate
    #           as to where the output file will be located and how it will be named.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure to retrieve the Commit History.
    #    $true  = Successfully retrieved the Commit History.
    # -------------------------------
    #>
    [bool] FetchCommitHistory([string] $projectPath,        # The absolute location of the project's local repository
                                [string] $outputPath)       # The absolute path of the Commit History Output File
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "Changelog.txt"                        # The filename of the commit history (or changelog) filename
        [string] $changelogSize = $null;                            # How many submitted commits to are to be retrieved?  This is our
                                                                    #  range of commits from the latest to the minimum requested by
                                                                    #  the user.  This variable is changeable via User Settings.
                                                                    #   NOTE: 0 - Everything; from the very start to the latest commit.
        [string] $changelogPath = "$($outputPath)\$($fileName)";    # The full path of the commit history (changelog) text file.
        [string] $prettyType = "fuller";                            # The type of 'Pretty' format to be used when obtaining the history.
                                                                    #  More Information: https://git-scm.com/docs/pretty-formats
        [string] $extCMDArgs = $null;                               # Arguments to be used when invoking the Git executable.
                                                                    #  This will allow Git to retrieve the commit history (changelog) from
                                                                    #  the project's local repository at the current selected branch.
        [string] $execReason = "Fetch Commit History";              # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if (([Logging]::DebugLoggingState() -eq $true) -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we cannot log.
            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # The Git executable was not detected.
            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.
            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Did the user requested a Changelog from the Commit History of the project's repository?
        if ($this.__fetchChangelog -eq $false)
        {
            # The user does not wish to have a Changelog file, we will abort this operation by request via User Settings.
            # Because the user did not want a Changelog file, merely return 'true'.
            return $true;
        } # If : User didn't request commit history.



        # Commit History Size
        # ++++++++++++++++++++
        # How many commits are to be fetched from the project's local repository?


        # Retrieve all of the commits that had ever been made to the Project's local repository?
        if ($this.__changelogLimit -eq 0)
        {
            # User wants all of the commits that had been made within the project's current selected branch from the localized repository.
            #  To provide this request - assure that the Changelog History Size is $null.
            $changelogSize = "";
        } # If : Fetch all Commits


        # Make sure that the Changelog History size is not a negative number.  If it were to be negative - then simply negate the negative
        #  integer.
        ElseIf($this.__changelogLimit -lt 0)
        {
            $changelogSize = "-$($this.__changelogLimit * (-1))";
            # Negate the negative number
        } # If : Negated Negative Number; Error Protection


        # Changelog History request is greater than zero
        else
        {
            # Because the User's Setting is greater than zero, we will merely use the integer as is with no alterations necessary.
            $changelogSize = "-$($this.__changelogLimit)";
        } # Else : Number is greater than Zero



        # Arguments Builder Constructor
        # ++++++++++++++++++++
        # Create the arguments that will be used when calling the Git executable.


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
    # -------------------------------
    # Output:
    #  [string] Current and Active Branch
    #    The current branch selected (or active).
    # -------------------------------
    #>
    [string] FetchCurrentBranch([string] $projectPath)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw the default message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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
    [string] FetchAllBranches([string] $projectPath)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw the error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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
    [string] FetchAllBranchesActivity([string] $projectPath)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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
    [string] FetchAllContributors([string] $projectPath)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, return an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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
    # -------------------------------
    # Output:
    #  [string] Commit Graph & info
    #    Simple line-graph with commit information
    #    - NOTE: This is a giant string.
    # -------------------------------
    #>
    [string] MakeCommitGraphInfo([string] $projectPath)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected, throw an error message instead.
            return "ERR";
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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

        # Make sure that the Git Logging directories are ready for use (if required)
        if ([Logging]::DebugLoggingState() -and ($this.__CreateDirectories() -eq $false))
        {
            # Because the logging directories could not be created, we can not log.
            #  Because the logging features are required, we can not run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the git executable was detected.
        if ($($this.DetectGitExist()) -eq $false)
        {
            # Git was not detected.
            return $false;
        } # if : Git was not detected


        # Make sure that the path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $true)) -eq $false)
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


                # SECTION - Contributors
                3
                {
                    # Build the output
                    $outputContent = "2) CONTRIBUTORS`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is a list of contributors that have" + `
                                     " sent commits to this project's git repository.`r`n`r`n" + `
                                     "List of Contributors:`r`n" + `
                                     "$($this.FetchAllContributors($projectPath))`r`n`r`n";


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
                                     "$($this.FetchAllBranchesActivity($projectPath))`r`n`r`n";


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
                                     "$($this.MakeCommitGraphInfo($projectPath))";


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