
@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    if not defined eCOMPILER_TAG (
        set "eCOMPILER_TAG=msvc"
    )

    if not defined eDIR_SOLUTION (
        set "eDIR_SOLUTION=%eDIR_BUILD%"
    )

    if not defined eNAME_PROJECT (
        for %%a in ("%eDIR_SOLUTION%\*.sln") do (
            set "eNAME_PROJECT=%%~na"
        )
    )
    if not exist "%eDIR_SOLUTION%\%eNAME_PROJECT%.sln" (
        for %%a in ("%eDIR_SOLUTION%\*.sln") do (
            set "eNAME_PROJECT=%%~na"
        )
    )

    call :debugView
    start "%eCOMPILER_TAG%" cmd /C "%~dp0private/runIDE.bat"
exit /b

rem ============================================================================
rem ============================================================================

:debugView
    @echo [settings]
    @echo   [eCOMPILER_TAG] ... %eCOMPILER_TAG%
    @echo   [eDIR_SOLUTION] ... %eDIR_SOLUTION%
    @echo   [eNAME_PROJECT] ... %eNAME_PROJECT%
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        cls
        @echo.
        @echo.
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
exit /b 0

rem ============================================================================
rem ============================================================================
