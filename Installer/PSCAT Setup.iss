;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                |_|
;   ____                    __   _                                  _     _                     ____           _
;  / ___|   ___    _ __    / _| (_)   __ _   _   _   _ __    __ _  | |_  (_)   ___    _ __     |  _ \   _ __  (_) __   __   ___   _ __
; | |      / _ \  | '_ \  | |_  | |  / _` | | | | | | '__|  / _` | | __| | |  / _ \  | '_ \    | | | | | '__| | | \ \ / /  / _ \ | '__|
; | |___  | (_) | | | | | |  _| | | | (_| | | |_| | | |    | (_| | | |_  | | | (_) | | | | |   | |_| | | |    | |  \ V /  |  __/ | |
;  \____|  \___/  |_| |_| |_|   |_|  \__, |  \__,_| |_|     \__,_|  \__| |_|  \___/  |_| |_|   |____/  |_|    |_|   \_/    \___| |_|
;                                    |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier






; Debugger Tools
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Generate Project Installer
#include ".\Scripts\Debug\Generate Compiler.iss"

; Log results to the Inno Terminal
;   AND
; Log results to a Logfile in %TEMP%
#include ".\Scripts\Debug\Logging.iss"






; Global Definitions
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Project Information
#include ".\Scripts\Project Information.iss"

; Project Metadata
#include ".\Scripts\Metadata\Project Metadata.iss"

; Installer Metadata
#include ".\Scripts\Metadata\Installer Metadata.iss"






; Installer Behavior
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Application Identifier (GUID)
#include ".\Scripts\Application GUID.iss"

; Source Directory
#include ".\Scripts\Setup\Source Directory.iss"

; Compression
#include ".\Scripts\Setup\Compression.iss"

; File Management
#include ".\Scripts\Setup\File Management.iss"

; Installer Output
#include ".\Scripts\Setup\Output.iss"

; Wizard Behavior
#include ".\Scripts\Setup\Wizard.iss"






; Wizard Interface
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Wizard Style
#include ".\Scripts\Interface\Wizard Style.iss"

; Wizard Interface
#include ".\Scripts\Interface\Wizard Interface.iss"

; Graphics
#include ".\Scripts\Interface\Wizard Graphics.iss"






; Languages
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; English - United States
#include ".\Scripts\Language\English.iss"






; Installation Files and Directories
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Files
#include ".\Scripts\Installation Files\Files.iss"

; Directories
#include ".\Scripts\Installation Files\Directories.iss"

; Start Menu
#include ".\Scripts\Installation Files\Start Menu.iss"






; Additional Tasks and Operations
; ----------------------------------------------------------
; ==========================================================
; ----------------------------------------------------------

; Ask user to Create Desktop Shortcut
#include ".\Scripts\Tasks\Desktop Shortcut.iss"

; Check for PowerShell Core Dependency
#include ".\Scripts\Tasks\Check POSHCore.iss"