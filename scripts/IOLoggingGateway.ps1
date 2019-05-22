<# Basic IO and Logging Gateway
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the ability to send a message or capture
 #  a message through various methods in a single instance.
 #  A single instance allows the possiblity for a message to be
 #  displayed via the terminal's buffer and also to be logged,
 #  this methodolgy helps to dramatically reduce code duplication
 #  and simplifies the procedures with sending a message to the
 #  user and to record input from the user or file in a monitored
 #  environment.
 #
 # REQUIRED DEPENDENCIES:
 #  - IOCommon
 #  - Logging
 #>



 class IOLoggingGateway
 {
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




   <# Capture Log Events
    # -------------------------------
    # Documentation:
    #  This function will provide a gateway for log
    #   based messages to be properly log with its
    #   appropriate log level.
    # -------------------------------
    # Input:
    #  [PSEventArgs] Event Message Object
    #   The event object that contains the log message and other information.
    #    The archive file contents that will be extracted.
    # NOTE:
    #  SourceArguments MUST Provide The Following:
    #  - Datatype: Object[]
    #  - Index[0]: Message Level {LogMessageLevel}
    #  - Index[1]: Additional Information (Provided by the POSH Engine) {String}
    # -------------------------------
    #>
    static [void] CaptureLogEvent([System.Management.Automation.PSEventArgs] $eventMessageObj)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $message = $null;          # The main message that will be logged.
        [string] $sourceID = $null;         # The source identifer; who sent the message.
        [string] $messageLevel = $null;     # The level of the message 
        [string] $finalMessage = $null;     # The final message that will be logged.
        [string] $messageAdditional = $null;# Additional information; usually contains
                                            #  readable data from the Powershell engine.
        # ----------------------------------------


        # Evaluate the data provided from the event object.  If any of the values from
        #  the event object are not provided, including the message array, then we will
        #  provide an error or default message instead - we must try to avoid blank entries.



        # First: Source Identifier
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Try to fetch the source identifier; who or what object that sent the message.
        
        # The Source Ident. is unknown or unobtainable.
        if ("$($eventMessageObj.SourceIdentifier)" -eq "$($null)")
        {
            # The Source Ident. is unknown
            $sourceID = "SOURCE IDENTIFIER IS UNKNOWN";
        } # If: Unknown Source Identifier
        
        else
        {
            # The Source ID was provided
            $sourceID = $eventMessageObj.SourceIdentifier;
        } # Else: Source Identifier Information Provided



        # - - - - - - - - - - - - - -



        # Second: Message Data
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Try to fetch the initial message; the reason why the event was triggered.

        # There was no initial message provided
        if ("$($eventMessageObj.MessageData)" -eq "$($null)")
        {
            # There does not exist any message.
            $message = "<<UNKNOWN OR BLANK MESSAGE>>";
        } # If: Unknown or Blank Message

        else
        {
            # The Message was provided
            $message = $eventMessageObj.MessageData;
        } # Else: Message Data was Provided
        


        # - - - - - - - - - - - - - -



        # Third: Message Level
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Try to fetch the message level; the severity or what kind of message
        #  that is provided in the event object.

        # The message level was not provided or is not obtainable.
        if ("$($eventMessageObj.SourceArgs[0])" -eq "$($null)")
        {
            # The message level is unknown
            $messageLevel = "UNKNOWN";
        } # If: Unknown Message Level

        else
        {
            # The Message Level was provided
            $messageLevel = $eventMessageObj.SourceArgs[0];
        } # Else: Message Level was Provided



        # - - - - - - - - - - - - - -



        # Fourth: Additional Message Information
        # ---------------------------
        # - - - - - - - - - - - - - -
        # Any additional information provided; optional field.

        # No additional information provided
        if ("$($eventMessageObj.SourceArgs[1])" -eq "$($null)")
        {
            # No additional information was provided
            $messageAdditional = "$($null)";
        } # If: No Additional Information was Provided
        else
        {
            # There exists some additional information; format
            #  it in a way that it works in the final message form.
            $messageAdditional = "Additional Information:`r`n`t$($eventMessageObj.SourceArgs[1])`r`n";
        } # Else: Additional Information was Provided



        # = = = = = = = = = = = = = =
        # - - - - - - - - - - - - - -
        # = = = = = = = = = = = = = =



        # Now to put everything in the final form, how the message is going to presented in the logfile.
        $finalMessage = "{$($sourceID)}-($($messageLevel))`r`n$($message)`r`n$($messageAdditional)";


        # - - - -


        # Write the message to the logfile.
        [Logging]::WriteLogFile("$($finalMessage)");
    } # CaptureLogEvent()




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
 } # IOLoggingGateway




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
} # IOCommonBufferMessageLevel