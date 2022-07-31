;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;              _____                                          _____    _                        _
;             / ____|                                        |  __ \  (_)                      | |
;            | (___     ___    _   _   _ __    ___    ___    | |  | |  _   _ __    ___    ___  | |_    ___    _ __   _   _
;             \___ \   / _ \  | | | | | '__|  / __|  / _ \   | |  | | | | | '__|  / _ \  / __| | __|  / _ \  | '__| | | | |
;             ____) | | (_) | | |_| | | |    | (__  |  __/   | |__| | | | | |    |  __/ | (__  | |_  | (_) | | |    | |_| |
;            |_____/   \___/   \__,_| |_|     \___|  \___|   |_____/  |_| |_|     \___|  \___|  \__|  \___/  |_|     \__, |
;                                                                                                                     __/ |
;                                                                                                                    |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Setup]


; Source Directory
; - - - - - - - - -
; This will specify the location as to where the files are generally located or a common-location.  With this
;   set, this changes all or most of the Output Directories and individual source file locations.  With that
;   said, the relative path depends upon this variable.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_sourcedir
SourceDir = "..\"


[/Setup]