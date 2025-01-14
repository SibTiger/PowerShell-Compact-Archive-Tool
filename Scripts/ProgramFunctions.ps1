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




<# Create Program Required Directories
 # -------------------------------
 # Documentation:
 #  This function is designed to assure that the required directories are available within the user's
 #   filesystem.  If incase one or more directories could not be found, then this function will try
 #   to create them.  Because of the design of the program, these directories are paramount in order
 #   for this application to function properly.  If the directories can not be created successfully,
 #   then we will return an error stating as such back to the calling function.
 #
 # ----
 #
 #  Directories to Create:
 #   - Program Data:
 #      - %HomePath%\Documents\<PROGRAM_NAME>
 #      - %LOCALAPPDATA%\<PROGRAM_NAME>
 #      - %LOCALAPPDATA%\<PROGRAM_NAME>\Logs
 #      - %APPDATA%\<PROGRAM_NAME>
 #      - %APPDATA%\<PROGRAM_NAME>\Configs
 #      - %APPDATA%\<PROGRAM_NAME>\Projects
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
    return (([CommonIO]::MakeDirectory($GLOBAL:_USERDATA_ROOT_PATH_)                        -eq $true)  -and `      # The Program Root Directory
            ([CommonIO]::MakeDirectory($GLOBAL:_PROGRAMDATA_LOCAL_ROOT_PATH_)               -eq $true)  -and `      # The Program Data Root [Local]
            ([CommonIO]::MakeDirectory($GLOBAL:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_)       -eq $true));            # The Program Data Logs [Local]
} # CreateDirectories()




<# Check Program Directories
 # -------------------------------
 # Documentation:
 #  This function will validate if the required directories already exists within the host's filesystem.
 #   If one required directory is missing, than this function will provide that signal to the calling
 #   function.
 #
 # ----
 #
 #  Directories to Create:
 #   - Program Data:
 #      - %HomePath%\Documents\<PROGRAM_NAME>
 #      - %LOCALAPPDATA%\<PROGRAM_NAME>
 #      - %LOCALAPPDATA%\<PROGRAM_NAME>\Logs
 #      - %APPDATA%\<PROGRAM_NAME>
 #      - %APPDATA%\<PROGRAM_NAME>\Configs
 #      - %APPDATA%\<PROGRAM_NAME>\Projects
 # -------------------------------
 # Output:
 #  [bool] Exit code
 #    $true = Directories exist
 #    $false = One or more directories does not exist.
 # -------------------------------
 #>
function CheckProgramDirectories()
{
    return (([CommonIO]::CheckPathExists($GLOBAL:_USERDATA_ROOT_PATH_, $true) -eq $true)                        -and `      # The Program Root Directory
            ([CommonIO]::CheckPathExists($GLOBAL:_PROGRAMDATA_LOCAL_ROOT_PATH_, $true)              -eq $true)  -and `      # The Program Data Root [Local]
            ([CommonIO]::CheckPathExists($GLOBAL:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_, $true)      -eq $true));            # The Program Data Logs [Local]
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
    [string] $pathMyDocuments = FetchPathUserDocuments;         # My Documents
    [string] $pathLocalAppData = FetchPathAppDataLocal;         # Local AppData
    [string] $pathRoamingAppData = FetchPathAppDataRoaming;     # Roaming AppData
    # ----------------------------------------


    # Check the following special directories if they already exists within the host system.
    return (([CommonIO]::CheckPathExists($pathMyDocuments, $true) -eq $true)        -and ` # My Documents
            ([CommonIO]::CheckPathExists($pathLocalAppData, $true) -eq $true)       -and ` # Local AppData
            ([CommonIO]::CheckPathExists($pathRoamingAppData, $true) -eq $true));          # Roaming AppData
} # CheckSpecialDirectories()