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




[CustomMessages]
; PowerShell Core was not found
MSGBOX_POSH_NOT_FOUND   =Unable to find an installation of PowerShell Core!%n%nPlease keep in mind that PowerShell Core is required in order for the {#_PRODUCT_NAME_FULL_} to work properly.

; PowerShell Core was found
MSGBOX_POSH_FOUND       =Successfully located an install instance of PowerShell Core!

; PowerShell Core was found but is an older version
MSGBOX_POSH_OUTDATED    =Installed version of PowerShell Core is outdated!%n%n{#_PRODUCT_NAME_FULL_} requires a later version of PowerShell Core than what is presently already installed.

; Detection Algorithm had failed or retrieved an unexpected value
MSGBOX_UNKNOWN_RESULT   =Unable to determine if PowerShell Core was already installed!%n%nPlease be sure that you have the PowerShell Core already installed.

; Download PowerShell Core Alert
MSGBOX_DOWNLOAD_POSH    =Would you like to download the latest official PowerShell Core build?




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

    // Allow Debug messages to be logged\shown in Inno Setup Debug Output console?
    _ALLOW_DEBUG_MESSAGES_  = false;





// Function Prototypes
// ------------------------------------------------------------
procedure   DetectPowerShellCore    ()                                                                                      ; forward;
function    RetrieveSubKeyList      (const HiveKey : Integer)                                           : TArrayOfString    ; forward;
function    ScanRetrievedSubKeys    (const hiveKey : Integer; const subKeyItemList : TArrayOfString)    : Cardinal          ; forward;
function    FindValueTarget         (const HiveKey : Integer; const ValueToInspect : String)            : Cardinal          ; forward;
procedure   AlertUserResults        (const searchResults : Cardinal)                                                        ; forward;





// ------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------





// Inno Setup will automatically call this function when appropriate.
function PrepareToInstall(var NeedsRestart: Boolean) : String;
begin
    // Try to find the current installation instance of PowerShell Core.
    DetectPowerShellCore();


    // Restarting the system is not necessary
    NeedsRestart := false;


    // Return an empty string
    Result := '';
end; // InitializeSetup()




// ==========================================================================================
// ==========================================================================================




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
procedure DetectPowerShellCore();
// Variables
var
    scanResults : Cardinal;         // This will hold the Results from the Scan.


// Code
begin
    // Perform the algorithm using the appropriate procedure depending on the host's CPU architecture.


    // Windows 64Bit
    if (IsWin64) then
        // Check if the application was a 64Bit version.
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_64_, \
                                            RetrieveSubKeyList(_DEFAULT_ROOTKEY_64_));


    // Windows 32Bit OR 64Bit application was not found
    if (scanResults = 0) then
        scanResults := ScanRetrievedSubKeys(_DEFAULT_ROOTKEY_32_, \
                                            RetrieveSubKeyList(_DEFAULT_ROOTKEY_32_));


    // With the scan finished, provide the results to the user's attention.
    AlertUserResults(scanResults);
end; // DetectPowerShellCore()




// ==========================================================================================
// ==========================================================================================




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




// ==========================================================================================
// ==========================================================================================




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
// Variables
var
    loopIterator    : Integer;          // Used for our For-Loop to scan the SubKeys.
    itemSelected    : String;           // The current SubKey or Value that will be examined.


// Code
begin
    // If there's nothing within the list, then there's nothing for us to do.
    if (GetArrayLength(subKeyItemList) <= 0) then
    begin
        // There's nothing for us to do.
        Result := 0;


        // Leave from this function
        Exit;
    end; // if : No Items in Array


    // Scan each SubKey within the array.
    for loopIterator := 0 to GetArrayLength(subKeyItemList) - 1 do
    begin
        // Generate the full Subkey address that we want to further inspect.
        itemSelected := _DEFAULT_SUBKEY_PATH_ + '\' + subKeyItemList[loopIterator];


        // Debug stuff
        if (_ALLOW_DEBUG_MESSAGES_) then
            //  Display what Subkey is currently being inspected.
            Log(Format('Inspecting SubKey: %s',[itemSelected]));


        // Determine if the target dependency exists
        Result := FindValueTarget(hiveKey, itemSelected);


        // If we found the target, then we may leave this function.
        //  Otherwise, continue with the algorithm.
        if (Result) > 0 then
            Exit;
    end; // for()
end; // ScanRetrievedSubKeys()




// ==========================================================================================
// ==========================================================================================




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
// Variables
var
    itemSelected    : String;           // The Value that will be examined.
    positionCounter : Integer;          // This will determine the position of when the delimiter occurs.
    versionMajor    : Cardinal;         // This will hold the value returned by the Windows Registry, POSH Major Version.
    versionMinor    : Cardinal;         // This will hold the value returned by the Windows Registry, POSH Minor Version.


// Code
begin
    // Debug stuff.
    if (_ALLOW_DEBUG_MESSAGES_) then
        //  This is to make sure that the arguments contains the right informaiton.
        Log(Format('Inspecting Value: %s', [ValueToInspect]));


    // Check to see if 'DisplayName' exists within the SubKey AND to also obtain the data within the
    //  'DisplayName' value.
    if ((RegValueExists(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_)) and \
        (RegQueryStringValue(HiveKey, ValueToInspect, _DEFAULT_SUBKEY_VALUE_, itemSelected))) then
    begin
        // Because the Value of the 'DisplayName' in the PowerShell Core SubKey contains its version and the product's
        //  name, we will have to parse it such that we can properly examine the string.
        //  We are only interested in the 'PowerShell' keyword, all others are ignored.
        // For instance: "PowerShell 7.2.5.0-x64"
        //  We only want "PowerShell" while omitting all other characters after the stem word, 'PowerShell'.
        positionCounter := Pos(' ', itemSelected);
        itemSelected    := Copy(itemSelected, 1, positionCounter - 1);


        // Compare the strings; did we find the target?
        if (CompareText(itemSelected, _DEFAULT_KEYWORD_EXEC_) = 0) then
        begin
            // Found the target!


            // Make sure that it's version meets the requirements
            if ((RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMajor', versionMajor))     and \
                    (versionMajor >= _DEFAULT_MAJOR_VERSION_)                                   and \
                    (RegQueryDWordValue(HiveKey, ValueToInspect, 'VersionMinor', versionMinor)) and \
                (versionMinor >= _DEFAULT_MINOR_VERSION_)) then
            begin
                // Version meets the requirements
                Result := 1;


                // Finished
                Exit;
            end // if : Target Found & Meets Requirements


            // The instance does not meet the desired requirements
            else
            begin
                // Version requirements were not met.
                Result := 2;


                // Finished
                Exit;
            end; // else : Target Found & Fails to Meet Requirements
        end; // if : Found Target
    end; // if : SubKey contains 'DisplayName' Value with Data.


    // Unable to find the target.
    Result := 0;
end; // FindValueTarget()




// ==========================================================================================
// ==========================================================================================




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
// Variables
var
    exitCodeExec    : Integer;          // This holds the exit code provided by the Windows Shell Environment.


// Code
begin
    // Determine what action to take.
    case searchResults of
        // Unable to find the target
        0:
            MsgBox(ExpandConstant('{cm:MSGBOX_POSH_NOT_FOUND}'), \
                    mbError, \
                    MB_OK);


        // Found the target and meets the requirements.
        1:
        begin
            // Found the target!

            // Debug Stuff
            if (_ALLOW_DEBUG_MESSAGES_) then
                // Provide a message box showing that the algorithm had successfully found the target.
                MsgBox(ExpandConstant('{cm:MSGBOX_POSH_FOUND}'), \
                        mbInformation, \
                        MB_OK);

            // Finished!
            Exit;
        end; // Case 1 : Found Target


        // Found the target but does not meet the requirements.
        2:
            MsgBox(ExpandConstant('{cm:MSGBOX_POSH_OUTDATED}'), \
                    mbError, \
                    MB_OK);


        // Obtained a result that was not expected.
        else
        begin
            MsgBox(ExpandConstant('{cm:MSGBOX_UNKNOWN_RESULT}'), \
                    mbCriticalError, \
                    MB_OK);
            Exit;
        end; // Error Case
    end; // Switch




    // Ask the user if they want to be directed to PowerShell Core's official download page.
    if (MsgBox(ExpandConstant('{cm:MSGBOX_DOWNLOAD_POSH}'), mbConfirmation, mb_YESNO) = IDYES) then
        // Take the user to the download page.
        shellexec('open', \
                    'https://github.com/PowerShell/PowerShell/releases/latest', \
                    '', \
                    '', \
                    SW_SHOW, \
                    ewNoWait, \
                    exitCodeExec);
end; // AlertUserResults()
[/code]