<# System Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to provide information regarding the host system's configuration.
 #  The information collected within this class can be used for debugging purposes.  As all
 #  systems varies in hardware configurations, it can be useful to retrieve just the basic
 #  information regarding the host's hardware and simple Operating System's environment.
 #  The data collected within this source - cannot be used in an intrusive way that will
 #  infringe upon the user's privacy.
 #>




class SystemInformation
{
    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Private Functions
    # -------------------------------
    # Documentation:
    #  This function will try to detect the host's current Operating System in which the
    #   application is currently running.  With this, it can be possible for the application
    #   to change its behavior one way for an environment - while different in another.  Thus,
    #   this function provides a gateway for cross-platform support.
    # -------------------------------
    # Output:
    #  [string] Operating System
    #   The detected Operating System that the application is presently running within.
    # -------------------------------
    static Hidden [string] __OperatingSystem()
    {
        # Check if the host is running a Windows environment.
        if ($IsWindows)
        {
            # Detected Windows
            return "Windows";
        } # If : Host Running Windows


        # Check if the host is running a GNU\Linux environment.
        elseif ($IsLinux)
        {
            # Detected Linux
            return "Linux";
        } # If : Host Running Linux


        # Check if the host is running a Macintosh environment.
        elseif ($IsMacOS)
        {
            # Detected Macintosh
            return "Macintosh";
        } # If : Host Running Macintosh OS


        # Unable to determine the host's environment
        else
        {
            # Return an unknown instead.
            return "UNKNOWN"
        } # Else : Unknown Environment
    } # __OperatingSystem()




    # PowerShell Edition
    static Hidden [string] __PowerShellEdition()
    {
        if ($PSEdition == "Core")
        {
            return "Core";
        }

        elseif ($PSEdition == "Desktop")
        {
            return "Legacy";
        }

        else
        {
            return "UNKNOWN";
        }
    }

    # Process ID
    static Hidden [int] __ProcessID()
    {
        return $PID;
    }

    # Working Directory Path
    static Hidden [string] __WorkingDirectoryPath()
    {
        return $PWD.Path;
    }


    static Hidden [string] __OutputEncoding()
    {
        return $OutputEncoding.BodyName;
    }
    #endregion
} # SystemInformation
