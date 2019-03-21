<# Logging Functionality (Debugging)
 # ------------------------------
 # ==============================
 # ==============================
 # This class provides the ability to log special
 #  activities and to handle logging functionality.
 #  Because bugs can happen at various places within
 #  the program and with specific scenarios, logging
 #  can allow the ability to trace where an issue
 #  occurred and what steps where preformed to get
 #  that error or odd behaviour.  These logs are only
 #  designed for debugging purposes.
 #>




class Logging
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)


    # Log Root Path
    # ---------------
    # This will hold the main log directory; where all
    #  logs are to be centralized.
    Hidden [string] $__logRootPath;


    # Buffer Log Path
    # ---------------
    # This will hold the path in which the log files of
    #  the buffer history is stored.
    Hidden [string] $__logBufferPath;


    # Program Log Path
    # ---------------
    # This will hold the path of the log file of the
    #  program's activity.
    Hidden [string] $__logProgramPath;


    # File Timestamp
    # ---------------
    # This will hold the timestamp of the current session;
    #  must be formatted in such a way that it is acceptable
    #  to the host's filesystem.
    Hidden [string] $__fileTimestamp;


    # File Name: Buffer History
    # ---------------
    # This will hold the file name that will contain the session's
    #  buffer history.
    Hidden [string] $__fileNameBufferHistory;


    # File Name: Program Activity
    # ---------------
    # This will hold the file name that will contain the program's
    #  activity during the current session.
    Hidden [string] $__fileNameProgramActivity;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructors


    # Logging Functionality : On-Load
    Logging([string] $logRootPath)
    {
        # Log Root Path
        $this.__logRootPath = "$($logRootPath)";

        # Buffer History Log Path
        $this.__logBufferPath = "$($this.__logRootPath)\Buffer";

        # Program Activity Log Path
        $this.__logProgramPath = "$($this.__logRootPath)\Program";

        # Session Timestamp
        $this.__fileTimestamp = "$($this.__GenerateSessionTimestamp())";

        # Program Activity Log Filename
        $this.__fileNameProgramActivity = "$($this.__fileTimestamp)-Program Log.txt";

        # Buffer History Log Filename
        $this.__fileNameBufferHistory = "$($this.__fileTimestamp)-Buffer History.txt";


        # ==================
        # Functions

        # Create the necessary directories
        $this.__CreateDirectories() | Out-Null;
    } # Logging Functionality : On-Load


    #endregion



    #region Getter Functions


   <# Get Log Root Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Log Root Path variable.
    # -------------------------------
    # Output:
    #  [string] Log Root Path
    #   Returns the value of the Log Root Path.
    # -------------------------------
    #>
    [string] GetLogRootPath()
    {
        return $this.__logRootPath;
    } # GetLogRootPath()




   <# Get Log Buffer Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Log Buffer Path variable.
    # -------------------------------
    # Output:
    #  [string] Log Buffer Path
    #   Returns the value of the Log Buffer History Path.
    # -------------------------------
    #>
    [string] GetLogBufferPath()
    {
        return $this.__logBufferPath;
    } # GetLogBufferPath()




   <# Get Log Program Activity Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Log Program Activity Path variable.
    # -------------------------------
    # Output:
    #  [string] Log Program Act. Path
    #   Returns the value of the Log Program Activity Path.
    # -------------------------------
    #>
    [string] GetLogProgramPath()
    {
        return $this.__logProgramPath;
    } # GetLogProgramPath()




   <# Get File Timestamp
    # -------------------------------
    # Documentation:
    #  Returns the value of the File Timestamp variable.
    # -------------------------------
    # Output:
    #  [string] File Timestamp
    #   Returns the value of the File Timestamp.
    # -------------------------------
    #>
    [string] GetFileTimestamp()
    {
        return $this.__fileTimestamp;
    } # GetFileTimestamp()




   <# Get Buffer History Filename
    # -------------------------------
    # Documentation:
    #  Returns the value of the Buffer History Filename variable.
    # -------------------------------
    # Output:
    #  [string] Buffer History Filename
    #   Returns the value of the Buffer History filename.
    # -------------------------------
    #>
    [string] GetFileNameBufferHistory()
    {
        return $this.__fileNameBufferHistory;
    } # GetFileNameBufferHistory()




   <# Get Program Activity Filename
    # -------------------------------
    # Documentation:
    #  Returns the value of the Program Activity Filename variable.
    # -------------------------------
    # Output:
    #  [string] Program Activity Filename
    #   Returns the value of the Program Activity filename.
    # -------------------------------
    #>
    [string] GetFileNameProgramActivity()
    {
        return $this.__fileNameProgramActivity;
    } # GetFileNameProgramActivity()


    #endregion Getter Functions



    #region Setter Functions


   <# Set Log Root Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Log Root Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLogRootPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__logRootPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetExecutablePath()




   <# Set Log Buffer Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Log Buffer Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLogBufferPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__logBufferPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetLogBufferPath()




   <# Set Log Program Activity Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Log Program Activity Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLogProgramPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__logProgramPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetLogProgramPath()




   <# Set File Timestamp
    # -------------------------------
    # Documentation:
    #  Sets a new value for the File Timestamp variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFileTimestamp([string] $newVal)
    {
        # Because there is overly an abundance of date and
        #  time formatting options, it is just best to
        #  blindly accept whatever is requested.
        $this.__fileTimestamp;

        # Successfully changed
        return $false;
    } # SetFileTimestamp()




   <# Set Buffer History Filename
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Buffer History Filename variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFileNameBufferHistory([string] $newVal)
    {
        # Accept what was requested
        $this.__fileNameBufferHistory;

        # Successfully changed
        return $false;
    } # SetFileNameBufferHistory()




   <# Set Program Activity Filename
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Program Activity Filename variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFileNameProgramActivity([string] $newVal)
    {
        # Accept what was requested
        $this.__fileNameProgramActivity;

        # Successfully changed
        return $false;
    } # SetFileNameProgramActivity()


    #endregion Setter Functions



    #region Private Functions


   <# Get Session Timestamp
    # -------------------------------
    # Documentation:
    #  This function will generate a timestamp that
    #   can be used for the logfiles generated within
    #   this class.  The timestamps must be formatted
    #   in such a way that it is acceptable to the
    #   host's filesystem.
    # -------------------------------
    # Output:
    #  [string] Session Timestamp
    #   The generated timestamp usable for filenames.
    # -------------------------------
    #>
    Hidden [string] __GenerateSessionTimestamp()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $timestamp = $null;    # This will hold our full timestamp
        [string] $cacheTime = $null;    # This will hold the current time
        [string] $cacheDate = $null;    # This will hold the current date
        # ----------------------------------------


        # Generate the current time
        $cacheTime = "$(Get-Date -UFormat "%H.%M.%S")";

        # Generate the current date
        $cacheDate = "$(Get-Date -UFormat "%d-%b-%y")";

        # Now put it all together
        $timestamp = "$($cacheDate) $($cacheTime)";


        # Return the timestamp
        return "$($timestamp)";
    } # __GenerateSessionTimestamp()    




   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function was created to check the directories
    #   that this class requires.
    #
    # ----
    #
    #  Directories to Check:
    #   - \Buffer
    #   - \Program
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Hidden [bool] __CheckRequiredDirectories()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [IOCommon] $io = [IOCommon]::new();       # Using functions from IO Common
        # ----------------------------------------


        # Check Program Log Directory
        if ((($io.CheckPathExists("$($this.__logProgramPath)")) -eq $true) -and `

        # Check Buffer Log Directory
        (($io.CheckPathExists("$($this.__logBufferPath)")) -eq $true))
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
    #   - \Buffer
    #   - \Program
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
        # Declarations and Initializations
        # ----------------------------------------
        [IOCommon] $io = [IOCommon]::new();       # Using functions from IO Common
        # ----------------------------------------


        # First, check if the directories already exist?
        if(($this.__CheckRequiredDirectories())-eq $true)
        {
            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # Program Log Directory
        if(($io.CheckPathExists("$($this.__logProgramPath)")) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (($io.MakeDirectory("$($this.__logProgramPath)")) -eq $false)
            {
                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Program Log Directory


        # ----


        # Buffer History Log Directory
        if(($io.CheckPathExists("$($this.__logBufferPath)")) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if (($io.MakeDirectory("$($this.__logBufferPath)")) -eq $false)
            {
                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Buffer History Log Directory


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


   <# Thrash Logs and Reports
    # -------------------------------
    # Documentation:
    #  This function will expunge the log files that
    #   are present in sub-directories that are
    #   managed within the class.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more operations failed
    #   $true = Successfully expunged the files.
    #           OR
    #           Directories were not found
    # -------------------------------
    #>
    [bool] ThrashLogs()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [IOCommon] $io = [IOCommon]::new();     # Using functions from IO Common
        [string[]] $extLogs = @('*.txt');       # Array of log extensions
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
        # Program Logs
        if (($io.DeleteFile("$($this.__logProgramPath)", $extLogs)) -eq $false)
        {
            # Failure to remove the requested files
            return $false;
        } # If : Failure to delete Program Logs


        # ----


        # Buffer History Logs
        if ((($io.DeleteFile("$($this.__logBufferPath)", $extLogs))) -eq $false)
        {
            # Failure to remove the requested files
            return $false;
        } # If : Failure to delete Buffer History Logs



        # If we made it here, then everything went okay!
        return $true;
    } # ThrashLogs()




   <# Capture Buffer
    # -------------------------------
    # Documentation:
    #  This function will log all output and input that
    #   is provided in the console's or terminal's buffer.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    [bool] CaptureBuffer()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;  # The operation exit code.
        # ----------------------------------------


        # Try to capture the terminal's buffer activity
        try
        {
            # Capture all activity provided within the buffer
            Start-Transcript -Path "$($this.__logBufferPath)\$($this.__fileNameBufferHistory)" `
                             -NoClobber `
                             -ErrorAction Stop;

            # Update the operation status
            $exitCode = $true;
        } # Try : Run 

        catch
        {
            # Display message on screen that the buffer will not be logged due to error.
            Write-Host "Failure occurred while capturing the terminal's buffer!" `
                       "Response Provided: $($_)";

            # Update the operation status
            $exitCode = $false;
        } # Catch : Error Occurred


        # Return the operation status
        return $exitCode;
    } # CaptureBuffer()




   <# Terminate Capturing Buffer
    # -------------------------------
    # Documentation:
    #  This function will close the transcripting service
    #   that was previously enabled to capture all activity
    #   from the buffer screen.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    [bool] CaptureBufferStop()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;  # The operation exit code.
        # ----------------------------------------


        # Try to stop all transcripts that is currently recording the session
        try
        {
            # Terminate transcription
            Stop-Transcript -ErrorAction Stop
                           
            # Update the operation status
            $exitCode = $true;
        } # Try : Run 

        catch
        {
            # Display error message
            Write-Host "Failure occurred while stopping the transcription service!" `
                       "Response Provided: $($_)";

            # Update the operation status
            $exitCode = $false;
        } # Catch : Error Occurred


        # Return the operation status
        return $exitCode;
    } # CaptureBufferStop()




   <# Write to Logfile [Program Activity]
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to write
    #   readable data to the Program's Activity logfile.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The readable message that will be sent to the logfile.
    #  [bool] User Preferences - Logging
    #   This merely holds the user's setting if they wish for
    #   the activity to be logged or not.
    #  [bool] Force Writing (Override Switch)
    #   When true, the provided information will be recorded
    #    - regardless of the user's logging preferences.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    [bool] WriteLogFile([string] $message, [bool] $userPrefLog, [bool] $forceWrite)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [IOCommon] $io = [IOCommon]::new();     # Using functions from IO Common
        [string] $timestamp = $null;            # Timestamp of the message
        [string] $messageToWrite = $null;       # Message with added information
        # ----------------------------------------


        # Did the user want the information logged?
        if (($userPrefLog -eq $false) -and ($forceWrite -eq $false))
        {
            # As requested, nothing is to be written on file.
            #  Return as successful, because there really was no error.
            return $true;
        } # If : User Requests not Logging



        # Get the timestamp
        $timestamp = "$($this.__GenerateSessionTimestamp())";

        # Apply the timestamp to the message
        $messageToWrite = "[$($timestamp)] $($message)";


        # Write the readable data to the logfile.
        if (($io.WriteToFile("$($this.__logProgramPath)\$($this.__fileNameProgramActivity)", "$($messageToWrite)")) -eq $false)
        {
            # The message failed to be written to file,
            #  return false to signify failure.
            return $false;
        } # If : Operation Failed
        

        # If we made it here, everything was successful.
        return $true;
    } # WriteLogFile()
    #endregion
} # Logging