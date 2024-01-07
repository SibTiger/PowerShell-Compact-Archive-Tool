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




<# Project Meta Data
 # ------------------------------
 # ==============================
 # ==============================
 # This class contains information regarding the PSCAT Project Meta files.  Within the Meta files, it can
 #  contain useful information regarding the Project, along with additional data used internally within the
 #  program itself.
 #>





class ProjectMetaData
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    # Meta File Name
    # ---------------
    # Provides the name of the individual meta file.
    hidden [string] $__metaFileName;


    # Meta File Path
    # ---------------
    # Contains the absolute path of the meta file.
    hidden [string] $__metaFilePath;


    # Directory Name
    # ---------------
    # Provides the directory name in which the Meta file resides
    hidden [string] $__directoryName;


    # Project Name
    # ---------------
    # The project's full or recognizable name
    hidden [string] $__projectName;


    # Revision
    # ---------------
    # The project's revision
    hidden [UInt64] $__projectRevision;


    # GUID
    # ---------------
    # A project's unique signature that identifies itself out of other projects.
    hidden [GUID] $__guid;


    # Verified
    # ---------------
    # Denotes if the file's archive datafile passed the verification test.
    hidden [ProjectMetaDataFileVerification] $__verification;


    # Installed
    # ---------------
    # Signifies if the file had been properly installed or could not be installed.
    hidden [bool] $__installed;


    # Message
    # ---------------
    # This will hold a verbose message regarding the operation for this file.
    hidden [string] $__message;



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    ProjectMetaData()
    {
        # Meta File Name
        $this.__metaFileName = $null;


        # Meta File Path
        $this.__metaFilePath = $null;


        # Project Name
        $this.__projectName = $null;


        # Directory Name
        $this.__directoryName = $null;


        # Revision
        $this.__projectRevision = 0;


        # GUID
        $this.__guid = $($GLOBAL:_DEFAULT_BLANK_GUID_);


        # Verification
        $this.__verification = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__installed = $false;


        # Message
        $this.__message = $null;
    } # Default Constructor




    # Initiated Object
    ProjectMetaData (   [string] $projectName, `    # Name of the project
                        [string] $metaFileName, `   # Name of the meta file
                        [string] $directoryName, `  # Name of the parent directory
                        [string] $metaFilePath, `   # File's full path
                        [UInt64] $revision, `       # Project's Revision
                        [GUID] $guid)               # Project's GUID
    {
        # Meta File Name
        $this.__metaFileName = $metaFileName;


        # Meta File Path
        $this.__metaFilePath = $metaFilePath;


        # Directory Name
        $this.__directoryName = $directoryName;


        # Project Name
        $this.__projectName = $projectName;


        # Revision
        $this.__projectRevision = $revision;


        # GUID
        $this.__guid = $guid;


        # Verification
        $this.__verification = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__installed = $false;


        # Message
        $this.__message = $null;
    } # Initiated Object




    # Initiated Object - Legacy
    ProjectMetaData (   [string] $metaFileName, `   # Name of the meta file
                        [string] $metaFilePath)     # Meta File's full path
    {
        # Meta File Name
        $this.__metaFileName = $metaFileName;


        # Meta File Path
        $this.__metaFilePath = $metaFilePath;


        # Directory Name
        $this.__directoryName = $null;


        # Project Name
        $this.__projectName = $NULL;


        # Revision
        $this.__projectRevision = $NULL;


        # GUID
        $this.__guid = $($GLOBAL:_DEFAULT_BLANK_GUID_);


        # Verification
        $this.__verification = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__installed = $false;


        # Message
        $this.__message = $null;
    } # Initiated Object

    #endregion




    #region Getter Functions

   <# Get Meta File Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Meta File Name' variable.
    # -------------------------------
    # Output:
    #  [String] Meta File Name
    #   The value of the 'Meta File Name'.
    # -------------------------------
    #>
    [string] GetMetaFileName() { return $this.__metaFileName; }




   <# Get Meta File Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Meta File Path' variable.
    # -------------------------------
    # Output:
    #  [String] Meta File Path
    #   The value of the 'Meta File Path'.
    # -------------------------------
    #>
    [string] GetMetaFilePath() { return $this.__metaFilePath; }




   <# Get Directory Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Directory Name' variable.
    # -------------------------------
    # Output:
    #  [String] Directory Name
    #   The value of the 'Directory Name'.
    # -------------------------------
    #>
    [string] GetDirectoryName() { return $this.__directoryName; }




   <# Get Project Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Name' variable.
    # -------------------------------
    # Output:
    #  [String] Project Name
    #   The value of the 'Project Name'.
    # -------------------------------
    #>
    [string] GetProjectName() { return $this.__projectName; }




   <# Get Project Revision
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Revision' variable.
    # -------------------------------
    # Output:
    #  [UInt64] Project Revision
    #   The value of the 'Project Revision'.
    # -------------------------------
    #>
    [UInt64] GetProjectRevision() { return $this.__projectRevision; }




   <# Get GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'GUID' variable.
    # -------------------------------
    # Output:
    #  [GUID] GUID
    #   The value of the 'GUID'.
    # -------------------------------
    #>
    [GUID] GetGUID() { return $this.__guid; }




   <# Get Verification
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Verification' variable.
    # -------------------------------
    # Output:
    #  [ProjectMetaDataFileVerification] Verification
    #   The value of the 'Verification'.
    # -------------------------------
    #>
    [ProjectMetaDataFileVerification] GetVerification() { return $this.__verification; }




   <# Get Installed
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Installed' variable.
    # -------------------------------
    # Output:
    #  [bool] Installed
    #   The value of the 'Installed'.
    # -------------------------------
    #>
    [bool] GetInstalled() { return $this.__installed; }




   <# Get Message
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Message' variable.
    # -------------------------------
    # Output:
    #  [string] Message
    #   The value of the 'Message'.
    # -------------------------------
    #>
    [string] GetMessage() { return $this.__message; }

    #endregion



    #region Setter Functions

   <# Set Meta File Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Meta File Name' variable.
    # -------------------------------
    # Input:
    #  [String] Meta File Name
    #   Sets the value of the 'Meta File Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMetaFileName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonFunctions]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__metaFileName = $newValue;


        # Operation was successful
        return $true;
    } # SetMetaFileName()




   <# Set Meta File Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Meta File Path' variable.
    # -------------------------------
    # Input:
    #  [String] Meta File Path
    #   Sets the value of the 'Meta File Path' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMetaFilePath([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonFunctions]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__metaFilePath = $newValue;


        # Operation was successful
        return $true;
    } # SetMetaFilePath()




   <# Set Directory Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Directory Name' variable.
    # -------------------------------
    # Input:
    #  [String] Directory Name
    #   Sets the value of the 'Directory Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetDirectoryName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonFunctions]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__directoryName = $newValue;


        # Operation was successful
        return $true;
    } # SetDirectoryName()




   <# Set Project Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Name' variable.
    # -------------------------------
    # Input:
    #  [String] Project Name
    #   Sets the value of the 'Project Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonFunctions]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__projectName = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectName()




   <# Set Project Revision
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Revision' variable.
    # -------------------------------
    # Input:
    #  [UInt64] Project Revision
    #   Sets the value of the 'Project Revision' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectRevision([UInt64] $newValue)
    {
        # Update the value as requested.
        $this.__projectRevision = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectRevision()




   <# Set GUID
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'GUID' variable.
    # -------------------------------
    # Input:
    #  [GUID] GUID
    #   Sets the value of the 'File Path' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGUID([GUID] $newValue)
    {
        # Update the value as requested.
        $this.__guid = $newValue;


        # Operation was successful
        return $true;
    } # SetGUID()




   <# Set Empty Meta File Path
    # -------------------------------
    # Documentation:
    #  Sets an empty value within the 'Meta File Path' variable.
    # -------------------------------
    #>
    [void] SetMetaFilePathAsEmpty() { $this.__metaFilePath = $NULL; }




   <# Set Verification
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Verification' variable.
    # -------------------------------
    # Input:
    #  [ProjectMetaDataFileVerification] Verification
    #   Sets the value of the 'Verification' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVerification([ProjectMetaDataFileVerification] $newValue)
    {
        # Because the value must fit within the 'ProjectMetaDataFileVerification'
        #   datatype, there really is no point in checking if the new requested
        #   value is 'legal'.  Thus, we are going to trust the value and
        #   automatically return success.
        $this.__verification = $newValue;


        # Operation was successful
        return $true;
    } # SetVerification()




   <# Set Installed
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Installed' variable.
    # -------------------------------
    # Input:
    #  [Bool] Installed
    #   Sets the value of the 'Installed' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetInstalled([bool] $newValue)
    {
        # Because the value must fit within the 'boolean' datatype, there
        #   really is no point in checking if the new requested value is
        #   'legal'.  Thus, we are going to trust the value and
        #   automatically return success.
        $this.__installed = $newValue;


        # Operation was successful
        return $true;
    } # SetInstalled()




   <# Set Message
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Message' variable.
    # -------------------------------
    # Input:
    #  [String] Message
    #   Sets the value of the 'Message' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMessage([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonFunctions]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__message = $newValue;


        # Operation was successful
        return $true;
    } # SetMessage()

    #endregion
} # ProjectMetaData




<# Project Meta Data File Verification [ENUM]
 # -------------------------------
 # Associated with the types of possible verification states, that provides
 #  more meaning to the programmer and - the user viewing the information.
 # Because the files we support are Zip archive datafiles, we need to be
 #  sure that the file can be properly verified - and healthy.
 # -------------------------------
 #>
enum ProjectMetaDataFileVerification
{
    NoInformation   = 0;    # Verification not yet performed.
    Passed          = 1;    # Verification passed; file is healthy.
    Failed          = 2;    # Verification failed; file is damaged.
    Installed       = 3;    # Verification not needed; already installed item.
} # ProjectMetaDataFileVerification