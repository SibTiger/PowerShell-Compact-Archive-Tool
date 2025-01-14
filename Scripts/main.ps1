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




<# Main Entry Point
 # ------------------------------
 # ==============================
 # ==============================
 # This source file will initialize the application's environment, assuring that the program can run within the host's
 #  PowerShell instance, provide a means for the user to interact within the software, and then - once the user had
 #  finished using the program - termination by safely closing the environment that had been created.  Essentially,
 #  this is the spine of the entire program.  If the entry point fails, the entire application will fall apart.
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


    # This variable will provide how long the splash screen should be displayed on the terminal.
    #  Because I want the splash screen to be displayed AND still having some work done in the background, we will
    #  capture the time now.
    [UInt64] $splashScreenHoldTime = `
                    ((Get-Date) + (New-TimeSpan -Seconds $Global:_STARTUPSPLASHSCREENHOLDTIME_)).Ticks;
    # ----------------------------------------



    # Clear the host's terminal buffer
    [CommonIO]::ClearBuffer();


    # Display the Startup Splash Screen
    [CommonCUI]::StartUpScreen();


    # Provide a new Window Title
    [CommonIO]::SetTerminalWindowTitle("$($Global:_PROGRAMNAME_) (Version $($Global:_VERSION_))");


    # Provide System and Environment Details
    [Logging]::WriteSystemInformation();


    # Delay the program momentarily so the user can see the splash screen.
    [CommonIO]::DelayTicks($splashScreenHoldTime);


    # Clear the host's terminal buffer
    [CommonIO]::ClearBuffer();


    # Execute the Main Menu; from here - the program will be entirely driven by User Interactions.
    $exitLevel = [MainMenu]::Main();


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




#region Special Program Variables

# This will contain all of the information stored within the pipe.  Now, I am using this
#  as I will need to capture the exit code that is returned from the main application's
#  function.
[System.Object[]] $returnState = $null;

#endregion




# Should the program launch in Clean-Up mode?
if ($programMode -eq 1)
{
    # Launch the cleanup mode.
    $returnState = clean;
} # Clean-Up Mode

# Run the application normally
else
{
    # Launch the main application in normal mode.
    $returnState = main;
} # Normal Mode




# Thrash the program's global variables.
Uninitializations;


# Try to retrieve the exit code that was returned by the main application and then
#  return it to the Operating System.
#  NOTE: We use the very last index as that was the very last item that was added
#       into the Pipe.  And this last item - is our exit code.
exit $returnState[$returnState.Length - 1];