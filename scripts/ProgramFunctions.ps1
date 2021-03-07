<# Create Program Required Directories
 # -------------------------------
 # Documentation:
 #  This function will create the directories that is required to house program-data.  These directories
 #   will be paramount for this program to operate successfully.  If the directories do not exist, then
 #   the directories are to be created on the user's filesystem.  If the directories does exist already,
 #   then nothing will be created nor changed.
 #
 # ----
 #
 #  Directories to Create:
 #   - User-Data Domain
 #    - %HomePath%\Documents\<PROG_NAME>
 #    - %HomePath%\Documents\<PROG_NAME>\Builds
 #    - %HomePath%\Documents\<PROG_NAME>\Builds\Release
 #    - %HomePath%\Documents\<PROG_NAME>\Builds\Development
 #
 #   - Program-Data Domain
 #    - %APPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Logs
 #    - %LOCALAPPDATA%\<PROG_NAME>\Configs
 # -------------------------------
 # Output:
 #  [bool] Exit code
 #    $true  = Successfully created the new directories.
 #             OR
 #             Directories already existed, nothing to do.
 #    $false = Failure creating the new directories.
 # -------------------------------
 #>
function CreateDirectories()
{
    # First, check if the special directories exists.
    if((CheckSpecialDirectories) -eq $false)
    {
        # Because one or more special directories does not exist, we can not create directories where
        #  the special paths does not exist.  Potentially incompatible Operating System or filesystem
        #  structure is not supported by the system.
        return $false;
    } # If : Special Directories Not Exist.


    # ----


    # Second, check if the directories already exist.  If they exist, than there is nothing to do.
    if ((CheckProgramDirectories) -eq $true)
    {
        # Because the directories exists within the filesystem, there's nothing todo.
        return $true;
    } # If : Directories Exists


    # ----


    # Because one or more directories did not exist, then we must find it and create them.
    return (# Create the User Data Directories
            ([IOCommon]::MakeDirectory("$($_USERDATA_ROOT_PATH_)")              -eq $true) -and `   # The Program Root Directory
            ([IOCommon]::MakeDirectory("$($_USERDATA_BUILDS_PATH_)")            -eq $true) -and `   # The Program Output Builds Directory
            ([IOCommon]::MakeDirectory("$($_USERDATA_RELEASEBUILDS_PATH_)")     -eq $true) -and `   # The Program Output Release Builds Directory
            ([IOCommon]::MakeDirectory("$($_USERDATA_DEVBUILDS_PATH_)")         -eq $true) -and `   # The Program Output Dev. Builds Directory
            # Program-Data Directories
            ([IOCommon]::MakeDirectory("$($_PROGRAMDATA_ROOT_LOCAL_PATH_)")     -eq $true) -and `   # The Program Data Root [Local]
            ([IOCommon]::MakeDirectory("$($_PROGRAMDATA_LOGS_PATH_)")           -eq $true) -and `   # The Program Data Logs [Local]
            ([IOCommon]::MakeDirectory("$($_PROGRAMDATA_ROOT_ROAMING_PATH_)")   -eq $true) -and `   # The Program Data Root [Roaming]
            ([IOCommon]::MakeDirectory("$($_PROGRAMDATA_CONFIGS_PATH_)")        -eq $true));        # The Program Data Configs [Roaming]
} # CreateDirectories()




<# Check Program Directories
 # -------------------------------
 # Documentation:
 #  This function will check to make sure that the required directories exists within the user's
 #   filesystem.
 #
 # ----
 #
 #  Directories to Check:
 #   - User-Data Domain
 #    - %HomePath%\Documents\<PROG_NAME>
 #    - %HomePath%\Documents\<PROG_NAME>\Builds
 #    - %HomePath%\Documents\<PROG_NAME>\Builds\Release
 #    - %HomePath%\Documents\<PROG_NAME>\Builds\Development
 #
 #   - Program-Data Domain
 #    - %APPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Logs
 #    - %LOCALAPPDATA%\<PROG_NAME>\Configs
 # -------------------------------
 # Output:
 #  [bool] Exit code
 #    $true = Directories exist
 #    $false = One or more directories does not exist.
 # -------------------------------
 #>
function CheckProgramDirectories()
{
    return (# User-Data Directories
            ([IOCommon]::CheckPathExists("$($_USERDATA_ROOT_PATH_)", $true)             -eq $true)  -and `  # The Program Root Directory
            ([IOCommon]::CheckPathExists("$($_USERDATA_BUILDS_PATH_)", $true)           -eq $true)  -and `  # The Program Output Builds Directory
            ([IOCommon]::CheckPathExists("$($_USERDATA_RELEASEBUILDS_PATH_)", $true)    -eq $true)  -and `  # The Program Output Release Builds Directory
            ([IOCommon]::CheckPathExists("$($_USERDATA_DEVBUILDS_PATH_)", $true)        -eq $true)  -and `  # The Program Output Dev. Builds Directory
            # Program-Data Directories
            ([IOCommon]::CheckPathExists("$($_PROGRAMDATA_ROOT_LOCAL_PATH_)", $true)    -eq $true)  -and `  # The Program Data Root [Local]
            ([IOCommon]::CheckPathExists("$($_PROGRAMDATA_LOGS_PATH_)", $true)          -eq $true)  -and `  # The Program Data Logs [Local]
            ([IOCommon]::CheckPathExists("$($_PROGRAMDATA_ROOT_ROAMING_PATH_)", $true)  -eq $true)  -and `  # The Program Data Root [Roaming]
            ([IOCommon]::CheckPathExists("$($_PROGRAMDATA_CONFIGS_PATH_)", $true)       -eq $true));        # The Program Data Configs [Roaming]
} # CheckProgramDirectories()




<# Check Special Directories
 # -------------------------------
 # Documentation:
 #  This function will check to make sure that the defined special directories exists within the
 #   host system.  Special Directories are defined as normally provided by the Operating System
 #   and usually required for the user's profile.
 # -------------------------------
 # Output:
 #  [bool] Exit Code
 #    $true = All special directories exists; no errors.
 #    $false = One or more special directories could not be detected, possibly missing.
 # -------------------------------
 #>
function CheckSpecialDirectories()
{
    # Declarations and Initializations
    # ----------------------------------------
    [string] $pathMyDocuments = "$(FetchPathUserDocuments)";        # My Documents
    [string] $pathLocalAppData = "$(FetchPathAppDataLocal)";        # Local AppData
    [string] $pathRoamingAppData = "$(FetchPathAppDataRoaming)";    # Roaming AppData
    # ----------------------------------------


    # Check the following special directories if they already exists within the host system.
    return (([IOCommon]::CheckPathExists("$($pathMyDocuments)", $true) -eq $true)       -and ` # My Documents
            ([IOCommon]::CheckPathExists("$($pathLocalAppData)", $true) -eq $true)      -and ` # Local AppData
            ([IOCommon]::CheckPathExists("$($pathRoamingAppData)", $true) -eq $true));         # Roaming AppData
} # CheckSpecialDirectories()