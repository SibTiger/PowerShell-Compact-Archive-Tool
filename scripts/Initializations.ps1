<# Initializations Driver
 # -------------------------------
 # Documentation:
 #  This function is essentially the driver to setting up the declarations and
 #   initializations for the heart of the program.  Most of the declarations
 #   housed within this script are global but constant, thus the variables can
 #   be used anywhere within this program but not mutable once initialized.
 # -------------------------------
 #>
function Initializations()
{
    # Parameters for this function
    Param
    (
        [Parameter(Mandatory = $true, Position=0)]
        [ProjectInformation] $projectInformation
    ); # Function Parameters

    # Program Information
    InitalizationProgramData;

    # Directory Locations
    InitalizationDirectory $projectInformation;
} # Initializations()




<# Initialization Program Data
 # -------------------------------
 # Documentation:
 #  This function will initialize all variables related to the program.
 # -------------------------------
 #>
function InitalizationProgramData()
{
    # Program Name
    Set-Variable -Name "_PROGRAMNAME_" -Value "PowerShell Compact-Archive Tool" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # Program Name (Abbrivated)
    Set-Variable -Name "_PROGRAMNAMESHORT_" -Value "PSCAT" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # Version
    Set-Variable -Name "_VERSION_" -Value "0.000001-Alpha" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # Version Name
    Set-Variable -Name "_VERSIONNAME_" -Value "Cordis" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # Release Date
    Set-Variable -Name "_RELEASEDATE_" -Value "DD.MM.YYYY" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # .NET Framework Requirement
    Set-Variable -Name "_DOTNETFRAMEWORK_" -Value 5 `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;

    # PowerShell Version Requirement
    Set-Variable -Name "_POWERSHELLVERSION_" -Value 3 `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue;
} # InitalizationProgramData()




<# Initialization Directory Paths
 # -------------------------------
 # Documentation:
 #  This function will setup the directory paths that will be used
 #   when handling files within this program.
 # -------------------------------
 #>
function InitalizationDirectory()
{
    # Parameters for this function
    Param
    (
        [Parameter(Mandatory = $true, Position=0)]
        [ProjectInformation] $projectInformation
    ); # Function Parameters


    # Script Absolute Script Path
    # ---------------
    # The path that this script currently resides from.
    #  Highly useful for 'absolute' paths.
    # BUG POSSIBLE: If the path has been disrupted at program's runtime,
    #  then it is possible that this path will be broken - thus causing
    #  problems when trying to throw or recall files from specific directories
    #  from an absolute directory.
    Set-Variable -Name "_SCRIPTPATH_" -Value $PSScriptRoot `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # ----
    # User Data


    # User-Data Parent Directory Path
    # ---------------
    # The root directory where user-data will be stored.
    Set-Variable -Name "_USERDATA_ROOT_PATH_" -Value "$(FetchPathUserDocuments)\$($_PROGRAMNAME_)\$($projectInformation.__projectName)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # Output Parent Directory Path
    # ---------------
    # The root directory that the builds reside.
    Set-Variable -Name "_USERDATA_BUILDS_PATH_" -Value "$($_USERDATA_ROOT_PATH_)\Builds" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # Output Release Directory Path
    # ---------------
    # The directory that holds the 'Release' builds.
    Set-Variable -Name "_USERDATA_RELEASEBUILDS_PATH_" -Value "$($_USERDATA_BUILDS_PATH_)\Release" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # Output Development Directory Path
    # ---------------
    # The directory that holds the 'Development' builds.
    Set-Variable -Name "_USERDATA_DEVBUILDS_PATH_" -Value "$($_USERDATA_BUILDS_PATH_)\Development" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # ----
    # Program Data [Local AppData]


    # Program-Data Parent Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable -Name "_PROGRAMDATA_ROOT_LOCAL_PATH_" -Value "$(FetchPathAppDataLocal)\$($_PROGRAMNAME_)\$($projectInformation.__projectName)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # Log Directory Path
    # ---------------
    # The directory that will contain the log-files regarding this program and some special
    #  operations.
    Set-Variable -Name "_PROGRAMDATA_LOGS_PATH_" -Value "$($_PROGRAMDATA_ROOT_LOCAL_PATH_)\Logs" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;

    
    # ----
    # Program Data [Roaming AppData]


    # Program-Data Parent Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable -Name "_PROGRAMADATA_ROOT_ROAMING_PATH_" -Value "$(FetchPathAppDataRoaming)\$($_PROGRAMNAME_)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;


    # User Data (Configuration)
    # ---------------
    # This directory will hold the user's configurations.
    Set-Variable -Name "_PROGRAMDATA_CONFIGS_PATH_" -Value "$($_PROGRAMADATA_ROOT_ROAMING_PATH_)\Configs" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue;
} # InitalizationDirectory()




<# Fetch Path: AppData Local Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's
 #   AppData Local absolute path and return the value to the
 #   respected caller.
 # -------------------------------
 # Output:
 #  [string] Local AppData Absolute Path
 #   The current user's Local AppData directory.
 # -------------------------------
 #>
function FetchPathAppDataLocal()
{
    return "$($env:LOCALAPPDATA)";
} # FetchPathAppDataLocal()




<# Fetch Path: AppData Roaming Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's
 #   AppData Roaming absolute path and return the value to the
 #   respected caller.
 # -------------------------------
 # Output:
 #  [string] Roaming AppData Absolute Path
 #   The current user's Roaming AppData directory.
 # -------------------------------
 #>
function FetchPathAppDataRoaming()
{
    return "$($env:APPDATA)";
} # FetchPathAppDataRoaming()




<# Fetch Path: User's Document Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's
 #   Document's absolute path and return the value to the
 #   respected caller.
 # -------------------------------
 # Output:
 #  [string] User's 'My Documents' Absolute Path
 #   The current user's Documents directory.
 # -------------------------------
 #>
function FetchPathUserDocuments()
{
    return "$($env:HOMEDRIVE)$($env:HOMEPATH)\Documents"
} # FetchPathUserDocuments()