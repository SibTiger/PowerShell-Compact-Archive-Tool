<# Project Website Services
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide common functionalities for accessing the project's
 #  various websites.  A project may contain website locations for accessing
 #  traditional websites as well as Web services:
 #   - Homepage
 #   - Repository
 #   - Wiki
 #   - Potentially More
 #  When wanting to view the desired websites, the functions within this object
 #  will take in account of the user's settings as well as if such URL's are
 #  available within the project.  To further elaborate regarding the user's
 #  settings, the user has the option allow Explorer Calls to be allowed,
 #  which if allowed - the user's preferred Internet Browser will automatically
 #  open to the desired webpage.  In contrast, if the Explorer Calls are
 #  disallowed, the website will only be displayed on to the terminal's output
 #  buffer.  But these options are only available if the project's sites are
 #  available, if the sites are not provided in the Project's Information -
 #  there's nothing to display.
 #>




 class ProjectSiteSources
 {
    #region Check Website Availability and Status


   <# Check Site Availability
    # -------------------------------
    # Documentation:
    #  This function will check to see if the website is presently available.
    #  The availability will be a factor in several places:
    #   - Does site exist in the Project's Information?
    #   - Is the website presently active?
    #  If both of these conditions are true, then the website is presently
    #  available for the user to access freely.  However if either of the
    #  conditions are false, then the website is not available or no valid
    #  site URL was provided in the first place in the Project's Information.
    # -------------------------------
    # Input:
    #  [string] Site
    #    The desired website to inspect its availability.
    # -------------------------------
    # Output:
    #  [bool] Availability Status
    #    Determines if the Website is available for the user.
    #    - True : Website is available for the user.
    #    - False: Website is not available to the user.
    # -------------------------------
    #>
    static [bool] CheckSiteAvailability([string] $site)
    {
        # Check the website's availability status
        if (([ProjectSiteSources]::__CheckSiteAvailability_SiteProvided("$($site)") -and `
            ([ProjectSiteSources]::__CheckSiteAvailability_SiteResponse("$($site)")))    `
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
    #  This function will check the site's string value and determine
    #   if the string is $Null.  If the String is null, then the site
    #   was never given within the Project's Information.  This could
    #   be due to the Project not having such resource or never provided
    #   withing the Project's information.
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
    # NOTES: This function is inspired by this question:
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
        # This will hold the main Website Request
        [System.Net.HttpWebRequest] $siteRequest = $null;#[System.Net.HttpWebRequest]::Create("$($site)");

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


        # Now that we had finished evaluating the website, close the site's response from the Request instance.
        $siteResponse.Close();


        # Return the site's availability.
        return $siteReady;
    } # __CheckSiteAvailability_SiteResponse()



    # endregion
 } # ProjectSiteSources
