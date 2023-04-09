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
    # Member Variables :: Properties
    # =================================================
    # =================================================


    # Member Functions :: Methods
    # =================================================
    # =================================================


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
    static [bool] Main([EmbedInstallerInstallDestination] $installLocation)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the Temporary Directory's absolute Path.
        [string] $temporaryDirectoryPath = $NULL;
        # ----------------------------------------



        # Clear the terminal of all previous text; keep the space clean so that
        #   it is easy for the user to read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Embed Installer
        [CommonCUI]::DrawSectionHeader("$($Global:_PROGRAMNAME_) Installer");


        # Create a temporary directory
        if ([CommonIO]::MakeTempDirectory("$($GLOBAL:_PROGRAMNAMESHORT_)-InstallComponent", `
                                            [ref] $temporaryDirectoryPath) `
            -eq $false)
        {
            # Send error signal
            return $false;
        } # if : Failed to Create Temp. Directory


        # Did the user request to install\update Windows Notification?
        if ($installLocation -eq [EmbedInstallerInstallDestination]::WindowsToastNotification)
        {
            # Open the URL using the preferred web browser.

        } # if : Request to Install


        # Provide the instructions
        [EmbedInstaller]::__DrawMainInstructions($installLocation, `
                                                $temporaryDirectoryPath);








        # Create a temporary directory


        # Open the directory to the user such that they may drag and drop
        #   the contents into the temporary directory.



        PAUSE
        return $true;
    } # Main()




   <# Draw Main Instructions
    # -------------------------------
    # Documentation:
    #  Alert the user of instructions as to how this operation works.
    # -------------------------------
    #>
    hidden static [void] __DrawMainInstructions([EmbedInstallerInstallDestination] $installType,
                                                [string] $temporaryDirectory)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This string will be used to create the instructions
        #   that are specifically for the desired install item(s).
        [string] $instructionString = $NULL;


        # This is a just a temporary variable such that we can obtain the
        #   directory name, without the entire absolute path.
        [System.IO.DirectoryInfo] $directoryInformation = $temporaryDirectory;


        # This will hold just the name of the temporary directory.
        [string] $directoryName = $directoryInformation.NameString;
        # ----------------------------------------



        # Determine what kind of message should be displayed.
        switch ($installType)
        {
            # Modern Windows Toast Notification
            ([EmbedInstallerInstallDestination]::WindowsToastNotification)
            {
                # Set the string
                $instructionString = (  " Instructions for Windows Burnt Toast`r`n"                                                                     , `
                                        "-------------------------------------`r`n"                                                                     , `
                                        "`r`n"                                                                                                          , `
                                        " Github Repository:`r`n"                                                                                       , `
                                        "`t`thttps://github.com/Windos/BurntToast`r`n"                                                                  , `
                                        " Download Latest Version:`r`n"                                                                                 , `
                                        "`t`thttps://github.com/Windos/BurntToast/releases/latest`r`n"                                                  , `
                                        "`r`n"                                                                                                          , `
                                        "`r`n"                                                                                                          , `
                                        "You can easily install or update Burnt Toast onto your system using $($GLOBAL:_PROGRAMNAME_) Installer.`r`n"   , `
                                        "`r`n"                                                                                                          , `
                                        "Follow the instructions below:`r`n"                                                                            , `
                                        "- - - - - - - - - - - - - - - -`r`n"                                                                           , `
                                        "  1) Download the latest version of Windows Burnt Toast using the download link provided above.`r`n"           , `
                                        "  2) Place the newly downloaded Zip file into the temporary folder named $($directoryName).`r`n"               , `
                                        "  3) Press the Enter Key to continue the install process.`r`n"                                                 , `
                                        "`r`n`r`n"                                                                                                      , `
                                        "NOTE: To abort this operation, you may close the temporary directory and press the Enter Key."                 , `
                                        "`tBy doing this, this will cancel the operation."                                                              , `
                                        "`r`n`r`n");


                # Finished
                break;
            } # Modern Windows Toast Notifications



            # PowerShell Compact-Archive Tool Project
            ([EmbedInstallerInstallDestination]::Project)
            {
                # Set the string
                $instructionString = (  " Instructions for $($GLOBAL:_PROGRAMNAME_) Projects`r`n"                                                       , `
                                        "-------------------------------------`r`n"                                                                     , `
                                        "`r`n"                                                                                                          , `
                                        "You can easily install or update your project(s) into $($GLOBAL:_PROGRAMNAME_).`r`n"                           , `
                                        "`r`n"                                                                                                          , `
                                        "Follow the instructions below:`r`n"                                                                            , `
                                        "- - - - - - - - - - - - - - - -`r`n"                                                                           , `
                                        "  1) Download the latest version(s) of the desired project(s) you wish to install.`r`n"                        , `
                                        "  2) Place the newly downloaded Zip file(s) into the temporary folder named $($directoryName).`r`n"            , `
                                        "  3) Press the Enter Key to continue with the installation process."                                           , `
                                        "`r`n`r`n"                                                                                                      , `
                                        "NOTE: To abort this operation, you may close the temporary directory and press the Enter Key."                 , `
                                        "`tBy doing this, this will cancel the operation."                                                              , `
                                        "`r`n`r`n");


                # Finished
                break;
            } # Project
        } # Switch : Determine Instruction String


        # Display the message to the user
        [Logging]::DisplayMessage($instructionString);


        # Wait for the user to press the Enter Key, acknowledging that they read the instructions.
        [CommonIO]::FetchEnterKey();
    } # __DrawMainInstructions()
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