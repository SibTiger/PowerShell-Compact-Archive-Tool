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




<# User Preferences
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds the User Preferences within this program.  The user's preferences
 #  will give rise to what the user wants to do with this program and perform the task
 #  as the user's demands with minimal configuration after the first initial setup.
 # The goal of this program is to assure that the user can merely 'click-and-forget',
 #  thus the program should NOT stand in the way of the user's tasks.  With that in
 #  mind, it is paramount that the User Preferences should provide little headache as
 #  necessary; in-fact, all of the configurations within the classes provides that same
 #  principle.
 #>




class UserPreferences
{
    # Object Singleton Instance
    # =================================================
    # =================================================


    #region Singleton Instance

    # Singleton Instance of the object
    hidden static [UserPreferences] $_instance = $null;




    # Get the instance of this singleton object (Default)
    static [UserPreferences] GetInstance()
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [UserPreferences]::_instance)
        {
            # Create a new instance of the singleton object.
            [UserPreferences]::_instance = [UserPreferences]::new();
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [UserPreferences]::_instance;
    } # GetInstance()




    # Get the instance of this singleton object (With Args)
    #  Useful if we already know that we have to instantiate
    #  a new instance of this particular object.
    static [UserPreferences] GetInstance([UserPreferencesCompressTool] $compressionTool, `      # Which Compression Software to use
                                        [string] $projectPath, `                                # Project's absolute path
                                        [string] $outputBuildsPath, `                           # Output Builds absolute path
                                        [UserPreferencesVersionControlTool] $versionControl)    # Utilize Git features (if software available)
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [UserPreferences]::_instance)
        {
            # Create a new instance of the singleton object.
            [UserPreferences]::_instance = [UserPreferences]::new($compressionTool, `
                                                                $projectPath, `
                                                                $outputBuildsPath, `
                                                                $versionControl);
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [UserPreferences]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Compression Choice
    # ---------------
    # The choice of which software tool will be used for generating archive data-files.
    Hidden [UserPreferencesCompressTool] $__compressionTool;


    # Project Path
    # ---------------
    # The absolute path of the ZDoom based project in-which to compile.
    Hidden [string] $__projectPath;


    # Project Builds Path
    # ---------------
    # The absolute path of the builds output location.
    Hidden [string] $__outputBuildsPath;


    # Version Control Choice
    # ---------------
    # The choice of which software tool be used for managing the local copy or local
    #   repository of the project's source files.
    Hidden [UserPreferencesVersionControlTool] $__versionControlTool;


    # Object GUID
    # ---------------
    # Provides a unique identifier to the object, useful to make sure that we are using
    #  the right object within the software.
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
        $this.__compressionTool = [UserPreferencesCompressTool]::InternalZip;

        # Project Path
        $this.__projectPath = ".\";

        # Output Build Path
        $this.__outputBuildsPath = $global:_USERDATA_BUILDS_PATH_;

        # Use Git Features
        $this.__versionControlTool = [UserPreferencesVersionControlTool]::None;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # Default Constructor




    # User Preference : On-Load
    UserPreferences([UserPreferencesCompressTool] $compressionTool, `
                    [string] $projectPath, `
                    [string] $outputBuildsPath, `
                    [UserPreferencesVersionControlTool] $versionControl)
    {
        # Compression Tool
        $this.__compressionTool = $compressionTool;

        # Project Path
        $this.__projectPath = $projectPath;

        # Output Build Path
        $this.__outputBuildsPath = $outputBuildsPath;

        # Use Git Features
        $this.__versionControlTool = $versionControl;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

   <# Get Compression Tool Choice
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Software Compression Tool Choice' variable.
    # -------------------------------
    # Output:
    #  [UserPreferencesCompressTool] Software Compression Tool Choice
    #   The value of the Software Compression Tool Choice.
    # -------------------------------
    #>
    [UserPreferencesCompressTool] GetCompressionTool()
    {
        return $this.__compressionTool;
    } # GetCompressionTool()




   <# Get Project Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Path' variable.
    # -------------------------------
    # Output:
    #  [string] Project Path
    #   The value of the Project Path.
    # -------------------------------
    #>
    [string] GetProjectPath()
    {
        return $this.__projectPath;
    } # GetProjectPath()




   <# Get Project Builds Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Builds Path' variable.
    # -------------------------------
    # Output:
    #  [string] Project Builds Path
    #   The value of the Project Builds Path.
    # -------------------------------
    #>
    [string] GetProjectBuildsPath()
    {
        return $this.__outputBuildsPath;
    } # GetProjectBuildsPath()




   <# Get Version Control Tool
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Version Control Tool' variable.
    # -------------------------------
    # Output:
    #  [UserPreferencesVersionControlTool] Version Control Tool
    #   The value of the Version Control Tool.
    # -------------------------------
    #>
    [UserPreferencesVersionControlTool] GetVersionControlTool()
    {
        return $this.__versionControlTool;
    } # GetVersionControlTool()




   <# Get Object GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the object's 'Global Unique ID' variable.
    # -------------------------------
    # Output:
    #  [GUID] Global Unique Identifier (GUID)
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
    #  Sets a new value for the 'Software Compression Tool Choice' variable.
    # -------------------------------
    # Input:
    #  [UserPreferencesCompressTool] Software Compression Tool
    #   A choice between the various compression software that is supported
    #    within the application and is available on the user's system.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionTool([UserPreferencesCompressTool] $newVal)
    {
        # Because the value must fit within the 'UserPreferencesCompressTool'
        #  datatype, there really is no point in checking if the new requested
        #  value is 'legal'.  Thus, we are going to trust the value and
        #  automatically return success.
        $this.__compressionTool = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionTool()




   <# Set Project Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Path' variable.
    # -------------------------------
    # Input:
    #  [string] Project Directory Path
    #   The new location of the Project Directory Path.
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
    #  Sets a new value for the 'Project Builds Path' variable.
    # -------------------------------
    # Input:
    #  [string] Project Builds Directory Path
    #   The new location of the Project Builds Directory Path.
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




   <# Set Version Control Tool
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Version Control Tool' variable.
    # -------------------------------
    # Input:
    #  [UserPreferencesVersionControlTool] Version Control Tool
    #   When set to any other value than 'None' (Nothing), this will allow
    #   the application to utilize the functionality of the Version Control
    #   software to manage or obtain information regarding the local working
    #   copy or local repository of the source files on the host's local
    #   machine.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVersionControlTool([UserPreferencesVersionControlTool] $newVal)
    {
        # Because the value must fit within the 'UserPreferencesVersionControlTool'
        #   datatype, there really is no point in checking if the new requested
        #   value is considered 'legal'.  Thus, we are going to trust the value
        #   and automatically return success.
        $this.__versionControlTool = $newVal;

        # Successfully updated.
        return $true;
    } # SetVersionControlTool()

    #endregion
} # UserPreferences




<# User Preferences Compress Tool [ENUM]
 # -------------------------------
 # Associated with what type of compression tool software should be used when wanting to
 #  compact a data into an archive-file.
 #
 # This provides a list of software that this application supports.
 # -------------------------------
 #>
enum UserPreferencesCompressTool
{
    InternalZip = 0; # Microsoft's .NET 4.5 (or later)
    SevenZip    = 1; # 7Zip's 7Za (CLI)
} # UserPreferencesCompressTool




<# User Preferences Version Control Tool [ENUM]
 # -------------------------------
 # Associated with what type of Version Control (VCS or SCM) will be used to manage the
 #  local copy or local repository stored on the user's host system.
 #
 # This provides a list of software that this application supports.
 # -------------------------------
 #>
enum UserPreferencesVersionControlTool
{
    None    = 0;    # Nothing
    GitSCM  = 1;    # Git-SCM
} # UserPreferencesVersionControlTool