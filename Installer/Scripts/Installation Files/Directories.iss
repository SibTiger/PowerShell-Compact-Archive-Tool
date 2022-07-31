;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                                 _____    _                        _                    _
;                                |  __ \  (_)                      | |                  (_)
;                                | |  | |  _   _ __    ___    ___  | |_    ___    _ __   _    ___   ___
;                                | |  | | | | | '__|  / _ \  / __| | __|  / _ \  | '__| | |  / _ \ / __|
;                                | |__| | | | | |    |  __/ | (__  | |_  | (_) | | |    | | |  __/ \__ \
;                                |_____/  |_| |_|     \___|  \___|  \__|  \___/  |_|    |_|  \___| |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Dirs]


; User's %LocalAppData%
; - - - - - - - - - - -
; Local application data that is to remain localized within the user's profile.
;   Mainly contains log files, reports, manifests, and the like.
Name: "{localappdata}\{#_PRODUCT_NAME_FULL_}";          \
    flags: uninsalwaysuninstall;




; User's %AppData%
; - - - - - - - - -
; Contains application data that can be, within a domain infustracture, transported from one system to another.
;   Thus, allowing the user's data to be movable with the user needs as they see fit.
Name: "{userappdata}\{#_PRODUCT_NAME_FULL_}";           \
    flags: uninsalwaysuninstall;

Name: "{userappdata}\{#_PRODUCT_NAME_FULL_}\Configs";   \
    flags: uninsalwaysuninstall;




; User's %UserProfile%\My Documents
; - - - - - - - - - - - - - - - - -
; All compiled builds will be stored within this location, given the user the fastest possible way to accessing
;   the generated builds.
Name: "{userdocs}\{#_PRODUCT_NAME_FULL_}";              \
    flags: uninsneveruninstall;


[/Dirs]