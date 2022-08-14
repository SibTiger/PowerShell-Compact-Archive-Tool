;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                                          _                                _
;                                         | |                              (_)
;                                         | |        ___     __ _    __ _   _   _ __     __ _
;                                         | |       / _ \   / _` |  / _` | | | | '_ \   / _` |
;                                         | |____  | (_) | | (_| | | (_| | | | | | | | | (_| |
;                                         |______|  \___/   \__, |  \__, | |_| |_| |_|  \__, |
;                                                            __/ |   __/ |               __/ |
;                                                           |___/   |___/               |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Wizard]


; Terminal Logging and Writing Logfile of Installation Procedure
; - - - - - - - - - - - - -
; This allows the ability for generating a Logfile containing sane-verbosity of all internalized actions that
;   are taking place within the installer in a step-by-step procedure.
;
; The information is viewable in two ways, simultaneously.
;   1. Terminal Output from the Inno Setup
;   2. Logfile located within the %TEMP% directory.
;
; Values:
;   Yes = Generate a verbose Logfile AND output results to Inno Setup Terminal
;   No  = Do not create a logfile nor provide results to the Inno Setup Terminal [Default]
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_setuplogging
SetupLogging = no


[/Wizard]