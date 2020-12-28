
@echo off
rem ============================================================================
rem ============================================================================

:main
    setlocal
    call "%~dp0config\configurations.bat" ^
        "eCONFIGURATIONS"   ^
        "%eCONFIGURATIONS%" ^
        "generate"

    if errorlevel 1 (
        @echo [FAILED] 'config\configurations.bat'
        exit /b 1
    )
    if "%eDEBUG%" == "ON" (call :debugConfigurationsView)
    endlocal & set "eCONFIGURATIONS=%eCONFIGURATIONS%"
exit /b

rem ============================================================================
rem ============================================================================

:debugConfigurationsView
    setlocal
    @echo [configurations]
    if not defined eCONFIGURATIONS (
        @echo -- 'no data' 
        exit /b
    )
    set index=0
    set "stringVariableValues=%eCONFIGURATIONS%"
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

