;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                |_|
;   ____            _                     _        _____                    __   _                                  _     _
;  / __ \          | |                   | |      / ____|                  / _| (_)                                | |   (_)
; | |  | |  _   _  | |_   _ __    _   _  | |_    | |        ___    _ __   | |_   _    __ _   _   _   _ __    __ _  | |_   _    ___    _ __
; | |  | | | | | | | __| | '_ \  | | | | | __|   | |       / _ \  | '_ \  |  _| | |  / _` | | | | | | '__|  / _` | | __| | |  / _ \  | '_ \
; | |__| | | |_| | | |_  | |_) | | |_| | | |_    | |____  | (_) | | | | | | |   | | | (_| | | |_| | | |    | (_| | | |_  | | | (_) | | | | |
;  \____/   \__,_|  \__| | .__/   \__,_|  \__|    \_____|  \___/  |_| |_| |_|   |_|  \__, |  \__,_| |_|     \__,_|  \__| |_|  \___/  |_| |_|
;                        | |                                                          __/ |
;                        |_|                                                         |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Output Base File Name
; - - - - - - - - - - -
; This provides the setup filename in the output result.  This essentially is our final compiled build that
;   the user will install.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputbasefilename
OutputBaseFilename = {#_FILE_NAME_INSTALLER_}


; Output Directory
; - - - - - - - - -
; This will specify the location in which the setup file will be stored once the Inno Builder had
;   successfully compiled, or generated, the installer file(s).
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputdir
OutputDir = {#_INSTALLER_OUTPUT_DIRECTORY_}


; Manifest File
; - - - - - - -
; The manifest provides information regarding the files that had been stored within the installer package.
;   With this information, it can be used to determine if a file was properly packaged within the installer
;   and determine the meta data of a specific file.
;
; Such information of the file(s) stored provides the following:
;       1. Index
;       2. Source File Name
;       3. Time Stamp
;       4. Version
;       5. SHA1
;       6. Original Size
;       7. First Slice
;       8. Last Slice
;       9. Start Offset
;       10. Chunk Sub-Offset
;       11. Chunk Compressed Size
;       12. Encrypted
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputmanifestfile
OutputManifestFile = {#_FILE_NAME_MANIFEST_}