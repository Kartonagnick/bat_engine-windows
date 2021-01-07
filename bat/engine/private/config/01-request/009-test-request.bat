@echo off & cls & @echo. & @echo.

rem запрашиваем одну единственную конфигурацию
rem самый новый компилятор студии

set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."

call :normalizePath ePATH_BAT_SCRIPTS ^
    "%ePATH_BAT_SCRIPTS%"

set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
set "compare=%~dp0..\00-compare\compare.bat"
call "%~dp0settings_test-PC_test.bat"

rem ============================================================================
rem ============================================================================
call :init
call "%~dp0..\request.bat" ^
    "eCONFIGURATIONS" "msvc:64:debug:dynamic"
if errorlevel 1 (@echo [FAILED] & exit /b 1)

call "%viewVariables%" eCONFIGURATIONS
call "%viewVariables%" etalon

call "%compare%" result "%eCONFIGURATIONS%" "%etalon%"

if not defined result (
    @echo [FAILED]
    exit /b 1
)

@echo [SUCCESS]
exit /b

rem ............................................................................

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b

rem ............................................................................

:init
    set etalon=msvc2019: 64: debug: dynamic
exit /b
