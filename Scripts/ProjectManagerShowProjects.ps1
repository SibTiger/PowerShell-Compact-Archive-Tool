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
 # This class will allow the user to view all of the PSCAT projects that had already been installed within
 #  the PowerShell Compact-Archive Tool's environment.  With this ability, the user will be able to view
 #  what projects are installed along with its version.  Providing the user with this information, the user
 #  will be able to determine if the project needs to be removed or to update.
 #>




class ProjectManagerShowProjects
{
   <# Project Manager Show Installation - Main Entry
    # -------------------------------
    # Documentation:
    #  This function will provide the user with the ability to view what projects are presently installed
    #   within the program's environment.
    # -------------------------------
    #>
    static [void] Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will contain a list of projects that had been installed within the environment.
        [System.Collections.ArrayList] $listOfProjectsInstalled = [System.Collections.ArrayList]::New();
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that it is easier
        #   for the user to read the information presented.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Install Projects section.
        [CommonCUI]::DrawSectionHeader("Installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects");


        # Show the instructions to the user
        [ProjectManagerShowProjects]::__DrawMainInstructions();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain a list of installed projects
        if ((![ProjectManagerCommon]::__GetInstalledProjects($listOfProjectsInstalled)) -or `   # Failure occurred
            ($NULL                          -eq $listOfProjectsInstalled)               -or `   # No installs found
            ($listOfProjectsInstalled.Count -eq 0))                                             # No installs found
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------
            # Generate the initial message
            [string] $logMessage = ("Unable to find any installed $($GLOBAL:_PROGRAMNAMESHORT_) Projects!`r`n" + `
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
            return;
        } # if : Unable to Obtain List of Installed Projects


        # Show the user the list of installed projects
        [ProjectManagerCommon]::DrawTableProjectInformation($listOfProjectsInstalled);


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Allow the user to read the output
        [CommonIO]::FetchEnterKey();


        # Finished
        return;
    } # Main()




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
            " Shown below is a list of $($GLOBAL:_PROGRAMNAMESHORT_) Projects that had been installed"      + `
            " into $($GLOBAL:_PROGRAMNAME_)."                                                               );
    } # __DrawMainInstructions()
} # ProjectManagerShowProjects