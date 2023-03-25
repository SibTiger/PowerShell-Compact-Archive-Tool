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
    #   web browser.  Once this function had been called, we will need to assure
    #   that we are able to reach the desired site.
    #  The check performed will determine if it is possible to open the web site
    #   using the preferred Web Browser or to only output the web page URL to the
    #   terminal's output buffer.
    # -------------------------------
    # Input:
    #  [string] Site URL
    #   The web page that will be accessed.
    #  [string] Site Name
    #   The name of the web page that we will be accessing.
    #  [bool] Update Behavioral
    #   When true, this will cause some extra information to be present in
    #   the terminal's output buffer.
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    Hidden static [bool] __AccessWebSite([string] $siteURL, `               # The Site's URL to access
                                        [string] $siteName, `               # The Site's name
                                        [bool] $update)                     # Perform the Update Behavioral
    {
        # Declarations and Initializations
        # ----------------------------------------
        # This will provide the overall status of the entire operation.
        [bool] $operationStatus = $false;

        # Fall-back: Show URL to the user, allow them to perform manual approach.
        #  This is used only if the requested webpage cannot be accessed for whatever
        #  reason.  Regardless if user setting or inaccessible error.
        [bool] $manualFallBack = $false;
        # ----------------------------------------



        # Add some padding in the terminal
        [Logging]::DisplayMessage("`r`n`r`n");



        # Check to make sure that we are able to access the desired webpage.
        if ([WebsiteResources]::CheckSiteAvailability($siteURL) -eq $true)
        {
            # The website is accessible, try to open the webpage.

            # Let the user know that the desired page is about to be opened
            [Logging]::DisplayMessage("Accessing $($siteName). . .");
            [Logging]::DisplayMessage("URL: $($siteURL)");

            # Try to access the website
            if (![CommonIO]::AccessWebpage($siteURL))
            {
                # There was an issue that caused the site to be inaccessible.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = ("Unable to automatically open the desired web site due to an error!`r`n" + `
                                        "The user will need to open the webpage themselves, manually.");

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Site Requested: $($siteURL)`r`n" + `
                                            "`tSite Name: $($siteName)`r`n" + `
                                            "`tUpdate Flag: $($update)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Warning);    # Message level

                # * * * * * * * * * * * * * * * * * * *

                # We will show the user the URL that they will need to access
                #   manually through their web browser of their choice.
                $manualFallBack = $true;
            } # If: Unable to access site

            # Successfully opened the site automatically for the user
            else
            {
                # Because the operation was successful, update the Status Signal as appropriate.
                $operationStatus = $true;
            } # Else : Operation was successful
        } # If: Webpage was available

        # Web site validation failed
        else
        {
            # The desired webpage could not be validated, as such - the page cannot be opened.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to automatically open the desired web site due to a validation error!`r`n" + `
                                    "The user will need to open the webpage themselves, manually.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Site Requested: $($siteURL)`r`n" + `
                                        "`tSite Name: $($siteName)`r`n" + `
                                        "`tUpdate Flag: $($update)`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # We will show the user the URL that they will need to access
            #   manually through their web browser of their choice.
            $manualFallBack = $true;
        } # Else: Site Validation Failed



        # If we are unable to automatically access the desired webpage, then we will instead provide the URL
        #  path to the user.  Thus allowing the user to access the site manually using their preferred web
        #  browser.
        if ($manualFallBack)
        {
            # Alert the user that webpage cannot be opened due to an an error.
            [Logging]::DisplayMessage("Failed to access $($siteName) due to an error.`r`n" + `
                                    "As such, it is not possible for the $($GLOBAL:_PROGRAMNAME_) to automatically open the page for you at this given moment.`r`n", `
                                    [LogMessageLevel]::Warning);


            # Alert the user that something horrible just happened
            [NotificationAudible]::Notify([NotificationAudibleEventType]::Warning);


            # Now show the information that is needed for the user to access the URL themselves.
            [Logging]::DisplayMessage("To access the $($siteName) webpage, please copy and paste the following link to your preferred Web Browser:`r`n" + `
                                        "`t$($siteURL)`r`n`r`n");


            # Wether there was a failure or if everything worked as intended, we will mark this operation as successful.
            #  Reason why I am not going to throw an error, is because we provided a work-around - thus it is not a dead-end
            #  functionality.  Such that, if the user wants to view the site - something bad happened - and then nothing happens.
            #  Instead, we are providing a way for the user to access the site themselves - if the choose to do so, but the
            #  information that is provided on the terminal output buffer.
            $operationStatus = $true;


            # Wait for the user to see the information provided on the terminal screen output buffer.
            [Logging]::GetUserEnterKey();
        } # if: Show URL - Manual Approach



        # If the user is checking for updates, provide extra information as needed.
        if ($update)
        {
            # Provide the program information to the user, thus allowing the user to know what
            #  version of the program that they are running.
            [CommonCUI]::DrawUpdateProgramInformation();

            # Provide extra spacing for readability sakes.
            [Logging]::DisplayMessage("`r`n");

            # Wait for the user to see the information provided on the terminal screen output buffer.
            [Logging]::GetUserEnterKey();
        } # if: Update Protocol



        # Return the status of the operation
        return $operationStatus;
    } # __AccessWebSite()




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
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    static [bool] AccessWebSite_General([string] $siteURL, `                # The Site's URL to access
                                        [string] $siteName)                 # The Site's name
    {
        # Access the Main Function that will open the Web Browser functionality; return
        #  the operation status back to the calling function.
        return [WebsiteResources]::__AccessWebSite($siteURL, `              # Site URL
                                                    $siteName, `            # Site's Name (or Nice name)
                                                    $false);                # Update Protocol
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
    # -------------------------------
    # Output:
    #  [bool] Operation Status
    #    - True : Successfully performed the operation.
    #    - False: Unable to successfully open the web page.
    # -------------------------------
    #>
    static [bool] AccessWebSite_Update([string] $siteURL, `                 # The Site's URL to access
                                        [string] $siteName)                 # The Site's name
    {
        # Access the Main Function that will open the Web Browser functionality; return
        #  the operation status back to the calling function.
        return [WebsiteResources]::__AccessWebSite($siteURL, `              # Site URL
                                                    $siteName, `            # Site's Name (or Nice Name)
                                                    $true);                 # Update Protocol
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
        # Check the website's availability status.
        return ([WebsiteResources]::__CheckSiteAvailability_SiteProvided($site -eq $true) -and `    # Make sure that the string is not null\empty
                [WebsiteResources]::__CheckSiteAvailability_SiteResponse($site) -eq $true);         # Make sure that the Web Host and site is reachable
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
        # Check if the String of the site is null.
        #  If the string is null\empty, then false will be provided.
        #  Otherwise, true will be given.
        return ($null -ne $site);
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
        [bool] $siteReady = $false;
        # ----------------------------------------



        # Try to create an HTTP Request
        try
        {
            # Create and open the instance of the HTTP Request
            $siteRequest = [System.Net.HttpWebRequest]::Create($site);


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created a new HTTP Request instance!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "HTTP Request Created for: " + $site;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Try: Create HTTP Request


        # Reached an error during the HTTP Request; unable to proceed any further
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to create a new HTTP Request for the desired web page:" + `
                                            " $($site)`r`n" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Unable to create a new HTTP Request instance!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("HTTP Request Created for: $($site)`r`n" + `
                                        "`tAssure that you have a stable connection to the WAN.`r`n" + `
                                        "`tCould the website be done or invalid?`r`n" + `
                                        "`tCheck your Security Software to allow HTTP\HTTPS requests" + `
                                        " to the desired webpage.`r`n" + `
                                        "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Due to the fatal error, we cannot proceed forward with
            #  opening the desired web page.
            return $siteReady;
        } # Catch: Unable to create HTTP Request


        # - - - -


        # Try to retrieve Response from the HTTP site source
        try
        {
            # Now that the instance is supposedly open, now retrieve the site's response from the Request.
            $siteResponse = $siteRequest.GetResponse();


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully received an HTTP Response from the web server!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "HTTP Response Acquired By: " + $site;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Try: Try to retrieve response from HTTP site


        # Reached an error during the HTTP Response; unable to proceed any further
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Unable to retrieve HTTP Response from web server for" + `
                                            " page: $($site)!`n`r" + `
                                            "$([Logging]::GetExceptionInfoShort($_.Exception))");

            # Generate the initial message
            [string] $logMessage = "Unable to obtain an HTTP Response from the web server!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("HTTP Response Invoked for: $($site)`r`n" + `
                                        "`tAssure that you have a stable connection to the WAN`r`n" + `
                                        "`tCould the website be done or invalid?`r`n" + `
                                        "`tCheck your Security Software to allow HTTP\HTTPS requests" + `
                                        " to the desired webpage.`r`n" + `
                                        "$([Logging]::GetExceptionInfo($_.Exception))");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Due to the fatal error, we cannot proceed forward with
            #  opening the desired web page.
            return $siteReady;
        } # Catch: Unable to fetch HTTP Response


        # - - - -


        # Evaluate the site's response.  Is the website available for us to access?
        if ($siteResponse.StatusCode -eq "OK")
        {
            # The website is reachable; it is possible for us to access the website right now.
            $siteReady = $true;


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully received an OK signal from HTTP Response by the Web Server!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("HTTP Request Created for: $($site)`r`n" + `
                                        "`tHTTP Response Status Code: $($siteResponse.StatusCode)" + `
                                        " $([int]$siteResponse.StatusCode)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # If : Website is not reachable


        # Website is not available presently.
        else
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Prep a message to display to the user for this error; temporary variable
            [string] $displayErrorMessage = ("Website may not be presently available!`r`n" + `
                                            "Website Address: $($site)`r`n" + `
                                            "Response Status: $($siteResponse.StatusCode)");

            # Generate the initial message
            [string] $logMessage = "Website may not be available presently!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("HTTP Request Created for: $($site)`r`n" + `
                                        "`tHTTP Response Status Code: $($siteResponse.StatusCode) $([int]$siteResponse.StatusCode)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($displayErrorMessage, `       # Message to display
                                    [LogMessageLevel]::Warning);    # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Exclamation) | Out-Null;
            # * * * * * * * * * * * * * * * * * * *
        } # else: Site not Available


        # Try to close the HTTP Response connection
        try
        {
            # Now that we had finished evaluating the website, close the site's response from the
            #  Request instance.
            $siteResponse.Close();


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully closed connection to the web server!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Website: " + $site + "`r`n";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # try: Close HTTP Response Connection


        # Unable to close the HTTP Response Connection
        catch
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to close the connection to the web server!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Website: " + $site + "`r`n";

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Catch: Failure to close the HTTP Response Connection



        # Return the site's availability.
        return $siteReady;
    } # __CheckSiteAvailability_SiteResponse()

    # endregion
 } # WebsiteResources