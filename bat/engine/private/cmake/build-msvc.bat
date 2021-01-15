@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [CMAKE-BUILD-MSVC] started...

    if exist "%eDIR_OWNER%\cmake-msvc.bat" (
        call "%eDIR_OWNER%\cmake-msvc.bat" "build"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "msvc" "build"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\build.bat" (
        call "%eDIR_OWNER%\build.bat" "msvc" 
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call "%~dp0generate-msvc.bat"
    if errorlevel 1 (goto :failed)

    call :build
    if errorlevel 1 (goto :failed)

:success
    @echo [CMAKE-BUILD-MSVC] completed successfully
exit /b

:failed
    @echo [CMAKE-BUILD-MSVC] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:build
    call :normalizePath "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 

    @echo [CMAKE BUILD PROJECT FOR MSVC]
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
