@ECHO OFF


REM I specifically made this script as I don't actively stay ontop with Git's functionality with Pull Request.
REM  So, to help me make Pull Request updates seamlessly, this script comes into play!
REM NOTE: With this script, I do not care about error cases.  I just want this to work with absolutely minimum development cost.

GOTO :Main


:Main
git.exe fetch origin master&
git.exe merge origin/master&

REM Just return the last git's exit code, regardless whatever the first git provided.
EXIT %ERRORLEVEL%