<# System Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class is designed to provide information regarding the host system's configuration.
 #  The information collected within this class can be used for debugging purposes.  As all
 #  systems vary in hardware configurations, it can be useful to retrieve just the basic
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
    #  [SystemInformationOperatingSystem] Operating System
    #   The detected Operating System that the application is presently running within.
    # -------------------------------
    static [SystemInformationOperatingSystem] OperatingSystem()
    {
        # Check if the host is running a Windows environment.
        if ($Global:IsWindows)
        {
            # Detected Windows
            return [SystemInformationOperatingSystem]::Windows;
        } # If : Host Running Windows


        # Check if the host is running a GNU\Linux environment.
        elseif ($Global:IsLinux)
        {
            # Detected Linux
            return [SystemInformationOperatingSystem]::Linux;
        } # If : Host Running Linux


        # Check if the host is running a Macintosh environment.
        elseif ($Global:IsMacOS)
        {
            # Detected Macintosh
            return [SystemInformationOperatingSystem]::Macintosh;
        } # If : Host Running Macintosh OS


        # Unable to determine the host's environment
        else
        {
            # Return an unknown instead.
            return [SystemInformationOperatingSystem]::UNKNOWN;
        } # Else : Unknown Environment
    } # OperatingSystem()





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
    #    this works with the older versions of PowerShell.  however, backwards compatibility may
    #    not be possible with ancient versions of PowerShell due to the OOP nature.  It should be
    #    noted that OOP scripting was not really introduced until 5.0, any version prior will not
    #    work correctly.  Further, if there are functions that use newer definitions or dotNET APIs,
    #    that too will not work correctly.  As such, it is assumed that all works well and that the
    #    host uses at least PowerShell 5.0 or greater -- but it is unlikely due to newer technologies
    #    and techniques.
    # -------------------------------
    # Output:
    #  [SystemInformationPowerShellEdition] PowerShell Edition
    #   The detected PowerShell Edition that this application is presently running within.
    # -------------------------------
    static [SystemInformationPowerShellEdition] PowerShellEdition()
    {
        # Check if the host PowerShell Edition is POSH .Net Core
        if ($Global:PSEdition -eq "Core")
        {
            # Detected PowerShell Core
            return [SystemInformationPowerShellEdition]::Core;
        } # if : PowerShell Core


        # Windows Desktop has selected.  Though, keep in mind that POSH 4.0 and earlier will not
        #  provide any output.  Thus, it will be treated as a legacy.
        else
        {
            # Detected PowerShell (5.1 and earlier)
            return [SystemInformationPowerShellEdition]::Legacy;
        } # else : PowerShell Legacy
    } # PowerShellEdition()





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
    static [int] ProcessID()
    {
        return $Global:PID;
    } # ProcessID()





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
    static [string] WorkingDirectoryPath()
    {
        return $Global:PWD.Path;
    } # WorkingDirectoryPath()





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
    static [string] OutputEncoding()
    {
        return $Global:OutputEncoding.BodyName;
    } # OutputEncoding()





    # Detect PowerShell Version
    # -------------------------------
    # Documentation:
    #  This function will provide the host's PowerShell Version that is presently being used while
    #   running the application.  The Version of the host's POSH can be used to determine how to
    #   operate a specific task for that version, while others may use a different approach.
    # -------------------------------
    # Output:
    #  [string] PowerShell Version
    #   The detected PowerShell Version that this application is presently running within.
    # -------------------------------
    static [string] PowerShellVersion()
    {
        return "$((Get-Host).Version)";
    } # PowerShellVersion()

    #endregion
} # SystemInformation




<# Operating System [ENUM]
 # -------------------------------
 # Provides a list of supported Operating Systems using PowerShell Core.
 #
 # List of supported Operating Systems using PowerShell Core:
 #  - https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle#supported-platforms
 # -------------------------------
 #>
 enum SystemInformationOperatingSystem
 {
    Windows = 0;    # Windows OS
    Linux = 1;      # Linux
    Macintosh = 2;  # Macintosh
    UNKNOWN = 99;   # Unregistered
 } # SystemInformationOperatingSystem




<# PowerShell Edition [ENUM]
 # -------------------------------
 # Provides a list of PowerShell Editions that are available.
 #
 # List of PowerShell Editions:
 #  - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_editions
 # -------------------------------
 #>
 enum SystemInformationPowerShellEdition
 {
    Core = 0;       # PowerShell Core
    Legacy = 1;     # Windows PowerShell
 } # SystemInformationPowerShellEdition