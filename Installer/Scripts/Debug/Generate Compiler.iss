;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;         _____                                        _               _____                               _   _
;        / ____|                                      | |             / ____|                             (_) | |
;       | |  __    ___   _ __     ___   _ __    __ _  | |_    ___    | |        ___    _ __ ___    _ __    _  | |   ___   _ __
;       | | |_ |  / _ \ | '_ \   / _ \ | '__|  / _` | | __|  / _ \   | |       / _ \  | '_ ` _ \  | '_ \  | | | |  / _ \ | '__|
;       | |__| | |  __/ | | | | |  __/ | |    | (_| | | |_  |  __/   | |____  | (_) | | | | | | | | |_) | | | | | |  __/ | |
;        \_____|  \___| |_| |_|  \___| |_|     \__,_|  \__|  \___|    \_____|  \___/  |_| |_| |_| | .__/  |_| |_|  \___| |_|
;                                                                                                 | |
;                                                                                                 |_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Setup]


; Create Installer Package
; - - - - - - - - - - - - -
; This will specify if we are wanting to generate an installer package or if we only want to check for script
;   errors without needing to create an installer package.  However, regardless of this setting, the Output
;   Directory (or OutputDir) will be cleaned.
;
; Values:
;   Yes = Generates an installer package [Default]
;   No  = Only check for script errors; An installer will not be generated.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_output
Output = "Yes"


[/Setup]