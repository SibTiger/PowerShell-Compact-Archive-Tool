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
   <# Detect PowerShell Module
    # -------------------------------
    # Documentation:
    #  This function will try to detect if the requested PowerShell Module is
    #   available within the PowerShell's current environment.
    # -------------------------------
    # Input:
    #   [string] PowerShell Module
    #       The PowerShell Module that we want to obtain the meta data.
    # -------------------------------
    # Output:
    #   [bool] PowerShell Module Detection State
    #       $false  = Module was not detected within the PowerShell's current session.
    #       $true   = Module was successfully detected within the PowerShell's current session.
    # -------------------------------
    #>
    static [bool] DetectPowerShellModule([string] $powerShellModule)
    {
        # Determine if the requested PowerShell Module had been detected.
        # NOTE: The Get-Module CMDlet will return $true if there is 'any'
        #       version of the CMDlet presently installed\available within
        #       the PowerShell Environment.  Otherwise, $false will be
        #       given when nothing was found.
        #   Reference: https://stackoverflow.com/a/28740512
        if (Get-Module -ListAvailable -Name $powerShellModule)
        {
            # Detected the module


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------


            # Declarations and Initializations
            # ----------------------------------------
            # This will contain the module's base information that will be used for logging.
            [string] $debugInfoModuleBase = "";

            # This will contain a list of installed versions of the module.
            [string] $debugInfoModuleVersions = "";

            # This will contain the full string, where the base and version(s) are combined into one variable.
            [string] $debugInfoFullString = "";

            # This will contain a single instance of the module's information;
            #   We will use this to obtain the base information.
            [System.Management.Automation.PSModuleInfo] $debugModuleSingleInstance = $NULL;

            # Retrieve all of the information related to the module, including all versions.
            [System.Object] $debugInstalledModulesList = $(Get-Module -ListAvailable -Name $powerShellModule);
            # ----------------------------------------



            # Determine if the user has multiple versions of the PowerShell Module installed
            if ($debugInstalledModulesList.GetType().Name -eq "Object[]")
            {
                # Multiple Module Versions were detected.

                # This will be used to illustrate how many versions where found.
                [UInt32] $installedCounter = 0;


                # Obtain a single instance and save it for later to get the base information.
                $debugModuleSingleInstance = $debugInstalledModulesList[0];


                # Show that multiple versions where found
                $debugInfoModuleVersions = ("`t-----------------------------------------`r`n" + `
                                            "`tMultiple Versions where found:`r`n");


                # Obtain a list of what versions were installed within the POSH environment.
                foreach ($item in $debugInstalledModulesList)
                {
                    # Increment the counter.
                    $installedCounter++;

                    # Record the version to the string.
                    $debugInfoModuleVersions += "`t[" + $installedCounter + "] - " + $item.Version + "`r`n";
                } # foreach : Scan through all instances found
            } # if : Multiple Versions Detected

            # Only one version was detected.
            else
            {
                # Obtain the instance and save it for later, so we can get the base information.
                $debugModuleSingleInstance = $debugInstalledModulesList;

                # Show the version that is installed
                $debugInfoModuleVersions = "`tVersion        :  " + $debugInstalledModulesList.Version + "`r`n";
            } # else : Single Instance Detected



            # Obtain the base information of the installed module.
            $debugInfoModuleBase = ("Author         : " + $debugModuleSingleInstance.Author         + "`r`n" + `
                                    "`tName           : " + $debugModuleSingleInstance.Name           + "`r`n" + `
                                    "`tCopyright      : " + $debugModuleSingleInstance.Copyright      + "`r`n" + `
                                    "`tProjectURL     : " + $debugModuleSingleInstance.ProjectURI     + "`r`n" + `
                                    "`tDescription    : " + $debugModuleSingleInstance.Description    + "`r`n" + `
                                    "`tPath           : " + $debugModuleSingleInstance.Path);


            # Put the base and version information together into one string.
            $debugInfoFullString =  $debugInfoModuleBase + "`r`n" + `
                                        $debugInfoModuleVersions;


            # Generate the initial message
            [string] $logMessage = "Successfully found the $($powerShellModule) module!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = $debugInfoFullString;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # POSH Module was found.
            return $true;
        } # if : Module is installed



        # POSH Module was not detected


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Could not find the $($powerShellModule) module!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = "";

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Warning);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # POSH Module was not found.
        return $false;
    } # DetectPowerShellModule()





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



        # Determine if the desired PowerShell Module is presently available within the environment.
        if ([CommonFunctions]::DetectPowerShellModule($powerShellModule))
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
                                        "Author         : $($getModuleInfo.Author)`r`n" + `
                                        "Version        : $($getModuleInfo.Version)`r`n" + `
                                        "Copyright      : $($getModuleInfo.Copyright)");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Verbose);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # Successfully populated the meta data.
        return $true;
    } # GetPowerShellModuleMetaDataBrief()





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