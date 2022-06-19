;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;             _____                 _             _   _           _     _                       ______   _   _
;            |_   _|               | |           | | | |         | |   (_)                     |  ____| (_) | |
;              | |    _ __    ___  | |_    __ _  | | | |   __ _  | |_   _    ___    _ __       | |__     _  | |   ___   ___
;              | |   | '_ \  / __| | __|  / _` | | | | |  / _` | | __| | |  / _ \  | '_ \      |  __|   | | | |  / _ \ / __|
;             _| |_  | | | | \__ \ | |_  | (_| | | | | | | (_| | | |_  | | | (_) | | | | |     | |      | | | | |  __/ \__ \
;            |_____| |_| |_| |___/  \__|  \__,_| |_| |_|  \__,_|  \__| |_|  \___/  |_| |_|     |_|      |_| |_|  \___| |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




Source: "Compile\PSCAT.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Scripts\Program Modes\Clean.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Scripts\Program Modes\Uninstall.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Setup\Resources\Web\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs