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

    # Detect Operating System
    # -------------------------------
    # Documentation:
    #  This function will try to detect the host's current Operating System in which the
    #   application is currently running.  With this, it can be possible for the application
    #   to change its behavior one way for an environment - while different in another.  Thus,
    #   this function provides a gateway for cross-platform support.
    #
    # NOTE:
    #   This function relies on PowerShell Core's environment in order to perform this operation.
    #   Thus, using a legacy PowerShell version will not be sufficient for this function's
    #   requirements.
    # -------------------------------
    # Output:
    #  [string] Operating System
    #   The detected Operating System that the application is presently running within.
    # -------------------------------
    static Hidden [string] __OperatingSystem()
    {
        # Check if the host is running a Windows environment.
        if ($Global:IsWindows)
        {
            # Detected Windows
            return "Windows";
        } # If : Host Running Windows


        # Check if the host is running a GNU\Linux environment.
        elseif ($Global:IsLinux)
        {
            # Detected Linux
            return "Linux";
        } # If : Host Running Linux


        # Check if the host is running a Macintosh environment.
        elseif ($Global:IsMacOS)
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





    # Detect PowerShell Edition
    # -------------------------------
    # Documentation:
    #  This function will try to detect the PowerShell Edition that is running the application.
    #   With this, it can be possible for the application to change its behavior one way for an
    #   environment - while different in another.  Thus, it is possible for the application to
    #   support multiple environments if possible.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [string] PowerShell Edition
    #   The detected PowerShell Edition that this application is presently running within.
    # -------------------------------
    static Hidden [string] __PowerShellEdition()
    {
        # Check if the host PowerShell Edition is POSH .Net Core
        if ($Global:PSEdition == "Core")
        {
            # Detected PowerShell Core
            return "Core";
        } # if : PowerShell Core


        # Check if the host PowerShell Edition is Legacy
        elseif ($Global:PSEdition == "Desktop")
        {
            # Detected PowerShell (5.1 and earlier)
            return "Legacy";
        } # if : PowerShell Legacy


        # Unable to detect the PowerShell edition.
        else
        {
            # Unable to detect PowerShell edition.
            #  Return an unknown instead.
            return "UNKNOWN";
        } # else : Unknown POSH Edition
    } # __PowerShellEdition()





    # Return Application's (PowerShell's) Process ID
    # -------------------------------
    # Documentation:
    #  This function will provide the application's (or essentially the PowerShell's) Process ID
    #   within the Operating System's environment.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [int] PowerShell's Process ID
    #   The Process ID of the PowerShell's instance (with the application active)
    # -------------------------------
    static Hidden [int] __ProcessID()
    {
        return $Global:PID;
    } # __ProcessID()





    # Return User's Working Directory Path
    # -------------------------------
    # Documentation:
    #  This function will return the User's Working Directory path in which the PowerShell's
    #   instance is presently using.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [string] User's Working Directory Full Path
    #   The full path of the User's Working Directory
    # -------------------------------
    static Hidden [string] __WorkingDirectoryPath()
    {
        return $Global:PWD.Path;
    } # __WorkingDirectoryPath()





    # Return PowerShell's Output Encoding Setting
    # -------------------------------
    # Documentation:
    #  This function will return PowerShell's current Encoding configuration for files generated
    #   by PowerShell.  This function can provide insight as to how the text files, generated by
    #   PowerShell, where encoded.  If by chance text files cannot be read with certain text editors,
    #   this function can provide an answer as to why.
    #
    # NOTE:
    #   This function relies on PowerShell's environment to perform the main operation.  Luckily,
    #    this works with the older versions of PowerShell.
    # -------------------------------
    # Output:
    #  [string] PowerShell's Encoding
    #   PowerShell's Encoding setting
    # -------------------------------
    static Hidden [string] __OutputEncoding()
    {
        return $Global:OutputEncoding.BodyName;
    } # __OutputEncoding()
    #endregion
} # SystemInformation
