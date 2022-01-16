<# PowerShell Compact-Archive Tool
 # Copyright (C) 2021
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




<# Main Entry Point
 # ------------------------------
 # ==============================
 # ==============================
 # This source file will initialize the application's environment, assuring that the program can run within the host's
 #  PowerShell instance, provide a means for the user to interact within the software, and then - once the user had finished
 #  using the program - termination by safely closing the environment that had been created.
 # Essentially, this is the spine of the entire program.  If the entry point fails, the entire application will fall apart.
 # ----------------------------
 # Exit Codes:
 # 0 = Successfully
 # 1 = Compatibility Issue Determined
 #>




# Program Entry Point
# --------------------------
# Documentation:
#   This function is our entry point for the program.  This function will be in charge of setting up the environment,
#   executing the Main Menu (User Interaction), and then self termination once the user leaves the Main Menu.
# --------------------------
function main()
{
    # Declarations and Initializations
    # ----------------------------------------
    # This variable will the program's main exit level state.  This variable will be the main exit level
    #  when the application terminates.
    [int] $exitLevel = 0;
    # ----------------------------------------



    # Clear the host's terminal buffer
    [CommonIO]::ClearBuffer();


    # Provide a new Window Title
    [CommonIO]::SetTerminalWindowTitle("$($Global:_PROGRAMNAME_) (Version $($Global:_VERSION_)) for $([ProjectInformation]::projectName) - $([ProjectInformation]::codeName)");


    # Display the Startup Splash Screen
    [CommonCUI]::StartUpScreen();


    # Delay the program momentarily so the user can see the splash screen.
    [CommonIO]::Delay(4);


    # Clear the host's terminal buffer
    [CommonIO]::ClearBuffer();


    # Load the user's configurations, if available.
    $loadSaveUserConfiguration.Load();


    # Execute the Main Menu; from here - the program will be entirely driven by User Interactions.
    $exitLevel = [MainMenu]::Main();


    # Save the user's configurations before terminating the program.
    $loadSaveUserConfiguration.Save();


    # Restore the Window Title back to it's state.
    [CommonIO]::SetTerminalWindowTitle($Global:_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_);


    # Close the program
    return $exitLevel;
} # main()




#region Prepare the program's environment

# Setup the program's environment
Initializations;

# Setup the program's directories
CreateDirectories | Out-Null;

#endregion




#region Instantiate Singletons

# Initialize the User Preference object.
[UserPreferences] $userPreferences = [UserPreferences]::GetInstance();


# Initialize a default Git Control object.
[GitControl] $gitControl = [GitControl]::GetInstance();


# Initialize the 7Zip object
[SevenZip] $sevenZip = [SevenZip]::GetInstance();


# Initialize the dotNet Core Zip Archive object
[DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();


# Initialize the Loading and Saving of User Configurations
[LoadSaveUserConfiguration] $loadSaveUserConfiguration = `
                                [LoadSaveUserConfiguration]::GetInstance();

#endregion




# Execute the application and return the exit code from the Main Menu.
#  The exit code could be an error or successful, this only depends on the
#  operations that had been performed and what information had been gathered.
exit main;