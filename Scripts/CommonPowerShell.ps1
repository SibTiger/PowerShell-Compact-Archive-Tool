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




<# Common PowerShell Functions
 # ------------------------------
 # ==============================
 # ==============================
 # This class will contain generic functions that will be used for the PowerShell Modules.
 #  These functions can be used for any PowerShell Module that may already be installed
 #  within the the current PowerShell Environment.  But, however, if wanting to perform an
 #  update on a current installed POSH Module, install a new POSH Module, or retrieve
 #  property data regarding a POSH Module that is available on a remote server, then the
 #  default PowerShell Repository will be used, the PSGallery Repository.  The PSGallery
 #  Repository is considered a 'central repository' and is default repository on a user's
 #  default PowerShell install.  Further, wither good or not, the PSGallery Repository is
 #  hosted by the Microsoft Corporation.  While Microsoft is hosting the repository, it
 #  should be understood - that the modules and scripts that are hosted on that database,
 #  should be considered unsafe.  Unless by vetting the modules and\or scripts that we
 #  want to use are considered safe for general usage.
 # Remember that we want to keep our users safe from any potential harm.
 #
 #
 # Developer Notes:
 #  Default PowerShell Repository:
 #      - PSGallery Repository
 #          https://www.powershellgallery.com/
 #>




class CommonPowerShell
{
   <# Install Module
    # -------------------------------
    # Documentation:
    #  This function will provide the ability to install a PowerShell Module
    #   into the user's system.  Upon installing the PowerShell Module,
    #   we will install the latest version available within the PowerShell
    #   Gallery Repository.
    #
    # Developer Note:
    #   - We will use the official central repository, PSGallery Repository.
    #   - Install-Module will ask the user to confirm installation from the
    #       default PSGallery Repository.  We /want/ the user to confirm the
    #       install.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to install.
    # -------------------------------
    # Output:
    #   [bool] PowerShell Module Install Status
    #       $true   = Successfully installed the PowerShell Module.
    #       $false  = Failed to install the PowerShell Module.
    # -------------------------------
    #>
    static [bool] InstallModule([string] $powerShellModule)
    {
        # Make sure that the user did not provide us with an empty string.
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # Because the string given is empty, there's nothing to install.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------


            # Generate the initial message
            [string] $logMessage = "Unable to install the PowerShell Module, as the name was never provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to install: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `            # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;


            # * * * * * * * * * * * * * * * * * * *


            # Cannot perform an installation with the string being empty.
            return $false;
        } # if : PowerShell Module String Empty


        # Does the user already have the module installed?
        if ([CommonPowerShell]::DetectPowerShellModule($powerShellModule))
        {
            # The PowerShell Module is already installed, no point in installing it again.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to install the PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module is already installed!`r`n" + `
                                            "`tPowerShell Module to install: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Despite the operation never took place, we will return true - ONLY to signify that the POSH
            #   Module is already available within the PowerShell's current environment.
            return $true;
        } # if : PowerShell Module Already Installed


        # Try to install the PowerShell Module
        try
        {
            Install-Module  -Name $powerShellModule `
                            -ErrorAction Stop;
        } # try : Install the PowerShell Module

        # An error had occurred
        catch
        {
            # Unable to install the PowerShell Module due to an error.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------


            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("A failure had occurred while installing the PowerShell Module:" + `
                                            " $($powerShellModule)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to install the PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("PowerShell Module to install: $($powerShellModule)`r`n" + `
                                            "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `   # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;


            # * * * * * * * * * * * * * * * * * * *

            # Operation had failed
            return $false;
        } # Catch : Failed to Install Module


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully installed the PowerShell Module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = "PowerShell Module to install: $($powerShellModule)";

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Operation was successful
        return $true;
    } # InstallModule()





   <# Update PowerShell Module
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to update an installed PowerShell Module within
    #   the user's PowerShell's environment.  To perform this update, we will rely on the
    #   PowerShell Gallery Repository to obtain the latest possible updates for the desired
    #   PowerShell Module.  Further, the PowerShell Module must already be installed and
    #   available within the current PowerShell environment.
    #
    # Developer Note:
    #   - We will use the official central repository, PSGallery Repository.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to update.
    # -------------------------------
    # Output:
    #   [bool] PowerShell Module Update Status
    #       $true   = Successfully updated the PowerShell Module.
    #       $false  = Failed to update the PowerShell Module.
    # -------------------------------
    #>
    static [bool] UpdateModule([string] $powerShellModule)
    {
        # Make sure that the user did not provide us with an empty string.
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # Because the string given is empty, we cannot update the desired PowerShell Module.
            # NOTE: I am fully aware that we can update every PowerShell Module that the user has
            #       presently installed, but that's not /our/ goal within this function.  ;)


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to update the PowerShell Module, as the name was never provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to update: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `            # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot perform an update with the string being empty.
            return $false;
        } # if : PowerShell Module String Empty



        # Make sure that the user has the module already installed within the PowerShell Environment.
        if (![CommonPowerShell]::DetectPowerShellModule($powerShellModule))
        {
            #  The PowerShell Module is not presently installed (or was not detected), no point in updating
            #   something that is not available.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("The PowerShell Module, $($powerShellModule), could not be updated!`r`n" + `
                                            " - It might be that the PowerShell is not presently installed.`r`n" + `
                                            " - OR The PowerShell Module is not presently available");

            # Generate the initial message
            [string] $logMessage = "Unable to update the PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module was not detected:`r`n" + `
                                            "`t- The PowerShell Module is presently available in this session.`r`n" + `
                                            "`t- The PowerShell Module is not installed.`r`n" + `
                                            "`tPowerShell Module to update: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `   # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot perform the update as the PowerShell Module was not found.
            return $false;
        } # if : PowerShell Module Not Installed



        # Try to update the PowerShell Module.
        try
        {
            # Update only the specified PowerShell Module.
            Update-Module   -Name $powerShellModule `
                            -ErrorAction Stop;
        } # Try : Update the PowerShell Module.

        # Caught an Error during Update
        catch
        {
            # Unable to update the PowerShell Module due to an error.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("A failure had occurred while updating the PowerShell Module:" + `
                                            " $($powerShellModule)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Failed to update the PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("PowerShell Module to update: $($powerShellModule)`r`n" + `
                                            "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `   # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Operation had failed.
            return $false;
        } # Catch : Failed to Update Module


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Successfully updated the PowerShell Module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = "PowerShell Module to update: $($powerShellModule)";

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Operation was successful
        return $true;
    } # UpdateModule()





   <# Check for PowerShell Module Updates
    # -------------------------------
    # Documentation:
    #  This function will try to check for available updates on a desired PowerShell
    #   Module.  To perform this operation, we will rely on the PowerShell Gallery
    #   Repository to obtain wither or not there are existing updates available.
    #   Further, the PowerShell Module must already be installed and available
    #   within the current PowerShell environment.
    #
    # Developer Note:
    #   - We will use the official central repository, PSGallery Repository.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to check for updates.
    #   [string] (REFERENCE) Nice Message String
    #       A User-Friendly string that can be shown to the user regarding the updates available.
    # -------------------------------
    # Output:
    #   [bool] Updates Available for PowerShell Module Status
    #       $true   = Updates are available for the POSH Module.
    #       $false  = Updates are not Available for the POSH Module.
    # -------------------------------
    #>
    static [bool] CheckUpdateModule([string] $powerShellModule, `   # PowerShell Module Full Name
                                    [ref] $niceMsgString)           # Returns User-Friendly String of Status.
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Used to capture the latest version retrieved from the PowerShell Gallery Repository.
        [System.Version] $getFindModuleResult = '0.0.0';

        # Used to capture the installed version.
        [System.Version] $getGetModuleResult = '0.0.0';
        # ----------------------------------------



        # Make sure that the user did not provide us with an empty string.
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # Because the string given is empty, we cannot check for potential updates on the desired
            #   PowerShell Module.


            # Update the Message String to show that an error had been reached.
            $niceMsgString.Value = "Unable to check for updates on a PowerShell Module, as the Module name was not given!";


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to check for updates on a PowerShell Module, as the name was never provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to check for updates: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `            # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot check for updates because the string given was empty.
            return $false;
        } # if : PowerShell Module String Empty



        # Make sure that the user has the module already installed within the PowerShell Environment.
        if(![CommonPowerShell]::DetectPowerShellModule($powerShellModule))
        {
            # The PowerShell Module is not presently installed (or was not detected), no point in checking
            #   for updates on something that is not available.


            # Update the Message String to show that an error had been reached.
            $niceMsgString.Value = "Unable to check for updates as the PowerShell Module, " + $powerShellModule + ", is not currently installed.";


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Cannot check for updates for the desired PowerShell Module, $($powerShellModule)`r`n" + `
                                            " - It might be that the PowerShell is not presently installed.`r`n" + `
                                            " - OR The PowerShell Module is not presently available");

            # Generate the initial message
            [string] $logMessage = "Unable to check for updates on the requested PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module was not detected:`r`n" + `
                                            "`t- The PowerShell Module is presently available in this session.`r`n" + `
                                            "`t- The PowerShell Module is not installed.`r`n" + `
                                            "`tPowerShell Module to check for updates: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `   # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Cannot check for updates as the PowerShell Module was not found.
            return $false;
        } # if : PowerShell Module Not Installed



        # Try to obtain the Installed and Remote PowerShell Module version information.
        try
        {
            # Declarations and Initializations
            # ----------------------------------------
            # This will hold all of the Installed Module results obtained by using the CMDlet,
            #   Get-Module.  From this list, we can obtain the latest version installed and
            #   compare that with what is available on the PowerShell Gallery Repository.
            [System.Object] $getGetModuleResultList = [System.Object]::new();
            # ----------------------------------------


            # Obtain the latest version of the PowerShell Module's meta-data from the PowerShell
            #   Gallery Repository;
            $getFindModuleResult = [System.Version]((Find-Module -Name $powerShellModule -ErrorAction Stop).Version);


            # Obtain a list of all installed versions of the PowerShell Module's meta data.
            $getGetModuleResultList = (Get-Module -Name $powerShellModule -ListAvailable -ErrorAction Stop);


            # Determine if the user has multiple versions of the PowerShell Module installed:
            #   if  : Multiple versions were found, only use the first index as that is the latest.
            #   else: Only one version was detected, just use that. 
            if ($getGetModuleResultList.GetType().Name -eq "Object[]")
            { $getGetModuleResult = $getGetModuleResultList[0].Version; }
            else
            { $getGetModuleResult = $getGetModuleResultList.Version; }
        } # Try : Obtain the Installed and Remote POSH Module Meta Data


        # Caught an Error while Checking for Updates
        catch
        {
            # Unable to check for updates due to an error.


            # Update the Message String to show that an error had been reached.
            $niceMsgString.Value = ("Unable to check for updates due to an error:`r`n" + `
                                    "`t$([Logging]::GetExceptionInfoShort($_.Exception))");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("A failure had occurred while checking for updates on the desired PowerShell Module:" + `
                                            " $($powerShellModule)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "An error had occurred while attempting to obtain Remote and Installed Version info!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("PowerShell Module to check for updates: $($powerShellModule)`r`n" + `
                                        "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Operation had failed.
            return $false;
        } # Catch : Failed to Check for Updates


        # Now compare the results and determine if there are updates available.
        if ($getGetModuleResult -lt $getFindModuleResult)
        {
            # Updates are Available


            # Update the Version String to show that there is a new version available.
            $niceMsgString.Value = ("Updates are available for $($powerShellModule)!`r`n" + `
                                    " - Installed Version: $($getGetModuleResult)`r`n" + `
                                    " - New Version Available: $($getFindModuleResult)");


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Updates are available for the $($powerShellModule) PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Found new updates for the PowerShell Module, $($powerShellModule).`r`n" + `
                                            "`tInstalled Version is: $($getGetModuleResult)`r`n" + `
                                            "`tLatest Version from PSGallery Repository: $($getFindModuleResult)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Updates are Available
            return $true;
        } # if : Updates Available



        # Updates are Not Available


        # Update the Version String to show that there is no new version available.
        $niceMsgString.Value = ("Updates are not available for $($powerShellModule).`r`n" + `
                                " - Installed Version: $($getGetModuleResult)`r`n" + `
                                " - Current Released Version: $(($getFindModuleResult).ToString())");


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Updates are not available for the $($powerShellModule) PowerShell Module.";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Updates are not available for the PowerShell Module, $($powerShellModule).`r`n" + `
                                        "`tInstalled Version is: $($getGetModuleResult)`r`n" + `
                                        "`tLatest Version from PSGallery Repository: $($getFindModuleResult)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Updates are not available
        return $false;
    } # CheckUpdateModule()





   <# Detect PowerShell Module
    # -------------------------------
    # Documentation:
    #  This function will try to detect if the requested PowerShell Module is available within the
    #   PowerShell's environment.  The detection works by using the Get-Module CMDlet, which requires
    #   that the PowerShell Module, regardless of the version, is already installed within the system.
    #   If the PowerShell Module had not already been installed within the system, than the detection
    #   will not be able to find the module.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to detect within the PowerShell environment.
    # -------------------------------
    # Output:
    #   [bool] PowerShell Module Detection Status
    #       $true   = Detected the PowerShell Module
    #       $false  = Did not detect the PowerShell Module.    
    # -------------------------------
    #>
    static [bool] DetectPowerShellModule([string] $powerShellModule)
    {
        # Make sure that the user did not provide us with an empty string.
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # Because the string given is empty, there's nothing to detect.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------


            # Generate the initial message
            [string] $logMessage = "Unable to detect a PowerShell Module, as the module name was never provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to Detect: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `            # Message to display
                                    [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;


            # * * * * * * * * * * * * * * * * * * *


            # Cannot perform the detection with the string being empty.
            return $false;
        } # if : PowerShell Module String Empty



        # Try to determine if the PowerShell Module is available within the current PowerShell Environment.
        try
        {
            # Declarations and Initializations
            # ----------------------------------------
            # Retrieve all of the information related to the module, including all versions.
            #   NOTE: If the Get-Module CMDlet fails to obtain at least one instance, such as the Module
            #           we are wanting to find is not installed, than we will jump-into the catch-block.
            [System.Object] $debugInstalledModulesList = $(Get-Module -ListAvailable -Name $powerShellModule -ErrorAction Stop);

            # This will only contain the latest version detected by the Get-Module CMDlet.  We will use this
            #   variable as the main source of obtaining the meta-data properties of that Module.
            [System.Management.Automation.PSModuleInfo] $debugModuleSingleInstance = $NULL;

            # This string will contain basic information regarding the Module's basic information.
            [string] $debugInfoModuleBase = "";

            # This string will contain a list of additional versions that had been detected from the
            #   Get-Module CMDlet.
            [string] $debugInfoModuleVersions = "";

            # This string will contain the basic information and the additional versions into one
            #   accumulative string.
            [string] $debugInfoFullString = "";
            # ----------------------------------------


            # If we made it this far, than Get-Module had detected at least one or more versions of the
            #  POSH Module.  Get as much information as possible regarding the module that was found and
            #  present that into the debugger\logging.


            # Determine if the user has multiple versions of the PowerShell Module installed.
            if ($debugInstalledModulesList.GetType().Name -eq "Object[]")
            {
                # Multiple Module Versions were detected.

                # This will be used to illustrate how many versions where found and presented in the
                #   Debug logfile.
                [UInt32] $installedCounter = 0;


                # Obtain the most up-to-date version of the Module; we will use this to retrieve the
                #   Meta-Data properties of the Module.
                $debugModuleSingleInstance = $debugInstalledModulesList[0];


                # Provide a nicer format to show that multiple versions of the Module had been detected.
                $debugInfoModuleVersions = ("`t-----------------------------------------`r`n" + `
                                            "`tMultiple Versions where found:`r`n");


                # Retrieve each version of the module that is presently installed within the system.
                foreach ($item in $debugInstalledModulesList)
                {
                    # Increment the counter.
                    $installedCounter++;

                    # Record the version
                    $debugInfoModuleVersions += "`t[" + $installedCounter + "] - " + $item.Version;

                    # Is this considered the latest version? (First index is the latest)
                    if ($installedCounter -eq 1) { $debugInfoModuleVersions += " { Latest Version }`r`n";}
                    else { $debugInfoModuleVersions += "`r`n";}
                } # foreach : Scan through all installed versions
            } # if : Multiple Versions Detected

            # Only one version was detected.
            else
            {
                # Obtain the single instance of the module that is installed; we will use this to retrieve
                #   the Meta-Data properties of the installed module.
                $debugModuleSingleInstance = $debugInstalledModulesList;

                # Record the version of the module that is installed.
                $debugInfoModuleVersions = "`tVersion        : " + $debugInstalledModulesList.Version + "`r`n";
            } # else : Single Instance Detected


            # Now we want to begin putting the information together so we can log it efficiently.


            # Obtain the meta-data properties of the installed module.
            $debugInfoModuleBase = ("Author         : " + $debugModuleSingleInstance.Author         + "`r`n" + `
                                    "`tName           : " + $debugModuleSingleInstance.Name           + "`r`n" + `
                                    "`tCopyright      : " + $debugModuleSingleInstance.Copyright      + "`r`n" + `
                                    "`tProjectURL     : " + $debugModuleSingleInstance.ProjectURI     + "`r`n" + `
                                    "`tDescription    : " + $debugModuleSingleInstance.Description    + "`r`n" + `
                                    "`tPath           : " + $debugModuleSingleInstance.Path);


            # Now put the string together that will be written to the debug logfile.
            $debugInfoFullString =  $debugInfoModuleBase    + "`r`n" + `
                                    $debugInfoModuleVersions;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully found the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $debugInfoFullString;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # try : Detect POSH Module


        # PowerShell Module not Detected
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find any installed versions of the desired PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "The PowerShell Module to detect if installed: $($powerShellModule)";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # PowerShell Module was not detected.
            return $false;
        } # catch : PowerShell Module not Detected



        # POSH Module was found.
        return $true;





   <# Get PowerShell Module Meta Data [Full]
    # -------------------------------
    # Documentation:
    #  This function will obtain the meta data of the desired PowerShell
    #   Module is that presently available within the current PowerShell
    #   environment.
    #  If the PowerShell Module was not detected, than this function
    #   will return a failure signal and without populating any of the
    #   Meta Data information.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to obtain the meta data.
    #   [PowerShellModuleMetaDataFull] (REFERENCE) PowerShell Module Meta Data
    #       If the PowerShell Module exists, then this will contain meta data
    #       from the desired PowerShell Module.
    # -------------------------------
    # Output:
    #  [bool] PowerShell Module was Detected
    #   When true, the PowerShell Module Meta Data variable will contain data.
    #   False, however, the PowerShell Module Meta Data variable was not set.
    # -------------------------------
    #>
    static [bool] GetPowerShellModuleMetaDataFull([string] $powerShellModule, `         # POSH Module to get data from
                                                    [ref] $powerShellModuleMetaData)    # Populated Meta Data to return
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will be used to obtain the meta data from the POSH Module.
        [System.Management.Automation.PSModuleInfo] $getModuleInfo = $NULL;
        # ----------------------------------------



        # Did the user provide an empty string?
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Cannot Fetch Meta Data for a PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to Obtain Meta Data: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Cannot get Meta Data as the string is empty.
            return $false;
        } # if : PowerShell Module String Empty



        # Determine if the desired PowerShell Module is presently available within the environment.
        if ([CommonPowerShell]::DetectPowerShellModule($powerShellModule))
        {
            # Detected the module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Found the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "It is possible to obtain the Meta Data from the POSH Module.";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # if : Module is installed

        # POSH Module was not detected
        else
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Could not find the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("It is not possible to obtain Meta Data as the module was not found.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the module was not detected, we will have to abort.
            return $false;
        } # Else : Module not detected


        # Obtain the Module Information and store it temporarily.
        try
        {
            # Try to obtain the Module Information
            [System.Object] $getModuleInfoDynamicType = $(Get-Module -Name $powerShellModule -ListAvailable -ErrorAction Stop);

            # Determine if the user has multiple versions available of the PowerShell Module:
            #   if  : Multiple versions were found, only use the first index.
            #   else: Only one version was detected, just use that. 
            if ($getModuleInfoDynamicType.GetType().Name -eq "Object[]")
            { $getModuleInfo = $getModuleInfoDynamicType[0]; }
            else
            { $getModuleInfo = $getModuleInfoDynamicType; }
        } # try : Obtain Meta Data from the POSH Module

        # Caught an error
        catch
        {
            # Unable to obtain the Meta Data from the POSH Module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the Meta Data for the requested PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("PowerShell Module: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *

            # Because we are not able to obtain the meta data, return an error signal.
            return $false;
        } # catch : Failed to obtain Meta Data


        # Now populate the PowerShell Module Meta Data [Full] object.
        $powerShellModuleMetaData.Value.author          = $getModuleInfo.author;
        $powerShellModuleMetaData.Value.name            = $getModuleInfo.name;
        $powerShellModuleMetaData.Value.version         = $getModuleInfo.version;
        $powerShellModuleMetaData.Value.copyright       = $getModuleInfo.copyright;
        $powerShellModuleMetaData.Value.projectURI      = $getModuleInfo.projecturi;
        $powerShellModuleMetaData.Value.description     = $getModuleInfo.description;
        $powerShellModuleMetaData.Value.releaseNotes    = $getModuleInfo.releasenotes;


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Obtained Meta Data for the requested PowerShell Module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("PowerShell Module: $($powerShellModule)`r`n" + `
                                        "`tAuthor         : $($getModuleInfo.Author)`r`n" + `
                                        "`tName           : $($getModuleInfo.Name)`r`n" + `
                                        "`tVersion        : $($getModuleInfo.Version)`r`n" + `
                                        "`tCopyright      : $($getModuleInfo.Copyright)`r`n" + `
                                        "`tProject URI    : $($getModuleInfo.ProjectURI)`r`n" + `
                                        "`tDescription    : $($getModuleInfo.Description)`r`n"+ `
                                        "`tRelease Notes  : $($getModuleInfo.ReleaseNotes)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Successfully populated the meta data.
        return $true;
    } # GetPowerShellModuleMetaDataFull()





   <# Get PowerShell Module Meta Data [Brief]
    # -------------------------------
    # Documentation:
    #  This function will obtain the meta data of the desired PowerShell
    #   Module is that presently available within the current PowerShell
    #   environment.
    #  If the PowerShell Module was not detected, than this function
    #   will return a failure signal and without populating any of the
    #   Meta Data information.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to obtain the meta data.
    #   [PowerShellModuleMetaDataBrief] (REFERENCE) PowerShell Module Meta Data
    #       If the PowerShell Module exists, then this will contain meta data
    #       from the desired PowerShell Module.
    # -------------------------------
    # Output:
    #  [bool] PowerShell Module was Detected
    #   When true, the PowerShell Module Meta Data variable will contain data.
    #   False, however, the PowerShell Module Meta Data variable was not set.
    # -------------------------------
    #>
    static [bool] GetPowerShellModuleMetaDataBrief([string] $powerShellModule, `        # POSH Module to get data from
                                                    [ref] $powerShellModuleMetaData)    # Populated Meta Data to return
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will be used to obtain the meta data from the POSH Module.
        [System.Management.Automation.PSModuleInfo] $getModuleInfo = $NULL;
        # ----------------------------------------



        # Did the user provide an empty string?
        if ([CommonFunctions]::IsStringEmpty($powerShellModule))
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Cannot Fetch Meta Data for the PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The PowerShell Module string was not provided!`r`n" + `
                                            "`tPowerShell Module to Obtain Meta Data: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Cannot get Meta Data as the string is empty.
            return $false;
        } # if : PowerShell Module String Empty



        # Determine if the desired PowerShell Module is presently available within the environment.
        if ([CommonPowerShell]::DetectPowerShellModule($powerShellModule))
        {
            # Detected the module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Found the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "It is possible to obtain the Meta Data from the POSH Module.";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # if : Module is installed

        # POSH Module was not detected
        else
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Could not find the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("It is not possible to obtain Meta Data as the module was not found.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the module was not detected, we will have to abort.
            return $false;
        } # Else : Module not detected


        # Obtain the Module Information and store it temporarily.
        try
        {
            # Try to obtain the Module Information
            [System.Object] $getModuleInfoDynamicType = $(Get-Module -Name $powerShellModule -ListAvailable -ErrorAction Stop);

            # Determine if the user has multiple versions available of the PowerShell Module:
            #   if  : Multiple versions were found, only use the first index.
            #   else: Only one version was detected, just use that. 
            if ($getModuleInfoDynamicType.GetType().Name -eq "Object[]")
            { $getModuleInfo = $getModuleInfoDynamicType[0]; }
            else
            { $getModuleInfo = $getModuleInfoDynamicType; }
        } # try : Obtain Meta Data from the POSH Module

        # Caught an error
        catch
        {
            # Unable to obtain the Meta Data from the POSH Module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the Meta Data for the requested PowerShell Module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("PowerShell Module: $($powerShellModule)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Error);      # Message level

            # * * * * * * * * * * * * * * * * * * *

            # Because we are not able to obtain the meta data, return an error signal.
            return $false;
        } # catch : Failed to obtain Meta Data


        # Now populate the PowerShell Module Meta Data [Brief] object.
        $powerShellModuleMetaData.Value.author          = $getModuleInfo.author;
        $powerShellModuleMetaData.Value.version         = $getModuleInfo.version;
        $powerShellModuleMetaData.Value.copyright       = $getModuleInfo.copyright;


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Obtained Meta Data for the requested PowerShell Module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("PowerShell Module: $($powerShellModule)`r`n" + `
                                        "`tAuthor         : $($getModuleInfo.Author)`r`n" + `
                                        "`tVersion        : $($getModuleInfo.Version)`r`n" + `
                                        "`tCopyright      : $($getModuleInfo.Copyright)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Successfully populated the meta data.
        return $true;
    } # GetPowerShellModuleMetaDataBrief()
} # CommonPowerShell