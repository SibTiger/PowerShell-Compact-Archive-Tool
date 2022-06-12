;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                |_|
;                                             _____                _     _
;                                            |_   _|   ___   ___  | |_  (_)  _ __     __ _
;                                              | |    / _ \ / __| | __| | | | '_ \   / _` |
;                                              | |   |  __/ \__ \ | |_  | | | | | | | (_| |
;                                              |_|    \___| |___/  \__| |_| |_| |_|  \__, |
;                                                                                    |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Generate Installer
; ~ ~ ~ ~ ~ ~ ~ ~ ~
; This defines if we are wanting to generate an installer package or if we want to check this script for
;   errors without generating an executable file.
; NOTE: Regardless of this setting, the Output Directory will be cleaned.
;
; Values:
;   No  = Only check this script for errors, nothing is generated.
;   Yes = Generates an installer executable file.                   [Default]
#define _SPECIAL_OPERATIONS_GENERATE_INSTALLER_ "Yes"


[SETUP]
; Create Installer Package
; - - - - - - - - - - - - -
; This specifies if we are wanting to generate an installer package or to merely test the script for errors.
;   However, regardless of this setting, Inno will still perform a cleanup operation within the OutputDir.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_output
Output = {#_SPECIAL_OPERATIONS_GENERATE_INSTALLER_}