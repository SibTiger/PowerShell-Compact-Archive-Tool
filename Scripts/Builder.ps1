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




<# Builder
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability to compile a project that had been loaded within the
 #  program's environment into an archive compressed file that can be loaded into the ZDoom
 #  based port, such as GZDoom, Zandronum, etc.
 #
 # Process of Compiling:
 #  1) Perform the prerequisite check
 #  2) Create the Output Directory for the Project
 #  3) Determine the Archive Filename
 #  4) Create a new temporary directory
 #  5) Duplicate the Project's Source Files into the newly created Temporary Directory
 #  6) Remove superfluous files and folders from the project's source files stored in the temporary directory.
 #  7) Compile the project's source files within the temporary directory.
 #  8) Delete the temporary directory
 #  9) - DONE -
 #>



class Builder
{
   <# Build
    # -------------------------------
    # Documentation:
    #  This function will drive the process to compile the desired project procedurally into a single
    #   compressed archive file.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true   = The project had been compiled successfully.
    #   $false  = The project could not be compiled.
    # -------------------------------
    #>
    static [bool] Build()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Archive datafile's final destination path
        [string] $compiledBuildPath = $null;

        # The file name for the archive datafile.
        [string] $fileName = $null;

        # The Temporary Directory path that will hold the project's contents.
        [string] $projectTemporaryPath = $null;
        # ----------------------------------------


        # Clear the terminal of all previous text; keep the space clean so that it is easy for the user to
        #   read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Main Menu
        [CommonCUI]::DrawSectionHeader("Compiling Project: $([ProjectInformation]::GetProjectName())");


        # Display the instructions
        [CommonCUI]::CompileInstructions();





        #           Prerequisite Check
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Make sure that we have all of the resources needed in order to compile the project.
        #   If the prerequisite check were to fail, then it is not possible to compile the project.
        if (![Builder]::__PrerequisiteCheck()) { return $false; }





        #        Generate Output Directory
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Create the Output Directory and get the Output Path for where the compiled build will be stored.
        #   If the directory could not be created, then we will abort the operation.
         if (![Builder]::__GenerateOutputPath([ref] $compiledBuildPath)) { return $false; }





        #            Generate Filename
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Get the filename that we will use for the compiled build of this project.
        [Builder]::__GenerateArchiveFileName([ref] $fileName);





        #         Create Temporary Directory
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Create a new temporary directory so we can duplicate the project's source files in this directory.
        #   We will later remove junk files\folders that we do not want in the final solution.
        # If we cannot create a temporary directory, then abort this operation.
        if (![Builder]::__CreateProjectTemporaryDirectory([ref] $projectTemporaryPath)) { return $false; }





        #         Mirror Project Files
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Duplicate the project's source files into the temporary directory.
        #   If we are unable to perform this action successfully, then we must stop the operation.
        if (![Builder]::__DuplicateSourceToTemporaryDirectory($projectTemporaryPath)) { return $false; }





        #        Thrash Superfluous Assets
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Discard any extraneous assets from the temporary directory.
        #  We are not interested in any fluff, as that can enlarge the final compile build.
        if (![Builder]::__ExpungeExtraneousResources($projectTemporaryPath))
        {
            # Because we could not delete the superfluous assets, we could not continue this operation.
            #  Now, with that, it could be possible to continue the operation as normal - having the extra
            #  assets that is unrelated to the game files or project in itself is not such a big deal,
            #  HOWEVER, it could be an issue if there are sensitive information that is not meant to be
            #  visible to other users - regardless where or what.

            # Thus, if we cannot expunge any of the superfluous data, then return an error signal.
            return $false;
        } # Could not Delete Superfluous Files





        #             Compile Project
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Create a compiled build of the project into a single archive data file.
        if (![Builder]::__CompileProject($fileName, `               # Archive filename
                                        $projectTemporaryPath, `    # Project's Temporary Directory Path
                                        $compiledBuildPath, `       # Output for the compiled build
                                        [ref]$compiledBuildPath))   # Archive file location (output file)
        {
            # Because there was an error while compiling the project's source
            #  files, we will have to abort at this point.
            return $false;
        } # if : Compile Project





        #         Delete Temporary Directory
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Delete the temporary directory as we no longer need this anymore.
        if (![Builder]::__DeleteProjectTemporaryDirectory($projectTemporaryPath))
        {
            # Because there was an error while trying to delete the temporary directory,
            #  we will land in this condition, but we may proceed onward regardless.
            # The Operating System may try to remove the directory in a later date by
            #  default.
            ;
        } # if : Cannot Create Temporary Directory





        #          Show Project Path
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Now that we are finished compiling the project, show the user where they can find their compiled build.
        [Builder]::__ShowProjectLocation($compiledBuildPath);





        # Alert the user that the operation was successful.
        [NotificationAudible]::Notify([NotificationAudibleEventType]::Success);


        # Show that the compiling operation was successful.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            [ProjectInformation]::GetProjectName() + " Had been compiled successfully!");


        # Operation was successful!
        return $true;
    } # Build()





   <# Prerequisite Check
    # -------------------------------
    # Documentation:
    #  This function performs a validation check to assure that all of the required resources are available
    #   for the compiling process.  If there some validation check fails within this function, than the
    #   entire prerequisite check will ultimately fail.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true   = All prerequisites had been satisfied.
    #   $false  = A required prerequisite had failed.
    # -------------------------------
    #>
    hidden static [bool] __PrerequisiteCheck()
    {
        # Show that the Prerequisite functionality is presently active
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Prerequisite Check");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::InProgress, `
                                            "Performing a Prerequisite Check. . .");




        #              Project Path
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *



        # Can we find the project's source files?
        if (![CommonIO]::CheckPathExists([ProjectInformation]::GetSourcePath(), $true))
        {
            # Unable to find the project's source files; unable to continue.

            # Alert the user that an error had been reached.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show that the Project's source files could not be found.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Failure, `
                                                "Unable to find $([ProjectInformation]::GetProjectName()) source files!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Please load a project into $($GLOBAL:_PROGRAMNAMESHORT_)!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Unable to compile $([ProjectInformation]::GetProjectName()) at this time.");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I am unable to find $([ProjectInformation]::GetProjectName()) source files!`r`n" + `
                                            "Please make sure that the project, $([ProjectInformation]::GetProjectName()), " + `
                                                "source files exists within the given path:`r`n" + `
                                            "`t$([ProjectInformation]::GetSourcePath())");

            # Generate the initial message
            [string] $logMessage = "Unable to find the project, $([ProjectInformation]::GetProjectName()), source files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project Name:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetProjectName() + "`r`n" + `
                                        "`tProject Path:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetSourcePath() + "`r`n" + `
                                        "`tPowerShell Core Version:`r`n" + `
                                        "`t`t" + [SystemInformation]::PowerShellVersion() + "`r`n" + `
                                        "`tOperating System:`r`n" + `
                                        "`t`t" + [SystemInformation]::OperatingSystem());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because we cannot find the project's source files, we have to abort the operation.
            return $false;
        } # if : Check Project source files exists



        # Successfully found project files
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Successful, `
                                            "Found $([ProjectInformation]::GetProjectName()) source files!");

        # Show the path to the project's source files
        [Builder]::__DisplayBulletListMessage(3, `
                                            [FormattedListBuilder]::NoSymbol, `
                                            [ProjectInformation]::GetSourcePath());




        #              Output Path
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *



        # Can we find the output path?
        if (![CommonIO]::CheckPathExists($GLOBAL:_OUTPUT_BUILDS_PATH_, $true))
        {
            # Unable to find the output path directory; unable to continue.

            # Alert the user that an error had been reached.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show that the Output Directory could not be found.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Failure, `
                                                "Unable to find the Output Directory!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "It seems $($GLOBAL:_PROGRAMNAMESHORT_) couldn't create $($GLOBAL:_OUTPUT_BUILDS_PATH_)....");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Unable to compile $([ProjectInformation]::GetProjectName()) at this time.");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I cannot find the folder to store any new compiled builds!`r`n" + `
                                            "$($GLOBAL:_PROGRAMNAMESHORT_) usually creates this for you, but " + `
                                                "it seems that the directory does not exist.`r`n" + `
                                            "To circumvent this error, you can try to create this folder:`r`n" + `
                                            "`t$($GLOBAL:_OUTPUT_BUILDS_PATH_)");

            # Generate the initial message
            [string] $logMessage = "Unable to find the Output Directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The Output Directory does not seem to exist....`r`n" + `
                                        "`tPlease make sure that you have the sufficient privileges to create " + `
                                            "folders in:`r`n" + `
                                        "`t`t" + $(FetchPathUserDocuments) + "`r`n" + `
                                        "`tOutput Path is:`r`n" + `
                                        "`t`t" + $GLOBAL:_OUTPUT_BUILDS_PATH_ + "`r`n" + `
                                        "`tPowerShell Core Version:`r`n" + `
                                        "`t`t" + [SystemInformation]::PowerShellVersion() + "`r`n" + `
                                        "`tOperating System:`r`n" + `
                                        "`t`t" + [SystemInformation]::OperatingSystem() + "`r`n" + `
                                        "`tProject Name:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetProjectName() + "`r`n" + `
                                        "`tProject Path:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetSourcePath());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `   # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because we cannot find the output directory, we have no place to store the compile build.
            #   We cannot continue this operation.
            return $false;
        } # if : Check Output Path exists



        # Successfully found output directory
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Successful, `
                                            "Found the Output Directory!");

        # Show the path of the output directory path.
        [Builder]::__DisplayBulletListMessage(3, `
                                            [FormattedListBuilder]::NoSymbol, `
                                            $GLOBAL:_OUTPUT_BUILDS_PATH_);




        #            Compression Tool
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *



        # Make sure that the Compression POSH Module exists.
        if (![ArchiveZip]::DetectCompressModule())
        {
            # Unable to find the compression POSH module

            # Alert the user that an error had been reached.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show that this program cannot detect the compression PowerShell Module.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Failure, `
                                                "Unable to find the Compression PowerShell Module!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Please make sure that you have the latest version of PowerShell Core.");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Unable to compile $([ProjectInformation]::GetProjectName()) at this time.");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I am unable to find the Compression PowerShell Module within the current session!`r`n" + `
                                            "Please make sure that you have the latest version of PowerShell Core:`r`n" + `
                                            "`thttps://github.com/PowerShell/PowerShell/releases`r`n" + `
                                            "Your version of PowerShell Core is:`r`n" + `
                                            "`t" + [SystemInformation]::PowerShellVersion());

            # Generate the initial message
            [string] $logMessage = "Unable to find the Compression PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please make sure you have the latest version of PowerShell Core installed.`r`n" + `
                                        "`tPowerShell Core Version:`r`n" + `
                                        "`t`t" + [SystemInformation]::PowerShellVersion() + "`r`n" + `
                                        "`tOperation System:`r`n" + `
                                        "`t`t" + [SystemInformation]::OperatingSystem() + "`r`n" + `
                                        "`tPowerShell Core Release Page on GitHub:`r`n" + `
                                        "`t`thttps://github.com/PowerShell/PowerShell/releases");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because we cannot find the Compression PowerShell Module within the current session, we
            #  cannot proceed forward with the compiling phase.
            return $false;
        } # if : Check if the Compression POSH Module Exists



        # If we made it this far, than we found everything we need to do compile this project!
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully found all of the required resources!");




        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = ("All of the prerequisites needed to compile $([ProjectInformation]::GetProjectName()) were found!");

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Project Name:`r`n" + `
                                    "`t`t" + [ProjectInformation]::GetProjectName() + "`r`n" + `
                                    "`tProject Path:`r`n" + `
                                    "`t`t" + [ProjectInformation]::GetSourcePath() + "`r`n" + `
                                    "`tOutput Path:`r`n" + `
                                    "`t`t" + $GLOBAL:_OUTPUT_BUILDS_PATH_ + "`r`n" + `
                                    "`tPowerShell Core Version:`r`n" + `
                                    "`t`t" + [SystemInformation]::PowerShellVersion() + "`r`n" + `
                                    "`tOperating System:`r`n" + `
                                    "`t`t" + [SystemInformation]::OperatingSystem());

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Prerequisite check passed!
        return $true;
    } # __PrerequisiteCheck()





   <# Generate Archive Filename
    # -------------------------------
    # Documentation:
    #  This function will generate the project's compiled filename.
    # -------------------------------
    # Input:
    #   [string] (REFERENCE) Filename of the compiled build
    #       The name of the archive datafile that will be generated.
    # -------------------------------
    #>
    hidden static [void] __GenerateArchiveFileName([ref] $fileName)
    {
        # Show that we are generating the filename for the compiled build.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Generating the output filename for $([ProjectInformation]::GetProjectName()). . .");



        # Assign the filename of the build
        $fileName.Value = [ProjectInformation]::GetOutputName();



        # Show the filename that has been generated.
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully generated the filename!");
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Child, `
                                            "File Name is `"$($fileName.Value)`".");
    } # __GenerateArchiveFileName()





   <# Generate Output Path
    # -------------------------------
    # Documentation:
    #  This function will determine where the compiled build will be stored within the host system's
    #   filesystem.  We will want to place the builds in their respective project names.
    # -------------------------------
    # Input:
    #  [string] (REFERENCE) Compile Output Path
    #   The location where the compiled build will be stored.
    # -------------------------------
    # Output: 
    #  [bool] Exit code
    #   $true   = Operation was successful.
    #   $false  = Failed to create the directory.
    # -------------------------------
    #>
    hidden static [bool] __GenerateOutputPath([ref] $compileOutputPath)
    {
        # Show that we determining the final output location
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Create the Output Directory for $([ProjectInformation]::GetProjectName()). . .");


        # Assign the new path that relates to the project we want to compile.
        $compileOutputPath.Value = $GLOBAL:_OUTPUT_BUILDS_PATH_ + "/" + [ProjectInformation]::GetProjectName();


        # Create the directory, if it doesn't already exists within the filesystem.
        #   If we are unable to create the directory, then report back that an error had occurred.
        if (([CommonIO]::CheckPathExists($compileOutputPath.Value, $true)   -eq $false) -and `  # Directory does not exist
            ([CommonIO]::MakeDirectory($compileOutputPath.Value)            -eq $false))        # Unable to create the directory
        {
            # Unable to create the output directory needed to store builds from this project.

            # Alert the user that an error had been reached.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show that we could not create the output directory for this project.
            [Builder]::__DisplayBulletListMessage(1, `
                                                [FormattedListBuilder]::Failure, `
                                                "Unable to create the Output Directory for " + [ProjectInformation]::GetProjectName() + "!");
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Tried to create the directory: " + $compileOutputPath.Value);
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Unable to compile $([ProjectInformation]::GetProjectName()) at this time.");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I am unable to create the output directory for $([ProjectInformation]::GetProjectName())!`r`n" + `
                                            "To circumvent this error, you can try to create this folder:`r`n" + `
                                            "`t" + $compileOutputPath.Value);

            # Generate the initial message
            [string] $logMessage = "Unable to create the Output Directory for this project, " + [ProjectInformation]::GetProjectName();

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Project Name:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetProjectName() + "`r`n" + `
                                        "`tProject Path:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetSourcePath() + "`r`n" + `
                                        "`tOutput Path:`r`n" + `
                                        "`t`t" + $GLOBAL:_OUTPUT_BUILDS_PATH_ + "`r`n" + `
                                        "`tOutput Path for this Project:`r`n" + `
                                        "`t`t" + $compileOutputPath.Value + "`r`n" + `
                                        "`tPowerShell Core Version:`r`n" + `
                                        "`t`t" + [SystemInformation]::PowerShellVersion() + "`r`n" + `
                                        "`tOperating System:`r`n" + `
                                        "`t`t" + [SystemInformation]::OperatingSystem());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because we could not create the output directory for this project, return back when an error.
            return $false;
        } # if : Unable to Create Output Directory for this Project



        # Show that we are finished.
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully created the Output Directory for" + [ProjectInformation]::GetProjectName() + "!");
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Child, `
                                            "Output Directory for " + [ProjectInformation]::GetProjectName());
        [Builder]::__DisplayBulletListMessage(3, `
                                            [FormattedListBuilder]::NoSymbol, `
                                            $compileOutputPath.Value);



        # Operation was successful
        return $true;
    } # __GenerateOutputPath()





   <# Compile Project
    # -------------------------------
    # Documentation:
    #  This function will compile the project source files at a designated path into a single archive data
    #   file, the compiled build.  The compiled build will be stored in the output directory specified.
    #
    # NOTE:
    #   The final filename of the archive file may diff if additional builds exists within the same output
    #   directory.
    # -------------------------------
    # Input:
    #  [string] Archive Filename
    #   The requested filename of the archive data file that is going to be created.
    #  [string] Project's Directory
    #   This provides the location of where the project source files are located.
    #  [string] Output Directory
    #   This is the directory where the project's compiled build will be stored.
    #  [string] (REFERENCE) File Path
    #   The final absolute path to the archive datafile within the filesystem.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true   = Successfully compiled the project.
    #   $false  = Failed to compile the project.
    # -------------------------------
    #>
    hidden static [bool] __CompileProject([string] $archiveFileName, `  # Requested archive datafile
                                        [string] $projectPath, `        # Absolute Path of the Temporary Directory Project location
                                        [string] $outputPath, `         # Output of where the compiled build will be stored.
                                        [ref] $filePath)                # Absolute Path of the Archive datafile
    {
        # Show that we are about to compact the project's source files into an archive datafile.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Compile the $([ProjectInformation]::GetProjectName()) project");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::InProgress, `
                                            "Compiling $([ProjectInformation]::GetProjectName()). . .");


        # Show that we are using the Compression PowerShell Module
        #   NOTE: The Module is hardcoded and I don't want to expose it in ArchiveZip class - because POSH
        #           does not have a way to make it unmutable without using the 'Set-Variable' CMDLet.
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::InProgress, `
                                            "NOTE: Compressing Files using the Microsoft.PowerShell.Archive Built-in PowerShell Module. . .");

        # Compact the files
        if (![ArchiveZip]::CreateArchive($archiveFileName, `
                                        $outputPath, `
                                        $projectPath, `
                                        $filePath))
        {
            # Reached an error while trying to compact the files.

            # Alert the user that an error had been reached.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # An error had been reached while compacting the project's files.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Failure, `
                                                "An error had occurred while compiling $([ProjectInformation]::GetProjectName())!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Please review the logfiles for more information!");
            [Builder]::__DisplayBulletListMessage(3, `
                                                [FormattedListBuilder]::NoSymbol, `
                                                "Unable to compile $([ProjectInformation]::GetProjectName()) at this time.");



            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("Failed to compile $([ProjectInformation]::GetProjectName())!`r`n" + `
                                            "Please inspect the logfile for what had caused the problem to occur.");

            # Generate the initial message
            $logMessage = "An error had been reached while compiling $([ProjectInformation]::GetProjectName())!";

            # Generate any additional information that might be useful
            $logAdditionalMSG = ("Compression Tool:`r`n" + `
                                "`t`tMicrosoft.PowerShell.Archive [Built-in]`r`n" + `
                                "`tArchive File Name Requested:`r`n" + `
                                "`t`t" + $archiveFileName + "`r`n" + `
                                "`tOutput Path:`r`n" + `
                                "`t`t" + $outputPath + "`r`n" + `
                                "`tProject Path:`r`n" + `
                                "`t`t" + $projectPath + "`r`n" + `
                                "`tEntire Path (Optional):`r`n" + `
                                "`t`t" + $filePath.Value);

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because the compiling process had reached an error, return a failure signal.
            return $false;
        } # If : Compiling Project Reached an Error



        # If we made it this far, that means that the operation was successful!
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully compiled $([ProjectInformation]::GetProjectName())!");
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Child, `
                                            "Compiled Build Path is: " + $filePath.Value);



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        $logMessage = "Successfully compiled the $([ProjectInformation]::GetProjectName()) project!";

        # Generate any additional information that might be useful
        $logAdditionalMSG = ("Compression Tool:`r`n" + `
                                "`t`tMicrosoft.PowerShell.Archive [Built-in]`r`n" + `
                                "`tArchive File Name Requested:`r`n" + `
                                "`t`t" + $archiveFileName + "`r`n" + `
                                "`tOutput Path:`r`n" + `
                                "`t`t" + $outputPath + "`r`n" + `
                                "`tProject Path:`r`n" + `
                                "`t`t" + $projectPath + "`r`n" + `
                                "`tEntire Path:`r`n" + `
                                "`t`t" + $filePath.Value);

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Operation was successful
        return $true;
    } # __CompileProject()





   <# Create Project Temporary Directory
    # -------------------------------
    # Documentation:
    #  This function will create a new temporary directory, which can then be used during the
    #   compiling process.  Where we can then duplicate the project's source files into this
    #   directory and provide any changes as necessary in the final solution.
    # -------------------------------
    # Input:
    #  [string] (REFERENCE) Temporary Directory Path
    #   Once populated, this will hold the temporary directory's absolute location.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true  = Successfully created the temporary directory.
    #   $false = Failed to create the temporary directory.
    # -------------------------------
    #>
    hidden static [bool] __CreateProjectTemporaryDirectory([ref] $directoryPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will provide the key term of the temporary directory we want create.
        [string] $directoryKeyTerm = "Compile_" + [ProjectInformation]::GetOutputName();
        # ----------------------------------------



        # Show that we trying to create a temporary directory
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Creating a new temporary directory. . .");


        # Create the temporary directory
        if (![CommonIO]::MakeTempDirectory($directoryKeyTerm, $directoryPath))
        {
            # Failed to create the temporary directory!

            # Alert the user that an error had been reached
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show the user that an error had been reached while creating the temporary directory.
            [Builder]::__DisplayBulletListMessage(1, `
                                                [FormattedListBuilder]::Failure, `
                                                "Unable to create the temporary directory!");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I was unable to create the temporary directory!`r`n" + `
                                            "Please make sure that you have the sufficient privileges to " + `
                                                "create a temporary directory in:`r`n" + `
                                            "`t" + $ENV:TEMP);

            # Generate the initial message
            [string] $logMessage = "Unable to create a temporary directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have sufficient privileges to create a " + `
                                            "temporary directory.`r`n" + `
                                        "`tTemporary Directory Root Location:`r`n" + `
                                        "`t`t" + $ENV:TEMP + "`r`n" + `
                                        "`tTemporary Directory Key Term:`r`n" + `
                                        "`t`t" + $directoryKeyTerm + "`r`n" + `
                                        "`tProject Name:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetProjectName());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level


            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *



            # Operation had failed
            return $false;
        } # if : Failed to Create Temp. Directory



        # Successfully created the temporary directory
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully created a temporary directory!");
        [Builder]::__DisplayBulletListMessage(2, `
                                            [FormattedListBuilder]::Child, `
                                            "Path to the Temporary Directory is: " + $directoryPath.Value);



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully created a temporary directory!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Project Name:`r`n" + `
                                    "`t`t" + [ProjectInformation]::GetProjectName() + "`r`n" + `
                                    "`tTemporary Directory Root Location:`r`n" + `
                                    "`t`t" + $ENV:TEMP + "`r`n" + `
                                    "`tTemporary Directory Key Term:`r`n" + `
                                    "`t`t" + $directoryKeyTerm);

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Operation was successful!
        return $true;
    } # __CreateProjectTemporaryDirectory()





   <# Duplicate Source Files to Temporary Directory.
    # -------------------------------
    # Documentation:
    #  This function will duplicate the project's source files in to the temporary directory.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory Path
    #   This contains the destination path that will have the source files.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true  = Successfully duplicated the project's contents.
    #   $false = Failed to duplicate the project's contents.
    # -------------------------------
    #>
    static hidden [bool] __DuplicateSourceToTemporaryDirectory([string] $projectTemporaryPath)
    {
        # Show that we are about to duplicate the project's source files to the temp. directory.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Duplicating $([ProjectInformation]::GetProjectName()) source files. . .");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Child, `
                                            "Source: $([ProjectInformation]::GetSourcePath())");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Child, `
                                            "Destination: $($projectTemporaryPath)");


        # Try to duplicate the files
        if (![CommonIO]::CopyDirectory("$([ProjectInformation]::GetSourcePath())\*",    # Source Directory
                                        $projectTemporaryPath))                         # Destination Directory
        {
            # Alert the user that an error had been reached
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


            # Show the user that an error had been reached while duplicating the project's files.
            [Builder]::__DisplayBulletListMessage(1, `
                                                [FormattedListBuilder]::Failure, `
                                                "Failed to duplicate the project's resources!");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I was not able to duplicate $([ProjectInformation]::GetProjectName()) assets to the temporary directory!");

            # Generate the initial message
            [string] $logMessage = "Unable to duplicate $([ProjectInformation]::GetProjectName()) assets to the temporary directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Directories:`r`n" + `
                                        "`tTemporary Directory Root Location:`r`n" + `
                                        "`t`t" + $ENV:TEMP + "`r`n" + `
                                        "`tTemporary Directory Location:`r`n" + `
                                        "`t`t" + $projectTemporaryPath + "`r`n" + `
                                        "`t" + [ProjectInformation]::GetProjectName() + " Source Location:`r`n" + `
                                        "`t`t" + [ProjectInformation]::GetSourcePath());

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *

            # Operation had failed
            return $false;
        } # if : Failed to duplicate resources


        # Successfully duplicated the project's resources
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully duplicated " + [ProjectInformation]::GetProjectName() + " assets!");



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully duplicated $([ProjectInformation]::GetProjectName()) assets!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Directories:`r`n" + `
                                    "`tTemporary Directory Root Location:`r`n" + `
                                    "`t`t" + $ENV:TEMP + "`r`n" + `
                                    "`tTemporary Directory Location:`r`n" + `
                                    "`t`t" + $projectTemporaryPath + "`r`n" + `
                                    "`t" + [ProjectInformation]::GetProjectName() + " Source Location:`r`n" + `
                                    "`t`t" + [ProjectInformation]::GetSourcePath());

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Operation was successful!
        return $true;
    } # __DuplicateSourceToTemporaryDirectory()





   <# Delete Project Temporary Directory
    # -------------------------------
    # Documentation:
    #  This function will delete the temporary directory that was used to compile the project's source
    #   files into a archive data file.
    #
    # NOTE:
    #   If incase this function returns an error, the Windows Operating System will automatically delete the
    #   folder in a later date by default.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory Path
    #   This provides the temporary directory path that is to be deleted.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true  = Successfully deleted the temporary directory.
    #   $false = Failed to delete the temporary directory.
    # -------------------------------
    #>
    hidden static [bool] __DeleteProjectTemporaryDirectory([string] $projectTemporaryPath)
    {
        # Show that we trying to delete the temporary directory
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Deleting the temporary directory. . .");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::InProgress, `
                                            "Deleting Folder: " + $projectTemporaryPath)


        # Delete the temporary directory and all of the data within.
        if (![CommonIO]::DeleteDirectory($projectTemporaryPath))
        {
            # Failed to delete the temporary directory


            # Alert the user that an error had been reached
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Show the user than an error had been reached while deleting the temporary directory.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Warning, `
                                                "Unable to delete the temporary directory!");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I was unable to delete the project's temporary directory.`r`n" + `
                                            "Make sure that you have sufficient privileges to delete the temporary directory.`r`n" + `
                                            "The Windows Operating System will automatically delete this folder in a later date.");

            # Generate the initial message
            [string] $logMessage = "Unable to delete the temporary directory!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Please assure that you have sufficient privileges to delete a temporary directory.`r`n" + `
                                        "`tIf the directory cannot be discarded, then the Windows Operating System may do so " + `
                                            "automatically at a later time.`r`n" + `
                                        "`tTemporary Directory Root Location:`r`n" + `
                                        "`t`t" + $env:TEMP + "`r`n" + `
                                        "`tTemporary Directory Location:`r`n" + `
                                        "`t`t" + $projectTemporaryPath);

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Warning);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Warning);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *



            # Operation had failed
            return $false;
        } # if: Failed to Delete Directory



        # Successfully deleted the temporary directory
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully deleted the temporary directory!");



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully deleted the temporary directory!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("`tTemporary Directory Root Location:`r`n" + `
                                        "`t`t" + $ENV:TEMP + "`r`n" + `
                                        "`tTemporary Directory Location:`r`n" + `
                                        "`t`t" + $projectTemporaryPath);

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                    $logAdditionalMSG, `        # Additional information
                                    [LogMessageLevel]::Verbose);  # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Operation was successful!
        return $true;
    } # __DeleteProjectTemporaryDirectory()





   <# Expunge Extraneous Resources
    # -------------------------------
    # Documentation:
    #  This function will delete files and folders that are deemed unnecessary.  These can range from
    #   Git SCM, Subversion, Operating System Shell [Desktop.ini, etc], etc. files and folders.
    # -------------------------------
    # Input:
    #  [string] Temporary Directory Path
    #   This provides the temporary directory location that we want to expunge superfluous files and folders.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $true  = Successfully expunged the superfluous files and folders.
    #   $false = Failed to expunge the superfluous files and\or folders
    # -------------------------------
    #>
    hidden static [bool] __ExpungeExtraneousResources([string] $temporaryDirectoryPath)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Known list of files and folders that are to be removed.
        [System.Collections.ArrayList] $foldersToDelete = [System.Collections.ArrayList] @();
        [System.Collections.ArrayList] $filesToDelete   = [System.Collections.ArrayList] @();
        # ----------------------------------------



        # Populate the arrays with what we want to delete
        # - - - - - - - - - - - - - - - - - - - - - - - - -
        # = = = = = = = = = = = = = = = = = = = = = = = = =
        # Directories to Remove
        # - - - -
        $foldersToDelete.Add("$($temporaryDirectoryPath)\.git");    # SCM Git
        $foldersToDelete.Add("$($temporaryDirectoryPath)\.svn");    # SCM Subversion


        # Files to Remove
        # - - - -
        $filesToDelete.Add(".gitattributes");                       # File Attributes and Behavior for a Git Repo
        $filesToDelete.Add(".gitignore");                           # Ignore specific files and folders within a Git Repo
        $filesToDelete.Add("*.md");                                 # GitHub Markdown files, such as readme.md
        $filesToDelete.Add("Thumb.dbs");                            # WINDOWS: Picture thumbnail database
        $filesToDelete.Add("desktop.ini");                          # WINDOWS: Explorer Properties for a specific folder




        # Show that we are about to expunge superfluous files and directories.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "Deleting unnecessary files and folders. . .");

        # Show that we are trying to delete unnecessary directories
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::InProgress,
                                            "Deleting unnecessary folders. . .");


        # Scan through all directories in the list
        foreach($i in $foldersToDelete)
        {
            # Delete the desired directory
            if (![CommonIO]::DeleteDirectory($i))
            {
                # Unable to delete the desired directory

                # Alert the user that an error had been reached.
                [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);


                # Show that the directory could not be deleted.
                [Builder]::__DisplayBulletListMessage(2, `
                                                    [FormattedListBuilder]::Failure, `
                                                    "Unable to delete folder: $($i)!");



                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate a message to display to the user.
                [string] $displayErrorMessage = ("Unable to delete a redundant folder: $($i)`r`n" + `
                                                "Please inspect the logfile for what had caused the problem to occur.");

                # Generate the initial message
                [string] $logMessage = "An error had been reached while removing superfluous directories!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Unable to delete directory: $($i)`r`n" + `
                                                "`tAdditional directories to be removed:`r`n" + `
                                                "`t`t - $($foldersToDelete -join "`r`n`t`t - ")");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                            [LogMessageLevel]::Error);  # Message level

                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *



                # Because we cannot delete the requested directory, we have to abort the operation.
                return $false;
            } # If : Failed to delete directory


            # Show what directory had been removed.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Child,
                                                "Deleted Folder: " + $i);
        } # Foreach: Delete Directories



        # - - - - - -



        # Show that we are trying to delete unnecessary files
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::InProgress, `
                                            "Deleting unnecessary files. . .");


        # Scan through all files in the list
        foreach($i in $filesToDelete)
        {
            # Delete the desired file(s) - using the Recursive flag
            if (![CommonIO]::DeleteFile($temporaryDirectoryPath, $i, $true))
            {
                    # Unable to delete the desired file
    
                    # Alert the user that an error had been reached.
                    [NotificationAudible]::Notify([NotificationAudibleEventType]::Error);
    
    
                    # Show that the file could not be deleted.
                    [Builder]::__DisplayBulletListMessage(2, `
                                                        [FormattedListBuilder]::Failure, `
                                                        "Unable to delete file: $($i)");    
    
    
                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------
    
                    # Generate a message to display to the user.
                    [string] $displayErrorMessage = ("Unable to delete a redundant file: $($i)`r`n" + `
                                                    "Please inspect the logfile for what had caused the problem to occur.");
    
                    # Generate the initial message
                    [string] $logMessage = "An error had been reached while removing superfluous files!";
    
                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = ("Unable to delete file: $($i)`r`n" + `
                                                    "`tAdditional files to be removed:`r`n" + `
                                                    "`t`t - $($filesToDelete -join "`r`n`t`t - ")");
    
                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                $logAdditionalMSG, `        # Additional information
                                                [LogMessageLevel]::Error);  # Message level
    
                    # Display a message to the user that something went horribly wrong
                    #  and log that same message for referencing purpose.
                    [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                                [LogMessageLevel]::Error);  # Message level
    
                    # Alert the user through a message box as well that an issue had occurred;
                    #   the message will be brief as the full details remain within the terminal.
                    [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;
    
                    # * * * * * * * * * * * * * * * * * * *
    
    
    
                    # Because we cannot delete the requested file, we have to abort the operation.
                    return $false;
            } # If : Failed to delete file(s) - with Recursive Flag


            # Show what file had been removed.
            [Builder]::__DisplayBulletListMessage(2, `
                                                [FormattedListBuilder]::Child,
                                                "Deleted File: " + $i);
        } # Foreach: Delete Files



        # Successfully deleted unnecessary resources
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Successful, `
                                            "Successfully deleted unnecessary files and folders!");



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully removed unnecessary files and directories!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Files that were removed:`r`n" + `
                                    "`t`t - $($foldersToDelete -join "`r`n`t`t - ")`r`n" + `
                                    "`tDirectories that were removed: `r`n" + `
                                    "`t`t - $($filesToDelete -join "`r`n`t`t - ")");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # The operation was successful
        return $true;
    } # __ExpungeExtraneousResources()





   <# Show Project Location
    # -------------------------------
    # Documentation:
    #  This function will present, to the user, where the compiled build of the project had been stored.
    # -------------------------------
    # Input:
    #  [string] Project Path
    #   The absolute path of the compiled project within the filesystem.
    # -------------------------------
    #>
    hidden static [void] __ShowProjectLocation([string] $projectPath)
    {
        # Present the location of the compiled build to the user.
        [Builder]::__DisplayBulletListMessage(0, `
                                            [FormattedListBuilder]::Parent, `
                                            "You will find `"$([System.IO.Path]::GetFileName($projectPath))`" in this location:");
        [Builder]::__DisplayBulletListMessage(1, `
                                            [FormattedListBuilder]::Child, `
                                            $projectPath);

        # Reveal the compiled build to the user by using the Windows File Explorer.
        [CommonIO]::AccessDirectory([System.IO.Path]::GetDirectoryName($projectPath), `
                                    [System.IO.Path]::GetFileName($projectPath));
    } # __ShowProjectLocation()





   <# Display Bullet List Message
    # -------------------------------
    # Documentation:
    #  This function will present status message to the user as the Builder performs the compiling operation.
    # -------------------------------
    # Input:
    #  [unsigned int] Message Position
    #   The position of the message that is to be displayed.  The position entails as to how many indentions
    #       are required before displaying the message.
    #  [FormattedListBuilder] Message Type
    #   The type of message that is to be presented to the user.  This usually could be a simple bullet list
    #       or provide a unique character for the message based on certain events.
    #  [string] Message String
    #   The message that will be displayed to the user.
    # -------------------------------
    #>
    hidden static [void] __DisplayBulletListMessage([uint] $messagePosition, `              # How many indentions before message
                                                    [FormattedListBuilder] $messageType, `  # Type of list or message
                                                    [string] $messageString)                # Initial message to display
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the desired bullet point symbol or any special symbol that matches with the type of
        #   the message.
        [char] $bulletCharacter = $null;

        # Symbols that will be used when providing a list.
        [char] $symbolParent        = '>';     # Main Operation
        [char] $symbolChild         = '-';     # Sub-Main Operation
        [char] $symbolInProgress    = '-';     # Task presently running
        [char] $symbolSuccessful    = '-';     # Operation finished successfully
        [char] $symbolWarning       = '!';     # Reached a warning case
        [char] $symbolFailure       = '!';     # Operation reached an error
        [char] $symbolNoSymbol      = ' ';     # Generic message with on symbol.
        # ----------------------------------------



        # Determine which symbol to use
        switch ($messageType)
        {
            # Parent
            ([FormattedListBuilder]::Parent)
            {
                # Use the Parent Symbol
                $bulletCharacter = $symbolParent;

                # Finished
                break;
            } # Parent


            # Child
            ([FormattedListBuilder]::Child)
            {
                # Use the Child Symbol
                $bulletCharacter = $symbolChild;

                # Finished
                break;
            } # Child


            # In-Progress
            ([FormattedListBuilder]::InProgress)
            {
                # Use the In-Progress Symbol
                $bulletCharacter = $symbolInProgress;

                # Finished
                break;
            } # In-Progress


            # Successful
            ([FormattedListBuilder]::Successful)
            {
                # Use the Successful Symbol
                $bulletCharacter = $symbolSuccessful;

                # Finished
                break;
            } # Successful


            # Warning
            ([FormattedListBuilder]::Warning)
            {
                # Use the Warning Symbol
                $bulletCharacter = $symbolWarning;

                # Finished
                break;
            } # Warning


            # Failure
            ([FormattedListBuilder]::Failure)
            {
                # Use the Failure Symbol
                $bulletCharacter = $symbolFailure;

                # Finished
                break;
            } # Failure


            # No Symbol
            ([FormattedListBuilder]::NoSymbol)
            {
                # Provide an empty space
                $bulletCharacter = $symbolNoSymbol;

                # Finished
                break;
            } # No Symbol


            # No Symbol
            default
            {
                # Do not use a symbol
                break;
            } # No Symbol
        } # Switch : Determine Symbol to Use



        # Provide the message
        [CommonCUI]::DrawFormattedList($messagePosition, `      # How many spaces to indent the message
                                        $bulletCharacter, `     # What symbol to use (optional)
                                        $messageString);        # Message to display
    } # __DisplayBulletListMessage()
} # Builder




<# Builder Formatted List [ENUM]
 # -------------------------------
 # This will give the ability to organize the type of messages that will be presented to the user
 #  from the Builder.
 # -------------------------------
 #>
enum FormattedListBuilder
{
    Parent         = 0; # Main Operation
    Child          = 1; # Sub-Operation
    InProgress     = 2; # Current Action
    Successful     = 3; # Operation was successful
    Warning        = 4; # A Warning had been raised
    Failure        = 5; # Operation had reached a failure
    NoSymbol       = 6; # No Symbol provided
} # FormattedListBuilder
