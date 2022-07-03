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



; Application and Scripts
; - - - - - - - - - - - -
Source: "Compile\PSCAT.ps1";                    DestDir: "{app}\Bin\";      Flags: confirmoverwrite recursesubdirs createallsubdirs ignoreversion touch
Source: "Scripts\Program Modes\Clean.ps1";      DestDir: "{app}\Bin\";      Flags: confirmoverwrite recursesubdirs createallsubdirs ignoreversion touch
Source: "Scripts\Program Modes\Uninstall.ps1";  DestDir: "{app}\Bin\";      Flags: confirmoverwrite recursesubdirs createallsubdirs ignoreversion touch



; Icons and Shortcuts
; - - - - - - - - - -
Source: "Installer\Product Assets\Desktop Icon\Desktop Icon.ico";   DestDir: "{app}\icons\";    Flags: confirmoverwrite recursesubdirs createallsubdirs ignoreversion touch
Source: "Installer\Product Assets\Graphic - Setup\Uninstall\Uninstall Icon.ico";    DestDir: "{app}\icons\"; Flags: confirmoverwrite recursesubdirs createallsubdirs ignoreversion touch



; Online Resources
; - - - - - - - - -
Source: "Installer\Product Assets\Web\*";       DestDir: "{app}\Websites\"; Flags: recursesubdirs createallsubdirs ignoreversion touch