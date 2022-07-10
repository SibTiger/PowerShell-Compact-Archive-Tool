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
function DetectPowerShellCore() : Boolean; forward;
function RetrieveSubKeyList(const HiveKey : Integer) : TArrayOfString; forward;
function ScanRetrievedSubKeys(const hiveKey : Integer; const subKeyItemList : TArrayOfString) : Cardinal; forward;
function FindValueTarget(const HiveKey : Integer; const ValueToInspect : String) : Cardinal; forward;
procedure AlertUserResults(const searchResults : Cardinal); forward;





// ------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------



// Inno Setup will automatically call this function when appropriate.
function InitializeSetup() : Boolean;
begin
    // Try to find the current install of PowerShell Core.
    Result := DetectPowerShellCore();
    Exit;
end;




// Detect PowerShell Core - Main
// --------------------------------------
// This algorithm will try its best to find the current installation of the PowerShell Core.  To perform this
//  operation, we will break this algorithm out into several parts - making this function the main spine.
//
//
// --------------------------------------
function DetectPowerShellCore() : Boolean;
// Variables
var
    // We will use this to determine which area within the Windows Registry we will be focusing.
    //  The main Hivekey will always be 'HKEY_LOCAL_MACHINE', but due to the difference of 32-Bit
    //  and 64-Bit Uninstaller programs - we will have to explictly state with part of the registry
    //  that we want to examine.
    // Source: https://stackoverflow.com/questions/4033976/inno-setup-doesnt-allow-access-to-all-registry-keys-why
    defaultRootKey  : Integer;
    // - - - -
    scanResults     : Cardinal;         // This will hold the Results from the Scan.
begin
    if (IsWin64) then
    begin
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_64_, RetrieveSubKeyList(_DEFAULT_ROOTKEY_64_));

        if (scanResults = 0) then
            scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_32_, RetrieveSubKeyList(_DEFAULT_ROOTKEY_32_));
    end
    else;
    begin
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_32_, RetrieveSubKeyList(_DEFAULT_ROOTKEY_32_));
    end;



    AlertUserResults(scanResults);
    Result := True;
    Exit;
end; // DetectPowerShellCore()




function RetrieveSubKeyList(const HiveKey : Integer) : TArrayOfString;
begin
    RegGetSubkeyNames(HiveKey, _DEFAULT_SUBKEY_PATH_, Result);
    Exit;
end; // RetrieveSubKeyList()




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
    if ((RegValueExists(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_)) and (RegQueryStringValue(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_, itemSelected))) then
    begin
        // Because the Value of the 'DisplayName' in the PowerShell Core SubKey contains its version and the product's name, we will have to parse it such that we can properly examine the string.
        //  We are only interested in the 'PowerShell' keyword, all others are ignored.
        positionCounter := Pos(' ', itemSelected);
        itemSelected    := Copy(itemSelected, 1, positionCounter - 1);

        // Compare the string
        if (CompareText(itemSelected, _DEFAULT_KEYWORD_EXEC_) = 0) then
        begin
            // Make sure that it's version meets the requirements
            if ((RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMajor', versionMajor)) and (versionMajor >= _DEFAULT_MAJOR_VERSION_) and (RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMinor', versionMinor)) and (versionMinor >= _DEFAULT_MINOR_VERSION_)) then
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




procedure AlertUserResults(const searchResults : Cardinal);
var
    exitCodeExec    : Integer;          // This holds the exit code provided by the Windows Shell Environment.
begin
    case searchResults of
        0:
        begin
            MsgBox('Unable to find it!', mbCriticalError, MB_OK);
            Exit;
        end;

        1:
        begin
            MsgBox('Found it!', mbInformation, MB_OK);
            Exit;
        end;

        2:
        begin
            MsgBox('Older version found!', mbCriticalError, MB_OK);
            ;shellexec('open', 'https://github.com/PowerShell/PowerShell/releases/latest', '', '', SW_SHOW, ewNoWait, exitCodeExec);
            Exit;
        end;
    end;

    MsgBox('Unknown Search Results', mbCriticalError, MB_OK);
end; // AlertUserResults()