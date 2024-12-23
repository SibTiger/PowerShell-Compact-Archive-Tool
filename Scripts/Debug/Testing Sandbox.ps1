# Program Entry Point
# --------------------------
# Documentation:
#     This is the main spine of the program.
# --------------------------
function main()
{
    # Prepare the initialize setup
    Initializations;

    # Initialize the objects
    [UserPreferences] $userPref = [UserPreferences]::GetInstance();

    [ArchiveZip] $psArchive = [ArchiveZip]::new(0);
    
    [LoadSaveUserConfiguration] $loadSaveConfigs = `
                [LoadSaveUserConfiguration]::new("$($Global:_PROGRAMDATA_CONFIGS_PATH_)");


    # Check Special Directories
    Write-Host "Special Directory Results: $(CheckSpecialDirectories)";
    Write-Host "Checking Directory Results: $(CheckProgramDirectories)";
    Write-Host "Called Create Directories: $(CreateDirectories)";


    # Logging: WriteToBuffer Message Levels
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Standard    [0]
    [Logging]::DisplayMessage("STANDARD MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Standard");

    # Attention   [1]
    [Logging]::DisplayMessage("ATTENTION MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Attention");

    # Information [2]
    [Logging]::DisplayMessage("INFORMATION MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Information");

    # Warning     [3]
    [Logging]::DisplayMessage("WARNING MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Warning");

    # Error       [4]
    [Logging]::DisplayMessage("ERROR MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Error");

    # Fatal       [5]
    [Logging]::DisplayMessage("FATAL MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Fatal");

    # Verbose     [6]
    [Logging]::DisplayMessage("VERBOSE MESSAGE`r`nThis is the message that would appear for text that is in this block.", "Verbose");
    
    # Default     [UNKNOWN]
    [Logging]::DisplayMessage("DEFAULT MESSAGE`r`nThis is the message that would appear for text that is in this block.", "UNKNOWN");
    
    # User Input - THIS SHOULD FAIL!
    [Logging]::DisplayMessage("USER INPUT MESSAGE`r`nThis is a message that would not appear as it is user input - seriously this should fail!", "UserInput");
    # Get Input
    [Logging]::DisplayMessage("Provide some test input:", "Standard");
    [Logging]::GetUserInput();
    [Logging]::DisplayMessage("Overflowing this message to test the standard message response");
    #>


    # Program Logging
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Thrash Logs
    #Write-Host "Thrashing logs from Buffer and Program Status: $($log.__ThrashLogs())";
    # Capture Buffer
    Write-Host "Capturing Buffer Status: $([Logging]::CaptureBuffer())";
    Write-Host "Writing to file (Message 1): $([Logging]::WriteLogFile("Boomer"))";
    Write-Host "Writing to file (Message 2): $([Logging]::WriteLogFile("Alex Jones"))";
    Write-Host "Stopping Transcription: $([Logging]::CaptureBufferStop())";
    Write-Host "Writing to file (Message 3): $([Logging]::WriteLogFile("Jackthomson in the airflane smequel of Jack Krost!"))";
    #>


    # Save\Load Functionality
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #Write-Host "Load Configuration Status: $($loadSaveConfigs.Load($userPref, $psArchive))`r`n";
    
    #Write-Host "Saved Configuration Status: $($loadSaveConfigs.Save($userPref, $psArchive))`r`n";
    #>


    # IOCommon - Move Directory
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Write-Host "Moved Directory Status: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House"))";
    Write-Host "Moved Directory Status [Bad Target]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\house\test1", "C:\Users\Nicholas\Desktop"))";
    Write-Host "Moved Directory Status [Bad Destination]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House1"))";
    Write-Host "Moved Directory Status [Bad Permissions]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\House"))";
    #>


    # IOCommon - Copy Directory
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Write-Host "Copied Directory Status: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house"))";
    Write-Host "Copied Directory Status [Bad Target]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test1", "C:\Users\Nicholas\Desktop\house"))";
    Write-Host "Copied Directory Status [Bad Destination]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house1"))";
    Write-Host "Copied Directory Status [Bad Permissions]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\house"))";
    #>



    # IOCommon - Search Item (Search Depth)
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [System.IO.FileSystemInfo[]] $results = $([IOCommon]::SearchFile("E:\", "*Links*.*"));
    Write-Host "Found the following hits: $($results.Count)";
    Foreach ($item in $results)
    {
        write-host "`t>> $($item.FullName)";
    }
    #>



    # IOCommon - Websites
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    $webList = @("http://tiger.rfc1337.net", `
                 "http://127.0.0.1", `
                 "youtube.com", `
                 "www.facebook.com");
    foreach ($item in $webList)
    {
        Write-Host "Trying Website: $($item)" 
                   "   Webpage Access Status: $([IOCommon]::AccessWebpage("$($item)"))";
    } # Website List
    #>



    # PowerShell Archive
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Delete all logs and reports
    Write-Host "Deleting logs and reports status: $($psArchive.ThrashLogs($true))";

    # Detect PowerShell Archive
    Write-Host "Archive Module Detection status: $($psArchive.DetectCompressModule())";

    # %TEMP% Directory
    [string] $TempDir = $null;
    Write-Host "Created %TEMP% Directory Status: $([IOCommon]::MakeTempDirectory("Test", [ref] $TempDir))";
    Write-Host "  Directory Path is: $($TempDir)";

    # Extract files
    [string] $extractOutput = $null;
    Write-Host "Extract Status: $($psArchive.ExtractArchive("F:\POSH Dev\powershit\files\tgrdm3-deflate.zip", "F:\POSH Dev\powershit\files\extract", [ref] $extractOutput))";
    Write-Host "  Directory Path is: $($extractOutput)";

    Write-Host "Extract Status [1]: $($psArchive.ExtractArchive("F:\POSH Dev\powershit\files\corrupted-deflate.zip", "F:\POSH Dev\powershit\files\extract", [ref] $extractOutput))";
    Write-Host "  Directory Path is [1]: $($extractOutput)";

    # Create Archivefile
    [string] $archiveOutput = $null;
    Write-Host "Create Archive File Status: $($psArchive.CreateArchive("NewTestBuild", "F:\POSH Dev\powershit\files\extract", "C:\Users\Nicholas\AppData\Local\Programs\GZDoom*", [ref] $archiveOutput))";
    Write-Host "  Archive Path is: $($archiveOutput)";
    #>


    # System Information
    #[Logging]::WriteSystemInformation();



    Write-Host "$([SystemInformation]::PowerShellVersion())";
} # main()




# Flush the terminal's buffer.
[IOCommon]::ClearBuffer();



# User Preferences
$userPreferences = [UserPreferences]::GetInstance(0, `                                                         # Compression
                                    "$($env:HOMEDRIVE)$($env:HOMEPATH)\Projects\ZDoom WADs\Alphecca\Source", ` # Project Path
                                    "$($global:_USERDATA_BUILDS_PATH_)", `                                     # Output
                                    $true, `                                                                   # Use Explorer.exe?
                                    $true, `                                                                   # Use Bell?
                                    0);
#Write-Host ("PARENT User Preference GUID is: $($userPreferences.GetObjectGUID())`r`n");
# Start the program
main;