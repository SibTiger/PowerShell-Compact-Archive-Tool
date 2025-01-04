<# PowerShell Compact-Archive Tool
 # Copyright (C) 2025
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
    Hidden static [string] $__borderDashLong = "----------------------------------------------------";


    # Border - Dash Spaced - Long
    # ---------------
    # A simple string that provides a long-dash spaced border.
    Hidden static [string] $__borderSubcategory = "- - - - - - - - - - - - - - - - - - - - - - - - - - ";


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
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);
        # -------------------------------------------------------------------


        # Display the program's full name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Display the version number, version name, and when the version was released (or Dev. Released)
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");
        # -------------------------------------------------------------------


        # Display a sub-border to show that there is a change of content
        [Logging]::DisplayMessage([CommonCUI]::__borderSubcategory);
        # -------------------------------------------------------------------


        # Display the current loaded project and its version information to the user.
        #  However, only if the project information is available.
        if ([ProjectInformation]::GetIsLoaded())
        {
            [Logging]::DisplayMessage("Project Loaded: $([ProjectInformation]::GetProjectName())");
        } # if : Project is Loaded


        # -------------------------------------------------------------------


        # Display the trailing borders to indicate the end of the Program Title.
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);


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
        # Declarations and Initializations
        # ----------------------------------------
        # This border will be displayed under the section title.
        [char] $border = '~';

        # This will state how many characters are in the Section Title.
        [int] $sectionTitleCharacters = $sectionTitle.Length;

        # This provides a border padding as how much length is to be provided for the initial border.
        #  Left side (before title) should have 5 border-characters
        #  Right side (after title) should have 5 border-characters
        [int] $sectionTitleBorderPadding = (5 * 2);

        # This variable will hold the full length of the Border that is to be rendered onto the
        #  terminal output buffer.
        [int] $sectionTitleBorderLength = 0;

        # This is the border, generated by this function, that will be displayed
        #  on the PowerShell's Terminal output buffer.
        #  Immediately add in the tabulation in the beginning.
        [string] $borderGenerated = "`t ";
        # ----------------------------------------



        # Display the section title
        [Logging]::DisplayMessage("`t`t  $($sectionTitle)");


        # Determine the size needed to render the border for the sectional title
        #  The algorithm works like this:
        #   5 + (Section Title / 2) + 5
        #  Thus, five border characters before the title, title length is divided by half,
        #          then after the title is five more border characters.
        #   I think this provides an even border for the majority of title sizes.
        $sectionTitleBorderLength = ($sectionTitleBorderPadding + ($sectionTitleCharacters  / 2));


        # Generate the border to fit the size of the section title.
        for ([int] $i = 0; $i -lt $sectionTitleBorderLength; $i++)
        {
            $borderGenerated += " " + $border;
        } # for : Render Variable-Length Border


        # Append the new line characters
        $borderGenerated += "`r`n";


        # Display a fancy border
        [Logging]::DisplayMessage($borderGenerated);
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
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);
    } # DrawMenuInstructions()




   <# Compile Instructions
    # -------------------------------
    # Documentation:
    #  This function will display that the project is being compiled at this moment.
    #   We will want to indicate to the user that they will have to patiently wait for
    #   the operation to end.  From this approach, in general but possibly with
    #   exceptions to the rule, the user is essentially hands-off during the compiling
    #   process.  Thus, any feedback provided by the user - is on hold until we are
    #   ready.
    # -------------------------------
    #>
    static [void] CompileInstructions()
    {
        # Display the common menu instructions
        [Logging]::DisplayMessage("Please wait patiently as $([ProjectInformation]::GetProjectName()) is being compiled. . .");

        # Display a border
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);
    } # CompileInstructions()




   <# Draw Waiting for User Response
    # -------------------------------
    # Documentation:
    #  This will display a message indicating that the program is currently waiting for user's feedback.
    #  NOTE: This function does NOT invoke the User Input functionality; this function should be
    #         called first before requesting the user's actual feedback.
    # -------------------------------
    # Input:
    #  [DrawWaitingForUserInputText] Type of Text to Display
    #   This will provide a visual sense as to what type of input that the program is expecting from
    #   the end-user.
    # -------------------------------
    #>
    static [void] DrawWaitingForUserResponse([DrawWaitingForUserInputText] $typeOfTextToDisplay)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $stringToDisplay = $null;      # This will show the type of response that the program
                                                #  is expecting from the end user.
        # ----------------------------------------


        # Determine what message is to be displayed to the user in regards to what input is expected.
        switch ($typeOfTextToDisplay)
        {
            # Waiting on your response
            ([DrawWaitingForUserInputText]::WaitingOnYourResponse)
            {
                $stringToDisplay = "Waiting on your response. . .";
                break;
            } # Waiting on your response



            # Please provide a new path or "Cancel"
            ([DrawWaitingForUserInputText]::PleaseProvideANewPath)
            {
                $stringToDisplay = "Please provide a new path or `"Cancel`" to cancel. . .";
                break;
            } # Please provide a new path



            # Please provide a number or "Cancel"
            ([DrawWaitingForUserInputText]::ProvideNumericValue)
            {
                $stringToDisplay = "Please provide a number or `"Cancel`" to cancel. . .";
                break;
            } # Please provide a number



            # Incorrect enumerator value; use the 'Waiting on your response' as the default
            #  response.
            default
            {
                $stringToDisplay = "Waiting on your response. . .";
            } # Default
        } # Switch: Determine Message




        # Let the user know that the program is waiting on their response.
        [Logging]::DisplayMessage($stringToDisplay);

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
    #  [string] Item Sub-Description (Optional)
    #   This will provide further information regarding the menu item.
    #   Ideal to provide information regarding the item's current state or essentially
    #   what the item does within the current session.
    #       NOTE: This can be nullable; it is not absolutely required.
    #  [bool] Insert a New White Space
    #   When true, this will add a new white space BELOW the current menu item that is
    #   being drawn.  This can be useful to help the reader to see each item WITHOUT seeing
    #   an abundance of clutter.  When false, however, there will be no additional white space
    #   below the current menu item that is being drawn.
    # -------------------------------
    #>
    static [void] DrawMenuItem([char] $itemKey, `               # The hotkey for the menu item
                                [string] $itemDescription, `    # Brief description of the menu item
                                [string] $itemSubDescription, ` # More information regarding the item (Optional)
                                [string] $itemCurrentSetting, ` # Provides an brief outlook regarding the current setting.
                                [bool] $insertNewWhiteSpace)    # Provide a Whitespace to separate each menu items
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this variable to determine how the menu item will be formatted.
        [string] $displayMenuOutputFormatting = $NULL;

        # This will hold the whitespace (new line) characters, if and only if, requested
        #  to be displayed.
        [string] $provideWhiteSpace = $NULL;
        # ----------------------------------------


        # Are we supposed to provide a new line below the menu item?
        if ($insertNewWhiteSpace)
        {
            $provideWhiteSpace = "`r`n";
        } # if : Provide a new line


        # Construct the bare minimal of the menu item string
        $displayMenuOutputFormatting = (" [$($itemKey)] - $($itemDescription)");




        # Add in any other strings, if requested todo so.
        # - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Was the Sub-Description provided?
        if (![CommonIO]::IsStringEmpty($itemSubDescription))
        {
            # Add the Sub-Description
            $displayMenuOutputFormatting += ("`r`n`t$($itemSubDescription)");
        } # if : Item Sub Description Provided


        # Was the Current Setting provided?
        if (![CommonIO]::IsStringEmpty($itemCurrentSetting))
        {
            # Add the Current Setting
            $displayMenuOutputFormatting += ("`r`n`t`t$($itemCurrentSetting)");
        } # if : Item Current Setting Provided

        # - - - - - - - - - - - - - - - - - - - - - - - - - -


        # Apply the extra whitespace padding, if it was requested
        if ($insertNewWhiteSpace)
        {
            # Provide the extra whitespace
            $displayMenuOutputFormatting += $provideWhiteSpace;
        } # if : Apply Whitespace Padding


        # Display the Menu Item as formatted.
        [Logging]::DisplayMessage($displayMenuOutputFormatting);
    } # DrawMenuItem()




   <# Draw Incorrect Menu Option
    # -------------------------------
    # Documentation:
    #  This function is intended to provide a friendly error message to the user, by indicating
    #   that the menu option that they had selected - is not available or valid.
    # -------------------------------
    #>
    static [void] DrawIncorrectMenuOption()
    {
        # Provided the error message
        [Logging]::DisplayMessage("`r`n");
        [Logging]::DisplayMessage("`t<!>`tIncorrect Option`t<!>");
        [Logging]::DisplayMessage([CommonCUI]::__borderDashLong);
        [Logging]::DisplayMessage("Your request could not be executed as the option was not valid or not available at this time!");


        # Wait for the user to provide feedback.
        [Logging]::GetUserEnterKey();
    } # DrawIncorrectMenuOption()




   <# Draw Update Program Information
    # -------------------------------
    # Documentation:
    #  This function, usually combined with a Web Browser opened to a specific web site, will
    #   display information regarding the current version of the program.  This information is
    #   essential, such that the user knows what version is presently running or presently
    #   already installed on the system as of right now.  Thus, provides the user with the
    #   information if they need to update or if they are still using the latest and greatest
    #   version available.
    # -------------------------------
    #>
    static [void] DrawUpdateProgramInformation()
    {
        # Clear the Terminal's output buffer
        [CommonIO]::ClearBuffer();

        # Display the Program Title
        [CommonCUI]::DrawProgramTitleHeader();


        # Show the user that they are at the Program Update section
        [CommonCUI]::DrawSectionHeader("Update $($Global:_PROGRAMNAME_)");


        # Display the instructions for the user
        [Logging]::DisplayMessage("Please check and download the latest version of $($Global:_PROGRAMNAME_).");
        [Logging]::DisplayMessage([CommonCUI]::__borderSubcategory);

        # Name of the program
        [Logging]::DisplayMessage("Program Name:`r`n`t$($Global:_PROGRAMNAME_)");

        # Program's Version information
        [Logging]::DisplayMessage("Program Version:`r`n`t$($Global:_VERSION_) - (Version Name: $($Global:_VERSIONNAME_))");

        # Program's Version Release Date
        [Logging]::DisplayMessage("Version Released Date:`r`n`t$($Global:_RELEASEDATE_)");
    } # DrawUpdateProgramInformation()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will provide a centralized way to retrieve the user's feedback while following
    #   a consistent behavior, which helps the user identify when the program is ready for interaction
    #   with the end-user.
    #
    # NOTE: Do keep in mind that user interactions are logged.
    # -------------------------------
    # Input:
    #  [DrawWaitingForUserInputText] Type of Text to Display
    #   This will provide a visual sense as to what type of input that the program is expecting from
    #   the end-user.
    # -------------------------------
    # Output:
    #  [string] User's Feedback
    #   Returns the user's feedback
    # -------------------------------
    #>
    static [string] GetUserInput([DrawWaitingForUserInputText] $typeOfTextToDisplay)
    {
        # Let the user know that the program is currently waiting for their
        #  response.
        [CommonCUI]::DrawWaitingForUserResponse($typeOfTextToDisplay);

        # Retrieve the user's feedback and return their desired request such
        #  that it can be
        #  evaluated further.
        return [Logging]::GetUserInput();
    } # GetUserInput()




   <# Browse for Target File
    # -------------------------------
    # Documentation:
    #  This function will allow the ability for the user to browse for a specific file within their filesystem.
    #   Once a path had been provided, this function will check to make sure that the path exists within the
    #   system's filesystem.  The results if the path exists will determine the result in which this function
    #   returns.  As such, if the path exists - then the function will return a $true.  Otherwise, if the path
    #   does not exist within the provided location, then a $false will be given instead.
    # -------------------------------
    # Input:
    #  [string] Brief Description
    #   This provides a very brief reminder to the user of what is expected.
    #  [string] Extension
    #   Specifies that the file MUST have a specific file extension associated with the input.
    #
    #   NOTE: Wildcard is acceptable; any file extension is allowed or optional.
    #  [System.Collections.ArrayList] Path to Target File
    #   This will provide the the path to the desired target file.
    # -------------------------------
    # Output:
    #  [bool] Path Validation
    #   $true = The given path exists.
    #   $false = The given path did not exist.
    # -------------------------------
    #>
    static [bool] BrowseForTargetFile([string] $briefDescription,                   # Brief description
                                    [string] $extension,                            # Extension that is allowed
                                    [System.Collections.ArrayList] $pathToTarget)   # File Target
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the user's path temporarily so that we may further validate the path.
        [string] $cacheTarget = $null;
        # ----------------------------------------


        # Make sure that the extension contains a period at the very beginning; but skip this step if a wildcard is in place.
        if (($extension -ne "*") -and `     # Wildcard is in use
            ($extension[0] -ne "."))        # First character is not a period
        {
            # Add the period
            $extension = $extension.Insert(0, ".");
        } # If : Provide a Period



        # Provide some padding from the content and the requested input.
        [Logging]::DisplayMessage("`r`n`r`n")


        # Show a brief description to the user such that they know what the program is expecting.
        [Logging]::DisplayMessage($briefDescription);


        # Display a border to separate the input from the program's content.
        [Logging]::DisplayMessage("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");



        # Ask the user to provide a new path
        [CommonCUI]::DrawWaitingForUserResponse([DrawWaitingForUserInputText]::PleaseProvideANewPath);


        # Obtain the user's feedback
        $cacheTarget = [Logging]::GetUserInput();


        # Make sure that the path is valid and is a file.
        if (([CommonIO]::CheckPathExists($cacheTarget, $true)) -and `               # Path is valid?
            ((Get-Item $cacheTarget) -is [System.IO.FileInfo]) -and `               # Target is a Directory
                (($extension -eq "*") -or `                                         # Any extension is allowed
                ([System.IO.Path]::GetExtension($cacheTarget) -eq $extension)))     # OR: Specific extension was provided
        {
            # Target is validated as a file; we may use this path.
            $pathToTarget.Add($cacheTarget);

            # Path is valid
            return $true;
        } # if : Path is Valid and is a File


        # Path is not valid and will not be used.
        return $false;
    } # BrowseForTargetFile()




   <# Browse for Target Directory
    # -------------------------------
    # Documentation:
    #  This function will allow the ability for the user to browse for a specific folder within their filesystem.
    #   Once a path had been provided, this function will check to make sure that the path exists within the
    #   system's filesystem.  The results if the path exists will determine the result in which this function
    #   returns.  As such, if the path exists - then the function will return a $true.  Otherwise, if the path
    #   does not exists within the provided location, then a $false will be given instead.
    # -------------------------------
    # Input:
    #  [string] Instructions
    #   Provide instructions to the user as to what is expected.
    #  [string] (REFERENCE) Path to Target Directory
    #   This will provide the the path to the desired target directory.
    # -------------------------------
    # Output:
    #  [bool] Path Validation
    #   $true = The given path exists.
    #   $false = The given path did not exist.
    # -------------------------------
    #>
    static [bool] BrowseForTargetDirectory([string] $instructions,  ` # Show description to the user; reminder
                                            [ref] $pathToTarget)      # Target Directory
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the user's path temporarily so that we may further validate the path.
        [string] $cacheTarget = $null;
        # ----------------------------------------



        # Provide some padding from the content and the requested input.
        [Logging]::DisplayMessage("`r`n`r`n")


        # Show a brief description to the user such that they know what the program is expecting.
        [Logging]::DisplayMessage($instructions);


        # Display a border to separate the input from the program's content.
        [Logging]::DisplayMessage("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");



        # Ask the user to provide a new path
        [CommonCUI]::DrawWaitingForUserResponse([DrawWaitingForUserInputText]::PleaseProvideANewPath);


        # Obtain the user's feedback
        $cacheTarget = [Logging]::GetUserInput();


        # If incase the user is pointing at a file by mistake, trim out the leaf.
        if (([CommonIO]::CheckPathExists($cacheTarget, $true)) -and `   # Path is valid?
            ((Get-Item $cacheTarget) -is [System.IO.DirectoryInfo]))    # Target is a Directory
        {
            # Target is validated as a directory; we may use this path.
            $pathToTarget.Value = $cacheTarget;

            # Path is valid
            return $true;
        } # if : Path is Valid and is a Directory

        # Path is not valid and will not be used.
        return $false;
    } # BrowseForTargetDirectory()




   <# Draw Formatted List
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to present a list to the user with the requested formatting style.
    #   Thus, this function can allow: Bullet, Number, or just provide indention to the list.  When interacting
    #   with this function, this function is only intended with one message - one item to display.  As such,
    #   we do not support an array of messages that are to be provided in a list form.  In addition, this
    #   function does not keep track of the list's flow.  Meaning, when providing an item to display -
    #   it is possible to have the following:
    #       - Parent                            [Position 0]
    #           1 Step 1                        [Position 1]
    #                       & Avoid the Goose   [Position 4]
    #       - New Parent                        [Position 0]
    #                           * Bonk!         [Position 5]
    #   Essentially, when providing a list, you are in complete control.  Whatever is asked, you get it in return.
    # -------------------------------
    # Input:
    #  [unsigned int] Position Level
    #   Defines how many space characters will be drawn - to provide indentions.
    #  [Char] Character Symbol
    #   Optionally, can be used to provide a bullet or number like list.  Without
    #    a symbol, the message will only carry indention.
    #  [string] Message to Present
    #   The message that will be displayed to the user with the list formatting.
    # -------------------------------
    #>
    static [void] DrawFormattedList([uint] $position, `     # Level of the message
                                    [char] $symbol, `       # Symbol to present before the message (Optional)
                                    [string] $message)      # Message to present
    {
        # Declarations and Initializations
        # ----------------------------------------
        # We will use this as a way to provide indention to the message.
        [string] $indentionSpacing = "  ";

        # This will hold the final message that will be presented to the user.
        [string] $formattedMessage = $NULL;
        # ----------------------------------------


        # Determine how much we are to indent the message?
        for([uint] $i = 0; $i -lt $position; $i++)
        {
            # Provide the indention spacing
            $formattedMessage += $indentionSpacing;
        } # for : Indention


        # Apply the symbol, if it is used.
        if (![CommonIO]::IsStringEmpty($symbol))
        {
            # Attach the symbol now before we append the message onto the message.
            $formattedMessage += [string]$symbol + " ";
        } # If : Attach symbol


        # Attach the initial message
        $formattedMessage += $message;


        # Display the final formatted message
        [Logging]::DisplayMessage($formattedMessage);
    } # DrawFormattedList()




   <# Start-Up Screen
    # -------------------------------
    # Documentation:
    #  This function is essentially like a splash-screen feature, but for the terminal.
    #   With this feature, it may provide some information regarding the application
    #   such as: the program's version, release details, license, and much more.
    # -------------------------------
    #>
    static [void] StartUpScreen()
    {
        # Display the creator's name and the program's full name
        [Logging]::DisplayMessage("   Nicholas Gautier`t`t`t`t$($Global:_PROGRAMNAME_)");


        # Display the Word Art
        [Logging]::DisplayMessage([CommonCUI]::StartUpScreenWordArt());


        # Display the program's license and the version
        [Logging]::DisplayMessage("   $($Global:_LICENSE_)" + `
                                "`t`t`t`t`t`t`t`t`t" + `
                                "Version $($Global:_VERSION_) $($Global:_VERSIONNAME_)");


        # Display the date that the version was released right below the version number.
        [Logging]::DisplayMessage("`t`t`t`t`t`t`t`t`t`t`t`t`t" + `
                                "$($Global:_RELEASEDATE_)");


        # Show the user their current Operating System and PowerShell version on the splash screen.
        [Logging]::DisplayMessage("`r`n`t`t`t`t`tPowerShell Version: $([SystemInformation]::PowerShellVersion()) [Running on $([SystemInformation]::OperatingSystem())]");


        # Separate the Banner content from the starting up notification.
        [Logging]::DisplayMessage("  |------------------------------------------------------------------------------------------------------------------------|");


        # Let the user know that the program is about to begin.
        [Logging]::DisplayMessage("`r`n`r`n`r`n" + `
                                "Starting. . .");
    } # StartUpScreen()




   <# Start-Up Screen - Word Art
    # -------------------------------
    # Documentation:
    #  This function merely helps to setup the Word Art that will be used for
    #   the application's startup screen.  I use this function such that I may
    #   easily setup the appropriate word art as needed.
    #
    # Word Art for the report's header were provided by this website:
    #  http://patorjk.com/software/taag
    #  FONT: Doh
    #  All other settings set to 'default'.
    # -------------------------------
    #>
    static [string] StartUpScreenWordArt()
    {
        # We will craft the word art and then immediately return it.
        return ("  //======================================================================================================================\\`r`n" + `
                "  |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|`r`n" + `
                "  |:                                                                                                                      :|`r`n" + `
                "  |:    PPPPPPPPPPPPPPPPP      SSSSSSSSSSSSSSS         CCCCCCCCCCCCC               AAA         TTTTTTTTTTTTTTTTTTTTTTT    :|`r`n" + `
                "  |:    P::::::::::::::::P   SS:::::::::::::::S     CCC::::::::::::C              A:::A        T:::::::::::::::::::::T    :|`r`n" + `
                "  |:    P::::::PPPPPP:::::P S:::::SSSSSS::::::S   CC:::::::::::::::C             A:::::A       T:::::::::::::::::::::T    :|`r`n" + `
                "  |:    PP:::::P     P:::::PS:::::S     SSSSSSS  C:::::CCCCCCCC::::C            A:::::::A      T:::::TT:::::::TT:::::T    :|`r`n" + `
                "  |:      P::::P     P:::::PS:::::S             C:::::C       CCCCCC           A:::::::::A     TTTTTT  T:::::T  TTTTTT    :|`r`n" + `
                "  |:      P::::P     P:::::PS:::::S            C:::::C                        A:::::A:::::A            T:::::T            :|`r`n" + `
                "  |:      P::::PPPPPP:::::P  S::::SSSS         C:::::C                       A:::::A A:::::A           T:::::T            :|`r`n" + `
                "  |:      P:::::::::::::PP    SS::::::SSSSS    C:::::C                      A:::::A   A:::::A          T:::::T            :|`r`n" + `
                "  |:      P::::PPPPPPPPP        SSS::::::::SS  C:::::C                     A:::::A     A:::::A         T:::::T            :|`r`n" + `
                "  |:      P::::P                   SSSSSS::::S C:::::C                    A:::::AAAAAAAAA:::::A        T:::::T            :|`r`n" + `
                "  |:      P::::P                        S:::::SC:::::C                   A:::::::::::::::::::::A       T:::::T            :|`r`n" + `
                "  |:      P::::P                        S:::::S C:::::C       CCCCCC    A:::::AAAAAAAAAAAAA:::::A      T:::::T            :|`r`n" + `
                "  |:    PP::::::PP          SSSSSSS     S:::::S  C:::::CCCCCCCC::::C   A:::::A             A:::::A   TT:::::::TT          :|`r`n" + `
                "  |:    P::::::::P          S::::::SSSSSS:::::S   CC:::::::::::::::C  A:::::A               A:::::A  T:::::::::T          :|`r`n" + `
                "  |:    P::::::::P          S:::::::::::::::SS      CCC::::::::::::C A:::::A                 A:::::A T:::::::::T          :|`r`n" + `
                "  |:    PPPPPPPPPP           SSSSSSSSSSSSSSS           CCCCCCCCCCCCCAAAAAAA                   AAAAAAATTTTTTTTTTT          :|`r`n" + `
                "  |:                                                                                                                      :|`r`n" + `
                "  |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|`r`n" + `
                "  \\======================================================================================================================//");
    } # StartUpScreenWordArt()
} # CommonCUI




<# Draw Waiting for User Input Text [ENUM]
 # -------------------------------
 # Which text will be displayed to the user in regards to the type of
 #  input that the program is expecting.
 # -------------------------------
 #>
enum DrawWaitingForUserInputText
{
    WaitingOnYourResponse   = 0; # This will display "Waiting on your response. . ."
    PleaseProvideANewPath   = 1; # This will display "Please provide a new path or 'Cancel' to cancel. . ."
    ProvideNumericValue     = 2; # This will display "Please provide a number or 'Cancel' to cancel. . ."
} # DrawWaitingForUserInputText