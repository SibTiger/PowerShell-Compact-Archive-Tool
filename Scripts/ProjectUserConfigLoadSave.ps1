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




<# Project User Configuration - Load\Save
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to allow the user to load or save their User Configuration preference file that
 #  contains information regarding a specific PowerShell Compact-Archive Tool Project.
 #>




class ProjectUserConfigurationLoadSave
{
    #region Save

   <# Save Project User Configuration
    # -------------------------------
    # Documentation:
    #  This function will save a Project User Configuration file within the PowerShell Compact-Archive-
    #   Tool's Project's directory.
    # -------------------------------
    # Input:
    #  [ProjectUserConfiguration] User Configuration
    #   The User Configuration contents that will be inserted into the User Config file.
    #  [ProjectMetaData] Project's Meta Data
    #   Desired Project's Meta Data information in which the User Config file will be saved.
    # -------------------------------
    # Output:
    #  $true    = Successfully saved the User Config file.
    #  $false   = Failed to save the User Config file.
    # -------------------------------
    #>
    static [bool] Save ([ProjectUserConfiguration] $userConfig, `       # User Config. Contents
                            [ProjectMetaData] $metaData)                # Project to Save User Config.
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain the contents of the User Config. object into a string.
        [string] $userConfigContentsString = $NULL;
        # ----------------------------------------



        # Make sure that the PSCAT Project Directory exists before continuing forward.
        if (![CommonIO]::CheckPathExists($metaData.GetMetaFilePath(), $true))
        {
            # Project Directory does not exist, cannot save User Config. file.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the Message Box string that will be presented to the user
            [string] $displayErrorMessage = ("The project named '$($metaData.GetProjectName())' does not " + `
                                            "appear to be installed correctly!`r`n" + `
                                            "Could not find installation path:`r`n" + `
                                            $metaData.GetMetaFilePath());

            # Generate the initial message
            [string] $logMessage = "$($GLOBAL:_PROGRAMNAMESHORT_) Project directory does not exist, cannot save User Config file!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("$($GLOBAL:_PROGRAMNAMESHORT_) Project to Inspect:"               + "`r`n" + `
                                        "`tName:                " + $metaData.GetProjectName()              + "`r`n" + `
                                        "`tCodename:            " + $metaData.GetProjectCodeName()          + "`r`n" + `
                                        "`tRevision:            " + $metaData.GetProjectRevision()          + "`r`n" + `
                                        "`tOutput Filename:     " + $metaData.GetProjectOutputFileName()    + "`r`n" + `
                                        "`tWebsite URL:         " + $metaData.GetProjectURLWebsite()        + "`r`n" + `
                                        "`tWiki URL:            " + $metaData.GetProjectURLWiki()           + "`r`n" + `
                                        "`tSource URL:          " + $metaData.GetProjectURLSourceCode()     + "`r`n" + `
                                        "`tSignature:           " + $metaData.GetMetaGUID()                 + "`r`n" + `
                                        "`tMeta Path:           " + $metaData.GetMetaFilePath()             );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity(  $logMessage, `              # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that there was no projects found and log that same message for
            #  referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                        [LogMessageLevel]::Error);      # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($displayErrorMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot save User Config file.
            return $false;
        } # if : PSCAT Proj. Dir. does not Exist


        # Craft the string of all of the properties contained within the Project User Configuration object.
        $userConfigContentsString = [ProjectUserConfigurationLoadSave]::SaveUserConfigurationString($userConfig);


        # Save the User Configuration file
        if (![CommonIO]::MakeTextFile($GLOBAL:_PROJECT_USER_CONFIG_FILENAME_,   `
                                        $metaData.GetMetaFilePath(),            `
                                        $userConfigContentsString))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the Message Box string that will be presented to the user
            [string] $displayErrorMessage = ("Unable to save the user configuration file for the project, $($GLOBAL:_PROGRAMNAMESHORT_)!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("User Configuration Properties:"                                      + "`r`n" + `
                                        "`t`tFilename:          " + $GLOBAL:_PROJECT_USER_CONFIG_FILENAME_      + "`r`n" + `
                                        "`t`tPath:              " + $metaData.GetMetaFilePath()                 + "`r`n" + `
                                        "`t`tContents:"                                                         + "`r`n" + `
                                        "`t----------------------------------------------"                      + "`r`n" + `
                                        $userConfigContentsString                                               + "`r`n" + `
                                        "`t----------------------------------------------"                      + "`r`n" + `
                                        "`t$($GLOBAL:_PROGRAMNAMESHORT_) Project:"                              + "`r`n" + `
                                        "`t`tName:              " + $metaData.GetProjectName()                  + "`r`n" + `
                                        "`t`tCodename:          " + $metaData.GetProjectCodeName()              + "`r`n" + `
                                        "`t`tRevision:          " + $metaData.GetProjectRevision()              + "`r`n" + `
                                        "`t`tOutput Filename:   " + $metaData.GetProjectOutputFileName()        + "`r`n" + `
                                        "`t`tWebsite URL:       " + $metaData.GetProjectURLWebsite()            + "`r`n" + `
                                        "`t`tWiki URL:          " + $metaData.GetProjectURLWiki()               + "`r`n" + `
                                        "`t`tSource URL:        " + $metaData.GetProjectURLSourceCode()         + "`r`n" + `
                                        "`t`tSignature:         " + $metaData.GetMetaGUID()                     );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity(  $logMessage, `              # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that there was no projects found and log that same message for
            #  referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                        [LogMessageLevel]::Error);      # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($displayErrorMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *
        } # if : Failed to Save Userconfig file



        # Operation was successful
        return $true;
    } # Save()




   <# Save User Configuration String
    # -------------------------------
    # Documentation:
    #  This function will generate the output that will be inserted into the User Configuration file.
    # -------------------------------
    # Input:
    #  [ProjectUserConfiguration] User Configuration
    #   Containing the user's preferences that will be placed in the User Config. file.
    # -------------------------------
    # Output:
    #  [string] User Configuration String
    #   The User Configuration Preferences as a complete string that can be written to a file.
    # -------------------------------
    #>
    static hidden [string] SaveUserConfigurationString([ProjectUserConfiguration] $userConfig)
    {
        return ("GameProjectSourcePath = " + $userConfig.GetGameProjectSourcePath() + "`r`n");
    } # SaveUserConfigurationString()

    #endregion




    #region Load

   <# Load Project User Configuration
    # -------------------------------
    # Documentation:
    #  This function will try to load the User Configuration file that is stored within the desired PSCAT
    #   Project installation directory.
    # -------------------------------
    # Input:
    #  [ProjectUserConfiguration] {REFERENCE} User Configuration
    #   The User Configuration that will contain the user's preferences for the desired PSCAT Project.
    #  [ProjectMetaData] Project's Meta Data
    #   The desired PSCAT Project's Meta Data that contains populated information.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #   $true   = Successfully accessed and obtained User Configuration data.
    #   $false  = Failed to access or obtain any values within the User Configuration data.
    # -------------------------------
    #>
    static [bool] Load ([ref] $userConfig,                      ` # User Configuration to populate
                        [ProjectMetaData] $projectMetaData)       # Project Meta Data
    {
        # Declarations and Initializations
        # ----------------------------------------
        # ----------------------------------------




    } # Load()

    #endregion
} # ProjectUserConfigurationLoadSave