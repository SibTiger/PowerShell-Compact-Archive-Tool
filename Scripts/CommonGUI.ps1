<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
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




<# Common GUI
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold various commonly used graphical user interfaces (GUI) that makes
 #  the interaction easier for the end-user.  With these functions defined within
 #  this object, we can easily keep the environment unified and consistent throughout
 #  the entire program.  Further, these functions will help to reduce code duplication
 #  as various other functions - outside from this class - can utilize these methods
 #  openly.  With the reduce of code duplication, we can spend more time on
 #  implementation of other functionalities and to easily maintain these member
 #  functions as necessary with minimal cost.
 #>




class CommonGUI
{
   <# MessageBox
    # -------------------------------
    # Documentation:
    #  This function provides a simple message box to the user.
    #  The interaction within this simplistic message box only
    #   contains an 'OK' button, all other interactions are ignored.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that will be presented within the Message Box.
    #  [System.Windows.MessageBoxImage] icon
    #   The type of message that will be displayed to the user, usually
    #   indicated by an icon on the far left side of the message with the
    #   associated system sound that relates to the event type.
    #
    #   https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboximage
    # -------------------------------
    #>
    static [void] MessageBox([string] $message,                         # Message to display within the message box
                            [System.Windows.MessageBoxImage] $icon)     # Message Box Graphical Icon
    {
        # Display the message box
        [System.Windows.MessageBox]::Show($message,                             ` # Message
                                        $Global:_PROGRAMNAME_,                  ` # Message Box Title
                                        [System.Windows.MessageBoxButton]::OK,  ` # Okay Button
                                        $icon);                                   # Visual Icon
    } # MessageBox()
} # CommonGUI