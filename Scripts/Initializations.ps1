<# PowerShell Compact-Archive Tool
 # Copyright (C) 2025
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
 #  NOTE: All variables defined within the sub-functions - are all global.
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

    # Directory Paths
    InitializationDirectoryPaths

    # Program environment
    InitializationEnvironment;

    # Generalized Variables
    GeneralizedVariables;
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
    Set-Variable `
        -Name "_PROGRAMNAME_" `
        -Value "PowerShell Compact-Archive Tool" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The full name of the application";


    # Program Name (Abbreviated)
    Set-Variable `
        -Name "_PROGRAMNAMESHORT_" `
        -Value "PSCAT" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The short name of the application";


    # Version
    Set-Variable `
        -Name "_VERSION_" `
        -Value "1.2.0 [Beta]" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The version of the application";


    # Version Name
    Set-Variable `
        -Name "_VERSIONNAME_" `
        -Value "Cordis" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The name of the version; usually the name of the program's foundation.";


    # Release Date
    # Date Format: DD.MM.YYYY with leading zeros
    Set-Variable `
        -Name "_RELEASEDATE_" `
        -Value "18.01.2025" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The date in which the version of the application was released.";


    # License
    Set-Variable `
        -Name "_LICENSE_" `
        -Value "GNU General Public License v3.0" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Describes the license that this application utilizes. ";
} # InitializationProgramIdentity()




<# Initialization: Program Identity
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide helpful website links related
 #   to the program.  Such websites could be the following: Source Repository, Wiki, Downloads,
 #   homepage, and more if necessary.
 # -------------------------------
 #>
function InitializationProgramSites()
{
    # Program Homepage
    Set-Variable `
        -Name "_PROGRAMSITEHOMEPAGE_" `
        -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides a URL to the application's homepage site.";


    # Program Wiki
    Set-Variable `
        -Name "_PROGRAMSITEWIKI_" `
        -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides a URL to the application's wiki site.";


    # Program Downloads
    Set-Variable `
        -Name "_PROGRAMSITEDOWNLOADS_" `
        -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/releases/latest" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides a URL to the application's download page site.";


    # Program Source Repository
    Set-Variable `
        -Name "_PROGRAMSITESOURCEREPOSITORY_" `
        -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides a URL to the application's source repository site.";


    # Report a Bug or Feature
    Set-Variable `
        -Name "_PROGRAMREPORTBUGORFEATURE_" `
        -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki/Report" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
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
    # Splash Screen Hold Timer (Seconds)
    #  How many seconds the splash screen will remain visible to the user, yet locking the
    #  program from proceeding onwards.
    Set-Variable `
        -Name "_STARTUPSPLASHSCREENHOLDTIME_" `
        -Value 4 `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The amount of time that is required for the splash screen to remain present on the terminal buffer.";
} # InitializationProgramData()




<# Initialization Directory Paths
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide the directory paths used
 #   for the program's needs within the host system.
 # -------------------------------
 #>
function InitializationDirectoryPaths()
{
    # Script Absolute Script Path
    # ---------------
    # The path that this script currently resides from.  Highly useful for 'absolute' paths.
    # BUG POSSIBLE: If the path has been disrupted at program's runtime, then it is possible
    #                   that this path will be broken - thus causing problems when trying to
    #                   throw or recall files from specific directories from an absolute
    #                   directory.
    Set-Variable `
        -Name "_SCRIPTPATH_" `
        -Value $PSScriptRoot `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the root path in which the application resides.";


    # ----
    # User Data


    # User-Data Root Directory Path
    # ---------------
    # The root directory where user-data will be stored.
    Set-Variable `
        -Name "_USERDATA_ROOT_PATH_" `
        -Value "$(FetchPathUserDocuments)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the root path in which the user data will be stored.";


    # ----
    # Program Data [Local AppData]


    # Program-Data Root Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable `
        -Name "_PROGRAMDATA_LOCAL_ROOT_PATH_" `
        -Value "$(FetchPathAppDataLocal)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the root path in which the program data will be stored, but remains local to this system within a Roaming Profile environment.";


    # Program-Data Program Log Directory Path
    # ---------------
    # The main program logfile directory
    Set-Variable `
        -Name "_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_" `
        -Value "$($_PROGRAMDATA_LOCAL_ROOT_PATH_)\Logs" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Contains the program's main logfile regarding every action and output.";



    # ----
    # Program Data [Roaming AppData]


    # Program-Data Parent Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Set-Variable `
        -Name "_PROGRAMDATA_ROAMING_ROOT_PATH_" `
        -Value "$(FetchPathAppDataRoaming)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the root path in which the program data will be stored, but can be moved around within a Roaming Profile environment.";



    # ----
    # Output Directories


    # Output Builds Directory Path
    # ---------------
    # The compiled builds directory path
    Set-Variable `
        -Name "_OUTPUT_BUILDS_PATH_" `
        -Value "$(FetchPathUserDocuments)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Contains the parent path where the compiled builds will be stored.";
} # InitializationDirectoryPaths()




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
    Set-Variable `
        -Name "_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_" `
        -Value "$([CommonIO]::GetTerminalWindowTitle())" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Maintains the current title of the PowerShell's window title; because we will change it - this will allow us to revert the title back.";
} # InitializationEnvironment()




<# Initialization: Generalized Variables
 # -------------------------------
 # Documentation:
 #  This function will initialize generalized variables that can be used within the program.
 # -------------------------------
 #>
function GeneralizedVariables()
{
    # Default GUID
    Set-Variable `
        -Name "_DEFAULT_BLANK_GUID_" `
        -Value "00000000-0000-0000-0000-000000000000" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides a zero filled GUID that will act as a temporary default.";
} # GeneralizedVariables()




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
function FetchPathAppDataLocal() { return $env:LOCALAPPDATA; }




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
function FetchPathAppDataRoaming() { return $env:APPDATA; }




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
function FetchPathUserDocuments() { return "$($env:HOMEDRIVE)$($env:HOMEPATH)\Documents"; }