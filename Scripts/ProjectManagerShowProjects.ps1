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
        # Show the instructions to the user
        [ProjectManagerShowProjects]::__DrawMainInstructions();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");

        return $false;
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





} # ProjectManagerShowProjects