<# Website Resources
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide common functionalities for accessing various
 #  websites.  Such websites could be related to a specific project.
 #  A project may contain website locations for accessing traditional
 #  websites as well as Web services:
 #   - Homepage
 #   - Repository
 #   - Wiki
 #   - Potentially More
 #  When wanting to view the desired websites, the functions within this object
 #  will take in account of the user's settings as well as if such URL's are
 #  available to access.  To further elaborate regarding the user's
 #  settings, the user has the option allow Explorer Calls to be allowed,
 #  which if allowed - the user's preferred Internet Browser will automatically
 #  open to the desired webpage.  In contrast, if the Explorer Calls are
 #  disallowed, the website will only be displayed on to the terminal's output
 #  buffer.  But these options are only available if the sites are available.
 #>




 class WebsiteResources
 {
    #region Access Web Sites


   <# Access Web Site - Main Task [Private]
    # -------------------------------
    # Documentation:
    #  This function will open the desired web page using the user's preferred
    #   web browser.  Once this function had been called, there will be several
    #   conditions that will be checked:
    #   - Does the user allow Web Browser to be used?
    #   - Is the site reachable?
    #  The checks performed will determine if it is possible to open the web site
    #   using the preferred Web Browser or to only output the web page URL to the
    #   terminal's output buffer.
    # -------------------------------
    # Input:
    #  [string] Site URL
    #   The web page that will be accessed.
    #  [string] Site Name
    #   The name of the web page that we will be accessing.
    #  [string] Version (Optional; nullable)
    #   When checking for updates, this value will be visible to the user.
    #  [bool] Update Behavioral
    #   When true, this will cause some extra information to be present in
    #   the terminal's output buffer.
    #  [UserPreferences] User Preferences
    #   User's present configuration; required for Web Browser settings
    #  [bool] Ignore User Settings
    #   When true, this will ignore the user's settings and forcefully open the
    #   web page using the user's preferred Web Browser.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    Hidden static [bool] __AccessWebSite([string] $siteURL,                 # The Site's URL to access
                                        [string] $siteName,                 # The Site's name
                                        [string] $projectVersion,           # The version of the target (Optional)
                                        [bool] $update,                     # Perform the Update Behavioral
                                        [UserPreferences] $userPreferences, # User Preferences
                                        [bool] $ignoreUserSetting)          # Ignore User's Settings and open Web Browser
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will provide the overall status of the entire operation.
        [bool] $operationStatus = $true;
        # ----------------------------------------


        # Does the user allow for the Web Browsers to be used?
        if (($userPreferences.GetUseWindowsExplorer() -eq $true) -or `
            ($ignoreUserSetting -eq $true))
        {
            # Open the desired web page.
            [Logging]::DisplayMessage("Accessing $($siteName). . .");
            [Logging]::DisplayMessage("URL: $($siteURL)");

            [IOCommon]::AccessWebpage("$($siteURL)");
        }

        return $operationStatus;
    } # AccessWebSite()




   <# Access Web Site - General Web Page
    # -------------------------------
    # Documentation:
    #  This function is a bridge to the AccessWebSite() member function.
    #   This function will allow the user to view the content via the Web
    #   Browser, if and only if, possible.
    # -------------------------------
    # Input:
    #  [string] Site URL
    #   The web page that will be accessed.
    #  [string] Site Name
    #   The name of the web page that we will be accessing.
    #  [UserPreferences] User Preferences
    #   User's present configuration; required for Web Browser settings
    #  [bool] Ignore User Settings
    #   When true, this will ignore the user's settings and forcefully open the
    #   web page using the user's preferred Web Browser.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    static [bool] AccessWebSite_General([string] $siteURL,                  # The Site's URL to access
                                        [string] $siteName,                 # The Site's name
                                        [UserPreferences] $userPreferences, # User Preferences
                                        [bool] $ignoreUserSetting)          # Ignore User's Settings and open Web Browser
    {
        # Access the Main Function that will open the Web Browser functionality; return
        #  the operation status back to the calling function.
        return [WebsiteResources]::__AccessWebSite("$($siteURL)",           ` # Site URL
                                                    "$($siteName)",         ` # Site's Name (or Nice name)
                                                    "$($null)",             ` # Target's current version (we are not interested in this option)
                                                    $false,                 ` # Update Protocol
                                                    $userPreferences,       ` # User's Preferences
                                                    $ignoreUserSetting);    ` # Forcefully Open the Web Browser
    } # AccessWebSite_General()




   <# Access Web Site - Update Web Page
    # -------------------------------
    # Documentation:
    #  This function is a bridge to the AccessWebSite() member function.
    #   This function will allow the user to view the content via the Web
    #   Browser, if and only if, possible.
    # -------------------------------
    # Input:
    #  [string] Site URL
    #   The web page that will be accessed.
    #  [string] Site Name
    #   The name of the web page that we will be accessing.
    #  [string] Version
    #   When checking for updates, this value will be visible to the user.
    #  [UserPreferences] User Preferences
    #   User's present configuration; required for Web Browser settings
    #  [bool] Ignore User Settings
    #   When true, this will ignore the user's settings and forcefully open the
    #   web page using the user's preferred Web Browser.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    static [bool] AccessWebSite_Update([string] $siteURL,                   # The Site's URL to access
                                        [string] $siteName,                 # The Site's name
                                        [string] $projectVersion,           # The version of the target (Optional)
                                        [UserPreferences] $userPreferences, # User Preferences
                                        [bool] $ignoreUserSetting)          # Ignore User's Settings and open Web Browser
    {
        # Access the Main Function that will open the Web Browser functionality; return
        #  the operation status back to the calling function.
        return [WebsiteResources]::__AccessWebSite("$($siteURL)",           ` # Site URL
                                                    "$($siteName)",         ` # Site's Name (or Nice Name)
                                                    "$($projectVersion)",   ` # Target's current version
                                                    $true,                  ` # Update Protocol
                                                    $userPreferences,       ` # User's Preferences
                                                    $ignoreUserSetting);    ` # Forcefully Open the Web Browser
    } # AccessWebSite_Update()


    #endregion




    #region Check Website Availability and Status


   <# Check Site Availability
    # -------------------------------
    # Documentation:
    #  This function will check to see if the website is presently available.
    #  The availability will be a factor in several places:
    #   - Does site exist with the given argument?
    #   - Is the website presently active?
    #  If both of these conditions are true, then the website is presently
    #  available for the user to access freely.  However if either of the
    #  conditions are false, then the website is not available or no valid
    #  site URL was provided.
    # -------------------------------
    # Input:
    #  [string] Site
    #    The desired website to inspect its availability state.
    # -------------------------------
    # Output:
    #  [bool] Availability Status
    #    Determines if the desired Website is available for the user to access.
    #    - True : Website is available for the user.
    #    - False: Website is not available to the user.
    # -------------------------------
    #>
    static [bool] CheckSiteAvailability([string] $site)
    {
        # Check the website's availability status
        if (([WebsiteResources]::__CheckSiteAvailability_SiteProvided("$($site)") -and `
            ([WebsiteResources]::__CheckSiteAvailability_SiteResponse("$($site)")))    `
            -eq $true)
        {
            # The website is presently available for the user to access.
            return $true;
        } # IF: Site is Available


        # The site is not available
        return $false;
    } # CheckSiteAvailability()




    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Private Functions - Check Site Availability




   <# Check Site Availability : Site Provided
    # -------------------------------
    # Documentation:
    #  This function will check the site's string value and determine if the
    #   string is $Null.  If the String is null, then the site was never populated.
    # -------------------------------
    # Input:
    #  [string] Site
    #    The desired website string to inspect.
    # -------------------------------
    # Output:
    #  [bool] String Check
    #    Determines if string is $Null
    #    - True : Website string is not $null.
    #    - False: Website string is $null or not available.
    # -------------------------------
    #>
    Hidden static [bool] __CheckSiteAvailability_SiteProvided([string] $site)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will provide the status of the site's string value.
        [bool] $status = $true;
        # ----------------------------------------


        # Check if the String of the site is null.
        if ($site -eq "$($null)")
        {
            # Because the site string is null, the option to access the site is not possible.
            #  As such, mark the site as not available.
            return $false;
        } # If: Site is $null


        # Return the status of the value check.
        return $status;
    } # __CheckSiteAvailability_SiteProvided()




   <# Check Site Availability : Site Response
    # -------------------------------
    # Documentation:
    #  This function will check if the site is currently available
    #   by checking the site's response.  If the Website is responding
    #   to this function's queries, then that would mean that the
    #   webpage is presently active and reachable for the user to easily
    #   access.  However, in contrast, if the page is not responding to
    #   the queries, then that would mean that the webpage is not
    #   available for the user to access openly.
    #
    # NOTE: If the website takes a long time to reach or process requests,
    #        then this function could temporarily lock the program until the
    #        a timeout occurs from the site request.
    #
    # Developer NOTE: This function is inspired by this question:
    #  https://stackoverflow.com/a/20262872/11314373
    # -------------------------------
    # Input:
    #  [string] Site
    #    The desired website to inspect.
    # -------------------------------
    # Output:
    #  [bool] Response Status
    #    Determines if Website is currently active
    #    - True : Site is presently available for access.
    #    - False: Site is presently NOT available for access.
    # -------------------------------
    #>
    Hidden static [bool] __CheckSiteAvailability_SiteResponse([string] $site)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will hold the main Website to Request
        [System.Net.HttpWebRequest] $siteRequest = $null;

        # This will hold the Site's response.
        [System.Net.HttpWebResponse] $siteResponse = $null;

        # Site Available and Ready to be accessed; this value will be returned.
        [bool] $siteReady = $true;
        # ----------------------------------------


        # Create and open the instance of the HTTP Request
        $siteRequest = [System.Net.HttpWebRequest]::Create("$($site)");

        # Now that the instance is supposedly open, now retrieve the site's response from the Request.
        $siteResponse = $siteRequest.GetResponse();


        # Evaluate the site's response.  Is the website available for us to access?
        if ($siteResponse.StatusCode -ne "OK")
        {
            # The website is not reachable; it is not possible to reach the website right now.
            $siteReady = $false;
        } # If : Website is not reachable


        # Now that we had finished evaluating the website, close the site's response from the
        #  Request instance.
        $siteResponse.Close();


        # Return the site's availability.
        return $siteReady;
    } # __CheckSiteAvailability_SiteResponse()



    # endregion
 } # WebsiteResources
