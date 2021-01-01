
@echo off
cls

@echo.
@echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

set first=
set second=

call "%~dp0..\compare.bat" "result" "%first%" "%second%"

if not defined result (
    @echo [FAILED]
    exit /b 1
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

