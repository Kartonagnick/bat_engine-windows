@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

call :normalizePath ePATH_COMPONENT D:\trtert\..\aaa\bbb\..\rtertre run\\
call :expected "D:\aaa\rtertre run"

call :normalizePath ePATH_COMPONENT "D:\trtert\..\aaa\bbb\..\rtertre run\\"
call :expected "D:\aaa\rtertre run"

call :normalizePath ePATH_COMPONENT hello wold\ololo\..\
call :expected "hello wold"

call :normalizePath ePATH_COMPONENT ?:\hello wold\ololo\..\
call :expected "hello wold"

set src="D:\trtert\..\aaa\bbb\..\rtertre run\\"
call :normalizePath ePATH_COMPONENT %src%
call :expected "D:\aaa\rtertre run"

call :normalizePath ePATH_COMPONENT "%src%"
call :expected "D:\aaa\rtertre run"

@echo [ALL TEST PASSED]
@echo [SUCCESS]

exit /b

call :normalizePath ePATH_COMPONENT  "D:\trtert\..\aaa\bbb\..\rtertre run\\"
@echo [ePATH_COMPONENT] '%ePATH_COMPONENT%'

call :normalizePath ePATH_COMPONENT  hello wold\ololo\..\
@echo [ePATH_COMPONENT] '%ePATH_COMPONENT%'

call :normalizePath ePATH_COMPONENT  ?:\hello wold\ololo\..\
@echo [ePATH_COMPONENT] '%ePATH_COMPONENT%'

exit /b 

:expected
    if errorlevel 1 (
        @echo [FAILED] 
        @echo   'normalizePath' was failed
        exit
    )

    set "expected=%~1"
    if not "%expected%" == "%ePATH_COMPONENT%" (
        @echo [FAILED]
        @echo   expected: %expected%
        @echo   result: %ePATH_COMPONENT%
        exit
    )
exit /b 0

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
        endlocal & set "%~1="
        exit /b 1
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        endlocal & set "%~1="
        exit /b 0
    )
    for /F "tokens=*" %%a in ("%VARIABLE_VALUE%") do (
        set "VARIABLE_VALUE=%%~a"
    )
    call :normalizePathImpl "?:\%VARIABLE_VALUE%"
    endlocal & set "%~1=%RETVAL%"
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
