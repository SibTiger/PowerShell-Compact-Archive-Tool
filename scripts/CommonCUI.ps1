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
    #  This function will display the Program's Title and Version Information on to
    #   the terminal.  This allows the user to see what program is presently running
    #   on the shell and the program's current version.
    # -------------------------------
    #>
    static [void] DrawProgramTitleHeader()
    {
        # Display the top border
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");
        # -------------------------------------------------------------------


        # Display the program's full name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Display the version number, version name, and when the version was released (or Dev. Released)
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");
        # -------------------------------------------------------------------


        # Display a sub-border to show that there is a change of content
        [Logging]::DisplayMessage("$([CommonCUI]::borderSubcategory)");
        # -------------------------------------------------------------------


        # Display the intended supported ZDoom project name and codename
        [Logging]::DisplayMessage("Designed for $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)]");
        # -------------------------------------------------------------------


        # Display the trailing borders to indicate the end of the Program Title.
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n`r`n");
    } # DrawProgramTitleHeader()




   <# Draw Section Header
    # -------------------------------
    # Documentation:
    #  This function will display the section header to indicate where the user
    #   is presently located within the program's layout.
    # -------------------------------
    # Input:
    #  [string] Section Title
    #   The title of the section that will be displayed.
    # -------------------------------
    #>
    static [void] DrawSectionHeader([string] $sectionTitle)
    {
        # Display the section title
        [Logging]::DisplayMessage("`t`t  $sectionTitle");

        # Display a fancy border
        [Logging]::DisplayMessage("`t~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n");
    } # DrawSectionHeader()




   <# Draw Menu Instructions
    # -------------------------------
    # Documentation:
    #  This function will display the Menu instructions to the user so that they know
    #   how to interact with the application.  The instructions are to be minimal but yet
    #   concise so that the user can easily start using the program without being
    #   overwhelmed with an 6abundance of text.
    # -------------------------------
    #>
    static [void] DrawMenuInstructions()
    {
        # Display the common menu instructions
        [Logging]::DisplayMessage("Select from the following available options:");

        # Display a border
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");
    } # DrawMenuInstructions()




   <# Draw Waiting for User Response
    # -------------------------------
    # Documentation:
    #  This will display a message indicating that the program is currently waiting for user's feedback.
    #  NOTE: This function does NOT invoke the User Input functionality; this function should be
    #         called first before requesting the user's actual feedback.
    # -------------------------------
    #>
    static [void] DrawWaitingForUserResponse()
    {
        # Let the user know that the program is waiting on their response.
        [Logging]::DisplayMessage("Waiting on your response. . .");

        # Display a border to separate the input from the program's content.
        [Logging]::DisplayMessage("------------------------------");
    } # DrawWaitingForUserResponse()




   <# Draw Menu List Item
    # -------------------------------
    # Documentation:
    #  This function will format a menu item to a list.  The item will include a
    #   Feedback Key and a brief description or information of the item being listed.
    # -------------------------------
    # Input:
    #  [char] Feedback Key
    #   The character key that the user requests to access the item.
    #  [string] Item Description
    #   The description or information of the menu item.
    # -------------------------------
    #>
    static [void] DrawMenuItem([char] $itemKey,
                                [string] $itemDescription)
    {
        # Display the Menu Item as formatted.
        [Logging]::DisplayMessage(" [$($itemKey)] - $($itemDescription)");
    } # DrawMenuItem()
} # CommonCUI