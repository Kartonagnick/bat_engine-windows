@echo off & cls & @echo. & @echo.

rem здесь указываем множество конфигураций all
rem должна сработать оптимизация

set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."

call :normalizePath ePATH_BAT_SCRIPTS ^
    "%ePATH_BAT_SCRIPTS%"

set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
set "compare=%~dp0..\00-test-compare\compare.bat"
call "%~dp0settings_test-PC_test.bat"

rem ============================================================================
rem ============================================================================
call :init
call "%~dp0..\request.bat" ^
    "eCONFIGURATIONS" ^
    "all; all; all; all"
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
        msvc2019: 64: release: static; ^
        msvc2019: 64: release: dynamic; ^
        msvc2019: 64: debug: static; ^
        msvc2019: 64: debug: dynamic; ^
        msvc2019: 32: release: static; ^
        msvc2019: 32: release: dynamic; ^
        msvc2019: 32: debug: static; ^
        msvc2019: 32: debug: dynamic; ^
        msvc2017: 64: release: static; ^
        msvc2017: 64: release: dynamic; ^
        msvc2017: 64: debug: static; ^
        msvc2017: 64: debug: dynamic; ^
        msvc2017: 32: release: static; ^
        msvc2017: 32: release: dynamic; ^
        msvc2017: 32: debug: static; ^
        msvc2017: 32: debug: dynamic; ^
        msvc2015: 64: release: static; ^
        msvc2015: 64: release: dynamic; ^
        msvc2015: 64: debug: static; ^
        msvc2015: 64: debug: dynamic; ^
        msvc2015: 32: release: static; ^
        msvc2015: 32: release: dynamic; ^
        msvc2015: 32: debug: static; ^
        msvc2015: 32: debug: dynamic; ^
        msvc2013: 64: release: static; ^
        msvc2013: 64: release: dynamic; ^
        msvc2013: 64: debug: static; ^
        msvc2013: 64: debug: dynamic; ^
        msvc2013: 32: release: static; ^
        msvc2013: 32: release: dynamic; ^
        msvc2013: 32: debug: static; ^
        msvc2013: 32: debug: dynamic; ^
        msvc2012: 64: release: static; ^
        msvc2012: 64: release: dynamic; ^
        msvc2012: 64: debug: static; ^
        msvc2012: 64: debug: dynamic; ^
        msvc2012: 32: release: static; ^
        msvc2012: 32: release: dynamic; ^
        msvc2012: 32: debug: static; ^
        msvc2012: 32: debug: dynamic; ^
        msvc2010: 64: release: static; ^
        msvc2010: 64: release: dynamic; ^
        msvc2010: 64: debug: static; ^
        msvc2010: 64: debug: dynamic; ^
        msvc2010: 32: release: static; ^
        msvc2010: 32: release: dynamic; ^
        msvc2010: 32: debug: static; ^
        msvc2010: 32: debug: dynamic; ^
        msvc2008: 64: release: static; ^
        msvc2008: 64: release: dynamic; ^
        msvc2008: 64: debug: static; ^
        msvc2008: 64: debug: dynamic; ^
        msvc2008: 32: release: static; ^
        msvc2008: 32: release: dynamic; ^
        msvc2008: 32: debug: static; ^
        msvc2008: 32: debug: dynamic; ^
        mingw810: 64: release: static; ^
        mingw810: 64: release: dynamic; ^
        mingw810: 64: debug: static; ^
        mingw810: 64: debug: dynamic; ^
        mingw810: 32: release: static; ^
        mingw810: 32: release: dynamic; ^
        mingw810: 32: debug: static; ^
        mingw810: 32: debug: dynamic; ^
        mingw730: 64: release: static; ^
        mingw730: 64: release: dynamic; ^
        mingw730: 64: debug: static; ^
        mingw730: 64: debug: dynamic; ^
        mingw730: 32: release: static; ^
        mingw730: 32: release: dynamic; ^
        mingw730: 32: debug: static; ^
        mingw730: 32: debug: dynamic; ^
        mingw720: 64: release: static; ^
        mingw720: 64: release: dynamic; ^
        mingw720: 64: debug: static; ^
        mingw720: 64: debug: dynamic; ^
        mingw720: 32: release: static; ^
        mingw720: 32: release: dynamic; ^
        mingw720: 32: debug: static; ^
        mingw720: 32: debug: dynamic
exit /b
