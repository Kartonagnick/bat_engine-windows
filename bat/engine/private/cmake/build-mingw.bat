@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
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

    if not exist "%eDIR_BUILD%\%eEXPANDED_SUFFIX%\CMakeCache.txt" (
        call "%~dp0generate-mingw.bat"
        if errorlevel 1 (goto :failed)
    )

    call :build
    if errorlevel 1 (goto :failed)

:success
    @echo [CMAKE] completed successfully
exit /b

:failed
    @echo [CMAKE] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:build
    call :normalizePath "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
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
    set "eDIR_BUILD=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

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
exit /b

rem ============================================================================
rem ============================================================================
