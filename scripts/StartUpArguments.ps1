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




<# Startup Arguments
 # ------------------------------
 # ==============================
 # ==============================
 # When calling the software, it is possible to provide it with arguments
 #  during the invoktion call.  These arguments allow the application to
 #  perform different tasks or operations.  It comes without saying, using
 #  these arguments, could cause the application to behave differently.
 #>




# Startup Arguments
param(
    # Program Mode (optional)
    # When provided, this well configure the software to run in a
    #   specialized mode.
    # Settings:
    #   0 = Normal Mode (Default)
    #       Software runs normally, no changes.
    #   1 = Clean Up Mode
    #       Deletes all builds, logs, and report files.
    #   2 = Uninstall Mode
    #       Deletes all builds, logs, report files, and user configuration.
    [Parameter(Mandatory=$false)]
    [byte]$programMode
) # Startup Arguments