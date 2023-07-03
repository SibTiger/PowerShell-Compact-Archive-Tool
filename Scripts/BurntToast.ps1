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
 # This class provides the functionality to use the BurntToast visual
 #  notifications.  With using BurntToast, it provides the ability to
 #  use the Windows Toast visual notification mechanic, in which this
 #  program can provide a way to easily alert the user of certain events
 #  through the Windows notification system.
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
    static [bool] InstallModule()
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
            [string] $logAdditionalMSG = ("Request to install BurntToast had been aborted as an instance" + `
                                            "already exists within the PowerShell environment.")

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $true;
        } # if : BurntToast Detected



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
    } # InstallModule()




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
    static [Bool] UpdateModule()
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
            [string] $logAdditionalMSG = ("The request to update the BurntToast PowerShell module had been aborted," + `
                                            "there was no previous install of BurntToast found within the environment.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # Alert the user through a message box as well.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;
            # * * * * * * * * * * * * * * * * * * *


            # Finished
            return $false;
        } # if : BurntToast not Detected



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
    } # UpdateModule()




   <# Uninstall BurntToast Module
    # -------------------------------
    # Documentation:
    #  This function will try to uninstall the BurntToast PowerShell module,
    #   from the PowerShell environment.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false  = BurntToast was could not be removed.
    #   $true   = BurntToast was successfully removed.
    # -------------------------------
    #>
    static [bool] UninstallModule()
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
            [string] $logAdditionalMSG = ("The request to uninstall the BurntToast PowerShell module had been aborted," + `
                                            "there was no previous install of BurntToast found within the environment.");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

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
    } # UninstallModule()

    #endregion





   <# Notify [Main Function] (Short-Hand\Standard MSGs)
    # -------------------------------
    # Documentation:
    #  This overload function is merely an expeditious way of reaching the Notify(arg0, arg1) method.
    #   However, this function will always assume that the Project Art is to be excluded when displaying
    #   a notification to the user.  Because PowerShell does not allow default arguments to be set, at
    #   least at the time of writing this statement, this function will allow overloading of the arguments.
    #
    # NOTE:
    #  Any notifications passed through this function will not contain any Project Art.
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    # -------------------------------
    #>
    static [void] Notify([String] $message)
    {
        # Access the Notify(arg0, arg1) with the Project Art being omitted.
        [BurntToast]::Notify($message, $null);
    } # Notify()



    #region Back-end Functions

   <# Display Windows Toast
    # -------------------------------
    # Documentation:
    #  This function will be our driver into organizing and managing how the visual notification will
    #   appear to the user within the Windows Graphical environment.
    #
    # NOTE:
    #  For this functionality to work, we will use Burnt Toast.
    #  Module: https://github.com/Windos/BurntToast
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    #  [String] Project Art (Optional)
    #   The absolute path of the image that will be displayed to the user.
    #   If this variable is null, then no image will be displayed.
    # -------------------------------
    #>
    hidden static [void] __DisplayWindowsToast([string] $message,       ` # Message that will be displayed
                                                [string] $projectArt)   ` # The project art that will be shown, this can be nullable.
    {
        # Invoke the Burnt Toast Notification functionality.
        New-BurntToastNotification  -AppLogo $null `
                                    -HeroImage $null `
                                    -Text $($GLOBAL:_PROGRAMNAME_), $message `
                                    -Silent;
    } # __DisplayWindowsToast()

    #endregion
} # BurntToast