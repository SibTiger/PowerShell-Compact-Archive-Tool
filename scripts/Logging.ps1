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



    #region Display Message


   <# Display Message
    # -------------------------------
    # Documentation:
    #  This function will provide a gateway into both
    #   displaying the desired message to the user's
    #   screen and also logging the same message.
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
        # Display the message to the terminal screen
        [IOCommon]::WriteToBuffer("$($msg)", "$($msgLevel)");

        # Log the message
        [Logging]::WriteLogFile("$($msg)");
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
        [IOLoggingGateway]::DisplayMessage("$($msg)", "Standard");
    } # DisplayMessage()

    #endregion




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
    static [bool] FormatLogMessage([LogMessageLevel] $msgLevel, `
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
        $finalMessage = "{$($currentTimeStamp)}-($($messageLevel))`r`n$($borderLine)`r`n$($message)`r`n`r$($messageAdditional)`r`n`r`n";


        # - - - -


        # Write the message to the logfile.
        return [Logging]::WriteLogFile("$($finalMessage)");
    } # FormatLogMessage()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will provide a gateway into both
    #   retrieving the user's input for a desired request
    #   and also logging that request.
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
        [string] $prompt = ">>>>> ";    # The prompt message that will be
                                        #  recorded in the logfile.
        # ----------------------------------------


        # Fetch user input
        $userInput = [IOCommon]::FetchUserInput();

        # Log the user's input
        [Logging]::WriteLogFile("$($prompt)$($userInput)");

        # Return the user's request
        return "$($userInput)";
    } # GetUserInput()
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