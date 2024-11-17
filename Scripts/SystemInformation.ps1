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




<# System Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to provide information regarding the host system's configuration.
 #  The information collected within this class can be used for debugging purposes.  As all
 #  systems vary in hardware configurations, it can be useful to retrieve just the basic
 #  information regarding the host's hardware and simple Operating System's environment.
 #  The data collected within this source - cannot be used in an intrusive way that will
 #  infringe upon the user's privacy.
 #>




class SystemInformation
{
    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Private Functions

    # Detect Operating System
    # -------------------------------
    # Documentation:
    #  This function will try to detect the host's current Operating System in which the
    #   application is currently running.  With this, it can be possible for the application
    #   to change its behavior one way for an environment - while different in another.  Thus,
    #   this function provides a gateway for cross-platform support.
    #
    # NOTE:
    #   This function relies on PowerShell Core's environment in order to perform this operation.
    #   Thus, using a legacy PowerShell version will not be sufficient for this function's
    #   requirements.
    # -------------------------------
    # Output:
    #  [SystemInformationOperatingSystem] Operating System
    #   The detected Operating System that the application is presently running within.
    # -------------------------------
    static [SystemInformationOperatingSystem] OperatingSystem()
    {
        # Check if the host is running a Windows environment.
        if ($Global:IsWindows)
        {
            # Detected Windows
            return [SystemInformationOperatingSystem]::Windows;
        } # If : Host Running Windows


        # Check if the host is running a GNU\Linux environment.
        elseif ($Global:IsLinux)
        {
            # Detected Linux
            return [SystemInformationOperatingSystem]::Linux;
        } # If : Host Running Linux


        # Check if the host is running a Macintosh environment.
        elseif ($Global:IsMacOS)
        {
            # Detected Macintosh
            return [SystemInformationOperatingSystem]::Macintosh;
        } # If : Host Running Macintosh OS


        # Unable to determine the host's environment
        else
        {
            # Return an unknown instead.
            return [SystemInformationOperatingSystem]::UNKNOWN;
        } # Else : Unknown Environment
    } # OperatingSystem()





    # Return Application's (PowerShell's) Process ID
    # -------------------------------
    # Documentation:
    #  This function will provide the application's (or essentially the PowerShell's) Process ID
    #   within the Operating System's environment.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [int] PowerShell's Process ID
    #   The Process ID of the PowerShell's instance (with the application active)
    # -------------------------------
    static [int] ProcessID()
    {
        return $Global:PID;
    } # ProcessID()





    # Return User's Working Directory Path
    # -------------------------------
    # Documentation:
    #  This function will return the User's Working Directory path in which the PowerShell's
    #   instance is presently using.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [string] User's Working Directory Full Path
    #   The full path of the User's Working Directory
    # -------------------------------
    static [string] WorkingDirectoryPath()
    {
        return $Global:PWD.Path;
    } # WorkingDirectoryPath()





    # Return PowerShell's Output Encoding Setting
    # -------------------------------
    # Documentation:
    #  This function will return PowerShell's current Encoding configuration for files generated
    #   by PowerShell.  This function can provide insight as to how the text files, generated by
    #   PowerShell, where encoded.  If by chance text files cannot be read with certain text editors,
    #   this function can provide an answer as to why.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [string] PowerShell's Encoding
    #   PowerShell's Encoding setting
    # -------------------------------
    static [string] OutputEncoding()
    {
        return $Global:OutputEncoding.BodyName;
    } # OutputEncoding()





    # Detect PowerShell Version
    # -------------------------------
    # Documentation:
    #  This function will provide the host's PowerShell Version that is presently being used while
    #   running the application.  The Version of the host's POSH can be used to determine how to
    #   operate a specific task for that version, while others may use a different approach.
    # -------------------------------
    # Output:
    #  [string] PowerShell Version
    #   The detected PowerShell Version that this application is presently running within.
    # -------------------------------
    static [string] PowerShellVersion()
    {
        return [string]((Get-Host).Version);
    } # PowerShellVersion()





    # Detect Multiple Threads
    # -------------------------------
    # Documentation:
    #   This function will perform a check on the system to determine if it can handle
    #    multiple threads.  A system is determined to have support of multiple threads
    #    if there are more than one physical microprocessor installed and presently
    #    active within the system, OR if there is one or more microprocessors installed
    #    but contains two or more logical threads.
    #   Thus, for example, a Pentium 4 with Hyperthreading is to be considered a
    #    multithreaded system.  However, a Pentium 3 with only one logical thread, is
    #    not a multithreaded system.  Of course there are a lot of modern microprocessors,
    #    with an abundance of configurations today, I am merely picking the most obvious.
    # -------------------------------
    # Output:
    #  [bool] Multiple Threads
    #   - True: The system is capable of supporting multiple threads.
    #   - False: The system is incapable of supporting multiple threads.
    # -------------------------------
    static [bool] SupportMultipleThreads()
    {
        # Check to see if this system can handle multiple threads
        if(((Get-CimInstance Win32_ComputerSystem).NumberOfProcessors -gt 1) -or `
            (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors -gt 1)
            {
                # This system can handle multiple threads
                return $true;
            } # if: Support Multithreads


        # The host is incapable of supporting multithreads.
        return $false;
    } # SupportMultipleThreads()
    #endregion
} # SystemInformation




<# Operating System [ENUM]
 # -------------------------------
 # Provides a list of supported Operating Systems using PowerShell Core.
 #
 # List of supported Operating Systems using PowerShell Core:
 #  - https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle#supported-platforms
 # -------------------------------
 #>
enum SystemInformationOperatingSystem
{
    Windows     = 0;  # Windows OS
    Linux       = 1;  # Linux
    Macintosh   = 2;  # Macintosh
    UNKNOWN     = 99; # Unregistered
} # SystemInformationOperatingSystem