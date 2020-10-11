<# System Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to provide information regarding the host system's configuration.
 #  The information collected will be based upon the system that is running the program, but
 #  
 #>




class SystemInformation
{
    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Private Functions
    # -------------------------------
    # Documentation:
    #  This function will 
    static Hidden [string] __OperatingSystem()
    {
        if ($IsWindows)
        {
            return "Windows";
        } # If : Host Running Windows

        elseif ($IsLinux)
        {
            return "Linux";
        } # If : Host Running Linux

        elseif ($IsMacOS)
        {
            return "Macintosh";
        } # If : Host Running Macintosh OS

        # 
        else
        {
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