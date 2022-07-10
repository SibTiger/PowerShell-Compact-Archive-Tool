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
// Global Variables
var
    // This will help us to determine if we were able to find the PowerShell instance and
    //  alert the parent function, within the stack, to abort.
    //  - False = Continue Scanning; Nested Function had not yet found instance.
    //  - True  = Found POSHCore; Nested Function had alerted the user.
    FOUND_TARGET            : Boolean;



// Global Constant Variables
const
    // This defines the SubKey path that we want to examine within the Windows Registry.
    _DEFAULT_SUBKEY_PATH_   = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';

    // This defines the Hivekey that we want to access that contains the desired SubKey.
    _DEFAULT_ROOTKEY_       = HKEY_LOCAL_MACHINE;

    // This defines the desired keyword that we are wanting to inspect within the DisplayName.
    _DEFAULT_KEYWORD_EXEC_  = 'PowerShell';

    // This will define the Value within the SubKey that we must examine
    _DEFAULT_SUBKEY_VALUE_  = 'DisplayName';

    // This defines the Major Version required, at minimum, for PowerShell.
    _DEFAULT_MAJOR_VERSION_ = 7;

    // This defines the Minor Version required - but incorporated with the Major Version.
    _DEFAULT_MINOR_VERSION_ = 2;




// Function Prototype for our DetectPowerShellCore().
procedure DetectPowerShellCore(SubKeyOrValue: String); forward;



// Inno Setup will automatically call this function when appropriate.
function InitializeSetup() : Boolean;
begin
    // Initialize the global variables for this algorithm to function properly.
    FOUND_TARGET := false;

    // Try to find the current install of PowerShell Core.
    DetectPowerShellCore(_DEFAULT_SUBKEY_PATH_);
end;




// Detect PowerShell Core
// --------------------------------------
// This algorithm will try its best to find a current installation of the PowerShell Core.  If the install
//  could not be found, then the installer will alert the user.  If the install was found, then the operation
//  will continue as normal.
// --------------------------------------
procedure DetectPowerShellCore(SubKeyOrValue : String);
// Variables
var
    // Global Step Variables
    loopIterator    : Integer;          // Used for our For-Loop to scan the SubKeys or Values.
    itemArray       : TArrayOfString;   // This will hold all of the SubKeys and Values that had been obtained.
    itemSelected    : String;           // The current SubKey or Value that will be examined.

    // - - - -
    // Second Step Variables:
    positionCounter : Integer;          // This will determine the position of when the delimiter occurs.
    versionMajor    : Cardinal;         // This will hold the value returned by the Windows Registry.
    exitCodeExec    : Integer;          // This holds the exit code provided by the Windows Shell Environment.
begin
    // Determine if we are inspecting SubKeys or Values within the desired SubKey.

    // Retrieve all possible SubKeys within the provided location.
    //  RECURSION NOTE: If there are no SubKeys but only Values instead, then procede to the next step.
    Log(Format('Inspecting: %s',[SubKeyOrValue]));
    if (RegGetSubkeyNames(_DEFAULT_ROOTKEY_, SubKeyOrValue, itemArray) and (GetArrayLength(itemArray) > 0)) then
    begin
        Log('Executing this...');
        // Examine all obtained SubKeys
        for loopIterator := 0 to GetArrayLength(itemArray) - 1 do
        begin
            // Cache the result such that we can easily pass it.
            itemSelected := _DEFAULT_SUBKEY_PATH_ + '\' + itemArray[loopIterator];

            Log(Format('Inspecting SubKey: %s',[itemSelected]));
            // Call this function again, such that we may examine the values.
            DetectPowerShellCore(itemSelected);

            // If the nested function had found an instance, then we are finished.
            if (FOUND_TARGET) then
            begin
                Exit;
            end;
        end;

        MsgBox('Unable to find it!', mbCriticalError, MB_OK);
        shellexec('open', 'https://github.com/PowerShell/PowerShell/releases/latest', '', '', SW_SHOW, ewNoWait, exitCodeExec);
        Exit;
    end // if : SubKey Names Retrieved

    else
    begin
        Log(Format('Inspecting Value: %s',[SubKeyOrValue]));

        // Check to see if 'DisplayName' exists within the SubKey.
        if ((RegValueExists(_DEFAULT_ROOTKEY_, SubKeyOrValue, _DEFAULT_SUBKEY_VALUE_)) and (RegQueryStringValue(_DEFAULT_ROOTKEY_, SubKeyOrValue, _DEFAULT_SUBKEY_VALUE_, itemSelected))) then
        begin
            // Because the PowerShell Core has a space within its Data in the SubKey DisplayName, containing version and other information,
            //  we will have to parse out all other reminaces and only focus strictly on the 'PowerShell' keyword.
            positionCounter := Pos(' ', itemSelected);
            itemSelected    := Copy(itemSelected, 1, positionCounter - 1);

            // Compare the string
            if (CompareText(itemSelected, _DEFAULT_KEYWORD_EXEC_) = 0) then
            begin
                // Found PowerShell Core!
                FOUND_TARGET := True;

                // Make sure that it's version meets the requirements
                if ((RegQueryDWordValue(_DEFAULT_ROOTKEY_, SubKeyOrValue, 'VersionMajor', versionMajor)) and (versionMajor >= _DEFAULT_MAJOR_VERSION_) and (RegQueryDWordValue(_DEFAULT_ROOTKEY_, SubKeyOrValue, 'VersionMinor', versionMinor)) and (versionMinor >= _DEFAULT_MINOR_VERSION_)) then
                begin
                    // The installed instance meets the requirements
                    MsgBox('Found it!', mbInformation, MB_OK);
                    Exit;
                end

                // The instance does not meet the desired requirements
                else
                begin
                    MsgBox('Older version found!', mbCriticalError, MB_OK);
                    shellexec('open', 'https://github.com/PowerShell/PowerShell/releases/latest', '', '', SW_SHOW, ewNoWait, exitCodeExec);
                    Exit;
                end;
            end;
        end;
    end;
end; // DetectPowerShellCore();