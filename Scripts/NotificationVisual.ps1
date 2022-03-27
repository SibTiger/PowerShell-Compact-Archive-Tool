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




<# Notification Visual
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability to notify the user based on certain specialized events.
 #  The notifications within this class provide visual alerts.  Visual alerts can quickly grab
 #  the user's attention, as it provides a graphical window within the foreground - which can
 #  easily catch the user's eyes.
 #
 # NOTE:
 #  For the visual notification in Windows 10, Burnt Toast will be used.  This provides fantastic
 #   functionality that can easily appeal to the user and the desired project.
 #
 # Useful Resources:
 #  Burnt Toast (for Windows 10): https://github.com/Windos/BurntToast
 #>



class NotificationVisual
{
   <# Notify [Main Function]
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to provide a visual notifications to the end-user,
    #   such that they are aware that an event that had occurred.
    # -------------------------------
    # Input:
    #  [String] Message
    #   The message that will be shown to the user.
    #  [String] Project Art (Optional)
    #   The absolute path of the image that will be displayed to the user.
    #   If this variable is null, then no image will be displayed.
    # -------------------------------
    #>
    static [void] Notify([String] $message,
                        [string] $projectArtPath)
    {
    } # Notify()





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
        [NotificationVisual]::Notify($message, $null);
    } # Notify()
} # NotificationVisual