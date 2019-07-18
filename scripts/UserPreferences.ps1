<# User Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds the User Preferences within this
 #  program.  The user's preferences will give rise
 #  to what the user wants to do with this program
 #  and perform the task as the user's demands with
 #  minimal configuration after the first initial
 #  setup.  The goal of this program is to assure
 #  that the user can merely 'click-and-forget',
 #  thus the program should NOT stand in the way
 #  of the user's tasks.  With that in mind, it
 #  is paramount that the User Preferences should
 #  provide little headache as necessary; in-fact,
 #  all of the configurations within the classes
 #  provides that same principle.
 #>




class UserPreferences
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Singleton Instance

    hidden static [UserPreferences] $_instance = $null;

    # Get the instance of this singleton object (Default)
    static [UserPreferences] GetInstance()
    {
        # if there was no previous instance of the object - then create one.
        if ([UserPreferences]::_instance -eq $null)
        {
            # Create a new instance of the singleton object.
            [UserPreferences]::_instance = [UserPreferences]::new();
        }

        # Provide an instance of the object.
        return [UserPreferences]::_instance;
    } # GetInstance()




    # Get the instance of this singleton object (With Args)
    #  Useful if we already know that we have to instantiate
    #  a new instance of this particular object.
    static [UserPreferences] GetInstance([UserPreferencesCompressTool] $compressionTool,
                                        [string] $projectPath,
                                        [string] $outputBuildsPath,
                                        [bool] $useGitFeatures,
                                        [bool] $useWindowsExplorer,
                                        [bool] $useBell,
                                        [UserPreferencesEventAlarm] $notificationType)
    {
        # if there was no previous instance of the object - then create one.
        if ([UserPreferences]::_instance -eq $null)
        {
            # Create a new instance of the singleton object.
            [UserPreferences]::_instance = [UserPreferences]::new([UserPreferencesCompressTool] $compressionTool,
                                                                [string] $projectPath,
                                                                [string] $outputBuildsPath,
                                                                [bool] $useGitFeatures,
                                                                [bool] $useWindowsExplorer,
                                                                [bool] $useBell,
                                                                [UserPreferencesEventAlarm] $notificationType);
        }

        # Provide an instance of the object.
        return [UserPreferences]::_instance;
    } # GetInstance()

    #endregion




    #region Private Variables (emulated)

    # Compression Choice
    # ---------------
    # The choice of which tool to generate an archive-datafile.
    Hidden [UserPreferencesCompressTool] $__compressionTool;


    # Project Path
    # ---------------
    # The ZDoom based project in-which to compile.
    Hidden [string] $__projectPath;


    # Project Builds Path
    # ---------------
    # The builds output path.
    Hidden [string] $__outputBuildsPath;


    # Use Git Features
    # ---------------
    # When true, this program will try to use Git's features.
    Hidden [bool] $__useGitFeatures;


    # Use Windows Explorer
    # ---------------
    # When true, this program will try to use Windows Explorer
    #  to open directory paths; useful to show where the builds
    #  are located within the user's filesystem.
    Hidden [bool] $__useWindowsExplorer;


    # Use Bell [Alarm]
    # ---------------
    # When true, this program will send a 'ding' sound when an
    #  event takes place; errors, warnings, and\or successful
    #  operations.
    Hidden [bool] $__ringMyDingaling;


    # Bell Events
    # ---------------
    # The user can be able to pick which event is giving with an
    #  audible notification.
    Hidden [UserPreferencesEventAlarm] $__notificationType;


    # Object GUID
    # ---------------
    # Provides a unique identifier to the object, useful to
    #  make sure that we are using the right object within
    #  the software.
    Hidden [GUID] $__objectGUID;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    UserPreferences()
    {
        # Compression Tool
        $this.__compressionTool = 0;

        # Project Path
        $this.__projectPath = ".\";

        # Output Build Path
        $this.__outputBuildsPath = "$($global:_DIRECTORYOUTPUTROOT_)";

        # Use Git Features
        $this.__useGitFeatures = $true;

        # Use Windows Explorer
        $this.__useWindowsExplorer = $true;

        # Use Bell
        $this.__ringMyDingaling = $true;

        # Bell Events
        $this.__notificationType = 0;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # Default Constructor




    # User Preference : On-Load
    UserPreferences([UserPreferencesCompressTool] $compressionTool,
                    [string] $projectPath,
                    [string] $outputBuildsPath,
                    [bool] $useGitFeatures,
                    [bool] $useWindowsExplorer,
                    [bool] $useBell,
                    [UserPreferencesEventAlarm] $notificationType)
    {
        # Compression Tool
        $this.__compressionTool = $compressionTool;

        # Project Path
        $this.__projectPath = $projectPath;

        # Output Build Path
        $this.__outputBuildsPath = $outputBuildsPath;

        # Use Git Features
        $this.__useGitFeatures = $useGitFeatures;

        # Use Windows Explorer
        $this.__useWindowsExplorer = $useWindowsExplorer;

        # Use Bell
        $this.__ringMyDingaling = $useBell;

        # Bell Events
        $this.__notificationType = $notificationType;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

   <# Get Compression Tool Choice
    # -------------------------------
    # Documentation:
    #  Returns the value of the Compression Tool Choice variable.
    # -------------------------------
    # Output:
    #  [UserPreferencesCompressTool] Compression Tool Choice
    #   the value of the Compression Tool Choice.
    # -------------------------------
    #>
    [UserPreferencesCompressTool] GetCompressionTool()
    {
        return $this.__compressionTool;
    } # GetCompressionTool()




   <# Get Project Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Project Path variable.
    # -------------------------------
    # Output:
    #  [string] Project Path
    #   the value of the Project Path.
    # -------------------------------
    #>
    [string] GetProjectPath()
    {
        return $this.__projectPath;
    } # GetProjectPath()




   <# Get Project Builds Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the Project Builds Path variable.
    # -------------------------------
    # Output:
    #  [string] Project Builds Path
    #   the value of the Project Builds Path.
    # -------------------------------
    #>
    [string] GetProjectBuildsPath()
    {
        return $this.__outputBuildsPath;
    } # GetProjectBuildsPath()




   <# Get Use Git Features
    # -------------------------------
    # Documentation:
    #  Returns the value of the Use Git Features variable.
    # -------------------------------
    # Output:
    #  [bool] Use Git Features
    #   the value of the Use Git Features.
    # -------------------------------
    #>
    [bool] GetUseGitFeatures()
    {
        return $this.__useGitFeatures;
    } # GetUseGitFeatures()




   <# Get Use Windows Explorer
    # -------------------------------
    # Documentation:
    #  Returns the value of the Use Windows Explorer variable.
    # -------------------------------
    # Output:
    #  [bool] Use Windows Explorer
    #   the value of the Use Windows Explorer.
    # -------------------------------
    #>
    [bool] GetUseWindowsExplorer()
    {
        return $this.__useWindowsExplorer;
    } # GetUseWindowsExplorer()




   <# Get Use Bell
    # -------------------------------
    # Documentation:
    #  Returns the value of the Use Bell variable.
    # -------------------------------
    # Output:
    #  [bool] Use Bell
    #   the value of the Use Bell.
    # -------------------------------
    #>
    [bool] GetUseBell()
    {
        return $this.__ringMyDingaling;
    } # GetUseBell()



   <# Get Bell Events
    # -------------------------------
    # Documentation:
    #  Returns the value of the Bell Events variable.
    # -------------------------------
    # Output:
    #  [UserPreferencesEventAlarm] Bell Events
    #   the value of the Bell Events.
    # -------------------------------
    #>
    [UserPreferencesEventAlarm] GetBellEvents()
    {
        return $this.__notificationType;
    } # GetBellEvents()




   <# Get Object GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the object's Global Unique ID variable.
    # -------------------------------
    # Output:
    #  [GUID] Global Unique Idenifier (GUID)
    #   The value of the object's GUID.
    # -------------------------------
    #>
    [GUID] GetObjectGUID()
    {
        return $this.__objectGUID;
    } # GetObjectGUID()

    #endregion



    #region Setter Functions

   <# Set Compression Tool Choice
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Compression Tool Choice variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionTool([UserPreferencesCompressTool] $newVal)
    {
        # Because the value must fit within the
        #  'UserPreferencesCompressTool' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__compressionTool = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionTool()




   <# Set Project Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Project Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__projectPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetProjectPath()




   <# Set Project Builds Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Project Builds Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectBuildsPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__outputBuildsPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetProjectBuildsPath()




   <# Set Use Git Features
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Use Git Features variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUseGitFeatures([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__useGitFeatures = $newVal;

        # Successfully updated.
        return $true;
    } # SetUseGitFeatures()




   <# Set Use Windows Explorer
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Use Windows Explorer variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUseWindowsExplorer([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__useWindowsExplorer = $newVal;

        # Successfully updated.
        return $true;
    } # SetUseWindowsExplorer()




   <# Set Use Bell
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Use Bell variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetUseBell([bool] $newVal)
    {
        # Because the value is either true or false, there
        #  really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__ringMyDingaling = $newVal;

        # Successfully updated.
        return $true;
    } # SetUseBell()




   <# Set Bell Events
    # -------------------------------
    # Documentation:
    #  Sets a new value for the Bell Events variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetBellEvents([UserPreferencesEventAlarm] $newVal)
    {
        # Because the value must fit within the
        #  'UserPreferencesEventAlarm' datatype, there really is
        #  no point in checking if the new requested value is
        #  'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__notificationType = $newVal;

        # Successfully updated.
        return $true;
    } # SetBellEvents()

    #endregion
} # UserPreferences




<# User Preferences Compress Tool [ENUM]
 # -------------------------------
 # Associated with what type of compression tool
 #  should be used when wanting to compact a data
 #  into an archive-file.
 # -------------------------------
 #>
enum UserPreferencesCompressTool
{
    Default = 0;   # .NET
    SevenZip = 1;  # 7Za (CLI)
} # UserPreferencesCompressTool




<# User Preferences Event Alarm [ENUM]
 # -------------------------------
 # Associated with what type of audible notification
 #  the user wishes to receive.  These notifications
 #  are based on certain events that can occur during
 #  the program's run-time.
 # -------------------------------
 #>
enum UserPreferencesEventAlarm
{
    Everything = 0;    # Everything will sound an alarm.
    Success = 1;       # Only successful operations will
                       #  sound an alarm.
    Errors = 2;        # Only errors will sound an alarm.
    Warnings = 3;      # Only warnings will sound an alarm.
} # UserPreferencesEventAlarm