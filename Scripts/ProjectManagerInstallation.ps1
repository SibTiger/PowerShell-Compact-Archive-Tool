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




<# Project Manager - Installation and Update
 # ------------------------------
 # ==============================
 # ==============================
 # This class will help guide the user into installing and\or updating PowerShell Compact-Archive Tool
 #  projects into the environment.  This functionality will allow the user to ultimately utilize this
 #  program to compile their desired mods into a package, in which they can then distribute builds or
 #  keep locally for testing.
 #>




class ProjectManagerInstallation
{
   <# Project Manager Installer - Main Entry
    # -------------------------------
    # Documentation:
    #  This function will guide the user through the installation\update producer, such that the
    #   desired projects are safely installed\updated for the user.
    # -------------------------------
    #>
    static [void] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain a list of files that the user wishes to install\update within PSCAT.
        #   NOTE: The base datatype is System.Object, _BUT_ each element within the Array List will change
        #           over time - making it easier to process.
        #   DATATYPE AFTER Windows' File Browser:
        #       |_ Root: System.Object
        #           |_ [0]: System.Object
        #           |_ [1]: System.Object
        #           |_ [n]: System.Object
        #   DATATYPE AFTER MetamorphoseType
        #       |_ Root: System.Object
        #           |_[0]: ProjectMetaData
        #           |_[1]: ProjectMetaData
        #           |_[n]: ProjectMetaData
        [System.Collections.ArrayList] $listOfProjectsToInstall = [System.Collections.ArrayList]::New();

        # Operation Status; this will provide the overall operation state.
        [ProjectManagerInstallationExitCondition] $operationState = [ProjectManagerInstallationExitCondition]::Error;
        # ----------------------------------------


        # Clear the terminal of all previous text; keep the space clean so that it is easier
        #   for the user to read the information presented.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Install Projects section.
        [CommonCUI]::DrawSectionHeader("Install $($GLOBAL:_PROGRAMNAMESHORT_) Projects");


        # Provide the instructions
        [ProjectManagerInstallation]::__DrawMainInstructions();


        # Show what Projects are already installed within the program
        [ProjectManagerInstallation]::__ShowCurrentInstalledProjects();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain the projects form the user.
        if (![ProjectManagerInstallation]::__GetProjectsFromUser($listOfProjectsToInstall))
        {
            # Alert the user that they had aborted the operation.
            [Logging]::DisplayMessage(  "User had aborted the installation operation!`r`n"  + `
                                        "Returning back to previous menu..."                , `
                                        [LogMessageLevel]::Attention);


            # Provide some whitespace padding
            [Logging]::DisplayMessage("`r`n`r`n");


            # Allow the user to see the feedback before returning back to the previous menu.
            [CommonIO]::FetchEnterKey();

            # Go back to the previous menu
            return;
        } # if : User Cancelled


        # Provide some whitespace padding
        [Logging]::DisplayMessage("`r`n`r`n");


        # Change the datatype of all entries from System.Object to ProjectMetaData
        [ProjectManagerInstallation]::__MetamorphoseType($listOfProjectsToInstall);


        # Perform a validation check by assuring that all provided archive datafiles given are healthy.
        [ProjectManagerInstallation]::__CheckArchiveFileIntegrity($listOfProjectsToInstall);


        # Perform the Installation
        $operationState = [ProjectManagerInstallation]::__InstallProjects($listOfProjectsToInstall);


        # Show the overall installation status to the user
        [ProjectManagerInstallation]::__DisplayInstallationOperationStatus($operationState)


        # Determine if the Installation function had reached an error.
        [ProjectManagerInstallation]::__InstallProjectsOverallState($operationState);


        # Provide some padding such that it is easier to read.
        [Logging]::DisplayMessage("`r`n");


        # Show the project installation report to the user
        [ProjectManagerInstallation]::__DisplayProjectInstallationReport($listOfProjectsToInstall);


        # Provide some padding such that it is easier to read.
        [Logging]::DisplayMessage("`r`n");


        # Allow the user to view the results before continuing.
        [CommonIO]::FetchEnterKey();


        # Finished
        return;
    } # __Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Provide the instructions to the user regarding the process of installing and\or updating projects
    #   into the program's environment.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions()
    {
        # Show the instructions to the user.
        [Logging]::DisplayMessage( `
            " To install new projects or to update an older installed project into $($GLOBAL:_PROGRAMNAME_),`r`n"           + `
            " you will use the Windows Directory Browser to select the desired $($GLOBAL:_PROGRAMNAMESHORT_) Projects`r`n"  + `
            " that will be installed into $($GLOBAL:_PROGRAMNAME_).  Using the Directory Browser, You may select`r`n"       + `
            " more than one $($GLOBAL:_PROGRAMNAMESHORT_) Project file at a time.`r`n"                                      + `
            "`r`n"                                                                                                          + `
            " You may cancel the operation by selecting 'Cancel' from the Directory Browser.`r`n"                           + `
            "`r`n"                                                                                                          + `
            "`r`n"                                                                                                          );
    } # __DrawMainInstructions()




   <# Show Current Installed Projects
    # -------------------------------
    # Documentation:
    #  When called, this will show what projects had already been installed within the program's environment,
    #   in which the user can quickly survey what is already installed and what may need require updates.
    # -------------------------------
    #>
    hidden static [void] __ShowCurrentInstalledProjects()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will contain a list of projects that had been installed within the environment.
        [System.Collections.ArrayList] $listOfProjectsInstalled = [System.Collections.ArrayList]::New();
        # ----------------------------------------


        # Obtain a list of installed projects
        if ((![ProjectManagerCommon]::__GetInstalledProjects($listOfProjectsInstalled)) -or `   # Failure occurred
            ($NULL -eq $listOfProjectsInstalled)                                        -or `   # No installs found
            ($listOfProjectsInstalled.Count -eq 0))                                             # No installs found
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------
            # Generate the initial message
            [string] $logMessage = ("Unable to find any installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!`r`n" + `
                                    "No projects will be shown to the user.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                            "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Finished; nothing more we can do.
            return;
        } # if : No Installed Projects Found


        # Show the list of installed projects to the user
        [ProjectManagerCommon]::DrawTableProjectInformation($listOfProjectsInstalled);
    } # __ShowCurrentInstalledProjects()




   <# Get Projects from User
    # -------------------------------
    # Documentation:
    #  This function is designed to give the user the ability to specify what project file or files that they
    #   wish to install\update into the program's environment.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] (System.Object) Project File List
    #   This will contain a list of project files that the user wishes to install\update.
    # -------------------------------
    # Output:
    #  Did the user User Provide File(s)?
    #   $true    = One or More project files were selected.
    #   $false   = User Cancelled
    # -------------------------------
    #>
    hidden static [bool] __GetProjectsFromUser([System.Collections.ArrayList] $projectFileList)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the user's Default Compressing object; this contains
        #  the user's preferences as to how the Archive ZIP module will be utilized within this
        #  application.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();


        # Browse File Title String
        [string] $windowsGUIBrowseFileTitleStr = "Select one or more $($GLOBAL:_PROGRAMNAMESHORT_) Project(s) to Install or Update";
        # ----------------------------------------



        # Provide Windows' File Browser, giving the user the ability to freely select one or more project files
        if (![CommonGUI]::BrowseFile($windowsGUIBrowseFileTitleStr,                                 `   # Title
                                    $defaultCompress.GetFileBrowserPreferredFileExtension(),        `   # Default File Extension
                                    $defaultCompress.GetFileBrowserAvailableFileExtensions(),       `   # Filter File Extensions
                                    $true,                                                          `   # Select Multiple Files
                                    [BrowserInterfaceStyle]::Modern,                                `   # Style
                                    $projectFileList))                                                  # List of Files Selected by User.
        {
            # User canceled the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("User had cancelled the operation; no project files were selected.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Report that the user is cancelling the operation.
            return $false;
        } # if : User Canceled



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("The user had provided one or more project file(s) to install\update.");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = "The following file(s) had been selected by the user:`r`n";

        # Scan through each selection provided by the user and record them for logging purposes.
        foreach ($item in $projectFileList) { $logAdditionalMSG += "`t`t >> $($item)`r`n"; }

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level


        # * * * * * * * * * * * * * * * * * * *



        # One or more files selected by user.
        return $true;
    } # __GetProjectsFromUser()




   <# Metamorphose Datatypes
    # -------------------------------
    # Documentation:
    #  This function will transform the datatypes within the given Array List of elements from a System.Object
    #   to an ProjectMetaData data structure type.
    #
    # NOTE: The Array List will be entirely altered to contain only elements with ProjectMetaData,
    #           all previous instances of System.Object _WILL_ be expunged from the Array List!
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {System.Object} File List
    #   Provides a list of files provided by the user to install.
    #   NOTE: The elements coming into this function are: System.Object,
    #           but coming out from this function as: ProjectMetaData.
    # -------------------------------
    #>
    hidden static [void] __MetamorphoseType([System.Collections.ArrayList] $fileList)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain the new file list that will replace the given list.
        [System.Collections.ArrayList] $newFileList = [System.Collections.ArrayList]::New();
        # ----------------------------------------



        # If there is nothing within the provided list, then there is nothing to transform.
        if ($fileList.Count -eq 0)
        {
            # There exists no files within the File List, nothing to metamorphose.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to perform metamorphism as there exists no files within the File List!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Abruptly terminate from this function
            return;
        } # if : File List is Empty



        # Begin the transformation
        foreach ($item in $fileList)
        {
            # Using the IO.FileInfo datatype will help us to easily obtain the file name and full path
            #   information.
            [System.IO.FileInfo] $fileInfo = [System.IO.FileInfo]::New($item);


            # Gather information about the desired file
            [string] $fileName = $fileInfo.Name;
            [string] $filePath = $fileInfo.FullName;


            # Store new information into the desired datatype structure.
            [ProjectMetaData] $newFileEntry = [ProjectMetaData]::New($fileName, $filePath);


            # Save it into the new list for processing later.
            $newFileList.Add($newFileEntry);
        } # foreach : Transform


        # Discard all entries from the provided file list.
        $fileList.Clear();


        # Insert all of the items from the new file list to the given parameter.
        foreach ($file in $newFileList) { $fileList.Add($file); }
    } # __MetamorphoseType()




   <# Check Archive File Integrity
    # -------------------------------
    # Documentation:
    #  This function will verify the integrity of the files that had been selected by the user.
    #   In by doing so, if incase one or more files are corrupted - this function will mark those files as
    #   damaged - using the ProjectMetaData datatype attributes.
    #
    #
    #  NOTE: All entries within the Array List must be in the ProjectMetaData data type.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {ProjectMetaData} File Collection
    #   Provides a list of files provided by the user to install.
    # -------------------------------
    #>
    hidden static [void] __CheckArchiveFileIntegrity([System.Collections.ArrayList] $fileCollection)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the user's Default Compressing object; this contains
        #  the user's preferences as to how the Archive ZIP module will be utilized within this
        #  application.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------



        # If there's nothing provided, then there is nothing todo.
        if ($fileCollection.Count -eq 0)
        {   # There exists no files within the File Collection, nothing to validate.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to perform validation as there exists no files within the" + `
                                    " File Collection List!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Abruptly terminate from this function
            return;
        } # if : File Collection List is Empty


        # Alert the user that we are inspecting the provided files.
        [Logging]::DisplayMessage("Verifying file(s). . .`r`n");


        # Verify that _ALL_ of the archive data file(s) are healthy.
        foreach ($item in $fileCollection)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Create a string in which we can use to generate the operation and record the result.  This
            #   information will be logged within the program's logfile -- useful for debugging if needed.
            # We will initialize this variable by including the filename that is being inspected.
            [string] $logActivity = "Verified file named: $($item.GetMetaFileName())";

            # This will provide additional information that could be useful within the logfile, related to
            #   the operation.
            [string] $logAdditionalInformation = $null;
            # ----------------------------------------



            # Determine verification status
            if ($defaultCompress.VerifyArchive($item.GetMetaFilePath()))
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Passed!";

                # Provide additional information
                $logAdditionalInformation = "This file is healthy and can be installed.";

                # Adjust the attributes of the desired file entry.
                $item.SetProgramVerification([ProjectMetaDataFileVerification]::Passed);
            } # if : Verification Passed

            # Verification had Failed
            else
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Failed!";

                # Provide additional information
                $logAdditionalInformation = "This file is damaged and cannot be installed.";

                # Adjust the attributes of the desired file entry.
                $item.SetProgramVerification([ProjectMetaDataFileVerification]::Failed);

                # Provide the reason for why the file will not be installed.
                $item.SetProgramMessage("This file had been determined to be corrupted, and therefore, cannot be installed.");

                # Clear the absolute path as we can no longer use this file.
                $item.SetMetaFilePathAsEmpty();
            } # else : Verification Failed



            # Record the information to the program's logfile.
            [Logging]::LogProgramActivity($logActivity, `
                                        $logAdditionalInformation, `
                                        [LogMessageLevel]::Information);
        } # foreach : Verify Archive File(s)
    } # __CheckArchiveFileIntegrity()




   <# Display Installation Overall Status
    # -------------------------------
    # Documentation:
    #  Show a message to the user of the overall installation procedure status.
    # -------------------------------
    # Input:
    #  [ProjectManagerInstallationExitCondition] Result of Installation
    #   Provides the overall operation of the Installation process.
    # -------------------------------
    #>
    hidden static [void] __DisplayInstallationOperationStatus([ProjectManagerInstallationExitCondition] $result)
    {
        switch ($result)
        {
            # Overall Operation was Successful
            ([ProjectManagerInstallationExitCondition]::Successful)
            {
                # Display Message
                [Logging]::DisplayMessage("Successfully installed all desired projects!");
                [Logging]::DisplayMessage("Please look at the report for details.");


                # Finished
                return;
            } # Successful


            # Overall Operation had Encountered one or more Errors
            ([ProjectManagerInstallationExitCondition]::Error)
            {
                # Display Message
                [Logging]::DisplayMessage("One or more files could not be installed!");
                [Logging]::DisplayMessage("Please look at the report for details.");


                # Finished
                return;
            } # Error


            # Overall Operation was Generally Successful; but encountered builds that could not be installed
            ([ProjectManagerInstallationExitCondition]::SameOrOlder)
            {
                # Display Message
                [Logging]::DisplayMessage("Successfully installed most of the desired project!");
                [Logging]::DisplayMessage("Please look at the report for details.");


                # Finished
                return;
            } # Same or Older


            # A fatal error had been reached
            ([ProjectManagerInstallationExitCondition]::Fatal)
            {
                # Display Message
                [Logging]::DisplayMessage("A fatal error had occurred, the operation had been aborted!");
                [Logging]::DisplayMessage("Please refer to the the $($GLOBAL:_PROGRAMNAMESHORT_) program's logfile.");


                # Finished
                return;
            } # Fatal
        } # Switch : Overall Operation Status
    } # __DisplayInstallationOperationStatus()




   <# Show Project Installation Report
    # -------------------------------
    # Documentation:
    #  This function will show an installation report of all of the projects that had been selected by the
    #   user.  The report will show what had been installed or what could not be installed along with a
    #   reason of the failure.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] List of Projects
    #   List of projects that had been provided by the user to install\update.
    # -------------------------------
    #>
    hidden static [void] __DisplayProjectInstallationReport([System.Collections.ArrayList] $listOfProjects)
    {
        # Provide a report of the files that had been installed or could not be installed.
        [Logging]::DisplayMessage("Installation Report of the Following Files:`r`n"                     + `
                                    "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = =`r`n"   + `
                                    "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n");


        # Output the results to the user such that they know what had been installed or could not be
        #  installed.
        foreach($item in $listOfProjects)
        {
            # Setup a string containing the results for the logging.
            [string] $fileResultsLogging = ( `
                                "Meta File Name:      " + $item.GetMetaFileName()           + "`r`n`t" + `
                                "Verification Passed: " + $item.GetProgramVerification()    + "`r`n`t" + `
                                "Installed:           " + $item.GetProgramInstalled()       + "`r`n`t" + `
                                "Installed Path:      " + $item.GetMetaFilePath()           + "`r`n`t" + `
                                "Overall Status:      " + $item.GetProgramMessage()         + "`r`n`t");

            # Setup a string containing the results for the logging.
            [string] $fileResults = ( `
                                "Meta File Name:      " + $item.GetMetaFileName()           + "`r`n" + `
                                "Installed:           " + $item.GetProgramInstalled()       + "`r`n" + `
                                "Overall Status:      " + $item.GetProgramMessage()         + "`r`n");


            # Show the results to the user
            [Logging]::DisplayMessage($fileResults);


            # Provide a border to help keep the output nicer to read.
            [Logging]::DisplayMessage("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Project Installation Report for $($item.GetMetaFileName()):");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $fileResultsLogging;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level


            # * * * * * * * * * * * * * * * * * * *
        } # Foreach : Output Installation Results
    } # __DisplayProjectInstallationReport()




   <# Determine Installation Overall State
    # -------------------------------
    # Documentation:
    #  Determine the overall state of the Install Projects function.  This will define if the entire
    #   installation\update procedure had been successful or had failed.
    # -------------------------------
    # Input:
    #  [ProjectManagerInstallationExitCondition] Result of Installation
    #   Provides the overall operation of the Installation process.
    # -------------------------------
    #>
    hidden static [void] __InstallProjectsOverallState([ProjectManagerInstallationExitCondition] $result)
    {
        switch ($result)
        {
            # Overall Operation was Successful
            ([ProjectManagerInstallationExitCondition]::Successful)     { return $true;  }


            # Overall Operation had Encountered one or more Errors
            ([ProjectManagerInstallationExitCondition]::Error)          { return $false; }


            # Overall Operation was Generally Successful; but encountered builds that could not be installed
            ([ProjectManagerInstallationExitCondition]::SameOrOlder)    { return $true;  }


            # A fatal error had been reached
            ([ProjectManagerInstallationExitCondition]::Fatal)          { return $false; }
        } # Switch : Overall Operation Status


        # If we made it here - than the condition is unknown, which will be treated as an error.
        return $false;
    } # __InstallProjectsOverallState()




   <# Install Project(s)
    # -------------------------------
    # Documentation:
    #  This function will try to install the desired project(s) onto the user's system.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] (ProjectMetaData) List of Projects
    #   Provides a list of files that the user wishes to install within the program.
    #     The list will contain the absolute path to the archive files to extract.
    # -------------------------------
    # Output:
    #  Installation status
    #   Successful      = Overall Installation was Successful
    #   Error           = Overall Installation had reached one or a few errors
    #   Same Or Older   = Overall Installation had issues
    # -------------------------------
    #>
    hidden static [ProjectManagerInstallationExitCondition] __InstallProjects([System.Collections.ArrayList] $listOfProjects)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the user's Default Compressing object; this contains
        #  the user's preferences as to how the Archive ZIP module will be utilized within this
        #  application.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();


        # Contains a list of projects that had already been installed previously.
        [System.Collections.ArrayList] $listOfInstalledProjects = [System.Collections.ArrayList]::New();


        # Overall Status of the operation; we will return this value once the operation had been finished.
        #   By default, we will provide a true result - this will change if an error was caught.
        [ProjectManagerInstallationExitCondition] $overallOperation = [ProjectManagerInstallationExitCondition]::Successful;
        # ----------------------------------------



        # Tell the user that we are now installing projects.
        [Logging]::DisplayMessage("Installing Project(s). . .`r`n");



        # Obtain a list of what projects had already been installed.
        if (![ProjectManagerCommon]::__GetInstalledProjects($listOfInstalledProjects))
        {   # Because we are not able to obtain what projects already installed within the host environment,
            #   we will need to abort the entire operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to install projects as it was not possible to fetch current " + `
                                    "installed projects within the environment!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Unable to continue; abort from this function.
            return $false;
        } # if : Failed to Obtain Current Installed Projects



        # Install each project provided.
        foreach ($item in $listOfProjects)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # This string will provide a brief description of the installation activities, this will
            #   be used for logging purposes.
            [string] $logActivity                                               = $null;

            # This will provide additional information that could be useful within the logfile,
            #   related to the operation.
            [string] $logAdditionalInformation                                  = $null;

            # Extracted Directory Absolute Path.
            [string] $outputDirectory                                           = $NULL;

            # Exit Status per Operation\File
            [ProjectManagerInstallationExitCondition] $exitCondition            = [ProjectManagerInstallationExitCondition]::Error;

            # Determines if the target project is an update, a new install, or same\outdated version.
            [ProjectManagerInstallOperationSwitch] $targetProjectInstallState   = [ProjectManagerInstallOperationSwitch]::NewInstall;

            # This is the install instance that will be updated, if updates are available.
            [ProjectMetaData] $previousInstall                                  = [ProjectMetaData]::New();

            # Temporary Directory that will contain the extracted files from the desired project to install.
            #   We will use this as a means to determine if the project is a new install, an update, or an
            #   older version.
            [string] $temporaryProjectDirectory                                 = $NULL;
            # ----------------------------------------



            # If the archive datafile is corrupted - then skip to the next file.
            if ($item.GetProgramVerification() -ne [ProjectMetaDataFileVerification]::Passed)
            {
                # File failed verification; unable to process any further.

                # Because this file could not be installed, flag this as a fault.
                $overallOperation = [ProjectManagerInstallationExitCondition]::Error;

                # Update the item's description to signify that the project could not be installed.
                $item.SetProgramMessage("The Zip file structure is corrupted and unreadable; unable to install safely.");

                # Mark the file as not installed.
                $item.SetProgramInstalled($false);

                # Clear the Installation Path
                $item.SetMetaFilePathAsEmpty();


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project due " + `
                                        "to the archive datafile being corrupted or damaged!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                [ProjectManagerCommon]::OutputMetaProjectInformation($item));


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level


                # * * * * * * * * * * * * * * * * * * *


                # Continue to the next file.
                continue;
            } # if : Archive is Damaged



            # Create a new temporary directory, so the project can be extracted and then later inspected.
            if (![CommonIO]::MakeTempDirectory("Install-Update Project", [ref] $temporaryProjectDirectory))
            {
                # Failed to create a temporary directory for the project, unable to continue.

                # Because this file could not be installed, flag this as a fault.
                $overallOperation = [ProjectManagerInstallationExitCondition]::Error;

                # Update the item's description to signify that the project could not be installed.
                $item.SetProgramMessage("Failed to create a temporary installation folder; unable to install.");

                # Mark the file as not installed.
                $item.SetProgramInstalled($false);

                # Clear the Installation Path
                $item.SetMetaFilePathAsEmpty();


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project due " + `
                                        "to the failure of creating a cache directory!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                [ProjectManagerCommon]::OutputMetaProjectInformation($item));

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level


                # * * * * * * * * * * * * * * * * * * *


                # Continue to the next file.
                continue;
            } # If : Failed to Create Temporary Project Directory



            # Extract the desired project to the temporary directory.
            if (!$defaultCompress.ExtractArchive($item.GetMetaFilePath(),       `
                                                $($temporaryProjectDirectory),  `
                                                [ref] $outputDirectory))
            {
                # Failed to properly extract the project's contents into a temporary directory.

                # Because this file could not be installed, flag this as a fault.
                $overallOperation = [ProjectManagerInstallationExitCondition]::Error;

                # Update the item's description to signify that the project could not be installed.
                $item.SetProgramMessage("Unable to extract the file to a temporary folder; unable to install.");

                # Mark the file as not installed.
                $item.SetProgramInstalled($false);

                # Clear the Installation Path
                $item.SetMetaFilePathAsEmpty();


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project as " + `
                                        "the archive file could not be extracted to the temporary folder.");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = (  "Temporary Directory to Extract onto:`r`n"      + `
                                                "`t`t$($temporaryProjectDirectory)`r`n"         + `
                                                "`r`n"                                          + `
                                                "`tInformation regarding the project:`r`n"      + `
                                                [ProjectManagerCommon]::OutputMetaProjectInformation($item));

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level


                # * * * * * * * * * * * * * * * * * * *


                # Continue to the next file.
                continue;
            } # If : Failed to Extract Project



            # Obtain the meta data of the project that had been extracted to the temporary directory.
            if (![ProjectManagerCommon]::__ReadMetaFile("$($outputDirectory)\$($GLOBAL:_META_FILENAME_)",   `
                                                        [ref] $item))
            {
                # Failed to read the meta data from the target project, cannot continue forward.

                # Because this file could not be installed, flag this as a fault.
                $overallOperation = [ProjectManagerInstallationExitCondition]::Error;

                # Update the item's description to signify that the project could not be installed.
                $item.SetProgramMessage("Unable to read the meta file correctly; unable to install.");

                # Mark the file as not installed.
                $item.SetProgramInstalled($false);

                # Clear the Installation Path
                $item.SetMetaFilePathAsEmpty();


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project as " + `
                                        "the Meta File information cannot be extracted properly!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                [ProjectManagerCommon]::OutputMetaProjectInformation($item));

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level


                # * * * * * * * * * * * * * * * * * * *



                # Continue to the next file.
                continue;
            } # if : Failed to Read Meta File



            # Determine if the target project had already been installed.  If the project had already been
            #   installed, than determine if an update will be necessary.
            foreach ($installedProject in $listOfInstalledProjects)
            {
                # Determine if the Unique IDs match.
                if ($installedProject.GetMetaGUID() -eq $item.GetMetaGUID())
                {   # Found an existing install of the project.

                    # Check if updates are available.
                    if ($installedProject.GetProjectRevision() -lt $item.GetProjectRevision())
                    {
                        # Signify that the target project is an updated version of what is already installed.
                        $targetProjectInstallState = [ProjectManagerInstallOperationSwitch]::Update;

                        # Obtain the original install information.
                        $previousInstall = $installedProject;


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Successfully found a previous install of $($item.GetProjectName()); " + `
                                                "this update will be applied.");

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ( `
                                        "Information Regarding the Updated Version:`r`n"                        + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                        "`r`n"                                                                  + `
                                        "`r`n"                                                                  + `
                                        "Information Regarding the Current Install:`r`n"                        + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Verbose);    # Message level


                        # * * * * * * * * * * * * * * * * * * *


                    } # if : Check if Updates Available

                    # Same or older version than what is presently installed.
                    else
                    {
                        # Signify that the target project is either outdated or the same version that is
                        #   already presently installed.
                        $targetProjectInstallState = [ProjectManagerInstallOperationSwitch]::SameOrOlder;


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Successfully found a previous install of $($item.GetProjectName()); " + `
                                                "this update will not be applied as it is either the same version or older.");

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = (  `
                                        "Information Regarding the Selected Build:`r`n"                         + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                        "`r`n"                                                                  + `
                                        "`r`n"                                                                  + `
                                        "Information Regarding the Current Install:`r`n"                        + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Verbose);    # Message level


                        # * * * * * * * * * * * * * * * * * * *


                    } # else : No updates necessary


                    # Found the same project signatures, we can escape from this loop.
                    break;
                } # if : Project IDs match
            } # foreach : Check for Updates



            # Determine the installation procedure
            switch ($targetProjectInstallState)
            {
                # No Data
                ([ProjectManagerInstallOperationSwitch]::NoData)
                {
                    # Not initialized properly.

                    # Update the item's description to signify that the project could not be installed.
                    $item.SetProgramMessage("An unknown state had been reached; unable to install.");


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("Unknown State; the provided build cannot be installed nor updated " + `
                                            "as no information is available.  This is a strange error....");

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = (  `
                                    "Information may or may not be accurate - Item Selected:`r`n"           + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                    "`r`n"                                                                  + `
                                    "`r`n"                                                                  + `
                                    "Information Regarding the Current Install:`r`n"                        + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Error);      # Message level


                    # * * * * * * * * * * * * * * * * * * *


                    # Nothing can be done here.
                    break;
                } # No Data


                # - - - -


                # New Install
                ([ProjectManagerInstallOperationSwitch]::NewInstall)
                {
                    # Because it is a new install, merely relocate the extracted directory to the Project's
                    #   destination.
                    if (![CommonIO]::MoveDirectory($outputDirectory, $GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_))
                    {
                        # Failed to properly relocate the directory to the default Project's install location.

                        # Update the item's description to signify that the project could not be installed.
                        $item.SetProgramMessage("A failure had been reached while installing contents; unable to install.");


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Failed to install The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                                "$($item.GetProjectName()), as the contents could not be relocated!");

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = (  `
                                        "Information Regarding the New Install:`r`n"                    + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($item)     );

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Error);      # Message level


                        # * * * * * * * * * * * * * * * * * * *


                        # Proceed to the next build.
                        break;
                    } # if : Failed to Relocate Directory


                    # Update the item's description to signify that the project had been installed.
                    $item.SetProgramMessage("Successfully installed!");

                    # Adjust the Exit Condition to signify that the operation was successful.
                    $exitCondition = [ProjectManagerInstallationExitCondition]::Successful;


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("Successfully installed The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                            "$($item.GetProjectName())!");

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = (  `
                                    "Information Regarding the New Install:`r`n"                    + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($item)     );

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Verbose);    # Message level


                    # * * * * * * * * * * * * * * * * * * *


                    # Done.
                    break;
                } # New Install


                # - - - -


                # Update Available
                ([ProjectManagerInstallOperationSwitch]::Update)
                {
                    # Update is Available
                    if (![CommonIO]::CopyDirectory("$($outputDirectory)\*", $previousInstall.GetMetaFilePath()))
                    {
                        # Files could not be relocated.

                        # Update the item's description to signify that the project could not be updated.
                        $item.SetProgramMessage("A failure had been reached while updating the files; unable to update.");


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Failed to update The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                                "$($item.GetProjectName()), as the contents could not be duplicated!");

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = (  `
                                        "Information Regarding the Updated Version:`r`n"                        + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                        "`r`n"                                                                  + `
                                        "`r`n"                                                                  + `
                                        "`tInformation Regarding the Current Install:`r`n"                      + `
                                        [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Error);      # Message level


                        # * * * * * * * * * * * * * * * * * * *


                        # Proceed to the next build.
                        break;
                    } # if : Failed to Relocate Files


                    # Update the item's description to signify that the project had been updated.
                    $item.SetProgramMessage("Successfully updated!");

                    # Adjust the Exit Condition to signify that the operation was successful.
                    $exitCondition = [ProjectManagerInstallationExitCondition]::Successful;


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("Successfully updated The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                            "$($item.GetProjectName())!");

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = (  `
                                    "Information Regarding the New Installation Version:`r`n"               + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                    "`r`n"                                                                  + `
                                    "`r`n"                                                                  + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Verbose);    # Message level


                    # * * * * * * * * * * * * * * * * * * *


                    # Done.
                    break;
                } # Update


                # - - - -


                # Same Version or Older Version
                ([ProjectManagerInstallOperationSwitch]::SameOrOlder)
                {
                    # The target project is either the same version or older;

                    # Update the item's description to signify that the project had not been installed nor updated.
                    $item.SetProgramMessage("This version is the same or older than what is already installed; this version will not be installed.");

                    # Adjust the Exit Condition to signify that the operation could not be performed.
                    $exitCondition = [ProjectManagerInstallationExitCondition]::SameOrOlder;


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("The $($GLOBAL:_PROGRAMNAMESHORT_) Project, $($item.GetProjectName()), will not "   + `
                                            "be installed or updated as the version is exactly the same or is older as to "     + `
                                            "what is currently installed.");

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = (  `
                                    "Information Regarding the Selected Build:`r`n"                         + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($item)             + `
                                    "`r`n"                                                                  + `
                                    "`r`n"                                                                  + `
                                    "`tInformation Regarding the Current Install:`r`n"                      + `
                                    [ProjectManagerCommon]::OutputMetaProjectInformation($installedProject) );

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Warning);    # Message level


                    # * * * * * * * * * * * * * * * * * * *


                    # Nothing can be done.
                    break;
                } # Same or Older Version
            } # switch : Installation Procedure



            # Remove the temporary directory
            # Ignore warnings\errors generated by this function; there's nothing we can do from this point
            #   anyways - just move forward.
            [CommonIO]::DeleteDirectory($temporaryProjectDirectory) | Out-Null;



            # Determine the operation and adjust attributes as necessary
            switch($exitCondition)
            {
                # If the installation was successful
                ([ProjectManagerInstallationExitCondition]::Successful)
                {
                    # Mark that the file had been installed.
                    $item.SetProgramInstalled($true);

                    # Store the extracted path
                    $item.SetMetaFilePath($outputDirectory);

                    # Update the item's description to signify that the file had been installed, only if the
                    #   message had not yet been updated already.
                    if ("$($NULL)" -eq $item.GetProgramMessage()) { $item.SetProgramMessage("Successfully installed!"); }

                    # Finished
                    break;
                } # Successful


                # If the installation had failed, than mark the Overall Operation as failed.
                ([ProjectManagerInstallationExitCondition]::Error)
                {
                    # Mark that the entire operation had failed; this will not be reset back to true.
                    $overallOperation = [ProjectManagerInstallationExitCondition]::Error;

                    # Clear the Installation Path
                    $item.SetMetaFilePathAsEmpty();

                    # Update the item's description to denote that a failure occurred, only if the message had
                    #   not yet been updated already.
                    if (("$($NULL)" -eq $item.GetProgramMessage())) { $item.SetProgramMessage("Failed to install project file."); }

                    # Finished
                    break;
                } # Error


                # If the installation was refused due to Same Version OR current install is newer
                ([ProjectManagerInstallationExitCondition]::SameOrOlder)
                {
                    # Update the status signifying that an update could not be performed; however, errors have
                    #   a higher precedence over this case.
                    if ($overallOperation -eq [ProjectManagerInstallationExitCondition]::Successful)
                    { $overallOperation = [ProjectManagerInstallationExitCondition]::SameOrOlder; }

                    # Mark that the file had not been installed
                    $item.SetProgramInstalled($false);

                    # Clear the Installation Path
                    $item.SetMetaFilePathAsEmpty();

                    # Update the item's description to denote that the installation was refused, but only if the
                    #   message had not yet been updated already.
                    if (("$($NULL)" -eq $item.GetProgramMessage())) { $item.SetProgramMessage("Unable to install as the version is either the same or older compared to what is currently installed."); }

                    # Finished
                    break;
                } # Same or Older
            } # Switch : Evaluate Installation Status



            # Generate the logged messages
            $logActivity = "Installation Results for: $($item.GetMetaFileName())";
            $logAdditionalInformation = "Status: $($item.GetProgramMessage())`r`n`tInstalled: $($exitCondition)`r`n`tInstalled Path: $($outputDirectory)";


            # Record the information to the program's logfile.
            [Logging]::LogProgramActivity($logActivity, `
                                        $logAdditionalInformation, `
                                        [LogMessageLevel]::Information);
        } # foreach : Extract Contents


        # Finished!
        return $overallOperation;
    } # __InstallProjects()
} # ProjectManagerInstallation




<# Project Manager - Install Operation Switch [ENUM]
 # -------------------------------
 # This enumerator will determine how the project will be installed.  The possible
 #  values determines if the project is a new fresh install, update is required, or
 #  if the project version is the same as to what is already installed or older.
 # -------------------------------
 #>
enum ProjectManagerInstallOperationSwitch
{
    NoData          = 0;    # No information was collected or determined yet.
    NewInstall      = 1;    # New installation of the project.
    Update          = 2;    # Updated version of the already installed project.
    SameOrOlder     = 3;    # Same or older version than what is already installed.
} # ProjectManagerInstallOperationSwitch




<# Project Manager - Installation Exit Condition [ENUM]
 # -------------------------------
 # This enumerator will determine the installation status of the individual project.
 #  After a project had been installed, failed to be installed, or refused due to
 #  versioning, we can be able to denote that through this enum-type - and determine
 #  what actions are to be taken later on.
 # -------------------------------
 #>
enum ProjectManagerInstallationExitCondition
{
    Successful      = 0;    # Installation was successful
    Error           = 1;    # Installation had failed
    SameOrOlder     = 2;    # Same or older version that what is presently installed.
    Fatal           = 99;   # A fatal error had caused the entire operation to be aborted.
} # ProjectManagerInstallationExitCondition