
@echo off
cls

@echo.
@echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

set build= ^
    msvc2015: release:   32: dynamic: none; ^
    msvc2015  : release:   32  : dynamic  : none; ^
    msvc2015: release : 32: static: none;  ^
    msvc2017: release: 32  : dynamic: none; ^
    msvc2017 : release   : 32  : static: none; ^
    mingw830 : release   : 32  : static: none

set include= ^
    msvc2015 : release: 32   : dynamic: none; ^
    msvc2015 : release   : 32   : dynamic: none; ^
    msvc2015: release: 32 : static: none;  ^
    msvc2017 : release: 32    : dynamic: none; ^
    msvc2017 : release: 32  : static: none

set exclude= ^
    msvc2015: release: 32 : static: none;  ^
    msvc2017 : release: 32  : static: none

set etalon= ^
    msvc2015: release: 32: dynamic: none; ^
    msvc2017: release: 32: dynamic: none

@echo.
call "%viewVariables%" build

@echo.
call "%viewVariables%" include

@echo.
call "%viewVariables%" exclude

call "%~dp0..\filtration.bat" "result" "build" "include" "exclude"

@echo.
call "%viewVariables%" result

@echo.
call "%viewVariables%" etalon

set "equal="
call "%~dp0compare.bat" equal "%result%" "%etalon%" 

@echo.
if not defined equal (
    @echo [FAILED]
    exit /b 1
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

