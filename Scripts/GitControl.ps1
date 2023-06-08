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
 #  - To utilize Git functionality within this program, the Git Version Control must
 #     first be installed properly on the host system.  Otherwise, the features may not
 #     be readily available.
 # DEPENDENCIES (Optional):
 #  GitHub Desktop (Windows)
 #   - https://desktop.github.com/
 #  OR
 #  Git (Windows)
 #   - https://git-scm.com/
 #>




class GitControl
{
    # Object Singleton Instance
    # =================================================
    # =================================================


    #region Singleton Instance

    # Singleton Instance of the object
    hidden static [GitControl] $_instance = $null;




    # Get the instance of this singleton object (default)
    static [GitControl] GetInstance()
    {
        # If there was no previous instance of the object - then create one.
        if ($null -eq [GitControl]::_instance)
        {
            # Create a new instance of the singleton object.
            [GitControl]::_instance = [GitControl]::new();
        } # if : No Singleton Instance

        # Provide an instance of the object.
        return [GitControl]::_instance;
    } # GetInstance()




    # Get the instance of this singleton object (with arguments).
    #  This is useful if we already know the properties of this
    #  new instance of the object.
    static [GitControl] GetInstance([string] $executablePath, `             # Executable Path
                                    [bool] $updateSource, `                 # Update the Local Repository
                                    [GitCommitLength] $lengthCommitID, `    # Length of the Commit ID
                                    [bool] $fetchChangelog, `               # Fetch Changelog History
                                    [int] $changelogLimit, `                # Maximum Log Entries
                                    [bool] $generateReport, `               # Create Report
                                    [bool] $generateReportFilePDF)          # Create a PDF Report
    {
        # if there was no previous instance of the object, then create one.
        if ($null -eq [GitControl]::_instance)
        {
            # Create a new instance of the singleton object
            [GitControl]::_instance = [GitControl]::new($executablePath, `
                                                        $updateSource, `
                                                        $lengthCommitID, `
                                                        $fetchChangelog, `
                                                        $changelogLimit, `
                                                        $generateReport, `
                                                        $generateReportFilePDF);
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [GitControl]::_instance;
    } # GetInstance()

    #endregion




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
    Hidden [uint32] $__changelogLimit;


    # Generate Report
    # ---------------
    # When this is true, this will provide the ability to generate reports upon request.
    #  A report will provide information regarding the repository from those that contribute,
    #  the commit history, forks, branches, and potentially much more.  When this is false,
    #  however, the report functionality will not be available.
    Hidden [bool] $__generateReport;


    # Generate Report - PDF File
    # ---------------
    # Dependant on the Generate Report functionality, this variable will dictate
    #  if a PDF file is to be generated during the creation of the report.  The
    #  PDF file will contain all of the information from the originated report source.
    Hidden [bool] $__generateReportFilePDF;


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


    # Object GUID
    # ---------------
    # Provides a unique identifier to the object, useful to make sure that we are using
    #  the right object within the software.
    Hidden [GUID] $__objectGUID;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    GitControl()
    {
        # Executable path to the Git.exe
        $this.__executablePath = $this.FindGit();

        # Update Source
        $this.__updateSource = $true;

        # Length of the Commit ID
        $this.__lengthCommitID = [GitCommitLength]::short;

        # Fetch the changelog History
        $this.__fetchChangelog = $true;

        # Changelog history limit
        $this.__changelogLimit = 50;

        # Generate Report
        $this.__generateReport = $false;

        # Generate Report - PDF File
        $this.__generateReportFilePDF = $false;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOCAL_PROJECT_LOGS_PATH_)\Git";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # Default Constructor




    # User Preference : On-Load
    GitControl([string] $executablePath, `
                [bool] $updateSource, `
                [GitCommitLength] $lengthCommitID, `
                [bool] $fetchChangelog, `
                [uint32] $changelogLimit, `
                [bool] $generateReport, `
                [bool] $generateReportFilePDF)
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

        # Generate Report - PDF File
        $this.__generateReportFilePDF = $generateReportFilePDF;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOCAL_PROJECT_LOGS_PATH_)\Git";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
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
    [string] GetExecutablePath() { return $this.__executablePath; }




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
    [bool] GetUpdateSource() { return $this.__updateSource; }




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
    [GitCommitLength] GetLengthCommitID() { return $this.__lengthCommitID; }




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
    [bool] GetFetchChangelog() { return $this.__fetchChangelog; }




   <# Get Changelog History Limit
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Changelog History Limit' variable.
    # -------------------------------
    # Output:
    #  [uint32] Changelog History Limit
    #   The value of the 'Changelog History Limit'.
    # -------------------------------
    #>
    [uint32] GetChangelogLimit() { return $this.__changelogLimit; }




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
    [bool] GetGenerateReport() { return $this.__generateReport; }




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
    [string] GetReportPath() { return $this.__reportPath; }




   <# Get Generate Report - Generate PDF File
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Generate Report - PDF File' variable.
    # -------------------------------
    # Output:
    #  [bool] Generate Report using PDF File
    #   The value of the 'Generate Report - PDF File'.
    # -------------------------------
    #>
    [bool] GetGenerateReportFilePDF() { return $this.__generateReportFilePDF; }




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
    [string] GetLogPath() { return $this.__logPath; }




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
    [string] GetRootLogPath() { return $this.__rootLogPath; }




   <# Get Object GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the object's 'Global Unique ID' variable.
    # -------------------------------
    # Output:
    #  [GUID] Global Unique Identifier (GUID)
    #   The value of the object's GUID.
    # -------------------------------
    #>
    [GUID] GetObjectGUID() { return $this.__objectGUID; }

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
        if(([CommonIO]::DetectCommand($newVal, "Application")) -eq $false)
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
    #  [uint32] Changelog History Limit
    #   A maximum limit of commits is shown within the Changelog history.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetChangelogLimit([uint32] $newVal)
    {
        # We will not need to worry about checking the value for inaccuracies
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




   <# Set Generate Report - Generate PDF File
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Generate Report - PDF File' variable.
    # -------------------------------
    # Input:
    #  [bool] Generate Report - PDF File
    #   When true, this will allow the report functionality to generate
    #    a PDF file.  Otherwise, only the text file will be produced.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGenerateReportFilePDF([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__generateReportFilePDF = $newVal;

        # Successfully updated.
        return $true;
    } # SetGenerateReportFilePDF()




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
        return (([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true) -eq $true) -and `   # Check the Root Log Directory
                ([CommonIO]::CheckPathExists($this.GetReportPath(), $true) -eq $true) -and `    # Check the Report Path Directory
                ([CommonIO]::CheckPathExists($this.GetLogPath(), $true) -eq $true));            # Check the Log Path Directory
    } # __CheckRequiredDirectories()




   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories that will hold the log and
    #   report files that are generated from this class.  If the directories do not
    #   exist on the filesystem already, there is a change that some operations might
    #   fail due to the inability to safely store the log and\or the report files
    #   generated by the functions within this class.  If the directories do not
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
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # Root Log Directory
        if(([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true)) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (([CommonIO]::MakeDirectory($this.GetRootLogPath())) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Git root logging and report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The root directory path is: $($this.GetRootLogPath())";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Root Log Directory


        # ----


        # Log Directory
        if(([CommonIO]::CheckPathExists($this.GetLogPath(), $true)) -eq $false)
        {
            # Log Directory does not exist, try to create it.
            if (([CommonIO]::MakeDirectory($this.GetLogPath())) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Git logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The logging directory path is: " + $this.GetLogPath();

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Log Directory


        # ----


        # Report Directory
        if(([CommonIO]::CheckPathExists($this.GetReportPath(), $true)) -eq $false)
        {
            # Report Directory does not exist, try to create it.
            if (([CommonIO]::MakeDirectory($this.GetReportPath())) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Git report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The report directory path is: " + $this.GetReportPath();

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

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
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

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
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

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
    #   the variable, this function will return the result in Boolean form.
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
        if ([CommonFunctions]::IsStringEmpty($this.GetExecutablePath()))
        {
            # No value was provided; unable to perform a check as nothing was provided.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the Git executable as there was no path provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the value is empty, this function was unable to detect the
            #  executable file.
            return $false;
        } # if : Executable Path is Empty


        # Check if the Git executable was found.
        if (([CommonIO]::DetectCommand($this.GetExecutablePath(), "Application")) -eq $true)
        {
            # Successfully located the Git executable.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully located the Git executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Git Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

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
            [string] $logAdditionalMSG = "Git Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

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
        if ([CommonIO]::DetectCommand("git.exe", "Application") -eq $true)
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
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git executable was found via the system's $PATH, return 'git.exe'.
            return "git.exe";
        } # If : Git Reachable via %PATH%


        # Try to find the Git executable by inspecting each element within the array.
        foreach ($index in $listDirectoryPath)
        {
            # Grab all of the results possible from this array's index.
            $searchResult = [CommonIO]::SearchFile($index, "git.exe");

            # Determine if there were any valid results from the search.
            if ($null -ne $searchResult)
            {
                # Successfully found the executable!


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Successfully located the Git executable!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "Git was found in: " + $searchResult[0].FullName;

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Verbose);    # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Return the first result back to the calling function.
                return $searchResult[0].FullName;
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
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Warning);    # Message level

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
    #   repository, the updates will only affect the currently selected branch.  Thus, all other branches
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
        if ($this.__CreateDirectories() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Did the user wanted the project's local repository to be updated?
        if ($this.GetUpdateSource() -eq $false)
        {
            # The user did not want the project's local repository to be updated; abort the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the project's files because the user did not request the project to be updated (User Settings).";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Current User Setting: $($this.GetUpdateSource())`r`n" + `
                                        "`tPath of the Target Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *

            # Because the user did not want the project's local repository updated, return 'true'.
            #  Technically the operation did not fail, instead - the user did not request for the
            #  local repository to be updated with the remote repository.
            return $true;
        } # If : Do not update source


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to update the local repo.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $false, `                       # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                   # Variable containing the STDOUT; if we need to process it.
        {
            # A failure had been reached; unable to update the local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to update the project's local repository.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

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
    # Use this function with caution if one were to be active within this project's files.
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
    [bool] SwitchLocalBranch([string] $projectPath, `       # Project's Local Repository Path
                            [string] $requestedBranch)      # Switch to the Requested Branch.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "checkout " + $requestedBranch;  # Arguments to be used when invoking the Git Executable.
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
        if ($this.__CreateDirectories() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to switch the local repo's branch
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $false, `                       # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                   # Variable containing the STDOUT; if we need to process it.
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

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
    #   repository, only the local repository's Commit ID will be used.  Meaning that this function only
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
        if ($this.__CreateDirectories() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
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
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Build the arguments necessary for retrieving the Commit ID by applying the user's request.
        if($this.GetLengthCommitID() -eq [GitCommitLength]::short)
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
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to retrieve the Commit ID from Local Repo.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$commitID) -ne 0)          # Variable containing the STDOUT; if we need to process it.
        {
            # A failure had been reached; unable to retrieve the Commit ID from the project's local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve the project's local repository's current Commit ID.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Retrieve Commit ID


        # Remove the extra whitespace that is attached at the end of the string.
        $commitID = ($commitID -replace "`n$", "");


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
    [bool] FetchCommitHistory([string] $projectPath, `      # The absolute location of the project's local repository
                                [string] $outputPath)       # The absolute path of the Commit History Output File
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = "Changelog.txt";                       # The filename of the commit history (or changelog) filename
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
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's Commit History due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's Commit History; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve the Commit History from the project's local repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *



            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository Commit History; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $false;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Did the user requested a Changelog from the Commit History of the project's repository?
        if ($this.GetFetchChangelog() -eq $false)
        {
            # The user does not wish to have a Changelog file; we will abort this operation by request via User Settings.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository Commit History; the user did not request to retrieve the information (User Setting).";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Current User Setting: $($this.GetFetchChangelog())`r`n" + `
                                        "`tPath of the Target Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *



            # Because the user did not want a Changelog file, merely return 'true'.
            return $true;
        } # If : User didn't request commit history.



        # Commit History Size
        # ++++++++++++++++++++
        # How many commits are to be fetched from the project's local repository?

        # Retrieve all the commits that had ever been made to the Project's local repository?
        if ($this.GetChangelogLimit() -eq 0)
        {
            # User wants all the commits that had been made within the project's current selected branch from the localized repository.
            #  To provide this request - assure that the Changelog History Size is $null.
            $changelogSize = $null;
        } # If : Fetch all Commits


        # Make sure that the Changelog History size is not a negative number.  If it were to be negative - then simply negate the negative
        #  integer.
        ElseIf($this.GetChangelogLimit() -lt 0)
        {
            # Negate the negative number; we will output the result to the logfile.
            $changelogSize = [string]($this.GetChangelogLimit() * (-1));


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "The User's Commit History Limit setting is a negative integer.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User's Commit History Limit setting is: $($this.GetChangelogLimit())`r`n" + `
                                        "`tTemporary Commit History Limit (Used in this operation): $($changelogSize)`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Append the parameter denotion onto the variable
            $changelogSize = " -" + $changelogSize;
        } # If : Negated Negative Number; Error Protection


        # Changelog History request is greater than zero
        else
        {
            # Because the User's Setting is greater than zero, we will merely use the integer as is with no alterations necessary.
            $changelogSize = " -" + $this.GetChangelogLimit();
        } # Else : Number is greater than Zero



        # Arguments Builder Constructor
        # ++++++++++++++++++++
        # Create the arguments that will be used when calling the Git executable.


        # Attach the Pretty Format and the Changelog History size to the extCMD Arguments.
        $extCMDArgs = "log --pretty=$($prettyType)$($changelogSize)";



        # Execute the Command
        # ++++++++++++++++++++


        # Execute the command
        if([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `      # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to retrieve the Changelog\Commit History.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $changelogPath, `               # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $true, `                        # Are we building a report?
                                        $false, `                       # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                   # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve the commit history or a general error had occurred.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve the project's local repository's Commit History.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $false;
        } # If : Failed to retrieve the commit history.


        # Successfully retrieved the commit history.
        return $true;
    } # FetchCommitHistory()




   <# Fetch Current Branch
    # -------------------------------
    # Documentation:
    #  This function will retrieve the project's local repository's current active branch.  This can be useful to identify
    #   which branch is presently active and how the files may differ due to the differences between other branches.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Current Active Branch
    #   The present branch that is selected on the project's local repository.
    #   NOTE:
    #       $null - Signifies that the Active Branch from the local repository could not be retrieved due to complications.
    # -------------------------------
    #>
    [string] FetchCurrentBranch([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "rev-parse --abbrev-ref HEAD";       # Arguments to be used when invoking the Git executable.
                                                                    #  This will allow Git to retrieve the project's local
                                                                    #  repository's active branch.
        [string] $outputResult = $null;                             # This will hold the output provided by the Git executable.
                                                                    #  The output given will be the active branch name within the
                                                                    #  local repository.
        [string] $execReason = "Fetch Current Branch";              # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's current active branch due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's current active branch; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve the current active branch from the project's local repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the project's local repository's current active branch; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                    $extCMDArgs, `                      # Arguments to retrieve the Active Branch
                                    $projectPath, `                     # The working directory that Git will start from.
                                    $this.GetLogPath(), `               # The Standard Output Directory Path.
                                    $this.GetLogPath(), `               # The Error Output Directory Path.
                                    $this.GetReportPath(), `            # The Report Directory Path.
                                    $execReason, `                      # The reason why we are running Git; used for logging purposes.
                                    $false, `                           # Are we building a report?
                                    $true, `                            # Do we need to capture the STDOUT so we can process it further?
                                    [ref]$outputResult) -ne 0)          # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve the currently active branch name from the local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve the project's local repository's current active Branch.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Unable to Retrieve Current Active Branch


        # Successfully retrieved the current active Branch
        return $outputResult;
    } # FetchCurrentBranch()




   <# Fetch all available Branches
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the available branches that exists within the project's local repository.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Branches
    #    Available branches that are available within the project's local repository.
    #    The output provided, obviously is a string, but may contain new line characters.
    #   NOTE:
    #       $null - Signifies that the list of available branches from the local repository could not be retrieved due to complications.
    # -------------------------------
    #>
    [string] FetchAllBranches([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "branch";                    # Arguments to be used when invoking the Git executable.
                                                            #  This will allow Git to retrieve all of the available
                                                            #  branches from the project's local repository.
        [string] $outputResult = $null;                     # This will hold the output provided by the Git executable.
                                                            #  The output given will be all of the available branches
                                                            #  within the local repository.
        [string] $execReason = "Fetch All Branches";        # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of available branches within the project's local repository due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of available branches within the project's local repository; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve a list of all available branches from the project's local repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of available branches within the project's local repository; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                    $extCMDArgs, `                      # Arguments to retrieve all of the available branches within the local repo.
                                    $projectPath, `                     # The working directory that Git will start from.
                                    $this.GetLogPath(), `               # The Standard Output Directory Path.
                                    $this.GetLogPath(), `               # The Error Output Directory Path.
                                    $this.GetReportPath(), `            # The Report Directory Path.
                                    $execReason, `                      # The reason why we are running Git; used for logging purposes.
                                    $false, `                           # Are we building a report?
                                    $true, `                            # Do we need to capture the STDOUT so we can process it further?
                                    [ref]$outputResult) -ne 0)          # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve the currently active branch name from the local repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve all of the available branches within the project's local repository.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Unable to Retrieve Current Active Branch


        # Successfully retrieved all of the available branches from the local repository.
        return $outputResult;
    } # FetchAllBranches()




   <# Fetch all available Branches with Last-Known Activity
    # -------------------------------
    # Documentation:
    #  This function will retrieve the latest activity from all of the branches that are affiliated with the project's remote repository.
    #  NOTE: This function will use the available branches that are available on the remote repository, excluding the localized repository.
    #         This was done to assure that the official branches had been accounted for.  If we were to rely solely on the localized
    #         repository, it may be possible that only a few branches are rendered while the rest is not available due to the local
    #         repository not being synchronized with the remote server.  As such, some data would be hidden and not properly recorded.  To
    #         circumvent this issue, we will use the Remote Repository to assure we have all of the branches available.
    #         A pitfall to this approach, if a user had yet to publish a new branch onto the remote repository - but only remains on the
    #         user's local repository, then that data will not be detected.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Branches Last-Known Activity within Remote Repository.
    #   Provides the Last-Known activity within each Branch on the Remote-Repository.
    #    The output provided, obviously is a string, but may contain new line characters.
    #   NOTE:
    #       $null - Signifies that the list of Last-Known Activity from the available branches from the remote repository could not be
    #                retrieved due to complications.
    # -------------------------------
    #>
    [string] FetchAllBranchesActivity([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = $null;                   # Arguments to be used when invoking the Git executable.
                                                        #  This will allow Git to retrieve the Last-Known Activity
                                                        #  of all of the branches available from the Remote
                                                        #  Repository server.
        [string] $outputResult = $null;                 # This will hold the output provided by the Git executable.
                                                        #  The output given will hold the last-known activity of all
                                                        #  of the branches that are available on the Remote Repository
                                                        #  server.
        [string] $execReason = "Fetch Active Branches"; # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of Last-Known Activity from all available branches within the project's remote repository due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of Last-Known Activity from all available branches within the project's remote repository; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve a list of the Last-Known Activity from all of the available branches" + `
                                        " within the project's remote repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of Last-Known Activity from all available branches within the project's remote repository; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Arguments Builder Constructor
        # ++++++++++++++++++++


        # This should provide us with the following output:
        # *(BRANCH) - (RELATIVE_DATE)
        # Source: https://stackoverflow.com/a/30076212
        $extCMDArgs = "branch -r --sort=-committerdate" + `
                      " --format=`"%(refname:short)" + `
                      " (%(committerdate:relative))`"";



        # Execute the command
        # ++++++++++++++++++++


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to retrieve the Last-Known Activity of all branches from the Remote Repo.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$outputResult) -ne 0)      # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve the Last-Known Activity from the Branches on Remote Repo.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve a list of Last-Known Activity from all available branches within the project's remote repository.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Unable to Retrieve Last-Known Activity


        # Successfully retrieved Last Known Activity from all available Branches on Remote Repo.
        return $outputResult;
    } # FetchAllBranchesActivity()




   <# Fetch All Contributors
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the contributors that had been involved within the project's development, as well as how many commits
    #   they had previously submitted into the project's repository.
    #
    #  The following information is gathered for each contributor:
    #   - Real Name (or alias)
    #   - How many commits they pushed onto the repository
    #   - Their E-Mail Address
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Contributors
    #    All contributors that had been involved within the project's repository and how many commits published by each contributor.
    #    The output provided, obviously is a string, but may contain new line characters.
    #   NOTE:
    #       $null - Signifies that the list of contributors could not be retrieved due to complications.
    # -------------------------------
    #>
    [string] FetchAllContributors([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = "shortlog --summary --email";    # Arguments to be used when invoking the Git executable.
                                                                #  This will allow Git to retrieve a list of all contributors
                                                                #  and how many commits they each published onto the repository.
        [string] $outputResult = $null;                         # This will hold the output provided by the Git executable.
                                                                #  The output given will hold the list of contributors.
        [string] $execReason = "Fetch All Contributors";        # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of contributors due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of contributors; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve a list of contributors that had" + `
                                        " previously been involved within the project's development.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a list of contributors; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to retrieve a list of contributors that had been involved with the developments.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$outputResult) -ne 0)      # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve a list of contributors.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve a list of contributors that had been previously involved within the project's development.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Unable to obtain list of Contributors


        # Successfully retrieved a list of contributors
        return $outputResult;
    } # FetchAllContributors()




   <# Generate Graph
    # -------------------------------
    # Documentation:
    #  This function will retrieve a visual Line Graph representation of the history within the project's repository.  The Line Graph
    #   demonstrates all commits that had been pushed into the project, the date in which it was committed, and the individual that
    #   pushed the commit.  Further, this Line Graph also provides a visual representation of all branches - including the Master
    #   Branch - that relates to the main project.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    # -------------------------------
    # Output:
    #  [string] Line Graph
    #    Line Graph that contains the history of commits that had been pushed to all branches within the project.
    #    The output provided, is a giant string, and will contain new line characters.
    #   NOTE:
    #       $null - Signifies that the list of contributors could not be retrieved due to complications.
    # -------------------------------
    #>
    [string] GenerateActivityLineGraph([string] $projectPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extCMDArgs = $null;                   # Arguments to be used when invoking the Git executable.
                                                        #  This will allow Git to provide a line graph containing
                                                        #  all commits that had been pushed onto the project and
                                                        #  branch history.
        [string] $outputResult = $null;                 # This will hold the output provided by the Git executable.
                                                        #  The output given will hold the History Line Graph.  This
                                                        #  could be really big!
        [string] $execReason = "Graph Log";             # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a History Line Graph due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $null;
        } # If : Git Logging Directories


        # Make sure that the Git executable has been detected and is presently ready to be used.
        if ($this.DetectGitExist() -eq $false)
        {
            # The Git executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a History Line Graph; unable to find the Git Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the Git application was not found, it is not possible to retrieve a History Line Graph of" + `
                                        " the project's repository.`r`n" + `
                                        "`tAbsolute Path of the Project Directory: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Git application was not found, return an error to signify that the operation had failed.
            return $null;
        } # if : Git was not detected


        # Make sure that the Project Directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The project directory does not exist with the provided path, unable to proceed forward.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve a History Line Graph; unable to find the desired project's directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The project's directory was not found within the given path.`r`n" + `
                                        "`tPath of the Project Directory: $($projectPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that the operation had failed.
            return $null;
        } # if : The Project Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Arguments Builder Constructor
        # ++++++++++++++++++++++++++++++

        # This was a major help in figuring out how to accomplish this task:
        #  https://stackoverflow.com/a/9074343
        # Formatting Help:
        #  https://git-scm.com/docs/pretty-formats

        # Construct the arguments that will be necessary to generate the History Line Graph
        $extCMDArgs = ("log --graph --abbrev-commit --decorate --all" + `                   # Generate the History Line Graph
                        " --format=`"[%h] - %aD (%ar) %d%n%x09By: %an%n%x09%s%n`"");        # Formatting to be used when presenting the Commit Information



        # Execute the Command
        # ++++++++++++++++++++


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # Git Executable Path
                                        $extCMDArgs, `                  # Arguments to retrieve the History Line Graph with the appropriate formatting.
                                        $projectPath, `                 # The working directory that Git will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running Git; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # Do we need to capture the STDOUT so we can process it further?
                                        [ref]$outputResult) -ne 0)      # Variable containing the STDOUT; if we need to process it.
        {
            # Failure to retrieve the History Line Graph


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to retrieve a History Line Graph of the project's development.";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Path of the Target Directory: " + $projectPath;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error to signify that the operation was not successful.
            return $null;
        } # if : Unable to obtain the History Line Graph


        # Successfully retrieved the History Line Graph
        return $outputResult;
    } # GenerateActivityLineGraph()




   <# Create a new Report
    # -------------------------------
    # Documentation:
    #  This function will create a report based upon the project's repository that
    #   were provided when calling this function.
    #  The report will contain information regarding the activity within the project's
    #   repository.  The information may contain a list of contributors that had previously
    #   published commits onto the project, branch information, overview of the commits that
    #   had been pushed to the project, and any other general details that might be useful
    #   inspection purposes.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The path to the project's localized repository.  The provided path must contain the .git directory
    #    within the root of the project's source files.
    #  [string] (REFERENCE) Return the File Path [Text File]
    #   Returns the full path of the generated TXT report file.  Useful to
    #    provide a full location as to where the report resides within the host's
    #    filesystem.
    #  [string] (REFERENCE) Return the File Path [Portable Document File]
    #   Returns the full path of the generated PDF report file.  Useful to
    #    provide a full location as to where the report resides within the host's
    #    filesystem.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while generating the report.
    #    $true  = Successfully created the report or user did not request to
    #               generate a report.
    # -------------------------------
    #>
    [bool] CreateNewReport([string] $projectPath, `     # The absolute location of the project's local repository
                           [ref] $returnFilePathTXT, `  # Returns the report's path (TXT)
                           [ref] $returnFilePathPDF)    # Returns the report's path (PDF)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the Project Information object; this contains details
        #  in regards to where the source files exists within the user's system.
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();


        # The following variables will hold the current date and time from the host system.
        #  With this, it'll be available for the filename and inside the report.
        # - - - -
        # >> Date
        [string] $dateNow = [string](Get-Date -UFormat "%d-%b-%y");
        # >> Time
        [string] $timeNow = [string](Get-Date -UFormat "%H.%M.%S");
        # >> Date && Time
        [string] $dateTime = $dateNow + " " + $timeNow;
        # - - - -


        # This will hold the report's filename.
        # - - - -
        # >> Standard Textfile
        [string] $fileNameTXT = "$($this.GetReportPath())\$($projectInformation.GetProjectName()) - $($dateTime).txt";

        # >> Portable Document File (PDF)
        [string] $fileNamePDF = "$($this.GetReportPath())\$($projectInformation.GetProjectName()) - $($dateTime).pdf";
        # - - - -


        # Prepare the reference variables with the report file names (with path)
        # - - - -
        # >> Standard Textfile
        $returnFilePathTXT.Value = $fileNameTXT;

        # >> Portable Document File (PDF)
        #  Make sure that the user wanted a PDF file before assuming to provide the path.
        if ($this.GetGenerateReportFilePDF())
        {
            # User requested to generate a report using the PDF format
            $returnFilePathPDF.Value = $fileNamePDF;
        } # if : Make PDF Report
        # - - - -


        # This variable will hold the output provided by the various function calls that are used in this method.
        #  Because some of the information provided might be excessively large, we will only store one chunk of
        #  data at a time throughout the entire process.  It might be possible to store multiple chunks into this
        #  variable in one shoot, but we will require much more resources from the host's system main memory.  Lets
        #  try to conserve the user's primary storage.
        # NOTE: CLR String Datatypes can reach ~3GB of memory usage.
        [string] $outputContent = $null;


        # This will be used to jump from one case to another; this will greatly help to keep the procedure organized.
        #  Essentially this variable will drive the structure of the report, but in a proper sequential manner.
        [int] $traverse = 0;


        # This variable will contain a border that will visually help to separate each section of the report.  With
        #  this defined in this way, we can cut code redundancy without having type it over and over again through
        #  out this entire function.
        [string] $sectionBorder = ("------------------------------`r`n" + `
                                    "==============================`r`n" + `
                                    "==============================`r`n");


        # This variable will be used as our break to escape the do-while loop; when we are finished generating the
        #  report - this variable will allow us to move forward into the final stages of completing the newly created
        #  report.
        [bool] $readyToBreak = $false;
        # ----------------------------------------



        # Did the user want a report of the project's repository?
        if ($this.GetGenerateReport() -eq $false)
        {
            # The user does not wish to have a report generated; we will abort this operation by request.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to create the report because the user does not request to" + `
                                    " generate one (User Settings).");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Current User Setting: $($this.GetGenerateReport())`r`n" + `
                                        "`tRequested repository to generate a report: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the user did not want a report generated, merely return 'true'.
            return $true;
        } # if : Do not create report



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the Git Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the project's repository due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for Git could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tRequested repository to generate a report: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that the Git executable was detected.
        if ($this.DetectGitExist() -eq $false)
        {
            # Because Git was not detected, it is not possible to proceed any further
            #  as the application is required to retrieve information about the project's
            #  repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the project's repository; unable to find the Git Executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Be sure that the Git application is presently installed and assure that this program" + `
                                        " is able to detect the executable.`r`n" + `
                                        "`tRequested repository to generate a report: $($projectPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because Git was not found, it is not possible to proceed any further.
            return $false;
        } # if : Git was not detected


        # Make sure that the local repository exists.
        if ([CommonIO]::CheckPathExists($projectPath, $true) -eq $false)
        {
            # The local repository does not exist with the provided path given.  It is not possible to create a report.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the project's repository because the local repository does not exist!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Requested repository to generate a report: " + $projectPath;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure as the local repository does not exist.
            return $false;
        } # if : Project Path (Local Repo.) does not Exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Generate the Report (Procedure Methodology)
        #  This loop will help us to stay organized as we traverse through each step.
        DO
        {
            # Sequential steps
            switch ($traverse)
            {
                # Report Header
                0
                {
                    # Prepare the message that we will write to the report.
                    # Word Art for the report's header were provided by this website:
                    #  http://patorjk.com/software/taag
                    #  FONT: Big
                    #  All other settings set to 'default'.
                    $outputContent = ("+--------------------------------------------------+`r`n" + `
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
                                      "$($projectInformation.GetProjectName()) project.  This report contains an overview of" + `
                                      " the project's activity and workflow.  However, all information is solely based on" + `
                                      " the project's Local Repository instead of the Remote Repository.  To assure that" + `
                                      " the information gathered by this report contains the latest information, be sure" + `
                                      " that the Local Repository had been completely up to date with the Remote Repository." + `
                                      "`r`n`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Header to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's Header
                    break;
                } # Case : Report Header


                # Table of Contents
                1
                {
                    # Build the output
                    $outputContent = ("Table of Contents:`r`n" + `
                                      "---------------------`r`n" + `
                                      "1) Project Information`r`n" + `
                                      "2) Contributors`r`n" + `
                                      "3) Branches`r`n" + `
                                      "4) Commits overview`r`n" + `
                                      "`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Table of Contents to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `       # Initial message
                                                    $logAdditionalMSG, `   # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the Table of Contents
                    break;
                } # Case : Table of Contents


                # Project Information
                2
                {
                    # Build the output
                    $outputContent = ("1) PROJECT INFORMATION`r`n" + `
                                      "$($sectionBorder)`r`n`r`n" + `
                                      "Provided below is information regarding the project itself.`r`n`r`n" + `
                                      "Project Name:`r`n" + `
                                      "`t$($projectInformation.GetProjectName())`r`n`r`n" + `
                                      "Project Code Name:`r`n" + `
                                      "`t$($projectInformation.GetCodeName())`r`n`r`n" + `
                                      "Filename:`r`n" + `
                                      "`t$($projectInformation.GetFileName())`r`n`r`n" + `
                                      "Project Website:`r`n" + `
                                      "`t$($projectInformation.GetURLWebsite())`r`n`r`n" + `
                                      "Project's Documentation:`r`n" + `
                                      "`t$($projectInformation.GetURLWiki())`r`n`r`n" + `
                                      "Project's Repository:`r`n" + `
                                      "`t$($projectInformation.GetURLSource())`r`n" + `
                                      "`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Project Information to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the Project Info.
                    break;
                } # Case : Project Information


                # Contributors
                3
                {
                    # Build the output
                    $outputContent = ("2) CONTRIBUTORS`r`n" + `
                                      "$($sectionBorder)`r`n`r`n" + `
                                      "Provided below is a list of contributors that have" + `
                                      " sent commits to this project's git repository.`r`n`r`n" + `
                                      "List of Contributors:`r`n" + `
                                      "$($this.FetchAllContributors($projectPath))`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Contributors to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the Contributors
                    break;
                } # Case : Contributors


                # Branch
                4
                {
                    # Build the output
                    $outputContent = ("3) BRANCHES`r`n" + `
                                      "$($sectionBorder)`r`n`r`n" + `
                                      "Provided below is list of branches that are" + `
                                      " available in this repository.`r`n`r`n" + `
                                      "List of Branches:`r`n" + `
                                      "$($this.FetchAllBranchesActivity($projectPath))`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Branch List to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the Branches
                    break;
                } # Case : Branch


                # Commits Overview
                5
                {
                    # Build the output
                    $outputContent = ("4) COMMITS OVERVIEW`r`n" + `
                                      "$($sectionBorder)`r`n`r`n" + `
                                      "Provided below is an overview of commits that" + `
                                      "  have been submitted to this project's repository.`r`n`r`n" + `
                                      "List of Commits:`r`n" + `
                                      "$($this.GenerateActivityLineGraph($projectPath))");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Commits Overview Details to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Jump out of the Loop key; without this flag - a Run-Away will occur.
                    $readyToBreak = $true;


                    # Finished with the Commits Overview
                    break;
                } # Case : Commits Overview


                # Default - ERROR; Run Away
                default
                {
                    # Something went horribly wrong
                    #  In normal cases, we should _NEVER_ reach this point.


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = "Run-Away had occurred while generating the requested report!";

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                                "`tIteration Step: $($traverse)`r`n" + `
                                                "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                                "`tTried to write to report file: $($fileNameTXT)`r`n");

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                $logAdditionalMSG, `        # Additional information
                                                [LogMessageLevel]::Error);  # Message level

                    # * * * * * * * * * * * * * * * * * * *


                    # Because a Run-Away occurred,
                    return $false;
                } # Case : Default
            } # switch()
        } While ($readyToBreak -eq $false);


        # Does the user also want a PDF file of the report?
        if ($this.GetGenerateReportFilePDF() -eq $true)
        {
            # Create the PDF file as requested
            if([CommonIO]::CreatePDFFile($fileNameTXT, $fileNamePDF) -eq $false)
            {
                # Failure occurred while creating the PDF document.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Could not create a PDF file of the report!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                            "`tRequested Local Repository generate a report: $($projectPath)`r`n" + `
                                            "`tText file of the report: $($fileNameTXT)`r`n" + `
                                            "`tTried to create PDF file: $($fileNamePDF)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Because the report could not be made in the PDF format, we will signify an error.
                return $false;
            } # If : Failure while creating PDF
        } # If : Make PDF Report


        # Successfully wrote to the file
        return $true;
    } # CreateNewReport()




   <# Thrash Logs and Reports
    # -------------------------------
    # Documentation:
    #  This function will expunge any log and report files that were generated by this object.
    #   Such files are only removed, by this function, if their extensions are known within
    #   this function.  For example, if a file extension known in this function is '*.txt'
    #   and '*.docx', only those files will be removed from the logging directories.
    # -------------------------------
    # Input:
    #  [bool] Expunge reports
    #   When this argument is set to true, reports - that were generated by this object - will
    #    be thrashed.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more operations failed.
    #   $true = Successfully expunged the files.
    #           OR
    #           Logging and\or Report directories were not found.
    # -------------------------------
    #>
    [bool] ThrashLogs([bool] $expungeReports)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $extLogs = @('*.err', '*.out');      # Array of log extensions
        [string[]] $extReports = @('*.txt', '*.pdf');   # Array of report extensions
        [string] $knownExtensions = $null;              # This will hold a nice string value of all of
                                                        #  the extensions that this function will remove;
                                                        #  extensions being: $extLogs and $extReports combined.
                                                        #  This is primarily used for logging purposes.
        [bool] $exitCode = $true;                       # The exit code status provided by the log\report
                                                        #  deletion operation status.  If the operation
                                                        #  was successful then true will be set, otherwise
                                                        #  it will be false to signify an error.
        # ----------------------------------------


        # Before we start, setup the known extensions variable for logging purposes.
        #  Get all of the known extensions used for logging; $extLogs
        foreach ($item in $extLogs)
        {
            # if this is the first entry in the variable, then just apply the item
            #  to the string without adding a appending the previous entries.
            if ($null -eq $knownExtensions)
            {
                # First entry to the string.
                $knownExtensions = $item;
            }# If: first entry

            # There is already information in the variable, append the new entry to the
            #  previous data.
            else
            {
                # Append the entry to the string list.
                $knownExtensions += ", " + $item;
            } # Else: Append entry
        } # Foreach: Known Logging Extensions


        #  Did the user wanted to remove all report files?
        if ($expungeReports)
        {
            # Get all of the known extensions used for reports; $extReports
            foreach($item in $extReports)
            {
                # Append the entry to the string list.
                $knownExtensions += ", " + $item;
            } # Foreach: Known Report Extensions
        } # If: Reports are included in operation



        # Make sure that the logging directories exist.  If the directories are not
        #  available presently, then there is nothing that can be done at this time.
        if ($this.__CheckRequiredDirectories() -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to delete the requested files as the logging directories were not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *



            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            return $true;
        } # IF : Required Directories Exists


        # Because the directories exist, let's try to thrash the logs.
        if([CommonIO]::DeleteFile($this.GetLogPath(), $extLogs) -eq $false)
        {
            # Reached a failure upon removing the requested log files.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while removing the requested log files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the operation failed, we will update the exit code to 'false'
            #  to signify that we reached an error.
            $exitCode = $false;
        } # If : failure to delete files


        # ----


        # Did the user also wanted to thrash the reports?
        if (($expungeReports -eq $true) -and `
            ([CommonIO]::DeleteFile($this.GetReportPath(), $extReports) -eq $false))
        {
            # Reached a failure upon removing the requested log files.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while removing the requested report files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the operation failed, we will update the exit code to 'false'
            #  to signify that we reached an error.
            $exitCode = $false;
        } # If : thrash the reports


        # If everything succeeded, provide this information to the logfile.
        if ($exitCode)
        {
            # The operation was successful, provide the information to the logfile.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully expunged the requested files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: Git`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # If: Everything was Successful


        # If we made it here, then everything went okay!
        return $exitCode;
    } # ThrashLogs()

    #endregion
} # GitControl




<# Git Commit Type [ENUM]
 # -------------------------------
 # Type of Commit Hash ID Length.
 # This provides a way to define how the SHA1 hash is to be presented.
 # -------------------------------
 #>
enum GitCommitLength
{
    short   = 0; # Short Form contains seven characters
    long    = 1; # Long Form contains forty-one characters
} # GitCommitType