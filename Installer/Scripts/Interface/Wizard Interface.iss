;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;           __          __  _                            _     _____           _                    __
;           \ \        / / (_)                          | |   |_   _|         | |                  / _|
;            \ \  /\  / /   _   ____   __ _   _ __    __| |     | |    _ __   | |_    ___   _ __  | |_    __ _    ___    ___
;             \ \/  \/ /   | | |_  /  / _` | | '__|  / _` |     | |   | '_ \  | __|  / _ \ | '__| |  _|  / _` |  / __|  / _ \
;              \  /\  /    | |  / /  | (_| | | |    | (_| |    _| |_  | | | | | |_  |  __/ | |    | |   | (_| | | (__  |  __/
;               \/  \/     |_| /___|  \__,_| |_|     \__,_|   |_____| |_| |_|  \__|  \___| |_|    |_|    \__,_|  \___|  \___|
;                                                               Blue face for an Interface
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Setup]


; Wizard Image Stretch
; - - - - - - - - - - - - -
; This option will allow the ability to stretch the Left Panel image such that it fits the appropriate area
;   within the installer.  Otherwise, the Left Panel image will be centered within the area instead.
;
; Values:
;   No  = Center the panel image if it is smaller than the panel section.
;   Yes = Stretch the panel image if it is smaller than the panel section.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_wizardimagestretch
WizardImageStretch = "Yes"




; Wizard Installer Window Resizable
; - - - - - - - - - - - - -
; When set to 'Yes', this will allow the end-user to resize the Wizard Installer window from a range of
;   pre-defined size anchors.
;
; Values:
;   No  = Disallow the user to resize the Wizard Installer window.
;   Yes = Allow the ability for the user to resize the Wizard Installer window.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_wizardresizable
WizardResizable = "No"


[/Setup]