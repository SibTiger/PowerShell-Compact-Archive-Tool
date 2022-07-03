;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                                           __          __  _                            _
;                                           \ \        / / (_)                          | |
;                                            \ \  /\  / /   _   ____   __ _   _ __    __| |
;                                             \ \/  \/ /   | | |_  /  / _` | | '__|  / _` |
;                                              \  /\  /    | |  / /  | (_| | | |    | (_| |
;                                               \/  \/     |_| /___|  \__,_| |_|     \__,_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Allow Cancel During Install
; - - - - - - - - - - - - - -
; This allows the ability for the end-user to abort the on-going installation operation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowcancelduringinstall
AllowCancelDuringInstall = "No"



; Allow Installation on a Network Drive
; - - - - - - - - - - - - - - - - - - -
; This allows or disallows the ability to install the product onto a Network Shared Drive.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allownetworkdrive
AllowNetworkDrive = "No"



; Allow Start Menu Icons
; - - - - - - - - - - - -
; Allow the ability for the end-user to add shortcuts or not to add shortcuts onto their Start Menu.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allownoicons
AllowNoIcons = "Yes"



; Allow Installation on Root Directory
; - - - - - - - - - - - - - - - - - - -
; Allow the user with the ability to install the product's contents onto a system's root Filesystem.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowrootdirectory
AllowRootDirectory = "No"



; Allow Installation within a Network
; - - - - - - - - - - - - - - - - - -
; This allows or disallows the ability to install the product onto a server.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowuncpath
AllowUNCPath = "No"



; Always Restart
; - - - - - - - -
; After an installation was successful, the installer would then immediately prompt the user to restart the
;   computer.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysrestart
AlwaysRestart = "No"



; Always Show Components List
; - - - - - - - - - - - - - - -
; This can provide the ability for the user to select components that are available within the installer.
;   Such as the ability to nit-pick specific features or options that are accessible to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowcomponentslist
AlwaysShowComponentsList = "Yes"



; Always Show Install Directory on Ready Page
; - - - - - - - - - - - - - - - - - - - - - -
; Visually show the final installation directory to the user on the 'Ready to Install' page.  This can be
;   helpful if the user might had forgotten to customize the install path or if the install path is not
;   correct - for their prefferred preference.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowdironreadypage
AlwaysShowDirOnReadyPage = "Yes"



; Always Show Start Menu Directory on Ready Page
; - - - - - - - - - - - - - - - - - - - - - - - -
; Visually show the expected directory name of the Start Menu that the user will be able to find the
;   product's content shortcuts.  This is mainly for convienience such that the user will see where the
;   shortcuts can be accessible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowgrouponreadypage
AlwaysShowGroupOnReadyPage = "Yes"



; Always Use Personal Start Menu
; - - - - - - - - - - - - - - - -
; It is possible for the Installer to only provide Start Menu Shortcuts to either All Users or merely just
;   the current user's profile.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysusepersonalgroup
AlwaysUsePersonalGroup = "Yes"



; Append Default Directory Name
; - - - - - - - - - - - - - - -
; When set as 'yes', the Installer will automatically provide a parent directory in which the contents of the
;   product will be stored into folder.  Otherwise, the parent directory will be as the user provides.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appenddefaultdirname
AppendDefaultDirName = "Yes"



; Append Default Start Menu Directory Name
; - - - - - - - - - - - - - - - - - - - - -
; When set as 'yes', the Installer will automatically provide a parent directory within the Start Menu that
;   will hold the product's shortcuts, in which the shortcuts are linked to the files within the Install
;   directory.  Otherwise, the shortcuts will be tossed within the Start Menu's main root.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appenddefaultgroupname
AppendDefaultGroupName = "Yes"



; Architectures Allowed
; - - - - - - - - - - -
; Specifies which processor architecutre the installer is allowed to run on.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_architecturesallowed
ArchitecturesAllowed = ""



; Architectures Install in 64Bit Mode
; - - - - - - - - - - - - - - - - - -
; This will specify that the Installer is to run in 64bit Mode.  When using 64Bit mode, any legacy systems
;   that are using 32Bit mode - are unable to run the installer.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_architecturesinstallin64bitmode
ArchitecturesInstallIn64BitMode = ""



; Changes Association
; - - - - - - - - - -
; This will allow the ability for the Windows File Explorer to refresh its File Association information,
;   which will make the file icons update to the latest changes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_changesassociations
ChangesAssociations = "No"



; Changes Environment
; - - - - - - - - - -
; This will allow the ability for running applications and Windows File Explorer to refresh its environment
;   variables from the system's registry.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_changesenvironment
ChangesEnvironment = "No"



; Close Applications
; - - - - - - - - - -
; When set to 'yes', the Installer will pause right before the installation operation happens when it
;   detects that the application's files are still running or is in use.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_closeapplications
CloseApplications = "Yes"



; Close Application Filter
; - - - - - - - - - - - - -
; This will limit which files and Install-Delete entries Setup will check for what is currently being in use;
;   only files that are matching one of the wilecards will be checked.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_closeapplicationsfilter
CloseApplicationsFilter = "*.exe,*.dll,*.chm"



; Create Application Directory
; - - - - - - - - - - - - - - -
; This will allow the ability for the product to have its own install directory.  However, when it is
;   disallowed for the application to have its own install directory, then the application will be installed
;   within the Windows Directory.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_createappdir
CreateAppDir = "Yes"



; Create Uninstall Registry Key
; - - - - - - - - - - - - - - -
; This will allow the ability for the application to contain an uninstaller entry within the Add/Remove
;   Programs from the classical Control Panel.  However, when the uninstaller is not added onto the Registry,
;   then the uninstaller will not be listed within the Add/Remove Programs.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_createuninstallregkey
CreateUninstallRegKey = "Yes"



; Default Install Directory Name
; - - - - - - - - - - - - - - - -
; This will provide a default install location.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_defaultdirname
DefaultDirName = "{autopf}\{#_PRODUCT_NAME_FULL_}"



; Default Start Menu Directory Name
; - - - - - - - - - - - - - - - - -
; This will provide a default Start Menu directory.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_defaultgroupname
DefaultGroupName = "{#_PRODUCT_NAME_FULL_}"



; Directory Exists Warning
; - - - - - - - - - - - - -
; When the install directory already exists, then the user will be prompted that the directory is already
;   present.  This should alert the user that the directory already exists and my cause the files within that
;   directory to be altered.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_direxistswarning
DirExistsWarning = "Auto"



; Disable Directory Page
; - - - - - - - - - - - -
; When set to 'yes', the Installer will never ask the end-user where to install the product onto their
;   filesystem.  Thus, the destination path is already determined to be in a fixed path.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disabledirpage
DisableDirPage = "Auto"



; Disable Finished Page
; - - - - - - - - - - -
; When set to 'yes', the final page - that visually confirms that the operation was successful to the user -
;   will be ignored and close automatically once the operation had finished.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablefinishedpage
DisableFinishedPage = "No"



; Disable Start Menu Page
; - - - - - - - - - - - - - -
; When set to 'yes', the user will not be prompted regarding the wither the Start Menu shortcuts will be
;   created automatically.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disableprogramgrouppage
DisableProgramGroupPage = "Auto"



; Disable Ready Memo
; - - - - - - - - - -
; When this is set to 'yes', the user will not be shown information regarding what changes will take place.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablereadymemo
DisableReadyMemo = "No"



; Disable Ready Page
; - - - - - - - - - -
; When this is set to 'yes', the installer will not show the 'Ready to Install' page to the user.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablereadypage
DisableReadyPage = "No"



; Disable Startup Prompt
; - - - - - - - - - - - -
; When this is set to 'yes', the Installer will not show the "This will install $name.  Do you wish to
;   continue?" prompt to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablestartupprompt
DisableStartupPrompt = "No"



; Disable Welcome Page
; - - - - - - - - - - -
; When this setting is set to 'yes', then the Installer will not show the 'Welcome' page to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablewelcomepage
DisableWelcomePage = "No"



; Enable Directory Does not Exist Warning
; - - - - - - - - - - - - - - - - - - - -
; When this setting is set to 'yes', the Installer will warn the user that the desired directory does not yet
;   exist.  Normally, the user will select 'OK' or 'Continue' - in which the user will know that the
;   installer will automatically create the directories during the install operation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_enabledirdoesntexistwarning
EnableDirDoesntExistWarning = "Yes"



; Extra Disk Space Required
; - - - - - - - - - - - - -
; This will define how much more additional space is required on the host in order to install the product.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_extradiskspacerequired
ExtraDiskSpaceRequired = 1048576



; Information After File
; - - - - - - - - - - - -
; This will specify of a ReadMe file that will be shown to the user after the installation process.
;   The ReadMe file must be within the install directory, the ReadMe can be in either *.txt or *.rtf file
;   format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_infoafterfile
InfoAfterFile = ".\Installer\Product Assets\Text\Before_Install.txt"



; Information Before File
; - - - - - - - - - - - -
; This will specify of a ReadMe file that will be shown to the user before the installation process.
;   The ReadMe file must be within the package contents of the installer, the ReadMe can be in either
;   *.txt or *.rtf file format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_infobeforefile
InfoBeforeFile = ".\Installer\Product Assets\Text\Before_Install.txt"



; License File
; - - - - - - -
; This will specify of a License file that will be shown to the user, in which they must agree to before
;   continuing with the installation process.  The License must be within the package contents of the
;   installer, the License can be in either *.txt or *.rtf file format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_licensefile
LicenseFile = "LICENSE"



; Minimum Requirements
; - - - - - - - - - - -
; This will specify the minimum Windows Operating System requirements needed in order to install the
;   software.  Thus, it is possible to enforce a specific Windows Operating System that is required
;   for the initial software to operate correctly, but the Installer can be the forefront to avoid
;   complications with the software.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_minversion
MinVersion = "6.1sp1"



; Maximum Requirements
; - - - - - - - - - - -
; This will specify the maximum Windows Operating System requirements that is supported with the software.
;   Thus, it is possible to enforce only a specific version of the Windows Operating System that is
;   supported.  If a newer Windows Operating System is not specified - or not supported, then the installer
;   will refuse to install the software.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_onlybelowversion
OnlyBelowVersion = "0"



; Privileges Required
; - - - - - - - - - -
; When this is set to 'yes', the user will be prompted to run the Installer with Administrative Privileges.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_privilegesrequired
PrivilegesRequired = "lowest"



; Privileges Required Overrides Allowed
; - - - - - - - - - - - - - - - - - - -
; This can be used to set one or more overides which allows the end user to override the Privileges Required
;   configuration.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_privilegesrequiredoverridesallowed
PrivilegesRequiredOverridesAllowed = ""



; Restart Applications
; - - - - - - - - - - -
; When this value is set to 'yes' and the Close Applications is also set to 'yes', the Installer will attempt
;   restart the application after the installation process had completed.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_restartapplications
RestartApplications = "Yes"



; Restart if Needed by Run
; - - - - - - - - - - - - -
; When this had been set to 'yes', and a program executed in the [Run] section queues files to be replaced on
;   the next reboot (by calling MoveFileEx or by modifying wininit.ini), Setup will detect this and prompt
;   the user to restart the computer at the end of installation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_restartifneededbyrun
RestartIfNeededByRun = "Yes"



; Log Installation
; - - - - - - - - -
; When this set had been set to 'yes', the Installer will log its activities.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_setuplogging
SetupLogging = "Yes"



; Show Language Selection Dialog
; - - - - - - - - - - - - - - - -
; When this value is set to 'yes' and there exists multiple languages, then the user will be prompted to
;   select their preferred language before the Installer shows the Welcome page or the first page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_showlanguagedialog
ShowLanguageDialog = "Yes"



; Time Stamps in UTC
; - - - - - - - - - -
; All of the files date and time information that are included within the Installer will be updated based
;   on the customer's time and region specifications.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_timestampsinutc
TimeStampsInUTC = "Yes"



; Touch Date
; - - - - - -
; The date used in the time/date stamp of files referenced by [Files] section entries that include the touch
;   flag.  A value of current causes the current system date (at compile time) to be used. A value of none
;   leaves the date as-is. Otherwise, TouchDate is interpreted as an explicit date in YYYY-MM-DD (ISO 8601)
;   format. If TimeStampsInUTC is set to yes, the date is assumed to be a UTC date.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_touchdate
TouchDate = "Current"



; Touch Time
; - - - - - -
; The time used in the time/date stamp of files referenced by [Files] section entries that include the touch
;   flag.  A value of current causes the current system time (at compile time) to be used. A value of none
;   leaves the time as-is. Otherwise, TouchTime is interpreted as an explicit time in HH:MM or HH:MM:SS
;   format. If TimeStampsInUTC is set to yes, the time is assumed to be a UTC time.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_touchtime
TouchTime = "Current"



; Uninstallable
; - - - - - - -
; When set to 'yes', the Installer will create an Uninstaller - in which the user can be able to expunge the
;   application.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallable
Uninstallable = "Yes"



; Uninstall Display Name
; - - - - - - - - - - - -
; This lets you specify a custom name for the program's entry in the Add/Remove Programs Control Panel
;   applet.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalldisplayname
UninstallDisplayName = "{#_PRODUCT_NAME_FULL_}"



; Uninstall Files Directory
; - - - - - - - - - - - - -
; Specifies the directory where the "unins*.*" files for the uninstaller are stored.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallfilesdir
UninstallFilesDir = "{app}"



; Uninstall Log Mode
; - - - - - - - - - -
; This will configure how the uninstall operation will be logged within the system.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalllogmode
UninstallLogMode = "Append"



; Uninstall Restart Computer
; - - - - - - - - - - - - - -
; When set to yes, the uninstaller will always prompt the user to restart the system at the end of a
;   successful uninstallation, regardless of whether it is necessary (e.g., because of [Files] section
;   entries with the uninsrestartdelete flag).
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallrestartcomputer
UninstallRestartComputer = "No"



; Update Uninstall Log Application Name
; - - - - - - - - - - - - - - - - - - -
; If yes, when appending to an existing uninstall log, Setup will replace the AppName field in the log with
;   the current installation's AppName. The AppName field of the uninstall log determines the title displayed
;   in the uninstaller. You may want to set this to no if your installation is merely an upgrade or add-on to
;   an existing program, and you don't want the title of the uninstaller changed.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_updateuninstalllogappname
UpdateUninstallLogAppName = "Yes"



; Use Previous Start Menu
; - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the Start Menu folder name of the previous
;   installation as the default Start Menu folder name presented to the user in the wizard. Additionally, if
;   AllowNoIcons is set to yes, the Don't create a Start Menu folder setting from the previous installation
;   will be restored.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_usepreviousgroup
UsePreviousGroup = "Yes"



; Use Previous Language
; - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the language of the previous installation as the
;   default language presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_usepreviouslanguage
UsePreviousLanguage = "Yes"



; Use Previous Privileges
; - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed in one of the two install modes, and if so, it will use that install
;   mode and not ask the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_usepreviousprivileges
UsePreviousPrivileges = "Yes"



; Use Previous Setup Type
; - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the setup type and component settings of the
;   previous installation as the default settings presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioussetuptype
UsePreviousSetupType = "Yes"



; Use Previous Tasks
; - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the task settings of the previous installation
;   as the default settings presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioustasks
UsePreviousTasks = "Yes"



; Use Previous User Information
; - - - - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the name, organization and serial number entered
;   previously as the default settings presented to the user on the User Information wizard page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioususerinfo
UsePreviousUserInfo = "Yes"



; User Information Page
; - - - - - - - - - - -
; If this is set to yes, Setup will show a User Information wizard page which asks for the user's name,
;   organization and possibly a serial number. The values the user enters are stored in the {userinfoname},
;   {userinfoorg} and {userinfoserial} constants. You can use these constants in [Registry] or [INI] entries
;   to save their values for later use.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_userinfopage
UserInfoPage = "No"