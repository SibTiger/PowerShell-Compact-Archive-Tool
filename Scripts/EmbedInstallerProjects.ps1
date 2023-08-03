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




<# Embed Installer - Projects
 # ------------------------------
 # ==============================
 # ==============================
 # This class provides the ability to install new projects into the program's environment.
 #  As time continues, new projects and improvements with existing will be made available,
 #  this class needs to meet with these needs.  Further, we need to allow a simple guided
 #  steps to perform these actions.  Due to the nature of the terminal - the user will be
 #  intimidated with the console window with limited-ease, compared to a standard GUI
 #  application.  With this fact, we need to be sure we automate the process in such a
 #  way that it is easy for the user - which they just want to get work done and deal with
 #  no fuss.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this
 #  functionality easy for the user.
 #>




 class EmbedInstallerProjects
 {
    # Install Project(s)
    # -------------------------------
    # Documentation:
    #  This function will try to install the desired project(s) onto the
    #   user's system.  By doing this, we will need to assure that the
    #   environment is ready as well as possible updates to an already
    #   existing Burnt Toast installation.
    # -------------------------------
    # Input:
    #  [System.Collections.ArrayList] File Collection
    #   This will hold *.ZIP files that had been placed within the temporary directory.
    # -------------------------------
    # Output:
    #  Installation status
    #   true    = Installation was successful.
    #   false   = Installation had failed.
    # -------------------------------
    #>
    hidden static [bool] __InstallProjects([System.Collections.ArrayList] $temporaryDirectoryContents)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the user's Default Compressing object; this contains
        #  the user's preferences as to how the Archive ZIP module will be utilized within this
        #  application.
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();

        # Overall Status of the operation; we will return this value once the operation had been finished.
        #   By default, we will provide a true result - this will change if an error was caught.
        [Bool] $overallOperation = $true;
        # ----------------------------------------



        # Tell the user that we are now installing projects.
        [Logging]::DisplayMessage("Installing Project(s). . .`r`n");



        # Install each project provided.
        foreach ($item in $temporaryDirectoryContents)
        {
            # If the archive datafile is corrupted - then skip to the next file.
            if ($item.GetVerification() -ne [EmbedInstallerFileVerification]::Passed)
            {
                # Because this file could not be installed, flag this as a fault.
                $overallOperation = $false;


                # Continue to the next file.
                continue;
            } # if : Archive is Damaged


            # This string will provide a brief description of the installation activities, this will
            #   be used for logging purposes.
            [string] $logActivity = $null;

            # This will provide additional information that could be useful within the logfile,
            #   related to the operation.
            [string] $logAdditionalInformation = $null;

            # Extracted Directory Absolute Path.
            [string] $outputDirectory = $NULL;

            # Exit Status
            [bool] $exitCondition = $false;


            # Extract each project.
            $exitCondition = $defaultCompress.ExtractArchive($item.GetFilePath(), `
                                                            $($GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_HOME_PATH_), `
                                                            [ref] $outputDirectory);


            # Determine the operation
            #  If the installation had failed, than mark the Overall Operation as failed.
            if (!$exitCondition)
            {
                # Mark that the entire operation had failed; this will not be reset back to true.
                $overallOperation = $false;

                # Clear the Installation Path
                $item.SetFilePathAsEmpty();

                # Update the item's description to denote that a failure occurred.
                $item.SetMessage("Failed to install project file.");
            } # if : Operation Failed

            # If the installation was successful.
            else
            {
                # Mark that the file had been installed.
                $item.SetInstalled($true);

                # Store the extracted path
                $item.SetFilePath($outputDirectory);

                # Update the item's description to signify that the file had been installed.
                $item.SetMessage("Successfully installed!");
            } # else : Installation Successful


            # Generate the logged messages
            $logActivity = "Installation Results for: $($item.GetFileName())";
            $logAdditionalInformation = "Status: $($item.GetMessage())`r`n`tInstalled: $($exitCondition)`r`n`tInstalled Path: $($outputDirectory)";


            # Record the information to the program's logfile.
            [Logging]::LogProgramActivity($logActivity, `
                                        $logAdditionalInformation, `
                                        [LogMessageLevel]::Information);
        } # foreach : Extract Contents


        # Finished!
        return $overallOperation;
    } # __InstallProjects()
 } # EmbedInstallerProjects