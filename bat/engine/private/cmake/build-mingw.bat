@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal

    call :init
    if errorlevel 1 (goto :failed)

    call "%~dp0generate-mingw.bat"
    if errorlevel 1 (goto :failed)

    @echo [CMAKE-BUILD-MINGW] started...

    if exist "%eDIR_OWNER%\cmake-mingw.bat" (
        call "%eDIR_OWNER%\cmake-mingw.bat" "build"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "mingw" "build"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\build.bat" (
        call "%eDIR_OWNER%\build.bat" "mingw" 
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call :build
    if errorlevel 1 (goto :failed)

:success
    @echo [CMAKE-BUILD-MINGW] completed successfully
exit /b

:failed
    @echo [CMAKE-BUILD-MINGW] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:init
    call "%eDIR_BAT_SCRIPTS%\mingw\get_version.bat" ^
        "%eCOMPILER_TAG%" ^
        "%eADDRESS_MODEL%"

    if errorlevel 1 (
        @echo [ERROR] initialize 'mingw' failed
        exit /b 1
    )
    set "PATH=%eINIT_COMPILER%;%PATH%"
exit /b

:build
    call :normalizePath eDIR_BUILD ^
        "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 

    @echo [CMAKE BUILD PROJECT FOR MINGW]
    @echo   [eDIR_BUILD] .... '%eDIR_BUILD%'
    @echo   [eBUILD_TYPE] ... '%eBUILD_TYPE%'
    @echo.

    cmake.exe                               ^
        --build    "%eDIR_BUILD%"           ^
        --parallel "%NUMBER_OF_PROCESSORS%" ^
        --config   "%eBUILD_TYPE%"

    if errorlevel 1 (
        @echo [ERROR] cmake`s build finished with errors
        exit /b 1
    )

exit /b

rem ============================================================================
rem ============================================================================

:normalizePath
    set "%~1=%~dpfn2"
exit /b

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
    if not defined eDIR_BAT_SCRIPTS (
        call :normalizePath eDIR_BAT_SCRIPTS "%~dp0..\..\.."
    )
exit /b

rem ============================================================================
rem ============================================================================
