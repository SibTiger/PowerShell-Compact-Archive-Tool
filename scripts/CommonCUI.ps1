<# Common CUI
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold various commonly used instructions and procedures that are
 #  designed for the Console User Interface (CUI).  With these functions defined
 #  within this object, we can easily keep the environment unified and consistent
 #  throughout the entire program.  Further, these functions will help to reduce
 #  code duplication as various other functions - outside from this class - can be
 #  utilize these methods openly.  With the reduce of code duplication, we can
 #  spend more time on implementation of other functionalities and to easily
 #  maintain these member functions as necessary with minimal cost.
 #>




class CommonCUI
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Border - Dash - Long
    # ---------------
    # A simple string that provides a long-dashed border.
    Hidden static [string] $borderDashLong = "----------------------------------------------------";


    # Border - Dash Spaced - Long
    # ---------------
    # A simple string that provides a long-dash spaced border.
    Hidden static [string] $borderSubcategory = "- - - - - - - - - - - - - - - - - - - - - - - - - - ";


    #endregion



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
        # Display the program information
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");

        # Show the full program name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Show the version, version name, and the release date of the version.
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");

        # Change of contents
        [Logging]::DisplayMessage("$([CommonCUI]::borderSubcategory)");

        # Show the intended supported project
        [Logging]::DisplayMessage("Designed for $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)]");
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n`r`n");
    } # DrawProgramTitleHeader()




   <# Draw Section Header
    # -------------------------------
    # Documentation:
    #  This function will provide a header for the desired section.
    # -------------------------------
    # Input:
    #  [string] Section Title
    #   The title of the section that will be drawn.
    # -------------------------------
    #>
    static [void] DrawSectionHeader([string] $sectionTitle)
    {
        [Logging]::DisplayMessage("`t`t  $sectionTitle");
        [Logging]::DisplayMessage("`t~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n");
    } # DrawSectionHeader()




   <# Draw Menu Instructions
    # -------------------------------
    # Documentation:
    #  This function will display the Menu instructions to the user so that they know
    #   how to interact with the application.  The instructions are to be minimal but yet
    #   concise so that the user can easily start using the program, but not to the point
    #   of flooding the returning user.
    # -------------------------------
    #>
    static [void] DrawMenuInstructions()
    {
        [Logging]::DisplayMessage("Select from the following available options:");
        [Logging]::DisplayMessage("----------------------------------------------------");
    } # DrawMenuInstructions()




   <# Draw Waiting for User Response
    # -------------------------------
    # Documentation:
    #  Displays a string indicating to the user that the program is waiting for feedback
    #   from the end-user.
    #  NOTE: This function does not invoke User Input functionality.
    # -------------------------------
    #>
    static [void] DrawWaitingForUserResponse()
    {
        # Let the user know that the program is waiting on their response.
        [Logging]::DisplayMessage("Waiting on your response. . .");
        [Logging]::DisplayMessage("------------------------------");
    } # DrawWaitingForUserResponse()




   <# Draw Menu List Item
    # -------------------------------
    # Documentation:
    #  This will display a menu item with a 'Key' and a description for the 'key'.
    # -------------------------------
    # Input:
    #  [char] Item Key
    #   The character that the user selects.
    #  [string] Item Description
    #   The description for the menu item.
    # -------------------------------
    #>
    static [void] DrawMenuItem([char] $itemKey,
                                [string] $itemDescription)
    {
        [Logging]::DisplayMessage(" [$($itemKey)] - $($itemDescription)");
    } # DrawMenuItem()
} # CommonCUI