;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                                   _____   _                    _       __  __
;                                  / ____| | |                  | |     |  \/  |
;                                 | (___   | |_    __ _   _ __  | |_    | \  / |   ___   _ __    _   _
;                                  \___ \  | __|  / _` | | '__| | __|   | |\/| |  / _ \ | '_ \  | | | |
;                                  ____) | | |_  | (_| | | |    | |_    | |  | | |  __/ | | | | | |_| |
;                                 |_____/   \__|  \__,_| |_|     \__|   |_|  |_|  \___| |_| |_|  \__,_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Applications
Name: "{group}\{#_PRODUCT_NAME_SHORT_}\{#_PRODUCT_NAME_FULL_}";             Filename: "{app}\Bin\{#_PRODUCT_NAME_SHORT_}.ps1"
Name: "{group}\{#_PRODUCT_NAME_SHORT_}\{#_PRODUCT_NAME_SHORT_} Clean";      Filename: "{app}\Bin\Clean.ps1"
Name: "{group}\{#_PRODUCT_NAME_SHORT_}\{#_PRODUCT_NAME_SHORT_} Deep-Clean"; Filename: "{app}\Bin\Uninstall.ps1"


; Uninstall Software
Name: "{group}\Uninstall\{cm:UninstallProgram,{#_PRODUCT_NAME_FULL_}}"; Filename: "{uninstallexe}"


; Websites
Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Homepage";  Filename: "{#_PRODUCT_WEBSITE_HOMEPAGE_}"
Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Updates";   Filename: "{#_PRODUCT_WEBSITE_UPDATES_}"
Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Forum";     Filename: "{#_PRODUCT_WEBSITE_COMMUNITY_}"
Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Wiki";      Filename: "{#_PRODUCT_WEBSITE_SUPPORT_}"