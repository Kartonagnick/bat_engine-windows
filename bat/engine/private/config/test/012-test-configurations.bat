@echo off
cls

@echo.
@echo.
rem ............................................................................
set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

call "%~dp0..\configurations.bat" ^
    "eBUILD_CONFIGURATIONS" "msvc"

if errorlevel 1 (@echo [FAILED] & exit /b 1)

call "%viewVariables%" eBUILD_CONFIGURATIONS
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================


