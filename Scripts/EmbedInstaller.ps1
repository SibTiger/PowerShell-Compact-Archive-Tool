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
 # This class can provide the ability to manage PowerShell Compact-Archive Tool projects, such that projects
 #  can be:
 #  - Installed
 #  - Updated
 #  - Removed
 #
 # Projects are an important asset to the PowerShell Compact-Archive Tool architecture, as it provides the
 #  the user with the ability to compile their game assets into an archive datafile and then later share
 #  that compiled build file to online communities or an online file archive site.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this
 #  functionality easy for the user.
 #>




class ProjectManager
{
   <# Project Manager
    # -------------------------------
    # Documentation:
    #  This function will act as our driver for this class.  Within this function, we will determine as to
    #   what action the user wishes to perform.  Such as needing to install a new project into PSCAT,
    #   update an already existing installation of a project, or removing a project entirely from PSCAT.
    #
    #  NOTE:
    #   This is the ideal entry way into this class.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed or canceled
    #     $true  = Operation was successful
    # -------------------------------
    #>
    static [bool] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # List of Files to Install
        [System.Collections.ArrayList] $listOfProjectsToInstall = [System.Collections.ArrayList]::New();


        # This will hold the Temporary Directory's absolute Path.
        [string] $temporaryDirectoryFullPath = $NULL;


        # This will contain a collection of files that had been provided by the user.
        #  The datatype within this Array List will be: EmbedInstallerFile, for simplicity sakes.
        [System.Collections.ArrayList] $temporaryDirectoryContents = [System.Collections.ArrayList]::new();


        # Operation Status; this provides the operation state back to the calling function.
        [Bool] $operationState = $false;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that it is easy for the user to
        #   read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Project Manager
        [CommonCUI]::DrawSectionHeader("Project Manager");


        # Check System Requirements
        if (![ProjectManager]::__CheckSystemRequirements()) { return $false; }


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


        # Determine if the user is wanting to cancel the operation
        #  If the user did not provide any files, then abort the operation.
        if ([ProjectManager]::__CancelOperation($temporaryDirectoryContents, $temporaryDirectoryFullPath)) { return $false; }


        # Perform a validation check by assuring that all provided archive datafiles given are healthy.
        [ProjectManager]::__CheckArchiveFileIntegrity($temporaryDirectoryContents);


        # Perform the Installation
        $operationState = [ProjectManager]::__InstallProjects($temporaryDirectoryContents);


        # Alert the user of the installation status
        if ($operationState) { [Logging]::DisplayMessage("Successfully installed all desired projects!`r`n"); }
        else { [Logging]::DisplayMessage("One or more files could not be installed!`r`n"); }


        # Provide a report of the files that had been installed or could not be installed.
        [Logging]::DisplayMessage("`r`nInstallation Report of the Following Files:`r`n" + `
                                    "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = =`r`n" + `
                                    "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -`r`n");


        # Output the results to the user such that they know the what had been installed or could
        #   not be installed.
        foreach($item in $temporaryDirectoryContents)
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
    #  Provide the instructions to the user such that they are aware as to what is happening within this
    #   operation.  By doing this, they will understand the procedure and what is expected from the user.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory
    #   Provides the absolute path of the temporary directory.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This string will be used to create the instructions that are specifically for the desired
        #   install item(s).
        [string] $instructionString = $NULL;
        # ----------------------------------------



        # Set the string
        $instructionString = (  " Instructions for $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                               + `
                                "-------------------------------------`r`n"                                                             + `
                                "`r`n"                                                                                                  + `
                                "You can easily install or update your project(s) into $($GLOBAL:_PROGRAMNAME_).`r`n"                   + `
                                "`r`n"                                                                                                  + `
                                "`r`n"                                                                                                  + `
                                "Follow the instructions below:`r`n"                                                                    + `
                                "- - - - - - - - - - - - - - - -`r`n"                                                                   + `
                                "  1) Download the latest version(s) of the desired project(s) you wish to install.`r`n"                + `
                                "  2) Place the newly downloaded Zip file(s) into the temporary folder named $($NULL).`r`n"             + `
                                "  3) Close the temporary folder window to continue the install process.`r`n"                           + `
                                "`r`n"                                                                                                  + `
                                "`r`n"                                                                                                  + `
                                " NOTE: To abort this operation, you may close the temporary directory while it is empty."              + `
                                "`tBy doing this, it will cancel the operation."                                                        + `
                                "`r`n`r`n");


        # Display the message to the user
        [Logging]::DisplayMessage($instructionString);


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()




   <# Get Projects from User
    # -------------------------------
    # Documentation:
    #  This function is designed to give the user the ability to specify what project archive files are to
    #   be installed into PSCAT's environment.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] (EmbedInstallerFile) Project List
    #   This will contain a list of project files that the user wishes to install into PSCAT.
    # -------------------------------
    # Output:
    #  Where Files Selected
    #   $true    = One or More files were selected.
    #   $false   = User Cancelled
    # -------------------------------
    #>
    hidden static [bool] __GetProjectsFromUser([System.Collections.ArrayList] $projectList)
    {
        # Provide Windows' File Browser, giving the user the ability to freely select one or more project files
        if (![CommonGUI]::BrowseFile("Select Project(s) to Install",                    `   # Title
                                    "*.zip",                                            `   # Default File Extension
                                    "Zip file (*.zip)|*.zip|7-Zip file (*.7z)|*.7z",    `   # Filter File Extensions
                                    $true,                                              `   # Select Multiple Files
                                    [BrowserInterfaceStyle]::Modern,                    `   # Style
                                    $projectList))                                          # List of Files Selected by User.
        {
            # User canceled the operation.
            return $false;
        } # if : User Canceled


        # One or more files selected by user.
        return $true;
    } # __GetProjectsFromUser()




   <# Check System Requirements
    # -------------------------------
    # Documentation:
    #  This function is designed to check if the system meets all of the requirements in order for this
    #   functionality to work correctly.
    # -------------------------------
    # Output:
    #  Requirements Flag
    #   $true    = Requirements had been met
    #   $false   = Requirements are not met.
    # -------------------------------
    #>
    hidden static [bool] __CheckSystemRequirements()
    {
        # Make sure that the internal Archive Zip functionality is available.
        if (![CommonFunctions]::IsAvailableZip())
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Cannot continue with the Project Manager as the dotNET Core Archive Zip is not available!`r`n"     + `
                                    "In order for this installer to work properly, the dotNET Core Archive Zip functionality must be"   + `
                                    " installed and available within the PowerShell Core's environment!`r`n"                            + `
                                    "Operation will be aborted.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Alert the user through a message box signifying that an issue had occurred.
            [CommonGUI]::MessageBox($logMessage, `
                                    [System.Windows.MessageBoxImage]::Hand) | Out-Null;


            # * * * * * * * * * * * * * * * * * * *


            # Send error signal
            return $false;
        } # if : Internal Zip is Not Available


        # If we made it here, than all of the requirements had been meet.
        return $true;
    } # __CheckSystemRequirements()




   <# Open Temporary Directory
    # -------------------------------
    # Documentation:
    #  With calling this function, it will open and display the temporary
    #   directory to the user and wait for the window to be closed by the
    #   user before proceeding onward with the operation.
    #
    #
    # NOTE:
    #  - This function requires that the temporary directory path must had
    #       already been created and exists within the specified location.
    #  - This function will HALT the program until the Temporary Folder
    #       had been closed by the user.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory
    #   Provides the absolute path of the temporary directory.
    # -------------------------------
    #>
    hidden static [void] __OpenDirectoryAndWaitForClose([string] $temporaryDirectoryFullPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the instructions that will be presented to the user.
        [string] $instructions = $null;


        # This is a just a temporary variable such that we can obtain the
        #   directory name, without the entire absolute path.
        [System.IO.DirectoryInfo] $directoryInformation = $temporaryDirectoryFullPath;


        # This will hold just the name of the temporary directory.
        [string] $directoryName = $directoryInformation.NameString;
        # ----------------------------------------



        # Generate the instructions for this part of the process.
        $instructions = ("Place the newly downloaded Zip file(s) into the temporary folder named $($directoryName).`r`n" + `
                        "Once finished, close the temporary folder window named $($directoryName) to continue. . .");


        # Open the directory to the user.
        [CommonIO]::AccessDirectory($temporaryDirectoryFullPath, `  # Temporary Directory
                                    $NULL);                     # Nothing to highlight


        # Alert the user that the temporary directory window instance must be closed in order to continue.
        [Logging]::DisplayMessage($instructions);


        # Now wait for the user to finish
        [CommonIO]::WaitForFileExplorer($temporaryDirectoryFullPath);
    } # __OpenDirectoryAndWaitForClose()




   <# Check Archive File Integrity
    # -------------------------------
    # Documentation:
    #  By calling this function, we will want to check all files provided
    #   within the Array List to assure the files are not corrupted.
    #   This check is essential to the Project Manager's functionality,
    #   which will help prevent or reduce potential unforeseen consequences
    #   during the operations.
    #
    # This function will merely update the Array List items, the further
    #   algorithms will determine the best course of action.  As such,
    #   we will not return a status regarding the findings.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] {EmbedInstallerFile} File Collections
    #   Provides a list of all files provided by the user.
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



        # If there's nothing provided, then there's nothing todo.
        if ($fileCollection.Count -eq 0) { return; }


        # Alert the user that we are inspecting the provided files.
        [Logging]::DisplayMessage("Verifying file(s). . .`r`n");


        # Inspect _ALL_ files and verify that the archive datafile is healthy.
        foreach ($item in $fileCollection)
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Create a string in which we can use to generate the operation and record the result.
            #   This information will be logged within the program's logfile -- useful for debugging
            #   if needed.
            # We will initialize this variable by including the filename that is being inspected.
            [string] $logActivity = "Verified file named: $($item.GetFileName())";

            # This will provide additional information that could be useful within the logfile,
            #   related to the operation.
            [string] $logAdditionalInformation = $null;
            # ----------------------------------------



            # Determine verification status
            if ($defaultCompress.VerifyArchive($item.GetFilePath()))
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Passed!";

                # Provide additional information
                $logAdditionalInformation = "The file is healthy and can be installed into the environment.";

                # Adjust the attributes of the desired file entry.
                $item.SetVerification([EmbedInstallerFileVerification]::Passed);
            } # if : Verification Passed

            # Verification had Failed
            else
            {
                # Save the result provided by the verification process.
                $logActivity = $logActivity + "`r`n`t- Result: Failed!";

                # Provide additional information
                $logAdditionalInformation = "The file is damaged and cannot be installed due to corrupted data.";

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




   <# Cancel Operation
    # -------------------------------
    # Documentation:
    #  This function will determine if the user had requested to cancel the installation
    #   procedure and then provide them with feedback stating that the operation will be
    #   terminated.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] File Collection
    #   This will hold *.ZIP files that had been placed within the temporary directory.
    #  [string] Temporary Directory Path
    #   Contains the path to the temporary directory, if incase we need to delete it.
    # -------------------------------
    # Output:
    #  Alerts the calling function if the user wanted to abort the operation.
    #   true    = Abort the operation.
    #   false   = Continue forward.
    # -------------------------------
    #>
    hidden static [bool] __CancelOperation([System.Collections.ArrayList] $fileList,
                                            [string] $temporaryDirectoryFullPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This string will alert the user that the installation process
        #   is aborting, as requested.
        [string] $message = $NULL;
        # ----------------------------------------



        # Does the file list contain at least one or more files?
        #  If there exists at least one file, allow the procedure to continue on.
        if ($fileList.Count -gt 0) { return $false; }


        # User had requested to cancel the operation.
        # Delete the temporary directory.
        [CommonIO]::DeleteDirectory($temporaryDirectoryFullPath);


        # Alert the user that the operation is terminating.
        $message = "`r`n`r`nInstallation had been cancelled!  Unable to find any ZIP files within the directory!`r`n`r`n"


        # Display the message to the user
        [Logging]::DisplayMessage($message);


        # Wait for the user to press the Enter Key, thus allowing them to understand what is happening.
        [CommonIO]::FetchEnterKey();


        # Alert the calling function to abort.
        return $true;
    } # __CancelOperation()




    # Install Project(s)
    # -------------------------------
    # Documentation:
    #  This function will try to install the desired project(s) onto the
    #   user's system.  By doing this, we will need to assure that the
    #   environment is ready as well as possible updates to an already
    #   existing Burnt Toast installation.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] File Collection
    #   This will hold *.ZIP files that had been placed within the temporary directory.
    # -------------------------------
    # Output:
    #  Installation status
    #   true    = Installation was successful.
    #   false   = Installation had failed.
    # -------------------------------
    #>
    hidden static [bool] __InstallProjects([System.Collections.ArrayList] $temporaryDirectoryContents)
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
        foreach ($item in $temporaryDirectoryContents)
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




    # Get Installed Projects
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
    [bool] GetInstalledProjects([System.Collections.ArrayList] $installedProjects)
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
            if (!ReadMetaData($item.FullName,               ` # Where the meta file is located
                                [ref] $newProjectRevision,  ` # Get Project's Revision
                                [ref] $newProjectName,      ` # Get Project's Name
                                [ref] $newProjectSignature))  # Get Project's GUID
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
    } # GetInstalledProjects()




    # Read Meta Data File
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
    [bool] ReadMetaFile([string] $metaFilePath, `       # Absolute path to the project's meta file
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
    } # ReadMetaFile()
} # ProjectManager