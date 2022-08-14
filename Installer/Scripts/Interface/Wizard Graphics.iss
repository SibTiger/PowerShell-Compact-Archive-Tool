;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;               __          __  _                            _      _____                          _       _
;               \ \        / / (_)                          | |    / ____|                        | |     (_)
;                \ \  /\  / /   _   ____   __ _   _ __    __| |   | |  __   _ __    __ _   _ __   | |__    _    ___   ___
;                 \ \/  \/ /   | | |_  /  / _` | | '__|  / _` |   | | |_ | | '__|  / _` | | '_ \  | '_ \  | |  / __| / __|
;                  \  /\  /    | |  / /  | (_| | | |    | (_| |   | |__| | | |    | (_| | | |_) | | | | | | | | (__  \__ \
;                   \/  \/     |_| /___|  \__,_| |_|     \__,_|    \_____| |_|     \__,_| | .__/  |_| |_| |_|  \___| |___/
;                                                                                         | |
;                                                                                         |_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Setup]


; Setup Icon
; - - - - - - - - - - - - -
; This will specify the icon that will be associated with the Installer and Uninstaller applications.
;
; Values:
;   (BLANK)         = Default Inno Setup Icon
;   (custom String) = Defined icon
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_setupiconfile
SetupIconFile = ".\Installer\Product Assets\Graphic - Setup\Install\Setup Icon.ico"




; Uninstall Display Icon
; - - - - - - - - - - - -
; This lets you specify a particular icon file (either an executable or an .ico file) to display for the
;   Uninstall entry in the Add/Remove Programs Control Panel applet. The filename will normally begin with
;   a directory constant.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalldisplayicon
UninstallDisplayIcon = "{app}\icons\Uninstall Icon.ico"




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
WizardImageFile = ".\Installer\Product Assets\Graphic - Wizard\Banner\*.bmp"




; Wizard Small Image File
; - - - - - - - - - - - - -
; This will specify the image that will be displayed on the right side of the Wizard Installer window.
;
; Values:
;   (BLANK)         = Default Inno Wizard Installer images
;   (custom String) = Defined images
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_wizardsmallimagefile
WizardSmallImageFile = ".\Installer\Product Assets\Graphic - Wizard\Logo\*.bmp"


[/Setup]