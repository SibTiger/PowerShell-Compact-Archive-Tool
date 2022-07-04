;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;       ____            _     _                           _     _____                               _                       _
;      / __ \          | |   (_)                         | |   |  __ \                             | |                     | |
;     | |  | |  _ __   | |_   _    ___    _ __     __ _  | |   | |  | |   ___   __      __  _ __   | |   ___     __ _    __| |  ___
;     | |  | | | '_ \  | __| | |  / _ \  | '_ \   / _` | | |   | |  | |  / _ \  \ \ /\ / / | '_ \  | |  / _ \   / _` |  / _` | / __|
;     | |__| | | |_) | | |_  | | | (_) | | | | | | (_| | | |   | |__| | | (_) |  \ V  V /  | | | | | | | (_) | | (_| | | (_| | \__ \
;      \____/  | .__/   \__| |_|  \___/  |_| |_|  \__,_| |_|   |_____/   \___/    \_/\_/   |_| |_| |_|  \___/   \__,_|  \__,_| |___/
;              | |
;              |_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Descrition
; ------------------------
; This provides the user with the ability to manually download additional applications that will work with
;   intended software.  Normally, traditional installers will package all of the requried applications for the
;   user by default.  But the difference here is in two scenarios:
;       1) The additional applications are merely optional, not required.
;       2) If we packaged the additional applications, they may become obselete when a new user were to use
;           this installer.  I'd much rather the user to use the latest and greatest available; providing
;           further enhancements, fixes, and even security improvements.



[CustomMessages]
ManuallyDownloadOptionalApplications = Manually Download Optional Applications:


[Tasks]
Name: "OpenURL_7Zip"; Description: "7Zip"; GroupDescription: "{cm:ManuallyDownloadOptionalApplications}"; Flags: unchecked
Name: "OpenURL_Git"; Description: "Git-SCM"; GroupDescription: "{cm:ManuallyDownloadOptionalApplications}"; Flags: unchecked


[Run]
FileName: "https://www.7-zip.org/"; Flags: shellexec runasoriginaluser; Tasks: OpenURL_7Zip
FileName: "https://git-scm.com/"; Flags: shellexec runasoriginaluser; Tasks: OpenURL_Git