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




<# Project User Configuration
 # ------------------------------
 # ==============================
 # ==============================
 # This class contains information regarding the PowerShell Compact-Archive Tool Project User Configuration.
 #  Within the User Configuration file, it will contain preferences that are specifically for a project that
 #  is currently installed within PSCAT's environment.
 #>




class ProjectUserConfiguration
{
    # Member Variables :: Properties
    # =================================================
    # =================================================

    # Project Source Path
    # ---------------
    # Contains the absolute path to the game's project source files, that will be compiled.
    hidden [string] $__gameProjectSourcePath;




    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    ProjectUserConfiguration()
    {
        # Game's Project Source Files Absolute Path
        $this.__gameProjectSourcePath = $NULL;
    } # Default Constructor




    # Initiated Object
    ProjectUserConfiguration([string] $gameProjectSourcePath)
    {
        # Game's Project Source Files Absolute Path
        $this.__gameProjectSourcePath = $gameProjectSourcePath;
    } # Initiated Object

    #endregion




    #region Getter Functions

   <# Get Game Project Source Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Game Project Source Path' variable.
    # -------------------------------
    # Output:
    #  [string] Game Project Source Path
    #   The value of the 'Game Project Source Path'.
    # -------------------------------
    #>
    [string] GetGameProjectSourcePath() { return $this.__gameProjectSourcePath; }

    #endregion




    #region Setter Functions

   <# Set Game Project Source Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Game Project Source Path' variable.
    # -------------------------------
    # Input:
    #  [String] Game Project Source Path
    #   Sets the value of the 'Game Project Source Path' variable.
    # -------------------------------
    # Output:
    #  [bool] status
    #   $true   = Success; value had been changed.
    #   $false  = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGameProjectSourcePath([string] $newValue)
    {
        # Make sure that the new value satisfies these following requirements:
        if (([CommonIO]::IsStringEmpty($newValue)           -eq $true) -or `    # Make sure that the value is not empty
             [CommonIO]::CheckPathExists($newValue, $true)  -eq $false)         # Make sure that the path exists
        { return $false; }


        # Update the value as requested
        $this.__gameProjectSourcePath = $newValue;


        # Operation was successful
        return $true;
    } # SetGameProjectSourcePath()

    # endregion




    #region Member Functions

   <# Set Empty Game Project Source Path
    # -------------------------------
    # Documentation:
    #  Sets an empty value within the 'Game Project Source Path' variable.
    # -------------------------------
    #>
    [void] SetGameProjectSourcePathAsEmpty() { $this.__gameProjectSourcePath = $NULL; }

    #endregion
} # ProjectUserConfiguration