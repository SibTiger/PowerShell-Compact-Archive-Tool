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




<# Project Manager - Uninstall Project(s)
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability for the user to uninstall PowerShell Compact-Archive Tool projects.
 #  Removing Projects will come necessary when needing to delete data this is no longer necessary, or
 #  if wanting to discard an outdated version for a newer version.  Or, hopefully never coming to this,
 #  discarding a buggy project version in exchange for cleaner version.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this functionality easy for the user.
 #>




class ProjectManagerUninstall
{
   <# Project Manager Uninstaller - Main Entry
    # -------------------------------
    # Documentation:
    #   This function will drive the uninstallation procedure such that the desired PSCAT Projects are
    #   safely removed from the environment.
    # -------------------------------
    #>
    hidden static [bool] __Main()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will contain what project (absolute path) to be uninstalled.
        [string] $projectToUninstall = $NULL;

        # Project's information within the meta data
        [ProjectMetaData] $projectInformation = [ProjectMetaData]::New();

        # This variable will be used as a confirmation string
        [string] $confirmString = "Are you sure you want to delete this project?`r`n";
        # ----------------------------------------



        # Provide the instructions
        [ProjectManagerUninstall]::__DrawMainInstructions();


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain the projects that the user wises to uninstall.
        if (![ProjectManagerUninstall]::__GetProjectToDelete([ref]$projectToUninstall))
        {
            # Alert the user that they had aborted the operation.
            [Logging]::DisplayMessage("User had aborted the uninstallation operation!`r`nReturning back to previous menu...");


            # Provide some whitespace padding
            [Logging]::DisplayMessage("`r`n`r`n");


            # Allow the user to see the feedback before returning back to the previous menu.
            [CommonIO]::FetchEnterKey();

            # Go back to the previous menu
            return $false;
        } # if : User Cancelled


        # Provide some whitespace padding
        [Logging]::DisplayMessage("`r`n`r`n");


        # Obtain the name of the project via the Meta
        if (![ProjectManagerCommon]::__ReadMetaFile($projectToUninstall + "\" + $GLOBAL:_META_FILENAME_,    `
                                                    [ref]$projectInformation))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to delete the desired project as the Project's Meta File could not be accessed!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project Target Path:`r`n"        + `
                                            "`t$($projectToUninstall)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Go back to the previous menu
            return $false;
        } # if : Unable to Fetch Meta File


        # Complete the Confirmation string with the project meta data that was obtained.
        $confirmString += ( "Name:      $($projectInformation.GetProjectName())`r`n"        + `
                            "Revision:  $($projectInformation.GetProjectRevision())`r`n"    + `
                            "Signature: $($projectInformation.GetGUID())`r`n"               + `
                            "Path:      $($projectToUninstall)");


        # Confirm that the user wants to remove the project
        if([CommonGUI]::MessageBox($confirmString,                              `
                                [System.Windows.MessageBoxImage]::Question,     `
                                [System.Windows.MessageBoxButton]::OKCancel,    `
                                [System.Windows.MessageBoxResult]::Cancel)      `
                                    -eq                                         `
                                [System.Windows.MessageBoxResult]::Cancel)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Uninstallation had been cancelled by the user!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project Target Path:`r`n"        + `
                                            "`t$($projectInformation)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                    # Initial message
                                        $logAdditionalMSG, `                # Additional information
                                        [LogMessageLevel]::Exclamation);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Warning);# Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Go back to the previous menu
            return $false;
        } # If : User Canceled the Operation


        # Delete the project as requested
        if(![CommonIO]::DeleteDirectory($projectToUninstall))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to thrash the desired directory!");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project Target Path:`r`n"        + `
                                            "`t$($projectInformation)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                    # Initial message
                                        $logAdditionalMSG, `                # Additional information
                                        [LogMessageLevel]::Error);          # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *
        } # If : Failure to Delete Directory 
        
        # Finished


        return $false;
    } # __Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Provide the instructions to the user regarding the process of uninstalling projects from the program's
    #   environment.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions()
    {   # Show the instructions to the user.
        [Logging]::DisplayMessage( `
            " Uninstalling $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                                   + `
            "-------------------------------------------------------------------------------------------`r`n"       + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            "To uninstall projects that had been installed into the $($GLOBAL:_PROGRAMNAME_), use the `r`n"         + `
            " Windows' Folder Browser to select the desired project that you want to remove.`r`n"                   + `
            " Only one project at a time can be removed.`r`n"                                                       + `
            "`r`n"                                                                                                  + `
            "`r`n"                                                                                                  + `
            "NOTE:`r`n"                                                                                             + `
            "`tTo abort this operation, you may select 'Cancel' in the Windows' Folder Browser.`r`n"                + `
            "`r`n`r`n");


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()




   <# Get a Project to Delete
    # -------------------------------
    # Documentation:
    #  This function is designed to give the user with the ability to specify what project that they wish to
    #   uninstall form the program's environment.
    #
    # NOTE: Because of how the Windows' Directory Browser works, only one directory at a time can be selected
    #           at a time.  Thus, the user cannot perform multiple directory selections.
    # -------------------------------
    # Input:
    #  [string] (REFERENCE) Project to Uninstall
    #   This will contain what PSCAT Project that the user wishes to uninstall.
    # -------------------------------
    # Output:
    #  Did the user User Provide a PSCAT Project?
    #   $true    = User Selected a Project
    #   $false   = User Cancelled
    # -------------------------------
    #>
    hidden static [bool] __GetProjectToDelete([ref] $projectToUninstall)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Browse File Title String
        [string] $windowsDirectoryBrowserInstructions = "Select a $($GLOBAL:_PROGRAMNAMESHORT_) Project to Uninstall.";
        # ----------------------------------------



        # Provide the Windows File Browser, giving the user with the ability to freely select one or more projects
        #   to remove.
        if (![CommonGUI]::BrowseDirectory($windowsDirectoryBrowserInstructions, `
                                            [BrowserInterfaceStyle]::Modern, `
                                            $false, `
                                            $GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_, `
                                            $projectToUninstall))
        {
            # User canceled the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("User had cancelled the operation; no project files were selected.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "$($NULL)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level


            # * * * * * * * * * * * * * * * * * * *


            # Report that the user is cancelling the operation.
            return $false;
        } # If : User Canceled



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("The user had selected a $($GLOBAL:_PROGRAMNAMESHORT_) Project to uninstall.");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("The following $($GLOBAL:_PROGRAMNAMESHORT_) Project had been selected:`r`n" + `
                                        "`t$($projectToUninstall.Value)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level


        # * * * * * * * * * * * * * * * * * * *



        # One or more files selected by user.
        return $true;
    } # __GetProjectToDelete()
} # ProjectManagerUninstall