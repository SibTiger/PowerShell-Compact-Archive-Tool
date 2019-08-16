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


   <# Get Logging Lock Key
    # -------------------------------
    # Documentation:
    #  This function will return the value of the logging lock key. This lock
    #   is important to assure that we do not log recursive information.
    # -------------------------------
    # Output:
    #   [bool] Lock status
    #       $true = A function requested the logging lock to be enabled.
    #       $false = No function has the lock placed presently.
    # -------------------------------
    #>
    static Hidden [bool] __GetLoggingLockKey()
    {
        return $Global:_LOGGINGLOCKKEY_;
    } # __GetLoggingLockKey()




   <# Set Logging Lock Key
    # -------------------------------
    # Documentation:
    #  This function will allow the logging functionality to temporarily pause.
    #   This is used to assure that nothing is logged that could cause recursive
    #   information - which would ultimately lead to a stack overflow.
    #   - When setting this true, a function is requesting that the logging
    #      functionality is temporarily paused.  Do know that the logging
    #      functionality will still operate as intended, but nothing will be written
    #      to the user's filesystem.
    #   - When setting this to false, the logging functionality will resume its entire
    #      logging protocol - information and data will be written to the user's
    #      filesystem.
    # -------------------------------
    # Input:
    #  [bool] New Value
    #   $True = Logging functionality is temporarily paused; nothing is written
    #             to the filesystem.
    #   $False = Logging functionality protocol is allowed to execute; data
    #             and information is written to the filesystem.
    # -------------------------------
    #>
    static Hidden [void] __SetLoggingLockKey([bool] $value)
    {
        $Global:_LOGGINGLOCKKEY_ = $value;
    } # __SetLoggingLockKey()




   <# Generate Timestamp
    # -------------------------------
    # Documentation:
    #  This function will generate a timestamp that
    #   can be used for the information that will
    #   be stored in the logfile.  The timestamp will
    #   help to provide a depiction of when an event
    #   or activity occurred within the program's
    #   run-time.
    # -------------------------------
    # Output:
    #  [string] Session Timestamp
    #   The generated timestamp for information being
    #    written in a logfile.
    # -------------------------------
    #>
    Static Hidden [string] __GenerateTimestamp()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $timestamp = $null;    # This will hold our full timestamp
        [string] $cacheTime = $null;    # This will hold the current time
        [string] $cacheDate = $null;    # This will hold the current date
        # ----------------------------------------


        # Get the current time
        $cacheTime = "$(Get-Date -UFormat "%H.%M.%S")";

        # Get the current date
        $cacheDate = "$(Get-Date -UFormat "%d-%b-%y")";

        # Now put it all together
        $timestamp = "$($cacheDate) $($cacheTime)";


        # Return the timestamp
        return "$($timestamp)";
    } # __GenerateTimestamp()




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
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $controlLockKey  = $false;       # This will help to determine the lock status; wither
                                                #  the 'Logging Lock Key' is being controlled by any of
                                                #  the outside functions.
        [bool] $exitCode        = $false;       # Provides the status code if all of the required directories
                                                #  are present in the host's filesystem.
        # ----------------------------------------


        # Determine if the logging lock key was already set by another function
        if ([Logging]::__GetLoggingLockKey())
        {
            # Another function has already placed a logging lock, do not manipulate the main lock.
            $controlLockKey = $false;
        } # if : Logging lock key controlled outside

        # The logging lock is presently not locked; this function may control it.
        else
        {
            # This function may control the logging lock.
            $controlLockKey = $true;

            # Lock the Logging functionality; this is required to avoid recursive calls.
            [Logging]::__SetLoggingLockKey($true);
        } # else : Logging lock key is controlled by this function



        # Check Program Log Directory
        if (([IOCommon]::CheckPathExists("$([Logging]::ProgramLogPath)")) -eq $true)
        {
            # All of the required directories are present in the filesystem
            $exitCode = $true;
        } # If : Check Directories Exists

        else
        {
            # One or more of the required directories are missing from the filesystem.
            $exitCode = $false;
        } # Else : Directories does not exist


        # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
        if($controlLockKey)
        {
            # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
            #  -- NOTE: If other functions already has it set - do not touch it!
            [Logging]::__SetLoggingLockKey($false);
        } # If : This function controls the logging lock key


        # Return the status to the calling function
        return $exitCode;
    } # __CheckRequiredDirectories()




   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories
    #   required for this class to operate successfully.
    #  If the directories does not exist, then the directories
    #   are to be created in the host's filesystem.
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
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $controlLockKey  = $false;       # This will help to determine the lock status; wither
                                                #  the 'Logging Lock Key' is being controlled by any of
                                                #  the outside functions.
        # ----------------------------------------


        # Determine if the logging lock key was already set by another function
        if ([Logging]::__GetLoggingLockKey())
        {
            # Another function has already placed a logging lock, do not manipulate the main lock.
            $controlLockKey = $false;
        } # if : Logging lock key controlled outside

        # The logging lock is presently not locked; this function may control it.
        else
        {
            # This function may control the logging lock.
            $controlLockKey = $true;

            # Lock the Logging functionality; this is required to avoid recursive calls.
            [Logging]::__SetLoggingLockKey($true);
        } # else : Logging lock key is controlled by this function



        # First, check if the directories already exist?
        if(([Logging]::__CheckRequiredDirectories())-eq $true)
        {
            # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
            if($controlLockKey)
            {
                # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
                #  -- NOTE: If other functions already has it set - do not touch it!
                [Logging]::__SetLoggingLockKey($false);
            } # If : This function controls the logging lock key

            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because the directory was not detected, we must create it before we
        #  can use it within the program.

        # Program Log Directory
        if(([IOCommon]::CheckPathExists("$([Logging]::ProgramLogPath)")) -eq $false)
        {
            # Program Log Directory does not exist, try to create it.
            if (([IOCommon]::MakeDirectory("$([Logging]::ProgramLogPath)")) -eq $false)
            {
                # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
                if($controlLockKey)
                {
                    # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
                    #  -- NOTE: If other functions already has it set - do not touch it!
                    [Logging]::__SetLoggingLockKey($false);
                } # If : This function controls the logging lock key

                # Failure occurred.
                return $false;
            } # If : Failed to Create Directory
        } # Program Log Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if(([Logging]::__CheckRequiredDirectories())-eq $true)
        {
            # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
            if($controlLockKey)
            {
                # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
                #  -- NOTE: If other functions already has it set - do not touch it!
                [Logging]::__SetLoggingLockKey($false);
            } # If : This function controls the logging lock key

            # The directories exist
            return $true;
        } # IF : Check if Directories Exists


        # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
        if($controlLockKey)
        {
            # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
            #  -- NOTE: If other functions already has it set - do not touch it!
            [Logging]::__SetLoggingLockKey($false);
        } # If : This function controls the logging lock key

        # A general error occurred, the directories could not be created.
        return $false;
    } # __CreateDirectories()




   <# Write to Logfile [Write File]
    # -------------------------------
    # Documentation:
    #  This function will take the provided message and
    #   write it to the specific logfile.  Additionally,
    #   this function will assure that the logfile can
    #   be created to the host's filesystem.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The readable message that will be written to the logfile.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #             OR
    #             Is locked; cannot write to secondary storage
    #              due to Logging Lock Key value.
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    Static Hidden [bool] __WriteLogFile([string] $message)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $controlLockKey  = $false;       # This will help to determine the lock status; wither
                                                #  the 'Logging Lock Key' is being controlled by any of
                                                #  the outside functions.
        [bool] $exitCode        = $false;       # Provides the exit code of the operation performed
                                                #  within the function.
        # ----------------------------------------


        # Determine if the logging lock key was already set by another function
        if ([Logging]::__GetLoggingLockKey())
        {
            # Another function has already placed a logging lock, we can NOT proceed in this function.
            #  Return immediately.
            return $false;
        } # if : Logging lock key controlled outside

        # The logging lock is presently not locked; this function may control it.
        else
        {
            # This function may control the logging lock.
            $controlLockKey = $true;

            # Lock the Logging functionality; this is required to avoid recursive calls.
            [Logging]::__SetLoggingLockKey($true);
        } # else : Logging lock key is controlled by this function



        # Make sure that the required directories exists for logging, if not - try to create it.
        if ([Logging]::__CreateDirectories() -eq $false)
        {
            # Because the directory could not be created, there's no point in
            #  trying to write information to a log file - when the directory
            #  does not exist.
            Write-Output "ERR! Program Log Directory failed to be created!";

            # Provide an error code
            $exitCode = $false;
        } # If : Program Log Dir. does not exist.


        # Make sure that there is something to actually write, if there is no message - then
        #  there is no point in trying to write to the host's filesystem.
        elseif ("$($message)" -eq "$($null)")
        {
            # Because the message is empty, there is really nothing that can be written to
            #  the logfile.
            Write-Output "ERR! Message can not be recorded as it is null!";

            # Provide an error code
            $exitCode = $false;
        } # Else-If : Message is empty


        # Write the readable data to the logfile.
        elseif (([IOCommon]::WriteToFile("$([Logging]::GetLogFilePath())", "$($message)")) -eq $false)
        {
            # The message failed to be written to file,
            #  provide an exit code of false to signify failure.
            $exitCode = $false;
        } # Else-If : Operation Failed

        # Operation was successful
        else
        {
            # Because the operation was successful, set the exit code as successful.
            $exitCode = $true;
        } # Else : Successful operation


        # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
        if($controlLockKey)
        {
            # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
            #  -- NOTE: If other functions already has it set - do not touch it!
            [Logging]::__SetLoggingLockKey($false);
        } # If : This function controls the logging lock key


        # Return the status to the calling function
        return $exitCode;
    } # __WriteLogFile()




   <# Format Log Message
    # -------------------------------
    # Documentation:
    #  This function will format the information that
    #   is passed into this function.  From this function,
    #   once the information has been formatted in a
    #   unified form, will pass the data to another
    #   function that will write to the log file.
    #  In order to write to the log file, it is recommended
    #   to pass to this function.
    # -------------------------------
    # Input:
    #  [LogMessageLevel] Message Level
    #    The message level severity of the information provided.
    #  [String] Initial Message
    #    The message that will be recorded in the logfile.
    #  [String] Additional Information (Nullable)
    #    Additional information that relates to the initial message.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Operation failed
    #    $true  = Operation was successful 
    # -------------------------------
    #>
    static Hidden [bool] __FormatLogMessage([LogMessageLevel] $msgLevel, `
                                            [String] $msg, `
                                            [String] $additionalMsg)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $currentTimeStamp = $null; # The current time of when the message has
                                            #  been captured.
        [string] $message = $null;          # The main message that will be logged.
        [string] $messageLevel = $null;     # The level of the message 
        [string] $messageAdditional = $null;# Additional information; usually contains
                                            #  readable data from the Powershell engine.
        [string] $borderLine = $null;       # This will provide a horizontal line that
                                            #  will help separate the header and the
                                            #  message.
        [string] $finalMessage = $null;     # The final message that will be logged.
        # ----------------------------------------


        # Provide a horizontal border to separate the header and the initial message.
        $borderLine = "- - - - - - - - - - - - - - - - - - - - -";



        # - - - - - - -



        # Evaluate the information passed to this function.  If any of the values are
        #  not provided, then we will provide a default or error message instead
        #  -- must avoid blank entries in the logfile.



        # First: Message Data
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Try to fetch the initial message; the reason why for the entry to be logged.

        # There was no initial message provided
        if ("$($msg)" -eq "$($null)")
        {
            # There does not exist any message.
            $message = "<<UNKNOWN OR BLANK MESSAGE>>";
        } # If: Unknown or Blank Message

        else
        {
            # The Message was provided
            $message = $msg;
        } # Else: Message Data was Provided
        


        # - - - - - - - - - - - - - -



        # Second: Message Level
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Try to fetch the message level; the severity or what kind of message
        #  that is provided with the data.

        # The message level was not provided or is not obtainable.
        if ("$($msgLevel)" -eq "$($null)")
        {
            # The message level is unknown
            $messageLevel = "UNKNOWN";
        } # If: Unknown Message Level

        else
        {
            # The Message Level was provided
            $messageLevel = $msgLevel;
        } # Else: Message Level was Provided



        # - - - - - - - - - - - - - -



        # Third: Additional Information
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Any additional information provided; optional field.

        # No additional information provided
        if ("$($additionalMsg)" -eq "$($null)")
        {
            # No additional information was provided
            $messageAdditional = "$($null)";
        } # If: No Additional Information was Provided
        else
        {
            # There exists some additional information; format
            #  it in a way that it works in the final message form.
            $messageAdditional = "Additional Information:`r`n`t$($additionalMsg)";
        } # Else: Additional Information was Provided



        # - - - - - - - - - - - - - -



        # Fourth: Timestamp
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Get the timestamp for when the message was captured.

        # Fetch the timestamp and cache it.
        $currentTimeStamp = [Logging]::__GenerateTimestamp();



        # = = = = = = = = = = = = = =
        # - - - - - - - - - - - - - -
        # = = = = = = = = = = = = = =



        # Fifth: Final Form
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Put the message in the final form that will be in the logfile.
        $finalMessage = ("{$($currentTimeStamp)}-($($messageLevel))`r`n" + `
                        "$($borderLine)`r`n" + `
                        "$($message)`r`n" + `
                        "`r`n" + `
                        "$($messageAdditional)`r`n" + `
                        "`r`n" + `
                        "`r`n");


        # - - - -


        # Write the message to the logfile.
        return [Logging]::__WriteLogFile("$($finalMessage)");
    } # __FormatLogMessage()

    #endregion



    #region Public Functions


   <# Get Exception Information (Short)
    # -------------------------------
    # Documentation:
    #  This function provides some insight regarding an exception
    #   that occurred during an operation at runtime.  This is useful
    #   to provide the information to the user at run-time.
    # -------------------------------
    # Inputs:
    #  [Exception] Error Details
    #   The exception object that contains further information
    #    regarding the exception that was thrown.
    # -------------------------------
    # Output:
    #  [string] Exception Information
    #   Some insight information regarding the exception that was thrown.
    #
    #   ERROR VALUES
    #    null = No exception object provided or information was null.
    # -------------------------------
    #>
    static [string] GetExceptionInfoShort ([Exception] $errDetail)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $information = $null;          # This variable will contain information and data
                                                #  regarding the exception passed to this function.
        # ----------------------------------------


        # Check to make sure the exception passed to this function is not null
        if ($null -eq $errDetail)
        {
            # Because the Exception object is null, we can not extract anything from it.
            return $null;
        } # If : Exception is null

        # Generate the exception information that will be returned to the calling function.
        $information = ("Reached an exception: $($errDetail.GetType().ToString())`r`n" + `
                        "More information is provided in the program's logfile.`r`n" + `
                        "Logfile can be found in:`r`n`t$([Logging]::GetLogFilePath())");


        # Return the short details of the error
        return $information;
    } # GetExceptionInfoShort()




   <# Get Exception Information
    # -------------------------------
    # Documentation:
    #  This function provides detailed information regarding an
    #   exception that occurred during an operation at runtime.
    #   This is useful to provide the information within the
    #   program's logfile.
    # -------------------------------
    # Inputs:
    #  [Exception] Error Details
    #   The exception object that contains further information
    #    regarding the exception that was thrown.
    # -------------------------------
    # Output:
    #  [string] Exception Information
    #   Detailed information regarding the exception as a multiple line string.
    #
    #   ERROR VALUES
    #    null = No exception object provided or information was null.
    # -------------------------------
    #>
    static [string] GetExceptionInfo ([Exception] $errDetail)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $information = $null;          # This variable will contain information and data
                                                #  regarding the exception passed to this function.
        # ----------------------------------------

        # Check to make sure the exception passed to this function is not null
        if ($null -eq $errDetail)
        {
            # Because the Exception object is null, we can not extract anything from it.
            return $null;
        } # If : Exception is null

        # Generate the exception information that will be returned to the calling function.
        $information = ("`tException Reached: $($errDetail.GetType().ToString())`r`n" + `
                        "`tException Message: $($errDetail.Message.ToString())`r`n" + `
                        "`tException Source: $($errDetail.Source.ToString())`r`n" + `
                        "`tException Target Site: $($errDetail.TargetSite.ToString())`r`n" + `
                        "`tException Stack Trace:`r`n" + `
                        "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n" + `
                        "$($errDetail.StackTrace.ToString())`r`n" + `
                        "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~");


        # Return the details of the error
        return $information;
    } # GetExceptionInfo()




   <# Get Program Logfile
    # -------------------------------
    # Documentation:
    #  This function will return the program's main logfile absolute path.
    # -------------------------------
    # Output:
    #   [string] Logfile path
    #       The absolute path of the program's logfile.
    # -------------------------------
    #>
    static [string] GetLogFilePath()
    {
        return "$([Logging]::ProgramLogPath)\$([Logging]::ProgramLogFileName)";
    } # GetLogFilePath()




   <# Allow Logging
    # -------------------------------
    # Documentation:
    #  This function will provide the status if the logging functionality is
    #   currently allowed or if logging is not yet available.
    # -------------------------------
    # Output:
    #  [bool] Logging State
    #   $false = Logging is currently disabled
    #   $true = Logging is currently enabled
    # -------------------------------
    #>
    static [bool] DebugLoggingState()
    {
        return $Global:_DEBUGLOGGING_;
    } # DebugLoggingState()




   <# Thrash Logs and Reports
    # -------------------------------
    # Documentation:
    #  This function will expunge the log files that
    #   are present in directories that are managed
    #   within the class.
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
        [string[]] $extLogs     = @('*.log');   # Array of log extensions
        [bool] $exitCode        = $false;       # Provides the exit code of the operation performed
                                                #  within the function.
        [bool] $controlLockKey  = $false;       # This will help to determine the lock status; wither
                                                #  the 'Logging Lock Key' is being controlled by any of
                                                #  the outside functions.
        # ----------------------------------------


        # Determine if the logging lock key was already set by another function
        if ([Logging]::__GetLoggingLockKey())
        {
            # Another function has already placed a logging lock, do not manipulate the main lock.
            $controlLockKey = $false;
        } # if : Logging lock key controlled outside

        # The logging lock is presently not locked; this function may control it.
        else
        {
            # This function may control the logging lock.
            $controlLockKey = $true;

            # Lock the Logging functionality; this is required to avoid recursive calls.
            [Logging]::__SetLoggingLockKey($true);
        } # else : Logging lock key is controlled by this function


        # First, make sure that the directories exist.
        #  If the directories are not available, than there
        #  is nothing that can be done.
        if (([Logging]::__CheckRequiredDirectories()) -eq $false)
        {
            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            $exitCode = $false;
        } # IF : Required Directories Exists


        # Because the directories exists, lets try to thrash the log files.
        elseif (([IOCommon]::DeleteFile("$([Logging]::ProgramLogPath)", $extLogs)) -eq $false)
        {
            # Failure to remove the requested files
            $exitCode = $false;
        } # Else-If : Failure to delete Program Logs

        # The deletion operation was successful
        else
        {
            # If we made it here, then everything went okay!
            $exitCode = $true;
        } # Else : Successfully deleted the files


        # If this function is controlling the Logging Lock Key, unlock it now - before leaving.
        if($controlLockKey)
        {
            # Because this function has the Logging Lock Key controlled, unlock it now to avoid conflicts.
            #  -- NOTE: If other functions already has it set - do not touch it!
            [Logging]::__SetLoggingLockKey($false);
        } # If : This function controls the logging lock key


        return $exitCode;
    } # ThrashLogs()




   <# Display Message
    # -------------------------------
    # Documentation:
    #  This function will provide information to be
    #   displayed to the end-user while also capturing
    #   the message to a logfile.  This will help to
    #   capture all of the output that is displayed to
    #   the end-user for debugging purposes.
    # NOTE:
    #  The formatting and specifications of the message
    #   will be evaluated in the inner-specific functions
    #   that are called within this function.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that is to be presented on the screen.
    #  [LogMessageLevel] Message Level
    #   The level of the message that is to be presented
    #    or formatted.
    # -------------------------------
    #>
    static [void] DisplayMessage([string] $msg, [LogMessageLevel] $msgLevel)
    {
        # Display the message to the end-user's screen.
        [IOCommon]::WriteToBuffer("$($msg)", "$($msgLevel)");

        # Log the message to the logfile.
        [Logging]::__FormatLogMessage("$($msgLevel)", "$($msg)", "$($null)") | Out-Null;
    } # DisplayMessage()




   <# Display Message (Short-Hand\Standard MSGs)
    # -------------------------------
    # Documentation:
    #  This function is merely a quick accessor to the
    #   DisplayMessage() function for 'Standard Messages'.
    #   Because PowerShell does not allow default
    #   arguments to be set, at least at the time of
    #   writing this statement, this function will
    #   allow overflowing of the arguments.
    # NOTE:
    #  Any messages coming through this function will be
    #   treated as a Standard Message!
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that is to be presented on the screen.
    # -------------------------------
    #>
    static [void] DisplayMessage([string] $msg)
    {
        # Access the standard DisplayMessage() with MSG Level
        #  set to standard.
        [Logging]::DisplayMessage("$($msg)", "Standard");
    } # DisplayMessage()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to fetch for
    #   user-input (STDIN) and also capture the result
    #   in the logfile as well.  This will help with
    #   debugging purposes.
    # -------------------------------
    # Output:
    #  [string] User's Input Request
    #    Returns the user's request.
    # -------------------------------
    #>
    static [string] GetUserInput()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $userInput = $null;    # This will hold the user's feedback
        # ----------------------------------------


        # Fetch user input, normally.
        $userInput = [IOCommon]::FetchUserInput();

        # Provide the user's input into the logfile and record it.
        [Logging]::__FormatLogMessage(7, "$($userInput)", "$($null)") | Out-Null;

        # Return the user's request
        return "$($userInput)";
    } # GetUserInput()




   <# Log Program Activity
    # -------------------------------
    # Documentation:
    #  This function will allow provide the ability for
    #   the internal program activity to be recorded in
    #   the logfile.  Information provided here may or
    #   may not be visible to the end-user via terminal
    #   buffer, but the information can be useful for
    #   debugging and understanding what actions are
    #   taking place under the hood of the software.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The initial message that will be recorded.
    #  [string] Additional Information
    #   Additional information relating to the initial
    #    message.
    #  [LogMessageLevel] Message Level
    #   The severity or level of the message that is
    #   about to be recorded in the logfile.
    # -------------------------------
    #>
    static [void] LogProgramActivity([string] $message, `
                                    [string] $additionalInformation, `
                                    [LogMessageLevel] $messageLevel)
    {
        # Because we have the information already provided for us,
        #  we will merely pass the data to the appropriate functions
        #  to properly record it in the logfile.
        [Logging]::__FormatLogMessage($messageLevel, `
                                    "$($message)", `
                                    "$($additionalInformation)") | Out-Null;
    } # LogProgramActivity()




   <# Write To Logfile
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to write information
    #   to a specific logfile upon request, though only if logging
    #   functionality is enabled or if the logging functionality
    #   is available at the time upon request.
    # -------------------------------
    # Input:
    #  [string] File Path (Absolute Path)
    #   The absolute and complete target path of the logfile that
    #    is about to be generated.
    #  [string] (REFERENCE) Message
    #   The message or data that is going to be written to the logfile.
    # -------------------------------
    #>
    static [void] WriteToLogFile([string] $filePath, [ref] $msg)
    {
        # If the logging functionality is enabled, write the information
        #  as requested
        if ([Logging]::DebugLoggingState())
        {
            # Logging is available presently, write the file as requested.
            [IOCommon]::WriteToFile("$($filePath)", "$($msg.Value.ToString())") | Out-Null;
        } # If : Logging is enabled & available
    } # WriteToLogFile()
    #endregion
} # Logging




<# Message Level [ENUM]
 # -------------------------------
 # The level of the message that is about to be
 #  presented to the screen or how the information
 #  is to be logged for future references.
 # -------------------------------
 #>
enum LogMessageLevel
{
    Standard = 0;   # Regular messages
    Attention = 1;  # Confirmation messages
    Information = 2;# Informational messages
    Warning = 3;    # Warning messages
    Error = 4;      # Error messages
    Fatal = 5;      # Program death messages
    Verbose = 6;    # Debug or detailed messages.
    UserInput = 7;  # User Feedback\Input (STDIN\Keyboard)
} # IOCommonBufferMessageLevel