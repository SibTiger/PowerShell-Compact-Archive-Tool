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




<# Project Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds all information regarding the desired project that we will be essentially compiling.
 #  Such information is essentially basic, such as: project name, code name, output filename, and project
 #  URLs.  This is going to be helpful for the program to be much more modular and yet also helpful for
 #  the end-user that will be using this program tool.
 #>




class ProjectInformation
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    # Project's Name
    # ---------------
    # The formal name of the project.
    Static [string] $projectName = "projectNameHere";


    # Project's Code Name (or Version Code Name)
    # ---------------
    # The code name of the overall project or version of the project.
    Static [string] $codeName = "projectsCodeNameHere";


    # Output Filename
    # ---------------
    # The filename that will be used in compiled builds.
    # NOTE: Remember that /idgames has a fixed 8char upper-limit!
    Static [string] $fileName = "projectsFileNameHere";


    # Project's Website
    # ---------------
    # The project's official website; which can be accessed by the end-user by request.  This can be
    #  helpful to the user, in-which they may check out the project's latest public announcements and
    #  insights regarding the project.
    Static [string] $urlWebsite = "";


    # Project's Help Documentation
    # ---------------
    # The project's official Wikipedia; which can be accessed by the end-user by request.  This can
    #  greatly be helpful to the user, as they may view the project's help-documentation for abroad
    #  reasons but not limited to using this very tool.
    # NOTE: Wiki's are usually provided in some Developer\Repositories Web-Services, such as GitHub.
    Static [string] $urlWiki = "";


    # Project's Repository
    # ---------------
    # The project's official repository; which can be accessed by the end-user by request.  This can
    #  allow the user to view the project's source code via their preferred web-browser.  Prime example
    #  of Repositories: GitHub, SourceForge, BitBucket, GitLab, and many more.
    Static [string] $urlSource = "";
} # ProjectInformation