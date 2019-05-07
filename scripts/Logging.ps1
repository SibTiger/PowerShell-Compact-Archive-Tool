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


    #region Variables


    # Program Log Path
    # ---------------
    # The centralized location of where the program's logfiles will be located.
    Static [string] $ProgramLogPath = "$($GLOBAL:_PROGRAMDATA_LOGS_PATH_)\Program";


    # Program Log Filename
    # ---------------
    # The filename of the program's log
    Static [string] $ProgramLogFileName = "$($GLOBAL:_PROGRAMNAMESHORT_).log";

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


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
    Static Hidden [string] __GenerateSessionTimestamp()
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
    #   - \Logs\Program
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Static Hidden [bool] __CheckRequiredDirectories()
    {
        # Check Program Log Directory
        if (([IOCommon]::CheckPathExists("$([Logging]::ProgramLogPath)")) -eq $true)
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
    #   - \Logs\Program
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure creating the new directories.
    #    $true  = Successfully created the new directories
    #             OR
    #             Directories already existed, nothing to do.
    # -------------------------------
    #>
    Static Hidden [bool] __CreateDirectories()
    {
        # First, check if the directories already exist?
        if(([Logging]::__CheckRequiredDirectories())-eq $true)
        {
            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because the directory was not detected, we must create it before we
        #  can use it within the program.

        # Program Log Directory
        if(([IOCommon]::CheckPathExists("$([Logging].ProgramLogPath)")) -eq $false)
        {
            # Program Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$([Logging]::ProgramLogPath)")) -eq $false)
            {
                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Program Log Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if(([Logging]::__CheckRequiredDirectories())-eq $true)
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
    Static [bool] ThrashLogs()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $extLogs = @('*.log');       # Array of log extensions
        # ----------------------------------------


        # First, make sure that the directories exist.
        #  If the directories are not available, than there
        #  is nothing that can be done.
        if(([Logging]::__CheckRequiredDirectories())-eq $true)
        {
            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            return $true;
        } # IF : Required Directories Exists


        # Because the directories exists, lets try to thrash the log files.
        if (([IOCommon]::DeleteFile("$([Logging]::ProgramLogPath)", $extLogs)) -eq $false)
        {
            # Failure to remove the requested files
            return $false;
        } # If : Failure to delete Program Logs



        # If we made it here, then everything went okay!
        return $true;
    } # ThrashLogs()




   <# Write to Logfile [Program Activity]
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to write
    #   readable data to the Program's Activity logfile.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The readable message that will be written to the logfile.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    Static [bool] WriteLogFile([string] $message)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $timestamp = $null;            # Timestamp of the message
        [string] $messageToWrite = $null;       # Message with added information
        # ----------------------------------------

        # Make sure that the required directories exists for logging, if not - try to create it.
        if ([Logging]::__CreateDirectories() -eq $false)
        {
            # Because the directory could not be created, there's no point in
            #  trying to write information to a log file - when the directory
            #  does not exist.
            Write-Output "ERR! Program Log Directory failed to be created!";
            return $false;
        } # If : Program Log Dir. does not exist.


        # Get the timestamp
        $timestamp = "$([Logging]::__GenerateSessionTimestamp())";

        # Apply the timestamp to the message
        $messageToWrite = "[$($timestamp)] $($message)";


        # Write the readable data to the logfile.
        if (([IOCommon]::WriteToFile("$([Logging]::ProgramLogPath)\$([Logging]::ProgramLogFileName)", "$($messageToWrite)")) -eq $false)
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