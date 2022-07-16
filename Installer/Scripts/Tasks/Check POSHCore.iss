;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                 _____   _                     _        _____     ____     _____   _    _    _____
;                / ____| | |                   | |      |  __ \   / __ \   / ____| | |  | |  / ____|
;               | |      | |__     ___    ___  | | __   | |__) | | |  | | | (___   | |__| | | |        ___    _ __    ___
;               | |      | '_ \   / _ \  / __| | |/ /   |  ___/  | |  | |  \___ \  |  __  | | |       / _ \  | '__|  / _ \
;               | |____  | | | | |  __/ | (__  |   <    | |      | |__| |  ____) | | |  | | | |____  | (_) | | |    |  __/
;                \_____| |_| |_|  \___|  \___| |_|\_\   |_|       \____/  |_____/  |_|  |_|  \_____|  \___/  |_|     \___|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Descrition
; ------------------------
; This script is designed to assure that the PowerShell Core application is available within the host system.
;   Without POSHCore, it is not possible to run this software.  This is a mandatory prerequesit.
[Wizard]
SetupLogging = yes




;function PrepareToInstall(var NeedsRestart: Boolean) : String;
[Code]
// Global Constant Variables
// ------------------------------------------------------------
const
    // This defines the SubKey path that we want to examine within the Windows Registry.
    _DEFAULT_SUBKEY_PATH_   = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';

    // This defines the Hivekey that we want to access that contains the desired SubKey.
    _DEFAULT_ROOTKEY_32_    = HKLM32;   // HKEY_LOCAL_MACHINE - 32Bit
    _DEFAULT_ROOTKEY_64_    = HKLM64;   // HKEY_LOCAL_MACHINE - 64Bit

    // This defines the desired keyword that we are wanting to inspect within the DisplayName.
    _DEFAULT_KEYWORD_EXEC_  = 'PowerShell';

    // This will define the Value within the SubKey that we must examine
    _DEFAULT_SUBKEY_VALUE_  = 'DisplayName';

    // This defines the Major Version required, at minimum, for PowerShell.
    _DEFAULT_MAJOR_VERSION_ = 7;

    // This defines the Minor Version required - but incorporated with the Major Version.
    _DEFAULT_MINOR_VERSION_ = 2;




// Function Prototypes
// ------------------------------------------------------------
function    DetectPowerShellCore    ()                                                                  : Boolean           ; forward;
function    RetrieveSubKeyList      (const HiveKey : Integer)                                           : TArrayOfString    ; forward;
function    ScanRetrievedSubKeys    (const hiveKey : Integer; const subKeyItemList : TArrayOfString)    : Cardinal          ; forward;
function    FindValueTarget         (const HiveKey : Integer; const ValueToInspect : String)            : Cardinal          ; forward;
procedure   AlertUserResults        (const searchResults : Cardinal)                                                        ; forward;





// ------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------



// Inno Setup will automatically call this function when appropriate.
function InitializeSetup() : Boolean;
begin
    // Try to find the current installation instance of PowerShell Core.
    Result := DetectPowerShellCore();


    // Finished!
    Exit;
end; // InitializeSetup()





// Detect PowerShell Core - Main
// --------------------------------------
// This function is the main driver algorithm.  Thus, meaning, that this function will cordinate how the
//  search will will operate.  We have to keep in mind that the desired application could be installed in
//  a 32Bit or 64Bit variant within a 64Bit Operating System environment, while a 32Bit Operating System
//  environment is strictly a 32Bit system.  As such, we have to scan merely dependent on the CPU
//  Architecture's word-size.
//
// NOTE: Due to the nature of 32Bit and 64Bit being intermixed within the Windows' Registry, we will have to
//          organize the search a bit differently for those using a 64Bit operating system.
// Source: https://stackoverflow.com/questions/4033976/inno-setup-doesnt-allow-access-to-all-registry-keys-why
// --------------------------------------
// Return:
//  true  = Found PowerShell Core installation
//  false = Unable to find a PowerShell Core installation
// --------------------------------------
function DetectPowerShellCore() : Boolean;
// Variables
var
    scanResults : Cardinal;         // This will hold the Results from the Scan.


// Code
begin
    // Perform the algorithm using the appropriate procedure depending on the host's CPU architecture.

    // Windows 64Bit
    if (IsWin64) then
    begin
        // Check if the application was a 64Bit.
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_64_, \
                                            RetrieveSubKeyList(_DEFAULT_ROOTKEY_64_));


        // Check if the application was a 32Bit, if and only if the 64Bit scan could not find the program.
        if (scanResults = 0) then
            scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_32_, \
                                                RetrieveSubKeyList(_DEFAULT_ROOTKEY_32_));
    end


    // Windows 32Bit
    else;
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_32_, \
                                            RetrieveSubKeyList(_DEFAULT_ROOTKEY_32_));


    // With the scan finished, provide the results to the user's attention.
    AlertUserResults(scanResults);


    // Allow the Installer to continue forward anyways.
    Result := True;


    // Finished!
    Exit;
end; // DetectPowerShellCore()





// Retrieve Subkeys
// --------------------------------------
// This function will merely return the Subkeys within the desired address from the Windows Registry.  The
//  Subkeys that were provided by the Windows Registry will be returned to the caller function.
// --------------------------------------
// Return:
//  SubKey Array size of $N.
// --------------------------------------
function RetrieveSubKeyList(const HiveKey : Integer) : TArrayOfString;
begin
    RegGetSubkeyNames(HiveKey, _DEFAULT_SUBKEY_PATH_, Result);
end; // RetrieveSubKeyList()





// Scan Retrieved Subkeys from Windows Registry
// --------------------------------------
// This function is designed to scan through the entire Subkey list, provided by the dynamic size array.  To
//  perform this search, this function will stitch together the full path of the SubKey to a helper-function
//  inwhich it will utlimately inspect if a specific value, that we are searching for, exists or not exists
//  within the system's registry.
// --------------------------------------
// Return:
//  SubKey Array size of $N.
// --------------------------------------
function ScanRetrievedSubKeys(const hiveKey : Integer; const subKeyItemList : TArrayOfString) : Cardinal;
var
    loopIterator    : Integer;          // Used for our For-Loop to scan the SubKeys.
    itemSelected    : String;           // The current SubKey or Value that will be examined.
begin
    // If there's nothing within the list, then there's nothing for us to do.
    if (GetArrayLength(subKeyItemList) <= 0) then
    begin
        // There's nothing for us to do.
        Result := 0;
        Exit;
    end;

    // Scan each SubKey
    for loopIterator := 0 to GetArrayLength(subKeyItemList) - 1 do
    begin
        // Cache the result such that we can easily pass it.
        itemSelected := _DEFAULT_SUBKEY_PATH_ + '\' + subKeyItemList[loopIterator];

        Log(Format('Inspecting SubKey: %s',[itemSelected]));
        // Call this function again, such that we may examine the values.
        Result := FindValueTarget(hiveKey, itemSelected);

        if (Result) > 0 then
            Exit;
    end;
end; // ScanRetrievedSubKeys()





// Find Value Target
// --------------------------------------
// This function will try to specifically look for the desired target with the given Windows Registry Value.
//  How this function operates, we already know that we want to examine the 'DisplayName', so we will inspect
//  the SubKey's DisplayName Value.
// --------------------------------------
// Return:
//  0 = Target was not found.
//  1 = Target was found, no issues.
//  2 = Target was found, older version.
// --------------------------------------
function FindValueTarget(const HiveKey : Integer; const ValueToInspect : String) : Cardinal;
var
    itemSelected    : String;           // The Value that will be examined.
    positionCounter : Integer;          // This will determine the position of when the delimiter occurs.
    versionMajor    : Cardinal;         // This will hold the value returned by the Windows Registry, POSH Major Version.
    versionMinor    : Cardinal;         // This will hold the value returned by the Windows Registry, POSH Minor Version.
    exitCodeExec    : Integer;          // This holds the exit code provided by the Windows Shell Environment.
begin
    Log(Format('Inspecting Value: %s', [ValueToInspect]));

    // Check to see if 'DisplayName' exists within the SubKey.
    if ((RegValueExists(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_)) and \
        (RegQueryStringValue(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_, itemSelected))) then
    begin
        // Because the Value of the 'DisplayName' in the PowerShell Core SubKey contains its version and the product's
        //  name, we will have to parse it such that we can properly examine the string.
        //  We are only interested in the 'PowerShell' keyword, all others are ignored.
        positionCounter := Pos(' ', itemSelected);
        itemSelected    := Copy(itemSelected, 1, positionCounter - 1);

        // Compare the string
        if (CompareText(itemSelected, _DEFAULT_KEYWORD_EXEC_) = 0) then
        begin
            // Make sure that it's version meets the requirements
            if ((RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMajor', versionMajor))     and \
                    (versionMajor >= _DEFAULT_MAJOR_VERSION_)                                   and \
                    (RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMinor', versionMinor)) and \
                (versionMinor >= _DEFAULT_MINOR_VERSION_)) then
            begin
                Result := 1;
                Exit;
            end

            // The instance does not meet the desired requirements
            else
            begin
                Result := 2;
                Exit;
            end;
        end;
    end;
    Result := 0;
end; // FindValueTarget()





// Retrieve Subkeys
// --------------------------------------
// This function will provide the results to the end-user.  Dependent solely on the provided results, this
//  function could alert the user that the required dependency is not installed or if it was able to find the
//  necessary dependency.  Further, this function could also alert the user if the required dependency is
//  outdated.
//
// NOTE:
//  Actions that are to take place depending on the value of $searchResults.
//      0 = Unable to find the dependency
//          a. Alert the User of an issue.
//          b. Take the user to the dependency download page.
//          c. Finished.
//      1 = Found the dependency and meets the version requirements.
//          a. Finished.
//      2 = Found the dependency but does not meet the version requirements.
//          a. Alert the User of an issue.
//          b. Take the user to the dependency download page.
//          c. Finished.
// --------------------------------------
procedure AlertUserResults(const searchResults : Cardinal);
var
    exitCodeExec    : Integer;          // This holds the exit code provided by the Windows Shell Environment.
begin
    case searchResults of
        0:
        begin
            MsgBox('Unable to find it!', mbCriticalError, MB_OK);
        end;

        1:
        begin
            MsgBox('Found it!', mbInformation, MB_OK);
            Exit;
        end;

        2:
        begin
            MsgBox('Older version found!', mbCriticalError, MB_OK);
        end;

        else
        begin
            MsgBox('Unknown Search Results', mbCriticalError, MB_OK);
            Exit;
        end;
    end;


    // Take the user to the download page.
    shellexec('open', \
                'https://github.com/PowerShell/PowerShell/releases/latest', \
                '', \
                '', \
                SW_SHOW, \
                ewNoWait, \
                exitCodeExec);
end; // AlertUserResults()