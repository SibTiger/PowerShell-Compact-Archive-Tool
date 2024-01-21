<# PowerShell Compact-Archive Tool
 # Copyright (C) 2023
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

    # Directory Paths - Program
    __Initialization_DirectorySetupDriver([InitializationsDirectoryChoice]::Program);

    # Program environment
    InitializationEnvironment;

    # Project Manager Manager
    __InitializationProjectManager;

    # Generalized Variables
    __GeneralizedVariables;
} # Initializations()




<# Initializations - Update Project Paths
 # -------------------------------
 # Documentation:
 #  This function, when called, will update the project path global variables.  This is useful
 #   for when a project had been loaded after the initialization ritual, but we need to have the
 #   paths updated.
 #  Thus, when we need to load-in a new project into the environment, then we also need to update
 #   the project paths as well.  This is where this function comes into play.
 #
 # NOTE: This function is NOT intended to be loaded before the main Initialization function driver.
 # -------------------------------
 #>
function Initializations_UpdateProjectPaths()
{
    # Directory Paths - Project Environment
    __Initialization_DirectorySetupDriver([InitializationsDirectoryChoice]::Project);
} # Initializations_UpdateProjectPaths()




<# Initializations - Directory Driver
 # -------------------------------
 # Documentation:
 #  This function will provide a gateway into initializing the desired directory global variables.
 #
 # NOTE:
 #  It is strongly recommended to initialize the Program directories before initializing any other
 #   directory variables!
 # -------------------------------
 # Input:
 #  [InitializationsDirectoryChoice] Directory Setup
 #   This will determine what directory variables are to be initialized or re-assigned.
 # -------------------------------
#>
function __Initialization_DirectorySetupDriver([InitializationsDirectoryChoice] $directorySetup)
{
    # Determine what directory variables to initialize
    switch ($directorySetup)
    {
        # Program Directories
        ([InitializationsDirectoryChoice]::Program)
        {
            # Setup the Program's directories
            InitializationDirectoryPaths_Program;


            # Finished!
            break;
        } # Program Directories


        # Project Directories
        ([InitializationsDirectoryChoice]::Project)
        {
            # Setup the Loaded Project's directories
            InitializationDirectoryPaths_Project;


            # Finished!
            break;
        } # Project Directories
    } # switch : Determine Directory Initializations
} # __Initialization_DirectorySetupDriver()




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
        -Value "1.2.0 [Alpha]" `
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
        -Value "DD.MM.2023" `
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
    # Debug Logging functionality
    Set-Variable `
        -Name "_DEBUGLOGGING_" `
        -Value $true `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Allows control to either enable or disable the program's logging functionalities.";


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




<# Initialization Directory Paths - Program Paths
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide the directory paths used
 #   for the program's needs within the host system.
 # -------------------------------
 #>
function InitializationDirectoryPaths_Program()
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


    # Program-Data Program Art Image Path
    # ---------------
    # The directory that will contain the program's images that will be visible using Windows' Toast Notifications.
    Set-Variable `
        -Name "_PROGRAMDATA_LOCAL_IMAGES_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_LOCAL_ROOT_PATH_)\Images" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -Force `
        -ErrorAction SilentlyContinue `
        -Description "Holds the path for the program's art pieces, such as logo and banner images.";


    # Program-Data Program Logo Image Path
    # ---------------
    # The program's logo image that will be shown within the Windows Toast Notifications
    Set-Variable `
        -Name "_PROGRAMDATA_LOCAL_IMAGES_LOGO_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_LOCAL_IMAGES_PATH_)\Logo.png" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -Force `
        -ErrorAction SilentlyContinue `
        -Description "Holds the path of the program's logo image that will be visible in Windows Toast Notifications.";


    # Program-Data Program Banner Image Path
    # ---------------
    # The program's banner image (formally known as a Hero Image) that will be shown within the Windows Toast Notifications
    Set-Variable `
    -Name "_PROGRAMDATA_LOCAL_IMAGES_BANNER_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_LOCAL_IMAGES_PATH_)\Banner.png" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -Force `
        -ErrorAction SilentlyContinue `
        -Description "Holds the path of the program's banner image that will be visible in Windows Toast Notifications.";



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


    # User Data (Configuration)
    # ---------------
    # This directory will hold the user's configurations.
    Set-Variable `
        -Name "_PROGRAMDATA_ROAMING_USERCONFIG_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_ROAMING_ROOT_PATH_)\Configs" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the parent path in which holds the user's configurations.";


    # User Data (Project Installation Path)
    # ---------------
    # This directory will hold the user's installed projects.
    Set-Variable `
        -Name "_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_ROAMING_ROOT_PATH_)\Projects" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Holds the parent path in which contains the user's installed projects.";
} # InitializationDirectoryPaths_Program()




<# Initialization Directory Paths - Project Paths
 # -------------------------------
 # Documentation:
 #  This function will initialize variables that will provide the directory paths used
 #   for loaded projects within the host system.
 # -------------------------------
 #>
 function InitializationDirectoryPaths_Project()
 {
     # ----
     # User Data


     # User-Data Project Parent Project Directory Path
     # ---------------
     # The project's parent directory where the user's data will be stored.
     Set-Variable `
         -Name "_USERDATA_PROJECT_PATH_" `
         -Value "$($GLOBAL:_USERDATA_ROOT_PATH_)\$([ProjectInformation]::projectName)" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "Provides the project's directory to help separate from other potential projects.";


     # Output Parent Directory Path
     # ---------------
     # The root directory that the builds reside.
     Set-Variable `
         -Name "_USERDATA_PROJECT_BUILDS_PATH_" `
         -Value "$($GLOBAL:_USERDATA_PROJECT_PATH_)\Builds" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "Holds the parent path in which all complied builds will be stored.";


     # Output Release Directory Path
     # ---------------
     # The directory that holds the 'Release' builds.
     Set-Variable `
         -Name "_USERDATA_PROJECT_BUILDS_RELEASE_PATH_" `
         -Value "$($GLOBAL:_USERDATA_PROJECT_BUILDS_PATH_)\Release" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "Holds the path for all released compiled builds that will be stored.";


     # Output Development Directory Path
     # ---------------
     # The directory that holds the 'Development' builds.
     Set-Variable `
         -Name "_USERDATA_PROJECT_BUILDS_DEVELOPMENT_PATH_" `
         -Value "$($GLOBAL:_USERDATA_PROJECT_BUILDS_PATH_)\Development" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "Holds the path for all developmental compiled builds that will be stored.";


     # ----
     # Program Data [Local AppData]


     # Program-Data Project Parent Directory Path
     # ---------------
     # The project parent directory where program-data will be stored.
     Set-Variable `
         -Name "_PROGRAMDATA_LOCAL_PROJECT_PATH_" `
         -Value "$($GLOBAL:_PROGRAMDATA_LOCAL_ROOT_PATH_)\$([ProjectInformation]::projectName)" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "This will contain the path as to where all related data of a loaded project will be stored.";


     # Log Directory for Projects Path
     # ---------------
     # The directory that will contain the log-files regarding activity that occurs while a project is loaded, such as operations.
     Set-Variable `
         -Name "_PROGRAMDATA_LOCAL_PROJECT_LOGS_PATH_" `
         -Value "$($GLOBAL:_PROGRAMDATA_LOCAL_PROJECT_PATH_)\Logs" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "This will hold the logfiles regarding each operation taken place within the loaded project.";


     # ----
     # Program Data [Roaming AppData]


     # Project Art Directory Path
     # ---------------
     # The directory that will contain the project's images that will be visible using Windows' Toast Notifications.
     Set-Variable `
         -Name "_PROGRAMDATA_ROAMING_PROJECT_ART_PATH_" `
         -Value "$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)\$([ProjectInformation]::projectName)\Art" `
         -Scope Global `
         -Option ReadOnly `
         -Visibility Public `
         -Force `
         -ErrorAction SilentlyContinue `
         -Description "Holds the path for the project's art pieces, such as logo and banner images.";


    # Project Logo Art
    # ---------------
    # The project's logo image that will be shown within the Windows Toast Notifications.
    Set-Variable `
        -Name "_PROGRAMDATA_ROAMING_PROJECT_ART_LOGO_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_ART_PATH_)\Logo.png" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -Force `
        -ErrorAction SilentlyContinue `
        -Description "Holds the path of the project's logo image that will be visible in Windows Toast Notifications.";


    # Project Banner Art
    # ---------------
    # The project's banner image (also known as Hero Image) that will be shown within the Windows Toast Notifications.
    Set-Variable `
        -Name "_PROGRAMDATA_ROAMING_PROJECT_ART_BANNER_PATH_" `
        -Value "$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_ART_PATH_)\Banner.png" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -Force `
        -ErrorAction SilentlyContinue `
        -Description "Holds the path of the project's banner image that will be visible in Windows Toast Notifications.";
 } # InitializationDirectoryPaths_Project()




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
function __GeneralizedVariables()
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
} # __GeneralizedVariables()




<# Initialization: Project Manager
 # -------------------------------
 # Documentation:
 #  This function will initialize the variables that will be used within the Project Manager functionality.
 # -------------------------------
 #>
function __InitializationProjectManager()
{
    # Project's Meta Filename
    Set-Variable `
        -Name "_META_FILENAME_" `
        -Value "meta" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "Provides the filename of the project's meta file.";


    # Required meta string data (Natural Numbers)
    Set-Variable `
        -Name "_META_REQUIRED_NUMBER_OF_STRINGS_" `
        -Value 8 `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "The required number of strings that must be obtained from the Meta file.";


    # Meta Value Delimiter
    Set-Variable `
        -Name "_META_VALUE_DELIMITER_" `
        -Value "=" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "This defines the delimiter that marks the value of a variable within the meta file.";


    # Meta string for 'Project Name' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_NAME_" `
        -Value "Project_Name" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Name.";


    # Meta string for 'Project Code Name' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_CODE_NAME_" `
        -Value "Project_CodeName" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Code Name.";


    # Meta string for 'Project Revision' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_REVISION_" `
        -Value "Project_Revision" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Revision.";


    # Meta string for 'Project Output File Name' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_OUTPUT_FILENAME_" `
        -Value "Project_OutputFileName" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Output File Name.";


    # Meta string for 'Project Website URL' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_URL_WEBSITE_" `
        -Value "Project_WebsiteURL" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Website URL.";


    # Meta string for 'Project Wiki URL' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_URL_WIKI_" `
        -Value "Project_WikiURL" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Wiki URL.";


    # Meta string for 'Project Source Code URL' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_URL_SOURCE_CODE_" `
        -Value "Project_SourceCodeURL" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Source Code URL.";


    # Meta string for 'Project Signature' found within the project's meta file.
    Set-Variable `
        -Name "_META_STRING_PROJECT_SIGNATURE_" `
        -Value "Project_Signature" `
        -Scope Global `
        -Option ReadOnly `
        -Visibility Public `
        -ErrorAction SilentlyContinue `
        -Description "A string within the project's meta file that contains the Project's Signature.";
} # __InitializationProjectManager()




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




<# Initialize Directory Choice [ENUM]
 # -------------------------------
 # Provides a readability aid as to what directories are to be
 #  initialized or re-assigned if necessary.
 # -------------------------------
 #>
enum InitializationsDirectoryChoice
{
    Program     = 0;    # Program Directories
    Project     = 1;    # Project Directories
} # InitializationsDirectoryChoice