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
            " The $($GLOBAL:__PROGRAMNAMESHORT_) Project Manager will automatically try to install or update the"   + `
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
    #  This function is designed to give the user the ability to specify what project files that they wish to
    #   install\update.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] (System.Object) Project File List
    #   This will contain a list of project files that the user wishes to install\update.
    # -------------------------------
    # Output:
    #  Where Files Selected
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
        # ----------------------------------------



        # Provide Windows' File Browser, giving the user the ability to freely select one or more project files
        if (![CommonGUI]::BrowseFile("Select Project(s) to Install or Update",                  `   # Title
                                    $defaultCompress.GetFileBrowserPreferredFileExtension(),    `   # Default File Extension
                                    $defaultCompress.GetFileBrowserAvailableFileExtensions(),   `   # Filter File Extensions
                                    $true,                                                      `   # Select Multiple Files
                                    [BrowserInterfaceStyle]::Modern,                            `   # Style
                                    $projectFileList))                                              # List of Files Selected by User.
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
    #  This function will transform the datatypes within the given Array List elements from System.Object
    #   to EmbedInstallerFile types.
    #
    # NOTE: The Array List will be entirely altered to contain only elements with EmbedInstallerFile,
    #           all previous instances of System.Object _WILL_ be expunged.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {System.Object} File List
    #   Provides a list of files provided by the user to install.
    #   NOTE: The elements coming into this function are: System.Object,
    #           but coming out from this function will be: EmbedInstallerFile.
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
    #   This will hold *.ZIP files that had been placed within the temporary directory.
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


        # Overall Status of the operation; we will return this value once the operation had been finished.
        #   By default, we will provide a true result - this will change if an error was caught.
        [Bool] $overallOperation = $true;
        # ----------------------------------------



        # Tell the user that we are now installing projects.
        [Logging]::DisplayMessage("Installing Project(s). . .`r`n");



        # Install each project provided.
        foreach ($item in $listOfProjects)
        {
            # If the archive datafile is corrupted - then skip to the next file.
            if ($item.GetVerification() -ne [EmbedInstallerFileVerification]::Passed)
            {
                # Because this file could not be installed, flag this as a fault.
                $overallOperation = $false;


                # Continue to the next file.
                continue;
            } # if : Archive is Damaged


            # This string will provide a brief description of the installation activities, this will
            #   be used for logging purposes.
            [string] $logActivity = $null;

            # This will provide additional information that could be useful within the logfile,
            #   related to the operation.
            [string] $logAdditionalInformation = $null;

            # Extracted Directory Absolute Path.
            [string] $outputDirectory = $NULL;

            # Exit Status
            [bool] $exitCondition = $false;


            # Extract each project.
            $exitCondition = $defaultCompress.ExtractArchive($item.GetFilePath(), `
                                                            $($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_), `
                                                            [ref] $outputDirectory);


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
        } # try : Obtain List of Meta Files

        # Caught Error
        catch
        {
            # Unable to obtain list of installed projects; abort the operation.
            return $false;
        } # catch : Error Reached



        # Begin storing the project information into the Embed Installer File data structure,
        #   such that we can process the data.
        foreach ($item in $listOfMetaFiles)
        {
            # Declarations and Initializations
            # ----------------------------------------
            [EmbedInstallerFile]    $newProjectEntry        = $null;                                # Entry to add into Array
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
            # File does not exist; abort the operation.
            return $false;
        } # if : File does not exist


        # Try to open the file and obtain the contents
        try
        {
            $metaContents = Get-Content                                             `
                                -Path $metaFilePath                                 `
                                -TotalCount $GLOBAL:_META_FILE_CONTENT_LINE_SIZE_   `
                                -ErrorAction Stop;
        } # try : Retrieve the Contents from File

        # Caught an error
        catch
        {
            # Unable to open the meta file; abort the operation.
            return $false;
        } # catch : Caught Error


        # Make sure that the contents from the Meta file are in the appropriate structure per line.
        if (!   ($metaContents[0].Contains("Project_Name:")     -and `      # First Line Must Contain: Project_Name:
                ($metaContents[1].Contains("Project_Revision:") -and `      # Second Line Must Contain: Project_Revision:
                ($metaContents[2].Contains("Project_Signature:")))))        # Third Line Must Contain: Project_Signature:
        {
            # The structure of the contents are not correct; abort
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
            # Improper Datatype Assignment Occurred.
            return $false;
        } # catch : Caught an Error
        # ---------------------------------------------------



        # Finished
        return $true;
    } # __ReadMetaFile()
} # ProjectManager