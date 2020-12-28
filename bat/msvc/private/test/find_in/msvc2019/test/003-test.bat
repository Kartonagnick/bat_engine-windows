
@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    set "PATH=%~dp0..\x64\Release; %PATH%"

    find_in --version
    find_in --help

    pushd "%~dp0"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%~dp0test" "--F:*.exe" --exe64 --once`
    ) do (
        @echo [result] %%a
    )
    popd 

exit /b 

rem ============================================================================
rem ============================================================================

