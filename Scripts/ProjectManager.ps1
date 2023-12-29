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
            { return $false; }
        } # switch : Operation Request



        # If we made it this far, something went horribly wrong.
        return $false;
    } # Main()
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