@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================

:main
    setlocal

    rem set "eDEBUG=ON"

    call "%eDIR_BAT_ENGINE%\run.bat" ^
        "--runIDE: QtCreator"

exit /b

rem ============================================================================
rem ============================================================================

:normalize
    set "%~1=%~dpfn2"
exit /b

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off & cls & @echo. & @echo.
        call :normalize eDIR_OWNER "%~dp0."
    )
    if not defined eDIR_BAT_SCRIPTS (
        call :normalize eDIR_BAT_SCRIPTS "%~dp0..\..\bat"
    )
    if not defined eDIR_BAT_ENGINE (
        set "eDIR_BAT_ENGINE=%eDIR_BAT_SCRIPTS%\engine"
    )
exit /b

rem ============================================================================
rem ============================================================================
