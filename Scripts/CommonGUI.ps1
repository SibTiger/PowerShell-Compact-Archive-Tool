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




# Add to Session
# ---------------------------------------------------
# Required in order to use the Message Box functionality within the Windows environment.
Add-Type -AssemblyName PresentationCore;
Add-Type -AssemblyName PresentationFramework;

# Required in order to use the following GUI functionalities within the Windows Environment
#   - File Browser Dialog
#   - Folder Browser Dialog
Add-Type -AssemblyName System.Windows.Forms;
# ---------------------------------------------------



class CommonGUI
{
   <# MessageBox - OK Button [Simple]
    # -------------------------------
    # Documentation:
    #  This function provides a simple message box to the user.
    #  The interaction within this simplistic message box only
    #   contains an 'OK' button, all other interactions are ignored.
    #
    # Resources:
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messagebox
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboximage
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that will be presented within the Message Box.
    #  [System.Windows.MessageBoxImage] Icon
    #   The type of message that will be displayed to the user, usually
    #   indicated by an icon on the far left side of the message with the
    #   associated system sound that relates to the event type.
    # -------------------------------
    # Output:
    #  [System.Windows.MessageBoxResult] User's Feedback
    #   Returns the user's feedback
    #
    #  NOTE: This function will only return 'OK' as that is the only
    #           button that will be available to the user.
    # -------------------------------
    #>
    static [System.Windows.MessageBoxResult] MessageBox([string] $message,                          # Message to display within the message box
                                                        [System.Windows.MessageBoxImage] $icon)     # Message Box Graphical Icon
    {
        # Display the message box
        return [CommonGUI]::MessageBox($message,                                    ` # Message
                                        $icon,                                      ` # Visual Icon
                                        [System.Windows.MessageBoxButton]::OK,      ` # OK Button
                                        [System.Windows.MessageBoxResult]::OK);     ` # Default Button
    } # MessageBox()





   <# MessageBox - Customizable Buttons
    # -------------------------------
    # Documentation:
    #  This function provides the user with the ability to provide
    #   interaction with a Message Box that contains more than one
    #   button, such as: OK Cancel, Yes No, Yes No Cancel.
    #
    #  The intention of this message box is too the ability to ask
    #   the user a question and to provide the appropriate choices,
    #   reducing the amount of work necessary.
    #
    # Resources:
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messagebox
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboximage
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboxbutton
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.messageboxresult
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that will be presented within the Message Box.
    #  [System.Windows.MessageBoxImage] Icon
    #   The type of message that will be displayed to the user, usually
    #   indicated by an icon on the far left side of the message with the
    #   associated system sound that relates to the event type.
    #  [System.Windows.MessageBoxButton] Button
    #   The specified buttons that will be available to the end-user to
    #   interact within the Message Box.
    #  [System.Windows.MessageBoxResult] Default Button
    #   The default button that is easily selectable when the user presses
    #   the enter key without using a pointing device (mouse).
    # -------------------------------
    # Output:
    #  [System.Windows.MessageBoxResult] User's Feedback
    #   Returns the user's feedback
    #
    #  NOTE: This function will only return 'OK' as that is the only
    #           button that will be available to the user.
    # -------------------------------
    #>
    static [System.Windows.MessageBoxResult] MessageBox([string] $message,                                  ` # Message
                                                        [System.Windows.MessageBoxImage] $icon,             ` # Message Box Title
                                                        [System.Windows.MessageBoxButton] $button,          ` # Desired Buttons
                                                        [System.Windows.MessageBoxResult] $defaultButton)   ` # Default Selected Button
    {
        # Display the message box
        return [System.Windows.MessageBox]::Show($message,              ` # Message
                                                $Global:_PROGRAMNAME_,  ` # Message Box Title
                                                $button,                ` # Okay Button
                                                $icon,                  ` # Visual Icon
                                                $defaultButton);        ` # Default Button
    } # MessageBox()





   <# Browse for Directory
    # -------------------------------
    # Documentation:
    #   This function will allow the user to select a directory using the
    #   Folder Browser dialog window.  By using this functionality, the
    #   user will be able to expeditiously navigate to the desired directory
    #   with ease - instead of having to spend extra time digging for a
    #   specific folder within the host's filesystem.
    #
    # Resources:
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog
    # -------------------------------
    # Input:
    #  [string] Instructions
    #   Provide a brief description as to what the user needs to find within the local host.
    #  [BrowserInterfaceStyle] Style
    #   This provides the ability to determine which browser interface is to be drawn to the user.
    #  [string] (REFERENCE) Results
    #   If a directory were to be selected, then we will return the value within this variable.
    # -------------------------------
    # Output:
    #  [bool] Path Selected
    #   $true   = The user had selected a directory and the result had been stored.
    #   $false  = The user had cancelled the operation, no directory had been selected.
    # -------------------------------
    #>
    static [bool] BrowseDirectory([string] $instructions,           ` # Show description to the user; reminder
                                [BrowserInterfaceStyle] $style,     ` # Style of the Browser interface
                                [ref] $result)                      ` # Selected directory to be returned.
    {
        # Declarations and Initializations
        # -------------------------------------
        # This will store the Folder Browser Dialog object
        [System.Windows.Forms.FolderBrowserDialog] $directoryBrowser = [System.Windows.Forms.FolderBrowserDialog]::New();

        # Used to obtain the results from the Folder Browser.
        [System.Windows.Forms.DialogResult] $browserResult = [System.Windows.Forms.DialogResult]::None;
        # -------------------------------------



        # Setup the properties for the Folder Browser Dialog
        #   General Settings
        $directoryBrowser.AutoUpgradeEnabled    = `                                                 # Choose between modern or classical browser.
                            ($style -eq [BrowserInterfaceStyle]::Modern) ? $true : $false;
        $directoryBrowser.UseDescriptionForTitle= $false;                                           # Place the description at the title bar?

        #   Classical Folder Browser Settings
        $directoryBrowser.RootFolder            = [System.Environment+SpecialFolder]::MyComputer;   # Allow the user full access to the system.
        $directoryBrowser.ShowNewFolderButton   = $true;                                            # Allow the user to create a new directory.
        #   Modern Folder Browser Settings
        $directoryBrowser.InitialDirectory      = $env:USERPROFILE;                                 # Start the user at their Home directory.



        # Open the Folder Browser Dialog window
        if (($browserResult = $directoryBrowser.ShowDialog()) -eq [System.Windows.Forms.DialogResult]::Cancel)
        {
            # The user chose to abort.
            return $false;
        } # if : User Cancelled



        # If we made it this far, then we know that the user had chosen a path.
        # Provide the path that the user had chose.
        $result.Value = $directoryBrowser.SelectedPath;

        # Let the calling function know that the user provided a path.
        return $true;
    } # BrowseDirectory()




   <# Browse for Files
    # -------------------------------
    # Documentation:
    #   This function will allow the user to select a particular or a handful of files with
    #   the respected file-extensions.  By using this functionality, the user will be able
    #   to expeditiously navigate to the desired file or files with ease - instead of having
    #   to spend extra time digging for a specific file's URI.
    #
    # Resources:
    #   - https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.openfiledialog
    # -------------------------------
    # Input:





    #  [string] Instructions
    #   Provide a brief description as to what the user needs to find within the local host.
    #  [BrowseDirectoryInterfaceStyle] Style
    #   This provides the ability to determine which browser interface is to be drawn to the user.
    #  [string] (REFERENCE) Results
    #   If a directory were to be selected, then we will return the value within this variable.
    # -------------------------------
    # Output:
    #  [bool] File(s) Selected
    #   $true   = The user had selected at least one file
    #   $false  = The user had cancelled the operation, no file had been selected.
    # -------------------------------
    #>
    static [bool] BrowseFile([string] $title,
                            [string] $defaultExtension,
                            [string] $filterExtensionOptions,
                            [bool] $selectMultipleFiles,
                            [BrowserInterfaceStyle] $style,
                            [string[]] $files)
    {
        # Declarations and Initializations
        # -------------------------------------
        # This will store the the File Browser Dialog object
        [System.Windows.Forms.OpenFileDialog] $fileBrowser = [System.Windows.Forms.OpenFileDialog]::New();

        # Used to obtain the results from the Folder Browser.
        [System.Windows.Forms.DialogResult] $browserResult = [System.Windows.Forms.DialogResult]::None;
        # -------------------------------------


        # Setup the properties for the File Browser Dialog
        $fileBrowser.AutoUpgradeEnabled             = `                                                 # Choose between modern or classical browser.
                            ($style -eq [BrowserInterfaceStyle]::Modern) ? $true : $false;
        $fileBrowser.CheckFileExists                = $true;       # Warn the user if the file does not exist within the filesystem.
        $fileBrowser.CheckPathExists                = $true;       # Warn the user if the path does not exist within the filesystem.
        $fileBrowser.DefaultExt                     = $defaultExtension;
        $fileBrowser.Filter                         = $filterExtensionOptions;
        $fileBrowser.DereferenceLinks               = $true;
        $fileBrowser.Multiselect                    = $selectMultipleFiles;
        $fileBrowser.RestoreDirectory               = $true;
        $fileBrowser.ShowHelp                       = $false;
        $fileBrowser.Title                          = $title;
        $fileBrowser.ValidateNames                  = $true;
        $fileBrowser.SupportMultiDottedExtensions   = $false;
        $fileBrowser.InitialDirectory               = $env:USERPROFILE;



        # Open the File Browser Dialog window
        if (($browserResult = $fileBrowser.ShowDialog()) -eq [System.Windows.Forms.DialogResult]::Cancel)
        {
            # The user chose to abort.
            return $false;
        } # if : User Cancelled



        # If we made it this far, then we know that the user had chosen one or many files.
        #  Provide the file(s) that the user had selected.
        $files = $fileBrowser.FileNames;

        # Let the calling function know that the user provided atleast one file.
        return $true;
    } # BrowseFile()
} # CommonGUI




<# Browser Interface Style [ENUM]
 # -------------------------------
 # This provides the ability to determine which type of browser that the user will be
 #  interacting.  The interface styles are merely either the classical or modern.
 # - Classical interface is very constrained in functionality as well as features that
 #      are inherited within the dialog window.
 # - Modern interface provides the latest newest functionalities that the operating
 #      system provides to the user, but also provides new features that are inherited
 #      within the the dialog window.
 # -------------------------------
 #>
enum BrowserInterfaceStyle
{
    Classic    = 0;    # The ol' browser
    Modern     = 1;    # The modern browser
} # BrowserInterfaceStyle