;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;             _____                 _      _                        _____   _                      _                    _
;            |  __ \               | |    | |                      / ____| | |                    | |                  | |
;            | |  | |   ___   ___  | | __ | |_    ___    _ __     | (___   | |__     ___    _ __  | |_    ___   _   _  | |_
;            | |  | |  / _ \ / __| | |/ / | __|  / _ \  | '_ \     \___ \  | '_ \   / _ \  | '__| | __|  / __| | | | | | __|
;            | |__| | |  __/ \__ \ |   <  | |_  | (_) | | |_) |    ____) | | | | | | (_) | | |    | |_  | (__  | |_| | | |_
;            |_____/   \___| |___/ |_|\_\  \__|  \___/  | .__/    |_____/  |_| |_|  \___/  |_|     \__|  \___|  \__,_|  \__|
;                                                       | |
;                                                       |_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





; Descrition
; ------------------------
; Create a desktop shortcut to the application.




[Tasks]

Name: "DesktopIcon";                                \
    Description: "{cm:CreateDesktopIcon}";          \
    GroupDescription: "{cm:AdditionalIcons}";       \
    Flags: Unchecked;

[/Tasks]




[Icons]

Name: "{userdesktop}\{#_PRODUCT_NAME_FULL_}";       \
    FileName: "{app}\Bin\PSCAT.ps1";                \
    IconFilename: "{app}\Icons\Desktop Icon.ico";   \
    Tasks: DesktopIcon;

[/Icons]