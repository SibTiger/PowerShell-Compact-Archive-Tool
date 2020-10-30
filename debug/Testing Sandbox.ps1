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

    [GitControl] $gitObj = [GitControl]::new("git.exe", ` # Binary path
                                             $true, `     # Update Project
                                             0, `         # CommitID Length
                                             $true, `     # Fetch Commit ID
                                             $true, `     # Fetch changelog
                                             50, `        # Changelog limit
                                             $true)       # Generate a Report

    [SevenZip] $sevenZipObj = [SevenZip]::new("C:\Program Files\7-Zip\7z.exe", `    # Binary Path
                                               1, `                                 # Compression Method [Zip | 7Zip]
                                               1, `                                 # Algorithm for Zip
                                               2, `                                 # Algorithm for 7Zip
                                               $true, `                             # Multithreaded Operations
                                               3, `                                 # Compression Level
                                               $true, `                             # Verify Builds
                                               $true);                              # Generate a Report

    [DefaultCompress] $psArchive = [DefaultCompress]::new(0, `     # Compression Level
                                                          $true, ` # Verify Build
                                                          $true);  # Generate Report
    
    [LoadSaveUserConfiguration] $loadSaveConfigs = `
                [LoadSaveUserConfiguration]::new("$($Global:_PROGRAMDATA_CONFIGS_PATH_)");

                #>
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
    #Write-Host "Load Configuration Status: $($loadSaveConfigs.Load($userPref, $gitObj, $sevenZipObj, $psArchive))`r`n";
    
    #Write-Host "Saved Configuration Status: $($loadSaveConfigs.Save($userPref, $gitObj, $sevenZipObj, $psArchive))`r`n";
    #>


    # IOCommon - Rename
   <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #Write-Host "Renamed Directory Status: $([IOCommon]::RenameItem("F:\POSH Dev\powershit\files\play.txt", "MyPlayground.txt2"))";
    #Write-Host "Renamed DIrectory Status [Bad Path]: $([IOCommon]::RenameItem("F:\POSH Dev\powershit\files\play.txt", "MyPlayground.txt2"))";
    #Write-Host "Renamed DIrectory Status [No Name]: $([IOCommon]::RenameItem("F:\POSH Dev\powershit\files\play.txt", "$($null)"))";
    #>


    # IOCommon - Move Directory
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Write-Host "Moved Directory Status: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House"))";
    Write-Host "Moved Directory Status [Bad Target]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\house\test1", "C:\Users\Nicholas\Desktop"))";
    Write-Host "Moved Directory Status [Bad Destination]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House1"))";
    Write-Host "Moved Directory Status [Bad Permissions]: $([IOCommon]::MoveDirectory("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\House"))";
    #>


    # IOCommon - Move Files
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [string[]] $fileMoveList = @("*.txt", "New Microsoft Word Document (3).docx");
    Write-Host "Moved Files Status: $([IOCommon]::MoveFile("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House", $fileMoveList))";
    Write-Host "Moved Directory Status [Bad Target]: $([IOCommon]::MoveFile("C:\Users\Nicholas\Desktop\house\test1", "C:\Users\Nicholas\Desktop", $fileMoveList))";
    Write-Host "Moved Directory Status [Bad Destination]: $([IOCommon]::MoveFile("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\House1", $fileMoveList))";
    Write-Host "Moved Directory Status [Bad Permissions]: $([IOCommon]::MoveFile("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\House", $fileMoveList))";
    #>


    # IOCommon - Copy Directory
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Write-Host "Copied Directory Status: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house"))";
    Write-Host "Copied Directory Status [Bad Target]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test1", "C:\Users\Nicholas\Desktop\house"))";
    Write-Host "Copied Directory Status [Bad Destination]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house1"))";
    Write-Host "Copied Directory Status [Bad Permissions]: $([IOCommon]::CopyDirectory("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\house"))";
    #>


    # IOCommon - Copy Files
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [string[]] $fileCopyList = @("*.txt", "New Microsoft Word Document (3).docx");
    Write-Host "Copied Directory Status: $([IOCommon]::CopyFile("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house", $fileCopyList))";
    Write-Host "Copied Directory Status [Bad Target]: $([IOCommon]::CopyFile("C:\Users\Nicholas\Desktop\test1", "C:\Users\Nicholas\Desktop\house", $fileCopyList))";
    Write-Host "Copied Directory Status [Bad Destination]: $([IOCommon]::CopyFile("C:\Users\Nicholas\Desktop\test", "C:\Users\Nicholas\Desktop\house1", $fileCopyList))";
    Write-Host "Copied Directory Status [Bad Permissions]: $([IOCommon]::CopyFile("C:\Users\Nicholas\Desktop\testBadPermissions", "C:\Users\Nicholas\Desktop\house", $fileCopyList))";
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

    # Verify Archive File - CORRUPTED TEST
    Write-Host "Archive File Test [Corrupted] Status: $($psArchive.VerifyArchive("F:\POSH Dev\powershit\files\corrupted-deflate.zip"))";

    # Verify Archive File
    Write-Host "Archive File Test Status: $($psArchive.VerifyArchive("F:\POSH Dev\powershit\files\tgrdm3-deflate.zip"))";

    # List of Files
    [string] $fileList = "$($psArchive.ListFiles("F:\POSH Dev\powershit\files\tgrdm3-deflate.zip", $true))";
    [string] $fileList = "$($psArchive.ListFiles("F:\POSH Dev\powershit\files\corrupted-deflate.zip", $true))";
    Write-Host "Archive File List:`r`n$($fileList)";

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

    # Generate a Report
    Write-Host "Generate Report Status: $($psArchive.CreateNewReport("F:\POSH Dev\powershit\files\tgrdm3-deflate.zip", $true))";
    #>





    # 7ZIP TESTING
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Special Directories Exists?
    Write-Host "Logging Directories Status: $($sevenZipObj.__CheckRequiredDirectories())";

    # Should we Create the Special Directories?
    Write-Host "Created Special Directories Status: $($sevenZipObj.__CreateDirectories())";

    # Delete Files
    Write-Host "Deleting Files Status: $($sevenZipObj.ThrashLogs($true))";

    # Found 7Zip
    Write-Host "Found 7Zip in Directory: $($sevenZipObj.Find7Zip())";

    # Detected 7Zip
    Write-Host "Detected 7Zip Status: $($sevenZipObj.Detect7ZipExist())";

    # File Hash IO
    Write-Host "Test Hash from IO is: $([IOCommon]::FileHash("F:\POSH Dev\powershit\files\tgrdm3.zip", "sha1"))";

    # File Hash 7Z
    Write-Host "Test Hash from 7Z is: $($sevenZipObj.ArchiveHash("F:\POSH Dev\powershit\files\tgrdm3.zip", "sha1"))";

    # Verify Archive File
    Write-Host "Verify Build Status: $($sevenZipObj.VerifyArchive("F:\POSH Dev\powershit\files\tgrdm3.zip"))";

    # File List
    Write-Host "List of All Files: $($sevenZipObj.ListFiles("F:\POSH Dev\powershit\files\tgrdm3.zip", $true))";

    # Extract the File
    [string] $extractDir = $null;
    Write-Host "Extracting TGRDM3 Status: $($sevenZipObj.ExtractArchive("F:\POSH Dev\powershit\files\tgrdm3.zip", "F:\POSH Dev\powershit\files\extract", [ref] $extractDir))";
    Write-Host "  Directory of Contents was stored in: $($extractDir)";

    # Creating new Archive File
    [string] $addDir = $null;
    Write-Host "Creating new Archive Status: $($sevenZipObj.CreateArchive("NewArchiveFile", "F:\POSH Dev\powershit\files\extract", "C:\Users\Nicholas\AppData\Local\Programs\GZDoom", [ref] $addDir))";
    Write-Host "  Archive File Absolute Path: $($addDir)";

    # Create a Report
    Write-Host "Report Status: $($sevenZipObj.CreateNewReport("F:\POSH Dev\powershit\files\tgrdm3.zip", $true))";
    #>


    # System Information
    #[Logging]::WriteSystemInformation();


    # GIT TESTING
    <# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Special Directories Exists?
    Write-Host "Logging Directories Status: $($gitObj.__CheckRequiredDirectories())";

    # Should we Create the Special Directories?
    Write-Host "Created Special Directories Status: $($gitObj.__CreateDirectories())";

    # Is Git Detectable?
    Write-Host "Detected Git Status: $($gitObj.DetectGitExist())";

    # Found Git
    Write-Host "Found Git in Directory: $($gitObj.FindGit())";

    # Can we update the LWC?
    Write-Host "LWC Update Status: $($gitObj.UpdateLocalRepository("$($userPref.GetProjectPath())"))";

    # Fetch the Commit ID
    Write-Host "Commit ID Retrieved: $($gitObj.FetchCommitID("$($userPref.GetProjectPath())"))";

    # Get the Changelog
    Write-Host "Commit History Status: $($gitObj.FetchCommitHistory("$($userPref.GetProjectPath())", "$($gitObj.GetLogPath())"))";

    # Get the Current Branch
    Write-Host "Current Selected Branch: $($gitObj.FetchCurrentBranch("$($userPref.GetProjectPath())"))";

    # Get All available Branches
    Write-Host "Available Branches:`r`n$($gitObj.FetchAllBranches("$($userPref.GetProjectPath())"))";
    
    # Switch Branch
    Write-Host "Switching Branch Status: $($gitObj.SwitchLocalBranch("$($userPref.GetProjectPath())", "PowerShelling"))";

    # Get all Contributors
    Write-Host "Contributors Involved:`r`n$($gitObj.FetchAllContributors("$($userPref.GetProjectPath())"))";
    # Display neat graph
    Write-Host "Git Graph:`r`n$($gitObj.GenerateActivityLineGraph("$($userPref.GetProjectPath())"))";

    # Create a Report
    Write-Host "Report Status: $($gitObj.CreateNewReport("$($userPref.GetProjectPath())", $true))";
    # Get All Available Branches + Activities
    Write-Host "Available Branches (+ Activity):`r`n$($gitObj.FetchAllBranchesActivity("$($userPref.GetProjectPath())"))";
    #>



    Write-Host "$([SystemInformation]::PowerShellVersion())";
} # main()




# Flush the terminal's buffer.
[IOCommon]::ClearBuffer();



# User Preferences
$userPreferences = [UserPreferences]::GetInstance(0, `                                                         # Compression
                                    "$($env:HOMEDRIVE)$($env:HOMEPATH)\Projects\ZDoom WADs\Alphecca\Source", ` # Project Path
                                    "$($global:_USERDATA_BUILDS_PATH_)", `                                     # Output
                                    $true, `                                                                   # Use Git?
                                    $true, `                                                                   # Use Explorer.exe?
                                    $true, `                                                                   # Use Bell?
                                    0);
#Write-Host ("PARENT User Preference GUID is: $($userPreferences.GetObjectGUID())`r`n");
# Start the program
main;