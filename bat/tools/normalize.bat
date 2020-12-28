
@echo off
rem ============================================================================
rem ============================================================================

:normalizePath
    setlocal
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%~a"
        set "VARIABLE_VALUE=%%~b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        endlocal 
        exit /b 1
    )
    if not defined VARIABLE_VALUE (
        endlocal & set "%~1="
        exit /b 0
    )
    call :normalizePathSafe %VARIABLE_VALUE%
    endlocal & set "%VARIABLE_NAME%=%RETVAL%"
exit /b 0

:normalizePathSafe
    for /F "tokens=*" %%a in ("%*") do (
        set "VARIABLE_VALUE=%%~a"
    )
    call :normalizePathImpl "?:\%VARIABLE_VALUE%"
exit /b

:normalizePathImpl
    set "RETVAL=%~f1"
    set "RETVAL=%RETVAL:?:\=%"
:removeEndedSlash
    set "last=%RETVAL:~-1%"

    if "%last%" == "\" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
    if "%last%" == "/" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
exit /b

rem ============================================================================
rem ============================================================================
