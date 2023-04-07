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




<# Embed Installer
 # ------------------------------
 # ==============================
 # ==============================
 # This class is intended to allow the user to install specific components into
 #  either of the following paths or resources within the environment:
 #      - PowerShell Compact-Archive Tool
 #      - PowerShell Core
 #      - User Files
 #
 # Because tools and resources changes over time, either due to new versions or
 #  perhaps new additions, it is crucial to allow the user to perform new updates
 #  or installs as time progresses onwards.
 #
 # DEPENDENCIES:
 #  .NET Core Framework v3 or later.
 #  PowerShell Core 7 or later
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this
 #  functionality easy for the user.
 #>




class EmbedInstaller
{
   <# Embed Installer
    # -------------------------------
    # Documentation:
    #   This function will provide a step-by-step algorithm such that the
    #   user can easily perform new installation and updates into the desired
    #   environment.  As such, this function will guide the user through
    #   the installation procedure.
    # ----
    # Output:
    #  [bool] Exit Code
    #     $false = Failed to install\update resource
    #     $true  = Successfully installed\updated resource
    # -------------------------------
    #>
    static [bool] EmbedInstaller()
    {
        return $true;
    } # EmbedInstaller()
} # EmbedInstaller




<# Embed Installer - Install Destination [ENUM]
 # -------------------------------
 # This specifies a list of pre-defined directories that
 #  are supported for the installation process.
 # -------------------------------
 #>
enum EmbedInstallerInstallDestination
{
    WindowsToastNotification        = 0;    # Windows 10's Toast Notification
    Project                         = 1;    # Supported Projects
} # EmbedInstallerInstallDestination




<# Embed Installer - Item Type [ENUM]
 # -------------------------------
 # Specifies what type of item is going to be installed onto the host system.
 #
 # Type of Items:
 #  File        - Single file of any type, with or without extension.
 #  Directory   - Single directory
 #  Archive     - Single archive data file that will be extracted in the specified destination.
 # -------------------------------
 #>
enum EmbedInstallerItemType
{
    File            = 0;    # Item Type: File
    Directory       = 1;    # Item Type: Directory
    Archive         = 2;    # Item Type: Archive Datafile
} # EmbedInstallerItemType