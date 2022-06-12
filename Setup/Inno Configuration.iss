; https://jrsoftware.org/ishelp/index.php
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!



; Installer GUID
; - - - - - - - -
#define _GENERATED_UNIQUE_GUID_                 "{{02B00588-4477-4E98-AF59-E8825F957C03}"





; Product Information
; - - - - - - - - - - -
; Project Details
#include ".\Scripts\Project Information.iss"
;#define _PRODUCT_AUTHOR_                        "Nicholas Gautier"
;#define _PRODUCT_NAME_FULL_                     "PowerShell Compact-Archive Tool"
;#define _PRODUCT_NAME_SHORT_                    "PSCAT"
;#define _PRODUCT_VERSION_                       "1.1.0"
;#define _PRODUCT_VERSION_CODENAME_              "Cordis"
;#define _PRODUCT_VERSION_DATE_                  "2022.05.22"
;#define _PRODUCT_WEBSITE_HOMEPAGE_              "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool"
;#define _PRODUCT_WEBSITE_AUTHOR_                "https://tiger.rfc1337.net/"
;#define _PRODUCT_WEBSITE_SUPPORT_               "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki"
;#define _PRODUCT_WEBSITE_UPDATES_               "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/releases"
;#define _PRODUCT_README_FILE_                   "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/wiki"
;#define _PRODUCT_BRIEF_DESCRIPTION_             "Generates PK3\PK7 ZDoom Mods"
;#define _PRODUCT_COPYRIGHT_                     "2018-2022" + _PRODUCT_AUTHOR_





; Installer Metadata
; - - - - - - - - - - -
#include ".\Scripts\Global\Installer Metadata.iss"
;#define _INSTALLER_METADATA_VERSION_            "1.0.0.0"
;#define _INSTALLER_METADATA_COPYRIGHT_          _PRODUCT_VERSION_DATE_
;#define _INSTALLER_METADATA_DESCRIPTION_        _PRODUCT_NAME_FULL_ + " Installer"
;#define _INSTALLER_METADATA_PRODUCT_VERSION_    _PRODUCT_VERSION_ + " (" + _PRODUCT_VERSION_CODENAME_ + ") - " + _PRODUCT_VERSION_DATE_





; Directories and Files
; - - - - - - - - - - -
#include ".\Scripts\Global\Directories and Files.iss"
;#define _FILE_NAME_INSTALLER_                   _PRODUCT_NAME_SHORT_ + " v" + _PRODUCT_VERSION_ + " Installer"
;#define _FILE_NAME_MANIFEST_                    "Manifest" + " v" + _PRODUCT_VERSION_ + ".txt"
;#define _INSTALLER_OUTPUT_DIRECTORY_            "..\Installers\" + _PRODUCT_VERSION_ + "\"
;#define _PRODUCT_DEFAULT_STARTMENU_DIRECTORY_   _PRODUCT_NAME_FULL_






; Specialized Operations
; - - - - - - - - - - -
#include ".\Scripts\Debug\Testing.iss"
; Generate Installer
; ~ ~ ~ ~ ~ ~ ~ ~ ~
; This defines if we are wanting to generate an installer package or if we want to check this script for
;   errors without generating an executable file.
; NOTE: Regardless of this setting, the Output Directory will be cleaned.
;
; Values:
;   No  = Only check this script for errors, nothing is generated.
;   Yes = Generates an installer executable file.                   [Default]
;#define _SPECIAL_OPERATIONS_GENERATE_INSTALLER_ "Yes"











[Setup]
#include ".\Scripts\Application GUID.iss"
; #define _PRODUCT_DEFAULT_INSTALL_DIRECTORY_     "{autopf}\{#_PRODUCT_NAME_FULL_}"
;               Project Metadata               
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Project Metadata.iss"
; Application ID
; - - - - - - - -
; This provides a unique ID in which identifies this application.
;   NOTE: In order to generate a GUID: Click 'Tools' and then select 'Generate GUID' using the Inno Setup
;           IDE.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appid
;AppId={{02B00588-4477-4E98-AF59-E8825F957C03}


; Application Name
; - - - - - - - - -
; This will provide the name of the product.  This will be visible throughout the entire installation wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appname
;AppName = {#_PRODUCT_NAME_FULL_}


; Application Version Name
; - - - - - - - - - - - - -
; This will provide the name and version of the product.  This will be visible in the Add/Remove Programs
;   within the classical Control Panel and the Welcome Page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appvername
;AppVerName = {#_PRODUCT_NAME_FULL_} + " " + {#_PRODUCT_VERSION_} + " (" + _PRODUCT_VERSION_CODENAME_ + ")"


; Application Version
; - - - - - - - - - -
; This will specify the version of the application that is being installed.  Tis will be visible in the
;   Add/Remove Program within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appversion
;AppVersion = {#_PRODUCT_VERSION_}


; Application Comments
; - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcomments
;AppComments = {#_PRODUCT_BRIEF_DESCRIPTION_}


; Application Contact
; - - - - - - - - - -
; This will be displayed in the Add/Remove Porgrams within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcontact
;AppContact = {#_PRODUCT_WEBSITE_SUPPORT_}


; Application Publisher
; - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_apppublisher
;AppPublisher = {#_PRODUCT_AUTHOR_}


; Application Publisher Homepage
; - - - - - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_apppublisherurl
;AppPublisherURL = {#_PRODUCT_WEBSITE_AUTHOR_}


; Application Readme File
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appreadmefile
;AppReadmeFile = {#_PRODUCT_README_FILE_}


; Application Support URL
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appsupporturl
;AppSupportURL = {#_PRODUCT_WEBSITE_SUPPORT_}


; Application Updates URL
; - - - - - - - - - - - -
; This will be displayed in the Add/Remove Programs within the classical Control Panel.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appupdatesurl
;AppUpdatesURL = {#_PRODUCT_WEBSITE_UPDATES_}


; Application Copyright
; - - - - - - - - - - -
; This will be visible in the Installer's window or fullscreen.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appcopyright
;AppCopyright = "Copyright (C) " + {#_PRODUCT_COPYRIGHT_}







;              Installer Metadata
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Installer Metadata.iss"
; Company
; - - - -
; Name of the company or publisher regarding the project.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfocompany
;VersionInfoCompany = {#_PRODUCT_AUTHOR_}


; Copyright
; - - - - -
; This specifies the project's copyright information.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfocopyright
;VersionInfoCopyright = {#_INSTALLER_METADATA_COPYRIGHT_}


; Description
; - - - - - -
; This provides a brief description of the project.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfodescription
;VersionInfoDescription = {#_INSTALLER_METADATA_DESCRIPTION_}


; Original File Name
; - - - - - - - - - -
; This specifies the origitgnal file name for the setup.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfooriginalfilename
;VersionInfoOriginalFileName = {#_PRODUCT_NAME_SHORT_}


; Product Name
; - - - - - - -
; This will specify the product name.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproductname
;VersionInfoProductName = {#_PRODUCT_NAME_FULL_}


; Product Text Version
; - - - - - - - - - - -
; This will provide a textual product version
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproducttextversion
;VersionInfoProductTextVersion = {#_INSTALLER_METADATA_PRODUCT_VERSION_}


; Product Version
; - - - - - - - -
; This will provide a product version
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoproductversion
;VersionInfoProductVersion = {#_PRODUCT_VERSION_}


; Version
; - - - -
; This will provide a version of the installer
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_versioninfoversion
;VersionInfoVersion = {#_INSTALLER_METADATA_VERSION_}







;        Compiler Related Configurations
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Compiler Configuration.iss"
; Internal Compression Level
; - - - - - - - - - - - - - -
; This defines the compression level that will be used for Inno's internal structure.  Ideally, there's no
;   real need to configure this - other than to maybe save a few kilobytes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_internalcompresslevel
;InternalCompressLevel = normal


; Compression Algorithm and Compression Level
; - - - - - -
; This will define the compression type and compression level that will be using when compacting the
;   software's assets into the installation package.  We will use LZMA\2 with the best possible compression
;   possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compression
;Compression = lzma2/ultra64


; Solid Compression
; - - - - - - - - -
; Compact the files in such a way that it benefits the overall compression ratio within the installer
;   package.  In doing so, data contents that are a like, will be combined instead of containing duplicated
;   data.  Decompressing, however, in Real-Time will be hindered.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_solidcompression
;SolidCompression = yes


; LZMA Algorithm
; - - - - - - - -
; This controls the algorithm that will be used for LZMA\2 Compressor.  Use the normal algorithm to benefit
;   overall compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmaalgorithm
;LZMAAlgorithm = 1


; LZMA Use Separate Process
; - - - - - - - - - - - - -
; Allow the ability for the LZMA\2 Compressor to use its own system resources, instead of being tied down
;   to Inno's process.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmauseseparateprocess
;LZMAUseSeparateProcess = yes


; LZMA Match Finder
; - - - - - - - - -
; Determine the Match Finder method that will be used with the LZMA\2 Compressor.  Using Binary Tree will
;   give use additional increase in compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmamatchfinder
;LZMAMatchFinder = BT


; Compression Threads
; - - - - - - - - - -
; Determines if the LZMA\2 Compressor will utilize the host's one or multiple CPU virtual threads, if
;   available.  Using 'auto' will allow the Compressor to automatically determine the threads it will need
;   in order successfully compact the data efficiently.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compressionthreads
;CompressionThreads = auto


; Merge Duplicate Files
; - - - - - - - - - - -
; If incase there exists multiple duplicate files, then we can be able to ignore all other duplicate sources
;   but only use the first instance instance.  By doing this, we minimize the need to store every duplicate
;   file - thus reducing the overall package size.  Moreover, the output that requires the duplicated data
;   to exist, will still be provided as intended.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_mergeduplicatefiles
;MergeDuplicateFiles = yes







;           Output Configuration
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Output Configuration.iss"
; Output Base File Name
; - - - - - - - - - - -
; This provides the setup filename in the output result.  This essentially is our final compiled build that
;   the user will install.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputbasefilename
;OutputBaseFilename = {#_FILE_NAME_INSTALLER_}


; Output Directory
; - - - - - - - - -
; This will specify the location in which the setup file will be stored once the Inno Builder had
;   successfully compiled, or generated, the installer file(s).
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputdir
;OutputDir = {#_INSTALLER_OUTPUT_DIRECTORY_}


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
;OutputManifestFile = {#_FILE_NAME_MANIFEST_}







;                 Source Directory
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Source Directory.iss"
; Source Directory
; - - - - - - - - -
; This will specify the location as to where the files are generally located or a common-location.  With this
;   set, this changes all or most of the Output Directories and individual source file locations.  With that
;   said, the relative path depends upon this variable.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_sourcedir
;SourceDir = "..\"







;              Test and Debugging
; =============================================
; =============================================
; ---------------------------------------------

; Create Installer Package
; - - - - - - - - - - - - -
; This specifies if we are wanting to generate an installer package or to merely test the script for errors.
;   However, regardless of this setting, Inno will still perform a cleanup operation within the OutputDir.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_output
;Output = {#_SPECIAL_OPERATIONS_GENERATE_INSTALLER_}







;               Installer Related
; =============================================
; =============================================
; ---------------------------------------------
#include ".\Scripts\Setup\Wizard Configuration.iss"
; Allow Cancel During Install
; - - - - - - - - - - - - - -
; This allows the ability for the end-user to abort the on-going installation operation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowcancelduringinstall
;AllowCancelDuringInstall= No


; Allow Installation on a Network Drive
; - - - - - - - - - - - - - - - - - - -
; This allows or disallows the ability to install the product onto a Network Shared Drive.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allownetworkdrive
;AllowNetworkDrive = No


; Allow Start Menu Icons
; - - - - - - - - - - - -
; Allow the ability for the end-user to add shortcuts or not to add shortcuts onto their Start Menu.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allownoicons
;AllowNoIcons = yes


; Allow Installation on Root Directory
; - - - - - - - - - - - - - - - - - - -
; Allow the user with the ability to install the product's contents onto a system's root Filesystem.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowrootdirectory
;AllowRootDirectory = no


; Allow Installation within a Network
; - - - - - - - - - - - - - - - - - -
; This allows or disallows the ability to install the product onto a server.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_allowuncpath
;AllowUNCPath = no


; Always Restart
; - - - - - - - -
; After an installation was successful, the installer would then immediately prompt the user to restart the
;   computer.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysrestart
;AlwaysRestart = no


; Always Show Components List
; - - - - - - - - - - - - - - -
; This can provide the ability for the user to select components that are available within the installer.
;   Such as the ability to nit-pick specific features or options that are accessible to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowcomponentslist
;AlwaysShowComponentsList = yes


; Always Show Install Directory on Ready Page
; - - - - - - - - - - - - - - - - - - - - - -
; Visually show the final installation directory to the user on the 'Ready to Install' page.  This can be
;   helpful if the user might had forgotten to customize the install path or if the install path is not
;   correct - for their prefferred preference.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowdironreadypage
;AlwaysShowDirOnReadyPage = yes


; Always Show Start Menu Directory on Ready Page
; - - - - - - - - - - - - - - - - - - - - - - - -
; Visually show the expected directory name of the Start Menu that the user will be able to find the
;   product's content shortcuts.  This is mainly for convienience such that the user will see where the
;   shortcuts can be accessible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysshowgrouponreadypage
;AlwaysShowGroupOnReadyPage = yes


; Always Use Personal Start Menu
; - - - - - - - - - - - - - - - -
; It is possible for the Installer to only provide Start Menu Shortcuts to either All Users or merely just
;   the current user's profile.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_alwaysusepersonalgroup
;AlwaysUsePersonalGroup = yes


; Append Default Directory Name
; - - - - - - - - - - - - - - -
; When set as 'yes', the Installer will automatically provide a parent directory in which the contents of the
;   product will be stored into folder.  Otherwise, the parent directory will be as the user provides.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appenddefaultdirname
;AppendDefaultDirName = yes


; Append Default Start Menu Directory Name
; - - - - - - - - - - - - - - - - - - - - -
; When set as 'yes', the Installer will automatically provide a parent directory within the Start Menu that
;   will hold the product's shortcuts, in which the shortcuts are linked to the files within the Install
;   directory.  Otherwise, the shortcuts will be tossed within the Start Menu's main root.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_appenddefaultgroupname
;AppendDefaultGroupName = yes


; Architectures Allowed
; - - - - - - - - - - -
; Specifies which processor architecutre the installer is allowed to run on.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_architecturesallowed
;ArchitecturesAllowed =


; Architectures Install in 64Bit Mode
; - - - - - - - - - - - - - - - - - -
; This will specify that the Installer is to run in 64bit Mode.  When using 64Bit mode, any legacy systems
;   that are using 32Bit mode - are unable to run the installer.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_architecturesinstallin64bitmode
;ArchitecturesInstallIn64BitMode =


; Changes Association
; - - - - - - - - - -
; This will allow the ability for the Windows File Explorer to refresh its File Association information,
;   which will make the file icons update to the latest changes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_changesassociations
;ChangesAssociations= no


; Changes Environment
; - - - - - - - - - -
; This will allow the ability for running applications and Windows File Explorer to refresh its environment
;   variables from the system's registry.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_changesenvironment
;ChangesEnvironment = no


; Close Applications
; - - - - - - - - - -
; When set to 'yes', the Installer will pause right before the installation operation happens when it
;   detects that the application's files are still running or is in use.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_closeapplications
;CloseApplications = yes


; Close Application Filter
; - - - - - - - - - - - - -
; This will limit which files and Install-Delete entries Setup will check for what is currently being in use;
;   only files that are matching one of the wilecards will be checked.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_closeapplicationsfilter
;CloseApplicationsFilter=*.exe,*.dll,*.chm


; Create Application Directory
; - - - - - - - - - - - - - - -
; This will allow the ability for the product to have its own install directory.  However, when it is
;   disallowed for the application to have its own install directory, then the application will be installed
;   within the Windows Directory.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_createappdir
;CreateAppDir = yes


; Create Uninstall Registry Key
; - - - - - - - - - - - - - - -
; This will allow the ability for the application to contain an uninstaller entry within the Add/Remove
;   Programs from the classical Control Panel.  However, when the uninstaller is not added onto the Registry,
;   then the uninstaller will not be listed within the Add/Remove Programs.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_createuninstallregkey
;CreateUninstallRegKey = yes


; Default Install Directory Name
; - - - - - - - - - - - - - - - -
; This will provide a default install location.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_defaultdirname
;DefaultDirName = {autopf}\{#_PRODUCT_NAME_FULL_}


; Default Start Menu Directory Name
; - - - - - - - - - - - - - - - - -
; This will provide a default Start Menu directory.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_defaultgroupname
;DefaultGroupName = {#_PRODUCT_DEFAULT_STARTMENU_DIRECTORY_}


; Directory Exists Warning
; - - - - - - - - - - - - -
; When the install directory already exists, then the user will be prompted that the directory is already
;   present.  This should alert the user that the directory already exists and my cause the files within that
;   directory to be altered.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_direxistswarning
;DirExistsWarning = auto


; Disable Directory Page
; - - - - - - - - - - - -
; When set to 'yes', the Installer will never ask the end-user where to install the product onto their
;   filesystem.  Thus, the destination path is already determined to be in a fixed path.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disabledirpage
;DisableDirPage = auto


; Disable Finished Page
; - - - - - - - - - - -
; When set to 'yes', the final page - that visually confirms that the operation was successful to the user -
;   will be ignored and close automatically once the operation had finished.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablefinishedpage
;DisableFinishedPage = no


; Disable Start Menu Page
; - - - - - - - - - - - - - -
; When set to 'yes', the user will not be prompted regarding the wither the Start Menu shortcuts will be
;   created automatically.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disableprogramgrouppage
;DisableProgramGroupPage = auto


; Disable Ready Memo
; - - - - - - - - - -
; When this is set to 'yes', the user will not be shown information regarding what changes will take place.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablereadymemo
;DisableReadyMemo = no


; Disable Ready Page
; - - - - - - - - - -
; When this is set to 'yes', the installer will not show the 'Ready to Install' page to the user.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablereadypage
;DisableReadyPage = no


; Disable Startup Prompt
; - - - - - - - - - - - -
; When this is set to 'yes', the Installer will not show the "This will install $name.  Do you wish to
;   continue?" prompt to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablestartupprompt
;DisableStartupPrompt= no


; Disable Welcome Page
; - - - - - - - - - - -
; When this setting is set to 'yes', then the Installer will not show the 'Welcome' page to the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_disablewelcomepage
;DisableWelcomePage = no


; Enable Directory Does not Exist Warning
; - - - - - - - - - - - - - - - - - - - -
; When this setting is set to 'yes', the Installer will warn the user that the desired directory does not yet
;   exist.  Normally, the user will select 'OK' or 'Continue' - in which the user will know that the
;   installer will automatically create the directories during the install operation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_enabledirdoesntexistwarning
;EnableDirDoesntExistWarning = yes


; Extra Disk Space Required
; - - - - - - - - - - - - -
; This will define how much more additional space is required on the host in order to install the product.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_extradiskspacerequired
;ExtraDiskSpaceRequired = 1048576


; Information After File
; - - - - - - - - - - - -
; This will specify of a ReadMe file that will be shown to the user after the installation process.
;   The ReadMe file must be within the install directory, the ReadMe can be in either *.txt or *.rtf file
;   format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_infoafterfile
;InfoAfterFile = LICENSE


; Information Before File
; - - - - - - - - - - - -
; This will specify of a ReadMe file that will be shown to the user before the installation process.
;   The ReadMe file must be within the package contents of the installer, the ReadMe can be in either
;   *.txt or *.rtf file format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_infobeforefile
;InfoBeforeFile = LICENSE


; License File
; - - - - - - -
; This will specify of a License file that will be shown to the user, in which they must agree to before
;   continuing with the installation process.  The License must be within the package contents of the
;   installer, the License can be in either *.txt or *.rtf file format.  Websites are NOT possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_licensefile
;LicenseFile = LICENSE


; Minimum Requirements
; - - - - - - - - - - -
; This will specify the minimum Windows Operating System requirements needed in order to install the
;   software.  Thus, it is possible to enforce a specific Windows Operating System that is required
;   for the initial software to operate correctly, but the Installer can be the forefront to avoid
;   complications with the software.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_minversion
;MinVersion = 6.1sp1


; Maximum Requirements
; - - - - - - - - - - -
; This will specify the maximum Windows Operating System requirements that is supported with the software.
;   Thus, it is possible to enforce only a specific version of the Windows Operating System that is
;   supported.  If a newer Windows Operating System is not specified - or not supported, then the installer
;   will refuse to install the software.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_onlybelowversion
;OnlyBelowVersion = 0


; Privileges Required
; - - - - - - - - - -
; When this is set to 'yes', the user will be prompted to run the Installer with Administrative Privileges.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_privilegesrequired
;PrivilegesRequired = admin


; Privileges Required Overrides Allowed
; - - - - - - - - - - - - - - - - - - -
; This can be used to set one or more overides which allows the end user to override the Privileges Required
;   configuration.
;
; Resources:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_privilegesrequiredoverridesallowed
;PrivilegesRequiredOverridesAllowed = dialog


; Restart Applications
; - - - - - - - - - - -
; When this value is set to 'yes' and the Close Applications is also set to 'yes', the Installer will attempt
;   restart the application after the installation process had completed.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_restartapplications
;RestartApplications = yes


; Restart if Needed by Run
; - - - - - - - - - - - - -
; When this had been set to 'yes', and a program executed in the [Run] section queues files to be replaced on
;   the next reboot (by calling MoveFileEx or by modifying wininit.ini), Setup will detect this and prompt
;   the user to restart the computer at the end of installation.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_restartifneededbyrun
;RestartIfNeededByRun = yes


; Log Installation
; - - - - - - - - -
; When this set had been set to 'yes', the Installer will log its activities.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_setuplogging
;SetupLogging = yes


; Show Language Selection Dialog
; - - - - - - - - - - - - - - - -
; When this value is set to 'yes' and there exists multiple languages, then the user will be prompted to
;   select their preferred language before the Installer shows the Welcome page or the first page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_showlanguagedialog
;ShowLanguageDialog = yes


; Time Stamps in UTC
; - - - - - - - - - -
; All of the files date and time information that are included within the Installer will be updated based
;   on the customer's time and region specifications.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_timestampsinutc
;TimeStampsInUTC = yes


; Touch Date
; - - - - - -
; The date used in the time/date stamp of files referenced by [Files] section entries that include the touch
;   flag.  A value of current causes the current system date (at compile time) to be used. A value of none
;   leaves the date as-is. Otherwise, TouchDate is interpreted as an explicit date in YYYY-MM-DD (ISO 8601)
;   format. If TimeStampsInUTC is set to yes, the date is assumed to be a UTC date.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_touchdate
;TouchDate = current


; Touch Time
; - - - - - -
; The time used in the time/date stamp of files referenced by [Files] section entries that include the touch
;   flag.  A value of current causes the current system time (at compile time) to be used. A value of none
;   leaves the time as-is. Otherwise, TouchTime is interpreted as an explicit time in HH:MM or HH:MM:SS
;   format. If TimeStampsInUTC is set to yes, the time is assumed to be a UTC time.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_touchtime
;TouchTime = current


; Uninstallable
; - - - - - - -
; When set to 'yes', the Installer will create an Uninstaller - in which the user can be able to expunge the
;   application.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallable
;Uninstallable = yes


; Uninstall Display Icon
; - - - - - - - - - - - -
; This lets you specify a particular icon file (either an executable or an .ico file) to display for the
;   Uninstall entry in the Add/Remove Programs Control Panel applet. The filename will normally begin with
;   a directory constant.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalldisplayicon
;UninstallDisplayIcon = {app}\image.png


; Uninstall Display Name
; - - - - - - - - - - - -
; This lets you specify a custom name for the program's entry in the Add/Remove Programs Control Panel
;   applet.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalldisplayname
;UninstallDisplayName = {#_PRODUCT_NAME_FULL_}


; Uninstall Files Directory
; - - - - - - - - - - - - -
; Specifies the directory where the "unins*.*" files for the uninstaller are stored.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallfilesdir
;UninstallFilesDir = {app}


; Uninstall Log Mode
; - - - - - - - - - -
; This will configure how the uninstall operation will be logged within the system.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstalllogmode
;UninstallLogMode = append


; Uninstall Restart Computer
; - - - - - - - - - - - - - -
; When set to yes, the uninstaller will always prompt the user to restart the system at the end of a
;   successful uninstallation, regardless of whether it is necessary (e.g., because of [Files] section
;   entries with the uninsrestartdelete flag).
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_uninstallrestartcomputer
;UninstallRestartComputer = no


; Update Uninstall Log Application Name
; - - - - - - - - - - - - - - - - - - -
; If yes, when appending to an existing uninstall log, Setup will replace the AppName field in the log with
;   the current installation's AppName. The AppName field of the uninstall log determines the title displayed
;   in the uninstaller. You may want to set this to no if your installation is merely an upgrade or add-on to
;   an existing program, and you don't want the title of the uninstaller changed.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_updateuninstalllogappname
;UpdateUninstallLogAppName = yes


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
;UsePreviousGroup = yes


; Use Previous Language
; - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the language of the previous installation as the
;   default language presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_usepreviouslanguage
;UsePreviousLanguage = yes


; Use Previous Privileges
; - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed in one of the two install modes, and if so, it will use that install
;   mode and not ask the user.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_usepreviousprivileges
;UsePreviousPrivileges = yes


; Use Previous Setup Type
; - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the setup type and component settings of the
;   previous installation as the default settings presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioussetuptype
;UsePreviousSetupType = yes


; Use Previous Tasks
; - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the task settings of the previous installation
;   as the default settings presented to the user in the wizard.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioustasks
;UsePreviousTasks = yes


; Use Previous User Information
; - - - - - - - - - - - - - - -
; When this directive is yes, the default, at startup Setup will look in the registry to see if the same
;   application is already installed, and if so, it will use the name, organization and serial number entered
;   previously as the default settings presented to the user on the User Information wizard page.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_useprevioususerinfo
;UsePreviousUserInfo = yes


; User Information Page
; - - - - - - - - - - -
; If this is set to yes, Setup will show a User Information wizard page which asks for the user's name,
;   organization and possibly a serial number. The values the user enters are stored in the {userinfoname},
;   {userinfoorg} and {userinfoserial} constants. You can use these constants in [Registry] or [INI] entries
;   to save their values for later use.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_userinfopage
;UserInfoPage = no






WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "Compile\PSCAT.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Scripts\Program Modes\Clean.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Scripts\Program Modes\Uninstall.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Setup\Resources\Web\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#_PRODUCT_NAME_FULL_}}"; Filename: "{#_PRODUCT_WEBSITE_HOMEPAGE_}"
Name: "{group}\{cm:UninstallProgram,{#_PRODUCT_NAME_FULL_}}"; Filename: "{uninstallexe}"

