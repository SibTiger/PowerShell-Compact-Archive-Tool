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




<# Project Manager
 # ------------------------------
 # ==============================
 # ==============================
 # This class can provide the user with the ability to manage PowerShell Compact-Archive Tool projects.
 #  Such management may involve the following:
 #  - Installing Projects
 #  - Updating Projects
 #  - Removing Projects
 #
 # Projects are an important asset to the PowerShell Compact-Archive Tool architecture, as it provides the
 #  user with the ability to compile their game assets into a single archive datafile.  Afterwards, the
 #  author or a developer within the team can then share that same compiled build to online communities,
 #  community forums, or anywhere they wish within the internet or local storage-keeping.
 #
 # DEVELOPER NOTES:
 #  We will rely heavily on the CommonGUI and CommonIO in order to make this functionality easy for the user.
 #>




class ProjectManager
{
   <# Project Manager
    # -------------------------------
    # Documentation:
    #  This function will act as our driver within this class.  In this function, the user will
    #   specifically state what action should be performed; either installing/updating to or removing
    #   projects from the PowerShell Compact-Archive Tool's environment.
    #
    #  NOTE:
    #   This is the entry point within this class.
    # -------------------------------
    # Input:
    #   [ProjectManagerOperationRequest] User Request
    #       Specifies what action should be performed within the Project Manager.
    # -------------------------------
    # Output:
    #   [bool] Operation Status
    #    true  = Operation was successful.
    #    false = Operation had failed.
    # -------------------------------
    #>
    static [bool] Main([ProjectManagerOperationRequest] $request)
    {
        # Clear the terminal of all previous text; keep the space clean so that it is easy for the user to
        #   read and follow along.
        [CommonIO]::ClearBuffer();


        # Draw Program Information Header
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Project Manager
        [CommonCUI]::DrawSectionHeader("Project Manager");


        # Provide some whitespace padding.
        [Logging]::DisplayMessage("`r`n`r`n");


        # Determine what operation is to be performed
        switch ($request)
        {
            # Install or Update Projects
            ([ProjectManagerOperationRequest]::InstallOrUpdate)
            { return [ProjectManagerInstallation]::__Main(); }

            # Uninstall Projects
            ([ProjectManagerOperationRequest]::Uninstall)
            { return $false; }

            # List Projects
            ([ProjectManagerOperationRequest]::List)
            { return $false; }

            # Load Project
            ([ProjectManagerOperationRequest]::Load)
            { return $false; }

            # Show Menu
            ([ProjectManagerOperationRequest]::ShowMenu)
            { return [ProjectManager]::__MainMenu(); }
        } # switch : Operation Request



        # If we made it this far, something went horribly wrong.
        return $false;
    } # Main()




   <# Project Manager - Main Menu
    # -------------------------------
    # Documentation:
    #  When called, this will act as a driver for the Project Manager's Main Menu.  Thus, guiding the user
    #   to perform their desired actions as requested within the Project Manager..
    # -------------------------------
    #>
    hidden static [void] __MainMenu()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will hold the user's input as they navigate within the main menu.
        [string] $userInput = $null;

        # This variable will determine if the user is to remain within the current menu loop.
        #  If the user were to exit from the menu, this variable's state will be set as false.
        #  Thus, with a false value - they may leave the menu.
        [bool] $menuLoop = $true;

        # Determines what action - requested by the user - will be executed.
        [ProjectManagerOperationRequest] $userRequest = [ProjectManagerOperationRequest]::ShowMenu;
        # ----------------------------------------


        # Open the Project Manager's Main Menu
        #  Keep the user at the Project Manager's Main Menu until they request to leave.
        do
        {
            # Clear the terminal of all previous text; keep the space clean so that
            #  it is easy for the user to read and follow along.
            [CommonIO]::ClearBuffer();

            # Draw Program Information Header
            [CommonCUI]::DrawProgramTitleHeader();

            # Show the user that they are at the Main Menu
            [CommonCUI]::DrawSectionHeader("Project Manager - Main Menu");

            # Show Project Manager's About section
            [ProjectManager]::__About();

            # Display the instructions
            [CommonCUI]::DrawMenuInstructions();

            # Draw the Project Manager's Main Menu list to the user
            [ProjectManager]::__DrawMainMenu();
 
            # Provide some extra padding
            [Logging]::DisplayMessage("`r`n");

            # Capture the user's feedback
            $userInput = [CommonCUI]::GetUserInput([DrawWaitingForUserInputText]::WaitingOnYourResponse);

            # Determine the user's request
            $userRequest = [ProjectManager]::__EvaluateExecuteUserRequest($userInput);

            # Request was valid?
            if ($userRequest -ne [ProjectManagerOperationRequest]::ShowMenu)
            { # Leave from the loop
                break;
            } # if : Request was Valid


            # Otherwise, request was not valid -- restart the menu
            # Alert the user that they had provided an incorrect option.
            [NotificationAudible]::Notify([NotificationAudibleEventType]::IncorrectOption);

            # Provide an error message to the user that the option they chose is not available.
            [CommonCUI]::DrawIncorrectMenuOption();
        } while ($menuLoop);


        # When we make it here, we have a valid request to execute.
        #  Re-call the Project Manager's Main function and execute the desired action.
        return [ProjectManager]::Main($userRequest);
    } # __MainMenu()




   <# Project Manager - About
    # -------------------------------
    # Documentation:
    #  This function will provide information regarding the Project Manager and the concept of Projects
    #   within this program.
    # -------------------------------
    #>
    hidden static [void] __About()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This variable will contain information about the Project Manager.
        [string] $strAbout = $NULL;
        # ----------------------------------------


        # Generate the About string
        $strAbout = "$($GLOBAL:_PROGRAMNAMESHORT_) Projects provides information regarding a game project, and also offers the developers with the ability to compile their game's assets into one single data file, such as a PK3 file.  This entire ecosystem is designed to provide the users, of this tool, to expeditiously compile the game project.  After a build had been created, wither it is a test build or a release build, the user is then free to upload their compiled build onto the Internet for others to download or to keep a local copy.";


        # Show the message to the user.
        [Logging]::DisplayMessage($strAbout);
    } # __About()



 
   <# Project Manager - Show Main Menu
    # -------------------------------
    # Documentation:
    #  This function will show the Project Manager's Main Menu and what options are available to the user.
    # -------------------------------
    #>
    hidden static [void] __DrawMainMenu()
    {
        # Install Projects
        [CommonCUI]::DrawMenuItem('I', `
                                "Install Project(s)", `
                                "Install or Update new Projects into $($GLOBAL:_PROGRAMNAMESHORT_).", `
                                $NULL, `
                                $true);


        # Uninstall Projects
        [CommonCUI]::DrawMenuItem('U', `
                                "Uninstall Project(s)", `
                                "Uninstall Projects from $($GLOBAL:_PROGRAMNAMESHORT_).", `
                                $NULL, `
                                $true);


        # Show Projects
        [CommonCUI]::DrawMenuItem('S', `
                                "Show Projects", `
                                "List all Projects that had been installed into $($GLOBAL:_PROGRAMNAMESHORT_).", `
                                $NULL, `
                                $true);
                                


        # Load a Project
        [CommonCUI]::DrawMenuItem('Load', `
                                "Load Project", `
                                "Load a Project into $($GLOBAL:_PROGRAMNAMESHORT_) environment.", `
                                $NULL, `
                                $true);


        # Exit from Project Manager
        [CommonCUI]::DrawMenuItem('X', `
                                "Exit", `
                                "Return to the previous menu.", `
                                $NULL, `
                                $true);
    } # __DrawMainMenu()
} # ProjectManager




<# Project Manager - Operation Request
 # -------------------------------
 # This enumerator will dictate what operation will be performed within the Project Manager.
 #  This will drive how the Project Manager will operate and interact with the user.
 # -------------------------------
 #>
 enum ProjectManagerOperationRequest
 {
     InstallOrUpdate    = 0;    # Install new or Update currently installed projects.
     Uninstall          = 1;    # Delete installed projects.
     List               = 2;    # Provide a list of what projects are installed.
     Load               = 3;    # Load a project into the environment.
     ShowMenu           = 4;    # Allow the user to specify what action they want;
                                #   involves using the Project Manager Menu
 } # ProjectManagerOperationRequest