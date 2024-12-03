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





; Description
; ------------------------
; This provides the user with the ability to manually download additional applications that will work with
;   intended software.  Normally, traditional installers will package all of the required applications for the
;   user by default.  But the difference here is in two scenarios:
;       1) The additional applications are merely optional, not required.
;       2) If we packaged the additional applications, they may become obsolete when a new user were to use
;           this installer.  I'd much rather the user to use the latest and greatest available; providing
;           further enhancements, fixes, and even security improvements.



[CustomMessages]

ManuallyDownloadAndInstallOptionalApplications  = %n Manually Download and Install Optional Applications:
ManuallyDownloadAndInstallResource_BurntToast   = BurntToast%n  Provides Toast Notifications to the user

[/CustomMessages]




[Tasks]

Name: "OpenURL_BurntToast";                                                         \
    Description: "{cm:ManuallyDownloadAndInstallResource_BurntToast}";              \
    GroupDescription: "{cm:ManuallyDownloadAndInstallOptionalApplications}";        \
    Flags: unchecked;

[/Tasks]




[Run]

FileName: "https://github.com/Windos/BurntToast";   \
    Flags: shellexec runasoriginaluser;             \
    Tasks: OpenURL_BurntToast;

[/Run]