@echo off
cls

@echo.
@echo.

set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

call "%~dp0..\configurations.bat" ^
    "eBUILD_CONFIGURATIONS" ^
    "   mingw640 :   all  :         all:   all:   custom   " ^
    "build"

if errorlevel 1 (@echo [FAILED] & exit /b 1)

@echo [build configurations]
call "%viewVariables%" eBUILD_CONFIGURATIONS
@echo [SUCCESS]
exit /b

rem ............................................................................

