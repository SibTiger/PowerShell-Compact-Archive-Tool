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




<# Uninitializations
 # -------------------------------
 # Documentation:
 #  This function will remove the global variables that had been previously initialized during
 #   the initialization phase, or simply the startup operation.  The reason for this function is
 #   remove the global variables that we had used for this program, but we do not want to the
 #   variables to be available long-after the application had been terminated normally.  As such,
 #   the variables may be available to the user outside of the application, which we want to
 #   prevent.
 #
 #  This feature is only viable if the client relies heavily on the terminal; meaning that the
 #   terminal was already opened before the application was running.  Thus, the program's
 #   environment will remain available long after the program had been terminated.
 # -------------------------------
 #>
 function Uninitializations()
 {
    

    # Program Name
    Remove-Variable -Name "_PROGRAMNAME_" `
        -Scope Global -Force;


    # Program Name (Abbreviated)
    Remove-Variable -Name "_PROGRAMNAMESHORT_" `
        -Scope Global -Force;

    # Version
    Remove-Variable -Name "_VERSION_" `
        -Scope Global -Force;

    # Version Name
    Remove-Variable -Name "_VERSIONNAME_" `
        -Scope Global -Force;

    # Release Date
    Remove-Variable -Name "_RELEASEDATE_" `
        -Scope Global -Force;

    # License
    Remove-Variable -Name "_LICENSE_" `
        -Scope Global -Force;

    # Program Homepage
    Remove-Variable -Name "_PROGRAMSITEHOMEPAGE_" `
        -Scope Global -Force;

    # Program Wiki
    Remove-Variable -Name "_PROGRAMSITEWIKI_" `
        -Scope Global -Force;

    # Program Downloads
    Remove-Variable -Name "_PROGRAMSITEDOWNLOADS_" `
        -Scope Global -Force;

    # Program Source Repository
    Remove-Variable -Name "_PROGRAMSITESOURCEREPOSITORY_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's source repository site.";

    # Report a Bug or Feature
    Remove-Variable -Name "_PROGRAMREPORTBUGORFEATURE_" -Value "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki/Report" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides a URL to the application's bug tracker site.";

    # .NET Framework Requirement
   Remove-Variable -Name "_DOTNETFRAMEWORK_" -Value "5.0.405" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Specifies the minimum required version of the dotNET Core Framework.";

    # PowerShell Version Requirement
    Remove-Variable -Name "_POWERSHELLVERSION_" -Value "7.2.1" `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Specifies the minimum required version of the PowerShell Core version.";

    # Debug Logging functionality
    Remove-Variable -Name "_DEBUGLOGGING_" -Value $true `
        -Option ReadOnly -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Allows control to either enable or disable the program's logging functionalities.";

    # Logging Lock Key
    #  This will help to avoid recursive function calls when an event is being logged.
    #  This key, when 'false' will adhere to the user's logging preference.  But when
    #  'true', the user's logging preference will be ignored (regardless true or false)
    #  and will disallow events to be logged.
    # NOTE: This functionality is mainly utilized with the WriteToFile() function in the
    #  CommonIO object.
    Remove-Variable -Name "_LOGGINGLOCKKEY_" -Value $false `
        -Option None -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "This variable will help to prevent a stack overflow issue that could occur when writing logged data.";

    # Splash Screen Hold Timer (Seconds)
    #  How many seconds the splash screen will remain visible to the user, yet locking the
    #  program from proceeding onwards.
    Remove-Variable -Name "_STARTUPSPLASHSCREENHOLDTIME_" -Value 4 `
        -Option None -Scope Global -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "The amount of time that is required for the splash screen to remain present on the terminal buffer.";

    # Script Absolute Script Path
    # ---------------
    # The path that this script currently resides from.
    #  Highly useful for 'absolute' paths.
    # BUG POSSIBLE: If the path has been disrupted at program's runtime,
    #  then it is possible that this path will be broken - thus causing
    #  problems when trying to throw or recall files from specific directories
    #  from an absolute directory.
    Remove-Variable -Name "_SCRIPTPATH_" -Value $PSScriptRoot `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the application resides.";


    # ----
    # User Data


    # User-Data Root Directory Path
    # ---------------
    # The root directory where user-data will be stored.
    Remove-Variable -Name "_USERDATA_ROOT_PATH_" -Value "$(FetchPathUserDocuments)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the user data will be stored.";


    # User-Data Project Parent Project Directory Path
    # ---------------
    # The project's parent directory where the user's data will be stored.
    Remove-Variable -Name "_USERDATA_PROJECT_PATH_" -Value "$($GLOBAL:_USERDATA_ROOT_PATH_)\$([ProjectInformation]::projectName)" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Provides the project's directory to help separate from other potential projects.";


    # Output Parent Directory Path
    # ---------------
    # The root directory that the builds reside.
    Remove-Variable -Name "_USERDATA_BUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_PROJECT_PATH_)\Builds" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which all complied builds will be stored.";


    # Output Release Directory Path
    # ---------------
    # The directory that holds the 'Release' builds.
    Remove-Variable -Name "_USERDATA_RELEASEBUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_BUILDS_PATH_)\Release" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the path for all released compiled builds that will be stored.";


    # Output Development Directory Path
    # ---------------
    # The directory that holds the 'Development' builds.
    Remove-Variable -Name "_USERDATA_DEVBUILDS_PATH_" -Value "$($GLOBAL:_USERDATA_BUILDS_PATH_)\Development" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the path for all developmental compiled builds that will be stored.";


    # ----
    # Program Data [Local AppData]


    # Program-Data Root Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Remove-Variable -Name "_PROGRAMDATA_ROOT_LOCAL_PATH_" -Value "$(FetchPathAppDataLocal)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the program data will be stored, but remains local to this system within a Roaming Profile environment.";


    # Program-Data Project Parent Directory Path
    # ---------------
    # The project parent directory where program-data will be stored.
    Remove-Variable -Name "_PROGRAMDATA_PROJECT_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_ROOT_LOCAL_PATH_)\$([ProjectInformation]::projectName)" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Contains the path of where all related program data will be stored that is affiliated with the loaded project.";


    # Log Directory Path
    # ---------------
    # The directory that will contain the log-files regarding this program and some special
    #  operations.
    Remove-Variable -Name "_PROGRAMDATA_LOGS_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_PROJECT_PATH_)\Logs" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which all of the logfiles will be stored.";


    # ----
    # Program Data [Roaming AppData]


    # Program-Data Parent Directory Path
    # ---------------
    # The root directory where program-data will be stored.
    Remove-Variable -Name "_PROGRAMDATA_ROOT_ROAMING_PATH_" -Value "$(FetchPathAppDataRoaming)\$($GLOBAL:_PROGRAMNAME_)" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the root path in which the program data will be stored, but can be moved around within a Roaming Profile environment.";


    # User Data (Configuration)
    # ---------------
    # This directory will hold the user's configurations.
    Remove-Variable -Name "_PROGRAMDATA_CONFIGS_PATH_" -Value "$($GLOBAL:_PROGRAMDATA_ROOT_ROAMING_PATH_)\Configs" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Holds the parent path in which holds the user's configurations";

    # PowerShell's Window Title
    Remove-Variable -Name "_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_" -Value "$([CommonIO]::GetTerminalWindowTitle())" `
        -Scope Global -Force -Option ReadOnly -ErrorAction SilentlyContinue `
        -Visibility Private `
        -Description "Maintains the current title of the PowerShell's window title; because we will change it - this will allow us to revert the title back.";

 } # Uninitializations()