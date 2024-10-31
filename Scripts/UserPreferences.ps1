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
    static [UserPreferences] GetInstance([string] $outputBuildsPath)
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [UserPreferences]::_instance)
        {
            # Create a new instance of the singleton object.
            [UserPreferences]::_instance = [UserPreferences]::new($outputBuildsPath);
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [UserPreferences]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)
    # Project Builds Path
    # ---------------
    # The absolute path of the builds output location.
    Hidden [string] $__outputBuildsPath;


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
        # Output Build Path
        $this.__outputBuildsPath = $global:_USERDATA_PROJECT_BUILDS_PATH_;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # Default Constructor




    # User Preference : On-Load
    UserPreferences([string] $outputBuildsPath)
    {
        # Output Build Path
        $this.__outputBuildsPath = $outputBuildsPath;

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

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
    [string] GetProjectBuildsPath() { return $this.__outputBuildsPath; }




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
    [GUID] GetObjectGUID() { return $this.__objectGUID; }

    #endregion



    #region Setter Functions

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

    #endregion
} # UserPreferences