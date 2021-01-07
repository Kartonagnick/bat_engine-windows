@echo off & cls & @echo. & @echo.

rem инвалид

set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."

call :normalizePath ePATH_BAT_SCRIPTS ^
    "%ePATH_BAT_SCRIPTS%"

set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
call "%~dp0settings_test-PC_test.bat"
rem ============================================================================
rem ============================================================================

call "%~dp0..\request.bat" ^
    "eCONFIGURATIONS" "mingw810:64:debug:dynamicA"
if errorlevel 1 (@echo [SUCCESS] & exit /b 0)

@echo [FAILED]
exit /b 0

rem ............................................................................

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b
