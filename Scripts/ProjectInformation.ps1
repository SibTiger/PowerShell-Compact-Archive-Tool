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




<# Project Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class will contain information regarding a desired project that had been selected by the
 #  user.  The information collected within this class will contain the essential meta-data needed
 #  to help aid the compiling process that is performed within the program.
 #>




class ProjectInformation
{

    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Hidden Variables

    # Project's Name
    # ---------------
    # The name of the project.
    Static Hidden [string] $__projectName = $NULL;


    # Project's Website
    # ---------------
    # The website for the project.
    Static Hidden [string] $__projectWebsite = $NULL;


    # Project's Compiled Name
    # ---------------
    # Defines the final output filename of the compiled build.
    Static Hidden [string] $__outputName = $NULL;


    # Project's Path
    # ---------------
    # The absolute path to the project's source files on a filesystem.
    Static Hidden [string] $__sourcePath = $NULL;


    # Project is Ready
    # ---------------
    # A flag that signifies if a project had been loaded into the environment.
    Static Hidden [bool] $__isLoaded = $false;



    # -----------------------------
    # -----------------------------
    # Project File


    # Project Filename
    # ---------------
    # A file the contains a project's meta-data information in plaintext.
    Static Hidden [string] $__projectFileName = "$($GLOBAL:_PROGRAMNAMESHORT_).Proj";


    # Variable: Comment Token
    # ---------------
    # A character at the first column that specifies that the line is a comment.
    Static Hidden [char] $__projectMetaDataCommentToken = '#';


    # Variable: Assignment Delimiter
    # ---------------
    # A character that separates the variable and the value of the variable.
    Static Hidden [char] $__projectFileAssignmentDelimiter = '=';


    # Variable: Project Name
    # ---------------
    # A variable, within the Project File, that provides the Project's name.
    Static Hidden [string] $__projectFileVariable_ProjectName = "Project_Name_String";


    # Variable: Project Website
    # ---------------
    # A variable, within the Project File, that provides the Project's website.
    Static Hidden [string] $__projectFileVariable_ProjectWebsite = "Project_Website_String";


    # Variable: Output Filename
    # ---------------
    # A variable, within the Project File, that provides the Output filename
    Static Hidden [string] $__projectFileVariable_OutputFileName = "Project_BuildName_String";

    #endregion




    # Member Functions :: Methods
    # =================================================
    # =================================================




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
    Static [String] GetProjectName() { return [ProjectInformation]::__projectName; }




   <# Get Project Website
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Website' variable.
    # -------------------------------
    # Output:
    #  [String] Project Website
    #   The value of the 'Project Website'.
    # -------------------------------
    #>
    Static [String] GetProjectWebsite() { return [ProjectInformation]::__projectWebsite; }




   <# Get Output Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Output Name' variable.
    # -------------------------------
    # Output:
    #  [String] Output Name
    #   The value of the 'Output Name'.
    # -------------------------------
    #>
    Static [String] GetOutputName() { return [ProjectInformation]::__outputName; }




   <# Get Source Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Source Path' variable.
    # -------------------------------
    # Output:
    #  [String] Source Path
    #   The value of the 'Source Path'.
    # -------------------------------
    #>
    Static [String] GetSourcePath() { return [ProjectInformation]::__sourcePath; }




   <# Get Project Loaded
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Project Loaded' variable.
    # -------------------------------
    # Output:
    #  [String] Project Loaded
    #   The value of the 'Project Loaded'.
    # -------------------------------
    #>
    Static [bool] GetIsLoaded () { return [ProjectInformation]::__isLoaded; }

    #endregion




   <# Load Procedure
    # -------------------------------
    # Documentation:
    #   This function will guide the user into loading the project's meta-data into the environment,
    #   which will ultimately help aid the program during the compiling process.
    # -------------------------------
    # Output:
    #  [Bool] Operation Code
    #   Determines if a project had been successfully loaded into the environment.
    #       $true   = Project's meta data had been collected successfully
    #       $false  = Project's meta data was not collected; user canceled; error was reached.
    # -------------------------------
    #>
    Static [Bool] Load ()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This string will provide the absolute path to the Project File
        [string] $projectFilePath = $NULL;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that
        #  it is easy for the user to read and follow along.
        [CommonIO]::ClearBuffer();

        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();

        # Show the user that they are at the Load Project section
        [CommonCUI]::DrawSectionHeader("Load Project");


        # Show what project is loaded into the environment, if one is already loaded.
        if ([ProjectInformation]::GetIsLoaded())
        { [Logging]::DisplayMessage("Project Loaded is: " + [ProjectInformation]::GetProjectName()); }
        else
        { [Logging]::DisplayMessage("Project Loaded is: - NO PROJECT IS YET LOADED -"); }


        # Provide some spacing
        [Logging]::DisplayMessage("`r`n`r`n");


        # Provide instructions to the user.
        [CommonCUI]::ShowInstructionHeader();
        [Logging]::DisplayMessage(  "While using the Graphical Folder Browser, please select a directory " + `
                                    "that contains the project's source files that you would like to " + `
                                    "compile into a ZDoom PK3 file.`r`n" + `
                                    "`r`n" + `
                                    "To cancel, click the 'Cancel' button within the graphical Folder Browser.");


        # Open the folder browser, allowing the user to select the project's source directory.
        if ([CommonGUI]::BrowseDirectory("Select a project that you want to build.", `
                                        [BrowserInterfaceStyle]::Modern, `
                                        [ref] [ProjectInformation]::__sourcePath) -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "User had canceled the operation to find a Project to load!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $NULL;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the user had canceled the operation, abort the entire operation.
            return $false;
        } # if : User Aborts from Directory Browser



        # Assign the Project File variable to make our lives easier.
        $projectFilePath = [ProjectInformation]::__sourcePath + "\" + [ProjectInformation]::__projectFileName;


        # Try to find the Project File with the path given by the user.
        if ([CommonIO]::CheckPathExists($projectFilePath, $true))
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Load the Project File in a list, so we can parse through it - line by line.
            [System.Collections.ArrayList] $projectFile = $(Get-Content -LiteralPath $projectFilePath);

            # Hash Table to help us fetch the data easily from the Project File
            $projectFileStrings = @{};

            # This will contain the contents from the Project File as-is, but new-lines being attached.
            #  Mainly for logging purposes for when things go horribly wrong.
            [string] $projectFileFormatString = $NULL;

            # Get Directory Info., which will be used for logging purposes.
            [System.IO.DirectoryInfo] $directoryInfo = [ProjectInformation]::__sourcePath;
            # ----------------------------------------


            # Because the Project File exists, we will try to obtain all of the necessary known strings from
            #   the Project File so that we can properly handle the data.
            foreach ($line in $projectFile)
            {
                # Also capture the line into a formatted string
                $projectFileFormatString += $line + "`r`n";


                # Line is a comment
                if ($line.Trim()[0] -eq [ProjectInformation]::__projectMetaDataCommentToken)
                { continue; }


                # Empty line
                if ([CommonIO]::IsStringEmpty($line))
                { continue; }


                # Project Name
                if ($line.Contains([ProjectInformation]::__projectFileVariable_ProjectName))
                { $projectFileStrings.Add([ProjectInformation]::__projectFileVariable_ProjectName, $line.Trim()); }


                # Project Website
                if ($line.Contains([ProjectInformation]::__projectFileVariable_ProjectWebsite))
                { $projectFileStrings.Add([ProjectInformation]::__projectFileVariable_ProjectWebsite, $line.Trim()); }


                # Project Output FileName
                if ($line.Contains([ProjectInformation]::__projectFileVariable_OutputFileName, $line))
                { $projectFileStrings.Add([ProjectInformation]::__projectFileVariable_OutputFileName, $line.Trim()); }
            } # foreach : Parse through Project File


            # Try to assign the values to their respective variables
            try
            {
                # Project's Name
                [ProjectInformation]::__projectName     = [string] ($projectFileStrings[[ProjectInformation]::__projectFileVariable_ProjectName]);


                # Project's Associated Website
                [ProjectInformation]::__projectWebsite  = [string] ($projectFileStrings[[ProjectInformation]::__projectFileVariable_ProjectWebsite]);


                # Compiled Output File Name for the Project.
                [ProjectInformation]::__outputName      = [string] ($projectFileStrings[[ProjectInformation]::__projectFileVariable_OutputFileName]);
            } # try : Assigning Values

            # Failed to set one of the values
            catch
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to properly read the," + [ProjectInformation]::__projectFileName + `
                                        ", Project File from " + $directoryInfo.Name + "!");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = (  "Project Source Directory was:`r`n" + `
                                                "`t`t" + [ProjectInformation]::__sourcePath + "`r`n" + `
                                                "`tProject File to Read was:`r`n" + `
                                                "`t`t" + $projectFilePath + "`r`n" + `
                                                "`tObtained Variable Values from Project File:`r`n" + `
                                                "`t`t - Project Name: "     + [ProjectInformation]::__projectName       + "`r`n" + `
                                                "`t`t - Project Website: "  + [ProjectInformation]::__projectWebsite    + "`r`n" + `
                                                "`t`t - Output Filename: "  + [ProjectInformation]::__outputName        + "`r`n" + `
                                                "`tProject File Contents Contains:`r`n" + `
                                                $projectFileFormatString);

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($logMessage, `            # Message to display
                                        [LogMessageLevel]::Error);  # Message level

                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *


                # Abort the operation
                return $false;
            } # Catch : Abort Operation



            # Now that we have the strings we need, we must remove the 'variable' + 'assignment delimiter',
            #   removing those two tokens, it leaves us with the value that we desire.
            # For example: AreYouCoolQuestion = IamAKoolCat_With_A_K
            #               We want "IamAKoolCat_With_A_K", removing everything before it.
            for([byte] $i = 0; $i -le $projectFileStrings.Count; $i++)
            {
                # Delimiter String Index Position
                [Int32] $indexPosition = 0;

                # Determine what string we want to change
                switch($i)
                {
                    # Project Name
                    0
                    {
                        # Get the position of the delimiter.
                        $indexPosition = [ProjectInformation]::__projectName.IndexOf([ProjectInformation]::__projectFileAssignmentDelimiter);

                        # Get the assigned value, removing everything before the value.
                        [ProjectInformation]::__projectName = [ProjectInformation]::__projectName.Substring($indexPosition + 1).Trim();

                        # Move on to the next string
                        break;
                    } # Project Name

                    # Project Website
                    1
                    {
                        # Get the position of the delimiter.
                        $indexPosition = [ProjectInformation]::__projectWebsite.IndexOf([ProjectInformation]::__projectFileAssignmentDelimiter);

                        # Get the assigned value, removing everything before the value.
                        [ProjectInformation]::__projectWebsite = [ProjectInformation]::__projectWebsite.Substring($indexPosition + 1).Trim();

                        # Move on to the next string
                        break;
                    } # Project Website

                    # Output Filename
                    2
                    {
                        # Get the position of the delimiter.
                        $indexPosition = [ProjectInformation]::__outputName.IndexOf([ProjectInformation]::__projectFileAssignmentDelimiter);

                        # Get the assigned value, removing everything before the value.
                        [ProjectInformation]::__outputName = [ProjectInformation]::__outputName.Substring($indexPosition + 1).Trim();

                        # Move on to the next string
                        break;
                    } # Output Filename
                } # Determine What String to Alter
            } # for : Get Assignment Values
        } # if : Project File was Found

        else
        {
            # Because the Project File was not found, we will populate only a few variables with what we have,
            #   which is only the directory name of the project.


            # Declarations and Initializations
            # ----------------------------------------
            # We will use this to obtain the Project Name from the Directory Name.
            [System.IO.DirectoryInfo] $directoryInfo = [ProjectInformation]::__sourcePath;
            # ----------------------------------------



            # Provide the Project Name
            [ProjectInformation]::__projectName = $directoryInfo.Name.ToString();

            # Provide the Output File Name
            [ProjectInformation]::__outputName = [ProjectInformation]::__projectName;

            # All other details is merely unknown to us.
            [ProjectInformation]::__projectWebsite = $NULL;
        } # else : Project File was not Found



        # Raise the flag signifying that a project had been loaded into the environment.
        if ([ProjectInformation]::__isLoaded -eq $false) { [ProjectInformation]::__isLoaded = $true; }



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Project has been successfully loaded into the environment!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = (  "Project Name is: "                 + [ProjectInformation]::__projectName       + "`r`n" + `
                                        "Project Website is: "              + [ProjectInformation]::__projectWebsite    + "`r`n" + `
                                        "Project Output Filename is: "      + [ProjectInformation]::__outputName        + "`r`n" + `
                                        "Project Source Files Located at: " + [ProjectInformation]::__sourcePath        + "`r`n" + `
                                        "Project Is Loaded Flag is: "       + [ProjectInformation]::__isLoaded          + "`r`n");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Finished with the operation
        return $true;
    } # Load()
} # ProjectInformation