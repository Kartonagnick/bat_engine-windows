
@echo off
cls

@echo.
@echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

set first= ^
    msvc2015: release:   32: dynamic: none; ^
    msvc2015: release: 32: dynamic: none; ^
    msvc2015: release: 32  : dynamic: none; ^
    msvc2015: release: 32: static: none;  ^
    msvc2017: release: 32  : dynamic: none; ^
    msvc2017: release: 32: dynamic: none; ^
    msvc2017: release: 32   : dynamic: none; ^
    msvc2017: release: 32    : dynamic: none; ^
    msvc2017: release: 32 : dynamic: none; ^
    msvc2017: release: 32  : static: none

set second= ^
    msvc2015: release: 32   : dynamic: none; ^
    msvc2015: release: 32 : static: none;  ^
    msvc2017: release: 32    : dynamic: none; ^
    msvc2017: release: 32  : static: none ^
    mingw810: release: 32  : static: none

@echo.
call "%viewVariables%" first

@echo.
call "%viewVariables%" second

call "%~dp0..\compare.bat" result "%first%" "%second%"

if defined result (
    @echo [FAILED]
    exit /b 1
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

