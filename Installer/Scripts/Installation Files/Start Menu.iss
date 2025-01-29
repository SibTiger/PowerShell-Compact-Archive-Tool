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





[Icons]


; Applications
Name: "{group}\{#_PRODUCT_NAME_SHORT_}\{#_PRODUCT_NAME_FULL_}";              \
    Filename: "{app}\Bootstrap\Bootstrap Loader.bat";

Name: "{group}\{#_PRODUCT_NAME_SHORT_}\{#_PRODUCT_NAME_FULL_} - Clean";      \
    Filename: "{app}\Bootstrap\Clean.bat";




; Text
Name: "{group}\Text\ReadMe";                                                 \
    Filename: "{app}\ReadMe.txt";

Name: "{group}\Text\License";                                               \
    Filename: "{app}\License.txt";




; Websites
Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Homepage";                   \
    Filename: "{#_PRODUCT_WEBSITE_HOMEPAGE_}";

Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Updates";                    \
    Filename: "{#_PRODUCT_WEBSITE_UPDATES_}";

Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Discussion Board";           \
    Filename: "{#_PRODUCT_WEBSITE_COMMUNITY_}";

Name: "{group}\Websites\{#_PRODUCT_NAME_SHORT_} Wiki";                       \
    Filename: "{#_PRODUCT_WEBSITE_SUPPORT_}";


[/Icons]
