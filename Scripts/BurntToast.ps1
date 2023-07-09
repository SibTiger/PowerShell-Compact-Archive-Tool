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




<# BurntToast - Windows Toast Visual Notifications
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the necessary functionality in order to utilize
 #  features from the BurntToast PowerShell module.  The BurntToast module
 #  produces visual notifications to the user by means of a Windows Toast
 #  notification mechanism through the Windows Action Center in the
 #  Desktop Environment.  By using this notification system in Windows,
 #  we can assure that the user will be able to see the alerts when
 #  the Windows Notification System is available.
 #
 # BurntToast can be found in the following URL:
 #  https://github.com/Windos/BurntToast
 #  https://www.powershellgallery.com/packages/BurntToast
 #>



class BurntToast
{
    #region Module Management

   <# Detect BurntToast Module
    # -------------------------------
    # Documentation:
    #  This function will try to detect if the host system has the BurtToast
    #   module available within the PowerShell's current environment.
    #   This will provide the ability to determine if BurntToast had been
    #   installed already within the environment, or if BurntToast had yet
    #   to be installed.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was not detected.
    #   $true   = BurntToast was successfully detected.
    # -------------------------------
    #>
    static [bool] DetectModule()
    {
        # We are going to try to detect if the module is available within this PowerShell
        #   instance.  If incase it is not available - then we will return $false, simply
        #   stating that it was not found.  When any output is provided, then we will
        #   return $true - as an instance of the module had been detected.
        # Reference: https://stackoverflow.com/a/28740512
        if (Get-Module -ListAvailable -Name "BurntToast")
        {
            # BurntToast had been detected


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Found BurntToast PowerShell module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "It is possible to use BurntToast Windows Visual Notification features!";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that we had successfully found the module.
            return $true;
        } # if : BurntToast is Installed



        # When BurntToast was not detected
        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Could not find BurntToast PowerShell module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("It is not possible to use the BurnToast features!`r`n" + `
                                    "`t- Please consider downloading the latest version of BurntToast:`r`n" + `
                                    "`t`thttps://github.com/Windos/BurntToast`r`n" + `
                                    "`t- Or, alternatively, you may consider installing BurntToast from $($GLOBAL:_PROGRAMNAMESHORT_) Main Settings.");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Warning);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # An instance of the module was not detected.
        return $false;
    } # DetectModule()




   <# Show BurntToast Install Option
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to determine if we can show
    #   the BurntToast installation alert, depending on certain circumstances.
    #   We will alert the user that it is possible to install the BurntToast
    #   PowerShell Module if was not yet installed, and if the host system
    #   has an active internet connection.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = Do not show Install Alert
    #   $true   = Show Install Alert
    # -------------------------------
    #>
    static [bool] ShowBurntToastInstallOption()
    {
        return ((![BurntToast]::DetectModule())                 -and `      # Check if the module is already installed
                  [CommonIO]::CheckInternetConnection()         -and `      # Check Host Internet Connection Availability
                  [BurntToast]::__CheckModuleExistsInRepository())          # Check if module still in the POSH Repository
    } # ShowBurntToastInstallOption()




   <# Check for BurntToast Updates
    # -------------------------------
    # Documentation:
    #  This function will check if there exists any updates for the BurntToast
    #   PowerShell module.  To do this, we will inspect what version is presently
    #   installed and compare that with what is presently available with the
    #   PowerShell Repository.  If an update exists, we will alert the calling
    #   function.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = No updates found.
    #   $true   = Updates are available.
    # -------------------------------
    #>
    static [bool] CheckBurntToastUpdates()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this to capture the version of the BurntToast PowerShell Module
        #   We know that the size is going to be at max - is three.
        #   0 = Major
        #   1 = Minor
        #   2 = Revision
        [int32[]] $repositoryVersion = [int32[]]::New(3);   # PowerShell Gallery Repository

        # Holds detailed version provided by the current install.
        [System.Version] $installedVersion = $NULL;

        # Holds the value that determines if there exists an update.
        [bool] $updateAvailable = $false;

        # Log Topic; used to describe if updates are available or not.
        [string] $logTopic = $null;
        # ----------------------------------------



        # Before we check for updates, first make sure that the PowerShell Module had already been installed within the environment.
        if (![BurntToast]::DetectModule())
        {
            # BurntToast was not found; abort the operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Cannot check for updates as the PowerShell Module was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ""

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $false;
        } # if : BurntToast Not Detected



        # Make sure that the user has an active internet connection.
        if (![CommonIO]::CheckInternetConnection())
        {
            # Because the user presently does not have internet access,
            #   we cannot check the online PowerShell Repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Cannot check for updates as the system is not presently connected to the Internet.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # No internet connection
            return $false;
        } # If : Host has No Internet Connection



        # Determine if the BurntToast PowerShell Module is still available within the PowerShell Repository.
        if (![BurntToast]::__CheckModuleExistsInRepository())
        {
            # Because the BurntToast PowerShell Module is no longer available in the PowerShell Repository, 
            #   we cannot determine if an update is available.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Cannot check for updates as the BurntToast PowerShell Module is no longer available in the PowerShell Repository!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # BurntToast not Available
            return $false;
        } # If : BurntToast Not Available in Repository


        # Capture the PowerShell Module information directly from the PowerShell Repository.
        try
        {
            # Declarations and Initializations
            # ----------------------------------------
            # This will hold the version information of the installed module.
            [string[]] $versionString = [string[]]::new(3);
            # ----------------------------------------


            # Fetch the entire results directly from the PowerShell Repository.
            $versionString = (Find-Module                   `
                                -Name "BurntToast"          `
                                -Repository "PSGallery"     `
                                -ErrorAction Stop).Version.Split('.');


            # Store and convert the datatype such that we can perform comparisons later on.
            for ([int] $i = 0; $i -lt 3; $i++)
            { $repositoryVersion[$i] = $versionString[$i]; }
        } # Try : Obtain Information from Repository


        # Caught an Error
        catch
        {
            # Unable to obtain the information from the PowerShell Repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to check for updates as we cannot retrieve information from the PowerShell Repository.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Unable to continue
            return $false;
        } #  Catch : Caught an Error



        # Capture information regarding the current install of the PowerShell Module.
        $installedVersion = ((Get-Module -ListAvailable -Name "BurntToast").Version);


        # Determine if an Update is Available
        # Update is available
        if (($repositoryVersion[0] -lt $installedVersion.Major) -or `
            ($repositoryVersion[1] -lt $installedVersion.Minor) -or `
            ($repositoryVersion[2] -lt $installedVersion.Build))
        {
            # Raise the flag, denoting that an update is available
            $updateAvailable = $true;

            # Change the log topic to denote that updates were available.
            $logTopic = "Updates are available for BurntToast";
        } # If : Update Available

        # No updates are available
        else { $logTopic = "No updates are available for BurntToast."; }



        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = $logTopic;

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Current Installation Build: " + `
                                        "$($installedVersion.Major).$($installedVersion.Minor).$($installedVersion.Build)`r`n" + `
                                        "`tPowerShell Repository Build Available: " + `
                                        "$($repositoryVersion[0]).$($repositoryVersion[1]).$($repositoryVersion[2])");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *



        # Return the final result.
        return $updateAvailable;
    } # CheckBurntToastUpdates()

    #endregion




    #region Front-end Functions

   <# Show Program Message
    # -------------------------------
    # Documentation:
    #  This function is designed to show event based messages generated
    #   by the application.  This differs from the project based
    #   messages, as the images will be centered around the program.
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    #  [BurntToastShowGraphic] Graphic Option
    #   Determines what image is going to shown to the user.
    # -------------------------------
    #>
    static [void] ShowProgramMessage([String] $message, `                   # Message to show to the user.
                                    [BurntToastShowGraphic] $graphicOption) # Show specific image to the user.
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Program's Logo Image
        [string] $imageLogo = $GLOBAL:_PROGRAMDATA_LOCAL_IMAGES_LOGO_PATH_;

        # Program's Banner Image
        [string] $imageBanner = $NULL;
        # ----------------------------------------


        # Determine what image will be shown to the user:
        if ($graphicOption -eq [BurntToastShowGraphic]::Banner) { $imageBanner  = $GLOBAL:_PROGRAMDATA_LOCAL_IMAGES_BANNER_PATH_; }


        [BurntToast]::__ShowWindowsToastMessage($message, `
                                                $imageLogo, `
                                                $imageBanner);
    } # ShowProgramMessage()




   <# Show Project Message
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to show event based message
    #   activities regarding a project.
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    #  [BurntToastShowGraphic] Graphic Option
    #   Determines what image is going to shown to the user.
    # -------------------------------
    #>
    static [void] ShowProjectMessage([string] $message, `                   # Message to show to the user.
                                    [BurntToastShowGraphic] $graphicOption) # Show specific image to the user.
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Program's Logo Image
        [string] $imageLogo = $GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_ART_LOGO_PATH_;

        # Program's Banner Image
        [string] $imageBanner = $NULL;
        # ----------------------------------------


        # Determine what image will be shown to the user:
        if ($graphicOption -eq [BurntToastShowGraphic]::Banner) { $imageBanner  = $GLOBAL:_PROGRAMDATA_ROAMING_PROJECT_ART_BANNER_PATH_; }


        # Show message
        [BurntToast]::__ShowWindowsToastMessage($message, `
                                                $imageLogo, `
                                                $imageBanner);
    } # ShowProjectMessage()

    #endregion




    #region Back-end Functions

   <# Check Module Exists within POSH Gallery
    # -------------------------------
    # Documentation:
    #  This function is designed to determine if the BurntToast PowerShell
    #   Module exists within the PowerShell Repository.  With this
    #   functionality alone, we can determine if we can potentially fetch
    #   a new install or update directly from the PowerShell Repository.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was not found in Repository.
    #   $true   = BurntToast was found in Repository.
    # -------------------------------
    #>
    static [bool] __CheckModuleExistsInRepository()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $operationStatus = $true;            # Provides the operation code of this function.
        # ----------------------------------------



        # Before we begin inspecting the PowerShell Repository, make sure
        #   that the host system has an active internet connection.
        if (![CommonIO]::CheckInternetConnection())
        {
            # Because the user presently does not have internet access,
            #   we cannot check the online PowerShell Repository.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to check the online PowerShell Repository as the host does not have an active Internet Connection presently.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Unable to inspect
            return $false;
        } # If : Host has No Internet Connection



        # Try to obtain the results from the online PowerShell Repository
        try
        {
            # Declarations and Initializations
            # ----------------------------------------
            [System.Object] $results = $NULL;     # Holds the results obtained from the repository.
            # ----------------------------------------


            # Obtain the results from the PowerShell Repository.
            $results = Find-Module                  `
                        -Name "BurntToast"          `
                        -Repository "PSGallery"     `
                        -ErrorAction Stop;

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully found results from the PowerShell Module Repository!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Name:                        $($results.Name)`r`n"                       + `
                                        "`tAuthor:                      $($results.Author)`r`n"                     + `
                                        "`tCompanyName:                 $($results.CompanyName)`r`n"                + `
                                        "`tCopyright:                   $($results.Copyright)`r`n"                  + `
                                        "`tProjectUri:                  $($results.ProjectUri)`r`n"                 + `
                                        "`tDescription:                 $($results.Description)`r`n"                + `
                                        "`tPublishedDate:               $($results.PublishedDate)`r`n"              + `
                                        "`tUpdated Date:                $($results.UpdatedDate)`r`n"                + `
                                        "`tVersion:                     $($results.Version)`r`n"                    + `
                                        "`tRepository:                  $($results.Repository)`r`n"                 + `
                                        "`tRepository Source Location:  $($results.RepositorySourceLocation)`r`n"   + `
                                        "`tModule:                      $($results.Type)`r`n"                       + `
                                        "`tRelease Notes:               $($results.ReleaseNotes)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # try : Obtain Results from 


        # Error was caught
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to check the online PowerShell Repository as the host does not have an active Internet Connection presently.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Signify that we were not able to fetch the results.
            $operationStatus = $false;
        } # Catch : Caught an Error



        # Finished.
        return $operationStatus;
    } # __CheckModuleExistsInRepository()




   <# Install BurntToast Module
    # -------------------------------
    # Documentation:
    #  This function will try to install the BurntToast PowerShell module, if
    #   it is not already installed within the PowerShell environment.
    #   To install this module, we will rely on the Package Manager already
    #   implemented within PowerShell, to assure a clean and successful
    #   installation.
    #
    # Install-Module Documentation:
    #  https://learn.microsoft.com/en-us/powershell/module/powershellget/install-module
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was not installed.
    #   $true   = BurntToast was successfully installed.
    # -------------------------------
    #>
    static [bool] __InstallModule()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $operationStatus = $true;            # Provides the operation code of this function.
        # ----------------------------------------



        # Before we install the module, first make sure that it is not already installed
        if ([BurntToast]::DetectModule())
        {
            # Because we found an installation of BurntToast, we will abort this operation.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "An instance of BurntToast was already found; installation aborted!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Request to install BurntToast had been aborted as an instance " + `
                                            "already exists within the PowerShell environment.")

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $true;
        } # if : BurntToast Detected



        # Assure that the host has an active Internet Connection.
        if (![CommonIO]::CheckInternetConnection())
        {
            # Because the user presently does not have internet access, we cannot install the module.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to begin procedure of installing BurntToast; Internet Connection is presently not available.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Unable to download
            return $false;
        } # If : Host has No Internet Connection



        # Try to install the BurntToast PowerShell Module
        try
        {
            # Install the module
            Install-Module  -Name "BurntToast" `
                            -Repository "PSGallery" `   # Default Repository; hosted by Microsoft.
                            -Force `                    # Using flag to suppresses confirmation.
                            -ErrorAction Stop;          # Stop when an error was caught.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully installed BurntToast PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $NULL;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # try : Install Module


        # General Error
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to install the BurntToast PowerShell module!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to install the BurntToast PowerShell module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = [Logging]::GetExceptionInfo($_.Exception);

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


            # Caught an error while trying to install the module.
            $operationStatus = $false;
        } # catch : Error



        # Finished
        return $operationStatus;
    } # __InstallModule()




   <# Update BurntToast Module
    # -------------------------------
    # Documentation:
    #  This function will try to update the BurntToast PowerShell module, if
    #   an update is available.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was could not be updated.
    #   $true   = BurntToast was successfully updated.
    # -------------------------------
    #>
    static [Bool] __UpdateModule()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $operationStatus = $true;            # Provides the operation code of this function.
        # ----------------------------------------



        # Before we begin with the update procedure, we must first ensure that the module had
        #   already been installed.
        if (![BurntToast]::DetectModule())
        {
            # Because there was no previous installation of BurntToast, we must abort.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update BurntToast as there was no previous installation found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The request to update the BurntToast PowerShell module had been aborted, " + `
                                            "there was no previous install of BurntToast found within the environment.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Alert the user through a message box as well.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;
            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $false;
        } # if : BurntToast not Detected



        # Assure that the host has an active Internet Connection.
        if (![CommonIO]::CheckInternetConnection())
        {
            # Because the user presently does not have internet access, we cannot update the module.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to begin procedure of updating BurntToast; Internet Connection is presently not available.";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Unable to download
            return $false;
        } # If : Host has No Internet Connection



        # Try to update the BurntToast module
        try
        {
            # Try to update the BurntToast Module
            Update-Module   -Name "BurntToast" `
                            -Force `                # Suppress confirmations
                            -ErrorAction Stop;      # Stop when an error had been reached.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully updated BurntToast to the latest version!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $NULL;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Try : Update BurntToast


        # General Error
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to update the BurntToast PowerShell module!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to update the BurntToast PowerShell module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = [Logging]::GetExceptionInfo($_.Exception);

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


            # Caught an error while trying to install the module.
            $operationStatus = $false;
        } # catch : Error



        # Finished
        return $operationStatus;
    } # __UpdateModule()




   <# Uninstall BurntToast Module
    # -------------------------------
    # Documentation:
    #  This function will try to uninstall the BurntToast PowerShell module
    #   from the user's PowerShell environment.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was could not be removed.
    #   $true   = BurntToast was successfully removed.
    # -------------------------------
    #>
    static [bool] __UninstallModule()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [bool] $operationStatus = $true;            # Provides the operation code of this function.
        # ----------------------------------------



        # Before we begin with the uninstallation procedure, we must first ensure that the module had
        #   already been installed.
        if (![BurntToast]::DetectModule())
        {
            # Because there was no previous installation of BurntToast, we must abort.

            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to uninstall BurntToast as there was no previous installation found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The request to uninstall the BurntToast PowerShell module had been aborted, " + `
                                            "there was no previous install of BurntToast found within the environment.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Alert the user through a message box as well.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;
            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $false;
        } # if : BurntToast not Detected



        # Try to uninstall the BurntToast module
        try
        {
            # Try to uninstall the BurntToast Module
            Uninstall-Module    -Name "BurntToast" `
                                -AllVersions `          # Just incase if multiple versions had been installed.
                                -Force `                # Suppress confirmations
                                -ErrorAction Stop;      # Stop when an error had been reached.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully uninstalled BurntToast!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $NULL;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Try : Uninstall BurntToast


        # General Error
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user regarding this error; temporary variable
            [string] $displayErrorMessage = ("Failed to uninstall the BurntToast PowerShell module!`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to uninstall the BurntToast PowerShell module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = [Logging]::GetExceptionInfo($_.Exception);

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


            # Caught an error while trying to install the module.
            $operationStatus = $false;
        } # catch : Error



        # Finished
        return $operationStatus;
    } # __UninstallModule()




   <# Show Windows Toast Message
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to provide a Windows Toast
    #   notification into the Windows Action Center, thus allowing the
    #   messages to be visible to the user on their native desktop
    #   environment.
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    #  [string] Project Logo (Optional)
    #   The absolutely path to the project's dedicated logo image.
    #  [string] Project Banner (Optional)
    #   The absolute path to the project's dedicated banner image.
    #   NOTE: This, formally, is called a 'Hero' image.  Calling this
    #           a banner image is for my sakes, as it makes sense to me.
    # -------------------------------
    #>
    hidden static [void] __ShowWindowsToastMessage([string] $message,       `   # Message that will be displayed
                                                [string] $projectLogo,      `   # [Optional] Project's Logo Image Full Path
                                                [string] $projectBanner)        # [Optional] Project's Banner Image Full Path
    {
        # Determine if the BurntToast PowerShell Module had been detected.
        #  If we cannot find BurntToast, then we can not continue.
        if (![BurntToast]::DetectModule()) { return; }


        # Make sure that the images are provided, otherwise - set them to null.
        # - - - -
        # Check the Project Logo Path
        if (($null -ne $projectLogo) -and `                         # Project Logo was provided
            (![CommonIO]::CheckPathExists($projectLogo, $true)))    # Path does not exist
        { $projectLogo = $null; }


        # Check the Project Banner Path
        if (($null -ne $projectBanner) -and `                       # Project Banner was provided.
            (![CommonIO]::CheckPathExists($projectBanner, $true)))  # Path does not exist
        { $projectBanner = $null; }
        # - - - -



        # Invoke the Burnt Toast Notification functionality.
        New-BurntToastNotification  -AppLogo $projectLogo `
                                    -HeroImage $projectBanner `
                                    -Text $($GLOBAL:_PROGRAMNAME_), $message `
                                    -Silent;
    } # __ShowWindowsToastMessage()

    #endregion
} # BurntToast




<# BurntToast Configure Install [ENUM]
 # -------------------------------
 # This defines what operation should be taken to configure
 #  the BurntToast instance within the host system.
 # -------------------------------
 #>
enum BurntToastConfigureInstall
{
    Install     = 0;
    Update      = 1;
    Uninstall   = 3;
} # BurntToastConfigureInstall




<# BurntToast Show Graphic [ENUM]
 # -------------------------------
 # This defines what graphic is going to be displayed in the Windows
 #  Toast notification when shown to the user, through the Windows
 #  Action Center.
 # -------------------------------
 #>
enum BurntToastShowGraphic
{
    Logo    = 0;
    Banner  = 1;
} # BurntToastShowGraphic