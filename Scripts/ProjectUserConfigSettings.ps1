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




<# Project User Configuration - Settings
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to give the user the ability to configure their PowerShell Compact-Archive Tool
 #  Project User Configuration file for a desired project.  Within this class, it will contain menus such
 #  that the user can freely provide their desired preferences on a specific PSCAT project.
 #>




class ProjectUserConfigurationSettings
{
   <# Update Project Source Path
    # -------------------------------
    # Documentation:
    #  This function will allow the user to specify where the project's source files are located within
    #   their local system.
    # -------------------------------
    # Output:
    #   $true   = Successfully updated the PSCAT Project Configuration File
    #   $false  = Failed to update the PSCAT Project Configuration File.
    # -------------------------------
    #>
    static [bool] UpdateProjectSourcePath()
    {
        # ----------------------------------------
        # Grab the current instance of the Project Info.
        [ProjectInformation] $projectInfo = [ProjectInformation]::GetInstance();

        # The new path provided by the user.
        [string] $newPath = $NULL;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that it is easier
        #   for the user to read the information presented.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Update Project User Configuration Menu
        [CommonCUI]::DrawSectionHeader("Update $($projectInfo.GetProjectName()) Source Path");


        # Provide some whitespace padding
        [Logging]::DisplayMessage("`r`n");


        # Provide the instructions
        [ProjectUserConfigurationSettings]::__DrawProjectSourcePathInstructions();


        # Show the current path of the project's assets to the user, to help guide them with their selection.
        [Logging]::DisplayMessage("Current Project Source Path Location: $($projectInfo.GetProjectPath())")


        # Provide the Windows Directory Browser to the user
        if (![CommonGUI]::BrowseDirectory("Select $($projectInfo.GetProjectPath()) Source Path", `
                                        [BrowserInterfaceStyle]::Modern `,
                                        [ref] $newPath))
        {
            # User canceled the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("User had cancelled the operation; no source path had been selected.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Report that the user is cancelling the operation.
            return $false;
        } # if : User Canceled



        # Update the path as requested by the user
        if (!$projectInfo.SetProjectPath($newPath))
        {
            # Failed to update the Project's Source Path


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to update the project's source path.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = (  "Project Name: $($projectInfo.GetProjectName())`r`n"    + `
                                            "`tRequested Path: $($newPath)`r`n"                     + `
                                            "`tCurrent Path: $($project.GetProjectPath())");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Failed to update
            return $false;
        } # if : Failed to update Project Source Path




        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("Successfully updated the project's source path.");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = (  "Project Name: $($projectInfo.GetProjectName())`r`n" + `
                                        "`tSource Path: $($projectInfo.GetProjectPath())");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level


        # * * * * * * * * * * * * * * * * * * *


        # Operation was successful
        return $true;
    } # UpdateProjectSourcePath()




   <# Draw Project Source Path Instructions
    # -------------------------------
    # Documentation:
    #  Provide the instructions to the user regarding the process in order to revise the path to the projects
    #   source code and assets.
    # -------------------------------
    #>
    hidden static [void] __DrawProjectSourcePathInstructions()
    {
        # Show the instructions to the user.
        [Logging]::DisplayMessage( `
            " To change the $($projectInfo.GetProjectName())'s source location, you will be using the Windows`r`n"          + `
            "   Directory Browser to select a new path that contains the source material and assets for the`r`n"            + `
            "   $($projectInfo.GetProjectName()) project.`r`n"                                                              + `
            "`r`n"                                                                                                          + `
            " You may cancel the operation by selecting 'Cancel' from the Directory Browser.`r`n"                           + `
            "`r`n"                                                                                                          + `
            "`r`n"                                                                                                          );
    } # __DrawProjectSourcePathInstructions()
} # ProjectUserConfigurationSettings