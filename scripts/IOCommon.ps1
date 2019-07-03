﻿<# Common Input\Output Operations
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to house all of the common
 #  input and output functionality that will be used
 #  within the software.  Because all of the I\O
 #  functions are held within this class, we can
 #  focus on minimizing code redundancy and assure
 #  that the functionality is refined.  Though, using
 #  this class requires a tightening class-coupling
 #  and a lower-cohesion -- A cost that is required
 #  to help avoid code redundancies and using well-refined
 #  functions within this class.
 # - -
 # Functionality that is supported in this class:
 #  - Get user input (keyboard)
 #  - Display a message on the screen
 #  - Running an external command
 #  - File and directory management
 #  - Create a PDF file
 #  - Hash information
 #>




class IOCommon
{
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
    #   on the screen with its appropriate formatting.  The
    #   formatting of the message is determined by its
    #   message level (or logged level).
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that is to be presented on the screen.
    #  [LogMessageLevel] Message Level
    #   The level of the message that is to be presented
    #    or formatted.
    # -------------------------------
    #>
    static [void] WriteToBuffer([string] $msg,                 # Message
                                [LogMessageLevel] $msgLevel)   # Message Level
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $textColourBackground = $null; # Text background color
        [string] $textColourForeground = $null; # Text foreground color
        # ----------------------------------------


        # Determine the level of the message; text presentation
        switch ($msgLevel)
        {
            # If in case: User Input was provided - leave from this
            #  function without displaying the information.
            "UserInput"
            {
                # Because this function was called with a message level
                #  of 'UserInput' (Only usable for capturing or evaluating
                #  the user's input elsewhere), there's no point of having
                #  this display what the user has already provided.
                return;
            } # UserInput


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
            Write-Host -Object $msg `
                    -ForegroundColor $textColourForeground;
        } # if : No Text Background

        # Background was specified
        else
        {
            Write-Host -Object $msg `
                    -ForegroundColor $textColourForeground `
                    -BackgroundColor $textColourBackground;
        } # else : Text Background
    } # WriteToBuffer()

    #endregion


    #region External Command Functions

   <# Detect Command [Test]
    # -------------------------------
    # Documentation:
    #  This function will help to determine if the external
    #   command or command (in general terms) could be
    #   detected with the given path and if the command is
    #   a supported command type.  If the file or command
    #   we want to ultimately execute is not detected in
    #   the filesystem or the file we want to use is not
    #   the proper executable type, then the detection
    #   will return false - indicating that the command
    #   cannot be used.
    # -------------------------------
    # Inputs:
    #  [string] Command
    #   The external executable or command to test.
    #  [string] Type
    #   The type of command that will be executed.
    #    See Get-Command "CommandType"
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-command
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Detected Code
    #    $false = Failure to detect the external executable or
    #              was not the proper command type.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    static [bool] DetectCommand([string] $command, `        # Executable or command to run
                                [string] $type, `           # Command type
                                [bool] $logging)            # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;          # The detection code that will be returned based
                                            #  on the results; if the command was found or not.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;       # The initial message to be logged.
        [string] $logAdditionalMSG = $null; # Additional information provided.
        # ----------------------------------------


        # Try to detect the requested command
        if ((Get-Command -Name "$($command)" `
                        -CommandType $($type) `
                        -ErrorAction SilentlyContinue) -eq $null)
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
        # Debugging
        # --------------

        # If Logging is enabled, obtain the additional information.
        if ($logging)
        {
            # Generate the message
            $logMessage = "Tried to find the $($type) named $($command); detected result was $($exitCode)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Verbose");
        } # If: Debugging

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
    #  This function depends on other methods in order to
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
    #   Arguments to be used when executing the binary or the extCMD.
    #  [string] Project Path
    #   The absolute path of the project directory.
    #  [string] STDOUT Log Path
    #   Absolute path to store the log file containing
    #    the program's STDOUT output.
    #   - NOTE: Filename will be provided by this function.
    #  [string] STDERR Log Path
    #   Absolute path to store the log file containing
    #    the program's STDERR output.
    #   - NOTE: Filename will be provided by this function.
    #  [string] Report Path
    #   Absolute path and filename to store the report file.
    #   - NOTE: The filename of the report __MUST_BE_INCLUDED!___
    #  [string] Description
    #   Used for logging and for information purposes only.
    #   - NOTE: A description can provide a reason for executing the
    #            executable or an operation that is being performed
    #            by the executable.  For example: "Using the Tree
    #            extCMD will provide an overview of the filesystem's
    #            directory hierarchy - as well as the depth of the
    #            directories."
    #            Just remember, this is only shown in the log file.
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.  Useful for processing the STDOUT
    #    internally - within the program.
    #  [string] (REFERENCE) String Output
    #   When Capture STDOUT is true, this parameter will
    #   carry the STDOUT from the executable.  The
    #   information provided will be available for use
    #   from the calling function.
    # -------------------------------
    # Output:
    #  [int] Exit Code
    #   The error code provided from the executable.
    #    This can be helpful to diagnose if the external command
    #    reached an error or was successful.
    #    NOTE: We are using negative values to help avoid a confusion
    #           from the return code of the binary (or extCMD) that was
    #           executed in this function.
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
    static [int] ExecuteCommand([string] $command, `            # Executable or command to run
                                [string] $arguments, `          # Parameters for the executable or command
                                [string] $projectPath, `        # Project file path (ZDoom based project)
                                [string] $stdOutLogPath, `      # Standard Out (Execution Logging) Path
                                [string] $stdErrLogPath, `      # Standard Error (Execution Logging) Path
                                [string] $reportPath, `         # Report path and filename (isReport)
                                [string] $description, `        # Reason for why we are executing the command
                                [bool] $logging, `              # Logging features
                                [bool] $isReport, `             # Output should be in the report file
                                [bool] $captureSTDOUT, `        # Capture the output from the command to a variable
                                [ref] $stringOutput)            # Holds the output from the command (captureSTDOUT)
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
        # Debugging [Logging]
        [string] $logMessage = $null;             # The initial message to be logged.
        [string] $logAdditionalMSG = $null;       # Additional information provided.
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the executable exists before trying to use it.
        if ($([IOCommon]::DetectCommand("$($command)", "Application", $logging)) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tReason to use command: $($description)");

                # Generate the message
                $logMessage = "Failed to execute the external command $($command) because it was not found or is not an application!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Executable was not detected.
            return -254;
        } # if : Executable was not detected


        # Make sure that the Project path exists
        if ($([IOCommon]::CheckPathExists("$($projectPath)", $logging)) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tReason to use command: $($description)`r`n" + `
                                    "`tProject Path: $($projectPath)");

                # Generate the message
                $logMessage = "Failed to execute the external command $($command) because the project path does not exist!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Project Path does not exist, return an error.
            return -253;
        } # if : The Project Path does not exist


        # Make sure that the Standard Output Path exists
        if ($([IOCommon]::CheckPathExists("$($stdOutLogPath)", $logging)) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tReason to use command: $($description)`r`n" + `
                                    "`tSTDOUT Directory: $($stdOutLogPath)");

                # Generate the message
                $logMessage = "Failed to execute the external command $($command) because the STDOUT Directory does not exist!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Standard Output Path does not exist, return an error.
            return -252;
        } # if : The Standard Output Path does not exist


        # Make sure that the Standard Error path exists
        if ($([IOCommon]::CheckPathExists("$($stdErrLogPath)", $true)) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tReason to use command: $($description)`r`n" + `
                                    "`tSTDERR Directory: $($stdErrLogPath)");

                # Generate the message
                $logMessage = "Failed to execute the external command $($command) because the STDERR Directory does not exist!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

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
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tDescription is now: $($description)");

                # Generate the message
                $logMessage = ("The description field was missing while serving the request to execute the external command $($command)!" + `
                                "  The description will be automatically filled for this instance.");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Warning");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


        } # if : Description was not populated

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the Command
        #  NOTE: This function will return the following if something goes horribly wrong:
        #        -255 = Failure to execute the extCMD or Command (May not exist or general error)
        #        -254 = Could not find the extCMD or Command
        $externalCommandReturnCode = [IOCommon]::__ExecuteCommandRun($command, `                # Executable to run
                                                                    $arguments, `               # Parameters for the executable
                                                                    $projectPath, `             # Project path (Working Directory)
                                                                    [ref] $containerStdOut, `   # Var. holds standard output
                                                                    [ref] $containerStdErr, `   # Var. holds standard error
                                                                    $logging)                   # Logging features


        # Create the necessary logfiles or capture a specific input
        [IOCommon]::__ExecuteCommandLog($stdOutLogPath, `           # Path for the Standard Output
                                        $stdErrLogPath, `           # Path for the Standard Error
                                        $reportPath, `              # Path for the report (isReport)
                                        $logging, `                 # Logging features
                                        $isReport, `                # Output should be in the report file
                                        $captureSTDOUT, `           # Capture the output from the command to a variable
                                        $description, `             # Reason for why we are executing the command
                                        [ref] $callBack, `          # Store the output result in this variable
                                        [ref] $containerStdOut, `   # Executable STDOUT results provided in this var.
                                        [ref] $containerStdErr)     # Executable STDERR results provided in this var.


        # Do we need to copy the STDOUT to the pointer?
        #  Used if wanting the extCMD output in a function.
        if ($captureSTDOUT -eq $true)
        {
            # Copy the stdout to pointer
            $stringOutput.Value = $callBack;
        } # If : Redirect STDOUT to Pointer


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Capture any additional information
        $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                            "`tArguments to be used: $($arguments)`r`n" + `
                            "`tReason to use command: $($description)`r`n" + `
                            "`tExtCMD Exit Code: $($externalCommandReturnCode)");

        # Generate the message
        $logMessage = "Successfully executed the external command $($command)!";

        # Pass the information to the logging system
        [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Verbose");

        # * * * * * * * * * * * * * * * * * * *


        # Return the ExtCMD's exit code
        return $externalCommandReturnCode;
    } # ExecuteCommand()




   <# Execute Command - Logging
    # -------------------------------
    # Documentation:
    #  This function will take the outputs provided by the
    #   external command or executable file and place them
    #   in the log files or redirect the output to a specific
    #   reference variable upon request.
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
    #   - NOTE: The filename of the report __MUST_BE_INCLUDED!___
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.  Useful for processing the STDOUT
    #  [string] Description
    #   Used for logging and for information purposes only.
    #   - NOTE: A description can provide a reason for executing the
    #            executable or an operation that is being performed
    #            by the executable.  For example: "Using the Tree
    #            extCMD will provide an overview of the filesystem's
    #            directory hierarchy - as well as the depth of the
    #            directories."
    #            Just remember, this is only shown in the log file.
    #  [string] (REFERENCE) Output String
    #   When Capture STDOUT is true, this parameter will
    #    carry the STDOUT from the executable.  The
    #    information provided will be available for use
    #    from the calling function.
    #  [string] (REFERENCE) Output Result STDOUT
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [string] (REFERENCE) Output Result STDERR
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    # -------------------------------
    #>
    Static Hidden [void] __ExecuteCommandLog([string] $stdOutLogPath, `     # Standard Out (Execution Logging) Path
                                            [string] $stdErrLogPath, `      # Standard Error (Execution Logging) Path
                                            [string] $reportPath, `         # Report path and filename (isReport)
                                            [bool] $logging, `              # Logging features
                                            [bool] $isReport, `             # Output should be in the report file
                                            [bool] $captureSTDOUT, `        # Capture the output from the command to a variable
                                            [string] $description, `        # Reason for why we are executing the command
                                            [ref] $stringOutput, `          # Holds the output from the command (captureSTDOUT); used for
                                                                            #  further processing within the program.
                                            [ref] $outputResultOut, `       # Contains the STDOUT result from the command or extCMD
                                            [ref] $outputResultErr)         # Contains the STDERR result from the command or extCMD
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $logTime        = $(Get-Date -UFormat "%d-%b-%y %H.%M.%S");             # Capture the current date and time.
        [string] $logStdErr      = "$($stdErrLogPath)\$($logTime)-$($description).err";  # Standard Error absolute log file path
        [string] $logStdOut      = "$($stdOutLogPath)\$($logTime)-$($description).out";  # Standard Out absolute log file path
        [string] $fileOutput     = $null;                                                # The absolute path of the file that will contain
                                                                                         #  the output result from the extCMD or command.
        [string] $redirectStdOut = $null;                                                # When Standard Out redirection to variable is
                                                                                         #  requested (captureSTDOUT), this will be our
                                                                                         #  buffer - which will hold the STDOUT data.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;             # The initial message to be logged.
        [string] $logAdditionalMSG = $null;       # Additional information provided.
        # ----------------------------------------


        # Determine the file name that will soon contain the output
        #  information from the extCMD or command.
        # Is it a report file or a logfile?
        if ($isReport)
        {
            # User is requesting a report file.
            $fileOutput = "$($reportPath)";
        } # If: Generating a Report
        else
        {
            # User is requesting a logfile
            $fileOutput = "$($LogStdOut)";
        } # Else: Generating a logfile


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
                [IOCommon]::WriteToFile("$($reportPath)", "$($outputResultOut.Value)", $logging) | Out-Null;
            } # If : Generating a Report


            # Store the STDOUT in a logfile?
            ElseIf ($logging -eq $true)
            {
                # Store the information to a text file.
                [IOCommon]::WriteToFile("$($logStdOut)", "$($outputResultOut.Value)", $logging) | Out-Null;
            } # Else : Stored in a specific file


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Description: $($description)`r`n" + `
                                    "`tSTDOUT Log Path: $($logStdOut)`r`n" + `
                                    "`tSTDOUT Output:`r`n" + `
                                    "`t$($outputResultOut.Value)");

                # Generate the message
                $logMessage = "External command returned successfully with additional output.";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Verbose");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


        } # If : STDOUT contains data


        # Standard Error
        # -------------------
        # +++++++++++++++++++


        # Store the STDERR in a logfile and is there data?
        If (($logging -eq $true) -and ("$($outputResultErr.Value)" -ne ""))
        {
            # Write the STDERR to a logfile
            [IOCommon]::WriteToFile("$($logStdErr)", "$($outputResultErr.Value)", $logging) | Out-Null;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Description: $($description)`r`n" + `
                                    "`tSTDERR Log Path: $($logStdErr)`r`n" + `
                                    "`tSTDERR Output:`r`n" + `
                                    "`t$($outputResultErr.Value)");

                # Generate the message
                $logMessage = "External command returned with an error or error messages exists!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Warning");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


        } # If : Log the STDERR
    } # ExecuteCommandLog()




   <# Execute Command - Run [Using .NET API]
    # -------------------------------
    # Documentation:
    #  This function will provide the ability execute the
    #   command or extCMD with the desired arguments.  This
    #   function will return the exit code that is provided
    #   directly from the executable, unless an internal
    #   conflict occurs - see 'Output:' for more information.
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
    #   Arguments to be used when executing the binary or the extCMD.
    #  [string] Project Path
    #   The absolute path of the project directory.
    #  [string] (REFERENCE) Output Result STDOUT
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [string] (REFERENCE) Output Result STDERR
    #   The STDOUT provided by the extCMD.
    #   - NOTE: Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [int] Exit Code
    #   The error code provided from the executable.
    #    This can be helpful to diagnose if the external command
    #    reached an error or was successful.
    #   NOTE: We are using negative values to help avoid a confusion
    #          from the return code of the binary (or extCMD) that was
    #          executed in this function.
    #   ERROR VALUES
    #   -255
    #    The executable could not execute; may not exist.
    #
    #   -254
    #    Command was not detected.
    # -------------------------------
    #>
    Static Hidden [int] __ExecuteCommandRun([string] $command, `        # Executable or command to run
                                            [string] $arguments, `      # Parameters for the executable or command
                                            [string] $projectPath, `    # Project file path (ZDoom based project)
                                            [ref] $captureStdOut, `     # Will hold the STDOUT result from the command or extCMD
                                            [ref] $captureStdErr, `     # Will hold the STDERR result from the command or extCMD
                                            [bool] $logging)            # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;                  # The initial message to be logged.
        [string] $logAdditionalMSG = $null;            # Additional information provided.

        # - - - - - - - - - - - - - - - - - - - -
        # .NET Special Objects
        # - - - -
        # Because Start-Process CMDLet does NOT redirect to a variable, but only to files.
        #  Instead, we will use the 'ProcessStartInfo' class from the dotNET framework.
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
        if(([IOCommon]::DetectCommand("$($command)", "Application", $logging)) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # if Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)");

                # Generate the message
                $logMessage = "Failed to execute the external command $($command) because it was not found or is not an application!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Because the extCMD does not exist (or not found), return an error.
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

            # Prep a message to display to the user for this error; temporary variable
            [string] $tempErrorMessage = "Failure to execute command upon request!`n`rFailure reason: $($executeFailureMessage)";


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("Command to execute: $($command)`r`n" + `
                                    "`tArguments to be used: $($arguments)`r`n" + `
                                    "`tFailed to execute reason: $($executeFailureMessage)");

                # Generate the message
                $logMessage = "A failure occurred upon executing the external command $($command)!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

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
    #
    #  NOTE: This function implies that the CMDLet had already
    #         executed from outside of this function.  This
    #         function will _NOT_ execute any CMDLets nor execute
    #         any commands; this function is only designed to help
    #         push the STDOUT and STDERR to the respected files
    #         and protocols.
    #
    #  EXECUTION NOTE:
    #   This function should only be called for significant CMDLets only.
    #    Furthermore, CMDLets do not have a centralized point of execution.
    #    Unlike the External CMD (extCMD) where there is one centralized
    #    point of execution, PowerShell's CMDLets can be executed freely
    #    within this software.  The reason for this is because there is a
    #    protocol for executing the extCMD and binary files, native CMDLets
    #    primarily depends on the dotNET Core (or dotNet) foundation.
    # -------------------------------
    # Inputs:
    #  [string] STDOUT Log Path
    #   Absolute path to store the log file containing
    #    the program's STDOUT output.
    #   - NOTE: Filename will be provided by this function.
    #  [string] STDERR Log Path
    #   Absolute path to store the log file containing
    #    the program's STDERR output.
    #   - NOTE: Filename will be provided by this function.
    #  [string] Report Path
    #   Absolute path and filename to store the report file.
    #   - NOTE: The filename of the report __MUST_BE_INCLUDED!___
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    #  [bool] Is Report
    #   When true, this will assure that the information
    #    is logged as a report.
    #  [bool] Capture STDOUT
    #   When true, the STDOUT will not be logged in a
    #    text file, instead it will be captured into
    #    a reference string.  Useful for processing the STDOUT
    #    internally - within the program.
    #  [string] Description
    #   Used for logging and for information purposes only.
    #   - NOTE: A description can provide a reason for executing the
    #            CMDLet or an operation that was performed by the
    #            CMDLet.  For example; "Using the Get-ChildItem to
    #            display all files and sub-directories that exists
    #            within the Working Directory"
    #            Just remember, this is only shown in the log file.
    #  [string] (REFERENCE) String Output
    #   When Capture STDOUT is true, this parameter will
    #    carry the STDOUT from the CMDLet.  The information provided
    #    will be available for use from the calling function.
    #  [string] (REFERENCE) Output Result STDOUT
    #   The STDOUT provided by the CMDLet.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    #  [string] (REFERENCE) Output Result STDERR
    #   The STDOUT provided by the CMDLet.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Output can be at maximum of 2GB of space. (Defined by CLR)
    # -------------------------------
    #>
    static [void] PSCMDLetLogging([string] $stdOutLogPath, `    # Standard Out (Execution Logging) Path
                                [string] $stdErrLogPath, `      # Standard Error (Execution Logging) Path
                                [string] $reportPath, `         # Report path and filename (isReport)
                                [bool] $logging, `              # Logging features
                                [bool] $isReport, `             # Output should be in the report file
                                [bool] $captureSTDOUT, `        # Capture the output from the command to a variable
                                [string] $description, `        # Reason for why we are executing the command
                                [ref] $stringOutput, `          # Holds the output from the command (captureSTDOUT)
                                [ref] $outputResultOut, `       # Contains the STDOUT result from the CMDLet
                                [ref] $outputResultErr)         # Contains the STDERR result from the CMDLet
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
        #  the same code, we will merely use the same function.
        [IOCommon]::__ExecuteCommandLog($stdOutLogPath, `       # Path for the Standard Output
                                        $stdErrLogPath, `       # Path for the Standard Error
                                        $reportPath, `          # Path for the report (isReport)
                                        $logging, `             # Logging features
                                        $isReport, `            # Output should be in the report file
                                        $captureSTDOUT, `       # Capture the output from the CMDLet to a variable
                                        $description, `         # Reason for why we are executing the CMDLet
                                        [ref] $callBack, `      # Store the output result in this variable
                                        [ref] $cacheSTDOUT, `   # CMDLet's STDOUT results provided in this var.
                                        [ref] $cacheSTDERR);    # CMDLet's STDERR results provided in this var.

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
    #  This function will allow the ability to write data given
    #   to a specific file.
    #
    #  NOTE: The encoding of the textfile will be set as Default.
    #   Default, at the time of writing this, is Unicode.
    # -------------------------------
    # Input:
    #  [string] File
    #   The exact file that will be written too.
    #   - NOTE: This must include the absolute path and the file
    #            name (including extension).  For example:
    #           "C:\Fake\Path\NewASCIIFile.txt"
    #  [ref] Contents
    #   The information (or data) that will be written to the file
    #    specified.
    #   - NOTE: Trying to conserve main memory space by using referencing.
    #            Size can be at maximum of 2GB of space. (Defined by CLR)
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure to create and\or write to file.
    #    $true = Successfully wrote to the file.
    # -------------------------------
    #>
    static [bool] WriteToFile([string] $file, `     # Target file to write
                            [ref] $contents, `      # Information (or data) to write in file
                            [bool] $logging)        # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.
        [int] $outFilePropertyWidth = 80;              # Width property to be used for the Out-File CMDLet.
                                                       #  This will only allow the so many characters per-line.
        [string] $outFilePropertyEncoding = "default"; # Encoding property to be used for the Out-File CMDLet.
                                                       #  This specifies what encoding the text file should be
                                                       #  upon creation.
        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;                  # The initial message to be logged.
        [string] $logAdditionalMSG = $null;            # Additional information provided.
        # ----------------------------------------


        # Try to write contents to the file.
        try
        {
            # Try to write the information to the file
            Out-File -LiteralPath "$($file)" `
                     -Encoding $outFilePropertyEncoding `
                     -InputObject "$($contents.Value.ToString())" `
                     -NoClobber `
                     -Append `
                     -Width $outFilePropertyWidth;
        } # Try : Write to file

        catch
        {
            # Immediately cache the reason why the command failed.
            $executeFailureMessage = "$($_)";

            # Prep a message to display to the user for this error; temporary variable
            [string] $tempErrorMessage = ("Failed to write data to file!`r`n" + `
                                        "Failure reason: $($executeFailureMessage)");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("File to write: $($file)`r`n" + `
                                    "`tContents to write: $($contents.Value.ToString())`r`n" + `
                                    "`tFailed to execute reason: $($executeFailureMessage)");

                # Generate the message
                $logMessage = "A failure has occurred upon writing data to file!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

            # * * * * * * * * * * * * * * * * * * *


            # Operation failed
            return $false;
        } # Catch : Failure to write


        # Assurance Fail-Safe; make sure that the file was successfully created on the filesystem.
        if ([IOCommon]::CheckPathExists("$($file)", $logging) -eq $false)
        {
            # Operation failed because the file does not
            #  exist on the secondary storage.
            return $false;
        } # if : file didn't exist (after write)


        # Operation was successful
        return $true;
    } # WriteToFile()




   <# Create a Portable Document File (PDF)
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to create a PDF
    #   file by taking the existing text document (*.txt) and
    #   generating a PDF file as the output.  Thus, a source
    #   file must already exist and is ready to be read.  If
    #   the file does not exist or can not be read, it is then
    #   impossible to create a PDF file.
    #
    #  - DEPENDENCY NOTE: This function requires Microsoft Word
    #                      to be installed on the host-system.
    #
    #  DEV.NOTE: iTextSharp, 3rd party API, is possible to use
    #             instead of Microsoft Word.  My goal is to keep
    #             all external dependencies at a minimal as much as
    #             possible and avoid external conflicts.  Other
    #             developers are free to change this dependency as
    #             you (pl) see fit, all I ask is to please keep in
    #             mind of the licensing when implementing such
    #             feature.
    #
    #  Resources:
    #   This helps greatly with how to implement this feature.
    #   - https://stackoverflow.com/a/23894977
    #   Microsoft Word API Commands
    #   - https://docs.microsoft.com/en-us/office/vba/api/word.application
    # -------------------------------
    # Input:
    #  [string] Source File
    #   The source text document that will be reflected to the PDF file.
    #   - NOTE: This must include the absolute path to the source file.
    #            For example: "C:\Fake\Path\TargetFile.txt"
    #  [string] Destination File
    #   The destination path and filename of the PDF file.
    #   - NOTE: This must include an absolute path and the file
    #            name (including extension).  For example:
    #           "C:\Fake\Path\NewReport.pdf"
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to create the PDF file.
    #    $true = Successfully created the PDF file.
    # -------------------------------
    #>
    Static [bool] CreatePDFFile([string] $sourceFile, `         # The target file that contains information to insert in the PDF file.
                                [string] $destinationFile, `    # The location to save the PDF file.
                                [bool] $logging)                # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [float] $wordVersion = 0.0;         # Microsoft Word Version
                                            #  This may not be needed, but just in case if there is
                                            #  differences in other versions - we can try to deter
                                            #  conflicts and correct the behavior if possible.
        [int] $wordPDFCode = 17;            # The code to export a document in PDF format.
                                            #  https://docs.microsoft.com/en-us/office/vba/api/word.wdexportformat
        [string] $executeFailureMessage = $null;       # If the command fails to properly execute, the reason for the
                                                       #  failure might be available from the PowerShell engine.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;       # The initial message to be logged.
        [string] $logAdditionalMSG = $null; # Additional information provided.
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Check to make sure that the source file actually exists.
        if ([IOCommon]::CheckPathExists("$($sourceFile)", $logging) -eq $false)
        {
            # Prep a message to display to the user for this error; temporary variable
            [string] $tempErrorMessage = ("Unable to create a PDF file; source file does not exist!`r`n" + `
                                        "Source file: $($sourceFile)");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("Source file: $($sourceFile)`r`n" + `
                                    "`tDestination file: $($destinationFile)");

                # Generate the message
                $logMessage = "Unable to create a PDF file as the source file does not exist!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

            # * * * * * * * * * * * * * * * * * * *


            # The source file does not exist; nothing can be done.
            return $false;
        } # if : source file didn't exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Detect Microsoft Word
        # -------------------
        # +++++++++++++++++++


        # First try to see if the host system has Microsoft Word installed,
        #  if so, we can proceed through the rest of this function, otherwise
        #  we have to immediately stop.
        if ($(Test-Path HKLM:SOFTWARE\Classes\Word.Application) -eq $true)
        {
            # Microsoft Word was detected; try to create a new instance
            #  of the process.
            try
            {
                # Try to create the object instance
                [System.__ComObject] $msWord = New-Object -ComObject Word.Application;
            } # Try : Create MS Word Instance

            catch
            {
                # The host system may not have Microsoft Word ready to be
                #  use or has a Microsoft Word version that is not
                #  compatible with PowerShell integration.

                # Immediately cache the reason why the command failed.
                $executeFailureMessage = "$($_)";

                # Prep a message to display to the user for this error; temporary variable
                [string] $tempErrorMessage = ("Unable to create a new instance of Microsoft Word.`r`n" + `
                                            "Failure reason: $($executeFailureMessage)");


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # If Logging is enabled, obtain the additional information.
                if ($logging)
                {
                    # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                    # Capture any additional information
                    $logAdditionalMSG = ("Unable to create a new instance of Microsoft Word.`r`n" + `
                                        "`tSource File: $($sourceFile)`r`n" + `
                                        "`tAdditional Error Message: $($executeFailureMessage)");

                    # Generate the message
                    $logMessage = "Unable to create a new instance of Microsoft Word.";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
                } # If: Debugging

                # Else - Debugging features are not enabled
                else
                {
                    # If logging is disabled, write directly to the user's display.
                    [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
                } # Else: Debugging Disabled

                # * * * * * * * * * * * * * * * * * * *

                # Because we couldn't get an instance of
                #  MS Word, we can not continue any further.
                return $false;
            } # Catch : Failure to create MS Word Instance
        } # If : Microsoft Word Installed \ Ready

        # Microsoft Word was not detected or is not compatible with PowerShell
        #  integration.
        else
        {
            # Immediately cache the reason why the command failed.
            $executeFailureMessage = "$($_)";

            # Prep a message to display to the user for this error; temporary variable
            [string] $tempErrorMessage = ("Unable to find a modern version Microsoft Word; unable to create a PDF.`r`n" + `
                                            "Failure reason: $($executeFailureMessage)");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("The host system does not have (or unable to detect) a modern version of Microsoft Word.`r`n" + `
                                    "`tSource File: $($sourceFile)`r`n" + `
                                    "`tAdditional Error Message: $($executeFailureMessage)");

                # Generate the message
                $logMessage = "Unable to find a modern version of Microsoft Word!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

            # * * * * * * * * * * * * * * * * * * *


            # Because we couldn't find Microsoft Word, we can not create a PDF file.
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
        #  https://blogs.technet.microsoft.com/heyscriptingguy/2006/08/31/how-can-i-set-the-document-orientation-in-microsoft-word-to-landscape/

        # Set the document's orientation to 'Landscape'.
        $wordDocument.PageSetup.Orientation = 1;



        # Export the Document
        # -------------------
        # +++++++++++++++++++


        # Export the document; create the PDF file
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
        if ([IOCommon]::CheckPathExists("$($destinationFile)", $logging) -eq $false)
        {
            # Prep a message to display to the user for this error; temporary variable
            [string] $tempErrorMessage = "Successfully created the PDF file as requested, but unable to find it....";


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("Source file: $($sourceFile)`r`n" + `
                                    "`tDestination file: $($destinationFile)");

                # Generate the message
                $logMessage = "The PDF file was created successfully but unable to find the PDF file at the destination path!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

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
    #  This function will create a temporary directory in the
    #   user's roaming profile (%TEMP%) directory.  This
    #   functionality can be useful for storing temporary
    #   program data.  When we are finished with this directory,
    #   we must discard it properly.  If incase the directory
    #   was never expunged, it is possible that the user can
    #   remove it using such tools as 'Clean Manager' or the
    #   Metro variant in Windows 10.
    #   Examples of usage:
    #    1 - Organizing data before compacting them in an
    #         archive data file.
    #    2 - Extracting the data to a temporary location,
    #         after completion - ask user where to store
    #         their data.
    #    3 - Hold large program generated files for further
    #         processing (queued) without wasting system's
    #         main memory resources.
    #
    # Directory Naming Scheme Note:
    #  The directory must be unique, we can NEVER have
    #   duplicated directories to assure that the data is
    #   correct.  With that in mind, we will have to think
    #   of the future and past tenses.  Meaning, we will need
    #   to assert the 'What-If' card.
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
    #        was synchronized by the remote server, with that
    #        change - the directory contains the EXACT same
    #        name (combined with date and time). 
    #     - I'm probably thinking too much?
    #   But with this in mind, we must assure that the directory
    #   name is unique at all times.
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
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to create the temporary directory.
    #    $true = Successfully created temporary the directory.
    # -------------------------------
    #>
    static [bool] MakeTempDirectory([string] $keyTerm, `    # Operation Key (Noun or Verb)
                                    [ref] $directoryPath, ` # Absolute path of the newly created directory
                                    [bool] $logging)        # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $tempDirectoryPath = $null;   # Absolute Path of the Temporary directory.
        [string] $tempDirectoryName = $null;   # The name of the directory that we are going
                                               #  to create.
        [string] $finalDirectoryPath = $null;  # This will hold the complete absolute path
                                               #  to the new requested directory.
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
        # Debugging [Logging]
        [string] $logMessage = $null;          # The initial message to be logged.
        [string] $logAdditionalMSG = $null;    # Additional information provided.
        # ----------------------------------------



        # Initialize the Variables
        # - - - - - - - - - - - - - -
        #  Initialize the variables so that they can be used
        #   in the operations later on.
        # ---------------------------


        # First, we are going to build up the destination path.
        #  We will use an environment variable to get the user's
        #  %TEMP% directory, then we will attach the program's
        #  name as part of the directory name.
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
        #  Make sure that this program has a directory within
        #   the user's %TEMP%.  If it does not exist - create
        #   it, otherwise move forward.  However, if the
        #   %Temp% directory is locked, this entire operation
        #   will be aborted.
        #  This directory is important as it will help to keep
        #   all of the sub-directory temporary directories
        #   housed in one location -- greatly helps to keep
        #   everything clean and organized.
        # ---------------------------


        # First, does the directory already exist?
        if ($([IOCommon]::CheckPathExists("$($tempDirectoryPath)", $logging)) -eq $false)
        {
            # Because the directory does not exist, try to create it.
            if ($([IOCommon]::MakeDirectory("$($tempDirectoryPath)", $logging)) -eq $false)
            {
                # Prep a message to display to the user for this error; temporary variable.
                [string] $tempErrorMessage = "Unable to create a temporary directory!";


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # If Logging is enabled, obtain the additional information
                if ($logging)
                {
                    # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                    # Capture any additional information
                    $logAdditionalMSG = ("Possible symptoms:`r`n" + `
                                        "`t- Directory exceeds Character limit or depth limit (Root -> Leaf)`r`n" + `
                                        "`t- The user's temporary roaming directory (%TEMP%) could be locked.`r`n" + `
                                        "`t- Insufficient writing privileges within the temporary roaming directory (%TEMP%).`r`n" + `
                                        "`tPath of the parent temporary directory: $($tempDirectoryPath)");

                    # Generate the message
                    $logMessage = "$($tempErrorMessage)";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
                } # If: Debugging

                # Else - Debugging features are not enabled
                else
                {
                    # If logging is disabled, write directly to the user's display.
                    [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
                } # Else: Debugging Disabled

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
        # Try to create the requested directory within the user's
        #  roaming profile %TEMP% directory.  If in case all else
        #  fails, we must abort the operation.
        # Reasons for failure:
        #  - Directory is locked (write access)
        #  - Depth exceeds NTFS requirements
        #     (256char from root to leaf)
        #  - Directory and all repetitions exists
        #     (Something is SERIOUSLY wrong)
        # ---------------------------

        # First, we should check if the directory already exists.
        #  If the directory already exists, try to make it unique.
        if ($([IOCommon]::CheckPathExists("$($finalDirectoryPath)", $logging)) -eq $true)
        {
            # Because the directory already exists, we need to make
            #  it unique to avoid data conflicts.

            # This variable will help us break out of the loop if
            #  we can successfully find a unique name.  Otherwise,
            #  we reached a failure.
            [bool] $status = $true;

            # Find a unique name
            while($status)
            {
                if($([IOCommon]::CheckPathExists("$($finalDirectoryPath).$($repetitionCount)", $logging)) -eq $false)
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

                    # Prep a message to display to the user for this error; temporary variable.
                    [string] $tempErrorMessage = "Failed to create a unique temporary directory!";


                    # If logging is enabled, obtain the additional information
                    if ($logging)
                    {
                        # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                        [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                        # Capture any additional information
                        $logAdditionalMSG = ("Reached repetition max threshold!`r`n" + `
                                            "`tRepetition Max Limit is: $($repetitionMax)" + `
                                            "`tRepetition Counter is: $($repetitionCount)");

                        # Generate the message
                        $logMessage = "$($tempErrorMessage)";

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
                    } # If: Debugging

                    # Else - Debugging features are not enabled
                    else
                    {
                        # If logging is disabled, write directly to the user's display.
                        [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
                    } # Else: Debugging Disabled

                    # * * * * * * * * * * * * * * * * * * *


                    # Leave this function with an error.
                    return $false;
                } # Inner-Else : Check if Max Reached

                # Increment the counter
                $repetitionCount = $repetitionCount + 1;
            } # while : trying to find unique name
        } # if : Directory already Exists



        # Now that we have the name of the temporary sub-directory, create it
        if ($([IOCommon]::MakeDirectory("$($finalDirectoryPath)", $logging)) -eq $false)
        {
            # Prep a message to display to the user for this error; temporary variable.
            [string] $tempErrorMessage = "Unable to create a temporary directory!"


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information.
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = ("Possible Symptoms:`r`n" + `
                                    "`t- Directory exceeds Character limit or depth limit (Root -> Leaf)`r`n" + `
                                    "`t- The user's temporary roaming directory (%TEMP%) could be locked.`r`n" + `
                                    "`t- Insufficient writing privileges within the temporary roaming directory (%TEMP%).`r`n" + `
                                    "`tPath of the temporary directory: $($finalDirectoryPath)");

                # Generate the message
                $logMessage = "$($tempErrorMessage)";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

            # * * * * * * * * * * * * * * * * * * *


            # There was a failure while creating the directory.
            return $false;
        } # if : Failure Creating Directory



        # Just for assurance sakes, does the directory exist?
        if ($([IOCommon]::CheckPathExists("$($finalDirectoryPath)", $logging)) -eq $false)
        {
            # Prep a message to display to the user for this error; temporary variable.
            [string] $tempErrorMessage = "Created the temporary directory but unable to found it....";


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                # Capture any additional information
                $logAdditionalMSG = "Path of the temporary directory: $($finalDirectoryPath)";

                # Generate the message
                $logMessage = "Successfully created the temporary directory but it was not found in the final destination path!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # Else - Debugging features are not enabled
            else
            {
                # If logging is disabled, write directly to the user's display.
                [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
            } # Else: Debugging Disabled

            # * * * * * * * * * * * * * * * * * * *


            # Because the directory does not exist, we cannot
            #  simply use something that isn't there.
            return $false;
        } # if : Directory does not exist



        # Finalizing and Concluding
        # - - - - - - - - - - - - - -
        # Now that everything was set up and we now have the
        #  directory ready for general use now, we will do the
        #  final touches and close this function successfully.
        # ---------------------------


        # Record the absolute directory name; so the previous
        #  function may utilize it.
        $directoryPath.Value = "$($finalDirectoryPath)";


        # Successfully finished with this function
        return $true;
    } # MakeTempDirectory()




   <# Make a New Directory
    # -------------------------------
    # Documentation:
    #  This function will create a new directory with the
    #   desired absolute path provided.
    # -------------------------------
    # Input:
    #  [string] Absolute Path
    #   The absolute path of a directory that is to be created
    #    within the filesystem.
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to create the directory.
    #    $true = Successfully created the directory.
    #            OR
    #            Directory already exists; nothing to do.
    # -------------------------------
    #>
    static [bool] MakeDirectory([string] $path, `   # Absolute path of the directory to create
                                [bool] $logging)    # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;       # If the command fails to properly
                                                       #  execute, the reason for the failure
                                                       #  might be available from the PowerShell
                                                       #  engine.
        [bool] $exitCode = $true;                      # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;                  # The initial message to be logged.
        [string] $logAdditionalMSG = $null;            # Additional information provided.
        # ----------------------------------------


        # Check to see if the path already exists; if it already exists -
        #  then there's nothing to done.  If it does not exist, however,
        #  then try to create it.
        if (([IOCommon]::CheckPathExists("$($path)", $logging)) -eq $false)
        {
            # The requested path does not exist, try to create it.
            try
            {
                # Try to create the directory; if failure - stop.
                New-Item -Path "$($path)" -ItemType Directory -ErrorAction Stop;


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # If Logging is enabled, obtain the additional information.
                if ($logging)
                {
                    # Capture any additional information
                    $logAdditionalMSG = "Directory Path: $($path)";

                    # Generate the message
                    $logMessage = "Successfully created the directory!";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Verbose");
                } # If: Debugging

                # * * * * * * * * * * * * * * * * * * *


            } # try : Create directory.

            catch
            {
                # Immediately cache the reason why the command failed.
                $executeFailureMessage = "$($_)";

                # Prep a message to display to the user for this error; temporary variable
                [string] $tempErrorMessage = ("Failed to create the required directory!`r`n" + `
                                            "Reason for failure: $($executeFailureMessage)");


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # If Logging is enabled, obtain the additional information
                if ($logging)
                {
                    # Display a message to the user that something went horribly wrong and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($tempErrorMessage)", "Error");


                    # Capture any additional information
                    $logAdditionalMSG = ("Directory Path: $($path)`r`n" + `
                                        "`tAdditional Error Message: $($executeFailureMessage)");

                    # Generate the message
                    $logMessage = "Failed to create the directory by request!";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
                } # If: Debugging

                # Else - Debugging features are not enabled
                else
                {
                    # If logging is disabled, write directly to the user's display.
                    [IOCommon]::WriteToBuffer("$($tempErrorMessage)", "Error");
                } # Else: Debugging Disabled

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
    #  This function will check if the provided directory's path
    #   (absolute path) exists within the host's filesystem.
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The path of the directory to check if it exists.
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Directory does not exist.
    #    $true = Directory exist
    # -------------------------------
    #>
    static [bool] CheckPathExists([string] $path, `     # The absolute path of the directory to check
                                [bool] $logging)        # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;    # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;       # The initial message to be logged.
        [string] $logAdditionalMSG = $null; # Additional information provided.
        # ----------------------------------------


        # Check if the path exists
        if((Test-Path -LiteralPath "$($path)" -ErrorAction SilentlyContinue) -eq $true)
        {
            # Directory exists
            $exitCode = $true;
        } # If : Directory exists


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # If Logging is enabled, obtain the additional information
        if ($logging)
        {
            # Capture any additional information
            $logAdditionalMSG = "$($_)";

            # Generate the message
            $logMessage = "Tried to find the path named $($path), the detected result was $($exitCode)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Verbose");
        } # If: Debugging

        # * * * * * * * * * * * * * * * * * * *


        # Return with exit code
        return $exitCode;
    } # CheckPathExists()




   <# Delete Directory
    # -------------------------------
    # Documentation:
    #  This function will forcefully expunge a specific directory
    #   recursively within it's hierarchy.  Meaning that any
    #   existing data-files or sub-directories - will be thrashed
    #   without any warning prompted to the end-user.  Please be
    #   sure you are using this function correctly.
    #
    #  WARNING NOTES:
    #   The following flags are enabled in this function:
    #    - Recursive
    #    - Forceful
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The absolute path of the directory that we want to delete (and any contents inside).
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to delete the directory.
    #    $true = Successfully deleted the directory
    #            OR
    #            Directory does not exist
    # -------------------------------
    #>
    static [bool] DeleteDirectory([string] $path, ` # The absolute path of the target directory
                                [bool] $logging)    # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;            # If the command fails to properly
                                                            #  execute, the reason for the failure
                                                            #  might be available from the PowerShell
                                                            #  engine.
        [bool] $exitCode = $false;                          # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;                       # The initial message to be logged.
        [string] $logAdditionalMSG = $null;                 # Additional information provided.
        [LogMessageLevel] $logMessageLevel = "Standard";    # The level of the message.
        # ----------------------------------------


        # First check to see if the directory actually exists,
        #  if not, then there is nothing to do.
        if(([IOCommon]::CheckPathExists("$($path)", $logging)) -eq $false)
        {
            # The directory does not exist, there's nothing to do.
            #  Because the directory does not exist (with the given path),
            #  there was no real error - just return as successful.
            return $true;
        } # Check if Directory Exists.


        # Try to delete the directory
        try
        {
            # Remove the directory.
            Remove-Item -LiteralPath "$($path)" `
                        -Force `
                        -Recurse `
                        -ErrorAction Stop;

            # Successfully deleted the requested directory.
            $exitCode = $true;
        } # Try : Delete Directory

        catch
        {
            # A failure occurred while deleting the requested directory.
            $exitCode = $false;
        } # Catch : Error Deleting Directory


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # If Logging is enabled, obtain the additional information
        if ($logging)
        {
            # Immediately cache any useful information left in the pipe.
            $executeFailureMessage = "$($_)";

            # If the operation was successful; generate the appropriate message
            if ($exitCode)
            {
                # Because the operation was successful, create a successful message

                # Capture any additional information
                $logAdditionalMSG = "Directory to delete: $($path)";

                # Generate the message
                $logMessage = "Successfully deleted the requested directory!";

                # Update the Message Level as 'Verbose'
                $logMessageLevel = "Verbose";
            } # Inner-If: Operation was successful

            # If the operation failed; generate a failed message
            else
            {
                # Because the operation had failed, create a failure message

                # Capture any additional information
                $logAdditionalMSG = ("Directory to delete: $($path)`r`n" + `
                                    "`tAdditional error information:`r`n" + `
                                    "`t`t$($executeFailureMessage)");

                # Generate the message
                $logMessage = "Failed to delete the requested directory!";

                # Update the Message Level as 'Error'
                $logMessageLevel = "Error";
            } # Inner-Else: Operation had failed


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # The initial message
                                        "$($logAdditionalMSG)", `   # Any additional provided
                                        "$($logMessageLevel)");     # The Message level
        } # If: Debugging

        # * * * * * * * * * * * * * * * * * * *


        # Return with exit code
        return $exitCode;
    } # DeleteDirectory()




   <# Delete File
    # -------------------------------
    # Documentation:
    #  This function will forcefully delete an individual
    #   file or a specific set of files given by a specific
    #   criteria.  It can be possible to provide a specific
    #   list of files to delete or provide a generic range,
    #   such as using a wildcard.  However, all 'included'
    #   files must be in the same directory.  If the files
    #   requested to be deleted are in different directories,
    #   it is not possible to remove them.  The includes
    #   parameter only allows for the filename(s) or set
    #   ranges, no path is specified other than the requesting
    #   directory that we want to inspect.
    #
    #  WARNING NOTES:
    #   The following flags are enabled in this function:
    #   - Forceful
    # -------------------------------
    # Input:
    #  [string] Directory (Absolute Path)
    #    The directory that contains the data files that we
    #     want to expunge.
    #    - NOTE: DO NOT PUT THE ACTUAL FILE PATH OR PATH OF
    #            FILES HERE, USE 'Includes' FOR THIS!
    #  [string[]] Includes
    #    What specific requirements must a file have in order
    #     to be classified to be deleted.  Specific filenames
    #     are acceptable.
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failed to delete the requested files.
    #    $true = Successfully deleted the requested files
    #            OR
    #            No operation was done
    # -------------------------------
    #>
    static [bool] DeleteFile([string] $path,        # Path of the directory to inspect
                            [string[]] $includes,   # List of files or requirements
                            [bool] $logging)        # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $executeFailureMessage = $null;            # If the command fails to properly
                                                            #  execute, the reason for the failure
                                                            #  might be available from the PowerShell
                                                            #  engine.
        [bool] $exitCode = $false;                          # Exit code that will be returned.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;                       # The initial message to be logged.
        [string] $logAdditionalMSG = $null;                 # Additional information provided.
        [LogMessageLevel] $logMessageLevel = "Standard";    # The level of the message.
        # ----------------------------------------


        # First check to see if the directory actually exists,
        #  if not, then there is nothing to do.
        if(([IOCommon]::CheckPathExists("$($path)", $logging)) -eq $false)
        {
            # The directory does not exist, there's nothing to do.
            #  Because the directory does not exist (with the provided path),
            #  there was no real error - just return as successful.
            return $true;
        } # Check if Directory Exists.


        # Try to delete the requested files from the provided directory.
        try
        {
            # Remove the requested files.
            Remove-Item -Path "$($path)\*" `
                        -Include $($includes) `
                        -Force `
                        -ErrorAction Stop;

            # Successfully deleted the file(s)
            $exitCode = $true;
        } # Try : Delete Files

        catch
        {
            # A failure occurred while deleting the requested file(s).
            $exitCode = $false;
        } # Catch : Error Deleting Files


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # If Logging is enabled, obtain the additional information
        if ($logging)
        {
            # Immediately cache any useful information left in the pipe.
            $executeFailureMessage = "$($_)";

            # If the operation was successful; generate the appropriate message
            if ($exitCode)
            {
                # Because the operation was successful, create a successful message

                # Capture any additional information
                $logAdditionalMSG = ("Directory that was inspected: $($path)" ` +
                                    "`tFile(s) that were deleted:`r`n" + `
                                    "`t`t$($includes.ToString())");

                # Generate the message
                $logMessage = "Successfully deleted the requested file(s)!";

                # Update the Message Level as 'Verbose'
                $logMessageLevel = "Verbose";
            } # Inner-If: Operation was successful

            # If the operation failed; generate a failed message
            else
            {
                # Because the operation had failed, create a failure message

                # Capture any additional information
                $logAdditionalMSG = ("Directory that was inspected: $($path)" ` +
                                    "`tFile(s) requested to be deleted:`r`n" + `
                                    "`t`t$($includes.ToString())" + `
                                    "`tAdditional error information:`r`n" + `
                                    "`t`t$($executeFailureMessage)");

                # Generate the message
                $logMessage = "Failed to delete the requested file(s)!";

                # Update the Message Level as 'Error'
                $logMessageLevel = "Error";
            } # Inner-Else: Operation had failed


            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # The initial message
                                        "$($logAdditionalMSG)", `   # Any additional provided
                                        "$($logMessageLevel)");     # The Message level
        } # If: Debugging

        # * * * * * * * * * * * * * * * * * * *


        # Return with exit code
        return $exitCode;
    } # DeleteFile

    #endregion


    #region File Integrity

   <# File Hash
    # -------------------------------
    # Documentation:
    #  This function will provide a hash value in respect
    #   to the data-file requested.
    # -------------------------------
    # Input:
    #  [string] File (Absolute Path)
    #   The absolute path of the data-file that we want to
    #    inspect.
    #  [string] Hash Algorithm
    #   Typical values can be: "MD5" or "SHA1".
    #    For a complete list of hash algorithms, please check the documentation:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    # Output:
    #  [string] Hash Value code
    #    ERROR VALUES:
    #     $null
    #     File does not exist
    #     OR
    #     Unknown hash algorithm requested
    # -------------------------------
    #>
    static [string] FileHash([string] $path, `          # Absolute path of the target file
                            [string] $hashAlgorithm, `  # Hash algorithm requested
                            [bool] $logging)            # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $hashValue = $null;      # The hash value regarding specified file.

        # SPECIAL OBJECTS
        # - - - - - - - -

        # FileHashInfo; used for capturing the hash information from a specific data file.
        $hashInfo = New-Object -TypeName Microsoft.PowerShell.Commands.FileHashInfo;

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;       # The initial message to be logged.
        [string] $logAdditionalMSG = $null; # Additional information provided.
        # ----------------------------------------


        # First, check if the file actually exists within the user's filesystem
        if ([IOCommon]::CheckPathExists("$($path)", $logging) -eq $false)
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
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Requested file: $($path)`r`n" + `
                                    "`tRequested Hash Algorithm: $($hashAlgorithm)");

                # Generate the message
                $logMessage = "The requested hash algorithm is not supported!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

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
            $hashInfo = Get-FileHash -LiteralPath "$($path)" `
                                    -Algorithm "$($hashAlgorithm)" `
                                    -ErrorAction Stop;

            # From the cache data, get the hash and save it.
            $hashValue = $hashInfo.Hash;
        } # Try : Get hash value

        # Catch if an error occurred
        catch
        {
            # Failure to obtain the hash value.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Requested file: $($path)`r`n" + `
                                    "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                    "`tAdditional Information:`r`n" + `
                                    "`t`t$($_)");

                # Generate the message
                $logMessage = "A failure occurred while trying to get the hash value!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", "$($logAdditionalMSG)", "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Return null as an error occurred.
            $hashValue = $null;
        } # Catch : Failure to fetch value


        # Return the hash value of the file - if it was present.
        return "$($hashValue)";
    } # FileHash()




   <# Supported Hash Algorithms
    # -------------------------------
    # Documentation:
    #  This function will check to make sure that the requested
    #   hash algorithm is supported in the .NET Framework.
    #
    #  List of available Hash Algorithms:
    #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash
    # -------------------------------
    # Input:
    #  [string] Requested Hash Algorithm
    #    This will contain the requested hash algorithm to be tested
    #     against the known supported algorithms used in the .NET
    #     Framework.
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


        # Compare the requested hash algo. to the list of supported algorithms.
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
    #  This function will provide the ability to access a specific
    #   webpage on request.  In order to access the webpage, we will
    #   merely try to use the default or preferred web browser that
    #   is set by the host or user settings of the current system
    #   environment.
    # -------------------------------
    # Input:
    #  [string] Web Site's URL Address
    #   The webpage that we want to access; URL or IP address of the
    #    server (or service) we want to access.
    #  [bool] Logging [Debugging]
    #   When true, the logging functionality will be enabled.
    #    The logging functionality merely captures any detailed
    #    information, which is then placed in a log file that
    #    is specified in the Logging implementation.
    # -------------------------------
    #  [bool] Exit code
    #    $false = Failed to access webpage.
    #    $true = Successfully accessed webpage.
    # -------------------------------
    #>
    static [bool] AccessWebpage([string] $URLAddress, `     # URL or IP Address of the webpage
                                [bool] $logging)            # Logging features
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $exitCode = $false;          # The operation exit code.

        # * * * * * * * * * * * * * * * * * * *
        # Debugging [Logging]
        [string] $logMessage = $null;       # The initial message to be logged.
        [string] $logAdditionalMSG = $null; # Additional information provided.
        # ----------------------------------------


        # Make sure that the URL Address provided is an actual legitimate URL address.
        if ((($URLAddress -like 'http://*') -eq $true) -or `
            (($URLAddress -like 'www.*') -eq $true))
        {
            # The address is legal.
            # Try to open the web site
            try
            {
                # Open the webpage
                Start-Process -FilePath "$($URLAddress)" `
                            -ErrorAction Stop;

                # Update the exit code status
                $exitCode = $true;
            } # Try : Execute Task

            catch
            {
                # An error occurred while trying to open the requested web-page


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # If Logging is enabled, obtain the additional information
                if ($logging)
                {
                    # Capture any additional information
                    $logAdditionalMSG = ("Tried to open requested webpage:`r`n" + `
                                        "`t`t$($URLAddress)`r`n" + `
                                        "`tAdditional Information:" + `
                                        "`t`t$($_)");

                    # Generate the message
                    $logMessage = "A failure occurred while trying to access the requested webpage!";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", `
                                                "$($logAdditionalMSG)", `
                                                "Error");
                } # If: Debugging

                # * * * * * * * * * * * * * * * * * * *


                # Update the exit code status.
                $exitCode = $false;
            } # Catch : Error
        } # If : URL Address is Legitimate

        else
        {
            # The address was not legal


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # If Logging is enabled, obtain the additional information
            if ($logging)
            {
                # Capture any additional information
                $logAdditionalMSG = ("Tried to open webpage:`r`n" + `
                                    "`t`t$($URLAddress)");

                # Generate the message
                $logMessage = "The requested webpage is not a valid URL or IP address!";

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `
                                            "$($logAdditionalMSG)", `
                                            "Error");
            } # If: Debugging

            # * * * * * * * * * * * * * * * * * * *


            # Update the exit code status.
            $exitCode = $false;
        } # Else : URL Address is NOT Legitimate



        # Return the operation status
        return $exitCode;
    } # AccessWebpage()
    #endregion
} # IOCommon