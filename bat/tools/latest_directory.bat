
set "CHECK_THIS_DIRECTORY=%~1"
set "VARIABLE_NAME=%~2"

if "%VARIABLE_NAME%" == "" (set "VARIABLE_NAME=LATEST_DIRECTORY")
rem ============================================================================
rem ===== enum all directories =================================================

:lastDirectory
    for /D %%a  in ("%CHECK_THIS_DIRECTORY%\*") do (
        call set "%VARIABLE_NAME%=%%~a"
    )
exit /b

rem ============================================================================
rem ============================================================================

