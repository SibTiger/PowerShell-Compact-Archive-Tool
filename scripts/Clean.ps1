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




<# Cleanup Entry Point
 # ------------------------------
 # ==============================
 # ==============================
 # This source file will allow the ability to cleanup all files and directories that are associated with the software.
 #  With this functionality, the user can merely clean their filesystem by removing compiled builds, logs, reports,
 #  and their configuration files with ease.
 # The following is supported:
 #  - Cleanup
 #      Removes the following:
 #      - Compiled Builds
 #      - Log files
 #      - Report files
 #  - Uninstall
 #      - Compiled Builds
 #      - Log files
 #      - Report files
 #      - User Configuration Files
 # ----------------------------
 # Exit Codes:
 # 0 = Successfully
 # 1 = Operation had Failed
 #>




# Cleanup Entry Point
# --------------------------
# Documentation:
#  This function is a sub-entry point of the program, which is invoked by setting the Program Mode to either '1' or '2'.
#   This functionality is not driven by the main driver and will not use the main driver afterwards, as such this function
#   is a stand-alone.
# --------------------------
function clean()
{
    param(
        # Deletes all builds, logs, report files, and user configuration.
        [Parameter(Mandatory=$true)]
        [ValidateRange(1, 2)]
        [byte]$programMode
    )



    switch ($programMode)
    {
        # Clean Up Mode
        1
        {
            # This statement will clean the following areas:
            #   - Logs
            #   - Reports
            #   - Compiled Builds
        } # Clean Up Mode

        # Uninstall Mode
        2
        {
            # This statement will uninstall the program by deleting the following areas:
            #   - Logs
            #   -  Reports
            #   - Compiled Builds
            #   - User Configurations
        } # Uninstall Mode
    } # switch : Program Mode
} # clean()