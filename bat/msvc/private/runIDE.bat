
@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    call :initialize
    if errorlevel 1 (exit /b 1)

    call :debugView

    start "%eCOMPILER_TAG%"  ^
          "%eVISUAL_STUDIO%" ^
          "%eDIR_SOLUTION%\%eNAME_PROJECT%.sln" 

    timeout /T 7
exit /b

rem ============================================================================
rem ============================================================================

:initialize
    call "%~dp0..\get_version.bat" "%eCOMPILER_TAG%" 
    if errorlevel 1 (exit /b 1)

    @echo [initial compiler] please wait...
    call "%eINIT_COMPILER%"
    if errorlevel 1 (
        @echo [ERROR] initialization failed
        exit /b 1
    )
    @echo [initial compiler] done!

    where devenv.exe >nul 2>nul
    if not errorlevel 1 (
        set "eVISUAL_STUDIO=devenv.exe"
        exit /b 0
    )

    where WDExpress.exe >nul 2>nul
    if not errorlevel 1 (
        set "eVISUAL_STUDIO=WDExpress.exe"
        exit /b 0
    )

    @echo [ERROR][msvc%version%] 'devenv.exe' or 'WDExpress.exe' not found

exit /b 1

rem ============================================================================
rem ============================================================================

:debugView
    @echo [settings]
    @echo   [eCOMPILER_TAG] .... %eCOMPILER_TAG%
    @echo   [eVISUAL_STUDIO] ... %eVISUAL_STUDIO%
    @echo   [eDIR_SOLUTION] .... %eDIR_SOLUTION%
    @echo   [eNAME_PROJECT] .... %eNAME_PROJECT%
exit /b

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

