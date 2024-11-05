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




<# Common Functions
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold functions that are commonly used within the program.
 #  Functions provided are in a general form, thus they can be used anywhere
 #  and everywhere - and they provide the same procedure and behavior regardless
 #  where called within the program.
 #>




class CommonFunctions
{
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



        # We are going to try to detect if the module is available within this
        #  PowerShell instance.  If incase it is not available - then we must
        #  return false, or simply stating that it was not found.
        # NOTE: If there is ANY output, then this function will return true.
        # Reference: https://stackoverflow.com/a/28740512
        if (Get-Module -ListAvailable -Name $powerShellModule)
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
            #   NOTE: what I fear using '-ListAvailable', if there is multiple versions of the POSH Module,
            #   then this datatype will change to 'System.Object[]' instead of 'PSModuleInfo'.  Then we will
            #   need to add further detections to determine how the data was returned by Get-Module.  I am
            #   not sure how to test this?
            $getModuleInfo = $(Get-Module -Name $powerShellModule -ListAvailable -ErrorAction Stop);
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
                                        "Author         : $($getModuleInfo.Author)`r`n" + `
                                        "Name           : $($getModuleInfo.Name)`r`n" + `
                                        "Version        : $($getModuleInfo.Version)`r`n" + `
                                        "Copyright      : $($getModuleInfo.Copyright)`r`n" + `
                                        "Project URI    : $($getModuleInfo.ProjectURI)`r`n" + `
                                        "Description    : $($getModuleInfo.Description)`r`n"+ `
                                        "Release Notes  : $($getModuleInfo.ReleaseNotes)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Successfully populated the meta data.
        return $true;
    } # GetPowerShellModuleMetaDataFull()





   <# Is .NET Core ZIP Archive Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the .NET Core Zip  functionality
    #   is available on the host system.  In order for this operation
    #   to work, we will use the Default Zip object to check if such
    #   feature is present.
    # -------------------------------
    # Output:
    #  [bool] .NET Core Zip Availability
    #   When true, this will mean that Zip is available and can be used.
    #   False, however, will mean that the Zip functionality is not available.
    # -------------------------------
    #>
    static [bool] IsAvailableZip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the Zip object
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $defaultCompress.DetectCompressModule();
    } # IsAvailableZip()




   <# Is String Empty
    # -------------------------------
    # Documentation:
    #  This function will determine if the provided string is empty.
    #
    # NOTE:
    #  If the string only contains whitespace(s), then it will be considered empty.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The desired string to inspect if it is empty or had already been assigned
    #   to a specific value.
    # -------------------------------
    # Output:
    #  [bool] Is String Empty
    #   True  = String is empty
    #   False = String is Populated \ Not-Empty.
    # -------------------------------
    #>
    static [bool] IsStringEmpty([string] $message) { return [string]::IsNullOrEmpty($message.Trim()); }
} # CommonFunctions