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




<# Project Manager - Show Projects
 # ------------------------------
 # ==============================
 # ==============================
 # This class will allow the user to view all of the installed PowerShell Compact-Archive Tool projects
 #  within the program's environment.  This can be useful such that the user knows what packages had been
 #  installed.  Further, the user can use the information as a way to determine if a project should be
 #  removed, updated, or if there's a lack of a desired project - thus a potential installation.
 #>




class ProjectManagerShowProjects
{
   <# Project Manager Show Installation - Main Entry
    # -------------------------------
    # Documentation:
    #   This function guide the process of showing the installed projects to the user.
    #
    #  NOTE:
    #   This function should only be called by the Project Manager.
    # -------------------------------
    #>
    hidden static [bool] __Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will contain a list of projects that had been installed within the environment. 
        [System.Collections.ArrayList] $listOfProjectsInstalled = [System.Collections.ArrayList]::New();
        # ----------------------------------------



        # Show the instructions to the user
        [ProjectManagerShowProjects]::__DrawMainInstructions();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain a list of installed projects
        if ((![ProjectManagerCommon]::__GetInstalledProjects($listOfProjectsInstalled)) -or `   # Failure occurred
            ($NULL -eq $listOfProjectsInstalled)                                        -or `   # No installs found
            ($listOfProjectsInstalled.Count -eq 0))                                             # No installs found
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------
            # Generate the initial message
            [string] $logMessage = ("Unable to find any installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects.`r`n" + `
                                    "You may need to install new projects into $($GLOBAL:_PROGRAMNAME_).");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Installation Path for $($GLOBAL:_PROGRAMNAMESHORT_) Projects:`r`n"   + `
                                            "`t`t$($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Display a message to the user that there was no projects found and log that same message for
            #  referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                    # Message to display
                                        [LogMessageLevel]::Warning);    # Message level

            # Alert the user through a message box as well that an event had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Warning) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Finished; nothing more we can do.
            return $false;
        } # if : Unable to Obtain List of Installed Projects


        # Show the user the list of installed projects
        [ProjectManagerShowProjects]::__ShowListOfProjects($listOfProjectsInstalled);


        # Finished
        return $true;
    } # __Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Provide the instructions to the user regarding the process of how the content will be shown.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions()
    {
        # Show the instructions to the user.
        [Logging]::DisplayMessage( `
            " Viewing Installed $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                              + `
            "-------------------------------------------------------------------------------------------`r`n"       + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            "You will be able to see all of the $($GLOBAL:_PROGRAMNAMESHORT_) Projects that had been installed.`r`n"+ `
            "`r`n"                                                                                                  + `
            " The information regarding the projects will be shown in this format:`r`n"                             + `
            " ----------------------------------`r`n"                                                               + `
            "  - Folder Name`r`n"                                                                                   + `
            "    - Project Name`r`n"                                                                                + `
            "    - Project Revision`r`n"                                                                            + `
            " ----------------------------------`r`n"                                                               + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            " $($GLOBAL:_PROGRAMNAMESHORT_) Project Installation Path can be found at this location:`r`n"           + `
            "   $($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_)`r`n"                                             + `
            "`r`n`r`n");


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()




   <# Show List of Projects
    # -------------------------------
    # Documentation:
    #  When called, this function will show a list of installed projects to the user in a formatted list.
    # -------------------------------
    # Input: 
    #  [System.Collections.ArrayList] {ProjectMetaData} Installed Projects.
    #   This will provide information as to what projects had been installed within the program's environment.
    # -------------------------------
    #>
    hidden static [void] __ShowListOfProjects([System.Collections.ArrayList] $listOfProjects)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will be used for counting each project that was added to the array list.
        [UInt64] $itemCount = 1;
        # ----------------------------------------


        # Iterate through each installed projects
        foreach($item in $listOfProjects)
        {
            # Build the string
            [string] $projectInformation = ("$($itemCount). $($item.GetFileName())`r`n"             + `
                                            "   Project Name: $($item.GetProjectName())`r`n"        + `
                                            "   Revision:     $($item.GetProjectRevision())`r`n");


            # Show the message to the user.
            [Logging]::DisplayMessage($projectInformation);


            # Increment the Counter
            $itemCount++;
        } # foreach : Show Each Project


        # Allow the user to read the output
        [CommonIO]::FetchEnterKey();
    } # __ShowListOfProjects()
} # ProjectManagerShowProjects