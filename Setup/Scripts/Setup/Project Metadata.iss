;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                |_|
;             _____                     _                 _       __  __          _                 _           _
;            |  __ \                   (_)               | |     |  \/  |        | |               | |         | |
;            | |__) |  _ __    ___      _    ___    ___  | |_    | \  / |   ___  | |_    __ _    __| |   __ _  | |_    __ _
;            |  ___/  | '__|  / _ \    | |  / _ \  / __| | __|   | |\/| |  / _ \ | __|  / _` |  / _` |  / _` | | __|  / _` |
;            | |      | |    | (_) |   | | |  __/ | (__  | |_    | |  | | |  __/ | |_  | (_| | | (_| | | (_| | | |_  | (_| |
;            |_|      |_|     \___/    | |  \___|  \___|  \__|   |_|  |_|  \___|  \__|  \__,_|  \__,_|  \__,_|  \__|  \__,_|
;                                     _/ |
;                                    |__/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Application Name
; - - - - - - - - -
; This will provide the name of the product.  This will be visible throughout the entire installation wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appname
AppName = {#_PRODUCT_NAME_FULL_}


; Application Version Name
; - - - - - - - - - - - - -
; This will provide the name and version of the product.  This will be visible in the Add/Remove Programs
;   within the classical Control Panel and the Welcome Page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appvername
AppVerName = {#_PRODUCT_NAME_FULL_} + " " + {#_PRODUCT_VERSION_} + " (" + _PRODUCT_VERSION_CODENAME_ + ")"


; Application Version
; - - - - - - - - - -
; This will specify the version of the application that is being installed.  Tis will be visible in the
;   Add/Remove Program within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appversion
AppVersion = {#_PRODUCT_VERSION_}


; Application Comments
; - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcomments
AppComments = {#_PRODUCT_BRIEF_DESCRIPTION_}


; Application Contact
; - - - - - - - - - -
; This will be displayed in the Add/Remove Porgrams within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcontact
AppContact = {#_PRODUCT_WEBSITE_SUPPORT_}


; Application Publisher
; - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_apppublisher
AppPublisher = {#_PRODUCT_AUTHOR_}


; Application Publisher Homepage
; - - - - - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_apppublisherurl
AppPublisherURL = {#_PRODUCT_WEBSITE_AUTHOR_}


; Application Readme File
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appreadmefile
AppReadmeFile = {#_PRODUCT_README_FILE_}


; Application Support URL
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appsupporturl
AppSupportURL = {#_PRODUCT_WEBSITE_SUPPORT_}


; Application Updates URL
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appupdatesurl
AppUpdatesURL = {#_PRODUCT_WEBSITE_UPDATES_}


; Application Copyright
; - - - - - - - - - - -
; This will be visible in the Installer's window or fullscreen.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcopyright
AppCopyright = "Copyright (C) " + {#_PRODUCT_COPYRIGHT_}