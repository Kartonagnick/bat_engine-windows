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

call "%~dp0..\configurations-debug.bat" ^
    "eBUILD_CONFIGURATIONS" ^
    "msvc2019:all:all:all; mingw-all:all:all:static" ^
    "build"

if errorlevel 1 (@echo [FAILED] & exit /b 1)

@echo [build configurations]
call :debugConfigurationsView
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

:debugConfigurationsView
    setlocal
    @echo [configurations]
    if not defined eBUILD_CONFIGURATIONS (
        @echo -- 'no data' 
        exit /b
    )
    set index=0
    set "stringVariableValues=%eBUILD_CONFIGURATIONS%"
:loopConfigurationsView
    set /a index=%index%+1
    for /F "tokens=1* delims=;" %%g in ("%stringVariableValues%") do (
        for /F "tokens=*" %%g in ("%%g") do (
            @echo     %index%^) '%%g' 
        )
        set "stringVariableValues=%%h"
    )
    if defined stringVariableValues (goto :loopConfigurationsView)
    endlocal
    @echo [configurations]
exit /b 

rem ============================================================================
rem ============================================================================


