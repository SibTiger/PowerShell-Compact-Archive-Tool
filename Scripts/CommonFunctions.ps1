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




<# Common Functions
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold functions that are commonly used within the program.
 #  Functions provided are in a general form, thus they can be used anywhere
 #  and everywhere - and they provide the same procedure and behavior regardless
 #  where called within the program.
 #>




class CommonFunctions
{
    <# Is String Empty
    # -------------------------------
    # Documentation:
    #  This function will determine if the provided string is empty.
    #
    # NOTE:
    #  If the string only contains whitespace(s), then it will be considered empty.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The desired string to inspect if it is empty or had already been assigned
    #   to a specific value.
    # -------------------------------
    # Output:
    #  [bool] Is String Empty
    #   True  = String is empty
    #   False = String is Populated \ Not-Empty.
    # -------------------------------
    #>
    static [bool] IsStringEmpty([string] $message) { return [string]::IsNullOrEmpty($message.Trim()); }
} # CommonFunctions