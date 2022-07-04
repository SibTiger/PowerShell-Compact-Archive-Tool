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
function InitializeSetup() : Boolean;
var
    iterator        : Integer;          // This will be used in the for-loop as we scan the KeyNameList var.
    KeyNameList     : TArrayOfString;   // This will hold the values within the Key
    KeyNameCurrent  : string;           // This will hold the value
    // - - - -
    iteratorInner   : Integer;
    ValueNameList   : TArrayOfString;
    ValueNameCurrent: string;
    // - - - -
    ValueDataString : string;
    ParsedValue     : string;
    posCount        : Integer;
    POSHMajorVer    : Cardinal;
    errorCode       : Integer;
begin
    if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', KeyNameList) then
    begin
        for iterator := 0 to GetArrayLength(KeyNameList) - 1 do
        begin
            KeyNameCurrent := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' + '\' + KeyNameList[iterator];

            Log(Format('Found Key %s', [KeyNameCurrent]));

            if RegGetValueNames(HKEY_LOCAL_MACHINE, KeyNameCurrent, ValueNameList) then
            begin
                for iteratorInner := 0 to GetArrayLength(ValueNameList) - 1 do
                begin
                    ValueNameCurrent := KeyNameCurrent + '\' + ValueNameList[iteratorInner];

                    Log(Format('Found Value of %s', [ValueNameCurrent]));

                    if (RegQueryStringValue(HKEY_LOCAL_MACHINE, KeyNameCurrent, ValueNameList[iteratorInner], ValueDataString)) then
                    begin
                        posCount := Pos(' ', ValueDataString);
                        ParsedValue := Copy(ValueDataString, 1, posCount - 1);

                        Log(Format('Data is %s', [ParsedValue]));

                        if (CompareText(ParsedValue, 'PowerShell') = 0) then
                        begin
                            if (RegQueryDWordValue(HKEY_LOCAL_MACHINE, KeyNameCurrent, 'VersionMajor', POSHMajorVer)) and (POSHMajorVer >= 7) then
                            begin
                                MsgBox('Found it!', mbInformation, MB_OK);
                            end
                            else
                            begin
                                MsgBox('Unable to find it!', mbCriticalError, MB_OK);
                                shellexec('open', 'https://github.com/PowerShell/PowerShell/releases/latest', '', '', SW_SHOW, ewNoWait, errorCode);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

