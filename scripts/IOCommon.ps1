<# Common Input\Output Operations
 # ------------------------------
 # ==============================
 # ==============================
 # This function is designed to centralize common
 #  input\output and to provide minimal maintenance.
 # Functions housed in this class are based on
 #  common Input\Output tasks, such as: checking for
 #  a specific directory\file\executable, executing
 #  a specific command while providing return code,
 #  executing a specific command to return a literal
 #  string, browsing for specific directory, and
 #  much more.
 #>




class IOCommon
{
    # Member Variables :: Properties
    # =================================================
    # =================================================
    hidden static [string] $eventNameLog = "EventLog_IOCommon";



    # Constructor and Internal Functions
    # =================================================
    # =================================================


    # Default Constructor
    IOCommon()
    {
        # Register logging events
        [IOCommon]::RegisterEventLogging("IOCommon", "$([IOCommon]::eventNameLog)") | Out-Null;
    } # Default Constructor



    <# Destroy (Destructor)
    # -------------------------------
    # Documentation:
    #  This function will remove, unregister, or destroy
    #   any open instances that is associated with this class.
    #
    # NOTE:
    #  PowerShell does not have any support for Destructors
    #   (Unless I missed it by mistake?).  Instead, this function
    #   will do what the destructor is supposed to do - though
    #   this requires that the owner of this object to call this
    #   particular function.  Failure to call this function can result
    #   in zombie-hanging instances or instances that are just generally
    #   remaining open to the system or the PowerShell engine (if the shell
    #   has not been terminated).
    # -------------------------------
    #>
    [void] Destroy()
    {
        [IOCommon]::UnregisterEvent("IOCommon", "$([IOCommon]::eventNameLog)") | Out-Null;
    } # Destroy()



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region User Input Functions


   <# Fetch User Input
    # -------------------------------
    # Documentation:
    #  This function will fetch input provided by the
    #   the user using STDIN (keyboard).
    #  This function will display a prompt that is
    #   adjacent to Python's prompt.  I prefer this
    #   prompt style as it is clear that the program
    #   is waiting for some sort of feedback from the
    #   user.  If the program is not clear when it is
    #   ready for feedback from the user - yet the
    #   program is in a block state because it is
    #   waiting for user feedback, the user will
    #   believe that the program is broken\frozen and
    #   the user will exit the program.  Because of
    #   this, I believe that it is important to have
    #   a clear indication when the program is waiting
    #   for feedback from the user.
    # -------------------------------
    # Output:
    #  [string] User's Input Request
    #    Returns the user's request.
    # -------------------------------
    #>
    static [string] FetchUserInput()
    {
        # Because I love Python's input prompt, we will emulate it here.
        #  I find this to be easier on the user to unify an action from the end-user.
        Write-Host ">>>>> " -NoNewline;

        # Get input from the user.
        [string] $stdInput = (Get-Host).UI.ReadLine();

        # Return the value as a string
        return [string]$stdInput;
    } # FetchUserInput()

    #endregion


    #region Write-to-Buffer Functions


   <# Write to Buffer (Terminal Screen)
    # -------------------------------
    # Documentation:
    #  This function will present the requested message
    #   on the screen with its appropriate formatting,
    #   determined by its message level (or logged level).
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that is to be presented on the screen.
    #  [LogMessageLevel] Message Level
    #   The level of the message that is to be presented
    #    or formatted.
    # -------------------------------
    #>
    static [void] WriteToBuffer([string] $msg, [LogMessageLevel] $msgLevel)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $textColourBackground = $null; # Text background color
        [string] $textColourForeground = $null; # Text foreground color
        # ----------------------------------------

        # Determine the level of the message; text presentation
        switch ($msgLevel)
        {
            # Regular or standard messages
            "Standard"
            {
                # Text Colour
                $textColourForeground = "White";

                # Text Background Colour
                $textColourBackground = "Black";
            } # Standard MSG


            # Confirmation messages
            "Attention"
            {
                # Text Colour
                $textColourForeground = "Black";

                # Text Background Colour
                $textColourBackground = "White";
            } # Confirmation MSG

            
            # Informational messages
            "Information"
            {
                # Text Colour
                $textColourForeground = "DarkGray";

                # Text Background Colour
                $textColourBackground = "Black";
            } # Information MSG


            # Warning messages
            "Warning"
            {
                # Text Colour
                $textColourForeground = "Cyan";

                # Text Background Colour
                $textColourBackground = "Black";
            } # Warning MSG


            # Error messages
            "Error"
            {
                # Text Colour
                $textColourForeground = "Red";

                # Text Background Colour
                $textColourBackground = "Black";
            } # Error MSG


            # Critical error or very fatal messages
            "Fatal"
            {
                # Text Colour
                $textColourForeground = "White";

                # Text Background Colour
                $textColourBackground = "Red";
            } # Fatal MSG


            # Verbose or debug messages
            "Verbose"
            {
                # Text Colour
                $textColourForeground = "White";

                # Text Background Colour
                $textColourBackground = "DarkBlue";
            } # Verbose MSG


            # Default (Level not registered or recognized)
            Default
            {
                # Text Colour
                $textColourForeground = "White";

                # Text Background Colour
                $textColourBackground = $null;
            } # Default
        } # switch


        # Display the message with the formatting specified
        # If there is no background specified, then do not use the background parameter.
        if ("$($textColourBackground)" -eq "$($null)")
        {
            Write-Host -Object $msg -ForegroundColor $textColourForeground;
        } # if : No Text Background

        # Background was specified
        else
        {
            Write-Host -Object $msg -ForegroundColor $textColourForeground -BackgroundColor $textColourBackground;
        } # else : Text Background
    } # WriteToBuffer

    #endregion


    #region External Command Functions

   <# Detect Command [Test]
    # -------------------------------
    # Documentation:
    #  This function will help to test if the executable could
    #   run successfully.  This can be helpful to determine if
    #   the program can detect the executable or if the executable
    #   is usable.  This function is merely for testing if the
    #   external software will run properly, do not use this
    #   function for major operations.
    # -------------------------------
    # Inputs:
    #  [string] Command
    #   The external executable to run by request.
    #  [string] Type
    #   The type of command that will be executed.
    #    See Get-Command "CommandType"
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-command
    # -------------------------------
    # Output:
    #  [bool] Detected Code
    #    $false = Failure to detect the external executable.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    static [bool] DetectCommand([string] $command, [string] $type)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $eventLogMessage = $null;  # Message that will be sent to the program's log.
        [bool] $exitCode = $false;          # The detection code that will be returned based
                                            #  on the results; if the command was found or not.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [LogMessageLevel] $logMSGLevel = "Verbose";    # The logged message level
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------

        # Try to detect the requested command
        if ((Get-Command -Name "$($command)" -CommandType $($type) -ErrorAction SilentlyContinue) -eq $null)
        {
            # Command was not detected.
            $exitCode = $false;
        } # If : Command Not Detected

        else
        {
            # Command was detected.
            $exitCode = $true;
        } # Else : Command Detected

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        # --------------

        # Capture any additional information
        $logAdditionalInfo = "$($_)";

        # Put the arguments together in a package
        $logEventArguments[0] = "$($logMSGLevel)";
        $logEventArguments[1] = "$($logAdditionalInfo)";

        # Send an event regarding the status of the operation's results; this will be logged.
        $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                          -MessageData "Tried to find the $($type) named $($command); detected result was $($exitCode)" `
                          -EventArguments $logEventArguments | Out-Null;

        # * * * * * * * * * * * * * * * * * * *

        # Return the results
        return $exitCode;
    } # DetectCommand()




   <# Execute Command
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to execute the
    #   requested external command and help to manage how the
    #   logging or redirection of output should be handled.
    #  This function will use several functions in order to
    #   preform the operation, this function is made to help
    #   simplify the operation and keep data organized
    #   efficiently.
    #
    #  Return Code Notes: After the command has been executed,
    #   this function will only return the exit code provided
    #   by the executable.  If the external executable can not
    #   be found or generally fails to execute in vague reasons,
    #   this function will return a specific error code that is
    #   dedicated by this function.
    # -------------------------------
    # Inputs:
    #  [string] Command
    #   The external executable to run by request.
    #  [string] Arguments
    #   Arguments to be used when executing the binary.
    #  [string] Project Path
    #   The absolute path of the project directory.
    #  [string] STDOUT Log Path
    #   Absolute path to store the log file containing
    #    the program's STDOUT output.
    #   - NOTE: Filename is provided by this function.
    #  [string] STDERR Log Path
    #   Absolute path to store the log file containing
    #    the program's STDERR output.
    #   - NOTE: Filename is provided by this function.
    #  [string] Report Path
    #   Absolute path and filename to store the report file.
    #   - NOTE: Filename MUST BE INCLUDED!
    #  [string] Description
    #   Used for logging and for information purposes only.
    #  [bool] Logging
    #   User's request to log
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.
    #  [string] (REFERENCE) stringOutput
    #   When Capture STDOUT is true, this parameter will
    #   carry the STDOUT from the executable.  The
    #   information provided will be available for use
    #   from the calling function.
    # -------------------------------
    # Output:
    #  [int] Exit Code
    #   The error code provided from the executable.
    #   This can be helpful to diagnose if the external command
    #    reached an error or was successful.
    #   ERROR VALUES
    #   -255
    #    The executable could not execute; may not exist.
    #
    #   -254
    #    Command was not detected.
    #
    #   -253
    #    Project Path was not detected.
    #
    #   -252
    #    Standard Out Path was not detected.
    #
    #   -251
    #    Standard Error Path was not detected.
    # -------------------------------
    #>
    static [int] ExecuteCommand([string] $command, `
                        [string] $arguments, `
                        [string] $projectPath, `
                        [string] $stdOutLogPath, `
                        [string] $stdErrLogPath, `
                        [string] $reportPath, `
                        [string] $description, `
                        [bool] $logging, `
                        [bool] $isReport, `
                        [bool] $captureSTDOUT, `
                        [ref] $stringOutput)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $containerStdOut = $null;        # Used to hold the STDOUT
        [string] $containerStdErr = $null;        # Used to hold the STDERR
        [int] $externalCommandReturnCode = $null; # Exit Code from the extCMD.
        [string] $callBack = $null;               # Allocate memory address if the stdout
                                                  #  needs to be relocated, this is our
                                                  #  medium in order to accomplish this.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the executable exists before trying to use it.
        if ($([IOCommon]::DetectCommand("$($command)", "Application")) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tReason to use command: $($description)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Failed to execute the external command $($command) because it was not found or is not an application!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Executable was not detected.
            return -254;
        } # if : Executable was not detected


        # Make sure that the Project path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)")) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tReason to use command: $($description)`r`n`tProject Path: $($projectPath)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Failed to execute the external command $($command) because the project path does not exist!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Project Path does not exist, return an error.
            return -253;
        } # if : The Project Path does not exist


        # Make sure that the Standard Output Path exists
        if ($([IOCommon]::CheckPathExists("$($stdOutLogPath)")) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tReason to use command: $($description)`r`n`tSTDOUT Directory: $($stdOutLogPath)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Failed to execute the external command $($command) because the STDOUT Directory does not exist!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Standard Output Path does not exist, return an error.
            return -252;
        } # if : The Standard Output Path does not exist


        # Make sure that the Standard Error path exists
        if ($([IOCommon]::CheckPathExists("$($stdErrLogPath)")) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tReason to use command: $($description)`r`n`tSTDERR Directory: $($stdErrLogPath)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Failed to execute the external command $($command) because the STDERR Directory does not exist!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Standard Error Path does not exist, return an error.
            return -251;
        } # if : The Standard Error Path does not exist


        # Make sure that the description field actually has something
        #  meaningful, if not (by mistake) - use the executable and args
        #  as the description.
        if (("$($description)" -eq "") -or ("$($description)" -eq $null))
        {
            # NOTE: Worst case scenario, we potentially break the filesystem
            #  by either: using illegal characters or long chars.
            #  To avoid this from happening, please use a valid description!
            $description = "$($command) $($arguments)";

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Warning";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tDescription is now: $($description)";

            # Send an event regarding this change; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "The description field was missing while serving the request to execute the external command $($command)!  The description will be automatically filled for this instance." `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *
        } # if : Description was not populated

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the Command
        $externalCommandReturnCode = [IOCommon]::__ExecuteCommandRun($command, `
                                                       $arguments, `
                                                       $projectPath, `
                                                       [ref] $containerStdOut, `
                                                       [ref] $containerStdErr)


        # Create the necessary logfiles or capture a specific input
        [IOCommon]::__ExecuteCommandLog($stdOutLogPath, `
                                $stdErrLogPath, `
                                $reportPath, `
                                $logging, `
                                $isReport, `
                                $captureSTDOUT, `
                                $description, `
                                [ref] $callBack, `
                                [ref] $containerStdOut, `
                                [ref] $containerStdErr)


        # Do we need to copy the STDOUT to the pointer?
        #  Used if wanting the extCMD output in a function.
        if ($captureSTDOUT -eq $true)
        {
            # Copy the stdout to pointer
            $stringOutput.Value = $callBack;
        } # If : Redirect STDOUT to Pointer


        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        # --------------

        # Put the arguments together in a package
        $logEventArguments[0] = "Verbose";
        $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tReason to use command: $($description)`r`n`tExtCMD Exit Code: $($externalCommandReturnCode)";

        # Send an event regarding the status of the operation's results; this will be logged.
        $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                            -MessageData "Successfully executed the external command $($command)!" `
                            -EventArguments $logEventArguments | Out-Null;

        # * * * * * * * * * * * * * * * * * * *

        # Return the ExtCMD's exit code
        return $externalCommandReturnCode;
    } # ExecuteCommand()




   <# Execute Command - Logging
    # -------------------------------
    # Documentation:
    #  This function will take the outputs provided by the
    #   extCMD and place them in logfiles or redirect the
    #   output to a specific reference variable upon request.
    # -------------------------------
    # Inputs:
    #  [string] STDOUT Log Path
    #   Absolute path to store the log file containing
    #    the program's STDOUT output.
    #   - NOTE: Filename is provided by this function.
    #  [string] STDERR Log Path
    #   Absolute path to store the log file containing
    #    the program's STDERR output.
    #   - NOTE: Filename is provided by this function.
    #  [string] Report Path
    #   Absolute path and filename to store the report file.
    #   - NOTE: Filename MUST BE INCLUDED!
    #  [bool] Logging
    #   User's request to log
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.
    #  [string] Description
    #   Used for logging and for information purposes only.
    #  [ref] {string} Output String
    #   When Capture STDOUT is true, this parameter will
    #    carry the STDOUT from the executable.  The
    #    information provided will be available for use
    #    from the calling function.
    #  [ref] {string} Output Result STDOUT
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [ref] {string} Output Result STDERR
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    # -------------------------------
    #>
    Static Hidden [void] __ExecuteCommandLog([string] $stdOutLogPath, `
                                    [string] $stdErrLogPath, `
                                    [string] $reportPath, `
                                    [bool] $logging, `
                                    [bool] $isReport, `
                                    [bool] $captureSTDOUT, `
                                    [string] $description, `
                                    [ref] $stringOutput, `
                                    [ref] $outputResultOut, `
                                    [ref] $outputResultErr)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $logTime        = $(Get-Date -UFormat "%d-%b-%y %H.%M.%S");             # Capture the current date and time.
        [string] $logStdErr      = "$($stdErrLogPath)\$($logTime)-$($description).err";  # Log file: Standard Error
        [string] $logStdOut      = "$($stdOutLogPath)\$($logTime)-$($description).out";  # Log file: Standard Output
        [string] $fileOutput     = if ($isReport -eq $true)                              # Check if the output is a log or a report.
                                   {"$($reportPath)"} else {"$($LogStdOut)"};
        [string] $redirectStdOut = $null;                   # When STDOUT redirection to variable is
                                                            #  requested, this will be our buffer.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------

        
        # Standard Output
        # -------------------
        # +++++++++++++++++++


        # Is there any data in the STDOUT?
        #  If so, we can continue to evaluate it.  Otherwise, skip over.
        if ("$($outputResultOut.Value)" -ne "")
        {
            # Should we store the STDOUT to a variable?
            if ($captureSTDOUT -eq $true)
            {
                # Because we need a memory-address, we will store the contents in a
                #  temporarily variable.  After that, store the value to the pointer.
                $redirectStdOut = $outputResultOut.Value;


                # Now store the information to the pointer; which can be used from
                #  the calling function.
                $stringOutput.Value = $redirectStdOut;
            } # If : Stored in Reference Var.


            # Should we store the STDOUT to a report file?
            ElseIf ($isReport -eq $true)
            {
                # Write the data to the report file.
                [IOCommon]::WriteToFile("$($reportPath)", "$($outputResultOut.Value)") | Out-Null;
            } # If : Generating a Report


            # Store the STDOUT in a file?
            ElseIf ($logging -eq $true)
            {
                # Store the information to a text file.
                [IOCommon]::WriteToFile("$($logStdOut)", "$($outputResultOut.Value)") | Out-Null;
            } # Else : Stored in a specific file


            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Verbose";
            $logEventArguments[1] = "Description: $($description)`r`n`tSTDOUT Log Path: $($logStdOut)`r`n`tSTDOUT Output:`r`n`t$($outputResultOut.Value)";

            # Send an event regarding the status of the operation's results; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "External command returned successfully with additional output." `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

        } # If : STDOUT contains data
        


        # Standard Error
        # -------------------
        # +++++++++++++++++++


        # Store the STDERR in a logfile and is there data?
        If (($logging -eq $true) -and ("$($outputResultErr.Value)" -ne ""))
        {
            # Write the STDERR to a file
            [IOCommon]::WriteToFile("$($logStdErr)", "$($outputResultErr.Value)") | Out-Null;


            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Warning";
            $logEventArguments[1] = "Description: $($description)`r`n`tSTDERR Log Path: $($logStdErr)`r`n`tSTDERR Output:`r`n`t$($outputResultErr.Value)";

            # Send an event regarding the status of the operation's results; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "External command returned with an error or error messages exists!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *
        } # If : Log the STDERR
    } # ExecuteCommandLog()




   <# Execute Command - Run [Using .NET API]
    # -------------------------------
    # Documentation:
    #  This function will allow a specific executable to run
    #   with the required parameters.
    #
    #  Return Code Notes: After the command has been executed,
    #   this function will only return the exit code provided
    #   by the executable.  If the external executable can not
    #   be found or generally fails to execute in vague reasons,
    #   this function will return a specific error code that is
    #   dedicated by this function.
    # -------------------------------
    # Inputs:
    #  [string] Command
    #   The external executable to run by request.
    #  [string] Arguments
    #   Arguments to be used when executing the binary.
    #  [string] Project Path
    #   The absolute path of the project directory.
    #  [ref] {string} STDOUT Container
    #   Placeholder for the STDOUT information
    #    provided by the extCMD.
    #  [ref] {string} STDERR Container
    #   Placeholder for the STDERR information
    #    provided by the extCMD.
    # -------------------------------
    # Output:
    #  [int] Exit Code
    #   The error code provided from the executable.
    #   This can be helpful to diagnose if the external command
    #    reached an error or was successful.
    #   ERROR VALUES
    #   -255
    #    The executable could not execute; may not exist.
    #   -254
    #    Command was not detected.
    # -------------------------------
    #>
    Static Hidden [int] __ExecuteCommandRun([string] $command, `
                                    [string] $arguments, `
                                    [string] $projectPath, `
                                    [ref] $captureStdOut, `
                                    [ref] $captureStdErr)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # - - - - - - - - - - - - - - - - - - - -
        # .NET Special Objects
        # - - - -
        # Because Start-Process CMDLet does NOT redirect to a variable, but only to files.
        #  instead, we will use the 'ProcessStartInfo' class.
        #  Helpful Resources
        #  Stackoverflow Help:
        #   https://stackoverflow.com/a/24227234
        #  ProcessStartInfo Help:
        #   https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo
        [System.Diagnostics.ProcessStartInfo] $processInfo = `              # Instantiate Process Start Info Obj.
                            [System.Diagnostics.ProcessStartInfo]::new();
        [System.Diagnostics.Process] $processExec = `                       # Instantiate Process Obj.
                            [System.Diagnostics.Process]::new();

        # Redirection Standard Out (Asynchronous)
        $asyncStdOut = New-Object -TypeName System.Runtime.CompilerServices.AsyncTaskMethodBuilder

        # Redirection Standard Error (Asynchronous)
        $asyncStdErr = New-Object -TypeName System.Runtime.CompilerServices.AsyncTaskMethodBuilder
        # ----------------------------------------


        # Check to see if the external command exists; if not - leave this function immediately.
        if(([IOCommon]::DetectCommand("$($command)", "Application")) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Failed to execute the external command $($command) because it was not found or is not an application!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            return -254;
        } # If : Command does not exist


        # Setup the ProcessStartInfo Obj.
        $processInfo.FileName = "$($command)";             # Executable
        $processInfo.Arguments = "$($arguments)";          # Argument(s)
        $processInfo.RedirectStandardOutput = $true;       # Maintain STDOUT
        $processInfo.RedirectStandardError = $true;        # Maintain STDERR
        $processInfo.UseShellExecute = $false;             # Use the shell
        $processInfo.CreateNoWindow = $true;               # Use the current console
        $processInfo.WorkingDirectory = "$($projectPath)"; # Execute in the Working Dir.


        # Setup the Process Obj.
        $processExec.StartInfo = $processInfo;             # Instantiate the Process object.


        # Execute the command
        try
        {
            # Start the process; do not output anything.
            $processExec.Start() | Out-Null;

            # Prevent a Deadlock from occurring by capturing
            #  the output and immediately cache before the
            #  buffer is full, once the buffer is full
            #  (which is a few Kilobytes) - a deadlock will
            #  occur.  Once a deadlock has occurred, nothing
            #  more can be done -- the shell itself MUST be
            #  forcefully terminated.
            # Resources that helped on resolving this issue:
            # >> https://stackoverflow.com/a/36539747
            # >> https://stackoverflow.com/a/36539226
            # -------
            # Standard Out (Asynchronous)
            $asyncStdOut = $processExec.StandardOutput.ReadToEndAsync()

            # Standard Error (Asynchronous)
            $asyncStdErr = $processExec.StandardError.ReadToEndAsync()
            # -------

            # Wait for the program to finish.
            $processExec.WaitForExit();
        } # Try : Executing command

        # An error occurred while trying to execute the command
        catch
        {
            # Immediately cache the reason why the command failed.
            $executeFailureMessage = "$($_)";

            # The command failed to be executed
            [IOLoggingGateway]::DisplayMessage("Failure to execute command upon request!`n`rFailure reason: $($executeFailureMessage)", "Error");

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Command to execute: $($command)`r`n`tArguments to be used: $($arguments)`r`n`tFailed to execute reason: $($executeFailureMessage)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "A failure occurred upon executing the external command $($command)!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Return an error
            return -255;
        } # Catch : Failed Executing Command


        # Capture the Output (STDOUT && STDERR)
        $captureStdErr.Value = $asyncStdErr.Result; # STDERR
        $captureStdOut.Value = $asyncStdOut.Result; # STDOUT


        # Return the result
        return $processExec.ExitCode;
    } # ExecuteCommandRun()




   <# PowerShell CMDLet - Logging
    # -------------------------------
    # Documentation:
    #  This function will take the outputs provided by the
    #   PowerShell's CMDLets and either place the data in
    #   the respected logfiles or redirect the output to
    #   a specific reference variable upon request.
    # -------------------------------
    # Inputs:
    #  [string] STDOUT Log Path
    #   Absolute path to store the log file containing
    #    the CMDLet's STDOUT output.
    #   - NOTE: Filename is provided by this function.
    #  [string] STDERR Log Path
    #   Absolute path to store the log file containing
    #    the CMDLet's STDERR output.
    #   - NOTE: Filename is provided by this function.
    #  [string] Report Path
    #   Absolute path and filename to store the report file.
    #   - NOTE: Filename MUST BE INCLUDED!
    #  [bool] Logging
    #   User's request to log
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.
    #  [string] Description
    #   Used for logging and for information purposes only.
    #  [ref] {string} Output String
    #   When Capture STDOUT is true, this parameter will
    #    carry the STDOUT from the executable.  The
    #    information provided will be available for use
    #    from the calling function.
    #  [ref] {string} Output Result STDOUT
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [ref] {string} Output Result STDERR
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    # -------------------------------
    #>
    static [void] PSCMDLetLogging([string] $stdOutLogPath, `
                        [string] $stdErrLogPath, `
                        [string] $reportPath, `
                        [bool] $logging, `
                        [bool] $isReport, `
                        [bool] $captureSTDOUT, `
                        [string] $description, `
                        [ref] $stringOutput, `
                        [ref] $outputResultOut, `
                        [ref] $outputResultErr)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $callBack = $null;                          # Allocate memory address if the stdout
                                                             #  needs to be relocated, this is our
                                                             #  medium in order to accomplish this.
        [string] $cacheSTDOUT = "$($outputResultOut.Value)"; # Cache the STDOUT; because it is a
                                                             #  pointer - we can not directly use
                                                             #  it as a pointer in another function
                                                             #  call (At least in PowerShell).
        [string] $cacheSTDERR = "$($outputResultErr.Value)"; # Cache the STDERR; because it is a
                                                             #  pointer - we can not directly use
                                                             #  it as a pointer in another function
                                                             #  call (At least in PowerShell).
        # ----------------------------------------

        # We will use the function named '__ExecuteCommandLog()'
        #  because the functionality already exists and works as
        #  intended.  Instead of simply just copying and pasting
        #  the same code, we will merely use the function.
        [IOCommon]::__ExecuteCommandLog($stdOutLogPath, `
                                $stdErrLogPath, `
                                $reportPath, `
                                $logging, `
                                $isReport, `
                                $captureSTDOUT, `
                                $description, `
                                [ref] $callBack, `
                                [ref] $cacheSTDOUT, `
                                [ref] $cacheSTDERR);

        # Are we redirecting the output?
        if ($captureSTDOUT -eq $true)
        {
            # Redirect the output by saving the callback value.
            $stringOutput.Value = $callBack;
        } # if : Redirecting the output
    } # PSCMDLetLogging()

    #endregion
    

    #region Writing File Functions

   <# Write to File
    # -------------------------------
    # Documentation:
    #  This function will write contents to a
    #  specific file.
    #
    #  NOTE: The encoding will be set as Default.
    #   Default, at the time of writing this, is
    #   Unicode.
    # -------------------------------
    # Input:
    #  [string] File
    #   The file to be written.
    #  [ref] Contents
    #   The information (or data) that is to be
    #   written to a file.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure to create and\or write to file.
    #    $true = Successfully wrote to the file.
    # -------------------------------
    #>
    static [bool] WriteToFile([string] $file, [ref] $contents)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # Try to write contents to the file.
        try
        {
            # Try to write the information to the file
            Out-File -LiteralPath "$($file)" `
                     -Encoding default `
                     -InputObject "$($contents.Value.ToString())" `
                     -NoClobber `
                     -Append;
        } # Try : Write to file

        catch
        {
            # Immediately cache the reason why the command failed.
            $executeFailureMessage = "$($_)";

            # Display error to the user
            [IOLoggingGateway]::DisplayMessage("Failed to write data to file!`r`nFailure reason: $($executeFailureMessage)", "Error");

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "File to write: $($file)`r`n`tContents to write: $($contents.Value.ToString())`r`n`tFailed to execute reason: $($executeFailureMessage)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "A failure has occurred upon writing data to file!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Operation failed
            return $false;
        } # Catch : Failure to write


        # Assurance Fail-Safe; make sure that the file
        #  was successfully created on the filesystem.
        if ([IOCommon]::CheckPathExists("$($file)") -eq $false)
        {
            # Operation failed because the file does not
            #  exist on the secondary storage.
            return $false;
        } # if : file didn't exist (after write)


        # Operation was successful
        return $true;
    } # WriteToFile()




   <# Create a Protable Document File (PDF)
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to
    #   create a PDF file by taking the existing
    #   text-document as the main source, the
    #   output file that will be generated - is
    #   the PDF file.
    #
    #  NOTE: This function requires Microsoft Word
    #         to be installed on the host-system.
    #
    #  DEV.NOTE: iTextSharp is possible to use
    #         instead of MSWord, but you'll need
    #         to use 3rd party API's.  You are
    #         free to use it, if necessary.
    #         Please be sure to keep licensing
    #         in mind when implementing that
    #         dependency.
    #
    #  Resources:
    #   This help greatly with how to implement
    #    feature.
    #   - https://stackoverflow.com/a/23894977
    #   Microsoft Word API Commands
    #   - https://docs.microsoft.com/en-us/office/vba/api/word.application
    # -------------------------------
    # Input:
    #  [string] Source File
    #   The source text document that will be
    #    reflected to the PDF file.
    #  [string] Destination File
    #   The destination path and filename of the
    #    PDF file.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure to create the PDF file.
    #    $true = Successfully created the PDF file.
    # -------------------------------
    #>
    Static [bool] CreatePDFFile([string] $sourceFile, [string] $destinationFile)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [float] $wordVersion = 0.0;         # Microsoft Word Version
                                            #  May not be needed, but in case
                                            #  differences between versions
                                            #  causes problems, we can try to
                                            #  deter that from happening.
        [string] $txtContent = $null;       # This will hold the source text
                                            #  file's contents.
        [int] $wordPDFCode = 17;            # The code to export a document in
                                            #  PDF format.
            # https://docs.microsoft.com/en-us/office/vba/api/word.wdexportformat
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Check to make sure that the source file actually exists.
        if ([IOCommon]::CheckPathExists("$($sourceFile)") -eq $false)
        {
            # Display error to the user
            [IOLoggingGateway]::DisplayMessage("Unable to create a PDF file; source file does not exist!`r`nSource file: $($sourceFile)", "Error");

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Source file: $($sourceFile)`r`n`tDestination file: $($destinationFile)";
            #File to write: $($file)`r`n`tContents to write: $($contents.Value.ToString())`r`n`tFailed to execute reason: $($executeFailureMessage)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "Unable to create a PDF file as the source file does not exist!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # The source file does not exist.
            return $false;
        } # if : source file didn't exist
        
        # ---------------------------
        # - - - - - - - - - - - - - -


        # Detect Microsoft Word
        # -------------------
        # +++++++++++++++++++


        # First try to see if the user has Microsoft Word installed,
        #  if so, we can proceed through the rest of this function,
        #  otherwise - immediately stop.
        if ($(Test-Path HKLM:SOFTWARE\Classes\Word.Application) -eq $true)
        {
            # Microsoft Word was detected; try to create a new instance
            #  of the process.
            try
            {
                # Try to create the object instance
                [System.__ComObject]$msWord = New-Object -ComObject Word.Application;
            } # Try : Create MS Word Instance

            catch
            {
                # The host system may not have Microsoft Word ready to be
                #  use or has a Microsoft Word version that is not
                #  compatible with PowerShell integration.

                # Immediately cache the reason why the command failed.
                $executeFailureMessage = "$($_)";

                # Provide the error message to the user
                [IOLoggingGateway]::DisplayMessage("Unable to create a new instance of Microsoft Word.");

                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Put the arguments together in a package
                $logEventArguments[0] = "Error";
                $logEventArguments[1] = "Unable to create a new instance of Microsoft Word.`r`n`tSource File: $($sourceFile)`r`n`tAdditional Error Message: $($executeFailureMessage)";

                # Send an event regarding this failure; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                  -MessageData "Unable to create a new instance of Microsoft Word." `
                                  -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *

                return $false;
            } # Catch : Failure to create MS Word Instance
        } # If : Microsoft Word Installed \ Ready

        # Microsoft Word was not detected or is not compatible with PowerShell
        #  integration.
        else
        {
                # Immediately cache the reason why the command failed.
                $executeFailureMessage = "$($_)";

                # Provide the error message to the user
                [IOLoggingGateway]::DisplayMessage("Unable to find a modern version Microsoft Word; unable to create a PDF.");


                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Put the arguments together in a package
                $logEventArguments[0] = "Error";
                $logEventArguments[1] = "The host system does not have (or unable to detect) a modern version of Microsoft Word.`r`n`tSource File: $($sourceFile)`r`n`tAdditional Error Message: $($executeFailureMessage)";

                # Send an event regarding this failure; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                  -MessageData "Unable to find a modern version of Microsoft Word!" `
                                  -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *
            return $false;
        } # Else : Failure to find Microsoft Word



        # Setup the Environment
        # -------------------
        # +++++++++++++++++++


        # Get the version of MS Word.
        $wordVersion = $msWord.Version;


        # Hide the instance; user does not need to see it.
        $msWord.Visible = $false;



        # Setup the Document
        # -------------------
        # +++++++++++++++++++


        # Dev. Notes:
        #    Caching the data to a string (Document.TypeText) is far too taxing and
        #    causes more problems while solving - bare minimum.
        #     > Not ALL of the document will be cached, if the file is too big - contents
        #       will be missing from the TypeText.
        #     > New Lines are not appended to the document, unless 'Get-Content -Raw' is
        #       used.
        #     > Font properties must be adjusted.
        #    It is far better to open the existing document and work with that directly.

        # Open the document directly.
        $wordDocument = $msWord.Documents.Open("$($sourceFile)");

        

        # Resource to change the document's orientation to Landscape.
        #  > https://blogs.technet.microsoft.com/heyscriptingguy/2006/08/31/how-can-i-set-the-document-orientation-in-microsoft-word-to-landscape/
        
        # Set the document's orientation to 'Landscape'.
        $wordDocument.PageSetup.Orientation = 1;



        # Export the Document
        # -------------------
        # +++++++++++++++++++


        # Export the document
        $wordDocument.ExportAsFixedFormat($destinationFile, $wordPDFCode);
        


        # Finishing Up
        # -------------------
        # +++++++++++++++++++


        # Close the document without saving the document.
        $wordDocument.Close(0);


        # Destroy the Word instance cleanly
        $msWord.Quit();



        # Finalizing
        # -------------------
        # +++++++++++++++++++


        # Check to make sure that the PDF file was saved properly.
        if ([IOCommon]::CheckPathExists("$($destinationFile)") -eq $false)
        {
            # Display error to the user
            [IOLoggingGateway]::DisplayMessage("Created a PDF file as requested but unable find it....")

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Source file: $($sourceFile)`r`n`tDestination file: $($destinationFile)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "The PDF file was created successfully but unable to find the PDF file at the destination path!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # The PDF file was not found
            return $false;
        } # if : file didn't exist


        # Successfully created the document
        return $true;
    } # CreatePDFFile()

    #endregion


    #region Directory and File Management Functions

   <# Create Temporary Directory (Roaming Profile)
    # -------------------------------
    # Documentation:
    #  This function will assist in trying to create
    #   a temporary directory in the user's roaming
    #   profile region.  With using a temporary directory,
    #   we can be able to momentarily house within the
    #   directory for the required operations.  After the
    #   operation has been successfully completed, ideally
    #   - we can then discard the data.  Remember, the
    #   data here is temporary and will be thrashed by
    #   either this program or Windows cleanmgr or whatever
    #   the Metro variant is now.
    #
    # Directory Naming Scheme Note:
    #  The directory must be unique, we can NEVER have
    #   duplicated directories to assure that the data
    #   is correct.  With that in mind, we will have
    #   to think future and past tenses.  Meaning, we
    #   will need to assert the 'What-If' card.
    #    What-If:
    #     - The user added a directory that has the EXACT
    #        same name as to what we are going to add?
    #     - The user reconfigures the System Time and
    #        System Date (rolling back in time), we are
    #        trying to create a directory that has the EXACT
    #        same name (combined with date and time).
    #     - The System Time and System Date is stalled,
    #        time and the date never changes.  Yes, this is
    #        purgatory and has never really happened
    #        (because the System Board would be severally
    #         damaged as the crystal timer that organizes the
    #         time in between IO would corrupt the machine
    #         beyond the state of repair.)
    #        but we must think of this case as it is still
    #        possible to occur -- we must think of all possible
    #        cases.
    #     - The System Date and System Time configured by the
    #        user originally was changed when the time and date
    #        was syncronized by the remote server, with that
    #        change - the directory contains the EXACT same
    #        name (combined with date and time). 
    #     - I'm probably thinking too much?
    #   But with this in mind, we must assure that the directory
    #   name is unique at all costs.
    #
    # Directory Naming Scheme:
    #  GENERAL FORM:
    #   [NOUN|VERB].[DATE:DD-MMM-YY].[TIME:HH-MM-SS](.[REPETITION_KEY])
    #  EXAMPLE
    #    Extracting.1-Jan-18.01-00-00
    #   OR (if that directory already exists):
    #    Extracting.1-Jan-18.01-00-00.1
    #
    # 
    # NOTE: This region is classified as 'Program Data'.
    # -------------------------------
    # Input:
    #  [string] Noun or Verb Key Term
    #   This will be included in the directory's name.
    #    This is only useful for debugging, nothing more.
    #  [ref] {STRING} Newly Created Directory's Absolute Path
    #   This will contain the newly created directory's
    #    absolute path.  This will be returned along with the
    #    function's status code.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure to create the directory.
    #    $true = Successfully created the directory.
    # -------------------------------
    #>
    static [bool] MakeTempDirectory([string] $keyTerm, [ref] $directoryPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $tempDirectoryPath = $null;   # Absolute Path of the Temporary directory.
        [string] $tempDirectoryName = $null;   # The name of the directory that we going
                                               #  to create.
        [string] $finalDirectoryPath = $null;  # This will hold the absolute path to the
                                               #  new requested directory.
        [string] $timeNow = $null;             # Holds the current time
        [string] $dateNow = $null;             # Holds the current date
        [string] $dateTime = $null;            # This will hold a time-stamp of when the
                                               #  directory was requested to be created.
        [int] $repetitionMax = 50;             # We should never really need this, but
                                               #  if in case we do - we have it.
                                               #  If in case the user needs more than the,
                                               #  max that is defined - then something is
                                               #  HORRIBLY wrong.
        [int] $repetitionCount = 0;            # The repetition counter; this will be
                                               #  incremented to help assure uniqueness for
                                               #  the directory name.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------

        

        # Initialize the Variables
        # - - - - - - - - - - - - - -
        #  Initialize the variables so that
        #   they can be used in the operations
        #   later on.
        # ---------------------------


        # First, we need to figure out the temporary directory
        #  To do this, we will use the environment variables
        #  to lock into the user's roaming profile temporary
        #  directory.  After that, append the program's name.
        $tempDirectoryPath = "$($env:TEMP)\$($Global:_PROGRAMNAME_)";


        # Second, get the Date and Time (this is our request time)
        # >> Date
        $dateNow = "$(Get-Date -UFormat "%d-%b-%y")";
        # >> Time
        $timeNow = "$(Get-Date -UFormat "%H.%M.%S")";
        
        # Now put the stamp together
        $dateTime = "$($dateNow).$($timeNow)";


        # Third, put the directory name together
        $tempDirectoryName = "$($keyTerm).$($dateTime)";


        # Finally, put the entire directory paths together
        $finalDirectoryPath = "$($tempDirectoryPath)\$($tempDirectoryName)";


        # ---------------------------
        # - - - - - - - - - - - - - -



        # Setup the Main Directory %TEMP%
        # - - - - - - - - - - - - - -
        #  Make sure that this program has a directory
        #   within the user's %TEMP%.  If it does not
        #   exist - create it, otherwise move forward.
        #   However, if the %Temp% directory is locked,
        #   this entire operation will be aborted.
        # ---------------------------


        # First, does the directory already exist?
        if ($([IOCommon]::CheckPathExists("$($tempDirectoryPath)")) -eq $false)
        {
            # Because the directory does not exist, try to create it.
            if ($([IOCommon]::MakeDirectory("$($tempDirectoryPath)")) -eq $false)
            {
                # Display the message to the user
                [IOLoggingGateway]::DisplayMessage("Unable to create a temporary directory!", "Error");

                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Put the arguments together in a package
                $logEventArguments[0] = "Error";
                $logEventArguments[1] = "Path of the parent temporary directory: $($tempDirectoryPath)";

                # Send an event regarding this failure; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                  -MessageData "Unable to create a parent temporary directory!" `
                                  -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *

                # We couldn't create the parent directory.  It might be
                #  possible that the User's LocalAppData\Temp is locked.
                return $false;
            } # inner-if : Create Directory Failed
        } # if : Path does NOT exist
        

        # ---------------------------
        # - - - - - - - - - - - - - -



        # Create the Requested Directory in %TEMP%
        # - - - - - - - - - - - - - -
        # Try to create the requested directory within
        #  the User's roaming profile %TEMP% directory.
        #  If in case all else fails, we must abort the
        #  operation.
        # Reasons for failure:
        #  - Directory is locked
        #  - Depth exceeds NTFS requirements
        #    (256char from root to leaf)
        #  - Directory and all repetitions exists
        #    (Something is SERIOUSLY wrong)
        # ---------------------------

        # First, we should check if the directory already exists.
        #  If the directory exists, try to make it unique.
        if ($([IOCommon]::CheckPathExists("$($finalDirectoryPath)")) -eq $true)
        {
            # This variable will help us break out of the loop
            #  if we can successfully find a unique name.  Otherwise,
            #  we reached a failure.
            [bool] $status = $true;

            # Find a unique name
            while($status)
            {
                if($([IOCommon]::CheckPathExists("$($finalDirectoryPath).$($repetitionCount)")) -eq $false)
                {
                    # We found a unique name, now record it
                    $finalDirectoryPath = "$($finalDirectoryPath).$($repetitionCount)";

                    # Change the status variable; we can leave the loop.
                    $status = $false;
                } # Inner-If : Check if Unique

                # Did we exceed our repetition limit?
                elseif (($status -eq $true) -and ($repetitionMax -le $repetitionCount))
                {
                    # Because we reached our max, something went horribly wrong.
                    #  We must abort this operation as it was unsuccessful.
                    return $false;
                } # Inner-Else : Check if Max Reached
                
                # Increment the counter
                $repetitionCount = $repetitionCount + 1;
            } # while : trying to find unique name
        } # if : Directory already Exists



        # Now that we have the name, create the directory
        if ($([IOCommon]::MakeDirectory("$($finalDirectoryPath)")) -eq $false)
        {
            # Display the message to the user
            [IOLoggingGateway]::DisplayMessage("Unable to create a temporary directory!", "Error");

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Path of the temporary directory: $($finalDirectoryPath)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                -MessageData "Unable to create a temporary directory!" `
                                -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # There was a failure while creating the directory.
            return $false;
        } # if : Failure Creating Directory



        # Just for assurance sakes, does the directory exist?
        if ($([IOCommon]::CheckPathExists("$($finalDirectoryPath)")) -eq $false)
        {
            # Display the message to the user
            [IOLoggingGateway]::DisplayMessage("Created the temporary directory but unable to found it....", "Error");

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Path of the temporary directory: $($finalDirectoryPath)";

            # Send an event regarding this failure; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                -MessageData "Successfully created the temporary directory but it was not found in the final destination path!" `
                                -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Because the directory does not exist, we cannot
            #  simply use something that isn't there.
            return $false;
        } # if : Directory does not exist



        # Finalizing and Concluding
        # - - - - - - - - - - - - - -
        # Now that everything was set up and we now have
        #  the directory ready for general use now, we
        #  will do the final touches and close this
        #  function successfully.
        # ---------------------------
        

        # Record the absolute directory name
        $directoryPath.Value = "$($finalDirectoryPath)";


        # Successfully finished with this function
        return $true;
    } # MakeTempDirectory()




   <# Make a New Directory
    # -------------------------------
    # Documentation:
    #  This function will make a new directory with the
    #   absolute path provided.
    # -------------------------------
    # Input:
    #  [string] Absolute Path
    #   The absolute path of a directory that is to be
    #   created by request.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure to create the directory.
    #    $true = Successfully created the directory.
    #            OR
    #            Directory already exists; nothing to do.
    # -------------------------------
    #>
    static [bool] MakeDirectory([string] $path)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $true;    # Exit code that will be returned.
        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # Check to see if the path already exists;
        #  if it already exists - then nothing to do.
        #  If it does not exist, then try to create it.
        if (([IOCommon]::CheckPathExists("$($path)")) -eq $false)
        {
            # The requested path does not exist, try to create it.
            try
            {
                # Try to create the directory; if failure - stop.
                New-Item -Path "$($path)" -ItemType Directory -ErrorAction Stop;

                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Put the arguments together in a package
                $logEventArguments[0] = "Verbose";
                $logEventArguments[1] = "Directory Path: $($path)";
                #Path of the temporary directory: $($finalDirectoryPath)";

                # Send an event regarding this failure; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                    -MessageData "Successfully created the directory!" `
                                    -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *
            } # try : Create directory.
            catch
            {
                # Immediately cache the reason why the command failed.
                $executeFailureMessage = "$($_)";

                # Display the message to the user
                [IOLoggingGateway]::DisplayMessage("Failed to create the required directory!`r`nReason for failure: $($executeFailureMessage)", "Error");

                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Put the arguments together in a package
                $logEventArguments[0] = "Error";
                $logEventArguments[1] = "Directory Path: $($path)`r`n`tAdditional Error Message: $($executeFailureMessage)";
                #Path of the temporary directory: $($finalDirectoryPath)";

                # Send an event regarding this failure; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                    -MessageData "Failed to create the directory by request!" `
                                    -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *
                # Failure occurred.
                $exitCode = $false;
            } # Catch : Failed to Create Directory
        } # If : Directory does not exist


        # Return the exit code
        return $exitCode;
    } # MakeDirectory()




   <# Check Path Exists
    # -------------------------------
    # Documentation:
    #  This function will check if the provided
    #   directory (absolute path) exists on the
    #   host's filesystem.
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The path to check if it exists in the
    #     filesystem.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Directory does not exist.
    #    $true = Directory exist
    # -------------------------------
    #>
    static [bool] CheckPathExists([string] $path)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;    # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # Check if the path exists
        if((Test-Path -LiteralPath "$($path)" -ErrorAction SilentlyContinue) -eq $true)
        {
            # Directory exists
            $exitCode = $true;
        } # If : Directory exists


        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        # --------------

        # Capture any additional information
        $logAdditionalInfo = "$($_)";

        # Put the arguments together in a package
        $logEventArguments[0] = "Verbose";
        $logEventArguments[1] = "$($logAdditionalInfo)";

        # Send an event regarding the status of the operation's results; this will be logged.
        $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                          -MessageData "Tried to find the path named $($path), detected result was $($exitCode)" `
                          -EventArguments $logEventArguments | Out-Null;

        # * * * * * * * * * * * * * * * * * * *

        # Return with exit code
        return $exitCode;
    } # CheckPathExists()




   <# Delete Directory
    # -------------------------------
    # Documentation:
    #  This function will forcefully and recursively
    #   thrash the target directory and all sub-
    #   directories following within the hierarchy.
    #   Thus meaning, anything within the target
    #   directory - will be expunged.  Use this
    #   function carefully!
    #
    #  NOTES:
    #   - Recursive
    #   - Forceful
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The directory that we want to delete.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to delete directory.
    #    $true = Successfully deleted directory
    # -------------------------------
    #>
    static [bool] DeleteDirectory([string] $path)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;    # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # First check to see if the directory actually exists,
        #  if not, then there is nothing to do.
        if(([IOCommon]::CheckPathExists("$($path)")) -eq $false)
        {
            # The directory does not exist, there's nothing to do.
            return $true;
        } # Check if Directory Exists.


        # Try to delete the directory
        try
        {
            # Remove the directory.
            Remove-Item -LiteralPath "$($path)" -Force -Recurse -ErrorAction Stop;

            # Successfully deleted the requested directory.
            $exitCode = $true;
        } # Try : Delete Directory

        catch
        {
            # Failure occurred while deleting the requested directory.
            $exitCode = $false;
        } # Catch : Error Deleting Directory


        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        # --------------

        # Capture any additional information
        $logAdditionalInfo = "$($_)";

        # Put the arguments together in a package
        $logEventArguments[0] = "Verbose";
        $logEventArguments[1] = "$($logAdditionalInfo)";

        # Send an event regarding the status of the operation's results; this will be logged.
        $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                          -MessageData "Tried to thrash the directory named $($path), operation result was $($exitCode)" `
                          -EventArguments $logEventArguments | Out-Null;

        # * * * * * * * * * * * * * * * * * * *

        # Return with exit code
        return $exitCode;
    } # DeleteDirectory()




   <# Delete File
    # -------------------------------
    # Documentation:
    #  This function will forcefully delete an
    #   individual file or a specific set of
    #   files given by a specific criteria.
    #   This function cane be useful to delete
    #   superfluous log files and the like.
    #   Use this function carefully!
    #
    #  NOTES:
    #   - Forceful
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The directory that we want to inspect
    #     the file contents.
    #    - NOTE: DO NOT PUT THE ACTUAL FILE PATH OR
    #            PATH OF FILES HERE, USE 'Includes'
    #            FOR THIS!
    #  [string[]] Includes
    #    What specific requirements must a file have
    #     in order to be classified to be deleted.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to delete directory.
    #    $true = Successfully deleted directory
    # -------------------------------
    #>
    static [bool] DeleteFile([string] $path, [string[]] $includes)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;    # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # First check to see if the directory actually exists,
        #  if not, then there is nothing to do.
        if(([IOCommon]::CheckPathExists("$($path)")) -eq $false)
        {
            # The directory does not exist, there's nothing to do.
            return $true;
        } # Check if Directory Exists.


        # Try to delete the requested files from specific directory.
        try
        {
            # Remove the requested files.
            Remove-Item -Path "$($path)\*" -Include $($includes) -Force -ErrorAction Stop;

            # Successfully deleted the file(s)
            $exitCode = $true;
        } # Try : Delete Files

        catch
        {
            # Failure occurred while deleting the requested file(s).
            $exitCode = $false;
        } # Catch : Error Deleting Files


        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        # --------------

        # Capture any additional information
        $logAdditionalInfo = "$($_)";

        # Put the arguments together in a package
        $logEventArguments[0] = "Verbose";
        $logEventArguments[1] = "$($logAdditionalInfo)";

        # Send an event regarding the status of the operation's results; this will be logged.
        $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                          -MessageData "Tried to thrash the requested files $($includes.ToString()) from the path named $($path), operation result was $($exitCode)" `
                          -EventArguments $logEventArguments | Out-Null;

        # * * * * * * * * * * * * * * * * * * *

        # Return with exit code
        return $exitCode;
    } # DeleteFile

    #endregion


    #region File Integrity

   <# File Hash
    # -------------------------------
    # Documentation:
    #  This function will provide the hash value
    #   in regards to a specific data-file.
    # -------------------------------
    # Input:
    #  [string] Absolute Path
    #   The absolute path of a data-file.
    #  [string] Hash Algorithm
    #   Typical values can be: "MD5" or "SHA1".
    #    For a complete list of hash algorithms, please check the documentation:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash
    # -------------------------------
    # Output:
    #  [string] Hash Value code
    #    $null = Error for File does not exist.
    #    All other values will be the hash code.
    # -------------------------------
    #>
    static [string] FileHash([string] $path, [string] $hashAlgorithm)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $hashValue = $null;      # The hash value regarding specified file.

        # SPECIAL OBJECTS
        # - - - - - - - -

        # FileHashInfo; used for capturing the hash information from a specific data file.
        $hashInfo = New-Object -TypeName Microsoft.PowerShell.Commands.FileHashInfo;

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # First, check if the file actually exists within the user's filesystem
        if ([IOCommon]::CheckPathExists("$($path)") -eq $false)
        {
            # Because the file was not on the user's filesystem at the specified
            #  path, return null to signify an error.
            return $null;
        } # if : File not found
        

        # Second, check to make sure that the requested hash algorithm is supported by
        #  the .NET Framework.
        if ([IOCommon]::__SupportedHashAlgorithms($hashAlgorithm) -eq $false)
        {
            # The hash algorithm requested was not supported.

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Requested file: $($path)`r`n`tRequested Hash Algorithm: $($hashAlgorithm)";

            # Send an event regarding the status of the operation's results; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "The requested hash algorithm is not supported!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Return null as the requested hash algorithm does not exist or is not supported.
            return $null;
        } # if : Unsupported Hash Algorithm


        # Try to get the hash of the file
        try
        {
            # Try to get the hash of the file and cache it.
            #  NOTE: Do not try to out-right store the 'hash' value explicitly as
            #        this causes a performance degrade when an issue creeps up.
            $hashInfo = Get-FileHash -LiteralPath "$($path)" -Algorithm "$($hashAlgorithm)" -ErrorAction Stop;

            # From the cache data, get the hash and save it.
            $hashValue = $hashInfo.Hash;
        } # Try : Get hash value

        # Catch if an error occurred
        catch
        {
            # Failure to obtain the hash value.

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Capture any additional information
            $logAdditionalInfo = "$($_)";

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Requested file: $($path)`r`n`tRequested Hash Algorithm: $($hashAlgorithm)`r`n`tAdditional Information: $($logAdditionalInfo)";

            # Send an event regarding the status of the operation's results; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                              -MessageData "A failure occurred while trying to get the hash value!" `
                              -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Return null as an error occurred.
            $hashValue = $null;
        } # Catch : Failure to fetch value


        # Return the value of the hash data, if it was present.
        return "$($hashValue)";
    } # FileHash()




   <# Supported Hash Algorithms
    # -------------------------------
    # Documentation:
    #  This function will check to make sure
    #   that requested hash algorithm is supported
    #   in the .NET Framework.
    #
    #  List of available Hash Algorithms:
    #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash
    # -------------------------------
    # Input:
    #  [string] Requested Hash Algorithm
    #    This will contain the requested algorithm to be used
    #     in .NET Framework.  This will be checked against a
    #     list of available algorithms known to be supported.
    # -------------------------------
    # Output:
    #  [bool] Supported Status
    #    $false = The hash algorithm requested is not supported.
    #    $true  = The hash algorithm requested is supported.
    # -------------------------------
    #>
    Static Hidden [bool] __SupportedHashAlgorithms([string] $hashAlgo)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $knownAlgos = @("sha1", `
                                   "sha256", `
                                   "sha384", `
                                   "sha512", `
                                   "md5");
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


    #region Web Control

   <# Open Web Page
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to access
    #   a specific webpage that was requested.  In
    #   order to access the webpage, we will merely
    #   use the default or preferred web browser
    #   as defined by the user's settings from the
    #   host system.
    # -------------------------------
    # Input:
    #  [string] URL Address
    #   The webpage's URL Address
    # -------------------------------
    #  [bool] Exit code
    #    $false = Failure to access webpage.
    #    $true = Successfully accessed webpage.
    # -------------------------------
    #>
    static [bool] AccessWebpage([string] $URLAddress)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;  # The operation exit code.

        # * * * * * * * * * * * * * * * * * * *
        # Event Logging
        [string] $logAdditionalInfo = $null;           # Additional information provided by
                                                       #  the PowerShell engine, such as
                                                       #  error messages.
        # Object containing arguments to be passed.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------


        # Make sure that the URL Address provided is actually
        #  a legitimate URL address.
        if ((($URLAddress -like 'http://*') -eq $true) -or `
            (($URLAddress -like 'www.*') -eq $true))
        {
            # The address is legal.
            # Try to open the web site
            try
            {
                # Open the webpage
                Start-Process -FilePath "$($URLAddress)" -ErrorAction Stop;
            
                # Update the exit code status
                $exitCode = $true;
            } # Try : Execute Task

            catch
            {
                # Error occurred while trying to open the requested web-page

                # * * * * * * * * * * * * * * * * * * *
                # Event Logging
                # --------------

                # Capture any additional information
                $logAdditionalInfo = "$($_)";

                # Put the arguments together in a package
                $logEventArguments[0] = "Error";
                $logEventArguments[1] = "Tried to open webpage: $($URLAddress)`r`n`tAdditional Information: $($logAdditionalInfo)";

                # Send an event regarding the status of the operation's results; this will be logged.
                $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                  -MessageData "Failure occurred while accessing the requested webpage!" `
                                  -EventArguments $logEventArguments | Out-Null;

                # * * * * * * * * * * * * * * * * * * *

                # Update the exit code status.
                $exitCode = $false;
            } # Catch : Error
        } # If : URL Address is Legitimate

        else
        {
            # The address is not legal

            # * * * * * * * * * * * * * * * * * * *
            # Event Logging
            # --------------

            # Put the arguments together in a package
            $logEventArguments[0] = "Error";
            $logEventArguments[1] = "Tried to open webpage: $($URLAddress)";

            # Send an event regarding the status of the operation's results; this will be logged.
            $null = New-Event -SourceIdentifier "$([IOCommon]::eventNameLog)" `
                                -MessageData "The requested webpage is not valid!" `
                                -EventArguments $logEventArguments | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Update the exit code status.
            $exitCode = $false;
        } # Else : URL Address is NOT Legitimate



        # Return the operation status
        return $exitCode;
    } # AccessWebpage()
    #endregion


    #region Custom Events Powershell Engine

   <# Register Event: Logging
    # -------------------------------
    # Documentation:
    #  This function will register the logging custom event
    #   to the Powershell engine.  This will allow functions
    #   to properly log their activities and provide
    #   informational or verbose details regarding the operation
    #   or status of a specific action that took place.
    # -------------------------------
    # Inputs:
    #  [string] Nice Source Name
    #   The source name that is being registered; ideally this
    #    can be the name of the object - which might be displayed
    #    to the user or logged for future references.
    #  [string] Source Identifier
    #   The Source Identifier that will be registered to the
    #    Powershell's engine.
    #   NOTE: All Source Identifiers _MUST_ be unique to the
    #    Powershell engine.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #    $false = Failure to create the custom event.
    #    $true = Successfully created the custom event.
    # -------------------------------
    #>
    static [bool] RegisterEventLogging([string] $niceSourceName, [string] $sourceIdent)
    {
        # Display a message on the screen that the logging event is being registered.
        Write-Host "Trying to register the custom event [Logging] for the source name: $($niceSourceName). . .";

        try
        {
            # Try to register the custom event
            Register-EngineEvent -SourceIdentifier "$($sourceIdent)" -Action {
                [IOLoggingGateway]::CaptureLogEvent($event);
            } # Register-EngineEvent :: Action

            # Display a message on the terminal screen that the event has been created successfully.
            Write-Host "Successfully registered the custom event [Logging] for the source name: $($niceSourceName)!";
        
            # Return successfully
            return $true;
        } # Try

        # A failure occurred
        Catch
        {
            # Display a message on the terminal screen that the event could not be successfully created.
            Write-Host "Failed to register custom event [Logging] for the source name: $($niceSourceName)!";
        
            # Return an error
            return $false;
        } # Failure
    } # RegisterEventLogging()




   <# Unregister Events
    # -------------------------------
    # Documentation:
    #  This function will unregister a specific custom event that
    #   was previously registered to the Powershell engine.
    # -------------------------------
    # Inputs:
    #  [string] Nice Source Name
    #   The source name that is being unregistered; ideally this
    #    can be the name of the object - which might be displayed
    #    to the user or logged for future references.
    #  [string] Source Identifier
    #   The Source Identifier that will be unregistered from the
    #    Powershell's engine.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #    $false = Failure to create the custom event.
    #    $true = Successfully created the custom event.
    # -------------------------------
    #>
    static [bool] UnregisterEvent([string] $niceSourceName, [string] $sourceIdent)
    {
        # Display a message on the screen that the logging event is being unregistered
        Write-Host "Trying to unregister the custom event [Logging] for the source name: $($niceSourceName). . .";

        # Remove the Custom Event for Logging
        try
        {
            # Try unregister the custom event
            Unregister-Event -Force -SourceIdentifier "$($sourceIdent)";

            # Display a message on the terminal screen that the event was unregistered successfully.
            Write-Host "Successfully unregistered the custom event [Logging] for the source name: $($niceSourceName)!";
    
            # Return successfully
            return $true;
        } # Try

        # Failure to unregister
        catch
        {
            # Display a message on the terminal screen that the event could not be successfully unregistered.
            Write-Host "Failed to unregister custom event [Logging] for the source name: $($niceSourceName)!";
    
            # Return an error
            return $false;
        } # Failure
    } # UnregisterEvent()

    #endregion
} # IOCommon