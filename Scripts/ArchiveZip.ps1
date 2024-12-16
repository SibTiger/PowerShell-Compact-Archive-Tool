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




    # Get the instance of this singleton object (With Args)
    static [ArchiveZip] GetInstance([CompressionLevel] $compressionLevel, ` # Compression Level
                                    [bool] $verifyBuild)                    # Verify Archive datafile
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [ArchiveZip]::_instance)
        {
            # Create a new instance of the singleton object.
            [ArchiveZip]::_instance = [ArchiveZip]::new($compressionLevel, `
                                                        $verifyBuild);
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [ArchiveZip]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Hidden Variables

    # Compression Level
    # ---------------
    # The compression level specified when compacting data into an archive datafile.
    Hidden [CompressionLevel] $__compressionLevel;


    # Verify Build
    # ---------------
    # Test the archive datafile to ensure that it is not corrupted.
    Hidden [bool] $__verifyBuild;


    # Log Root
    # ---------------
    # The main parent directory's absolute path that will hold this object's logs directory.
    Hidden [string] $__rootLogPath = "$($global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_)\PSArchive";


    # Log Root Path
    # ---------------
    # This directory, in absolute form, will hold logfiles that were generated
    #  from this object when creating, verifying, extracting, and listing
    #  contents from within an archive datafile.
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
    ArchiveZip()
    {
        # Compression Level
        $this.__compressionLevel = [CompressionLevel]::Fastest;

        # Verify Build
        $this.__verifyBuild = $true;
    } # Default Constructor




    # User Preference : On-Load
    ArchiveZip([CompressionLevel] $compressionLevel, `
                    [bool] $verifyBuild)
    {
        # Compression Level
        $this.__compressionLevel = $compressionLevel;

        # Verify Build
        $this.__verifyBuild = $verifyBuild;
    } # User Preference Constructor

    #endregion



    #region Getter Functions

   <# Get Compression Level
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compression Level' variable.
    # -------------------------------
    # Output:
    #  [CompressionLevel] Compression Level
    #   The value of the 'Compression Level'.
    # -------------------------------
    #>
    [CompressionLevel] GetCompressionLevel() { return $this.__compressionLevel; }




   <# Get Verify Build
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Verify Build' variable.
    # -------------------------------
    # Output:
    #  [bool] Verify Build
    #   The value of the 'Verify Build'.
    # -------------------------------
    #>
    [bool] GetVerifyBuild() { return $this.__verifyBuild; }




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



    #region Setter Functions

   <# Set Compression Level
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compression Level' variable.
    # -------------------------------
    # Input:
    #  [CompressionLevel] Compression Level
    #   The desired compression level for compacting data into the archive datafile.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionLevel([CompressionLevel] $newVal)
    {
        # Because the value must fit within the 'CompressionLevel'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__compressionLevel = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionLevel()




   <# Set Verify Build
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Verify Build' variable.
    # -------------------------------
    # Input:
    #  [bool] Verify Archive
    #   When true, allow the possibility to test the archive datafile's
    #    integrity.  Otherwise, when false, do not examine the archive
    #    file for potential errors.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVerifyBuild([bool] $newVal)
    {
        # Because the value must be either true or false, there really
        #  is no point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__verifyBuild = $newVal;

        # Successfully updated.
        return $true;
    } # SetVerifyBuild()

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
        # Determine if the PowerShell Module is presently available within the environment.
        if ([CommonPowerShell]::DetectModule($this.GetPowerShellModuleName()))
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




   <# Show About
    # -------------------------------
    # Documentation:
    #   This function will provide the 'About' information about this PowerShell Module and
    #   present it to the user.  The about information shown to the user will contain as much
    #   meta data as possible, if any present, that is related to the PowerShell Module.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true = Successfully retrieved About Information
    #   $false = Unable to retrieve any useful About information
    # -------------------------------
    #>
    [bool] ShowAbout()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will be used to collect the PowerShell Module's meta data.
        [PowerShellModuleMetaData] $aboutInfo = [PowerShellModuleMetaData]::new();

        # This is the about string that will be presented to the user.
        [string] $aboutString = $NULL;

        # A quick 'Double Space' macro.
        [string] $dbs = "`r`n`r`n";
        # ----------------------------------------



        # Determine if it is possible to obtain the meta data for this PowerShell Module.
        #   If we cannot get the meta data, than return an error.
        if (![CommonPowerShell]::GetModuleMetaData($this.GetPowerShellModuleName(), `
                                                    [ref] $aboutInfo))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to show the PowerShell Module About information!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("There was no Meta Data Information available for the PowerShell Module!`r`n" + `
                                            "`tPowerShell Module Name: " + $this.GetPowerShellModuleName());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Unable to obtain any About Info. data.
            return $false;
        } # if : Unable to Get Meta Data



        # Construct the string, that we will present to the user, with the data
        #   that we had just obtained.
        # To do this properly, we will only append information to the string - if
        #   the data is available within the field.  Otherwise, if nothing is available,
        #   than the missing information will not be included into the string.
        if ([CommonIO]::IsStringEmpty($aboutInfo.Author) -ne $true)
        { $aboutString += "Author:`r`n`t" + $aboutInfo.Author + $dbs; }

        if ([CommonIO]::IsStringEmpty($aboutInfo.Name) -ne $true)
        { $aboutString += "PowerShell Module Name:`r`n`t" + $aboutInfo.Name + $dbs; }

        if ([CommonIO]::IsStringEmpty($aboutInfo.Version) -ne $true)
        { $aboutString += "PowerShell Module Version:`r`n`t" + $aboutInfo.Version + $dbs; }

        if ([CommonIO]::IsStringEmpty($aboutInfo.Copyright) -ne $true)
        { $aboutString += "Copyright:`r`n`t" + $aboutInfo.Copyright + $dbs; }

        if ([CommonIO]::IsStringEmpty($aboutInfo.ProjectURI) -ne $true)
        { $aboutString += "Webpage:`r`n`t" + $aboutInfo.ProjectURI + $dbs; }

        if ([CommonIO]::IsStringEmpty($aboutInfo.Description) -ne $true)
        {
            $aboutString += ("Description:`r`n" + `
                    "`t" + $aboutInfo.Description + $dbs);
        } # if : Append Description

        if ([CommonIO]::IsStringEmpty($aboutInfo.ReleaseNotes)  -ne $true)
        {
            $aboutString += ("Release Notes:`r`n" + `
                    "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n" + `
                    "`r`n" + `
                    $aboutInfo.ReleaseNotes + `
                    "`r`n" + `
                    "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n");
        } # if : Append Release Notes



        # If incase /nothing/ was collected, alert the user that we couldn't generate any
        #   useful information regarding the PowerShell Module.
        if ([CommonIO]::IsStringEmpty($aboutString))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to show the PowerShell Module About information!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("There was no useful Meta Data Information available for:`r`n" + `
                                            "`t`t" + $this.GetPowerShellModuleName() + "`r`n" + `
                                            "`r`n" + `
                                            "`tAbout String that was Collected:`r`n" + `
                                            "=====================================================`r`n" + `
                                            "`r`n" + `
                                            $aboutString + "`r`n" + `
                                            "`r`n" + `
                                            "=====================================================");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Nothing of use was collected.
            return $false;
        } # if : About String is Empty



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully created the About Information string!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("PowerShell Module Full Name:`r`n" + `
                                        "`t`t" + $this.GetPowerShellModuleName() + "`r`n" + `
                                        "`tThe About Information that was Collected:`r`n" + `
                                        "`t`t - Author:         " + $aboutInfo.Author       + "`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.Author) + "`r`n" + `
                                        "`t`t - Module Name:    " + $aboutInfo.Name         + "`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.Name) + "`r`n" + `
                                        "`t`t - Module Version: " + $aboutInfo.Version      + "`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.Version) + "`r`n" + `
                                        "`t`t - Copyright:      " + $aboutInfo.Copyright    + "`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.Copyright) + "`r`n" + `
                                        "`t`t - Project URI:    " + $aboutInfo.ProjectURI   + "`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.ProjectURI) + "`r`n" + `
                                        "`t`t - Description:`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.Description) + "`r`n" + `
                                        "= - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - `r`n" + `
                                        "`r`n" + `
                                        $aboutInfo.description + "`r`n" + `
                                        "`r`n" + `
                                        "= - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - `r`n" + `
                                        "`t`t - Release Notes:`r`n" + `
                                        "`t`t`tString was empty?  " + [CommonIO]::IsStringEmpty($aboutInfo.ReleaseNotes) + "`r`n" + `
                                        "= - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - `r`n" + `
                                        "`r`n" + `
                                        $aboutInfo.ReleaseNotes + "`r`n" + `
                                        "`r`n" + `
                                        "= - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - `r`n" + `
                                        "`r`n" + `
                                        "`r`n" + `
                                        "About String that was Generated:`r`n" + `
                                        "----------------------------------`r`n" + `
                                        $aboutString);

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Show the information we had gathered to the user.
        [Logging]::DisplayMessage($aboutString);



        # Finished
        return $true;
    } # ShowAbout()



    #region Inspect Archive


   <# Verify Archive
    # -------------------------------
    # Documentation:
    #  This function will test the archive data file by making sure that all of
    #   the contents within the compressed file are not corrupted.  If the
    #   source files within the archive data file are corrupted then the test
    #   will fail - as the integrity of the archive file had been compromised.
    #
    # Developer Note:
    #  Because the PowerShell Module that we use to perform this operation, at
    #   least by the time of writing this, does not have a explicit function to
    #   'verify' the archive data file itself, we will have to improvise our own
    #   way of performing the validation process.  Searching for how others
    #   tackled this limitation, the best course of action is to extract all of
    #   the data from the compressed file.  We will extract the data into a
    #   temporary location - which will be removed after the verification had
    #   finished.  Please keep in mind that this operation, unfortunately,
    #   requires a lot resources to extract the files to a destination.  This
    #   is where I really wish this PowerShell Module had the ability to verify
    #   a compressed zip file, like 7Zip.
    #  Further researching, others had suggested to obtain a list of files
    #   that are present within the archive data file.  The intention of that
    #   operation is by forcing the bit-stream check of the compressed file
    #   to obtain the list of files.  However, I had quickly noticed that I
    #   was able to achieve a false-positive with a corrupted archive file by
    #   manipulating the bytes of the compressed file by using a Hex Editor tool,
    #   HxD.  With that reason alone, I will not 'list' files that are in the
    #   archive data file.
    #
    # Extract Information:
    #    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/Expand-Archive
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The archive data file, in absolute path form, that will be verified.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Archive file failed the verification process.
    #              Some files or the archive file itself is corrupted.
    #    $true = Archive file passed the verification process.
    # -------------------------------
    #>
    [bool] VerifyArchive([string] $targetFile)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $tmpDirectory = $null;                                     # This will be used to hold the path of the temporary directory,
                                                                            #  which will be used to extract the data from the archive file.
        [bool] $testResult = $true;                                         # This will hold our test result; was the operation successful
                                                                            #  or did something go horribly wrong?
        [string] $targetFileName = [string]((Get-Item $targetFile).Name);   # This will hold the archive file name which will be presented in
                                                                            #  the logfile.
        [string] $execReason = "Verifying " + $targetFileName;              # This will hold the description of the operation that is being
                                                                            #  performed in this function, but only presented for logging
                                                                            #  purposes.
        [System.Object] $execSTDOUT = [System.Object]::new();               # This will hold the STDOUT that is provided by the CMDLet that
                                                                            #  will be used for the verification process, but contained as
                                                                            #  an object.
        [System.Object] $execSTDERR = [System.Object]::new();               # This will hold the STDERR that is provided by the CMDLet that
                                                                            #  will be used for the verification process, but contained as
                                                                            #  an object.
        [string] $strSTDOUT = $null;                                        # This will hold the STDOUT information, but will be held as a
                                                                            #  literal string.  The information provided to it will be
                                                                            #  converted from an object to a string, the information held in
                                                                            #  this variable will be presented in the logfile.
        [string] $strSTDERR = $null;                                        # This will hold the STDERR information, but will be held as a
                                                                            #  literal string.  The information provided to it will be
                                                                            #  converted from an object to a string, the information held in
                                                                            #  this variable will be presented in the logfile.
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them.
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
            [string] $displayErrorMessage = ("Unable to verify the compressed file:`r`n" + `
                                            "`t`t" + $targetFileName + "`r`n" + `
                                            "The Log directories could not be created!`r`n" + `
                                            "Please make sure that you have sufficient privileges to create directories in:`r`n" + `
                                            "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_);

            # Generate the initial message
            [string] $logMessage = "Unable to verify the compressed file because the log directories could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the log directories for the Archive Zip could not be created, " + `
                                            "nothing can be logged as required.`r`n" + `
                                        "Tried to create directories in:`r`n" + `
                                        "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_ + "`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required log directories are created.`r`n" + `
                                        "`t`t- Make sure that you have sufficient permissions to create directories.`r`n" + `
                                        "`tRequested file to verify: $($targetFile)");

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
            [string] $displayErrorMessage = ("Unable to verify the compressed file:`r`n" + `
                                            "`t`t" + $targetFileName + "`r`n" + `
                                            "The PowerShell Module, " + $this.GetPowerShellModuleName() + `
                                                ", was not detected!`r`n" + `
                                            "Because the PowerShell Module was not found, it is not possible " + `
                                                "to perform the validation operation!");

            # Generate the initial message
            [string] $logMessage = ("Unable to verify the compressed file; unable to find the required PowerShell Module, " + `
                                        $this.GetPowerShellModuleName() + "!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have the latest version of PowerShell Core installed.`r`n" + `
                                        "`tRequired PowerShell Module: " + $this.GetPowerShellModuleName() + "`r`n" + `
                                        "`tRequested file to verify: $($targetFile)" + `
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


        # Make sure that the target archive file exists.
        if ([CommonIO]::CheckPathExists($targetFile, $true) -eq $false)
        {
            # The target archive data file does not exist with the provided path;
            #   We will not be able to perform the validation operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to verify the compressed file:`r`n" + `
                                            "`t`t" + $targetFileName + "`r`n" + `
                                            "The path to the compressed file is not correct.`r`n" + `
                                            "The path given to the compressed file:`r`n" + `
                                            "`t" + $targetFile);

            # Generate the initial message
            [string] $logMessage = "Unable to verify the compressed file because the path was not correct!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Requested file to verify: " + $targetFile;

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


            # Return a failure as the target file does not exist.
            return $false;
        } # if : Target Archive File does not Exist

        # ---------------------------
        # - - - - - - - - - - - - - -



        # To verify the archive data file, we will need to extract all of the contents into a temporary
        #  directory.  With that, we must first create a temporary directory.
        #  We will also obtain the temporary directory's full path by using a reference.
        if ([CommonIO]::MakeTempDirectory("Verify", [ref] $tmpDirectory) -eq $false)
        {
            # Because the temporary directory could not be created, we cannot continue any further.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Unable to verify the compressed file:`r`n" + `
                                            "`t" + $targetFileName + "`r`n" + `
                                            "Tried to create a temporary directory to perform the validation " + `
                                                "process, however the temporary directory could not be created!");

            # Generate the initial message
            [string] $logMessage = "Unable to verify the archive data file because the temporary directory could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested file to verify: $($targetFile)`r`n" + `
                                        "`tTemporary Directory: $($tmpDirectory)");

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


            # Because the temporary directory could not be created, we cannot proceed any further.
            return $false;
        } # if : Failure Creating the Temporary Directory


        # Try to test the archive file by extracting all of the data from the target file to the temporary directory.
        try
        {
            # Extract all of the contents
            Expand-Archive -LiteralPath $targetFile `
                           -DestinationPath $tmpDirectory `
                           -ErrorAction Stop `
                           -PassThru `
                           -OutVariable execSTDOUT `
                           -ErrorVariable execSTDERR;
        } # Try : Extract Archive Data File

        # An error occurred; a file, within the archive, might have been corrupted or missing.
        catch [System.Management.Automation.ItemNotFoundException]
        {
            # Obtain the file name that is either corrupted or missing from the archive datafile.
            [string] $badFileName = Split-Path -Path "$([string]($_.TargetObject))" -Leaf;

            # Obtain the full file path that is either corrupted or missing from the archive datafile.
            [string] $badFileNameFull = [string]($_.TargetObject);


            # Because a failure had been reached, update the exit code to signify that an issue had occurred.
            $testResult = $false;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("The file named '$($badFileName)' was not found in the compressed file: " + `
                                                "$($targetFileName)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = ("Verification process had failed; the file '$($badFileName)' was not found within the " + `
                                    "compressed file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("File that is missing or corrupted: $($badFileNameFull)`r`n" + `
                                        "`tRequested file to verify: $($targetFile)`r`n" + `
                                        "`tTemporary Directory: $($tmpDirectory)`r`n" + `
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
        } # Catch [ItemNotFound] : File Not Found

        # An error occurred; the archive data file's format is malformed
        catch [System.IO.FileFormatException]
        {
            # Because a failure had been reached, update the exit code to signify that an issue had occurred.
            $testResult = $false;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("The compressed file '$($targetFileName)' may not be a valid archive file " + `
                                            "structure.`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Verification process had failed; the compressed file structure is damaged.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested file to verify: $($targetFile)`r`n" + `
                                        "`tTemporary Directory: $($tmpDirectory)`r`n" + `
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
        } # Catch [FileFormat] : Archive File Format Malformed

        # A general error occurred while testing the archive file.
        catch
        {
            # A failure occurred while extracting the contents, we will assume that the archive file
            #   is corrupted or damaged.
            $testResult = $false;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("A general failure occurred while trying to verify the compressed file!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = ("Verification process had failed; A general failure occurred while extracting files " + `
                                    "from the compressed file.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested file to verify: $($targetFile)`r`n" + `
                                        "`tTemporary Directory: $($tmpDirectory)`r`n" + `
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
        } # Catch : General Failure while Verifying Archive

        # Delete the temporary directory and all data within it.
        finally
        {
            # Delete the temporary directory, we no longer need it.
            [CommonIO]::DeleteDirectory($tmpDirectory) | Out-Null;
        } # Finally : Delete Temporary Directory



        # Logging Section
        # =================
        # - - - - - - - - -


        # If there is information held in the STDOUT container, then we will convert the data from an array-list
        #  to a literal string.
        if (![CommonIO]::IsStringEmpty($execSTDOUT))
        {
            # Because there is information within the STDOUT container, we will convert it to a literal string.
            #  But because we are going to display the information to a logfile, ultimately, present the data in
            #  a readable form for the end-user to easily decipher the report.


            # HEADER
            # - - - - - -
            # Logfile Header

            $strSTDOUT = ("Successfully verified the archive data file, $($targetFileName).`r`n" + `
                            "Below is a list of files that resides within the archive file and that has been tested:`r`n" + `
                            "`r`n" + `
                            "-----------------------------------------------------------`r`n" + `
                            "`r`n");


            # BODY
            # - - - - - -
            # Logfile Body (List of files)

            foreach ($item in $execSTDOUT)
            {
                $strSTDOUT = ($strSTDOUT + `
                                "`t>> $([string]$($item))`r`n");
            } # foreach : File in List


            # FOOTER
            # - - - - - -
            # Logfile Footer

            $strSTDOUT = ($strSTDOUT + `
                            "`r`n" + `
                            "-----------------------------------------------------------`r`n");
        } # if : STDOUT Contains Data



        # If there is information held in the STDERR container, then we will transform the data from an object
        #  to a literal string.
        if (![CommonIO]::IsStringEmpty($execSTDERR))
        {
            # Because of how the information is stored in the object, we can just store the data to a literal
            #  string outright.
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
                                    [ref] $strSTDERR );         # STDERR output from the CMDLet.


        # - - - - - - - - -
        # =================



        # Return the results to the calling function
        return $testResult;
    } # VerifyArchive()

    #endregion



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
                                            "`t" + $fileName + "`r`n" + `
                                            "The Log directories could not be created!`r`n" + `
                                            "Please make sure that you have sufficient privileges to create directories in:`r`n" + `
                                            "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_);

            # Generate the initial message
            [string] $logMessage = "Unable to extract data from the compressed file because the log directories could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the log directories for the Archive Zip could not be created, " + `
                                            "nothing can be logged as required.`r`n" + `
                                        "Tried to create directories in:`r`n" + `
                                        "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_ + "`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required log directories are created.`r`n" + `
                                        "`t`t- Make sure that you have sufficient permissions to create directories.`r`n" + `
                                        "`tTried to Extract from the Compressed File: $($fileName)`r`n" + `
                                        "`tPath to the Archive Data File:`r`n" + `
                                        "`t" + $file);

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
                                            "`t" + $fileName + "`r`n" + `
                                            "The PowerShell Module, " + $this.GetPowerShellModuleName() + `
                                                ", was not detected!`r`n" + `
                                            "Because the PowerShell Module was not found, it is not possible " + `
                                                "to extract data from a compressed file!");

            # Generate the initial message
            [string] $logMessage = ("Unable to extract data from the compressed file because the required PowerShell Module, " + `
                                        $this.GetPowerShellModuleName() + ", was not found!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have the latest version of PowerShell Core installed.`r`n" + `
                                        "`tRequired PowerShell Module: " + $this.GetPowerShellModuleName() + "`r`n" + `
                                        "`tTried to Extract from the Compressed File: $($fileName)`r`n" + `
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
                                            "`t" + $fileName + "`r`n" + `
                                            "The path to the compressed file is not correct.`r`n" + `
                                            "The path given to the compressed file:`r`n" + `
                                            "`t" + $file + "`r`n" + `
                                            "The output path given was:`r`n" + `
                                            "`t" + $outputPath);

            # Generate the initial message
            [string] $logMessage = "Unable to extract data from the compressed file because the output path was not correct!";

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
                                            "`t" + $fileName + "`r`n" + `
                                            "The output path was not correct.`r`n" + `
                                            "The output path given was:`r`n" + `
                                            "`t" + $outputPath);

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file because the output directory could not be found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive file to extract: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)");

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
                                            "`t" + $fileName + "`r`n" + `
                                            "It was not possible to create the output directory as needed.`r`n" + `
                                            "Output Directory Path:`r`n" + `
                                            "`t" + $extractPath);

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file because the extracting directory could not be created!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive file to extract: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tExtracting Directory: $($extractPath)");

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
            [string] $logMessage = "Successfully extracted the archive file!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive file that was extracted: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tExtracting Directory: $($extractPath)");

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
            [string] $logMessage = ("Failed to extract the archive data file; the file with a name of '$($badFileName)' was" + `
                                    " not found in the archive data file!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("File that is missing or corrupted: $($badFileNameFull)`r`n" + `
                                        "`tArchive file that was extracted: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tExtracting Directory: $($extractPath)`r`n" + `
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
            [string] $displayErrorMessage = ("The archive data file '$($fileNameExt)' may not be a valid archive file " + `
                                            "structure.`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to extract the archive data file; the archive data file structure is malformed.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive file that was extracted: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tExtracting Directory: $($extractPath)`r`n" + `
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


        } # Catch [FileFormat] : Archive File Format Malformed

        # A general error had occurred
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to extract the requested archive data file!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to extract the archive data file.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive file that was extracted: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tExtracting Directory: $($extractPath)`r`n" + `
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
            [string] $displayErrorMessage = ("Unable to create a new compress file, " + $archiveFileNameRequest + ", " + `
                                            "because the log directories could not be created!`r`n" + `
                                            "Please make sure that you have sufficient privileges to create directories in:`r`n" + `
                                            "`t" + $global:_PROGRAMDATA_LOCAL_PROGRAM_LOGS_PATH_);

            # Generate the initial message
            [string] $logMessage = "Unable to create a new archive file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for the Archive Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tRequested archive file to create: $($archiveFileNameRequest)`r`n" + `
                                        "`tContents to compact: $($targetDirectory)`r`n" + `
                                        "`tOutput directory: $($outputPath)");

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
            [string] $displayErrorMessage = ("Unable to create a new compress file, " + $archiveFileNameRequest + ", " + `
                                            "because the PowerShell Module, " + $this.GetPowerShellModuleName() + `
                                                ", was not detected!`r`n" + `
                                            "Because the PowerShell Module was not found, it is not possible " + `
                                                "to create the compressed file!");

            # Generate the initial message
            [string] $logMessage = "Unable to create a new archive data file; unable to find the required module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Be sure that you have the latest dotNET Core and PowerShell Core available.`r`n" + `
                                        "`tRequested archive file to create: $($archiveFileNameRequest)`r`n" + `
                                        "`tContents to compact: $($targetDirectory)");

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
            [string] $displayErrorMessage = ("Unable to create a new compress file, " + $archiveFileNameRequest + ", " + `
                                            "because the output path could not be found:`r`n" + `
                                            "`t" + $outputPath + "`r`n");

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file because the output path could not be found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive file to create: $($archiveFileNameRequest)`r`n" + `
                                        "`tContents to compact: $($targetDirectory)`r`n" + `
                                        "`tOutput path: $($outputPath)");

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
            [string] $displayErrorMessage = ("Unable to create a new compress file, " + $archiveFileNameRequest + ", " + `
                                            "because the source files could not be found with the given path:`r`n" + `
                                            "`t" + $targetDirectory + "`r`n");

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file because the target directory could not be found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive file to create: $($archiveFileNameRequest)`r`n" + `
                                        "`tContents to compact: $($targetDirectory)`r`n" + `
                                        "`tOutput directory: $($outputPath)");

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
                    [string] $displayErrorMessage = "Failed to create a new archive data file because it was not possible to create a unique filename!";

                    # Generate the initial message
                    [string] $logMessage = $displayErrorMessage;

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = ("Unable to create a unique filename for the archive datafile!`r`n" + `
                                                "`tArchive Filename [Absolute Path]: $($archiveFileName).$($archiveFileExtension)`r`n" + `
                                                "`tContents to compact: $($targetDirectory)`r`n" + `
                                                "`tOutput directory: $($outputPath)");

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
                             -CompressionLevel $this.GetCompressionLevel() `
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
            [string] $displayErrorMessage = ("Failed to create a new archive datafile because of memory limitations!" + `
                                            "  There may be too much data to compact or a file is too large to compress!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to create a new archive datafile due to memory constraints!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Archive Filename [Absolute Path]: $($archiveFileName).$($archiveFileExtension)`r`n" + `
                                        "`tContents to compact: $($targetDirectory)`r`n" + `
                                        "`tOutput directory: $($outputPath)`r`n" + `
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
                [string] $displayErrorMessage = ("Failed to create a new archive datafile!`r`n" + `
                                                "$([Logging]::GetExceptionInfoShort($_.Exception))");

                # Generate the initial message
                [string] $logMessage = "Failed to create a new archive datafile!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Archive Filename [Absolute Path]: $($archiveFileName).$($archiveFileExtension)`r`n" + `
                                            "`tContents to compact: $($targetDirectory)`r`n" + `
                                            "`tOutput directory: $($outputPath)`r`n" + `
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
        if([CommonIO]::DeleteFile($this.GetLogPath(), $extLogs) -eq $false)
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




<# Compression Level [ENUM]
 # -------------------------------
 # Associated with what type of compression level the end-user prefers when compacting
 #  source files into an archive datafile through the ArchiveZip object.
 # Please see the '-CompressionLevel' from the 'Compress-Archive' CMDLet here:
 #  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive#parameters
 # -------------------------------
 #>
enum CompressionLevel
{
    Optimal         = 0;    # Best Compression
    Fastest         = 1;    # Light Compression
    NoCompression   = 2;    # Store
} # CompressionLevel