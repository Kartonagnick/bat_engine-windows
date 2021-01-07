@echo off & cls & @echo. & @echo.

rem запрашиваем несколько одинаковых конфигураций
rem дубликаты должны быть удалены

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
    "eCONFIGURATIONS" "msvc-all:all:debug;mingw-all:all:debug;msvc-all:all:debug;mingw-all:all:debug"
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
    set etalon= ^
        msvc2019: 64: debug: static; ^
        msvc2019: 64: debug: dynamic; ^
        msvc2019: 32: debug: static; ^
        msvc2019: 32: debug: dynamic; ^
        msvc2017: 64: debug: static; ^
        msvc2017: 64: debug: dynamic; ^
        msvc2017: 32: debug: static; ^
        msvc2017: 32: debug: dynamic; ^
        msvc2015: 64: debug: static; ^
        msvc2015: 64: debug: dynamic; ^
        msvc2015: 32: debug: static; ^
        msvc2015: 32: debug: dynamic; ^
        msvc2013: 64: debug: static; ^
        msvc2013: 64: debug: dynamic; ^
        msvc2013: 32: debug: static; ^
        msvc2013: 32: debug: dynamic; ^
        msvc2012: 64: debug: static; ^
        msvc2012: 64: debug: dynamic; ^
        msvc2012: 32: debug: static; ^
        msvc2012: 32: debug: dynamic; ^
        msvc2010: 64: debug: static; ^
        msvc2010: 64: debug: dynamic; ^
        msvc2010: 32: debug: static; ^
        msvc2010: 32: debug: dynamic; ^
        msvc2008: 64: debug: static; ^
        msvc2008: 64: debug: dynamic; ^
        msvc2008: 32: debug: static; ^
        msvc2008: 32: debug: dynamic; ^
        mingw810: 64: debug: static; ^
        mingw810: 64: debug: dynamic; ^
        mingw810: 32: debug: static; ^
        mingw810: 32: debug: dynamic; ^
        mingw730: 64: debug: static; ^
        mingw730: 64: debug: dynamic; ^
        mingw730: 32: debug: static; ^
        mingw730: 32: debug: dynamic; ^
        mingw720: 64: debug: static; ^
        mingw720: 64: debug: dynamic; ^
        mingw720: 32: debug: static; ^
        mingw720: 32: debug: dynamic

exit /b
