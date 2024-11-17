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




<# PowerShell Module Meta Data
 # ------------------------------
 # ==============================
 # ==============================
 # These classes contain meta data information regarding a PowerShell Module.  These classes will
 #  allow the ability for the user to view meta data regarding the PowerShell Module.  The Meta
 #  Data that will be collected are merely information about the PowerShell Module, nothing more
 #  than that.
 #
 # These classes are designed as fully public and easily accessible; getters and setters will not
 #  be used here whatsoever.
 #>




# PowerShell Module Meta Data
class PowerShellModuleMetaData
{
    [string] $author;
    [string] $name;
    [string] $version;
    [string] $copyright;
    [string] $projectURI;
    [string] $description;
    [string] $releaseNotes;
} # PowerShellModuleMetaData