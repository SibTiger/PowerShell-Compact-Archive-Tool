<# Create Program Required Directories
 # -------------------------------
 # Documentation:
 #  This function will create the directories
 #   that is required to house program-data.
 #  These directories will be paramount for
 #   this program to operate successfully.
 #  If the directories do not exist, then the
 #   directories are to be created on the user's
 #   filesystem.
 #  If the directories does exist already, then
 #   nothing will be created nor changed.
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
 #    - %LOCALAPPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Logs
 #    - %APPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Configs
 # -------------------------------
 # Output:
 #  [bool] Exit code
 #    $false = Failure creating the new directories.
 #    $true  = Successfully created the new directories
 #             OR
 #             Directories already existed, nothing to do.
 # -------------------------------
 #>
function CreateDirectories()
{
    # First, check if the special directories exists.
    if((CheckSpecialDirectories) -eq $false)
    {
        # Because one or more special directories does
        #  not exist, we can not create directories where
        #  the special paths does not exist.
        #  Potentially incompatible Operating System or
        #  filesystem structure is not supported by the
        #  system.
        return $false;
    } # If : Special Directories Not Exist.


    # ----


    # Second, check if the directories already exist.
    #  If they exist, than there is nothing to do.
    if ((CheckProgramDirectories) -eq $true)
    {
        # Because the directories exists within the
        #  filesystem, there's nothing todo.
        return $true;
    } # If : Directories Exists
    

    # ----


    # Because one or more directories did not exist, then
    #  we must find it and create them.


    # User-Data Directories
    # ++++++++++++++++++++++++++
    # ++++++++++++++++++++++++++


    # Program Root Directory
    if(([IOCommon]::MakeDirectory("$($_USERDATA_ROOT_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Root Directory Created

    # ----

    # Program Output Builds Directory
    if(([IOCommon]::MakeDirectory("$($_USERDATA_BUILDS_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Output Builds Directory Created

    # ----

    # Program Output Release Builds Directory
    if(([IOCommon]::MakeDirectory("$($_USERDATA_RELEASEBUILDS_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Output Release Builds Directory Created

    # ----

    # Program Output Dev. Builds Directory
    if(([IOCommon]::MakeDirectory("$($_USERDATA_DEVBUILDS_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Output Dev. Builds Directory Created



    # Program-Data Directories
    # ++++++++++++++++++++++++++
    # ++++++++++++++++++++++++++


    # Program Data Root [Local]
    if(([IOCommon]::MakeDirectory("$($_PROGRAMDATA_ROOT_LOCAL_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Data Root [Local]

    # ----

    # Program Data Logs [Local]
    if(([IOCommon]::MakeDirectory("$($_PROGRAMDATA_LOGS_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Data Logs [Local]

    # ----

    # Program Data Root [Roaming]
    if(([IOCommon]::MakeDirectory("$($_PROGRAMADATA_ROOT_ROAMING_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Data Configs [Local]

    # ----

    # Program Data Configs [Roaming]
    if(([IOCommon]::MakeDirectory("$($_PROGRAMDATA_CONFIGS_PATH_)")) -eq $false)
    {
        # Directory could not be created.
        return $false;
    } # If : Program Data Configs [Local]



    # Return the Exit status if successful
    return $true;
} # CreateDirectories()




<# Check Program Directories
 # -------------------------------
 # Documentation:
 #  This function will check to make sure that the
 #   required directories exists within the user's
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
 #    - %LOCALAPPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Logs
 #    - %APPDATA%\<PROG_NAME>
 #    - %LOCALAPPDATA%\<PROG_NAME>\Configs
 # -------------------------------
 # Output:
 #  [bool] Exit code
 #    $false = One or more directories does not exist.
 #    $true = Directories exist
 # -------------------------------
 #>
function CheckProgramDirectories()
{
    # User-Data Directories
    # -----

    if ((([IOCommon]::CheckPathExists("$($_USERDATA_ROOT_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_USERDATA_BUILDS_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_USERDATA_RELEASEBUILDS_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_USERDATA_DEVBUILDS_PATH_)")) -eq $true))
    {
        # The directories exists.
        #  Nothing to do.
    } # If : Directories Exists

    else
    {
        # The directories does not exist.
        #  Because one or more directories does not exist,
        #  return an error signal.
        return $false;
    } # Else : Directories not exist


    # =====================
    # ---------------------
    # =====================


    # Program-Data Directories
    # ----

    if ((([IOCommon]::CheckPathExists("$($_PROGRAMDATA_ROOT_LOCAL_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_PROGRAMDATA_LOGS_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_PROGRAMADATA_ROOT_ROAMING_PATH_)")) -eq $true) -and `
        (([IOCommon]::CheckPathExists("$($_PROGRAMDATA_CONFIGS_PATH_)")) -eq $true))
    {
        # The directories exists.
        #  Nothing to do.
    } # If : Directories Exists

    else
    {
        # The directories does not exist.
        #  Because one or more directories does not exist,
        #  return an error signal.
        return $false;
    } # Else : Directories not exist


    # =====================
    # ---------------------
    # =====================


    # If we made it this far, then all the directories exists on the filesystem.
    #  Return a success signal.
    return $true;
} # CheckProgramDirectories()




<# Check Special Directories
 # -------------------------------
 # Documentation:
 #  This function will check to make sure that the
 #   defined special directories exists within the
 #   host system.
 #  Special Directories are defined as normally
 #   provided by the Operating System and usually
 #   required for the user's profile.
 # -------------------------------
 # Output:
 #  [bool] Exit Code
 #    $false = One or more special directories
 #              could not be detected, possibly missing.
 #    $true = All special directories exists; no errors. 
 # -------------------------------
 #>
function CheckSpecialDirectories()
{
    # Declarations and Initializations
    # ----------------------------------------
    [string] $pathMyDocuments = "$(FetchPathUserDocuments)";    # My Documents
    [string] $pathLocalAppData = "$(FetchPathAppDataLocal)";    # Local AppData
    [string] $pathRoamingAppData = "$(FetchPathAppDataRoaming)";# Roaming AppData
    # ----------------------------------------


    # Check the following:
    # My Documents
    if (([IOCommon]::CheckPathExists("$($pathMyDocuments)")) -eq $false)
    {
        return $false;
    } # If : My Documents


    # ----


    # Local AppData
    if (([IOCommon]::CheckPathExists("$($pathLocalAppData)")) -eq $false)
    {
        return $false;
    } # If : Local AppData


    # ----


    # Roaming AppData
    if (([IOCommon]::CheckPathExists("$($pathRoamingAppData)")) -eq $false)
    {
        return $false;
    } # If : Roaming AppData


    # ----


    # Everything was successful
    return $true;
} # CheckSpecialDirectories()