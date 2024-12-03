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




<# User Experience
 # ------------------------------
 # ==============================
 # ==============================
 # This class provides the ability to bridge the gap between Terminal
 #  and Graphical interaction.  It is possible for the user to want to
 #  experience the program by pure terminal'isc or to incorporate some
 #  Graphical elements to make their use of interacting with the
 #  application easier and simplistic.  Or, however, perhaps the user's
 #  Operating System is incapable of supporting a Graphical User Interface.
 #  This class is designed such that it is possible to make that determination
 #  easily without having to provide duplicated code everywhere within the
 #  scripts source.
 #>




class UserExperience
{
   <# Browse for Files
    # -------------------------------
    # Documentation:
    #   This function will allow the user to select a particular or a handful of files with
    #   the respected file-extensions.  By using this functionality, the user will be able
    #   to expeditiously navigate to the desired file or files with ease - instead of having
    #   to spend extra time digging for a specific file's URI.
    # -------------------------------
    # Input:
    #  [string] Title
    #   This will display a very brief description onto the Title bar of the Dialog window.
    #  [string] Default Extension
    #   Provides the default, or preferred, file extension that calling function is requiring.
    #  [string] Filter Extension Options
    #   Provides additional file extensions that are acceptable.
    #  [Bool] Select Multiple Files
    #   When true, the user can select one or more files.  False, however, the user can
    #   only pick just one file.
    #  [Browser Interface Style] Style
    #   This provides the ability to determine which browser interface is to be drawn to the
    #   user.
    #  [System.Collections.ArrayList] Files
    #   This provides the list of files that had been selected by the user.  This is returned
    #   to the calling function for further evaluation.
    # -------------------------------
    # Output:
    #  [bool] File(s) Selected
    #   $true   = The user had selected at least one file
    #   $false  = The user had cancelled the operation, no file had been selected.
    # -------------------------------
    #>
    static [bool] BrowseForFile([string] $title,                        ` # Brief Description in Title Bar.
                                [string] $defaultExtension,             ` # Default File Extension.
                                [string] $filterExtensionOptions,       ` # Additional File Extensions.
                                [bool] $selectMultipleFiles,            ` # Select only one OR at least one file.
                                [BrowserInterfaceStyle] $style,         ` # Style of the Browser interface.
                                [System.Collections.ArrayList] $files)    # Selected files to be returned.
    {
        # Determine if we should use the Graphical User Interface variant
        if ([SystemInformation]::OperatingSystem() -eq [SystemInformationOperatingSystem]::Windows)
        {   # Use the Graphical User Interface
            return [CommonGUI]::BrowseFile($title,                  ` # Brief Description in Title Bar
                                        $defaultExtension,          ` # Default File Extension
                                        $filterExtensionOptions,    ` # Additional File Extensions
                                        $selectMultipleFiles,       ` # Select only one _or_ multiple files.
                                        $style,                     ` # Style of the Browser interface.
                                        $files);                      # Selected files to be returned.
        } # if : Provide GUI

        # Use the Console UI instead
        else
        {   # Use the Terminal User Interface
            return [CommonCUI]::BrowseForTargetFile($title,
                                                    $defaultExtension,
                                                    $files);
        } # else : Use Console UI
    } # BrowseForFile()




   <# Browse for Directory
    # -------------------------------
    # Documentation:
    #   This function will allow the user to select a directory using the
    #   Folder Browser dialog window.  By using this functionality, the
    #   user will be able to expeditiously navigate to the desired directory
    #   with ease - instead of having to spend extra time digging for a
    #   specific folder within the host's filesystem.
    # -------------------------------
    # Input:
    #  [string] Instructions
    #   Provide a brief description as to what the user needs to find within the local host.
    #  [BrowserInterfaceStyle] Style
    #   This provides the ability to determine which browser interface is to be drawn to the user.
    #  [string] (REFERENCE) Results
    #   If a directory were to be selected, then we will return the value within this variable.
    # -------------------------------
    # Output:
    #  [bool] Path Selected
    #   $true   = The user had selected a directory and the result had been stored.
    #   $false  = The user had cancelled the operation, no directory had been selected.
    # -------------------------------
    #>
    static [bool] BrowseForFolder([string] $instructions,               ` # Show description to the user; reminder
                                    [BrowserInterfaceStyle] $style,     ` # Style of the Browser interface
                                    [ref] $targetFolder)                  # Selected directory to be returned.
    {
        # Determine if we should use the Graphical User Interface variant
        if ([SystemInformation]::OperatingSystem() -eq [SystemInformationOperatingSystem]::Windows)
        {   # Use the Graphical User Interface
            return [CommonGUI]::BrowseDirectory($instructions,      ` # Show description to the user; reminder
                                                $style,             ` # Style of the Browser interface
                                                $targetFolder);}      # Selected directory to be returned.

        # Use the Console UI instead
        else
        {   # Use the Terminal User Interface
            return [CommonCUI]::BrowseForTargetDirectory($instructions,
                                                        $targetFolder);
        } # else : Use Console UI
    } # BrowseForFolder()
} # Class : UserExperience