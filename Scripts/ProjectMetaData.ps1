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


    #region Meta Properties
    # - - - - - - - - - - - - -
    # - - - - - - - - - - - - -

    # Meta File Name
    # ---------------
    # Provides the name of the individual meta file.
    hidden [string] $__metaFileName;


    # Meta File Path
    # ---------------
    # Contains the absolute path of the meta file.
    hidden [string] $__metaFilePath;


    # Meta GUID
    # ---------------
    # A unique signature that uniquely identifies a project.
    #   This value is defined within the project's meta file.
    hidden [GUID] $__metaGUID;

    #endregion




    #region Project Information Properties
    # - - - - - - - - - - - - -
    # - - - - - - - - - - - - -

    # Project Name
    # ---------------
    # The project's full or recognizable name
    hidden [string] $__projectName;


    # Project Code Name
    # ---------------
    # The code name of the overall project or version of the project.
    hidden [string] $__projectCodeName;


    # Revision
    # ---------------
    # The project's revision
    hidden [UInt64] $__projectRevision;


    # Output File Name
    # ---------------
    # The project's output file name after being compiled into an archive data file.
    hidden [string] $__projectOutputFileName;


    # Website URL
    # ---------------
    # The website link to the project's homepage or where the user can find the project.
    hidden [string] $__projectURLWebsite;


    # Wiki URL
    # ---------------
    # The website link to the project's Wiki page or where the user can find documentation related to the
    #   project.
    hidden [string] $__projectURLWiki;


    # Source Code URL
    # ---------------
    # The website link to the project's source code or where the user can obtain\view the project's source
    #   materials.
    hidden [string] $__projectURLSourceCode;

    #endregion




    #region Program Specific Variables
    # - - - - - - - - - - - - -
    # - - - - - - - - - - - - -

    # Directory Name
    # ---------------
    # Provides the directory name in which the Meta file resides
    hidden [string] $__programDirectoryName;


    # Verified
    # ---------------
    # Denotes if the file's archive datafile passed the verification test.
    hidden [ProjectMetaDataFileVerification] $__programVerification;


    # Installed
    # ---------------
    # Signifies if the file had been properly installed or could not be installed.
    hidden [bool] $__programInstalled;


    # Message
    # ---------------
    # This will hold a verbose message regarding the operation for this file.
    hidden [string] $__programMessage;

    #endregion




    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    ProjectMetaData()
    {
        # Meta Properties
        # - - - - - - - - - - - - -

        # Meta File Name
        $this.__metaFileName    = $null;


        # Meta File Path
        $this.__metaFilePath    = $null;


        # Meta GUID
        $this.__metaGUID        = $($GLOBAL:_DEFAULT_BLANK_GUID_);




        # Project Information Properties
        # - - - - - - - - - - - - -

        # Project Name
        $this.__projectName             = $null;


        # Project Code Name
        $this.__projectCodeName         = $null;


        # Project Revision
        $this.__projectRevision         = 0;


        # Output File Name
        $this.__projectOutputFileName   = $null;


        # Website URL
        $this.__projectURLWebsite       = $null;


        # Wiki URL
        $this.__projectURLWiki          = $null;


        # Source Code URL
        $this.__projectURLSourceCode    = $null;




        # Program Specific Variables
        # - - - - - - - - - - - - -

        # Directory Name
        $this.__programDirectoryName    = $null;


        # Verification
        $this.__programVerification     = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__programInstalled        = $false;


        # Message
        $this.__programMessage          = $null;
    } # Default Constructor




    # Initiated Object
    ProjectMetaData ([ProjectMetaDataArguments] $inputArguments)
    {
        # Meta Properties
        # - - - - - - - - - - - - -

        # Meta File Name
        $this.__metaFileName            = $inputArguments.metaFileName;


        # Meta File Path
        $this.__metaFilePath            = $inputArguments.metaFilePath;


        # Meta GUID
        $this.__metaGUID                = $inputArguments.metaGUID;




        # Project Information Properties
        # - - - - - - - - - - - - -

        # Project Name
        $this.__projectName             = $inputArguments.projectName;


        # Project Code Name
        $this.__projectCodeName         = $inputArguments.projectCodeName;


        # Project Revision
        $this.__projectRevision         = $inputArguments.projectRevision;


        # Output File Name
        $this.__projectOutputFileName   = $inputArguments.projectOutputFileName;


        # Website URL
        $this.__projectURLWebsite       = $inputArguments.projectURLWebsite;


        # Wiki URL
        $this.__projectURLWiki          = $inputArguments.projectURLWiki;


        # Source Code URL
        $this.__projectURLSourceCode    = $inputArguments.projectURLSourceCode;




        # Program Specific Variables
        # - - - - - - - - - - - - -

        # Directory Name
        $this.__programDirectoryName    = $inputArguments.programDirectoryName;


        # Verification
        $this.__programVerification     = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__programInstalled        = $false;


        # Message
        $this.__programMessage          = $null;
    } # Initiated Object




    # Initiated Object - Legacy
    ProjectMetaData (   [string] $metaFileName, `   # Name of the meta file
                        [string] $metaFilePath)     # Meta File's full path
    {
        # Meta Properties
        # - - - - - - - - - - - - -

        # Meta File Name
        $this.__metaFileName    = $metaFileName;


        # Meta File Path
        $this.__metaFilePath    = $metaFilePath;


        # Meta GUID
        $this.__metaGUID        = $($GLOBAL:_DEFAULT_BLANK_GUID_);




        # Project Information Properties
        # - - - - - - - - - - - - -

        # Project Name
        $this.__projectName             = $null;


        # Project Code Name
        $this.__projectCodeName         = $null;


        # Project Revision
        $this.__projectRevision         = 0;


        # Output File Name
        $this.__projectOutputFileName   = $null;


        # Website URL
        $this.__projectURLWebsite       = $null;


        # Wiki URL
        $this.__projectURLWiki          = $null;


        # Source Code URL
        $this.__projectURLSourceCode    = $null;




        # Program Specific Variables
        # - - - - - - - - - - - - -

        # Directory Name
        $this.__programDirectoryName    = $null;


        # Verification
        $this.__programVerification     = [ProjectMetaDataFileVerification]::NoInformation;


        # Installed
        $this.__programInstalled        = $false;


        # Message
        $this.__programMessage          = $null;
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




   <# Get Meta GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Meta GUID' variable.
    # -------------------------------
    # Output:
    #  [GUID] Meta GUID
    #   The value of the 'Meta GUID'.
    # -------------------------------
    #>
    [GUID] GetMetaGUID() { return $this.__metaGUID; }




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




   <# Get Project Code Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Code Name' variable.
    # -------------------------------
    # Output:
    #  [String] Project Code Name
    #   The value of the 'Project Code Name'.
    # -------------------------------
    #>
    [string] GetProjectCodeName() { return $this.__projectCodeName; }




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




   <# Get Project Output File Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Output File Name' variable.
    # -------------------------------
    # Output:
    #  [String] Project Output File Name
    #   The value of the 'Project Output File Name'.
    # -------------------------------
    #>
    [string] GetProjectOutputFileName() { return $this.__projectOutputFileName; }




   <# Get Project Website URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Website URL' variable.
    # -------------------------------
    # Output:
    #  [String] Project Website URL
    #   The value of the 'Project Website URL'.
    # -------------------------------
    #>
    [string] GetProjectURLWebsite() { return $this.__projectURLWebsite; }




   <# Get Project Wiki URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Wiki URL' variable.
    # -------------------------------
    # Output:
    #  [String] Project Wiki URL
    #   The value of the 'Project Wiki URL'.
    # -------------------------------
    #>
    [string] GetProjectURLWiki() { return $this.__projectURLWiki; }




   <# Get Project Source Code URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Source Code URL' variable.
    # -------------------------------
    # Output:
    #  [String] Project Source Code URL
    #   The value of the 'Project Source Code URL'.
    # -------------------------------
    #>
    [string] GetProjectURLSourceCode() { return $this.__projectURLSourceCode; }




   <# Get Program Directory Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Program Directory Name' variable.
    # -------------------------------
    # Output:
    #  [String] Program Directory Name
    #   The value of the 'Program Directory Name'.
    # -------------------------------
    #>
    [string] GetProgramDirectoryName() { return $this.__programDirectoryName; }




   <# Get Program Verification
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Program Verification' variable.
    # -------------------------------
    # Output:
    #  [ProjectMetaDataFileVerification] Program Verification
    #   The value of the 'Program Verification'.
    # -------------------------------
    #>
    [ProjectMetaDataFileVerification] GetProgramVerification() { return $this.__programVerification; }




   <# Get Program Installed
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Program Installed' variable.
    # -------------------------------
    # Output:
    #  [bool] Program Installed
    #   The value of the 'Program Installed'.
    # -------------------------------
    #>
    [bool] GetProgramInstalled() { return $this.__programInstalled; }




   <# Get Program Message
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Program Message' variable.
    # -------------------------------
    # Output:
    #  [string] Program Message
    #   The value of the 'Program Message'.
    # -------------------------------
    #>
    [string] GetProgramMessage() { return $this.__programMessage; }

    #endregion



    #region Setter Functions

   <# Set Meta File Name [Required]
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
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMetaFileName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__metaFileName = $newValue;


        # Operation was successful
        return $true;
    } # SetMetaFileName()




   <# Set Meta File Path [Required]
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
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMetaFilePath([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__metaFilePath = $newValue;


        # Operation was successful
        return $true;
    } # SetMetaFilePath()




   <# Set Meta GUID [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Meta GUID' variable.
    # -------------------------------
    # Input:
    #  [GUID] Meta GUID
    #   Sets the value of the 'Meta GUID' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetMetaGUID([GUID] $newValue)
    {
        # Update the value as requested.
        $this.__metaGUID = $newValue;


        # Operation was successful
        return $true;
    } # SetMetaGUID()




   <# Set Project Name [Required]
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
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__projectName = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectName()




   <# Set Project Code Name [Optional]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Code Name' variable.
    # -------------------------------
    # Input:
    #  [String] Project Code Name
    #   Sets the value of the 'Project Code Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectCodeName([string] $newValue)
    {
        # Update the value as requested.
        $this.__projectCodeName = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectCodeName()




   <# Set Project Revision [Required]
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
    #   true  = Success; value has been changed.
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




   <# Set Project Output File Name [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Output File Name' variable.
    # -------------------------------
    # Input:
    #  [String] Project Output File Name
    #   Sets the value of the 'Project Output File Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectOutputFileName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__projectOutputFileName = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectOutputFileName()




   <# Set Project Website URL [Optional]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Website URL' variable.
    # -------------------------------
    # Input:
    #  [String] Project Website URL
    #   Sets the value of the 'Project Website URL' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectURLWebsite([string] $newValue)
    {
        # Update the value as requested.
        $this.__projectURLWebsite = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectURLWebsite()




   <# Set Project Wiki URL [Optional]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Wiki URL' variable.
    # -------------------------------
    # Input:
    #  [String] Project Wiki URL
    #   Sets the value of the 'Project Wiki URL' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectURLWiki([string] $newValue)
    {
        # Update the value as requested.
        $this.__projectURLWiki = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectURLWiki()




   <# Set Project Source Code URL [Optional]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Source Code URL' variable.
    # -------------------------------
    # Input:
    #  [String] Project Source Code URL
    #   Sets the value of the 'Project Source Code URL' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectURLSourceCode([string] $newValue)
    {
        # Update the value as requested.
        $this.__projectURLSourceCode = $newValue;


        # Operation was successful
        return $true;
    } # SetProjectURLSourceCode()




   <# Set Program Directory Name [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Program Directory Name' variable.
    # -------------------------------
    # Input:
    #  [String] Program Directory Name
    #   Sets the value of the 'Program Directory Name' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProgramDirectoryName([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__programDirectoryName = $newValue;


        # Operation was successful
        return $true;
    } # SetProgramDirectoryName()




   <# Set Program Verification [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Program Verification' variable.
    # -------------------------------
    # Input:
    #  [ProjectMetaDataFileVerification] Program Verification
    #   Sets the value of the 'Program Verification' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProgramVerification([ProjectMetaDataFileVerification] $newValue)
    {
        # Because the value must fit within the 'ProjectMetaDataFileVerification'
        #   datatype, there really is no point in checking if the new requested
        #   value is 'legal'.  Thus, we are going to trust the value and
        #   automatically return success.
        $this.__programVerification = $newValue;


        # Operation was successful
        return $true;
    } # SetProgramVerification()




   <# Set Program Installed [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Program Installed' variable.
    # -------------------------------
    # Input:
    #  [Bool] Program Installed
    #   Sets the value of the 'Program Installed' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProgramInstalled([bool] $newValue)
    {
        # Because the value must fit within the 'boolean' datatype, there
        #   really is no point in checking if the new requested value is
        #   'legal'.  Thus, we are going to trust the value and
        #   automatically return success.
        $this.__programInstalled = $newValue;


        # Operation was successful
        return $true;
    } # SetProgramInstalled()




   <# Set Program Message [Required]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Program Message' variable.
    # -------------------------------
    # Input:
    #  [String] Program Message
    #   Sets the value of the 'Program Message' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true  = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProgramMessage([string] $newValue)
    {
        # Make sure that the value is not null; if null - do not update.
        if ([CommonIO]::IsStringEmpty($newValue)) { return $false; }


        # Update the value as requested.
        $this.__programMessage = $newValue;


        # Operation was successful
        return $true;
    } # SetProgramMessage()




   <# Set Empty Meta File Path
    # -------------------------------
    # Documentation:
    #  Sets an empty value within the 'Meta File Path' variable.
    # -------------------------------
    #>
    [void] SetMetaFilePathAsEmpty() { $this.__metaFilePath = $NULL; }

    #endregion
} # ProjectMetaData




<# Project Meta Data - Input Arguments
 # ------------------------------
 # ==============================
 # ==============================
 # This class is only intended to provide input arguments that will be used for a
 #  class constructor for the Project Meta Data object.
 #>




class ProjectMetaDataArguments
{
    [string]    $metaFileName           ;   # Name of the meta file
    [string]    $metaFilePath           ;   # File's full path
    [GUID]      $metaGUID               ;   # Project's GUID
    [string]    $projectName            ;   # Name of the project
    [string]    $projectCodeName        ;   # Project's Code Name
    [UInt64]    $projectRevision        ;   # Project's Revision
    [string]    $projectOutputFileName  ;   # Output Filename
    [string]    $projectURLWebsite      ;   # Website link
    [string]    $projectURLWiki         ;   # Wiki Link
    [string]    $projectURLSourceCode   ;   # Source Code Link
    [string]    $programDirectoryName   ;   # Name of the parent directory
} # ProjectMetaDataArguments




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