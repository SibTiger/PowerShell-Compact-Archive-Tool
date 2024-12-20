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




<# Project Manager - Common
 # ------------------------------
 # ==============================
 # ==============================
 # This class only contains common functions that will be utilized within the Project Manager functionalities.
 #  Within this class contains common algorithms and methods that can be used freely within the Project
 #  Manager classes.
 #>




class ProjectManagerCommon
{
   <# Draw Main Instructions - SelectFromTable
    # -------------------------------
    # Documentation:
    #  Provide instructions to the user regarding how to select a project from the given table.  Also allow
    #     for other options to be visible as well.
    # -------------------------------
    #>
    hidden static [void] __DrawMenuInstructionsForTable()
    {
        # Alert the user of the Item Column, the Item Number is used to select the desired project.
        [Logging]::DisplayMessage("To select a $($GLOBAL:_PROGRAMNAMESHORT_) Project, use the Item Number.");

        # Show the standard instructions
        [CommonCUI]::DrawMenuInstructions();
    } # __DrawMenuInstructionsForTable()




   <# Get Installed Projects
    # -------------------------------
    # Documentation:
    #  This function is designed to obtain all of the projects that are installed within the program's
    #   environment.  To obtain what projects that had been installed, this function will inspect the meta
    #   file within the projects directory.  The meta file will provide essential information regarding each
    #   installed project.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {ProjectMetaData} Installed Projects.
    #   This will provide information as to what projects had been installed within the program's environment.
    #   This variable should be empty when provided, this function will populate it.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed
    #     $true  = Operation was successful
    # -------------------------------
    #>
    hidden static [bool] __GetInstalledProjects([System.Collections.ArrayList] $installedProjects)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Cache the File.IO information that will be obtained by using the Get-ChildItem CMDLet.
        [System.Collections.ArrayList] $listOfMetaFiles = [System.Collections.ArrayList]::new();
        # ----------------------------------------



        # Make sure that the projects directory exists before trying to scan the directory.
        #  If the directory was not found, then abort the operation.
        if (![CommonIO]::CheckPathExists($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_ , $true))
        {   # Unable to find the installation path for the Projects.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Failed to obtain a list of installed projects as the directory could not be found!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Tried to inspect the Project's Installation Path:`r`n"       + `
                                            "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *

            # Unable to continue; abruptly abort from this function
            return $false;
        } # if : Failed to Find Project's Installation Path


        # Obtain to obtain all of the existing meta files within the projects directory.
        try
        {
            # NOTE:
            #  I prefer to use strict-data types, but Get-ChildTem can provide either a single instance or an ArrayList
            #   type.  I will use this variable to determine the data type and push it through this program's ArrayList,
            #   thus keeping the consistency within this code base.
            $dynamicVariable = Get-ChildItem `
                                -LiteralPath $GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_ `
                                -Filter $GLOBAL:_META_FILENAME_ `
                                -Recurse `
                                -Depth 1 `
                                -ErrorAction Stop;


            # Determine if the Get-ChildItem CMDLet did not provide us with any instances, thus the path was empty.
            if ($NULL -eq $dynamicVariable)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to find any installed projects!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                                "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Finished; there's nothing we can do.
                return $true;
            } # If : No Installed Projects Found


            # Determine if the Get-ChildItem CMDLet provided us with a single instance of the System.IO.FileInfo type
            #   or an ArrayList containing multiple instances of the System.IO.FileInfo.
            # Single Instance
            elseif ($dynamicVariable.GetType().Name -eq "FileInfo")
            { $listOfMetaFiles.Add($dynamicVariable); }

            # Array List of Instances
            else
            { foreach($instance in $dynamicVariable) { $listOfMetaFiles.Add($instance); }}


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Searched for installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects");

            # Generate any additional information that might be useful
            #   Just in case if we could not find any installed projects, than provide this default message
            #   instead.
            [string] $logAdditionalMSG = "$($NULL)";

            # Determine how the Additional Message will be generate
            if ($listOfMetaFiles.Count -ge 1)
            {
                # There exists one or more projects that had been installed.
                $logAdditionalMSG = "Found $($listOfMetaFiles.Count.ToString()) $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n";

                # Append all of the project information into the debug string.
                foreach($file in $listOfMetaFiles)
                {
                    $logAdditionalMSG +=   ("`t`tDirectory:`r`n"                                + `
                                            "`t`t`t$($file.DirectoryName)`r`n"                  + `
                                            "`t`tDirectory Base Name:`r`n"                      + `
                                            "`t`t`t$($file.Directory.BaseName)`r`n"             + `
                                            "`t`tFile Name:`r`n"                                + `
                                            "`t`t`t$($file.Name)`r`n"                           + `
                                            "`t`tFull Path:`r`n"                                + `
                                            "`t`t`t$($file.FullName)`r`n"                       + `
                                            "`t - - - - - - - - - - - - - - - - - - - -`r`n"    );
                } # foreach : Scan Each Project Found
            } # If : One or More Projects found


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # try : Obtain List of Meta Files

        # Caught Error
        catch
        {
            # Unable to obtain list of installed projects


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to obtain a list of installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = ("Failed to obtain a list of installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                            "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)`r`n"        + `
                                            "`tTarget File to Inspect:`r`n"                                     + `
                                            "`t`t$($GLOBAL:_META_FILENAME_)`r`n"                                + `
                                            "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation; cannot proceed forward.
            return [ProjectManagerInstallationExitCondition]::Fatal;
        } # catch : Error Reached



        # Begin storing the project information into the Project's Meta Data structure,
        #   such that we can process the data.
        foreach ($item in $listOfMetaFiles)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Entry that will be added into the Project's array
            [ProjectMetaData] $newProjectEntry = [ProjectMetaData]::New();
            # ----------------------------------------


            # Obtain the information from the File.IO Operation
            # -------------------------------------------------
            # Meta File Path
            $newProjectEntry.SetMetaFilePath($item.DirectoryName);

            # Meta File Name
            $newProjectEntry.SetMetaFileName($item.Name);

            # Project Directory Name
            $newProjectEntry.SetProgramDirectoryName($Item.Directory.BaseName);

            # Adjust the Verification
            $newProjectEntry.SetProgramVerification([ProjectMetaDataFileVerification]::Installed);

            # Mark as installed
            $newProjectEntry.SetProgramInstalled($true);

            # Set the message\description
            $newProjectEntry.SetProgramMessage("Installed project loaded for evaluation purposes.");
            # -------------------------------------------------



            # Obtain the information from the Meta file.
            if (![ProjectManagerCommon]::ReadMetaFile($item.FullName, `                 # Where the meta file is located
                                                        [ref] $newProjectEntry))        # Obtain information from the Project's Meta Data
            {
                # Could not evaluate the project's meta data information.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Failed to obtain a list of installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Project information provided may or may not be accurate:`r`n"    + `
                                                [ProjectManagerCommon]::OutputMetaProjectInformation($newProjectEntry));

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Something had failed; continue to the next
                continue;
            } # if : Failed to Read Meta File


            # Finally, add the new entry into the main project list.
            $installedProjects.Add($newProjectEntry);


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Successfully found $($GLOBAL:_PROGRAMNAMESHORT_) Project, $($newProjectEntry.GetProjectName())!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project information that had been collected:`r`n"                        + `
                                            [ProjectManagerCommon]::OutputMetaProjectInformation($newProjectEntry));

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # foreach



        # Finished
        return $true;
    } # __GetInstalledProjects()




   <# Read Meta Data File
    # -------------------------------
    # Documentation:
    #  This function is designed to read the project's meta file and extract the known information from the
    #   file.  By doing this, we also have to assure that the data structure is correct and provide that
    #   information to the callee function.
    # -------------------------------
    # Input:
    #  [string] Meta File Path
    #   Holds the absolute location of the project's meta file.
    #  [ProjectMetaData] (REFERENCE) Project's Meta Data
    #   This reference will contain the contents within the Project's Meta Data file.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed
    #     $true  = Operation was successful
    # -------------------------------
    #>
    static [bool] ReadMetaFile([string] $metaFilePath, `        # Absolute path to the project's meta file
                                [ref] $projectMetaData)         # The project's meta data
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the contents from the meta file, we can use this to manipulate and process the data
        #   as necessary to retrieve the proper data.
        [System.Collections.ArrayList] $metaContents = [System.Collections.ArrayList]::new();

        # Hash Table that will hold our obtained meta data strings.
        $metaStrings = @{};

        # Temporary Meta Data Information
        [string]    $tempProjectName            = $NULL;
        [string]    $tempProjectCodeName        = $NULL;
        [UInt64]    $tempProjectRevision        = 0;
        [string]    $tempProjectOutputFileName  = $null;
        [string]    $tempProjectURLWebsite      = $null;
        [string]    $tempProjectURLWiki         = $null;
        [string]    $tempProjectURLSourceCode   = $null;
        [GUID]      $tempProjectGUID            = $GLOBAL:_DEFAULT_BLANK_GUID_;
        # ----------------------------------------


        # Make sure that the file exists
        if (![CommonIO]::CheckPathExists($metaFilePath, $true))
        {
            # File does not exist


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Meta File does not exist or is not accessible!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "Unable to open the Project's Meta File at the designated Path:`r`n" + `
                                            "`t`t$($metaFilePath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation.
            return $false;
        } # if : File does not exist


        # Try to open the file and obtain the contents
        if (![CommonIO]::ReadTextFile($metaFilePath, $metaContents))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Unable to load the Meta data file!`r`n"               + `
                                            $GLOBAL:_PROGRAMNAMESHORT_ + "Project cannot be loaded!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Meta File to Open:`r`n"          + `
                                            "`t`t$($metaFilePath)`r`n");

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
        } # if : Cannot Open Meta File


        # Iterate through the lines (from the Meta file) and pick out the necessary meta data.
        foreach ($line in $metaContents)
        {
            # Project Name
            if($line.Contains($GLOBAL:_META_STRING_PROJECT_NAME_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_NAME_, $line); }


            # Project Codename
            if($line.Contains($GLOBAL:_META_STRING_PROJECT_CODE_NAME_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_CODE_NAME_, $line); }


            # Project Revision
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_REVISION_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_REVISION_, $line); }


            # Project Output Filename
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_, $line); }


            # Project URL Website
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_, $line); }


            # Project URL Wiki
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_URL_WIKI_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_URL_WIKI_, $line); }


            # Project URL Source Code
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_, $line); }


            # Project Signature
            elseif ($line.Contains($GLOBAL:_META_STRING_PROJECT_SIGNATURE_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_SIGNATURE_, $line); }
        } # foreach: Find Necessary Strings


        # Make sure that we have enough information from the project's meta file.
        if ($metaStrings.Count -ne $GLOBAL:_META_REQUIRED_NUMBER_OF_STRINGS_)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # This will show the line number in which a string appears within the meta file.
            [UInt64] $metaLineNumber                        = 0;

            # Only used to show all of the meta contents in a formatted view.
            [System.Collections.ArrayList] $cacheStringList = [System.Collections.ArrayList]::new();
            # ----------------------------------------



            # Generate and format the string
            foreach ($stringLine in $metaContents)
            {
                # Increment the Line Number
                $metaLineNumber++;

                # Build String
                $cacheStringList.Add("`t`t$($metaLineNumber.ToString()) | $($stringLine)`r`n");
            } # foreach: Iterate and Generate a Formatted String



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to obtain significant information from the project's meta file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG =   ("Got $(($metaStrings.Count).ToString()) out of $(($GLOBAL:_META_REQUIRED_NUMBER_OF_STRINGS_).ToString()) Useful strings from the Meta file!`r`n" + `
                                            "`tExpected to find the following information in meta file:`r`n"    + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_NAME_)`r`n"                  + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_CODE_NAME_)`r`n"             + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_REVISION_)`r`n"              + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_)`r`n"       + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_)`r`n"           + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_URL_WIKI_)`r`n"              + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_)`r`n"       + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_SIGNATURE_)`r`n"             + `
                                            "`r`n"                                                              + `
                                            "`tInstead, the following was found within the meta file:`r`n"      + `
                                            "$($cacheStringList)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Unable to continue forward, abort
            return $false;
        } # if : Not Enough Information from Meta File



        # Obtain the information gathered from the Meta file
        # ---------------------------------------------------
        try
        {
            # Project's Name
            $tempProjectName            = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_NAME_]               `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_NAME_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Code Name
            $tempProjectCodeName        = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_CODE_NAME_]          `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_CODE_NAME_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Revision
            $tempProjectRevision        = [UInt64]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_REVISION_]           `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_REVISION_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Output File Name
            $tempProjectOutputFileName  = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_]    `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Website URL
            $tempProjectURLWebsite      = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_]        `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Wiki URL
            $tempProjectURLWiki         = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_WIKI_]           `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_URL_WIKI_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Source Code URL
            $tempProjectURLSourceCode   = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_]    `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Signature
            $tempProjectGUID            = [GUID]    ($metaStrings[$GLOBAL:_META_STRING_PROJECT_SIGNATURE_]          `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_SIGNATURE_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();
        } # try : Assign Proper Values

        # Caught Error
        catch
        {   # Improper Datatype Assignment had Occurred.

            # Declarations and Initializations
            # ----------------------------------------
            # This will show the line number in which a string appears within the meta file.
            [UInt64] $metaLineNumber                        = 0;

            # Only used to show all of the meta contents in a formatted view.
            [System.Collections.ArrayList] $cacheStringList = [System.Collections.ArrayList]::new();
            # ----------------------------------------



            # Generate and format the string
            foreach ($stringLine in $metaContents)
            {
                # Increment the Line Number
                $metaLineNumber++;

                # Build String
                $cacheStringList.Add("`t`t$($metaLineNumber.ToString()) | $($stringLine)`r`n");
            } # foreach: Iterate and Generate a Formatted String



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to Convert Data Structure from the Input Meta File!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG =   ("Obtained the following values from the project's meta file:`r`n"                                       + `
                                            "`t`t- Project Name             =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_NAME_])`r`n"             + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Code Name        =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_CODE_NAME_])`r`n"        + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Revision         =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_REVISION_])`r`n"         + `
                                            "`t`t`tTried to cast as UInt64`r`n"                                                                     + `
                                            "`t`t- Project Output Path      =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_])`r`n"  + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Website URL      =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_])`r`n"      + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Wiki URL         =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_WIKI_])`r`n"         + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Source Code URL  =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_])`r`n"  + `
                                            "`t`t`tTried to cast as String`r`n"                                                                     + `
                                            "`t`t- Project Signature        =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_SIGNATURE_])`r`n"        + `
                                            "`t`t`tTried to cast as GUID`r`n"                                                                       + `
                                            "`r`n"                                                                                                  + `
                                            "`tMeta File Contents:`r`n"                                                                             + `
                                            "$($cacheStringList)")                                                                                  ;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($displayErrorMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Unable to use the data from the Meta file
            return $false;
        } # catch : Caught an Error



        # Try to apply the data into the project meta data structure
        if (($projectMetaData.Value.SetProjectName($tempProjectName)                        -eq $false) -or `
            ($projectMetaData.Value.SetProjectCodeName($tempProjectCodeName)                -eq $false) -or `
            ($projectMetaData.Value.SetProjectRevision($tempProjectRevision)                -eq $false) -or `
            ($projectMetaData.Value.SetProjectOutputFileName($tempProjectOutputFileName)    -eq $false) -or `
            ($projectMetaData.Value.SetProjectURLWebsite($tempProjectURLWebsite)            -eq $false) -or `
            ($projectMetaData.Value.SetProjectURLWiki($tempProjectURLWiki)                  -eq $false) -or `
            ($projectMetaData.Value.SetProjectURLSourceCode($tempProjectURLSourceCode)      -eq $false) -or `
            ($projectMetaData.Value.SetMetaGUID($tempProjectGUID)                           -eq $false))
        {   # Log this information and record what had failed.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage        = ("One or more values could not be set within the Project's Meta Data Structure!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG  = ("Meta Properties and Value Results:`r`n"                                                             + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_NAME_)`r`n"                                          + `
                                            "`t`t- Value:   $($tempProjectName)`r`n"                                                            + `
                                            "`t`t- Type:    $($tempProjectName.GetType().Name)`r`n"                                             + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectName($tempProjectName))`r`n"                     + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_CODE_NAME_)`r`n"                                     + `
                                            "`t`t- Value:   $($tempProjectCodeName)`r`n"                                                        + `
                                            "`t`t- Type:    $($tempProjectCodeName.GetType().Name)`r`n"                                         + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectCodeName($tempProjectCodeName))`r`n"             + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_REVISION_)`r`n"                                      + `
                                            "`t`t- Value:   $($tempProjectRevision)`r`n"                                                        + `
                                            "`t`t- Type:    $($tempProjectRevision.GetType().Name)`r`n"                                         + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectRevision($tempProjectRevision))`r`n"             + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_OUTPUT_FILENAME_)`r`n"                               + `
                                            "`t`t- Value:   $($tempProjectOutputFileName)`r`n"                                                  + `
                                            "`t`t- Type:    $($tempProjectOutputFileName.GetType().Name)`r`n"                                   + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectOutputFileName($tempProjectOutputFileName))`r`n" + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_URL_WEBSITE_)`r`n"                                   + `
                                            "`t`t- Value:   $($tempProjectURLWebsite)`r`n"                                                      + `
                                            "`t`t- Type:    $($tempProjectURLWebsite.GetType().Name)`r`n"                                       + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectURLWebsite($tempProjectURLWebsite))`r`n"         + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_URL_WIKI_)`r`n"                                      + `
                                            "`t`t- Value:   $($tempProjectURLWiki)`r`n"                                                         + `
                                            "`t`t- Type:    $($tempProjectURLWiki.GetType().Name)`r`n"                                          + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectURLWiki($tempProjectURLWiki))`r`n"               + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_URL_SOURCE_CODE_)`r`n"                               + `
                                            "`t`t- Value:   $($tempProjectURLSourceCode)`r`n"                                                   + `
                                            "`t`t- Type:    $($tempProjectURLSourceCode.GetType().Name)`r`n"                                    + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetProjectURLSourceCode($tempProjectURLSourceCode))`r`n"   + `
                                            "`tProperty:    $($GLOBAL:_META_STRING_PROJECT_SIGNATURE_)`r`n"                                     + `
                                            "`t`t- Value:   $($tempProjectGUID)`r`n"                                                            + `
                                            "`t`t- Type:    $($tempProjectGUID.GetType().Name)`r`n"                                             + `
                                            "`t`t- Result:  $($projectMetaData.Value.SetMetaGUID($tempProjectGUID))`r`n"                        );

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Failure to set the values, unable to continue.
            return $false;
        } # if : Failure to Set



        # Operation was successful
        return $true;
    } # ReadMetaFile()




   <# Output Meta Project Information
    # -------------------------------
    # Documentation:
    #  This function is designed to generate a string that contains the project's meta data information, and
    #   then return that string such that it can used for presenting to the user or to log the contents to
    #   the logfile.
    # -------------------------------
    # Input:
    #  [ProjectMetaData] Project Information
    #   Contains the project's meta data information.
    # -------------------------------
    # Output:
    #  [string] Project Information in String Form
    #       Contains the project information that will be presented in a string form.
    # -------------------------------
    #>
    static [string] OutputMetaProjectInformation([ProjectMetaData] $projectInformation)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Project Information within a string format.
        [string] $projectInformationString = $NULL;
        # ----------------------------------------


        # Craft the string
        $projectInformationString = ( `
                            "`tMeta File Name:`r`n"                                                 + `
                            "`t`t"  +   $projectInformation.GetMetaFileName()           +   "`r`n"  + `
                            "`tMeta File Path:`r`n"                                                 + `
                            "`t`t"  +   $projectInformation.GetMetaFilePath()           +   "`r`n"  + `
                            "`tProject Signature:`r`n"                                              + `
                            "`t`t"  +   $projectInformation.GetMetaGUID()               +   "`r`n"  + `
                            "`tProject Name:`r`n"                                                   + `
                            "`t`t"  +   $projectInformation.GetProjectName()            +   "`r`n"  + `
                            "`tProject Code Name:`r`n"                                              + `
                            "`t`t"  +   $projectInformation.GetProjectCodeName()        +   "`r`n"  + `
                            "`tProject Revision:`r`n"                                               + `
                            "`t`t"  +   $projectInformation.GetProjectRevision()        +   "`r`n"  + `
                            "`tOutput File Name:`r`n"                                               + `
                            "`t`t"  +   $projectInformation.GetProjectOutputFileName()  +   "`r`n"  + `
                            "`tWebsite URL:`r`n"                                                    + `
                            "`t`t"  +   $projectInformation.GetProjectURLWebsite()      +   "`r`n"  + `
                            "`tWiki URL:`r`n"                                                       + `
                            "`t`t"  +   $projectInformation.GetProjectURLWiki()         +   "`r`n"  + `
                            "`tSource Code URL:`r`n"                                                + `
                            "`t`t"  +   $projectInformation.GetProjectURLSourceCode()   +   "`r`n"  + `
                            "`tProject Directory Name:`r`n"                                         + `
                            "`t`t"  +   $projectInformation.GetProgramDirectoryName()   +   "`r`n"  + `
                            "`tArchive Integrity Verification:`r`n"                                 + `
                            "`t`t"  +   $projectInformation.GetProgramVerification()    +   "`r`n"  + `
                            "`tProject Installed:`r`n"                                              + `
                            "`t`t"  +   $projectInformation.GetProgramInstalled()       +   "`r`n"  + `
                            "`tStatus Message:`r`n"                                                 + `
                            "`t`t"  +   $projectInformation.GetProgramMessage()         +   "`r`n"  );


        # Return the string containing the Project Information.
        return $projectInformationString;
    } # OutputMetaProjectInformation()




   <# Draw Table Project Information
    # -------------------------------
    # Documentation:
    #  This function will show a list of projects that had been installed into the PowerShell Compact-Archive
    #   Tool's environment to the user by using a table generated by PowerShell.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {ProjectMetaData} List of Installed Projects
    #   This will provide information as to what projects had been installed within the program's environment.
    # -------------------------------
    #>
    static [void] DrawTableProjectInformation([System.Collections.ArrayList] $listOfProjects)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Create an empty array that will soon hold project information that will be presented to the user.
        [System.Object[]] $projectTableView = @();

        # Logging Output of the project information
        [string] $projectLoggingInformation = $NULL;

        # Keep count of how many projects are installed; this will be in Natural Numbers (i.e. 1, 2, 3, 4, n)
        [UInt64] $countInstalls             = 0;
        # ----------------------------------------



        # If the list is empty, do not continue further within this function.
        if (($listOfProjects.Count  -eq 0)      -or `
            ($listOfProjects        -eq $NULL))
            { return; }


        # Provide a caption for the table
        [Logging]::DisplayMessage("List of Installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects:");


        # Iterate through each installed project and populate the rows for the table.
        foreach ($project in $listOfProjects)
        {
            # Increment the Counter
            $countInstalls++;

            # Build the table columns
            $row                = "" | Select-Object Item, Project, CodeName, Revision;

            # Build the table row
            $row.Item           = $countInstalls;
            $row.Project        = $project.GetProjectName();
            $row.CodeName       = $project.GetProjectCodeName();
            $row.Revision       = $project.GetProjectRevision();

            # Append row to the table array
            $projectTableView += $row;

            # Build the Logging information
            $projectLoggingInformation += ( "`tItem:                $($countInstalls.ToString())`r`n"                   + `
                                            "`t`tProject Name:      $($project.GetProjectName())`r`n"                   + `
                                            "`t`tProject Code Name: $($project.GetProjectCodeName())`r`n"               + `
                                            "`t`tRevision:          $($project.GetProjectRevision().ToString())`r`n"    + `
                                            "`t`tOutput Filename:   $($project.GetProjectOutputFileName())`r`n"         + `
                                            "`t`tProject Website:   $($project.GetProjectURLWebsite())`r`n"             + `
                                            "`t`tProject Wiki:      $($project.GetProjectURLWiki())`r`n"                + `
                                            "`t`tProject Source:    $($project.GetProjectURLSourceCode())`r`n"          + `
                                            "`t`tSignature:         $($project.GetMetaGUID())`r`n"                      + `
                                            "`r`n`r`n");
        } # foreach : Iterate all Projects


        # Show the table to the user
        Format-Table                        `
            -InputObject $projectTableView  `
            -AutoSize                       `
            -Wrap                           `
                | Out-Host;


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("Providing user with list of installed projects using a table.");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                        "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)`r`n"        + `
                                        "`tInstalled Projects List:`r`n"                                    + `
                                        "$($projectLoggingInformation)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *
    } # DrawTableProjectInformation()
} # ProjectManagerCommon