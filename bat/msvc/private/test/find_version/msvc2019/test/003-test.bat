@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    pushd "%~dp0"

    set "PATH=%~dp0..\x64\Release; %PATH%"
    set "ePATH_ROOT=%~dp0..\..\..\..\..\..\..\.."
    set list=C:\noexist; 003-test

    find_version --version
    find_version --help

    call :checkTest ^
    "003-test\gmock\ver-1.10.x\gmock" ^
        "--names: gmock; gtest" ^
        "--start:%list%"        
    if errorlevel 1 (goto :failed)

    call :checkTest ^
    "003-test\gtest\ver-1.8.1"  ^
        "--names: gmock; gtest" ^
        "--max-version:1.9.0"   ^
        "--start:%list%"        
    if errorlevel 1 (goto :failed)

:success
    @echo [TEST] PASSED
    popd
exit /b 0

:failed
    @echo [TEST] FAILED
    popd
exit /b 1

:checkTest
    @echo ---------------------------
    set "result="
    for /f "usebackq tokens=* delims=" %%a in (
        `find_version.exe %*`
    ) do (
        @echo [x] %%a
        set "result=%%a"
    )
    call :apply
    if not "%result%" == "%~1" (
        @echo [EXPECTED] '%~1'
        @echo [REAL] '%result%'
        @echo [FAILED]
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:apply
    if not defined result (exit /b)
    call :trim result %result%
    if not defined result (exit /b)
    call :normalizePath "%result%" result
    if not defined result (exit /b)
    call set "result=%%result:%~dp0=%%"
exit /b

rem ============================================================================
rem ============================================================================

:normalizePath
    setlocal
    set "RETVAL=%~dpfn1"
:removeEndedSlash
    set "last=%RETVAL:~-1%"

    if "%last%" == "\" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
    if "%last%" == "/" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
    endlocal & set "%~2=%RETVAL%"
exit /b

rem ============================================================================
rem ============================================================================

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b

rem ============================================================================
rem ============================================================================
