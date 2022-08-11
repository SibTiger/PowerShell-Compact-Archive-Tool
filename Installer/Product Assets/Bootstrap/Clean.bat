@REM Do not output each statement into the terminal output buffer.
@ECHO OFF


REM All environment changes from here-on-out will be locked within this shellscript.
SETLOCAL


REM Obtain the current location of this shellscript.
SET "selfPath=%~dp0"


REM Launch the Bootstrap program
CALL :Main


REM Relieve the localization environment.
ENDLOCAL


REM When we finish with the Main method, then terminate the program as we are finished.
EXIT /B %ERRORLEVEL%





REM # ============================================
REM # ============================================
REM # ============================================





REM # Main
REM # ============================================
REM # Documentation:
REM #   This is the main section of the shellscript, such that it helps to access the Bootstrap Loader program.
REM # --------------------------------------------
REM # Return:
REM #   [Integer] Exit Code
REM #       0 = Operation was Successful
REM #       1 = Unable to find PowerShell Core
REM #       2 = Unable to find PSCAT
REM #       3 = Unable to find Bootstrap Loader
REM # ============================================
:Main

REM Setup the variables that we will be using within this program.
CALL :Initialization


REM Try to find the main Bootstrap Loader shellscript.
CALL :FindBootstrapLoader


REM Where we able to find the Bootstrap Loader shellscript?
IF %ERRORLEVEL% EQU 0 (
    REM Alert the user that we could not find the shellscript.
    CALL :UnableFindBootstrapLoader

    REM Terminate this program with an error.
    EXIT /B 3
)


REM Launch the Bootstrap Loader
CALL :LaunchBootstrap


REM Finished!
EXIT /B 0
REM # ============================================





REM # Initializations
REM # ============================================
REM # Documentation:
REM #   Setup the variables that we are will be using within this program.
REM # ============================================
:Initialization

REM Bootstrap Loader
SET "BootstrapNiceName=Bootstrap Loader"
SET "BootstrapFileName=Bootstrap Loader.bat"
SET "BootstrapFilePath=%selfPath%\%BootstrapFileName%"


REM Text Formatting
SET "Tabulation=    "


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





REM # Unable to Find Bootstrap Loader
REM # ============================================
REM # Documentation:
REM #   Alert the user that we could not find the Bootstrap Loader.
REM # ============================================
:UnableFindBootstrapLoader

REM Alert the user that an error had occurred.
CALL :Bell


REM Show the error message
ECHO.
ECHO.
ECHO %Tabulation% %Tabulation% %Tabulation% %Tabulation% ^<!^> CANNOT LOCATE BOOTSTRAP LOADER ^<!^>
ECHO %Tabulation% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO.
ECHO %Tabulation% It seems that I could not find the Bootstrap Loader program!
ECHO %Tabulation% It could be a symptom of a corrupted installation in your system.
ECHO.
ECHO %Tabulation% You may try to reinstalling the latest version of PowerShell Compact-Archive Tool from the official site:
ECHO %Tabulation% %Tabulation% https://github.com/SibTiger/PowerShell-Compact-Archive-Tool/releases/latest
ECHO.
ECHO.


REM Allow the user to view the message shown in the terminal buffer
PAUSE


REM Finished
GOTO :EOF
REM # ============================================





REM # Check Bootstrap Loader Path
REM # ============================================
REM # Documentation:
REM #   Try to find the Bootstrap Loader shellscript.
REM # ============================================
:FindBootstrapLoader

IF EXIST "%BootstrapFilePath%" (
    REM Found the Bootstrap Loader
    EXIT /B 1
)


REM Unable to find the Bootstrap Loader
EXIT /B 0
REM # ============================================





REM # Launch the Bootstrap Loader Shellscript
REM # ============================================
REM # Documentation:
REM #   Launch the Bootstrap Loader as it will properly execute the PowerShell Compact-Archive Tool.
REM # ============================================
:LaunchBootstrap
START "Run %BootstrapFileName%. . ." /D "%selfPath%" /NORMAL "%BootstrapFilePath%" 1
REM # ============================================