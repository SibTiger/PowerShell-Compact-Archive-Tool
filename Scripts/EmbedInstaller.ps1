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




<# Embed Installer
 # ------------------------------
 # ==============================
 # ==============================
 # This class provides the ability to manage PowerShell Compact-Archive Tool Projects.
 #  Managing projects, such as:
 #  - Installing projects
 #  - Updating projects
 #  - Deleting projects
 #
 # Projects are an important asset to the PowerShell Compact-Archive Tool, as it provides
 #  the user with the ability to compile their game assets into an archive datafile and
 #  share that compiled build file to online communities or online file archive site.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this
 #  functionality easy for the user.
 #>




class EmbedInstaller
{
   <# Embed Installer
    # -------------------------------
    # Documentation:
    #  This function will act as our driver such that it will coordinate the
    #   the management procedure from installation, updating, or removing a
    #   desired project from the environment.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Operation had failed
    #     $true  = Operation was successful
    # -------------------------------
    #>
    static [bool] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the Temporary Directory's absolute Path.
        [string] $temporaryDirectoryFullPath = $NULL;


        # This will contain a collection of files that had been provided by the user.
        #  The datatype within this Array List will be: EmbedInstallerFile, for simplicity sakes.
        [System.Collections.ArrayList] $temporaryDirectoryContents = [System.Collections.ArrayList]::new();


        # Operation Status; this provides the operation state back to the calling function.
        [Bool] $operationState = $false;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that
        #   it is easy for the user to read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Embed Installer
        [CommonCUI]::DrawSectionHeader("$($Global:_PROGRAMNAME_) Installer");


        # Make sure that the internal Archive Zip functionality is available.
        if (![CommonFunctions]::IsAvailableZip())
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Cannot continue with the EmbedInstaller as the dotNET Core Archive Zip was not available!`r`n"     + `
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


        # Create a temporary directory
        if (![CommonIO]::MakeTempDirectory("$($GLOBAL:_PROGRAMNAMESHORT_)-InstallComponent", `
                                            [ref] $temporaryDirectoryFullPath))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Cannot continue with the EmbedInstaller as a Temporary Directory could not be created!`r`n"    +
                                    "The temporary directory is a requirement in such that the user can provide the desired files.");

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
        } # if : Failed to Create Temp. Directory


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide the instructions
        [EmbedInstaller]::__DrawMainInstructions($temporaryDirectoryFullPath);


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Open the directory to the user such that they may drag and drop
        #   the contents into the temporary directory.
        [EmbedInstaller]::__OpenDirectoryAndWaitForClose($temporaryDirectoryFullPath);


        # Provide some whitespace padding
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain a list of what files exists within the temporary directory.
        [EmbedInstaller]::__GetListFileContents($temporaryDirectoryFullPath, `
                                                $temporaryDirectoryContents);


        # Determine if the user is wanting to cancel the operation
        #  If the user did not provide any files, then abort the operation.
        if ([EmbedInstaller]::__CancelOperation($temporaryDirectoryContents, $temporaryDirectoryFullPath)) { return $false; }


        # Perform a validation check by assuring that all provided archive datafiles given are healthy.
        [EmbedInstaller]::__CheckArchiveFileIntegrity($temporaryDirectoryContents);


        # Perform the Installation
        $operationState = [EmbedInstallerProjects]::__InstallProjects($temporaryDirectoryContents);


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
    #  Provide the instructions to the user such that they are aware as
    #   to what is happening within this operation.  By doing this, they
    #   will understand the procedure and what is expected from the user.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory
    #   Provides the absolute path of the temporary directory.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions([string] $temporaryDirectory)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This string will be used to create the instructions
        #   that are specifically for the desired install item(s).
        [string] $instructionString = $NULL;


        # This is a just a temporary variable such that we can obtain the
        #   directory name, without the entire absolute path.
        [System.IO.DirectoryInfo] $directoryInformation = $temporaryDirectory;


        # This will hold just the name of the temporary directory.
        [string] $directoryName = $directoryInformation.NameString;
        # ----------------------------------------



        # Set the string
        $instructionString = [EmbedInstallerProjects]::__DrawInstructions($directoryName);


        # Display the message to the user
        [Logging]::DisplayMessage($instructionString);


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()




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
    #   This check is essential to the embedded installer's functionality,
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




   <# Get List File Contents
    # -------------------------------
    # Documentation:
    #  This function will inspect the provided directory for files that had been uploaded
    #   by the user.  When there are files within the directory, it will be recorded as an
    #   Embed Installer File object type.  By using the Embed Installer File, we can capture
    #   what information is important for this entire operation as a whole.
    #  Additionally, this function will only record *.ZIP files.  Any other types will be ignored.
    #
    #
    # CAUTION:
    #   This function will only capture Zip files, all others are ignored.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory
    #   Provides the absolute path of the temporary directory.
    #  [System.Collections.ArrayList] File Collection
    #   This will hold *.ZIP files that had been placed within the temporary directory.
    # -------------------------------
    #>
    hidden static [void] __GetListFileContents([string] $temporaryDirectoryFullPath, `
                                                [System.Collections.ArrayList] $fileCollection)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this variable to collect the output from the Get-ChildItem CMDLet.
        [System.Object[]] $fileItems = [System.Object]::new();
        # ----------------------------------------



        # Obtain a list of contents that exists within the directory.
        $fileItems = Get-ChildItem -LiteralPath $temporaryDirectoryFullPath `
                                    -Filter "*.zip";



        # Record all of the files found
        foreach ($file in $fileItems)
        {
            # Create a new instance of the Embed Install File type.
            [EmbedInstallerFile] $newFileEntry = [EmbedInstallerFile]::New($file.Name, $file.FullName);

            # Add the file into the collection.
            $fileCollection.Add($newFileEntry);
        } # foreach : Record Files
    } # __GetListFileContents()




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
} # EmbedInstaller