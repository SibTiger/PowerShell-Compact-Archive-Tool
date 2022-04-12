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
} # CommonGUI




<# Message Box Icons [ENUM]
 # -------------------------------
 # This will provide the ability to determine the type of visual icon that will appear
 #  within the rendered Message Box.  The icon will help to immediately warn the user
 #  - or to visually que - that an event had happened, such event may be result of a
 #  positive action or an event that had gone horribly wrong.  With these icons, it also
 #  provides audible sounds in respect to the icon.  Meaning, an icon of 'Error' or
 #  'Hand' will play the 'error' sound that is defined in the user's profile settings.
 # https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboximage
 # -------------------------------
 #>
enum MessageBoxIcons
{
    None            = 0; # No icon is provided.
    Asterisk        = 1; # A Message Box Icon of a lowercase letter 'i' in a circle.
    Information     = 2; # A Message Box Icon of a lowercase letter 'i' in a circle.
    Exclamation     = 3; # A Message Box Icon of an exclamation point in a triangle with a yellow background.
    Warning         = 4; # A Message Box Icon of an exclamation point in a triangle with a yellow background.
    Question        = 5; # A Message Box Icon of a question mark in a circle. {DEPRECATED}
    Error           = 6; # A Message Box Icon of a white 'X' in a circle with a red background.
    Stop            = 7; # A Message Box Icon of a white 'X' in a circle with a red background.
    Hand            = 8; # A Message Box Icon of a white 'X' in a circle with a red background.
} # MessageBoxIcons