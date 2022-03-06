<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #>




<# Initializations Driver
 # -------------------------------
 # Documentation:
 #  This function acts as a simple procedural driver for declaring and initializing variables that
 #   will be used within this program.  Such variables provide basic information regarding the program,
 #   such as the software name or version, while other variables may contain imperative information
 #   which is required for the software's internal functionality and basic support.
 #
 #  NOTE: All variables defined within the sub-functions - are all global.  While these variables are
 #         global to the program's environment, some may be flagged as constant and others might be
 #         mutable.  Please review carefully.
 # -------------------------------
 #>
function Initializations()
{
    # Program Identity
    InitializationProgramIdentity;

    # Program Websites
    InitializationProgramSites;

    # Program Data and Internal Mutable Data
    InitializationProgramData;

    # Directory Locations
    InitializationDirectory;

    # Program environment
    InitializationEnvironment;
} # Initializations()




<# Initialization: Program Identity
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that provide information to the software's identity.
 #   Such information will be the program's name, version, code name, etc....
 # -------------------------------
 #>
function InitializationProgramIdentity()
{
    # Program Name
    Set-Variable -Name "_PROGRAMNAME_" -Value "PowerShell Compact-Archive Tool" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The full name of the application";


    # Program Name (Abbreviated)
    Set-Variable -Name "_PROGRAMNAMESHORT_" -Value "PSCAT" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The short name of the application";

    # Version
    Set-Variable -Name "_VERSION_" -Value "1.1.0 - Alpha" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The version of the application";


    # Version Name
    Set-Variable -Name "_VERSIONNAME_" -Value "Cordis" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The name of the version; usually the name of the program's foundation.";

    # Release Date
    # Date Format: DD.MM.YYYY with leading zeros
    Set-Variable -Name "_RELEASEDATE_" -Value "xx.03.2022" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The date in which the version of the application was released.";

    # License
    Set-Variable -Name "_LICENSE_" -Value "GNU General Public License v3.0" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Describes the license that this application utilizes. ";
} # InitializationProgramIdentity()




<# Initialization: Program Identity
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide helpful website links related
 #   to the program.  Such website links could be: Source Repository, Wiki, Downloads,
 #   homepage, and more if necessary.
 # -------------------------------
 #>
function InitializationProgramSites()
{
    # Program Homepage
    Set-Variable -Name "_PROGRAMSITEHOMEPAGE_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's homepage site.";

    # Program Wiki
    Set-Variable -Name "_PROGRAMSITEWIKI_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's wiki site.";

    # Program Downloads
    Set-Variable -Name "_PROGRAMSITEDOWNLOADS_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/releases" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's download page site.";

    # Program Source Repository
    Set-Variable -Name "_PROGRAMSITESOURCEREPOSITORY_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's source repository site.";

    # Report a Bug or Feature
    Set-Variable -Name "_PROGRAMREPORTBUGORFEATURE_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki/Report" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's bug tracker site.";
} # InitializationProgramSites()




<# Initialization: Program Data
 # -------------------------------
 # Documentation:
 #  This function will declare and initialize variables that will be used within the software - either
 #   by further enhancing functionality or to provide technical data.  Some variables housed in this
 #   function may allow the possibility to be inter-changeable at runtime.
 # -------------------------------
 #>
function InitializationProgramData()
{
    # .NET Framework Requirement
    Set-Variable -Name "_DOTNETFRAMEWORK_" -Value "5.0.405" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Specifies the minimum required version of the dotNET Core Framework.";

    # PowerShell Version Requirement
    Set-Variable -Name "_POWERSHELLVERSION_" -Value "7.2.1" `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Specifies the minimum required version of the PowerShell Core version.";

    # Debug Logging functionality
    Set-Variable -Name "_DEBUGLOGGING_" -Value $true `
        -Option Constant -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Allows control to either enable or disable the program's logging functionalities.";

    # Logging Lock Key
    #  This will help to avoid recursive function calls when an event is being logged.
    #  This key, when 'false' will adhere to the user's logging preference.  But when
    #  'true', the user's logging preference will be ignored (regardless true or false)
    #  and will disallow events to be logged.
    # NOTE: This functionality is mainly utilized with the WriteToFile() function in the
    #  CommonIO object.
    Set-Variable -Name "_LOGGINGLOCKKEY_" -Value $false `
        -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "This variable will help to prevent a stack overflow issue that could occur when writing logged data.";

    # Splash Screen Hold Timer (Seconds)
    #  How many seconds the splash screen will remain visible to the user, yet locking the
    #  program from proceeding onwards.
    Set-Variable -Name "_STARTUPSPLASHSCREENHOLDTIME_" -Value 4 `
        -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The amount of time that is required for the splash screen to remain present on the terminal buffer.";
} # InitializationProgramData()




<# Initialization Directory Paths
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide the directory paths for
 #   both the User Data and Program Data within the host system.
 # -------------------------------
 #>
function InitializationDirectory()
{
    # Script Absolute Script Path
    # ---------------
    # The path that this script currently resides from.
    #  Highly useful for 'absolute' paths.
    # BUG POSSIBLE: If the path has been disrupted at program's runtime,
    #  then it is possible that this path will be broken - thus causing
    #  problems when trying to throw or recall files from specific directories
    #  from an absolute directory.
    Set-Variable -Name "_SCRIPTPATH_" -Value $PSScriptRoot `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the application resides.";


    # ----
    # User Data


    # User-Data Root Directory Path
    # ---------------
    # The root directory where user-data will be stored.
    Set-Variable -Name "_USERDATA_ROOT_PATH_" -Value "$(FetchPathUserDocuments)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the user data will be stored.";


    # User-Data Project Parent Project Directory Path
    # ---------------
    # The project's parent directory where the user's data will be stored.
    Set-Variable -Name "_USERDATA_PROJECT_PATH_" -Value "$($GLOBAL:_USERDATA_ROOT_PATH_)\$([ProjectInformation]::projectName)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides the project's directory to help separate from other potential projects.";


    # Output Parent Directory Path
    # ---------------
    # The root directory that the builds reside.
    Set-Variable -Name "_USERDATA_BUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_PROJECT_PATH_)\Builds" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which all complied builds will be stored.";


    # Output Release Directory Path
    # ---------------
    # The directory that holds the 'Release' builds.
    Set-Variable -Name "_USERDATA_RELEASEBUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_BUILDS_PATH_)\Release" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the path for all released compiled builds that will be stored.";


    # Output Development Directory Path
    # ---------------
    # The directory that holds the 'Development' builds.
    Set-Variable -Name "_USERDATA_DEVBUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_BUILDS_PATH_)\Development" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the path for all developmental compiled builds that will be stored.";


    # ----
    # Program Data [Local AppData]


    # Program-Data Root Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable -Name "_PROGRAMDATA_ROOT_LOCAL_PATH_" -Value "$(FetchPathAppDataLocal)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the program data will be stored, but remains local to this system within a Roaming Profile environment.";


    # Program-Data Project Parent Directory Path
    # ---------------
    # The project parent directory where program-data will be stored.
    Set-Variable -Name "_PROGRAMDATA_PROJECT_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_ROOT_LOCAL_PATH_)\$([ProjectInformation]::projectName)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Contains the path of where all related program data will be stored that is affiliated with the loaded project.";


    # Log Directory Path
    # ---------------
    # The directory that will contain the log-files regarding this program and some special
    #  operations.
    Set-Variable -Name "_PROGRAMDATA_LOGS_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_PROJECT_PATH_)\Logs" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which all of the logfiles will be stored.";


    # ----
    # Program Data [Roaming AppData]


    # Program-Data Parent Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable -Name "_PROGRAMDATA_ROOT_ROAMING_PATH_" -Value "$(FetchPathAppDataRoaming)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the program data will be stored, but can be moved around within a Roaming Profile environment.";


    # User Data (Configuration)
    # ---------------
    # This directory will hold the user's configurations.
    Set-Variable -Name "_PROGRAMDATA_CONFIGS_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_ROOT_ROAMING_PATH_)\Configs" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which holds the user's configurations";
} # InitializationDirectory()




<# Initialization: Program Environment
 # -------------------------------
 # Documentation:
 #  This function will initialize the variables that will provide information regarding PowerShell's environment.
 #   Such information can be the window's position, title, colors, etc...
 # -------------------------------
 #>
function InitializationEnvironment()
{
    # PowerShell's Window Title
    Set-Variable -Name "_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_" -Value "$([CommonIO]::GetTerminalWindowTitle())" `
        -Scope Global -Force -Option Constant -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Maintains the current title of the PowerShell's window title; because we will change it - this will allow us to revert the title back.";
} # InitializationEnvironment()




<# Fetch Path: AppData Local Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's AppData Local absolute path and return the
 #   value to the respected caller.
 # -------------------------------
 # Output:
 #  [string] Local AppData Absolute Path
 #   The current user's Local AppData directory.
 # -------------------------------
 #>
function FetchPathAppDataLocal()
{
    return $env:LOCALAPPDATA;
} # FetchPathAppDataLocal()




<# Fetch Path: AppData Roaming Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's AppData Roaming absolute path and return the
 #   value to the respected caller.
 # -------------------------------
 # Output:
 #  [string] Roaming AppData Absolute Path
 #   The current user's Roaming AppData directory.
 # -------------------------------
 #>
function FetchPathAppDataRoaming()
{
    return $env:APPDATA;
} # FetchPathAppDataRoaming()




<# Fetch Path: User's Document Directory
 # -------------------------------
 # Documentation:
 #  This function will find the currently logged-in user's Document's absolute path and return the value
 #   to the respected caller.
 # -------------------------------
 # Output:
 #  [string] User's 'My Documents' Absolute Path
 #   The current user's Documents directory.
 # -------------------------------
 #>
function FetchPathUserDocuments()
{
    return "$($env:HOMEDRIVE)$($env:HOMEPATH)\Documents";
} # FetchPathUserDocuments()