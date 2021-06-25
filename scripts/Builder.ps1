<# Builder
 # ------------------------------
 # ==============================
 # ==============================
 # This class is the heart of the program - in which it allows the
 #  desired project to be compiled into a single archive data file.
 #  The builder will perform various steps to assure that the project
 #  is up to date with the remote repository, assure that all of the
 #  dependencies are ready for use, perform the compiling operation,
 #  verify the integrity of the newly generated archive datafile,
 #  and create any useful documentation as requested.  The user has
 #  full flexibility as to how the Builder operates and with what
 #  capabilities are usable.
 #>



class Builder
{
   <# Build
    # -------------------------------
    # Documentation:
    #  This function is essentially our main driver into creating a
    #   ZDoom based archive datafile generated by using the project's
    #   source files.  Because this function is our main driver into
    #   achieving this goal, we have to assure that the process is
    #   well organized and is keeping the operation - easy to manage.
    #   By doing this, we will want to approach this in a sequential
    #   manner while also checking our work consistently.  Meaning,
    #   in order to compile the project's source files into one single
    #   archive file, we may need to update the source via a Source
    #   Control tool - then we may proceed with compacting the data.
    #   This is only a brief example out of many possible cases now
    #   and as well in the future when and if the functionality were
    #   to expand.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = The Project Build had reached an error.
    #   $true = The Project Build had successfully been created.
    # -------------------------------
    #>
    static [bool] Build()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Archive datafile's final destination path
        [string] $compiledBuildPath = $null;
        # ----------------------------------------


        # Clear the terminal of all previous text; keep the space clean so that
        #  it is easy for the user to read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Main Menu
        [CommonCUI]::DrawSectionHeader("Compiling the $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)] Project");


        # Display the instructions
        [CommonCUI]::CompileInstructions();




        #region Prerequisite Check

        #           Prerequisite Check
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *


        # Make sure that we have all of the resources that we are going to
        #  need in order to successfully compile this project.
        [Builder]::DisplayBulletListMessage(0, [FormattedListBuilder]::Parent, "Prerequisite Check");
        [Builder]::DisplayBulletListMessage(1, [FormattedListBuilder]::InProgress, "Performing a Prerequisite Check. . .");


        # Invoke the Prerequisite Check and evaluate its feedback.  If it turns
        #  out that we are missing one or more required resources, then we cannot
        #  proceed with the compiling process.
        if (![Builder]::PrerequisiteCheck())
        {
            # Because we are lacking a required resource, we cannot proceed with
            #  this process.

            # Show that this step had reached a fault
            [Builder]::DisplayBulletListMessage(1, [FormattedListBuilder]::Failure, "Missing one or more resources!");
            [Builder]::DisplayBulletListMessage(2, [FormattedListBuilder]::NoSymbol, "Unable to compile the project as requested.");

            # We will return a failure signal, as we cannot proceed forward with
            #  the compiling process.
            return $false;
        } # if : Evaluate Prerequisite Check


        # Because we have all of the resources that we need - in order to compile this project, we can
        #  proceed to the next step!

        # Show that the Prerequisite Check had passed.
        [Builder]::DisplayBulletListMessage(1, [FormattedListBuilder]::Successful, "Passed!");

        #endregion




        #region Update Source (Git)

        #           Update Source (Git)
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *


        # If requested, we are going to update the project's source files.  Thus, we assure that the
        #  user's local repository is always up to date with the remote repository
        [CommonCUI]::DrawFormattedList(0, $symbolParent, "Update $([ProjectInformation]::projectName) source files");


        # Before we perform this step, first we need to make sure that:
        #  - Found Git
        #  - Using Git features is allowed
        #  - User allows us to update the local repository
        if (([CommonFunctions]::IsAvailableGit() -eq $true) -and `
            ($userPreferences.GetUseGitFeatures() -eq $true) -and `
            ($gitControl.GetUpdateSource() -eq $true))
        {
            # We are allowed to update the Local Repository to match with the Remote Repository.

            # Because we can update the project files, show the user that we are going to update
            #  the project's source files.
            [CommonCUI]::DrawFormattedList(1, $symbolInProgress, "Updating $([ProjectInformation]::projectName)'s Local Repository with the Remote Repository. . .");

            # Update the Local Repository
            if ($userPreferences.UpdateLocalRepository("$($userPreferences.GetProjectPath())"))
            {
                # Visually show to the user that the project's source files had been updated successfully.
                [CommonCUI]::DrawFormattedList(1, $symbolSuccessful, "Successfully updated $([ProjectInformation]::projectName)'s Local Repository!");
            } # If : Successfully Updated Local Repository

            # Error had been reached while updating the Local Repository
            else
            {
                # Visually show that an error had been reached
                #  Instead of aborting the operation from here, we can try to continue instead.
                [CommonCUI]::DrawFormattedList(1, $symbolFailure, "Failed to update $([ProjectInformation]::projectName)'s Local Repository with the Remote Repository!");
                [CommonCUI]::DrawFormattedList(2, $null, "Please be cautious as this build maybe corrupted or incomplete!");
            } # Else : Failed to Update Local Repository
        } # If : Update Local Repository

        # Unable to update the Local Repository
        else
        {
            # We cannot update the source either due to user's request or unable to find the Git
            #  application.
            [CommonCUI]::DrawFormattedList(1, $symbolWarning, "Unable to update $([ProjectInformation]::projectName)'s source files; skipping this step instead.");
        } # Else: Unable to Update Local Repository


        # Show that we are finished updating the project's local repository
        [CommonCUI]::DrawFormattedList(1, $symbolSuccessful, "Finished!");

        #endregion




        #region Compile Project

        #             Compile Project
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *


        # Now to compile the project, using the user's preferred compiling tool and compiler settings.
        [CommonCUI]::DrawFormattedList(0, $symbolParent, "Compile $([ProjectInformation]::projectName) source files.");



        # Determine which compression tool we are going to use in order to generate this build,
        #  and if that tool is available for us to use.
        # Archive Zip (Default)
        if ($userPreferences.GetCompressionTool() -eq [UserPreferencesCompressTool]::InternalZip)
        {
            # We will use the ZIP Archive module to compile this project.
            [CommonCUI]::DrawFormattedList(1, $symbolInProgress, "Compiling $([ProjectInformation]::projectName) using ZIP Archive (Default). . .");


            # Generate archive build
            if ($defaultCompress.CreateArchive("$([ProjectInformation]::fileName)", `
                                            "$($userPreferences.GetProjectBuildsPath())", `
                                            "$($userPreferences.GetProjectPath())", `
                                            [ref] $compiledBuildPath) -eq $false)
            {
                # Failed to generate the build
                [CommonCUI]::DrawFormattedList(1, $symbolFailure, "Failed to compile $([ProjectInformation]::projectName)!");

                # Because we had reached an error, return back with an error signal.
                return $false;
            } # If : Failed to generate build
        } # if : Archive Zip (Default)

        # 7Zip
        elseif ($userPreferences.GetCompressionTool() -eq [UserPreferencesCompressTool]::SevenZip)
        {
            # We will use the 7Zip application to compile this project.
            [CommonCUI]::DrawFormattedList(1, $symbolInProgress, "Compiling $([ProjectInformation]::projectName) using 7Zip. . .");
        } # Else-if : 7Zip

        # Fatal Error; either the tool is unknown or not ready
        else
        {
            # Display a message to the user that an error had been reached
            [CommonCUI]::DrawFormattedList(1, $symbolFailure, "Cannot compile $([ProjectInformation]::projectName) as the compiling software is not ready or not available at this time!");

            # We cannot proceed forward with the operation.
            return $false;
        } # Else : Error









        #endregion




        #region Create Reports
        #endregion




        # Show that the compiling operation was successful.
        [CommonCUI]::DrawFormattedList(0, $symbolParent, "Operation had been completed!");

        # To avoid compiling issues, we will merely return an error for now.
        return $false;
    } # Build()




   <# Prerequisite Check
    # -------------------------------
    # Documentation:
    #  The function performs a validation check to assure that all
    #   of the required resources are available for the compiling
    #   process.  If incase we found one or more resources - that
    #   is imperative for the entire operation to work correctly -
    #   then we may ultimately abruptly abort the entire compile
    #   operation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more resources were missing but required.
    #   $true = All of the resources were accounted for and ready.
    # -------------------------------
    #>
    hidden static [bool] PrerequisiteCheck()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();

        # Retrieve the current instance of the user's Git Control object; this contains the user's
        #  preferences as to how Git will be used within this application.
        [GitControl] $gitControl = [GitControl]::GetInstance();

        # Retrieve the current instance of the user's 7Zip object; this contains the user's
        #  preferences as to how 7Zip will be utilized within this application.
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();

        # We will use this variable to cache the detection status of a particular item that we want
        #  to check.  Instead of having to recall the exact same checking function over and over again,
        #  we will use this variable to merely cache the value as we step through each process within
        #  the checking procedure.
        [bool] $boolCacheValue = $false;


        # Debugging Variables
        [string] $logMessage = $NULL;           # Main message regarding the logged event.
        [string] $logAdditionalMSG = $NULL;     # Additional information about the event.
        # ----------------------------------------




        #              Project Path
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Check the current status of the Project Path
        $boolCacheValue = [CommonIO]::CheckPathExists("$($userPreferences.GetProjectPath())", $true);

        # Can we find the project's source files?
        if ($boolCacheValue -eq $false)
        {
            # Unable to find the project's source files; unable to continue.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I am unable to find the $([ProjectInformation]::projectName) source files!`r`n" + `
                                            "Please reconfigure the path for the $([ProjectInformation]::projectName) project!`r`n" + `
                                            "`t- $([ProjectInformation]::projectName) Project Path is presently: $($userPreferences.GetProjectPath())`r`n" + `
                                            "`t- Path Exists Detection Status: $([string]$boolCacheValue)");

            # Generate the initial message
            $logMessage = "Unable to find the $([ProjectInformation]::projectName) project's source files!";

            # Generate any additional information that might be useful
            $logAdditionalMSG = ("Please reconfigure the location of the $([ProjectInformation]::projectName) Project's Source.`r`n" + `
                                "`tProject Source Location is: $($userPreferences.GetProjectPath())`r`n" + `
                                "`tProject Source Path Exists: $([string]$boolCacheValue)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because we cannot find the project's source files, we have to abort the operation.
            return $false;
        } # if : Check Project source files exists




        #              Output Path
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Check the current status of the Output Path
        $boolCacheValue = [CommonIO]::CheckPathExists("$($userPreferences.GetProjectBuildsPath())", $true);

        # Can we find the output path?
        if ($boolCacheValue -eq $false)
        {
            # Unable to find the output path directory; unable to continue.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate a message to display to the user.
            [string] $displayErrorMessage = ("I cannot find the folder to store any new compiled builds!`r`n" + `
                                            "Please reconfigure the Output Path in the program's general settings!`r`n" + `
                                            "`t- Output Path is presently: $($userPreferences.GetProjectBuildsPath())`r`n" + `
                                            "`t- Path Exists Detection Status: $([string]$boolCacheValue)");

            # Generate the initial message
            $logMessage = "Unable to find the Output Directory!";

            # Generate any additional information that might be useful
            $logAdditionalMSG = ("Please reconfigure the location of the Output Directory.`r`n" + `
                                "`tOutput Directory Location is: $($userPreferences.GetProjectBuildsPath())`r`n" + `
                                "`tOutput Directory Path Found: $([string]$boolCacheValue)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                        "$($logAdditionalMSG)", `   # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because we cannot find the output directory, we have no place to place the
            #  compiled build.  We cannot continue this operation.
            return $false;
        } # if : Check Output Path exists




        #            Compression Tool
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Determine if the chosen compression tool is available for us to utilize.
        switch ($userPreferences.GetCompressionTool())
        {
            # dotNET Archive Zip
            ([UserPreferencesCompressTool]::InternalZip)
            {
                # Check the current status of the Archive ZIP Module
                $boolCacheValue = [CommonFunctions]::IsAvailableZip();

                # Make sure that the dotNET Archive Zip is available
                if ($boolCacheValue -eq $false)
                {
                    # Unable to find the dotNET Archive Zip


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate a message to display to the user.
                    [string] $displayErrorMessage = ("I am unable to find support for ZIP in this version of PowerShell!`r`n" + `
                                                    "Please make sure that you are using the latest version of PowerShell Core!`r`n" + `
                                                    "`t- You are currently using PowerShell Core Version: $([SystemInformation]::PowerShellVersion())`r`n" + `
                                                    "`t- ZIP Archive Module Detection Status: $([string]$boolCacheValue)`r`n" + `
                                                    "`t- You may check out any new releases of the PowerShell Core at GitHub!`r`n" + `
                                                    "`t`thttps://github.com/PowerShell/PowerShell/releases");

                    # Generate the initial message
                    $logMessage = "Unable to find the dotNET Archive Zip Module!";

                    # Generate any additional information that might be useful
                    $logAdditionalMSG = ("Please assure that you are currently using the latest version of PowerShell Core!`r`n" + `
                                        "`tArchive ZIP Module Detection reported: $([string]$boolCacheValue)`r`n" + `
                                        "`tPowerShell Version: $([SystemInformation]::PowerShellVersion())`r`n" + `
                                        "`tOperating System: $([String][SystemInformation]::OperatingSystem())`r`n" + `
                                        "`tCheck for new versions of PowerShell Core at the provided official website:`r`n" + `
                                        "`t`thttps://github.com/PowerShell/PowerShell/releases");

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                                "$($logAdditionalMSG)", `   # Additional information
                                                [LogMessageLevel]::Error);  # Message level

                    # Display a message to the user that something went horribly wrong
                    #  and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                    [LogMessageLevel]::Error);  # Message level

                    # * * * * * * * * * * * * * * * * * * *


                    # Because we cannot find the default internal Archive Module within PowerShell, we
                    #  cannot proceed forward with the compiling phase.
                    return $false;
                } # If : Found Default Zip

                # Finished
                break;
            } # dotNET Archive Zip


            # 7Zip
            ([UserPreferencesCompressTool]::SevenZip)
            {
                # Check the current status of the 7Zip application
                $boolCacheValue = [CommonFunctions]::IsAvailable7Zip();

                # Make sure that the 7Zip is available
                if ($boolCacheValue -eq $false)
                {
                    # Unable to find the 7Zip application


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate a message to display to the user.
                    [string] $displayErrorMessage = ("I am unable to find the 7Zip software on your computer!`r`n" + `
                                                    "Please assure that 7Zip had been properly installed on your computer!`r`n" + `
                                                    "`t- 7Zip Detection Status: $([string]$boolCacheValue)`r`n" + `
                                                    "`t- You may download the latest version of 7Zip at the official website!`r`n" + `
                                                    "`t`thttps://www.7-zip.org/download.html");

                    # Generate the initial message
                    $logMessage = "Unable to find the 7Zip Application!";

                    # Generate any additional information that might be useful
                    $logAdditionalMSG = ("Please assure that you currently have 7Zip installed and that $($Global:_PROGRAMNAME_) can detect it's installation path!`r`n" + `
                                        "`tFound 7Zip: $([String]$boolCacheValue)`r`n" + `
                                        "`t7Zip Path: $($sevenZip.GetExecutablePath())`r`n" + `
                                        "`tInstall the latest version of 7Zip at the official website:`r`n" + `
                                        "`t`thttps://www.7-zip.org/download.html");

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                                "$($logAdditionalMSG)", `   # Additional information
                                                [LogMessageLevel]::Error);  # Message level

                    # Display a message to the user that something went horribly wrong
                    #  and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                                [LogMessageLevel]::Error);  # Message level

                    # * * * * * * * * * * * * * * * * * * *


                    # Because the user specified that we must use 7Zip in order to compile the builds,
                    #  then we must abort the operation as we are unable to find the software.
                    return $false;
                } # If : Found 7Zip

                # Finished
                break;
            } # 7Zip


            # Unknown or Unsupported (Error Case)
            default
            {
                # Unknown or Unsupported compression tool!


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate a message to display to the user.
                    [string] $displayErrorMessage = ("Please choose a valid Compression Tool within the Program's Generalized settings!`r`n" + `
                                                    "The current compression tool that you had requested is either no longer supported or unknown.`r`n" + `
                                                    "`t- Current Compression Tool ID is: $([uint]$userPreferences.GetCompressionTool())");

                    # Generate the initial message
                    $logMessage = "Requested compression software is either unsupported or unknown!";

                    # Generate any additional information that might be useful
                    $logAdditionalMSG = ("Please reconfigure your preferred Compression Tool within the Program's Generalized Settings!`r`n" + `
                                        "`tCompression Tool ID: $([uint]$userPreferences.GetCompressionTool())");

                    # Pass the information to the logging system
                    [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                                "$($logAdditionalMSG)", `   # Additional information
                                                [LogMessageLevel]::Error);  # Message level

                    # Display a message to the user that something went horribly wrong
                    #  and log that same message for referencing purpose.
                    [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                                [LogMessageLevel]::Error);  # Message level

                    # * * * * * * * * * * * * * * * * * * *


                # Because this compression tool is not support or simply unknown, have to abruptly
                #  stop.
                return $false;
            } # Unknown or Unsupported
        } # Switch : Determine Specified Compression Tool




        #           Git Functionality
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # Determine if the user wanted us to use Git Features
        if ($userPreferences.GetUseGitFeatures())
        {
            # Check the current status of the Git application
            $boolCacheValue = [CommonFunctions]::IsAvailableGit();

            # Assure that we are able to find the Git Application
            if ($boolCacheValue -eq $false)
            {
                # Unable to find the Git application.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate a message to display to the user.
                [string] $displayErrorMessage = ("I am unable to find the Git Version Control software on your computer!`r`n" + `
                                                "Please assure that Git Version Control had been properly installed on your computer!`r`n" + `
                                                "`t- Git Detection Status: $([string]$boolCacheValue)`r`n" + `
                                                "`t- You may download the latest version of Git at the official website!`r`n" + `
                                                "`t`thttps://git-scm.com/");

                # Generate the initial message
                $logMessage = "Unable to find the Git Application!";

                # Generate any additional information that might be useful
                $logAdditionalMSG = ("Please assure that you currently have Git installed and that $($Global:_PROGRAMNAME_) can detect it's installation path!`r`n" + `
                                    "`tFound Git: $([String]$boolCacheValue)`r`n" + `
                                    "`tGit Path: $($gitControl.GetExecutablePath())`r`n" + `
                                    "`tInstall the latest version of GIT at the official website:`r`n" + `
                                    "`t`thttps://git-scm.com/");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity("$($logMessage)", `       # Initial message
                                            "$($logAdditionalMSG)", `   # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage("$($displayErrorMessage)", `  # Message to display
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Because the user had requested that we utilize the Git software yet we are unable
                #  to find it, we may not continue with the compiling operation.
                return $false;
            } # if : Check if Git Exists
        } # if : Git Features Requested




        #                  DONE!
        # * * * * * * * * * * * * * * * * * * * *
        # * * * * * * * * * * * * * * * * * * * *

        # If we made it this far, that means that we have everything we need to compile this project!


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        $logMessage = ("The Prerequisite Check had determined that we have all of the required" + `
                        "resources necessary to compile the $([ProjectInformation]::projectName) project!");

        # Generate any additional information that might be useful
        $logAdditionalMSG = "Prerequisite Check had successfully passed!";

        # Pass the information to the logging system
        [Logging]::LogProgramActivity("$($logMessage)", `           # Initial message
                                    "$($logAdditionalMSG)", `       # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # If we made it to this point, then we have all of the resources
        #  that we need to compile this project!
        return $true;
    } # PrerequisiteCheck()





   <# Display Bullet List Message
    # -------------------------------
    # Documentation:
    #  This function will act as a gateway into accessing the Formatted List.
    # -------------------------------
    # Input:
    #  [unsigned int] Message Position
    #   The position of the message that is to be displayed.  The position entails
    #       as to how many indentions are required before displaying the message.
    #  [FormattedListBuilder] Message Type
    #   The type of message that is to be presented to the user.  This usually could
    #   be a simple bullet list or provides a unique character for the message based
    #   on certain events.
    #  [string] Message String
    #   The message that will be displayed to the user.
    # -------------------------------
    #>
    hidden static [void] DisplayBulletListMessage([uint] $messagePosition,              # How many indentions before message
                                        [FormattedListBuilder] $messageType,    # Type of list or message
                                        [string] $messageString)                # Initial message to display
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the desired bullet point symbol or any special symbol
        #  that matches with the type of the message.
        [char] $bulletCharacter = $null;

        # Symbols that will be used when providing a list.
        [char] $symbolParent     = '>';     # Main Operation
        [char] $symbolChild      = '-';     # Sub-Main Operation
        [char] $symbolInProgress = '-';     # Task presently running
        [char] $symbolSuccessful = '-';     # Operation finished successfully
        [char] $symbolWarning    = '!';     # Reached a warning case
        [char] $symbolFailure    = '!';     # Operation reached an error
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
            default
            {
                # Do not use a symbol
                break;
            } # No Symbol
        } # Switch : Determine Symbol to Use



        # Provide the message
        [CommonCUI]::DrawFormattedList($messagePosition,    # How many spaces to indent the message
                                        $bulletCharacter,   # What symbol to use (optional)
                                        $messageString);    # Message to display
    } # DisplayBulletListMessage()
} # Builder




<# Builder Formatted List [ENUM]
 # -------------------------------
 # This will allow the ability to organize the type of messages that will be
 #  used within the Builder.
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