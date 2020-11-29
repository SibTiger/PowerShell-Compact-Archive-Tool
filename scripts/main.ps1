<# Main Entry Point
 # ------------------------------
 # ==============================
 # ==============================
 # This source file will initialize the application's environment, assuring that the program can run within the host's
 #  PowerShell instance, provide a means for the user to interact within the software, and then - once the user had finished
 #  using the program - termination by safely closing the environment that had been created.
 #
 # Essentially, this is the spine of the entire program.  If the entry point fails, the entire application will fall apart.
 #>




# Program Entry Point
# --------------------------
# Documentation:
#   This function is our entry point for the program.  This function will be in charge of setting up the environment,
#   executing the Main Menu (User Interaction), and then self termination once the user leaves the Main Menu.
# --------------------------
function main()
{
    # Clear the host's terminal buffer
    [IOCommon]::ClearBuffer();


    # Setup the program's environment
    Initializations;


    # Initialize the User Preference object.
    [UserPreferences] $userPreferences = [UserPreferences]::New(0, `                                    # Compression Tool
                                                            ".\", `                                     # Project Path
                                                            "$($global:_USERDATA_BUILDS_PATH_)", `      # Output Builds Path
                                                            $true, `                                    # Use Git Features
                                                            $true, `                                    # Use Windows Explorer Features
                                                            $true, `                                    # Use Bell Notification?
                                                            0);                                         # Notification Type


    # Initialize the Git Control object.
    [GitControl] $gitControl = [GitControl]::New("git.exe", `               # Executable path to Git
                                                $true, `                    # Update Project Files
                                                [GitCommitLength]::short, ` # Commit ID Length
                                                $true, `                    # Fetch Commit ID
                                                $true, `                    # Fetch History Commit Changelog
                                                50, `                       # History Commit Changelog Range
                                                $false);                    # Create a report


    # Initialize the 7Zip object
    [SevenZip] $sevenZip = [SevenZip]::New("7z.exe",                                # Executable path to 7Zip
                                            [SevenZipCompressionMethod]::Zip, `     # Compression Method 
                                            [SevenZipAlgorithmZip]::Deflate, `      # Zip Algorithm
                                            [SevenZipAlgorithm7Zip]::LZMA2, `       # 7Zip Algorithm
                                            $true, `                                # Multithreaded Operations
                                            [SevenCompressionLevel]::Normal, `      # Compression Level
                                            $true, `                                # Verify Build
                                            $false);                                # Create a report


    # Initialize the dotNet Core Zip Archive object
    [DefaultCompress] $defaultCompress = [DefaultCompress]::New([DefaultCompressionLevel]::Fastest, `   # Compression Level
                                                            $true, `                                    # Verify Build
                                                            $false);                                    # Create a report


    # Initialize the Loading and Saving of User Configurations
    [LoadSaveUserConfiguration] $loadSaveUserConfiguration = `
                                [LoadSaveUserConfiguration]::New("$($Global:_PROGRAMDATA_CONFIGS_PATH_)");
} # main()




# If incase the legacy PowerShell terminal is capable of reaching this point, immediately stop - before things go horribly wrong.
if ([SystemInformation]::PowerShellEdition() -eq "Legacy")
{
    # Output a message to the PowerShell terminal about the fatal error
    Write-Output ("<!>   COMPATIBILITY ISSUE DETERMINED   <!>`r`n" + `
                  "==========================================`r`n" + `
                  "`r`n" + `
                  "Unable to run the desired application, $($MyInvocation.MyCommand.Name), due to" + `
                  " compatibility issues with this PowerShell Version.  Please consider using the" + `
                  " latest PowerShell Core available on GitHub.`r`n" + `
                  "`r`n" + `
                  "PowerShell Core GitHub Downloads:`r`n" + `
                  "`thttps://github.com/PowerShell/PowerShell/releases`r`n" + `
                  "PowerShell Official Documentation:`r`n" + `
                  "`thttps://docs.microsoft.com/en-us/powershell/`r`n" + `
                  "`r`n" + `
                  "`r`n" + `
                  "Press any key to terminate this session. . .");


    # Wait for the user to provide any key
    $null = [Console]::ReadKey($true) | Out-Null;


    # Provide some extra padding so it is easier for the user to see the PowerShell's prompt
    Write-Output "`r`n`r`n";


    # Terminate the script
    return;
} # if : Compatibility Issues




# Execute the application
main;