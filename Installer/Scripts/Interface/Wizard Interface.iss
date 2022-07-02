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




; Wizard Image File
; - - - - - - - - - - - - -
; This will specify the image that will be displayed on the left side of the Wizard Installer window.
;
; Values:
;   (BLANK)         = Default Inno Wizard Installer images
;   (custom String) = Defined images
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_wizardimagefile
WizardImageFile = ".\Installer\Product Assets\Graphic - Wizard - Left Panel\*.bmp"
