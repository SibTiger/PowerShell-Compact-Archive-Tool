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
 # This class is intended to allow the user to install specific components into
 #  either of the following paths or resources within the environment:
 #      - PowerShell Compact-Archive Tool
 #      - PowerShell Core
 #      - User Files
 #
 # Because tools and resources changes over time, either due to new versions or
 #  perhaps new additions, it is crucial to allow the user to perform new updates
 #  or installs as time progresses onwards.
 #
 # DEPENDENCIES:
 #  .NET Core Framework v3 or later.
 #  PowerShell Core 7 or later
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
    #   This function will provide a step-by-step algorithm such that the
    #   user can easily perform new installation and updates into the desired
    #   environment.  As such, this function will guide the user through
    #   the installation procedure.
    # -------------------------------
    # Input:
    #  [EmbedInstallerInstallationType] Installation Type
    #   This value explicitly states the type of installation that will
    #   be performed within the main program.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #     $false = Failed to install\update resource
    #     $true  = Successfully installed\updated resource
    # -------------------------------
    #>
    static [bool] Main([EmbedInstallerInstallationType] $installationType)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the Temporary Directory's absolute Path.
        [string] $temporaryDirectoryPath = $NULL;


        # This will contain a collection of files that had been provided by the user.
        #  The datatype within this Array List will be: EmbedInstallerFile, for simplicity sakes.
        [System.Collections.ArrayList] $temporaryDirectoryContents = [System.Collections.ArrayList]::new();
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
            [string] $logMessage = ("Cannot continue with the EmbedInstaller as the dotNET Core Archive Zip was not available!`r`n" + `
                                    "In order for this installer to work properly, the dotNET Core Archive Zip functionality must be" + `
                                    " installed and available within the PowerShell Core's environment.");

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
                                            [ref] $temporaryDirectoryPath))
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


        # Did the user request to install\update Windows Notification?
        if ($installationType -eq [EmbedInstallerInstallationType]::WindowsToastNotification)
        {
            # Check to make sure that the site is reachable before trying to access it.
            if([WebsiteResources]::CheckSiteAvailability([NotificationVisual]::GetBurntToastDownloadURL(), $true))
            {
                # Open the URL using the preferred web browser.
                if (![WebsiteResources]::AccessWebSite_General([NotificationVisual]::GetBurntToastDownloadURL(),    ` # Burnt Toast Download's URL
                                                                "Burnt Toast Downloads"))                           ` # Page Title
                {
                    # Unable to access the website; possibly a host issue?


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = ("Unable to access the download page for Burnt Toast!`r`n"   + `
                                            "The user will have to access the website manually.");

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = "Site Requested: $([NotificationVisual]::GetBurntToastDownloadURL())";

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                                $logAdditionalMSG, `            # Additional information
                                                [LogMessageLevel]::Warning);    # Message level

                    # Alert the user through a message box signifying that an issue had occurred.
                    [CommonGUI]::MessageBox("Unable to automatically access $([NotificationVisual]::GetBurntToastDownloadURL())", `
                                            [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;


                    # * * * * * * * * * * * * * * * * * * *
                } # if : Unable to Access Website
            } # if : Site is Reachable
        } # if : Request to Install


        # Provide extra spacing to separate the Website Resources verbose information and the instructions
        #   that are soon to be provided.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide the instructions
        [EmbedInstaller]::__DrawMainInstructions($installationType, `
                                                $temporaryDirectoryPath);


        # Open the directory to the user such that they may drag and drop
        #   the contents into the temporary directory.
        [EmbedInstaller]::__OpenDirectoryAndWaitForClose($temporaryDirectoryPath);


        # Obtain a list of what files exists within the temporary directory.
        [EmbedInstaller]::__GetListFileContents($temporaryDirectoryPath, `
                                                $temporaryDirectoryContents);


        # Determine if the user is wanting to cancel the operation
        if ([EmbedInstaller]::__CancelOperation($temporaryDirectoryContents, `
                                                $temporaryDirectoryPath))
        {
            # Abort the operation.
            return $false;
        } # if : User Requested Abort


        # Perform a validation check by assuring that all provided archive datafiles given are healthy.
        [EmbedInstaller]::__CheckArchiveFileIntegrity($temporaryDirectoryContents);


        # Now that we made it this far, now we can perform the desired installation
        switch ($installationType)
        {
            # Installation: Burnt Toast
            ([EmbedInstallerInstallationType]::WindowsToastNotification)
            {
                # Perform the Installation
                [EmbedInstaller]::__EmbedInstallerBurntToast($temporaryDirectoryContents);


                # Finished
                break;
            } # Case : Burnt Toast


            # Installation: Project
            ([EmbedInstallerInstallationType]::Project)
            {
                # Perform the Installation
                [EmbedInstaller]::__EmbedInstallerProjects($temporaryDirectoryContents);


                # Finished
                break;
            } # Case : Projects
        } # switch : Installation Type



        return $true;
    } # Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Provide the instructions to the user such that they are aware as
    #   to what is happening within this operation.  By doing this, they
    #   will understand the procedure and what is expected from the user.
    # -------------------------------
    # Input:
    #  [EmbedInstallerInstallationType] Install Type
    #   This defines what content is expected to be installed within the environment.
    #  [string] Temporary Directory
    #   Provides the absolute path of the temporary directory.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions([EmbedInstallerInstallationType] $installType, `    # Installation Contents
                                                [string] $temporaryDirectory)                       # Path to Directory
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



        # Determine what kind of message should be displayed.
        switch ($installType)
        {
            # Modern Windows Toast Notification
            ([EmbedInstallerInstallationType]::WindowsToastNotification)
            {
                # Set the string
                $instructionString = (  " Instructions for Windows Burnt Toast`r`n"                                                                     + `
                                        "-------------------------------------`r`n"                                                                     + `
                                        "`r`n"                                                                                                          + `
                                        " Github Repository:`r`n"                                                                                       + `
                                        "`t`t$([NotificationVisual]::GetBurntToastWebsiteURL())`r`n"                                                    + `
                                        " Download Latest Version:`r`n"                                                                                 + `
                                        "`t`t$([NotificationVisual]::GetBurntToastDownloadURL())`r`n"                                                   + `
                                        "`r`n"                                                                                                          + `
                                        "`r`n"                                                                                                          + `
                                        "You can easily install or update Burnt Toast onto your system using $($GLOBAL:_PROGRAMNAME_) Installer.`r`n"   + `
                                        "`r`n"                                                                                                          + `
                                        "Follow the instructions below:`r`n"                                                                            + `
                                        "- - - - - - - - - - - - - - - -`r`n"                                                                           + `
                                        "  1) Download the latest version of Windows Burnt Toast using the download link provided above.`r`n"           + `
                                        "  2) Place the newly downloaded Zip file into the temporary folder named $($directoryName).`r`n"               + `
                                        "  3) Close the temporary folder window to continue the install process.`r`n"                                   + `
                                        "`r`n`r`n"                                                                                                      + `
                                        "NOTE: To abort this operation, you may close the temporary directory while it is empty."                       + `
                                        "`tBy doing this, it will cancel the operation."                                                                + `
                                        "`r`n`r`n");


                # Finished
                break;
            } # Modern Windows Toast Notifications



            # PowerShell Compact-Archive Tool Project
            ([EmbedInstallerInstallationType]::Project)
            {
                # Set the string
                $instructionString = (  " Instructions for $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                                       + `
                                        "-------------------------------------`r`n"                                                                     + `
                                        "`r`n"                                                                                                          + `
                                        "You can easily install or update your project(s) into $($GLOBAL:_PROGRAMNAME_).`r`n"                           + `
                                        "`r`n"                                                                                                          + `
                                        "Follow the instructions below:`r`n"                                                                            + `
                                        "- - - - - - - - - - - - - - - -`r`n"                                                                           + `
                                        "  1) Download the latest version(s) of the desired project(s) you wish to install.`r`n"                        + `
                                        "  2) Place the newly downloaded Zip file(s) into the temporary folder named $($directoryName).`r`n"            + `
                                        "  3) Close the temporary folder window to continue the install process.`r`n"                                   + `
                                        "`r`n`r`n"                                                                                                      + `
                                        "NOTE: To abort this operation, you may close the temporary directory while it is empty."                       + `
                                        "`tBy doing this, it will cancel the operation."                                                                + `
                                        "`r`n`r`n");


                # Finished
                break;
            } # Project
        } # Switch : Determine Instruction String


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
    hidden static [void] __OpenDirectoryAndWaitForClose([string] $temporaryDirectoryPath)
    {
        # Open the directory to the user.
        [CommonIO]::AccessDirectory($temporaryDirectoryPath, `  # Temporary Directory
                                    $NULL);                     # Nothing to highlight


        # Now wait for the user to finish
        [CommonIO]::WaitForFileExplorer($temporaryDirectoryPath);
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


        # Inspect _ALL_ files and verify that the archive datafile is healthy.
        foreach ($item in $fileCollection)
        {
            # Determine verification status
            if ($defaultCompress.VerifyArchive($item.GetFilePath()))
            {
                $item.SetVerification([EmbedInstallerFileVerification]::Passed);
            } # if : Verification Passed

            # Verification had Failed
            else
            {
                $item.SetVerification([EmbedInstallerFileVerification]::Failed);
            } # else : Verification Failed
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
    hidden static [void] __GetListFileContents([string] $temporaryDirectoryPath, `
                                                [System.Collections.ArrayList] $fileCollection)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this variable to collect the output from the Get-ChildItem CMDLet.
        [System.Object[]] $fileItems = [System.Object]::new();
        # ----------------------------------------



        # Obtain a list of contents that exists within the directory.
        $fileItems = Get-ChildItem -LiteralPath $temporaryDirectoryPath `
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
                                            [string] $temporaryDirectoryPath)
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
        [CommonIO]::DeleteDirectory($temporaryDirectoryPath);


        # Alert the user that the operation is terminating.
        $message = "`r`n`r`nInstallation had been cancelled!  Unable to find any ZIP files within the directory!`r`n`r`n"


        # Display the message to the user
        [Logging]::DisplayMessage($message);


        # Wait for the user to press the Enter Key, thus allowing them to understand what is happening.
        [CommonIO]::FetchEnterKey();


        # Alert the calling function to abort.
        return $true;
    } # __CancelOperation()




   <# Embed Installer - Install Burnt Toast
    # -------------------------------
    # Documentation:
    #  This function will try to install Burnt Toast onto the user's system.
    #   By doing this, we will need to assure that the environment is ready
    #   as well as possible updates to an already existing Burnt Toast
    #   installation.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] File Collection
    #   This will hold *.ZIP files that had been placed within the temporary directory.
    #   The Array List Objects are coming from Get-ChildItem CMDLet.
    # -------------------------------
    # Output:
    #  Installation status
    #   true    = Installation was successful.
    #   false   = Installation had failed.
    # -------------------------------
    #>
    hidden static [bool] __EmbedInstallerBurntToast([System.Collections.ArrayList] $temporaryDirectoryContents)
    {
        return $true;
    } # __EmbedInstallerBurntToast()




   <# Embed Installer - Install Projects
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
    hidden static [bool] __EmbedInstallerProjects([System.Collections.ArrayList] $temporaryDirectoryContents)
    {
        return $true;
    } # __EmbedInstallerProjects()
} # EmbedInstaller




<# Embed Installer - Installation Type [ENUM]
 # -------------------------------
 # This specifies a list of pre-defined directories that
 #  are supported for the installation process.
 # -------------------------------
 #>
enum EmbedInstallerInstallationType
{
    WindowsToastNotification        = 0;    # Windows 10's Toast Notification
    Project                         = 1;    # Supported Projects
} # EmbedInstallerInstallationType