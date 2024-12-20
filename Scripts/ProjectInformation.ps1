﻿<# PowerShell Compact-Archive Tool
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




<# Project Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds all information regarding the desired project that we will be essentially compiling.
 #  Such information is essentially basic, such as: project name, code name, output filename, and project
 #  URLs.  This is going to be helpful for the program to be much more modular and yet also helpful for
 #  the end-user that will be using this program tool.
 #>




class ProjectInformation
{
    # Object Singleton Instance
    # =================================================
    # =================================================


    #region Singleton Instance

    # Singleton Instance of the object
    hidden static [ProjectInformation] $_instance = $null;




    # Get the instance of this singleton object (Default)
    static [ProjectInformation] GetInstance()
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [ProjectInformation]::_instance)
        {
            # Create a new instance of the singleton object.
            [ProjectInformation]::_instance = [ProjectInformation]::new();
        } # If : No Singleton Instance

        # Provide an instance of the object.
        return [ProjectInformation]::_instance;
    } # GetInstance()




    # Get the instance of this singleton object (with Args)
    #  Useful if we already know that we have to instantiate
    #  a new instance of this particular object.
    static [ProjectInformation] GetInstance([string] $projectName,      `   # Project's full name
                                            [string] $codeName,         `   # Project's Codename (or version codename)
                                            [string] $compilerVersion,  `   # Project's Compiler Version
                                            [string] $fileName,         `   # Project's Filename (compiled name)
                                            [string] $urlWebsite,       `   # Project's Website Link
                                            [string] $urlWiki,          `   # Project's Wiki Link
                                            [string] $urlSource,        `   # Project's Source Line
                                            [string] $projectPath)          # Project's Source files; local filesystem path.
    {
        # if there was no previous instance of the object - then create one.
        if ($null -eq [ProjectInformation]::_instance)
        {
            # Create a new instance of the singleton object.
            [ProjectInformation]::_instance = [ProjectInformation]::new($projectName,       $codeName,
                                                                        $compilerVersion,   $fileName,
                                                                        $urlWebsite,        $urlWiki,
                                                                        $urlSource,         $projectPath);
        } # If : No Singleton Instance

        # Provide an instance of the object.
        return [ProjectInformation]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Project's Name
    # ---------------
    # The formal name of the project.
    Hidden [string] $__projectName = "projectNameHere";


    # Project's Code Name (or Version Code Name)
    # ---------------
    # The code name of the overall project or version of the project.
    Hidden [string] $__codeName = "projectsCodeNameHere";


    # Project's Compiler Version
    # ---------------
    # The base version of the project's version within this program.
    # NOTE: The version does not reflect the version of the project
    #           itself, but the version in regards to this program.
    Hidden [string] $__compilerVersion = "";


    # Output Filename
    # ---------------
    # The filename that will be used in compiled builds.
    # NOTE: Remember that /idgames has a fixed 8char upper-limit!
    Hidden [string] $__fileName = "projectsFileNameHere";


    # Project's Website
    # ---------------
    # The project's official website; which can be accessed by the end-user by request.  This can be
    #  helpful to the user, in-which they may check out the project's latest public announcements and
    #  insights regarding the project.
    Hidden [string] $__urlWebsite = "";


    # Project's Help Documentation
    # ---------------
    # The project's official Wikipedia; which can be accessed by the end-user by request.  This can
    #  greatly be helpful to the user, as they may view the project's help-documentation for abroad
    #  reasons but not limited to using this very tool.
    # NOTE: Wiki's are usually provided in some Developer\Repositories Web-Services, such as GitHub.
    Hidden [string] $__urlWiki = "";


    # Project's Repository
    # ---------------
    # The project's official repository; which can be accessed by the end-user by request.  This can
    #  allow the user to view the project's source code via their preferred web-browser.  Prime example
    #  of Repositories: GitHub, SourceForge, BitBucket, GitLab, and many more.
    Hidden [string] $__urlSource = "";


    # Project Loaded
    # ---------------
    # This variable will keep track if a project had been loaded within the program's environment.
    #  By keeping track if a project had been loaded, the program can be able to restrict certain
    #  operations as well as encouraging the user to load projects.
    Hidden [bool] $__projectLoaded = $false;


    # Project's Path
    # ---------------
    # This will provide the location as to where the project is located within the host's system.
    #  More specifically, where the user has it stored within their system.  By having this member
    #   variable available, we can easily auto-assign this with the desired path already provided
    #   by the user during load.
    Hidden [string] $__projectPath = "";


    # Project's Installation Path
    # ---------------
    # This will provide the absolute location of the PSCAT project's installation path.  This
    #   will be used as a way to update additional configuration files as needed.
    Hidden [string] $__projectInstallationPath = "";


    # Project's Meta File Name
    # ---------------
    # Specifies the exact filename of the current loaded project's Metadata file.  This will be
    #   used as a way to update additional configuration files as needed, in which we can
    #   expeditiously load the project's meta file.
    Hidden [string] $__projectMetaFileName = "";


    #endregion




    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    ProjectInformation()
    {
        # Project Name
        $this.__projectName             = $null;

        # Code Name
        $this.__codeName                = $null;

        # Compile Version
        $this.__compilerVersion         = $null;

        # File Name
        $this.__fileName                = $null;

        # Website URL
        $this.__urlWebsite              = $null;

        # Wiki URL
        $this.__urlWiki                 = $null;

        # Source Repository URL
        $this.__urlSource               = $null;

        # Project Loaded
        $this.__projectLoaded           = $false;

        # Project Path
        $this.__projectPath             = $null;

        # Project Installation Path
        $this.__projectInstallationPath = $null;

        # Project Meta Filename
        $this.__projectMetaFileName     = $null;
    } # Default Constructor




    # Project Information : On-Demand
    ProjectInformation([string] $projectName,       `   # Project's full name
                        [string] $codeName,         `   # Project's Codename (or version codename)
                        [string] $CompilerVersion,  `   # Project's Compiler Version
                        [string] $fileName,         `   # Project's Filename (compiled name)
                        [string] $urlWebsite,       `   # Project's Website Link
                        [string] $urlWiki,          `   # Project's Wiki Link
                        [string] $urlSource,        `   # Project's Source Line
                        [string] $projectPath,      `   # Project's Source files; local filesystem path.
                        [string] $installPath,      `   # Project's Install Path
                        [string] $metaFileName)         # Project's Meta filename
    {
        # Project Name
        $this.__projectName             = $projectName;

        # Code Name
        $this.__codeName                = $codeName;

        # Compile Version
        $this.__compilerVersion         = $compilerVersion;

        # File Name
        $this.__fileName                = $fileName;

        # Website URL
        $this.__urlWebsite              = $urlWebsite;

        # Wiki URL
        $this.__urlWiki                 = $urlWiki;

        # Source Repository URL
        $this.__urlSource               = $urlSource;

        # Project Loaded
        $this.__projectLoaded           = $true;

        # Project Path
        $this.__projectPath             = $projectPath;

        # Project Installation Path
        $this.__projectInstallationPath = $installPath;

        # Project Meta Filename
        $this.__projectMetaFileName     = $metaFileName;
    } # Project Information Constructor




    #region Getter Functions

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
    [String] GetProjectName() { return $this.__projectName; }




   <# Get Code Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Code Name' variable.
    # -------------------------------
    # Output:
    #  [String] Code Name
    #   The value of the 'Code Name'.
    # -------------------------------
    #>
    [String] GetCodeName() { return $this.__codeName; }




   <# Get Compiler Version
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compiler Version' variable.
    # -------------------------------
    # Output:
    #  [String] Compiler Version
    #   The value of the 'Compiler Version'.
    # -------------------------------
    #>
    [String] GetCompilerVersion() { return $this.__compilerVersion; }




   <# Get File Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'File Name' variable.
    # -------------------------------
    # Output:
    #  [String] File Name
    #   The value of the 'File Name'.
    # -------------------------------
    #>
    [String] GetFileName() { return $this.__fileName; }




   <# Get Website URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Website URL' variable.
    # -------------------------------
    # Output:
    #  [String] Website URL
    #   The value of the 'Website URL'.
    # -------------------------------
    #>
    [String] GetURLWebsite() { return $this.__urlWebsite; }




   <# Get Wiki URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Wiki URL' variable.
    # -------------------------------
    # Output:
    #  [String] Wiki URL
    #   The value of the 'Wiki URL'.
    # -------------------------------
    #>
    [String] GetURLWiki() { return $this.__urlWiki; }




   <# Get Source URL
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Source URL' variable.
    # -------------------------------
    # Output:
    #  [String] Source URL
    #   The value of the 'Source URL'.
    # -------------------------------
    #>
    [String] GetURLSource() { return $this.__urlSource; }




   <# Get Project Loaded
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Loaded' variable.
    # -------------------------------
    # Output:
    #  [Bool] Project Loaded
    #   The value of the 'Project Loaded'.
    # -------------------------------
    #>
    [Bool] GetProjectLoaded() { return $this.__projectLoaded; }




   <# Determine Assigned: Website
    # -------------------------------
    # Documentation:
    #  This determines if the 'Website URL' variable had been populated
    # -------------------------------
    # Output:
    #  [Bool] Determines if URL was Provided
    #   True  = Website URL had been provided.
    #   False = Website URL had NOT been provided.
    # -------------------------------
    #>
    [Bool] DetermineAssignedWebsite()
    {
        if ([CommonIO]::IsStringEmpty($this.__urlWebsite))
        {
            # Website was not provided.
            return $false;
        } # if : No Website Provided


        # If we made it here, then the Website URL had been provided.
        return $true;
    } # DetermineAssignedWebsite()




   <# Get Project Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Path' variable.
    # -------------------------------
    # Output:
    #  [String] Project Path
    #   The value of the 'Project Path'.
    # -------------------------------
    #>
    [String] GetProjectPath() { return $this.__projectPath; }




   <# Get Project Installation Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Installation Path' variable.
    # -------------------------------
    # Output:
    #  [String] Project Installation Path
    #   The value of the 'Project Installation Path'.
    # -------------------------------
    #>
    [String] GetProjectInstallationPath() { return $this.__projectInstallationPath; }




   <# Get Project Meta Filename
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Meta Filename' variable.
    # -------------------------------
    # Output:
    #  [String] Project Meta Filename
    #   The value of the 'Project Meta Filename'.
    # -------------------------------
    #>
    [String] GetProjectMetaFileName() { return $this.__projectMetaFileName; }

    #endregion




    #region Setter Functions

   <# Set Project Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Name' variable.
    # -------------------------------
    # Input:
    #  [string] Project Name
    #   Defines the Project's Name variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectName([string] $newVal)
    {
        # Insure that the provided value is not null.
        # If it is null, we cannot accept the change as it is a mandatory value.
        if ([CommonIO]::IsStringEmpty($newVal)) { return $false; }


        # Set the Project Name as requested.
        $this.__projectName = $newVal;


        # Finished!
        return $true;
    } # SetProjectName()




   <# Set Project's Code Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Code Name' variable.
    # -------------------------------
    # Input:
    #  [string] Code Name
    #   Defines the Project's Code Name variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCodeName([string] $newVal)
    {
        # Insure that the provided value is not null.
        # If it is null, we cannot accept the change as it is a mandatory value.
        if ([CommonIO]::IsStringEmpty($newVal)) { return $false; }


        # Set the Project's Code Name as requested.
        $this.__codeName = $newVal;


        # Finished!
        return $true;
    } # SetCodeName()




   <# Set Compiler Version
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compiler Version' variable.
    # -------------------------------
    # Input:
    #  [string] Compiler Version
    #   Defines the Project's Compiler Version variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompilerVersion([string] $newVal)
    {
        # Insure that the provided value is not null.
        # If it is null, we cannot accept the change as it is a mandatory value.
        if ([CommonIO]::IsStringEmpty($newVal)) { return $false; }


        # Set the Project's Compiler Version as requested.
        $this.__compilerVersion = $newVal;


        # Finished!
        return $true;
    } # SetCompilerVersion()




   <# Set File Name
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'File Name' variable.
    # -------------------------------
    # Input:
    #  [string] File Name
    #   Defines the File Name variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetFileName([string] $newVal)
    {
        # Insure that the provided value is not null.
        # If it is null, we cannot accept the change as it is a mandatory value.
        if ([CommonIO]::IsStringEmpty($newVal)) { return $false; }


        # Set the File Name as requested.
        $this.__fileName = $newVal;


        # Finished!
        return $true;
    } # SetFileName()




   <# Set Website URL
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Website URL' variable.
    # -------------------------------
    # Input:
    #  [string] Website URL
    #   Defines the Website URL variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetURLWebsite([string] $newVal)
    {
        # Set the URL Website as requested.
        $this.__urlWebsite = $newVal;


        # Finished!
        return $true;
    } # SetURLWebsite()




   <# Set Wiki URL
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Wiki URL' variable.
    # -------------------------------
    # Input:
    #  [string] Wiki URL
    #   Defines the Wiki URL variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetURLWiki([string] $newVal)
    {
        # Set the URL Wiki as requested.
        $this.__urlWiki = $newVal;


        # Finished!
        return $true;
    } # SetURLWiki()




   <# Set Source URL
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Source URL' variable.
    # -------------------------------
    # Input:
    #  [string] Source URL
    #   Defines the Source URL variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetURLSource([string] $newVal)
    {
        # Set the URL Source as requested.
        $this.__urlSource = $newVal;


        # Finished!
        return $true;
    } # SetURLSource()




   <# Set Project Loaded
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Loaded' variable.
    # -------------------------------
    # Input:
    #  [Bool] Project Loaded
    #   Changes the state of the 'Project Loaded' variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectLoaded([bool] $newVal)
    {
        # Change the state of the Project Loaded variable.
        $this.__projectLoaded = $newVal;


        # Finished!
        return $true;
    } # SetProjectLoaded()




   <# Set Project Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Path' variable.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   Defines the Project Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectPath([string] $newVal)
    {
        # Inspect to see if the path
        if ([CommonIO]::CheckPathExists($newVal, $true))
        {
            # Path exists; use it as requested.
            $this.__projectPath = $newVal;


            # Finished successfully
            return $true;
        } # if : Path Exists


        # Failure; Path did not exist.
        return $false;
    } # SetProjectPath()




   <# Set Project Installation Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Installation Path' variable.
    # -------------------------------
    # Input:
    #  [string] Project Installation Path
    #   Defines the Project Installation Path variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectInstallationPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if ([CommonIO]::CheckPathExists($newVal, $true))
        {
            # Path exists; use it as requested.
            $this.__projectInstallationPath = $newVal;


            # Finished successfully
            return $true;
        } # if : Path Exists


        # Failure; Path did not exist.
        return $false;
    } # SetProjectInstallationPath()




   <# Set Project Meta Filename
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Project Meta Filename' variable.
    # -------------------------------
    # Input:
    #  [string] Project Meta Filename
    #   Defines the Project Meta Filename variable.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetProjectMetaFileName([string] $newVal)
    {
        # Assure that the filename is not empty.
        if ([CommonIO]::IsStringEmpty($newVal)) { return $false; }

        # Filename given; use it as requested.
        $this.__projectMetaFileName = $newVal;

        # Finished successfully
        return $true;
    } # SetProjectMetaFileName()

    #endregion




   <# Clear Project Information
    # -------------------------------
    # Documentation:
    #  This function will clear all information provided for the project, and the 'Project Loaded'
    #   attribute will marked as $false.
    # -------------------------------
    #>
    [void] Clear()
    {
        $this.__projectName             = $null;    # Project Name
        $this.__codeName                = $null;    # Code Name
        $this.__compilerVersion         = $null;    # Compile Version
        $this.__fileName                = $null;    # File Name
        $this.__urlWebsite              = $null;    # Website URL
        $this.__urlWiki                 = $null;    # Wiki URL
        $this.__urlSource               = $null;    # Source Repository URL
        $this.__projectPath             = $null;    # Project Path
        $this.__projectLoaded           = $false;   # Project Loaded
        $this.__projectInstallationPath = $null;    # Project Installation Path
        $this.__projectMetaFileName     = $null;    # Project Meta Filename
    } # Clear()




   <# Show Project Information
    # -------------------------------
    # Documentation:
    #  This function will show the current information regarding the project that is presently loaded within
    #   this object's instance.
    # -------------------------------
    # Input:
    #  [ProjectInformationShowDetail] Information Detail
    #   Specifies how much information will be provided to the calling function.
    #  [string] {REFERENCE} Project Information
    #   When this function return's true, this string will contain all available information regarding the
    #   project that is presently loaded within this object's instance.
    # -------------------------------
    # Output:
    #  [bool] Project Loaded
    #     $false = Project is not loaded.
    #     $true  = Project is loaded.
    # -------------------------------
    #>
    [bool] Show([ProjectInformationShowDetail] $informationDetail,  `   # How much detail to give
                [ref] $projectInformationStr)                           # Project Information String
    {
        # Is a project presently loaded?
        if ($this.__projectLoaded -eq $false)
        { return $false; }


        # Project is loaded, craft the string:
        if (($informationDetail -eq [ProjectInformationShowDetail]::Full) -or `
            ($informationDetail -eq [ProjectInformationShowDetail]::Basic))
        {
            # Project Name
            if (($NULL -ne $this.__projectName) -and ($this.__projectName -ne ""))
            { $projectInformationStr.Value = "Project Name: " + $this.__projectName + "`r`n"; }

            # Code Name
            if (($NULL -ne $this.__codeName) -and ($this.__codeName -ne ""))
            { $projectInformationStr.Value += "Code Name: " + $this.__codeName + "`r`n"; }

            # Compiler Version
            if (($NULL -ne $this.__compilerVersion) -and ($this.__compilerVersion -ne ""))
            { $projectInformationStr.Value += "Compiler Version: " + $this.__compilerVersion + "`r`n"; }
        } # Basic Detail Information


        if ($informationDetail -eq [ProjectInformationShowDetail]::Full)
        {
            # File Name
            if (($NULL -ne $this.__fileName) -and ($this.__fileName -ne ""))
            { $projectInformationStr.Value += "Output File Name: " + $this.__fileName + "`r`n"; }

            # Website URL
            if (($NULL -ne $this.__urlWebsite) -and ($this.__urlWebsite -ne ""))
            { $projectInformationStr.Value += "Website Link: " + $this.__urlWebsite + "`r`n"; }

            # Wiki URL
            if (($NULL -ne $this.__urlWiki) -and ($this.__urlWiki -ne ""))
            { $projectInformationStr.Value += "Wiki Link: " + $this.__urlWiki + "`r`n"; }

            # Source URL
            if (($NULL -ne $this.__urlSource) -and ($this.__urlSource -ne ""))
            { $projectInformationStr.Value += "Source Code Link: " + $this.__urlSource + "`r`n"; }

            # Project Path
            if (($NULL -ne $this.__projectPath) -and ($this.__projectPath -ne ""))
            { $projectInformationStr.Value += "Local Working Copy Path: " + $this.__projectPath + "`r`n"; }

            # Project Installation Path
            if (($NULL -ne $this.__projectInstallationPath) -and ($this.__projectInstallationPath -ne ""))
            { $projectInformationStr.Value += "Installation Path: " + $this.__projectInstallationPath + "`r`n"; }

            # Project Meta Filename
            if (($NULL -ne $this.__projectMetaFileName) -and ($this.__projectMetaFileName -ne ""))
            { $projectInformationStr.Value += "Meta Filename: " + $this.__projectMetaFileName + "`r`n"; }
        } # Full Detail Information


        # Finished
        return $true;
    } # Show()
} # ProjectInformation




<# Project Information Show Detail [ENUM]
 # -------------------------------
 # Amount of detail Shown in Project Information
 # Provides how much detail will be provided when wanting to obtain information regarding the project that
 #  is presently loaded within the program's environment.
 # -------------------------------
 #>
enum ProjectInformationShowDetail
{
    Basic;
    Full;
} # ProjectInformationShowDetail