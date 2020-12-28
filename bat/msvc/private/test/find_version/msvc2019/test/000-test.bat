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
    set list=C:\noexist; 000-test

    find_version --version
    find_version --help

  rem options --min-version/--max-version must be ignored
    call :checkTest ^
    "000-test\long-000\workspace\external\gmock\ver-1.8.2" ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--min-version: 1.8.1"            ^
        "--max-version: 1.10.x"           ^
        "--version: 1.8.2"                ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem concrete
    call :checkTest ^
    "000-test\long-000\workspace\external\gmock\ver-1.8.3" ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--version: 1.8.3"                ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem no exist
    call :checkTest                       ^
        ""                                ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--min-version: 1.8.1"            ^
        "--max-version: 1.10.x"           ^
        "--version: 1.11.2"               ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem no exist
    call :checkTest                       ^
        ""                                ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--version: 1.11.2"               ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem --min-version
    call :checkTest                       ^
    "000-test\long-001\workspace\external\gmock\ver-1.11.x\gmock" ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--min-version: 1.8.1"            ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem --max-version
    call :checkTest                       ^
    "000-test\long-000\workspace\external\gmock\ver-1.10.x\gmock" ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--max-version: 1.10.x"           ^
        "--symptoms: include; lib-*"
    if errorlevel 1 (goto :failed)

  rem select maximum
    call :checkTest ^
    "000-test\long-001\workspace\external\gmock\ver-1.11.x\gmock" ^
        "--names: gmock"                  ^
        "--start:%list%"                  ^
        "--s: workspace*;external*;long*" ^
        "--symptoms: include; lib-*"
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
