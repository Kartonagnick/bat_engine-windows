@echo off & cls & @echo. & @echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
set "compare=%~dp0..\00-compare\compare.bat"
rem ============================================================================
rem ============================================================================

set build= ^
    msvc2015: 32:   release: dynamic; ^
    msvc2015  : 32:   release  : dynamic  ; ^
    msvc2015: 32 : release: static;  ^
    msvc2017: 32: release  : dynamic; ^
    msvc2017 : 32   : release  : static; ^
    mingw830 : 32   : release  : static

set include= ^
    msvc2015 : 32: release   : dynamic; ^
    msvc2015 : 32   : release   : dynamic; ^
    msvc2015: 32: release : static;  ^
    msvc2017 : 32: release    : dynamic; ^
    msvc2017 : 32: release  : static

set exclude= ^
    msvc2015: 32: release : static;  ^
    msvc2017 : 32: release  : static

set etalon= ^
    msvc2015: 32: release: dynamic; ^
    msvc2017: 32: release: dynamic

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
call "%compare%" equal "%result%" "%etalon%" 

@echo.
if not defined equal (@echo [FAILED] & exit /b 1)
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

