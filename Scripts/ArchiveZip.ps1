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




<# Archive Zip
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user to perform the following actions:
 #  - Compress files to a archive data file
 #  - Extract files from  a archive data file
 #  - List files that are present within a archive data file.
 # In order for this functionality to work, we will use the PowerShell
 #  Module in order to perform the necessary actions properly.
 #  As a benefit of using the PowerShell Module, we do not need to
 #  need to worry about any external resources, such as WinZip or 7Zip.
 #  However, instead, we only need to assure that the host system has
 #  the correct version of the dotNET Core Framework and PowerShell
 #  Core installed.
 #
 # DEPENDENCIES:
 #  - PowerShell Core 6.0, at minimum
 #      - Built with dotNET Core 2.0
 #      OR
 #  - PowerShell Core 7.4.6, tested during development
 #      - Built with dotNET 8.0
 #          known working on Windows 10 and Windows 11.
 #          Later versions should work fine?
 #
 # DEVELOPER NOTES [API]:
 #  We will be using the following modules and APIs heavily within
 #   this class:
 #   - System.IO.Compression (dotNET Framework && dotNET Core Framework)
 #     > https://docs.microsoft.com/en-us/dotnet/api/system.io.compression
 #   - Microsoft.PowerShell.Archive (PowerShell Module)
 #     > https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive
 #>




class ArchiveZip
{
    # Object Singleton Instance
    # =================================================
    # =================================================


    #region Singleton Instance

    # Singleton Instance of the object
    hidden static [ArchiveZip] $_instance = $null;




    # Get the instance of this singleton object (Default)
    static [ArchiveZip] GetInstance()
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [ArchiveZip]::_instance)
        {
            # Create a new instance of the singleton object.
            [ArchiveZip]::_instance = [ArchiveZip]::new();
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [ArchiveZip]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Hidden Variables

    # Log Root
    # ---------------
    # The main parent directory's absolute path that will hold this object's logs directory.
    Hidden [string] $__rootLogPath = "$($global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_)\PSArchive";


    # Log Root Path
    # ---------------
    # This directory, in absolute form, will hold logfiles that were generated
    #  from this object when creating and extracting contents from within an
    #  archive datafile.
    Hidden [string] $__logPath = "$($this.__rootLogPath)\logs";


    # PowerShell Module Name
    # ---------------
    # This will contain the name of the PowerShell Module for this specific functionality.
    #   With this POSH Module being already built into the POSH Core framework, we can only
    #   check to make sure that the module is still present within the POSH Core environment.
    #
    # Developer Note:
    #   Because this POSH Module is built-into the POSH Core's framework, we cannot perform
    #   the following actions:
    #       - Updates
    #       - Uninstall
    #       - Install
    #   This is due to the module not having to be installed through the PowerShell
    #   Gallery Repository.
    #
    # Install Location:
    #   Built-In since Windows 10
    # Module Requirements:
    #   PowerShell Version 5.0 and Later
    # Module Information:
    #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive
    Hidden [string] $__powerShellModuleName = "Microsoft.PowerShell.Archive";


    # Object GUID
    # ---------------
    # Provides a unique identifier to the object, useful to make sure that we are using
    #  the right object within the program.
    Hidden [GUID] $__objectGUID = [GUID]::NewGuid();

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    ArchiveZip() {;}

    #endregion



    #region Getter Functions

   <# Get Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Log Path
    #   The value of the 'Log Directory Path'.
    # -------------------------------
    #>
    [string] GetLogPath() { return $this.__logPath; }




   <# Get Root Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Root Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Root Log Path
    #   The value of the 'Log Root Directory Path'.
    # -------------------------------
    #>
    [string] GetRootLogPath() { return $this.__rootLogPath; }




   <# Get PowerShell Module Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'PowerShell Module Name' variable.
    # -------------------------------
    # Output:
    #  [string] PowerShell Module Name
    #   The value of the 'PowerShell Module Name'.
    # -------------------------------
    #>
    [string] GetPowerShellModuleName() { return $this.__powerShellModuleName; }




   <# Get Object GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the object's 'Global Unique ID' variable.
    # -------------------------------
    # Output:
    #  [GUID] Global Unique Identifier (GUID)
    #   The value of the object's GUID.
    # -------------------------------
    #>
    [GUID] GetObjectGUID() { return $this.__objectGUID; }

    #endregion



    #region Hidden Functions


   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories that will contain the log files
    #   that are generated from this class.  If the directories do not exist in the filesystem
    #   already, there is a chance that some operations might fail due to the inability to
    #   properly store the log files that are generated by the functions within this class.
    #  If the directories do not already exist, this function will try to create
    #   them automatically - without interacting with the end-user.
    #  If the directories already exist within the filesystem, then nothing will
    #   be performed.
    #
    # ----
    #
    #  Directories to be created:
    #   - %LOCALAPPDATA%\<PROG_NAME>\PSArchive
    #   - %LOCALAPPDATA%\<PROG_NAME>\PSArchive\logs
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure creating the new directories.
    #    $true  = Successfully created the new directories
    #             OR
    #             Directories already existed, nothing to do.
    # -------------------------------
    #>
    Hidden [bool] __CreateDirectories()
    {
        # First, check if the directories already exist.
        if(($this.__CheckRequiredDirectories()) -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The Archive Zip logging directories already exists;" + `
                                    " there is no need to create the directories again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive Zip Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # Root Log Directory
        if([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if ([CommonIO]::MakeDirectory($this.GetRootLogPath()) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Archive Zip root logging!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The root directory path would be:`r`n" + `
                                                "`t`t" + $this.GetRootLogPath());

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Root Log Directory


        # ----


        # Log Directory
        if([CommonIO]::CheckPathExists($this.GetLogPath(), $true) -eq $false)
        {
            # Log Directory does not exist, try to create it.
            if ([CommonIO]::MakeDirectory($this.GetLogPath()) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the Archive Zip logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The logging directory path would be:`r`n" + `
                                                "`t`t" + $this.GetLogPath());

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Log Directory


        # ----


        # Final assurance check; make sure that the required directories had been created successfully.
        if($this.__CheckRequiredDirectories() -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created the Archive Zip logging directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive Zip Logging Directories:`r`n" + `
                                            "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                            "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *

            # The directories exist
            return $true;
        } # IF : Check if Directories Exists

        # If the directories could not be detected - despite being created on the filesystem,
        #  then something went horribly wrong.
        else
        {
            # The directories could not be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the Archive Zip required logging directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive Zip Logging Directories:`r`n" + `
                                            "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                            "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : If Directories Not Found


        # A general error occurred; the directories could not be created.
        return $false;
    } # __CreateDirectories()




   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function will check to make sure that the log directories,
    #   that are used in this class, currently exists within the host's
    #   filesystem.
    #
    # ----
    #
    #  Directories to be checked:
    #   - %LOCALAPPDATA%\<PROG_NAME>\PSArchive
    #   - %LOCALAPPDATA%\<PROG_NAME>\PSArchive\logs
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Hidden [bool] __CheckRequiredDirectories()
    {
        return (([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true) -eq $true) -and   ` # Check the Root Log Directory
                ([CommonIO]::CheckPathExists($this.GetLogPath(), $true) -eq $true));            # Check the Log Path Directory
    } # __CheckRequiredDirectories()


    #endregion



    #region Visible Functions


   <# Detect Compression Module
    # -------------------------------
    # Documentation:
    #  This function will try to detect if the required PowerShell Module is
    #   presently available within the PowerShell Core's environment.  Without
    #   the PowerShell Module, the primary functionality within this class is
    #   merely pointless.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = Required PowerShell Module was not found
    #   $true = Required PowerShell Module was found
    # -------------------------------
    #>
    [bool] DetectCompressModule()
    {
        # We are going to try to detect if the module is available within this
        #  PowerShell instance.  If incase it is not available - then we must
        #  return false, or simply stating that it was not found.
        # NOTE: If there is ANY output, then this function will return true.
        # Reference: https://stackoverflow.com/a/28740512
        if (Get-Module -ListAvailable -Name $this.GetPowerShellModuleName())
        {
            # Detected the PowerShell Module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Found the $($this.GetPowerShellModuleName())) PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "It is possible to use $($this.GetPowerShellModuleName()) features!";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that we had found the PowerShell Module
            return $true;
        } # if : Module is installed

        # Unable to find the required PowerShell Module
        else
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Could not find the PowerShell Module: $($this.GetPowerShellModuleName())!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("It is not possible to use $($this.GetPowerShellModuleName()) features!`r`n" + `
                                        "`t- Please make sure that you have the latest version of the PowerShell Core installed:`r`n" + `
                                        "`t`thttps://github.com/PowerShell/PowerShell`r`n" + `
                                        "`t- If needed, you may also need to download the latest version of the dotNET Core:`r`n" + `
                                        "`t`thttps://dotnet.microsoft.com/download");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : Module not detected


        # Because the PowerShell Module was not detected.
        return $false;
    } # DetectCompressModule()



    #region Archive File Management

   <# Extract Archive
    # -------------------------------
    # Documentation:
    #  This function will extract all of the contents that is inside of the
    #   archive data file.  The contents that had been extracted will be placed
    #   in the designated output directory, if the output is a legal path.
    #
    #  Output Directory:
    #   In this function, a new directory will be created containing the same
    #   name as the archive data file's name, excluding the file extension.
    #   If, however, the directory already exists with the same name, then a new
    #   directory will be created with a Data & Time Stamp to the filename to
    #   make it unique.
    #
    #  For Example:
    #   E:\User\FreddyM\Documents\{{DESIRED_OUTPUT}}\{{ARCHIVE_FILENAME_EXTRACTED_FILES}}\*
    #  OR, if the directory already exists:
    #   E:\User\FreddyM\Documents\{{DESIRED_OUTPUT}}\{{ARCHIVE_FILENAME_EXTRACTED_FILES}}_{{DATE_TIME_STAMP}}\*
    #
    # Extract Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/Expand-Archive
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive data file, in absolute path form, that we want to extract.
    #  [string] Output Path
    #   The absolute path of where the new directory, containing the
    #   extracted contents, will be stored.
    #  [string] (REFERENCE) Directory Output
    #   The absolute path of the newly created directory containing the extracted files.
    # -------------------------------
    # Output:
    #  [bool] Exit Code
    #    $false = Failed to extract files from the archive data file.
    #    $true  = Successfully extracted files from the archive data file.
    # -------------------------------
    #>
    [bool] ExtractArchive([string] $file, `         # The archive file we want to extract the data from
                        [string] $outputPath, `     # The desired path we want to store the extracted data
                        [ref] $directoryOutput)     # The extracting directory of where the contents had been placed
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $extractPath = $null;                              # This will hold the extracting directory path; all of the
                                                                    #  contents from the archive will be placed within this
                                                                    #  directory set by this variable.
        [string] $getDateTime = $null;                              # This variable will hold the date and time, if required to help
                                                                    #  make the extracting directory path unique.
        [string] $fileName = $null;                                 # This will only hold the filename of the archive file, omitting
                                                                    #  the extension and absolute path.
        [string] $fileNameExt = $null;                              # This will only hold the filename of the archive file, containing
                                                                    #  the extension and absolute path.
        [string] $execReason = $null;                               # This will hold the description of the operation that is being
                                                                    #  performed in this function, but only presented for logging
        [bool] $exitCode = $false;                                  # Used to determine the status of the Expand-Archive operation.
        [System.Object] $execSTDOUT = [System.Object]::new();       # This will hold the STDOUT that is provided by the CMDLet that
                                                                    #  will be used for the extraction process, but contained as
                                                                    #  an object.
        [System.Object] $execSTDERR = [System.Object]::new();       # This will hold the STDERR that is provided by the CMDLet that
                                                                    #  will be used for the extraction process, but contained as
                                                                    #  an object.
        [string] $strSTDOUT = $null;                                # This will hold the STDOUT information, but will be held as a
                                                                    #  literal string.  The information provided to it will be
                                                                    #  converted from an object to a string, the information held in
                                                                    #  this variable will be presented in the logfile.
        [string] $strSTDERR = $null;                                # This will hold the STDERR information, but will be held as a
                                                                    #  literal string.  The information provided to it will be
                                                                    #  converted from an object to a string, the information held in
                                                                    #  this variable will be presented in the logfile.
        # ----------------------------------------



        # Assign the Variables
        # - - - - - - - - - - - - - -
        # Perform the necessary assignments that we couldn't do during the initialization phase, because
        #   of the width was too large.
        # ---------------------------

        # Setup the filename to match with the archive data file's name but omitting the file extension.
        $fileName = [string]([System.IO.Path]::GetFileNameWithoutExtension($file));

        # Setup the filename to match with the archive data file's name, including the file extension.
        $fileNameExt = [string]([System.IO.Path]::GetFileName($file));

        # The description that will be presented in the logfile.
        $execReason = "Extracting " + $fileNameExt;



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the logging requirements are met.
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the log directories could not be created, we cannot log any events.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file:`r`n" + `
                                            "`t" + $fileNameExt + "`r`n" + `
                                            "The Log directories could not be created!`r`n" + `
                                            "Please make sure that you have sufficient privileges to create directories in:`r`n" + `
                                            "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_);

            # Generate the initial message
            [string] $logMessage = "Unable to extract data from the compressed file because the log directories could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the log directories for the Archive Zip could not be created, " + `
                                            "nothing can be logged as required.`r`n" + `
                                        "`tTried to create directories in:`r`n" + `
                                        "`t`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_ + "`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required log directories are created.`r`n" + `
                                        "`t`t- Make sure that you have sufficient permissions to create directories.`r`n" + `
                                        "`tTried to Extract from the Compressed File:`r`n" + `
                                        "`t`t" + $fileName + "`r`n" + `
                                        "`tPath to the Archive Data File:`r`n" + `
                                        "`t`t" + $file);

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


            # Because logging features are required, we cannot run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that The PowerShell Module is presently available for us to use.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because the PowerShell Module is not available, we essentially cannot do anything meaningful.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file:`r`n" + `
                                            "`t" + $fileNameExt + "`r`n" + `
                                            "The PowerShell Module, " + $this.GetPowerShellModuleName() + `
                                                ", was not detected!`r`n" + `
                                            "Because the PowerShell Module was not found, it is not possible " + `
                                                "to extract data from a compressed file!");

            # Generate the initial message
            [string] $logMessage = ("Unable to extract data from the compressed file because the required PowerShell Module, " + `
                                        $this.GetPowerShellModuleName() + ", was not found!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have the latest version of PowerShell Core installed.`r`n" + `
                                        "`tRequired PowerShell Module:`r`n" + `
                                        "`t`t" + $this.GetPowerShellModuleName() + "`r`n" + `
                                        "`tTried to Extract from the Compressed File:`r`n" + `
                                        "`t`t" + $fileNameExt + "`r`n" + `
                                        "`tPath to the Archive Data File:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tPlease check for the latest version of PowerShell Core: `r`n" + `
                                        "`t`thttps://learn.microsoft.com/en-us/powershell/");

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


            # Because the required PowerShell Module was not found, we cannot proceed any further.
            return $false;
        } # if : PowerShell Module not Available


        # Make sure that the archive file exists.
        if ([CommonIO]::CheckPathExists($file, $true) -eq $false)
        {
            # The archive data file does not exist with the provided path;
            #   We will not be able to perform the extraction operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file:`r`n" + `
                                            "`t" + $fileNameExt + "`r`n" + `
                                            "The path to the compressed file is not correct.`r`n" + `
                                            "The path given to the compressed file:`r`n" + `
                                            "`t" + $file);

            # Generate the initial message
            [string] $logMessage = "Unable to extract data from the compressed file because the archive file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "The Archive Data File Path Given: `r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Path Given was:`r`n" + `
                                        "`t`t" + $outputPath;

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


            # Return a failure as the archive file does not exist.
            return $false;
        } # if : Archive File does not Exist


        # Make sure that the desired output path currently exists
        if ([CommonIO]::CheckPathExists($outputPath, $true) -eq $false)
        {
            # The requested output path does not currently exist; we cannot proceed any further.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file:`r`n" + `
                                            "`t" + $fileNameExt + "`r`n" + `
                                            "The path to the output directory was not correct.`r`n" + `
                                            "The output directory path given was:`r`n" + `
                                            "`t" + $outputPath);

            # Generate the initial message
            [string] $logMessage = "Unable to extract the compressed file because the output directory could not be found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive file to extract:`r`n" + `
                                        "`t`t" + $file  + "`r`n" + `
                                        "`tOutput Directory:`r`n" + `
                                        "`t`t" + $outputPath);

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


            # The output path does not exist; we cannot extract the contents.
            return $false;
        } # if : Output Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # CREATE THE EXTRACTING DIRECTORY
        # - - - - - - - - - - - - - -
        # Before we can do the main operation, we first need to make sure that the
        #  extracting directory is unique and can be created successfully.
        # ---------------------------

        # Provide the general extracting path
        #  OutputPath + Filename
        $extractPath = "$($outputPath)\$($fileName)";


        # Does the extracting directory already exist?
        if ([CommonIO]::CheckPathExists($extractPath, $true) -eq $true)
        {
            # Because the directory already exists, we need to make it unique.  To accomplish
            #  the task of making the directory to be unique, we will add a timestamp to the
            #  directory in order to make it unique while still giving the data 'meaning' to
            #  it.
            #  Date and Time
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            $getDateTime = [string](Get-Date -UFormat "%d-%b-%Y_%H-%M-%S");

            # Now put everything together
            $extractPath += "_" + $getDateTime;
        } # if : Make a Unique Directory Name


        # Create the new extracting directory; if unable to create it, we cannot proceed any further.
        if([CommonIO]::MakeDirectory($extractPath) -eq $false)
        {
            # A failure occurred when trying to make the directory,
            #  we cannot continue as the extracting directory is not available.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file:`r`n" + `
                                            "`t" + $fileNameExt + "`r`n" + `
                                            "It was not possible to create the extracting directory as needed.`r`n" + `
                                            "Extracting Directory Path:`r`n" + `
                                            "`t" + $extractPath);

            # Generate the initial message
            [string] $logMessage = "Unable to extract data from the compressed file because the extracting directory could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested compressed file to extract:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Directory:`r`n" +
                                        "`t`t" + $outputPath + "`r`n" + `
                                        "`tExtracting Directory:`r`n" + `
                                        "`t`t" + $extractPath);

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


            # Because the extracting directory could not be created, we cannot proceed any further.
            return $false;
        } # if : Failed to create extracting directory


        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the directory resides.
        #  Thus, the calling function can bring the new directory to the user's
        #  attention using whatever methods necessary.
        $directoryOutput.Value = $extractPath;


        # ---------------------------
        # - - - - - - - - - - - - - -



        # EXTRACT THE ARCHIVE DATA FILE
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Execute the Expand-Archive CMDLet
        try
        {
            # Extract the contents
            Expand-Archive -LiteralPath $file `
                           -DestinationPath $extractPath `
                           -ErrorAction Stop `
                           -PassThru `
                           -OutVariable execSTDOUT `
                           -ErrorVariable execSTDERR;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully extracted the data from the compressed file!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Compressed file that was extracted:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Directory:`r`n" + `
                                        "`t`t" + $outputPath + "`r`n" + `
                                        "`tExtracting Directory:`r`n" + `
                                        "`t`t" + $extractPath);

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Update the Exit Code status; the operation was successful.
            $exitCode = $true;
        } # try : Execute Extract Task

        # An error occurred; a file might have been corrupted or missing.
        catch [System.Management.Automation.ItemNotFoundException]
        {
            # This will temporarily hold on to just the file name that is missing or corrupted.
            [string] $badFileName = Split-Path -Path "$([string]($_.TargetObject))" -Leaf;

            # This will temporarily hold on to the full path of the file that is missing or corrupted.
            [string] $badFileNameFull = [string]($_.TargetObject);


            # Because a failure had been reached, we will have to update the exit code.
            $exitCode = $false;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("The file named '$($badFileName)' was not found in the archive file: " + `
                                            "$($fileNameExt)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = ("Failed to extract data from the compressed file; the file with a name of '$($badFileName)' was" + `
                                    " not found in the compressed file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("File that is missing or corrupted:`r`n" + `
                                        "`t`t" + $badFileNameFull + "`r`n" + `
                                        "`tArchive file that was extracted:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Directory:`r`n" + `
                                        "`t`t" + $outputPath + "`r`n" + `
                                        "`tExtracting Directory:`r`n" + `
                                        "`t`t" + $extractPath + "`r`n" + `
                                        [Logging]::GetExceptionInfo($_.Exception));

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


        } # Catch [ItemNotFound] : File Not Found

        # An error occurred; the archive data file's format is malformed
        catch [System.IO.FileFormatException]
        {
            # Because a failure had been reached, we will have to update the exit code.
            $exitCode = $false;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("The compressed file, $($fileNameExt), is corrupted.`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to extract data from the compressed file; the compressed file is corrupted.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Compressed file that was extracted:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Directory:`r`n" + `
                                        "`t`t" + $outputPath + "`r`n" + `
                                        "`tExtracting Directory:`r`n" + `
                                        "`t`t" + $extractPath + "`r`n" + `
                                        [Logging]::GetExceptionInfo($_.Exception));

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
        } # Catch [FileFormat] : Archive File Format Malformed

        # A general error had occurred
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to extract data from the compressed file due to a general error!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to extract data from the compressed file due to a general failure.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Compressed file that was extracted:`r`n" + `
                                        "`t`t" + $file + "`r`n" + `
                                        "`tOutput Directory:`r`n" + `
                                        "`t`t" + $outputPath + "`r`n" + `
                                        "`tExtracting Directory:`r`n" + `
                                        "`t`t" + $extractPath + "`r`n" + `
                                        [Logging]::GetExceptionInfo($_.Exception));

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


            # Update the Exit Code status because the operation had failed.
            $exitCode = $false;
        } # catch : Caught Error in Extract Task

        # Log the activity in the logfiles (if requested)
        finally
        {
            # Because there is information within the STDOUT container, we will convert it to a literal string.
            #  But because we are going to display the information to a logfile, ultimately, present the data in
            #  a readable form for the end-user to easily decipher the report.
            if ($null -ne $execSTDOUT)
            {
                # HEADER
                # - - - - - -
                # Logfile Header

                $strSTDOUT = ("Successfully extracted the archive data file named" + `
                                " $($fileNameExt).`r`n" + `
                                "Below is a list of files that had been extracted successfully from the archive file:`r`n" + `
                                "`r`n" + `
                                "-----------------------------------------------------------`r`n" + `
                                "`r`n");


                # BODY
                # - - - - - -
                # Logfile Body (List of files)

                foreach ($item in $execSTDOUT)
                {
                    # Append the information as a long list, but in a readable and presentable way.
                    $strSTDOUT = $strSTDOUT + `
                                    "`t>> $([string]$($item))`r`n";
                } # foreach : File in List


                # FOOTER
                # - - - - - -
                # Logfile Footer

                $strSTDOUT = ($strSTDOUT + `
                                "`r`n" + `
                                "-----------------------------------------------------------`r`n");
            } # if : STDOUT Contains Data



            # If there is information held within the STDERR container, then we will transform the
            #  data from an object to a literal string.
            if ($null -ne $execSTDERR)
            {
                # Because of how the information is stored in the object, we can just store the data to
                #  a literal string outright.
                $strSTDERR = [string]($execSTDERR);
            } # if : STDERR Contains Data


            # Create the logfiles as requested
            [CommonIO]::PSCMDLetLogging($this.GetLogPath(), `       # Log path for the STDOUT logfile.
                                        $this.GetLogPath(), `       # Log path for the STDERR logfile.
                                        $NULL, `                    # Report path and filename.
                                        $false, `                   # Is this a report?
                                        $false, `                   # Should we receive the STDOUT or STDERR for further processing?
                                        $execReason, `              # Reason for using the CMDLet.
                                        $null, `                    # Returned STDOUT\STDERR for further processing.
                                        [ref] $strSTDOUT, `         # STDOUT output from the CMDLet.
                                        [ref] $strSTDERR);          # STDERR output from the CMDLet.
        } # finally : Log the activity in the log files


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $exitCode;
    } # ExtractArchive()




   <# Create Archive File
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to create a new archive data file from scratch.
    #   Because of the design of this function, it only supports a bulk operation - but not
    #   appending updates to an already existing archive data file.  Thus, it is recommended
    #   to have a dedicated directory containing all the files and subdirectories we want
    #   to place into the archive data file and then proceed with the operation.
    #
    #  Compress Archive Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The requested name of the archive data file that is going to be created.
    #  [string] Output Path
    #   The output path to place the newly created archive file.
    #  [string] Target Directory
    #   The root of the directory that contains all of the data that we want to compact
    #    into a single archive data file.
    #   NOTE: This argument might contain wildcards, for example:
    #       D:\Users\Admin\Desktop\TopSecret\*.*
    #  [string] (REFERENCE) Archive File Path
    #   This will hold the newly created archive file's absolute path and file name.
    #    This will be returned to the calling function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = A failure occurred while creating the archive file.
    #    $true  = Successfully created the archive file.
    # -------------------------------
    #>
    [bool] CreateArchive([string] $archiveFileNameRequest, `    # The name of the archive that will be created
                        [string] $outputPath, `                 # The destination path of the archive file.
                        [string] $targetDirectory, `            # The directory we want to compact; may contain wildcards
                        [ref] $archivePath)                     # The full path of the archive file's location.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $execReason = $null;                               # Description; used for logging
        [string] $archiveFileExtension = "pk3";                     # This will hold the archive file's extension.
                                                                    #  NOTE: Because the ZipFile class only supports the Zip standard, and
                                                                    #   we are targeting the ZDoom engine, the extension will be fixated to
                                                                    #   the Zip file extension that is recognizable to the ZDoom engine.
                                                                    #   Thus, this variable will be set as 'PK3'.
        [string] $archiveFileName = $null;                          # This will hold the archive data file's full name, including the
                                                                    #  absolute path to access the file specifically.
        [string] $compressionLevel = "Optimal";                     # Specified Compression Level to be used when creating the compressed
                                                                    #   file.
        [bool] $exitCode = $false;                                  # The exit code status provided by the Compress-Archive operation
                                                                    #  status.  If the operation was successful, then true will be
                                                                    #  set.  Otherwise, it well be set as false to signify an error.
        [System.Object] $execSTDOUT = [System.Object]::new();       # This will hold the STDOUT that is provided by the CMDLet that
                                                                    #  will be used for compacting the archive file, but contained
                                                                    #  as an object.
        [System.Object] $execSTDERR = [System.Object]::new();       # This will hold the STDERR that is provided by the CMDLet that
                                                                    #  will be used for compacting the archive file, but contained
                                                                    #  as an object.
        [string] $strSTDOUT = $null;                                # This will hold the STDOUT information, but will be held as a
                                                                    #  literal string.  The information provided to it will be
                                                                    #  converted from an object to a string, the information held
                                                                    #  in this variable will be presented in the logfile.
        [string] $strSTDERR = $null;                                # This will hold the STDERR information, but will be held as a
                                                                    #  literal string.  The information provided to it will be
                                                                    #  converted from an object to a string, the information held
                                                                    #  in this variable will be presented in the logfile.
        # ----------------------------------------


        # SETUP THE ENVIRONMENT
        # - - - - - - - - - - - - - -
        # Make sure that the environment is ready before we proceed by initializing any variables that need to be
        #  configured before we proceed any further during the compacting procedure protocol.
        # ---------------------------
        # The description that will be presented in the logfile.
        $execReason = "Creating " + $archiveFileNameRequest;

        # Generate the full path of the archive data file, though this may change later if it is not unique.
        #  NOTE: Omitting the file extension.
        $archiveFileName = "$($outputPath)\$($archiveFileNameRequest)";

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the logging requirements are met.
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to create a new compress file:`r`n " + `
                                            "`t" + $archiveFileNameRequest + "`r`n" + `
                                            "The Log directories could not be created!`r`n" + `
                                            "Please make sure that your have sufficient privileges to create directories in:`r`n" + `
                                            "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_);

            # Generate the initial message
            [string] $logMessage = "Unable to create a new compressed file because the log directories could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the log directories for the Archive Zip could not be created, " + `
                                            "nothing can be logged as required.`r`n" + `
                                        "`tTried to create directories in:`r`n" + `
                                        "`t`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_ + "`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required log directories are created.`r`n" + `
                                        "`t`t- Make sure that you have sufficient permissions to create directories.`r`n" + `
                                        "`tTried to create Compress File:`r`n" + `
                                        "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                        "`tPath of the contents to compact:`r`n" + `
                                        "`t`t" + $targetDirectory);

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


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that the current PowerShell instance has the Archive functionality ready for use.
        if ($this.DetectCompressModule() -eq $false)
        {
            # Because this current PowerShell instance lacks the functionality required to create the
            #  archive datafile, we cannot proceed any further.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to create a new compressed file:`r`n" + `
                                            "`t" + $archiveFileNameRequest + "`r`n" + `
                                            "The PowerShell Module, " + $this.GetPowerShellModuleName() + `
                                                ", was not detected!`r`n" + `
                                            "Because the PowerShell Module was not found, it is not possible " + `
                                                "to create a new compress file!");

            # Generate the initial message
            [string] $logMessage = ("Unable to create a new compress file because the required PowerShell Module, " + `
                                    $this.GetPowerShellModuleName() + ", was not found!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have the latest version of PowerShell Core installed.`r`n" + `
                                        "`tRequired PowerShell Module:`r`n" + `
                                        "`t`t" + $this.GetPowerShellModuleName() + "`r`n" + `
                                        "`tTried to create Compress File:`r`n" + `
                                        "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                        "`tPath of the contents to compact:`r`n" + `
                                        "`t`t" + $targetDirectory);

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


            # Because the required module was not found, we cannot proceed any further.
            return $false;
        } # if : PowerShell Archive Support Missing


        # Make sure that the desired output path currently exists
        if ([CommonIO]::CheckPathExists($outputPath, $true) -eq $false)
        {
            # The requested output path does not currently exist; we cannot proceed any further.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to create a new compress file:`r`n" + `
                                            "`t" + $archiveFileNameRequest + "`r`n" + `
                                            "The path to store the compressed file is not correct`r`n" + `
                                            "The path given to output the compressed file:`r`n" + `
                                            "`t" + $outputPath);

            # Generate the initial message
            [string] $logMessage = "Unable to create a new compress file because the output directory does not exist!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The Archive Data File to Create:`r`n" + `
                                            "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                            "`tOutput Path to Place the Compressed File:`r`n" + `
                                            "`t`t" + $outputPath);

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


            # The output path does not exist; we cannot extract the contents.
            return $false;
        } # if : Output Directory does not exist


        # Check to make sure that the target path directory or file(s) already exists within the filesystem.
        if ([CommonIO]::CheckPathExists($targetDirectory, $false) -eq $false)
        {
            # The target directory does not exist; we cannot compact the requested data as the target directory
            #  does not exist with the given path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to create a new compress file:`r`n" + `
                                            "`t" + $archiveFileNameRequest + "`r`n" + `
                                            "The path to the files that are to be compressed is not correct.`r`n" + `
                                            "The path given for the contents that are to be compacted:`r`n" + `
                                            "`t" + $targetDirectory);

            # Generate the initial message
            [string] $logMessage = "Unable to create a new compress file because the target directory path does not exist!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The Archive Data File to Create:`r`n" + `
                                            "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                            "`tTarget Directory Path to Compress:`t`n" + `
                                            "`t`t" + $targetDirectory);

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


            # Return a failure as the target directory does not exist.
            return $false;
        } # if : Target Directory does not Exist

        # ---------------------------
        # - - - - - - - - - - - - - -



        # DETERMINE ARCHIVE FILE NAME
        # - - - - - - - - - - - - - -
        # We will need to determine a unique file name of the archive data file.  If the original name given is not sufficient,
        #  if some other file has the same name in the output directory, then we will merely apply a timestamp to help make it unique.
        # ---------------------------


        # If the full path is not unique, try to make it unique.
        if ([CommonIO]::CheckPathExists("$($archiveFileName).$($archiveFileExtension)", $true) -eq $true)
        {
            # Because the filename already exists within the given output path, we can make it unique by adding in a timestamp
            #  to the filename.  However, in case we cannot make the filename unique (even with the timestamp), then the
            #  operation must be aborted.


            # Setup the timestamp to help make it unique.
            #  Formatting of the Date and Time:
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            [string] $getDateTime = [string](Get-Date -UFormat "%d-%b-%Y_%H-%M-%S");

            # Update the archive filename to include the date and time stamp.
            $archiveFileName = "$($archiveFileName)_$($getDateTime)";

            # Check to make sure that the new filename is unique, if not - then we cannot proceed.
            if ([CommonIO]::CheckPathExists("$($archiveFileName).$($archiveFileExtension)", $true) -eq $true)
            {
                # Because the archive file name is still not unique enough, we cannot proceed anymore.
                #  This function will have to be aborted.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                    # Prep a message to display to the user for this error; temporary variable.
                    [string] $displayErrorMessage = ("Unable to create a new compress file:`r`n" + `
                                                    "`t" + $archiveFileNameRequest + "`r`n" + `
                                                    "It was not possible to create a unique filename for the compress file.`r`n" + `
                                                    "The path given to output the compressed file:`r`n" + `
                                                    "`t" + $outputPath);

                    # Generate the initial message
                    [string] $logMessage = "Unable to create a new compress file because the filename of the compress file could not be unique!";

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = ("The Archive Data File to Create:`r`n" + `
                                                "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                                "`tOutput Path to Place the Compressed File:`r`n" + `
                                                "`t`t" + $outputPath);

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


                # Return an error.
                return $false;
            } # INNER-IF: Unable to make it unique
        } # If: File Already Exists at Path


        # Now save the output path to our reference (pointer) variable, this will allow the calling function to get the absolute path of
        #  where the archive file resides.



        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the archive file resides.
        #  Thus, the calling function can bring the new archive file to the user's
        #  attention using whatever methods necessary.
        $archivePath.Value = "$($archiveFileName).$($archiveFileExtension)";


        # ---------------------------
        # - - - - - - - - - - - - - -



        # CREATE ARCHIVE DATAFILE
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Execute the Compress-Archive CMDLet
        try
        {
            # Create the archive datafile.
            Compress-Archive -Path "$($targetDirectory)\*" `
                             -DestinationPath "$($archiveFileName).$($archiveFileExtension)" `
                             -CompressionLevel $compressionLevel `
                             -ErrorAction Stop `
                             -PassThru `
                             -OutVariable execSTDOUT `
                             -ErrorVariable execSTDERR;

            # Update the Exit Code status; the operation was successful.
            $exitCode = $true;
        } # try : Execute Compression Task

        # An error occurred; the data is too large to compact
        catch [System.OutOfMemoryException]
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Failed to create a new compressed file because there was not enough system memory!`r`n" + `
                                            [Logging]::GetExceptionInfoShort($_.Exception));

            # Generate the initial message
            [string] $logMessage = "Failed to create a new archive datafile due to memory constraints!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The Archive Data File to Create:`r`n" + `
                                            "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                            "The path given for the contents that are to be compacted:`r`n" + `
                                            "`t" + $targetDirectory + "`r`n" + `
                                            "`tOutput Path to Place the Compressed File:`r`n" + `
                                            "`t`t" + $outputPath + "`r`n" + `
                                            "`tThe full path to the archive data file:`r`n" + `
                                            "`t`t" + $archiveFileName + "." + $archiveFileExtension + "`r`n" + `
                                            [Logging]::GetExceptionInfo($_.Exception));

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


            # Because a failure had been reached, we will have to update the exit code.
            $exitCode = $false;
        } # Catch [OutOfMemory] : File(s) too large

        # A general error had occurred
        catch
        {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Prep a message to display to the user for this error; temporary variable
                [string] $displayErrorMessage = ("Failed to create a new compressed file!`r`n" + `
                                                "$([Logging]::GetExceptionInfoShort($_.Exception))");

                # Generate the initial message
                [string] $logMessage = "Failed to create a new archive datafile!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The Archive Data File to Create:`r`n" + `
                                                "`t`t" + $archiveFileNameRequest + "`r`n" + `
                                                "The path given for the contents that are to be compacted:`r`n" + `
                                                "`t" + $targetDirectory + "`r`n" + `
                                                "`tOutput Path to Place the Compressed File:`r`n" + `
                                                "`t`t" + $outputPath + "`r`n" + `
                                                "`tThe full path to the archive data file:`r`n" + `
                                                "`t`t" + $archiveFileName + "." + $archiveFileExtension + "`r`n" + `
                                                [Logging]::GetExceptionInfo($_.Exception));

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

            # Update the Exit Code status; the operation failed.
            $exitCode = $false;
        } # catch : Caught Error in Compression Task

        # Log the activity in the logfiles (if requested)
        finally
        {
            # If the STDOUT contains the file path of the archive datafile,
            #  then we will store it for logging purposes.
            if (![CommonIO]::IsStringEmpty($execSTDOUT))
            {
                # Because we only created just one compressed datafile, we
                #  will only have one output file - not multiple.  With that,
                #  we just need to capture just the one output file - which is
                #  our compressed archive datafile.
                $strSTDOUT = "Newly created archive datafile path: " + [string]($execSTDOUT);
            } # if : STDOUT Is not null



            # If the STDERR contains information, then store
            #  it as a standard string datatype.  Luckily the
            #  information provided within the object requires
            #  no real changes or data manipulation, we can
            #  just cast it and it works like magic!  I love
            #  the simplicity!
            if ($null -ne $execSTDERR)
            {
                # No need to filter or manipulate the data, just
                #  cast it as is.  Everything we need is already
                #  available and readable.
                $strSTDERR = [string]($execSTDERR);
            } # if : STDERR Is not null


            # Create the logfiles
            [CommonIO]::PSCMDLetLogging($this.GetLogPath(), `
                                        $this.GetLogPath(), `
                                        $NULL, `
                                        $false, `
                                        $false, `
                                        $execReason, `
                                        $null, `
                                        [ref] $strSTDOUT, `
                                        [ref] $strSTDERR );
        } # finally : Log the activity in the log files



        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $exitCode;
    } # CreateArchive()

    #endregion





    #region File Management

   <# Thrash Logs
    # -------------------------------
    # Documentation:
    #  This function will expunge any log files that were generated by this object.
    #   Such files are only removed, by this function, if their extensions are known within
    #   this function.  For example, if a file extension known in this function is '*.txt'
    #   and '*.docx', only those files will be removed from the logging directories.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more operations failed.
    #   $true = Successfully expunged the files.
    #           OR
    #           Log directories were not found.
    # -------------------------------
    #>
    [bool] ThrashLogs()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $extLogs = @('*.err', '*.out');      # Array of log extensions
        [string] $knownExtensions = $null;              # This will hold a nice string value of all of
                                                        #  the extensions that this function will remove;
                                                        #  extensions being: $extLogs and $extReports combined.
                                                        #  This is primarily used for logging purposes.
        [bool] $exitCode = $true;                       # The exit code status provided by the log\report
                                                        #  deletion operation status.  If the operation
                                                        #  was successful then true will be set, otherwise
                                                        #  it'll be false to signify an error.
        # ----------------------------------------


        # Before we start, setup the known extensions variable for logging purposes.
        #  Get all of the known extensions used for logging; $extLogs
        foreach ($item in $extLogs)
        {
            # if this is the first entry in the variable, then just apply the item
            #  to the string without adding a appending the previous entries.
            if ([CommonIO]::IsStringEmpty($knownExtensions))
            {
                # First entry to the string.
                $knownExtensions = $item;
            }# If: first entry

            # There is already information in the variable, append the new entry to the
            #  previous data.
            else
            {
                # Append the entry to the string list.
                $knownExtensions += "," + $item;
            } # Else: Append entry
        } # Foreach: Known Logging Extensions


        # Make sure that the logging directories exist.  If the directories are not
        #  available presently, than there is nothing that can be done at this time.
        if ($this.__CheckRequiredDirectories() -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to delete the requested files as the logging directories were not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: ArchiveZip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *



            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            return $true;
        } # IF : Required Directories Exists


        # Because the directories exists - let's try to thrash the logs.
        if([CommonIO]::DeleteFile($this.GetLogPath(), $extLogs, $false) -eq $false)
        {
            # Reached a failure upon removing the requested log files.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while removing the requested log files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: ArchiveZip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the operation failed, we will update the exit code to 'false'
            #  to signify that we reached an error.
            $exitCode = $false;
        } # If : failure to delete files


        # ----


        # If everything succeeded, provide this information to the logfile.
        if ($exitCode)
        {
            # The operation was successful, provide the information to the logfile.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully expunged the requested files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: ArchiveZip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # If: Everything was Successful


        # If we made it here, then everything went okay!
        return $exitCode;
    } # ThrashLogs()

    #endregion
    #endregion
} # ArchiveZip