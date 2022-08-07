@ECHO OFF


REM All environment changes from here-on-out will be locked within this shellscript.
SETLOCAL


REM Launch the Bootstrap program
CALL :Main %1


REM When we finish with the Main method, then terminate the program as we are finished.
EXIT /B %ERRORLEVEL%





REM # ============================================
REM # ============================================
REM # ============================================





REM # Main
REM # ============================================
REM # Documentation:
REM #   This is the main section of the shellscript, such that it helps to drive how the program will operate.
REM # --------------------------------------------
REM # Parameters:
REM #   [Integer] PSCAT Program Mode
REM #       0 or Greater
REM # --------------------------------------------
REM # Return:
REM #   [Integer] Exit Code
REM #       0 = Operation was Successful
REM #       1 = Unable to find PowerShell Core
REM # ============================================
:Main

REM Setup the variables that we will be using within this program.
CALL :Initialization


REM Update the Window Title
CALL :UpdateWindowTitle


REM Try to find an installation of PowerShell Core
CALL :FindPowerShell


REM Were we unable to find POSHCore?
IF %ERRORLEVEL% EQU 0 (
    REM Alert the user that something went horribly wrong.
    CALL :UnableFindPowerShell

    REM Terminate this program with an error.
    EXIT /B 1
)


REM Finished
EXIT /B 0
REM # ============================================





REM # Initializations
REM # ============================================
REM # Documentation:
REM #   Setup the variables that we are will be using within this program.
REM # ============================================
:Initialization

REM Target Application that we want to launch
SET "TargetNiceName=PowerShell Compact-Archive Tool"
SET "TargetFileName=PSCAT.ps1"


REM Bootstrap Program Meta-Data
SET "ProgramName=%TargetNiceName% Bootstrap"
SET "ProgramVersion=1.0.0"


REM PowerShell Core
SET "PowerShellPath=NULL"
SET "PowerShellExec=NULL"


REM Title
SET "WindowTitle=%ProgramName% ^(Version: %ProgramVersion%^)"


REM Finished
GOTO :EOF
REM # ============================================





REM # Audible Bell
REM # ============================================
REM # Documentation:
REM #   Alert the user by using a special BELL ASCII Character.
REM # ============================================
:Bell
ECHO 
GOTO :EOF
REM # ============================================





REM # Update Window Title
REM # ============================================
REM # Documentation:
REM #   Update the title of the terminal window.
REM # ============================================
:UpdateWindowTitle
TITLE %WindowTitle%
GOTO :EOF
REM # ============================================





REM # Find PowerShell Core
REM # ============================================
REM # Documentation:
REM #   Try to find the installation of the PowerShell Core within
REM #       the host system's filesystem.
REM # ============================================
:FindPowerShell
EXIT /B 0
REM # ============================================





REM # Unable to Find PowerShell Core
REM # ============================================
REM # Documentation:
REM #   Alert the user that we could not find the PowerShell Core.
REM # ============================================
:UnableFindPowerShell

REM Alert the user that an error had occurred.
CALL :Bell


REM Show the error message
ECHO.
ECHO.
ECHO ^<!^> CANNOT LOCATE POWERSHELL CORE ^<!^>
ECHO - - - - - - - - - - - - - - - - - - - - - -
ECHO.
ECHO It seems that I could not find an installation of the PowerShell Core!
ECHO Please be sure that you had already installed the PowerShell Core on your system.
ECHO.
ECHO You may download the latest version of PowerShell Core using the official site:
ECHO https://github.com/PowerShell/PowerShell/releases/latest
ECHO.
ECHO.


REM Finished
GOTO :EOF
REM # ============================================