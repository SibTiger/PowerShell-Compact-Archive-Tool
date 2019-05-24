<# PowerShell Event System
 # ------------------------------
 # ==============================
 # ==============================
 # This class contains special functions that relates
 #  to using the event system in the PowerShell engine.
 #  Functions within this class primarily handles with
 #  customized PowerShell events.  For more information
 #  regarding events:
 #   - Creating new custom events [CMDLet: New-Event]
 #     https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-event
 #   - Unregistering an event [CMDLet: Unregister-Event]
 #     https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/unregister-event
 #   - How to implement event handling in PowerShell with classes
 #     https://stackoverflow.com/questions/55527673/how-to-implement-event-in-powershell-with-classes
 #
 # !! Seriously, read this !!!
 # IMPORTANT EVENT SEQUENCING:
 #  Follow the order of operations to assure that the
 #   events will fire correctly within the PowerShell
 #   engine.
 #  1) In order to use events in PowerShell, you
 #      __MUST__ first register it.  Do remember that
 #      upon registering the event, the 'Action' code-block
 #      may determine if you need an entirely new function
 #      to handle a new functionality.
 #     NOTE: You can NOT contain non-automatic variables
 #      in the action block as they will NOT be initialized
 #      when the event is triggered!
 #  2) Events that are triggered - are processed in a
 #      sequential fashion, thus nothing here runs in
 #      parallel nor multi-processing.  One thread is used,
 #      no more.
 #  3) Unregister the event when you are finished with it.
 #      When terminating the PowerShell session or destroying
 #      objects that had previously registered an event to the
 #      PowerShell engine, you need to unregister it!  The only
 #      exceptions to this rule is if the PowerShell terminal
 #      was destroyed by the system API (or sigkill was issued).
 #      When this happens, all registeries and environment is
 #      expeditiously thrashed.
 #>




class Events
{
    #region Register Events

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

    #endregion



    #region Unregister Events

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
    #  [string] Nice Event Purpose
    #   A short noun or verb for the purpose for the event.
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
    static [bool] UnregisterEvent([string] $niceSourceName,
                                [string] $niceEventPurpose,
                                [string] $sourceIdent)
    {
        # Display a message on the screen that the logging event is being unregistered
        Write-Host "Trying to unregister the custom event [$($niceEventPurpose)] for the source name: $($niceSourceName). . .";

        # Remove the Custom Event for Logging
        try
        {
            # Try unregister the custom event
            Unregister-Event -Force -SourceIdentifier "$($sourceIdent)";

            # Display a message on the terminal screen that the event was unregistered successfully.
            Write-Host "Successfully unregistered the custom event [$($niceEventPurpose)] for the source name: $($niceSourceName)!";
    
            # Return successfully
            return $true;
        } # Try

        # Failure to unregister
        catch
        {
            # Display a message on the terminal screen that the event could not be successfully unregistered.
            Write-Host "Failed to unregister custom event [$($niceEventPurpose)] for the source name: $($niceSourceName)!";
    
            # Return an error
            return $false;
        } # Failure
    } # UnregisterEvent()

    #endregion



    #region Fire Event (Issue Signal)

   <# Trigger Event
    # -------------------------------
    # Documentation:
    #  This function will allow a centralized way of triggering an event for
    #   objects within this software.  This type of event trigger focuses on
    #   custom Powershell events that has already been registered to the POSH
    #   engine.
    # -------------------------------
    # Inputs:
    #  [string] Source Identifier
    #   The source identifier that has been registered and defines what
    #    object or source is triggering the event.
    #  [string] Message Data
    #   The primary reason for the event being triggered; the message
    #    containing some sort of data or information that will be carried
    #    over to a listening function as defined by the action of the
    #    source identifier that has been registered to the PowerShell engine.
    #  [string[]] Event Arguments
    #   Object of arguments that is to be carried over to the listening
    #    function that was defined by the action of the source identifier
    #    that has been registered to the PowerShell engine.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #    $false = Failure to trigger the custom event.
    #    $true = Successfully triggered the custom event.
    # -------------------------------
    #>
    static [bool] TriggerEvent ([string] $sourceIdent, [string] $msgData, [string[]] $eventArgs)
    {
        # Try to trigger the event to the PowerShell's engine.
        try
        {
            # Trigger the event
            New-Event -SourceIdentifier "$($sourceIdent)" `
                      -MessageData "$($msgData)" `
                      -EventArguments $eventArgs `
                      -ErrorAction Stop;

            # Successfully triggered the event.
            return $true;
        } # Try

        # Error occurred while triggering the event
        catch
        {
            # Failed to trigger the event.
            return $false;
        } # Failure
    } # TriggerEvent()




   <# Trigger Event [For Logging | Gateway Accessor]
    # -------------------------------
    # Documentation:
    #  This function allows the possibility of organizing how the log messages
    #   should be structured and sent to the Event Trigger parent function.
    #   This function was designed to help automatically provide a structured
    #   way handling how messages should be organized and packaged for the Event
    #   Trigger function.  Thus, in future means, when a new feature is added
    #   for logged messages - only this function is updated with minor alterations
    #   that require this function.
    # -------------------------------
    # Inputs:
    #  [string] Source Identifier
    #   The source identifier that has been registered and defines what
    #    object or source is triggering the event.
    #  [LogMessageLevel] The Message Level
    #   The level of the message that is about to be logged.  The level
    #    can be informational (or verbose), error, warning, etc.  This
    #    is only needed to help identify the severity of the message that
    #    is being logged.
    #  [string] Initial Message (Primary feedback or response)
    #   The primary reason for the event being triggered; the message
    #    containing some sort of data or information that will be carried
    #    over to a listening function as defined by the action of the
    #    source identifier that has been registered to the PowerShell engine.
    #  [string] Additional Information
    #   Additional information that is relating to the primary or the initial
    #    message that is being logged.  Additional information may contain
    #    readable data from PowerShell's engine as output, though some detailed
    #    messages may just contain verbose information.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #    $false = Failure to trigger the custom event.
    #    $true = Successfully triggered the custom event.
    # -------------------------------
    #>
    static [bool] TriggerEventLogging ([string] $sourceIdent,
                                    [LogMessageLevel] $levelMSG,
                                    [string] $initialMSG,
                                    [string] $additionalInfo)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Helps to organize how the object is to be structured for logging purposes.
        #  We need this object as we will pass additional data in the event system.
        $logEventArguments = New-Object `
                                -TypeName Object[] `
                                -ArgumentList 2;
        # ----------------------------------------

        # Setup the object-array to work with the specifications:
        #  Array Index Structure:
        #  [0] = Message Level
        #  [1] = Additional Information (Optional)
        $logEventArguments[0] = "$($levelMSG)";         # Log Message Level
        $logEventArguments[1] = "$($additionalInfo)";   # Log Additional Information

        # - - - -

        # Trigger the event and return the status code.
        return ([Events]::TriggerEvent("$($sourceIdent)", "$($initialMSG)", $logEventArguments));
    } # TriggerEventLogging()

    #endregion
} # Events