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
    # -------------------------------
    # Output:
    #  $true    = Successfully saved the User Config file.
    #  $false   = Failed to save the User Config file.
    # -------------------------------
    #>
    static [bool] Save ([ProjectUserConfiguration] $userConfig)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain the contents of the User Config. object into a string.
        [string] $userConfigContentsString = $NULL;

        # Retrieve the current instance of the Project Information object
        [ProjectInformation] $projectInformation = [ProjectInformation]::GetInstance();

        # Create a new instance of the Project Meta Data object; required in order to save with new data.
        [ProjectMetaData] $metaData = [ProjectMetaData]::New();
        # ----------------------------------------



        # Obtain the project's meta data from the desired project.
        if (![ProjectManagerCommon]::ReadMetaFile($projectInformation.GetProjectInstallationPath(), [ref] $metaData))
        {
            # Unable to obtain the project's meta data from the file.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the Message Box string that will be presented to the user
            [string] $displayErrorMessage = ("Unable to save the changes for '$($metaData.GetProjectName())'!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $projInfoStr = $NULL;
            $projectInformation.Show([ProjectInformationShowDetail]::Full, [ref] $projInfoStr);
            [string] $logAdditionalMSG = $projInfoStr;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity(  $logMessage, `              # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that there was an error while trying to obtain the project's
            #   meta data information.
            [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                        [LogMessageLevel]::Error);      # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($displayErrorMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot save User Config file.
            return $false;
        } # if : Failed to Access Meta Data




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
        $userConfigContentsString = [ProjectUserConfigurationLoadSave]::__SaveUserConfigurationString($userConfig);


        # Save the User Configuration file
        if (![CommonIO]::MakeTextFile($GLOBAL:_PROJECT_USERCONFIG_FILENAME_,    `
                                        $metaData.GetMetaFilePath(),            `
                                        $userConfigContentsString,              `
                                        $True))
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
                                        "`t`tFilename:          " + $GLOBAL:_PROJECT_USERCONFIG_FILENAME_       + "`r`n" + `
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


            # Operation had failed
            return $false;
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
    static hidden [string] __SaveUserConfigurationString([ProjectUserConfiguration] $userConfig)
    { return ("$($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_) $($GLOBAL:_PROJECT_USERCONFIG_VALUE_DELIMITER_) $($userConfig.GetGameProjectSourcePath())`r`n"); }

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
        # This will hold the contents from the User Config file, we can use this to manipulate the process the data
        #   as necessary to retrieve the proper data.
        [System.Collections.ArrayList] $userConfigContents = [System.Collections.ArrayList]::new();

        # A hash table that will hold the obtained user config content strings.
        $userConfigHash = @{};

        # Temporary User Configuration Information
        [string]    $tempGameProjectSourcePath  = $NULL;

        # User Configuration File Path
        [string]    $userConfigurationPath      = $projectMetaData.GetMetaFilePath() + "\" + $GLOBAL:_PROJECT_USERCONFIG_FILENAME_;
        # ----------------------------------------


        # Make sure that the User Configuration file exists.
        if (![CommonIO]::CheckPathExists($userConfigurationPath, $true))
        {
            # File could not be found


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The User Configuration file does not exist or is not accessible!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "User Configuration File Path:`r`n"             + `
                                            "`t`t$($userConfigurationPath)`r`n"             + `
                                            "`tProject Name:`r`n"                           + `
                                            "`t`t$($projectMetaData.GetProjectName())`r`n"  + `
                                            "`tProject Installation Path:`r`n"              + `
                                            "`t`t$($projectMetaData.GetMetaFilePath())"     );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation
            return $false;
        } # if : User Config. Not Found


        # Try to open the file and obtain the contents
        if (![CommonIO]::ReadTextFile($userConfigurationPath, $userConfigContents))
        {
            # Unable to open\read the User Configuration file


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = "Unable to load " + $projectMetaData.GetProjectName() + " User Configuration!";

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "User Configuration File to Open:`r`n"              + `
                                            "`t`t$($userConfigurationPath)`r`n"                 + `
                                            "`tProject Name:`r`n"                               + `
                                            "`t`t$($projectMetaData.GetProjectName())`r`n"      + `
                                            "`tProject Installation Path:`r`n"                  + `
                                            "`t`t$($projectMetaData.GetMetaFilePath())"         );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation.
            return $false;
        } # if : Cannot Open Project User Config.



        # Parse through the lines (from the User Configuration file) and pick out the necessary data we need.
        foreach($line in $userConfigContents)
        {
            # Game Project Source Path
            if ($line.Contains($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_))
            { $userConfigHash.Add($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_, $line); }
        } # foreach : Find Necessary Strings



        # Make sure that we have enough information from the project User Configuration file.
        if ($userConfigHash.Count -ne $GLOBAL:_PROJECT_USERCONFIG_REQUIRED_NUMBER_OF_STRINGS_)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # This will show the line number in which a string appears within the User Config. file.
            [UInt64] $lineNumber                            = 0;

            # Only used to show all of the User Config. contents in a formatted view.
            [System.Collections.ArrayList] $cacheStringList = [System.Collections.ArrayList]::new();
            # ----------------------------------------



            # Generate and format the string
            foreach ($stringLine in $userConfigContents)
            {
                # Increment the Line Number
                $lineNumber++;

                # Build String
                $cacheStringList.Add("`t`t$($lineNumber.ToString()) | $($stringLine)`r`n");
            } # foreach: Iterate and Generate a Formatted String



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to obtain significant information from the project's User Configuration file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "Got $(($userConfigHash.Count).ToString()) out of "                                     + `
                                                "$(($GLOBAL:_PROJECT_USERCONFIG_REQUIRED_NUMBER_OF_STRINGS_).ToString()) Useful "   + `
                                                "strings from the User Configuration file!`r`n"                                     + `
                                            "`tExpected to find the following information in User Configuration file:`r`n"          + `
                                            "`t`t - $($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_)`r`n"                         + `
                                            "`r`n"                                                                                  + `
                                            "`tInstead, the following was found within the User Config. file:`r`n"                  + `
                                            $cacheStringList);

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Unable to continue forward, abort
            return $false;
        } # if : Not Enough Information from project User Configuration



        # Obtain the information gathered from the User Configuration file
        # -----------------------------------------------------------------
        try
        {
            # Game Project Source Path
            $tempGameProjectSourcePath   = [string] ($userConfigHash[$GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_]     `
                                                        -Replace "$($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_)$($GLOBAL:_PROJECT_USERCONFIG_VALUE_DELIMITER_)").Trim();
        } # Try : Assign Proper Values


        # Caught Error
        catch
        {
            # Improper Datatype Assignment had occurred.

            # Declarations and Initializations
            # ----------------------------------------
            # This will show the line number in which a string appears within the User Config. file.
            [UInt64] $lineNumber                            = 0;

            # Only used to show all of the User Config. contents in a formatted view.
            [System.Collections.ArrayList] $cacheStringList = [System.Collections.ArrayList]::new();
            # ----------------------------------------



            # Generate and format the string
            foreach ($stringLine in $userConfigContents)
            {
                # Increment the Line Number
                $lineNumber++;

                # Build String
                $cacheStringList.Add("`t`t$($lineNumber.ToString()) | $($stringLine)`r`n");
            } # foreach: Iterate and Generate a Formatted String



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to Convert Data Structure from the Input User Configuration File!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG =   ("Obtained the following values from the project's Configuration File file:`r`n"                             + `
                                            "`t`t- Game Project Source Path =`t$($userConfigHash[$GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_])`r`n" + `
                                            "`t`t`tTried to cast as String`r`n"                                                                         + `
                                            "`r`n"                                                                                                      + `
                                            "`tUser Configuration File Contents:`r`n"                                                                   + `
                                            "$($cacheStringList)")                                                                                      ;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($displayErrorMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Unable to use the data from the User Configuration file
            return $false;
        } # Catch : Caught an Error



        # Try to apply the data into the User Configuration data structure.
        if (($userConfig.Value.SetGameProjectSourcePath($tempGameProjectSourcePath)     -eq $false))
        {
            # Log this information and record what had failed.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage        = ("One or more values could not be set within the Project's User Configuration Structure!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG  = ("User Configuration Properties and Value Results:`r`n"                                               + `
                                            "`tProperty:    $($GLOBAL:_PROJECT_USERCONFIG_STRING_SOURCE_PATH_)`r`n"                             + `
                                            "`t`t- Value:   $($tempGameProjectSourcePath)`r`n"                                                  + `
                                            "`t`t- Type:    $($tempGameProjectSourcePath.GetType().Name)`r`n"                                   + `
                                            "`t`t- Result:  $($userConfig.Value.SetGameProjectSourcePath($tempGameProjectSourcePath))"          );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Failure to set the values, unable to continue.
            return $false;
        } # if : Failure to Set



        # Made it thus far, the operation was successful
        return $true;
    } # Load()

    #endregion
} # ProjectUserConfigurationLoadSave