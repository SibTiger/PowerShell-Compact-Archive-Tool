;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;               ______   _   _            __  __                                                                     _
;              |  ____| (_) | |          |  \/  |                                                                   | |
;              | |__     _  | |   ___    | \  / |   __ _   _ __     __ _    __ _    ___   _ __ ___     ___   _ __   | |_
;              |  __|   | | | |  / _ \   | |\/| |  / _` | | '_ \   / _` |  / _` |  / _ \ | '_ ` _ \   / _ \ | '_ \  | __|
;              | |      | | | | |  __/   | |  | | | (_| | | | | | | (_| | | (_| | |  __/ | | | | | | |  __/ | | | | | |_
;              |_|      |_| |_|  \___|   |_|  |_|  \__,_| |_| |_|  \__,_|  \__, |  \___| |_| |_| |_|  \___| |_| |_|  \__|
;                                                                           __/ |
;                                                                          |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Merge Duplicate Files
; - - - - - - - - - - -
; If incase there exists multiple duplicate files, then we can be able to ignore all other duplicate sources
;   but only use the first instance instance.  By doing this, we minimize the need to store every duplicate
;   file - thus reducing the overall package size.  Moreover, the output that requires the duplicated data
;   to exist, will still be provided as intended.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_mergeduplicatefiles
MergeDuplicateFiles = "Yes"