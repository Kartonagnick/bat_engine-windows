
@echo off
cls

@echo.
@echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

set first=msvc2015: release: 32: dynamic: none
set second=

@echo.
call "%viewVariables%" first

@echo.
call "%viewVariables%" second

call "%~dp0compare.bat" result "%first%" "%second%"

if defined result (
    @echo [FAILED]
    exit /b 1
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

