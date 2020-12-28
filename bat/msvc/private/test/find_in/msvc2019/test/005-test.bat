
@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    set "PATH=%~dp0..\x64\Release; %PATH%"

    del %~dp0a.txt >nul 2>nul 

    find_in --version
    find_in --help

    pushd "%~dp0"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:C:\Program Files (x86)" "--F:*.exe" --exe64`
    ) do (
        @echo [result] %%a >> %~dp0a.txt 
    )
    popd 

exit /b 

rem ============================================================================
rem ============================================================================

