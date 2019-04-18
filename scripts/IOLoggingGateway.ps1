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
    #  [IOCommonMessageLevel] Message Level
    #   The level of the message that is to be presented
    #    or formatted.
    # -------------------------------
    #>
    static [void] DisplayMessage([string] $msg, [IOCommonMessageLevel] $msgLevel)
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
        # ----------------------------------------

        # Fetch the data from the event object.
        $message = $eventMessageObj.MessageData;
        $sourceID = $eventMessageObj.SourceIdentifier;
        $messageLevel = $eventMessageObj.SourceArgs;

        # Put everything together in a final message form
        $finalMessage = "{$($sourceID)}-($($messageLevel))`r`n$($message)`r`n";

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