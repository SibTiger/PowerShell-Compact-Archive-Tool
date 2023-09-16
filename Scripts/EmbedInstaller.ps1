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




<# Project Manager
 # ------------------------------
 # ==============================
 # ==============================
 # This class can provide the user with the ability to manage PowerShell Compact-Archive Tool projects.
 #  Such management may involve the following:
 #  - Installing Projects
 #  - Updating Projects
 #  - Removing Projects
 #
 # Projects are an important asset to the PowerShell Compact-Archive Tool architecture, as it provides the
 #  user with the ability to compile their game assets into a single archive datafile.  Afterwards, the
 #  author or a developer within the team can then share that same compiled build to online communities,
 #  community forums, or anywhere they wish within the internet or local storage-keeping.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this functionality easy for the user.
 #>




class ProjectManager
{
   <# Project Manager
    # -------------------------------
    # Documentation:
    #  This function will act as our driver within this class.  In this function, the user will
    #   specifically state what action should be performed; either installing/updating to or removing
    #   projects from the PowerShell Compact-Archive Tool's environment.
    #
    #  NOTE:
    #   This is the entry point within this class.
    # -------------------------------
    #>
    static [bool] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain the list of files that the user wishes to install within PSCAT.
        #   NOTE: The base datatype is System.Object, BUT each element within the Array List will change
        #           over time - making it easier to process.
        #   DATATYPE AFTER Windows' File Browser:
        #       |_ Root: System.Object
        #           |_ [0]: System.Object
        #           |_ [n]: System.Object
        #   DATATYPE AFTER MetamorphoseType
        #       |_ Root: System.Object
        #           |_[0]: EmbedInstallerFile
        #           |_[n]: EmbedInstallerFile
        [System.Collections.ArrayList] $listOfProjectsToInstall = [System.Collections.ArrayList]::New();


        # Operation Status; this will provide the overall operation state back to the calling function.
        [Bool] $operationState = $false;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that it is easy for the user to
        #   read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Project Manager
        [CommonCUI]::DrawSectionHeader("Project Manager");


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide the instructions
        [ProjectManager]::__DrawMainInstructions();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain the projects form the user.
        if (![ProjectManager]::__GetProjectsFromUser($listOfProjectsToInstall)) { return $false; }


        # Provide some whitespace padding
        [Logging]::DisplayMessage("`r`n`r`n");


        # Change the datatype of all entries from System.Object to EmbedInstallerFile
        [ProjectManager]::__MetamorphoseType($listOfProjectsToInstall);


        # Perform a validation check by assuring that all provided archive datafiles given are healthy.
        [ProjectManager]::__CheckArchiveFileIntegrity($listOfProjectsToInstall);


        # Perform the Installation
        $operationState = [ProjectManager]::__InstallProjects($listOfProjectsToInstall);


        # Alert the user of the installation status
        if ($operationState) { [Logging]::DisplayMessage("Successfully installed all desired projects!`r`n"); }
        else { [Logging]::DisplayMessage("One or more files could not be installed!`r`n"); }


        # Provide a report of the files that had been installed or could not be installed.
        [Logging]::DisplayMessage("`r`nInstallation Report of the Following Files:`r`n" + `
                                    "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = =`r`n" + `
                                    "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n");


        # Output the results to the user such that they know the what had been installed or could
        #   not be installed.
        foreach($item in $listOfProjectsToInstall)
        {
            # Setup a string containing the results to the user.
            [string] $fileResults = ("File Name: "          + $item.GetFileName()       + "`r`n" + `
                                    "Verification Passed: " + $item.GetVerification()   + "`r`n" + `
                                    "Installed: "           + $item.GetInstalled()      + "`r`n" + `
                                    "Installed Path: "      + $item.GetFilePath()       + "`r`n" + `
                                    "Overall Status: "      + $item.GetMessage()        + "`r`n");


            # Show the results to the user
            [Logging]::DisplayMessage($fileResults);


            # Provide a border to help keep the output nicer to read.
            [Logging]::DisplayMessage("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n");
        } # Foreach : Output Installation Results


        # Provide some padding such that it is easier to read.
        [Logging]::DisplayMessage("`r`n");


        # Allow the user to view the results before continuing.
        [CommonIO]::FetchEnterKey();


        # Finished
        return $operationState;
    } # Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Provide instructions to the user regarding the installation procedure.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions()
    {
        # Show the instructions to the user.
        [Logging]::DisplayMessage( `
            " Installing and Updating $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                        + `
            "-------------------------------------------------------------------------------------------`r`n"       + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            "To install new projects into $($GLOBAL:_PROGRAMNAME_) or to update already existing, use the `r`n"     + `
            " Windows' File Browser to select the desired projects to install or update.`r`n"                       + `
            " The $($GLOBAL:_PROGRAMNAMESHORT_) Project Manager will automatically try to install or update the"    + `
            " projects for you.`r`n"                                                                                + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            "NOTE: To abort this operation, you may select 'Cancel' in the File Browser.`r`n"                       + `
            "`r`n`r`n");


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()




   <# Get Projects from User
    # -------------------------------
    # Documentation:
    #  This function is designed to give the user the ability to specify what project file or files that they
    #   wish to install\update.
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
    #   to an EmbedInstallerFile data structure type.
    #
    # NOTE: The Array List will be entirely altered to contain only elements with EmbedInstallerFile,
    #           all previous instances of System.Object _WILL_ be expunged from the Array List!
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {System.Object} File List
    #   Provides a list of files provided by the user to install.
    #   NOTE: The elements coming into this function are: System.Object,
    #           but coming out from this function as: EmbedInstallerFile.
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
        if ($fileList.Count -eq 0) { return; }



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
            [EmbedInstallerFile] $newFileEntry = [EmbedInstallerFile]::New($fileName, $filePath);


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
    #  This function will verify the integrity of the files that had been selected by the user to install.
    #   In by doing so, if incase one or more files are corrupted - this function will mark those files as
    #   damaged - using the EmbedInstallerFiler datatype attributes.
    #
    #
    #  NOTE: All entries within the Array List are to be in the EmbedInstallerFile.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {EmbedInstallerFile} File Collection
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
        if ($fileCollection.Count -eq 0) { return; }


        # Alert the user that we are inspecting the provided files.
        [Logging]::DisplayMessage("Verifying file(s). . .`r`n");


        # Inspect _ALL_ files and verify that the archive data file(s) are healthy.
        foreach ($item in $fileCollection)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Create a string in which we can use to generate the operation and record the result.  This
            #   information will be logged within the program's logfile -- useful for debugging if needed.
            # We will initialize this variable by including the filename that is being inspected.
            [string] $logActivity = "Verified file named: $($item.GetFileName())";

            # This will provide additional information that could be useful within the logfile, related to
            #   the operation.
            [string] $logAdditionalInformation = $null;
            # ----------------------------------------



            # Determine verification status
            if ($defaultCompress.VerifyArchive($item.GetFilePath()))
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Passed!";

                # Provide additional information
                $logAdditionalInformation = "The file is healthy and can be installed.";

                # Adjust the attributes of the desired file entry.
                $item.SetVerification([EmbedInstallerFileVerification]::Passed);
            } # if : Verification Passed

            # Verification had Failed
            else
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Failed!";

                # Provide additional information
                $logAdditionalInformation = "The file is damaged and cannot be installed.";

                # Adjust the attributes of the desired file entry.
                $item.SetVerification([EmbedInstallerFileVerification]::Failed);

                # Provide the reason for why the file will not be installed.
                $item.SetMessage("The file is determined to be corrupted and cannot be installed.");

                # Clear the absolute path as we can no longer use this file.
                $item.SetFilePathAsEmpty();
            } # else : Verification Failed



            # Record the information to the program's logfile.
            [Logging]::LogProgramActivity($logActivity, `
                                        $logAdditionalInformation, `
                                        [LogMessageLevel]::Information);
        } # foreach : Verify Archive File(s)
    } # __CheckArchiveFileIntegrity()




   <# Install Project(s)
    # -------------------------------
    # Documentation:
    #  This function will try to install the desired project(s) onto the user's system.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] (EmbedInstallerFile) List of Projects
    #   Provides a list of files that the user wishes to install within the program.
    #     The list will contain the absolute path to the archive files to extract.
    # -------------------------------
    # Output:
    #  Installation status
    #   true    = Installation was successful.
    #   false   = Installation had failed.
    # -------------------------------
    #>
    hidden static [bool] __InstallProjects([System.Collections.ArrayList] $listOfProjects)
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
        [Bool] $overallOperation = $true;
        # ----------------------------------------



        # Tell the user that we are now installing projects.
        [Logging]::DisplayMessage("Installing Project(s). . .`r`n");



        # Obtain a list of what projects had already been installed.
        if (![ProjectManager]::__GetInstalledProjects($listOfInstalledProjects)) { return $false; }



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

            # Exit Status
            [bool] $exitCondition                                               = $false;

            # Determines if the target project is an update, a new install, or same\outdated version.
            [ProjectManagerInstallOperationSwitch] $targetProjectInstallState   = [ProjectManagerInstallOperationSwitch]::NewInstall;

            # This is the install instance that will be updated, if updates are available.
            [EmbedInstallerFile] $previousInstall                               = [EmbedInstallerFile]::New();

            # Temporary Directory that will contain the extracted files from the desired project to install.
            #   We will use this as a means to determine if the project is a new install, an update, or an
            #   older version.
            [string] $temporaryProjectDirectory                                 = $NULL;

            # This will hold the attributes for the project file we are about to install\update.
            [UInt64] $temporaryProjectRevision                                  = 0;
            [string] $temporaryProjectName                                      = $NULL;
            [GUID] $temporaryProjectSignature                                   = $GLOBAL:_DEFAULT_BLANK_GUID_;
            # ----------------------------------------



            # If the archive datafile is corrupted - then skip to the next file.
            if ($item.GetVerification() -ne [EmbedInstallerFileVerification]::Passed)
            {
                # Because this file could not be installed, flag this as a fault.
                $overallOperation = $false;


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project due " + `
                                        "to the archive datafile being corrupted or damaged!");

                # Generate any additional information that might be useful

                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                "`tFile Name:`r`n"                              + `
                                                "`t`t$($item.GetFileName())`r`n"                + `
                                                "`tFile Path:`r`n"                              + `
                                                "`t`t$($item.GetFilePath())`r`n"                + `
                                                "`tVerification`r`n"                            + `
                                                "`t`t$($item.GetVerification())`r`n"            + `
                                                "`tInstalled`r`n"                               + `
                                                "`t`t$($item.GetInstalled())`r`n"               + `
                                                "`tMessage`r`n"                                 + `
                                                "`t`t$($item.GetMessage())`r`n");

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
                $overallOperation = $false;


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project due " + `
                                        "to the failure of creating a cache directory!");

                # Generate any additional information that might be useful

                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                "`tFile Name:`r`n"                              + `
                                                "`t`t$($item.GetFileName())`r`n"                + `
                                                "`tFile Path:`r`n"                              + `
                                                "`t`t$($item.GetFilePath())`r`n"                + `
                                                "`tVerification`r`n"                            + `
                                                "`t`t$($item.GetVerification())`r`n"            + `
                                                "`tInstalled`r`n"                               + `
                                                "`t`t$($item.GetInstalled())`r`n"               + `
                                                "`tMessage`r`n"                                 + `
                                                "`t`t$($item.GetMessage())`r`n");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level


                # * * * * * * * * * * * * * * * * * * *


                # Continue to the next file.
                continue;
            } # If : Failed to Create Temporary Project Directory



            # Extract the desired project to the temporary directory.
            $exitCondition = $defaultCompress.ExtractArchive($item.GetFilePath(), `
                                                            $($temporaryProjectDirectory), `
                                                            [ref] $outputDirectory);


            # Obtain the meta data of the project that had been extracted to the temporary directory.
            if (![ProjectManager]::__ReadMetaFile("$($outputDirectory)\$($GLOBAL:_META_FILENAME_)",     `
                                                    [ref] $temporaryProjectRevision,                    `
                                                    [ref] $temporaryProjectName,                        `
                                                    [ref] $temporaryProjectSignature))
            {
                # Failed to read the meta data from the target project.
                $overallOperation = $false;



                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to install or update $($GLOBAL:_PROGRAMNAMESHORT_) Project as " + `
                                        "the Meta File information cannot be extracted properly!");

                # Generate any additional information that might be useful

                [string] $logAdditionalMSG = (  "Information may or may not be accurate:`r`n"   + `
                                                "`tFile Name:`r`n"                              + `
                                                "`t`t$($item.GetFileName())`r`n"                + `
                                                "`tFile Path:`r`n"                              + `
                                                "`t`t$($item.GetFilePath())`r`n"                + `
                                                "`tProject Name:`r`n"                           + `
                                                "`t`t$($temporaryProjectName)`r`n"              + `
                                                "`tProject Revision:`r`n"                       + `
                                                "`t`t$($temporaryProjectRevision)`r`n"          + `
                                                "`tProject Signature:`r`n"                      + `
                                                "`t`t$($temporaryProjectSignature)`r`n"         + `
                                                "`tVerification`r`n"                            + `
                                                "`t`t$($item.GetVerification())`r`n"            + `
                                                "`tInstalled`r`n"                               + `
                                                "`t`t$($item.GetInstalled())`r`n"               + `
                                                "`tMessage`r`n"                                 + `
                                                "`t`t$($item.GetMessage())`r`n");

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
                if ($installedProject.GetGUID() -eq $temporaryProjectSignature)
                {
                    # Check if updates are available.
                    if ($installedProject.GetProjectRevision() -lt $temporaryProjectRevision)
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

                        [string] $logAdditionalMSG = (  "Information Regarding the Updated Version:`r`n"    + `
                                                        "`tFile Name:`r`n"                                  + `
                                                        "`t`t$($item.GetFileName())`r`n"                    + `
                                                        "`tFile Path:`r`n"                                  + `
                                                        "`t`t$($item.GetFilePath())`r`n"                    + `
                                                        "`tProject Name:`r`n"                               + `
                                                        "`t`t$($item.GetProjectName())`r`n"                 + `
                                                        "`tProject Revision:`r`n"                           + `
                                                        "`t`t$($item.GetProjectRevision())`r`n"             + `
                                                        "`tProject Signature:`r`n"                          + `
                                                        "`t`t$($item.GetGUID())`r`n"                        + `
                                                        "`tVerification`r`n"                                + `
                                                        "`t`t$($item.GetVerification())`r`n"                + `
                                                        "`tInstalled`r`n"                                   + `
                                                        "`t`t$($item.GetInstalled())`r`n"                   + `
                                                        "`tMessage`r`n"                                     + `
                                                        "`t`t$($item.GetMessage())`r`n"                     + `
                                                        "`r`n"                                              + `
                                                        "`r`n"                                              + `
                                                        "Information Regarding the Current Install:`r`n:"   + `
                                                        "`tFile Name:`r`n"                                  + `
                                                        "`t`t$($installedProject.GetFileName())`r`n"        + `
                                                        "`tFile Path:`r`n"                                  + `
                                                        "`t`t$($installedProject.GetFilePath())`r`n"        + `
                                                        "`tProject Name:`r`n"                               + `
                                                        "`t`t$($installedProject.GetProjectName())`r`n"     + `
                                                        "`tProject Revision:`r`n"                           + `
                                                        "`t`t$($installedProject.GetProjectRevision())`r`n" + `
                                                        "`tProject Signature:`r`n"                          + `
                                                        "`t`t$($installedProject.GetGUID())`r`n"            + `
                                                        "`tVerification`r`n"                                + `
                                                        "`t`t$($installedProject.GetVerification())`r`n"    + `
                                                        "`tInstalled`r`n"                                   + `
                                                        "`t`t$($installedProject.GetInstalled())`r`n"       + `
                                                        "`tMessage`r`n"                                     + `
                                                        "`t`t$($installedProject.GetMessage())");

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

                        [string] $logAdditionalMSG = (  "Information Regarding the Selected Build:`r`n"     + `
                                                        "`tFile Name:`r`n"                                  + `
                                                        "`t`t$($item.GetFileName())`r`n"                    + `
                                                        "`tFile Path:`r`n"                                  + `
                                                        "`t`t$($item.GetFilePath())`r`n"                    + `
                                                        "`tProject Name:`r`n"                               + `
                                                        "`t`t$($item.GetProjectName())`r`n"                 + `
                                                        "`tProject Revision:`r`n"                           + `
                                                        "`t`t$($item.GetProjectRevision())`r`n"             + `
                                                        "`tProject Signature:`r`n"                          + `
                                                        "`t`t$($item.GetGUID())`r`n"                        + `
                                                        "`tVerification`r`n"                                + `
                                                        "`t`t$($item.GetVerification())`r`n"                + `
                                                        "`tInstalled`r`n"                                   + `
                                                        "`t`t$($item.GetInstalled())`r`n"                   + `
                                                        "`tMessage`r`n"                                     + `
                                                        "`t`t$($item.GetMessage())`r`n"                     + `
                                                        "`r`n"                                              + `
                                                        "`r`n"                                              + `
                                                        "Information Regarding the Current Install:`r`n:"   + `
                                                        "`tFile Name:`r`n"                                  + `
                                                        "`t`t$($installedProject.GetFileName())`r`n"        + `
                                                        "`tFile Path:`r`n"                                  + `
                                                        "`t`t$($installedProject.GetFilePath())`r`n"        + `
                                                        "`tProject Name:`r`n"                               + `
                                                        "`t`t$($installedProject.GetProjectName())`r`n"     + `
                                                        "`tProject Revision:`r`n"                           + `
                                                        "`t`t$($installedProject.GetProjectRevision())`r`n" + `
                                                        "`tProject Signature:`r`n"                          + `
                                                        "`t`t$($installedProject.GetGUID())`r`n"            + `
                                                        "`tVerification`r`n"                                + `
                                                        "`t`t$($installedProject.GetVerification())`r`n"    + `
                                                        "`tInstalled`r`n"                                   + `
                                                        "`t`t$($installedProject.GetInstalled())`r`n"       + `
                                                        "`tMessage`r`n"                                     + `
                                                        "`t`t$($installedProject.GetMessage())");

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


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("Unknown State; the provided build cannot be installed nor updated " + 
                                            "as no information is available.  This is a strange error....");

                    # Generate any additional information that might be useful

                    [string] $logAdditionalMSG = (  "Information may or may not be accurate - Item Selected:`r`n"       + `
                                                    "`tFile Name:`r`n"                                                  + `
                                                    "`t`t$($item.GetFileName())`r`n"                                    + `
                                                    "`tFile Path:`r`n"                                                  + `
                                                    "`t`t$($item.GetFilePath())`r`n"                                    + `
                                                    "`tProject Name:`r`n"                                               + `
                                                    "`t`t$($item.GetProjectName())`r`n"                                 + `
                                                    "`tProject Revision:`r`n"                                           + `
                                                    "`t`t$($item.GetProjectRevision())`r`n"                             + `
                                                    "`tProject Signature:`r`n"                                          + `
                                                    "`t`t$($item.GetGUID())`r`n"                                        + `
                                                    "`tVerification`r`n"                                                + `
                                                    "`t`t$($item.GetVerification())`r`n"                                + `
                                                    "`tInstalled`r`n"                                                   + `
                                                    "`t`t$($item.GetInstalled())`r`n"                                   + `
                                                    "`tMessage`r`n"                                                     + `
                                                    "`t`t$($item.GetMessage())`r`n"                                     + `
                                                    "`r`n"                                                              + `
                                                    "`r`n"                                                              + `
                                                    "Information Regarding the Current Install:`r`n:"                   + `
                                                    "`tFile Name:`r`n"                                                  + `
                                                    "`t`t$($installedProject.GetFileName())`r`n"                        + `
                                                    "`tFile Path:`r`n"                                                  + `
                                                    "`t`t$($installedProject.GetFilePath())`r`n"                        + `
                                                    "`tProject Name:`r`n"                                               + `
                                                    "`t`t$($installedProject.GetProjectName())`r`n"                     + `
                                                    "`tProject Revision:`r`n"                                           + `
                                                    "`t`t$($installedProject.GetProjectRevision())`r`n"                 + `
                                                    "`tProject Signature:`r`n"                                          + `
                                                    "`t`t$($installedProject.GetGUID())`r`n"                            + `
                                                    "`tVerification`r`n"                                                + `
                                                    "`t`t$($installedProject.GetVerification())`r`n"                    + `
                                                    "`tInstalled`r`n"                                                   + `
                                                    "`t`t$($installedProject.GetInstalled())`r`n"                       + `
                                                    "`tMessage`r`n"                                                     + `
                                                    "`t`t$($installedProject.GetMessage())");

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


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Failed to install The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                                "$($item.GetProjectName()), as the contents could not be relocated!");

                        # Generate any additional information that might be useful

                        [string] $logAdditionalMSG = (  "Information Regarding the New Install:`r`n"        + `
                                                        "`tFile Name:`r`n"                                  + `
                                                        "`t`t$($item.GetFileName())`r`n"                    + `
                                                        "`tFile Path:`r`n"                                  + `
                                                        "`t`t$($item.GetFilePath())`r`n"                    + `
                                                        "`tProject Name:`r`n"                               + `
                                                        "`t`t$($item.GetProjectName())`r`n"                 + `
                                                        "`tProject Revision:`r`n"                           + `
                                                        "`t`t$($item.GetProjectRevision())`r`n"             + `
                                                        "`tProject Signature:`r`n"                          + `
                                                        "`t`t$($item.GetGUID())`r`n"                        + `
                                                        "`tVerification`r`n"                                + `
                                                        "`t`t$($item.GetVerification())`r`n"                + `
                                                        "`tInstalled`r`n"                                   + `
                                                        "`t`t$($item.GetInstalled())`r`n"                   + `
                                                        "`tMessage`r`n"                                     + `
                                                        "`t`t$($item.GetMessage())");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Error);      # Message level


                        # * * * * * * * * * * * * * * * * * * *


                        # Proceed to the next build.
                        break;
                    } # if : Failed to Relocate Directory


                    # Done.
                    break;
                } # New Install


                # - - - -


                # Update Available
                ([ProjectManagerInstallOperationSwitch]::Update)
                {
                    # Update is Available
                    if (![CommonIO]::CopyDirectory("$($outputDirectory)\*", $previousInstall.GetFilePath()))
                    {
                        # Files could not be relocated.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = ("Failed to update The $($GLOBAL:_PROGRAMNAMESHORT_) Project, " + `
                                                "$($item.GetProjectName()), as the contents could not be duplicated!");

                        # Generate any additional information that might be useful

                        [string] $logAdditionalMSG = (  "Information Regarding the Updated Version:`r`n"            + `
                                                        "`tFile Name:`r`n"                                          + `
                                                        "`t`t$($item.GetFileName())`r`n"                            + `
                                                        "`tFile Path:`r`n"                                          + `
                                                        "`t`t$($item.GetFilePath())`r`n"                            + `
                                                        "`tProject Name:`r`n"                                       + `
                                                        "`t`t$($item.GetProjectName())`r`n"                         + `
                                                        "`tProject Revision:`r`n"                                   + `
                                                        "`t`t$($item.GetProjectRevision())`r`n"                     + `
                                                        "`tProject Signature:`r`n"                                  + `
                                                        "`t`t$($item.GetGUID())`r`n"                                + `
                                                        "`tVerification`r`n"                                        + `
                                                        "`t`t$($item.GetVerification())`r`n"                        + `
                                                        "`tInstalled`r`n"                                           + `
                                                        "`t`t$($item.GetInstalled())`r`n"                           + `
                                                        "`tMessage`r`n"                                             + `
                                                        "`t`t$($item.GetMessage())`r`n"                             + `
                                                        "`r`n"                                                      + `
                                                        "`r`n"                                                      + `
                                                        "Information Regarding the Current Install:`r`n:"           + `
                                                        "`tFile Name:`r`n"                                          + `
                                                        "`t`t$($installedProject.GetFileName())`r`n"                + `
                                                        "`tFile Path:`r`n"                                          + `
                                                        "`t`t$($installedProject.GetFilePath())`r`n"                + `
                                                        "`tProject Name:`r`n"                                       + `
                                                        "`t`t$($installedProject.GetProjectName())`r`n"             + `
                                                        "`tProject Revision:`r`n"                                   + `
                                                        "`t`t$($installedProject.GetProjectRevision())`r`n"         + `
                                                        "`tProject Signature:`r`n"                                  + `
                                                        "`t`t$($installedProject.GetGUID())`r`n"                    + `
                                                        "`tVerification`r`n"                                        + `
                                                        "`t`t$($installedProject.GetVerification())`r`n"            + `
                                                        "`tInstalled`r`n"                                           + `
                                                        "`t`t$($installedProject.GetInstalled())`r`n"               + `
                                                        "`tMessage`r`n"                                             + `
                                                        "`t`t$($installedProject.GetMessage())");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                    $logAdditionalMSG, `            # Additional information
                                                    [LogMessageLevel]::Error);      # Message level


                        # * * * * * * * * * * * * * * * * * * *


                        # Proceed to the next build.
                        break;
                    } # if : Failed to Relocate Files


                    # Done.
                    break;
                } # Update


                # - - - -


                # Same Version or Older Version
                ([ProjectManagerInstallOperationSwitch]::SameOrOlder)
                {
                    # The target project is either the same version or older;


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("The $($GLOBAL:_PROGRAMNAMESHORT_) Project, $($item.GetProjectName()), will not "   + `
                                            "be installed or updated as the version is exactly the same or is older as to "     + `
                                            "what is currently installed.");

                    # Generate any additional information that might be useful

                    [string] $logAdditionalMSG = (  "Information Regarding the Selected Build:`r`n"             + `
                                                    "`tFile Name:`r`n"                                          + `
                                                    "`t`t$($item.GetFileName())`r`n"                            + `
                                                    "`tFile Path:`r`n"                                          + `
                                                    "`t`t$($item.GetFilePath())`r`n"                            + `
                                                    "`tProject Name:`r`n"                                       + `
                                                    "`t`t$($item.GetProjectName())`r`n"                         + `
                                                    "`tProject Revision:`r`n"                                   + `
                                                    "`t`t$($item.GetProjectRevision())`r`n"                     + `
                                                    "`tProject Signature:`r`n"                                  + `
                                                    "`t`t$($item.GetGUID())`r`n"                                + `
                                                    "`tVerification`r`n"                                        + `
                                                    "`t`t$($item.GetVerification())`r`n"                        + `
                                                    "`tInstalled`r`n"                                           + `
                                                    "`t`t$($item.GetInstalled())`r`n"                           + `
                                                    "`tMessage`r`n"                                             + `
                                                    "`t`t$($item.GetMessage())`r`n"                             + `
                                                    "`r`n"                                                      + `
                                                    "`r`n"                                                      + `
                                                    "Information Regarding the Current Install:`r`n:"           + `
                                                    "`tFile Name:`r`n"                                          + `
                                                    "`t`t$($installedProject.GetFileName())`r`n"                + `
                                                    "`tFile Path:`r`n"                                          + `
                                                    "`t`t$($installedProject.GetFilePath())`r`n"                + `
                                                    "`tProject Name:`r`n"                                       + `
                                                    "`t`t$($installedProject.GetProjectName())`r`n"             + `
                                                    "`tProject Revision:`r`n"                                   + `
                                                    "`t`t$($installedProject.GetProjectRevision())`r`n"         + `
                                                    "`tProject Signature:`r`n"                                  + `
                                                    "`t`t$($installedProject.GetGUID())`r`n"                    + `
                                                    "`tVerification`r`n"                                        + `
                                                    "`t`t$($installedProject.GetVerification())`r`n"            + `
                                                    "`tInstalled`r`n"                                           + `
                                                    "`t`t$($installedProject.GetInstalled())`r`n"               + `
                                                    "`tMessage`r`n"                                             + `
                                                    "`t`t$($installedProject.GetMessage())");

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
            [CommonIO]::DeleteDirectory($temporaryProjectDirectory) | Out-Null;



            # Determine the operation
            #  If the installation had failed, than mark the Overall Operation as failed.
            if (!$exitCondition)
            {
                # Mark that the entire operation had failed; this will not be reset back to true.
                $overallOperation = $false;

                # Clear the Installation Path
                $item.SetFilePathAsEmpty();

                # Update the item's description to denote that a failure occurred.
                $item.SetMessage("Failed to install project file.");
            } # if : Operation Failed

            # If the installation was successful.
            else
            {
                # Mark that the file had been installed.
                $item.SetInstalled($true);

                # Store the extracted path
                $item.SetFilePath($outputDirectory);

                # Update the item's description to signify that the file had been installed.
                $item.SetMessage("Successfully installed!");          
            } # else : Installation Successful


            # Generate the logged messages
            $logActivity = "Installation Results for: $($item.GetFileName())";
            $logAdditionalInformation = "Status: $($item.GetMessage())`r`n`tInstalled: $($exitCondition)`r`n`tInstalled Path: $($outputDirectory)";


            # Record the information to the program's logfile.
            [Logging]::LogProgramActivity($logActivity, `
                                        $logAdditionalInformation, `
                                        [LogMessageLevel]::Information);
        } # foreach : Extract Contents


        # Finished!
        return $overallOperation;
    } # __InstallProjects()




   <# Get Installed Projects
    # -------------------------------
    # Documentation:
    #  This function is designed to obtain all of the projects that are installed within the PSCAT
    #   environment.  To obtain what projects had been installed, this function will inspect
    #   the meta file within the projects directory.  The meta file will provide essential information
    #   regarding each installed project.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {EmbedInstallerFile} Installed Projects.
    #   This will provide information as to what projects had been installed within the PSCAT environment.
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
        if (![CommonIO]::CheckPathExists($($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_) , $true)) { return $false; }


        # Obtain to obtain all of the existing meta files within the projects directory.
        try
        {
            $listOfMetaFiles = Get-ChildItem `
                                -LiteralPath $($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_) `
                                -Filter $GLOBAL:_META_FILENAME_ `
                                -Recurse `
                                -Depth 1 `
                                -ErrorAction Stop;


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
                    $logAdditionalMSG +=   ("`t`tDirectory:`r`n"                        + `
                                            "`t`t`t$($file.DirectoryName)`r`n"          + `
                                            "`t`tFile Name:`r`n"                        + `
                                            "`t`t`t$($file.Name)`r`n"                   + `
                                            "`t`tFull Path:`r`n"                        + `
                                            "`t`t`t$($file.FullName)");
                } # foreach : Scan Each Project Found
            } # If : One or More Projects found


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

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
            return $false;
        } # catch : Error Reached



        # Begin storing the project information into the Embed Installer File data structure,
        #   such that we can process the data.
        foreach ($item in $listOfMetaFiles)
        {
            # Declarations and Initializations
            # ----------------------------------------
            [EmbedInstallerFile]    $newProjectEntry        = [EmbedInstallerFile]::New();          # Entry to add into Array
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
            $newProjectEntry.SetVerification([EmbedInstallerFileVerification]::Installed);

            # Mark as installed
            $newProjectEntry.SetInstalled($true);

            # Set the message\description
            $newProjectEntry.SetMessage("Installed project loaded for evaluation purposes.");
            # -------------------------------------------------



            # Obtain the information from the Meta file.
            if (![ProjectManager]::__ReadMetaFile($item.FullName,               ` # Where the meta file is located
                                                [ref] $newProjectRevision,      ` # Get Project's Revision
                                                [ref] $newProjectName,          ` # Get Project's Name
                                                [ref] $newProjectSignature))      # Get Project's GUID
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
                                                "`t`tEmbedded Message`r`n"                                      + `
                                                "`t`t`t$($newProjectEntry.GetMessage())`r`n"                    + `
                                                "`t`tProject Revision ID:`r`n"                                  + `
                                                "`t`t`t$($newProjectRevision)`r`n"                              + `
                                                "`t`tProject Name:`r`n"                                         + `
                                                "`t`t`t$($newProjectName)`r`n"                                  + `
                                                "`t`tUnique Signature:`r`n"                                     + `
                                                "`t`t`t$($newProjectSignature)");


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Something had failed; continue to the next
                continue;
            } # if : Failed to Read Meta File


            # Store the information retrieved from the meta file
            # --------------------------------------------------
            # Project's current revision
            $newProjectEntry.SetProjectRevision($newProjectRevision);
            
            # Project's name
            $newProjectEntry.SetProjectName($newProjectName);

            # Project's unique Signature
            $newProjectEntry.SetGUID($newProjectSignature);
            # --------------------------------------------------



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
                                            "`t`tEmbedded Message`r`n"                                      + `
                                            "`t`t`t$($newProjectEntry.GetMessage())`r`n"                    + `
                                            "`t`tProject Revision ID:`r`n"                                  + `
                                            "`t`t`t$($newProjectEntry.GetProjectRevision)`r`n"              + `
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
    #  [UInt64] (REFERENCE) Project's Revision
    #   This reference will be assigned and hold the project's revision ID from the meta file.
    #  [string] (REFERENCE) Project's Name
    #   This reference will be assigned and hold the project's name from the meta file.
    #  [GUID] (REFERENCE) Project's Signature
    #   This reference will be assigned and hold the project's signature (GUID) from the meta file.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed
    #     $true  = Operation was successful
    # -------------------------------
    #>
    hidden static [bool] __ReadMetaFile([string] $metaFilePath, `       # Absolute path to the project's meta file
                                        [ref] $projectRevision, `       # The project's revision ID
                                        [ref] $projectName,     `       # The project's name
                                        [ref] $projectSignature)        # The project's signature
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the contents from the meta file, we can use this to manipulate and process the data
        #   as necessary to retrieve the proper data.
        [System.Collections.ArrayList] $metaContents = [System.Collections.ArrayList]::new();
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
            $metaContents = Get-Content                                             `
                                -Path $metaFilePath                                 `
                                -TotalCount $GLOBAL:_META_FILE_CONTENT_LINE_SIZE_   `
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
            foreach ($line in $metaContents) { $logAdditionalMSG += "`t`t$($line)" }

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


        # Make sure that the contents from the Meta file are in the appropriate structure per line.
        if (!   ($metaContents[0].Contains("Project_Name:")     -and `      # First Line Must Contain: Project_Name:
                ($metaContents[1].Contains("Project_Revision:") -and `      # Second Line Must Contain: Project_Revision:
                ($metaContents[2].Contains("Project_Signature:")))))        # Third Line Must Contain: Project_Signature:
        {
            # The structure of the contents are not correct


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Content structure within the Meta File are not correct!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Meta File to Open:`r`n"                              + `
                                            "`t`t$($metaFilePath)`r`n"                          + `
                                            "`tExpected the structure to be as follows:`r`n"    + `
                                            "`t`tProject_Name`r`n"                              + `
                                            "`t`tProject_Revision`r`n"                          + `
                                            "`t`tProject_Signature`r`n");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Unable to continue, abort operation
            return $false;
        } # if : Meta Contents not Correct



        # Obtain the information gathered from the Meta file
        # ---------------------------------------------------
        try
        {
            # Project's Name
            $projectName.Value      = [string]  ($metaContents[0] -Replace "Project_Name:").Trim();

            # Project's Revision
            $projectRevision.Value  = [UInt64]  ($metaContents[1] -Replace "Project_Revision:").Trim();

            # Project's Signature
            $projectSignature.Value = [GUID]    ($metaContents[2] -Replace "Project_Signature:").Trim();
        } # try : Assign Proper Values

        # Caught Error
        catch
        {
            # Improper Datatype Assignment had Occurred.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to Convert Data Structure from the Input Meta File!");

            # Generate the initial message
            [string] $logMessage = $displayErrorMessage;

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("$($NULL)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Unable to use the data from the Meta file
            return $false;
        } # catch : Caught an Error
        # ---------------------------------------------------



        # Finished
        return $true;
    } # __ReadMetaFile()
} # ProjectManager




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