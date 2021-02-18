<# Common CUI
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold common Console User Interface instructions and procedures to
 #  reduce code duplication.  With the functions provided in this class, we can easily
 #  keep most of the User Interface content unified and consistent through out the
 #  entire program.  With the consistency of the UI, the end-user can easily navigate
 #  within the program with the outmost ease.  If we were not consistent, the user
 #  will easily get frustrated with the program.
 #>




class CommonCUI
{
   <# Draw Program Title Header
    # -------------------------------
    # Documentation:
    #  This function will display the Program's information to the user so that they
    #   are able to see what version of the program is currently running within the
    #   shell.
    # -------------------------------
    #>
    static [void] DrawProgramTitleHeader()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the main border
        [string] $border    = "----------------------------------------------------";
        # This will help separate the contents
        [string] $borderSub = "- - - - - - - - - - - - - - - - - - - - - - - - - - ";
        # ----------------------------------------


        # Display the program information
        [Logging]::DisplayMessage("$($border)");

        # Show the full program name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Show the version, version name, and the release date of the version.
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");

        # Change of contents
        [Logging]::DisplayMessage("$($borderSub)");

        # Show the intended supported project
        [Logging]::DisplayMessage("Designed for $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)]");
        [Logging]::DisplayMessage("$($border)");
        [Logging]::DisplayMessage("$($border)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n`r`n");
    } # DrawProgramTitleHeader()
} # CommonCUI