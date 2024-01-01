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




<# Project Manager - Common
 # ------------------------------
 # ==============================
 # ==============================
 # This class only contains common functions that will be used for the Project Manager functionality.  These
 #  functions are only intended to be used for the Project Manager, as these methods are designed to be
 #  shared for various parent algorithms.
 #>




 class ProjectManagerCommon
 {
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
        if (![CommonIO]::CheckPathExists($($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_) , $true))
        {   # Unable to find the installation path for the Projects.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Failed to obtain a list of installed projects as the directory could not be found!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Tried to inspect the Project's Installation Path:`r`n"        + `
                                            "`t`t($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)";

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
                                -LiteralPath $($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_) `
                                -Filter $GLOBAL:_META_FILENAME_ `
                                -Recurse `
                                -Depth 1 `
                                -ErrorAction Stop;


            # Determine if the Get-ChildItem CMDLet provided us with a single instance of the System.IO.FileInfo type
            #   or an ArrayList containing multiple instances of the System.IO.FileInfo.
            # Single Instance
            if ($dynamicVariable.GetType().Name -eq "FileInfo")
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
                                            "`t`tFile Name:`r`n"                                + `
                                            "`t`t`t$($file.Name)`r`n"                           + `
                                            "`t`tFull Path:`r`n"                                + `
                                            "`t`t`t$($file.FullName)`r`n"                       + `
                                            "`t - - - - - - - - - - - - - - - - - - - -`r`n");
                } # foreach : Scan Each Project Found
            } # If : One or More Projects found


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Verbose);# Message level

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
                                            "`t`t$($GLOBAL:_METAL_FILENAME_)`r`n"                               + `
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
            [ProjectMetaData]       $newProjectEntry        = [ProjectMetaData]::New();             # Entry to add into Array
            [UInt64]                $newProjectRevision     = 0;                                    # Cache project's revision
            [string]                $newProjectName         = $null;                                # Cache project's name
            [GUID]                  $newProjectSignature    = $($GLOBAL:_DEFAULT_BLANK_GUID_);      # Cache project's GUID
            # ----------------------------------------


            # Obtain the information from the File.IO Operation
            # -------------------------------------------------
            # Directory Path
            $newProjectEntry.SetFilePath($item.DirectoryName);

            # File Name
            $newProjectEntry.SetFileName($item.Name);

            # Adjust the Verification
            $newProjectEntry.SetVerification([ProjectMetaDataFileVerification]::Installed);

            # Mark as installed
            $newProjectEntry.SetInstalled($true);

            # Set the message\description
            $newProjectEntry.SetMessage("Installed project loaded for evaluation purposes.");
            # -------------------------------------------------



            # Obtain the information from the Meta file.
            if (![ProjectManagerCommon]::__ReadMetaFile($item.FullName,                 `   # Where the meta file is located
                                                        [ref] $newProjectEntry))            # Obtain information from the Project's Meta Data
            {
                # Could not evaluate the project's meta data information.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Failed to obtain a list of installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Project information provided may or may not be accurate:`r`n"    + `
                                                "`t`tFile Path:`r`n"                                            + `
                                                "`t`t`t$($newProjectEntry.GetFilePath())`r`n"                   + `
                                                "`t`tFile Name:`r`n"                                            + `
                                                "`t`t`t$($newProjectEntry.GetFileName())`r`n"                   + `
                                                "`t`tMeta File:`r`n"                                            + `
                                                "`t`t`t$($item.FullName)`r`n"                                   + `
                                                "`t`tVerification State:`r`n"                                   + `
                                                "`t`t`t$($newProjectEntry.GetVerification())`r`n"               + `
                                                "`t`tInstalled Flag:`r`n"                                       + `
                                                "`t`t`t$($newProjectEntry.GetInstalled())`r`n"                  + `
                                                "`t`tInternal Message`r`n"                                      + `
                                                "`t`t`t$($newProjectEntry.GetMessage())`r`n"                    + `
                                                "`t`tProject Revision ID:`r`n"                                  + `
                                                "`t`t`t$($newProjectEntry.GetProjectRevision())`r`n"            + `
                                                "`t`tProject Name:`r`n"                                         + `
                                                "`t`t`t$($newProjectEntry.GetProjectName())`r`n"                + `
                                                "`t`tUnique Signature:`r`n"                                     + `
                                                "`t`t`t$($newProjectEntry.GetGUID())");


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
            [string] $logAdditionalMSG = ("Project information that had been collected:`r`n"                + `
                                            "`t`tFile Path:`r`n"                                            + `
                                            "`t`t`t$($newProjectEntry.GetFilePath())`r`n"                   + `
                                            "`t`tFile Name:`r`n"                                            + `
                                            "`t`t`t$($newProjectEntry.GetFileName())`r`n"                   + `
                                            "`t`tMeta File:`r`n"                                            + `
                                            "`t`t`t$($item.FullName)`r`n"                                   + `
                                            "`t`tVerification State:`r`n"                                   + `
                                            "`t`t`t$($newProjectEntry.GetVerification())`r`n"               + `
                                            "`t`tInstalled Flag:`r`n"                                       + `
                                            "`t`t`t$($newProjectEntry.GetInstalled())`r`n"                  + `
                                            "`t`tInternal Message`r`n"                                      + `
                                            "`t`t`t$($newProjectEntry.GetMessage())`r`n"                    + `
                                            "`t`tProject Revision ID:`r`n"                                  + `
                                            "`t`t`t$($newProjectEntry.GetProjectRevision())`r`n"            + `
                                            "`t`tProject Name:`r`n"                                         + `
                                            "`t`t`t$($newProjectEntry.GetProjectName())`r`n"                + `
                                            "`t`tUnique Signature:`r`n"                                     + `
                                            "`t`t`t$($newProjectEntry.GetGUID())");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


        } #foreach



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
    hidden static [bool] __ReadMetaFile([string] $metaFilePath, `       # Absolute path to the project's meta file
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
        [string]    $tempProjectName        = $NULL;
        [UInt64]    $tempProjectRevision    = 0;
        [GUID]      $tempProjectGUID        = $GLOBAL:_DEFAULT_BLANK_GUID_;
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
                                        [LogMessageLevel]::Error);    # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Abort the operation.
            return $false;
        } # if : File does not exist


        # Try to open the file and obtain the contents
        try
        {
            $metaContents = Get-Content                     `
                                -Path $metaFilePath         `
                                -ErrorAction Stop;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Successfully opened and read the Meta File");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "Meta File Path:`r`n"                                                           + `
                                            "`t`t$($metaFilePath)`r`n"                                                      + `
                                            "`r`n"                                                                          + `
                                            "`t`tFile Contents`r`n"                                                         + `
                                            "`t`t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n"   + `
                                            "`r`n");

            # We will output all of the contents from the meta file into the Log Description
            foreach ($line in $metaContents) { $logAdditionalMSG += "`t`t$($line)`r`n"; }

            # Just for readability and consistency sakes
            $logAdditionalMSG += "`r`n`t`t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level


            # * * * * * * * * * * * * * * * * * * *


        } # try : Retrieve the Contents from File

        # Caught an error
        catch
        {
            # Unable to open the meta file


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to open meta file!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = ("Failed to open meta file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Meta File to Open:`r`n"                              + `
                                            "`t`t$($metaFilePath)`r`n"                          + `
                                            "$([Logging]::GetExceptionInfo($_.Exception))");

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
        } # catch : Caught Error



        # Iterate through the array and pick out the necessary meta data.
        # Scan through the array and obtain the necessary data
        foreach ($item in $metaContents)
        {
            # Project Name
            if($item.Contains($GLOBAL:_META_STRING_PROJECT_NAME_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_NAME_, $item); }

            # Project Revision
            elseif ($item.Contains($GLOBAL:_META_STRING_PROJECT_REVISION_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_REVISION_, $item); }

            # Project Signature
            elseif ($item.Contains($GLOBAL:_META_STRING_PROJECT_SIGNATURE_))
            { $metaStrings.Add($GLOBAL:_META_STRING_PROJECT_SIGNATURE_, $item); }
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
            [string] $logAdditionalMSG =    "Got $(($metaStrings.Count).ToString()) out of $(($GLOBAL:_META_REQUIRED_NUMBER_OF_STRINGS_).ToString()) Useful strings from the Meta file!`r`n" + `
                                            "`tExpected to find the following information in meta file:`r`n" + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_NAME_)`r`n" + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_REVISION_)`r`n" + `
                                            "`t`t - $($GLOBAL:_META_STRING_PROJECT_SIGNATURE_)`r`n" + `
                                            "`tInstead, the following was found within the meta file:`r`n" + `
                                            "$($cacheStringList)";

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
            $tempProjectName        = [string]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_NAME_]       `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_NAME_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Revision
            $tempProjectRevision    = [UInt64]  ($metaStrings[$GLOBAL:_META_STRING_PROJECT_REVISION_]   `
                                            -Replace "$($GLOBAL:_META_STRING_PROJECT_REVISION_)$($GLOBAL:_META_VALUE_DELIMITER_)").Trim();

            # Project's Signature
            $tempProjectGUID        = [GUID]    ($metaStrings[$GLOBAL:_META_STRING_PROJECT_SIGNATURE_]  `
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
            [string] $logAdditionalMSG =    "Obtained the following values from the project's meta file:`r`n"                           + `
                                            "`t`t- Project Name      =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_NAME_])`r`n"        + `
                                            "`t`t`tTried to cast as String`r`n"                                                         + `
                                            "`t`t- Project Revision  =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_REVISION_])`r`n"    + `
                                            "`t`t`tTried to cast as UInt64`r`n"                                                         + `
                                            "`t`t- Project Signature =`t$($metaStrings[$GLOBAL:_META_STRING_PROJECT_SIGNATURE_])`r`n"   + `
                                            "`t`t`tTried to cast as GUID`r`n"                                                           + `
                                            "`tMeta File Contents:`r`n"                                                                 + `
                                            "$($cacheStringList)"                                                                       ;


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Unable to use the data from the Meta file
            return $false;
        } # catch : Caught an Error
        # ---------------------------------------------------



        # Apply the data into the project meta data structure
        $projectMetaData.Value.SetProjectName($tempProjectName);
        $projectMetaData.Value.SetProjectRevision($tempProjectRevision);
        $projectMetaData.Value.SetGUID($tempProjectGUID);



        # Finished
        return $true;
    } # __ReadMetaFile()
} # ProjectManagerCommon