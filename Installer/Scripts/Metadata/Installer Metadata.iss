;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;         _____                 _             _   _                   __  __          _                 _           _
;        |_   _|               | |           | | | |                 |  \/  |        | |               | |         | |
;          | |    _ __    ___  | |_    __ _  | | | |   ___   _ __    | \  / |   ___  | |_    __ _    __| |   __ _  | |_    __ _
;          | |   | '_ \  / __| | __|  / _` | | | | |  / _ \ | '__|   | |\/| |  / _ \ | __|  / _` |  / _` |  / _` | | __|  / _` |
;         _| |_  | | | | \__ \ | |_  | (_| | | | | | |  __/ | |      | |  | | |  __/ | |_  | (_| | | (_| | | (_| | | |_  | (_| |
;        |_____| |_| |_| |___/  \__|  \__,_| |_| |_|  \___| |_|      |_|  |_|  \___|  \__|  \__,_|  \__,_|  \__,_|  \__|  \__,_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Company
; - - - -
; Name of the company or publisher regarding the project.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfocompany
VersionInfoCompany = {#_PRODUCT_AUTHOR_}



; Copyright
; - - - - -
; This specifies the project's copyright information.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfocopyright
VersionInfoCopyright = {#_PRODUCT_VERSION_DATE_}



; Description
; - - - - - -
; This provides a brief description of the project.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfodescription
VersionInfoDescription = {#_PRODUCT_NAME_FULL_} + " Installer"



; Original File Name
; - - - - - - - - - -
; This specifies the origitgnal file name for the setup.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfooriginalfilename
VersionInfoOriginalFileName = {#_PRODUCT_NAME_SHORT_}



; Product Name
; - - - - - - -
; This will specify the product name.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproductname
VersionInfoProductName = {#_PRODUCT_NAME_FULL_}



; Product Text Version
; - - - - - - - - - - -
; This will provide a textual product version
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproducttextversion
VersionInfoProductTextVersion = {#_PRODUCT_VERSION_} + " (" + {#_PRODUCT_VERSION_CODENAME_} + ") - " + {#_PRODUCT_VERSION_DATE_}



; Product Version
; - - - - - - - -
; This will provide a product version
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproductversion
VersionInfoProductVersion = {#_PRODUCT_VERSION_}



; Version
; - - - -
; This will provide a version of the installer
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoversion
VersionInfoVersion = "1.0.0.0"