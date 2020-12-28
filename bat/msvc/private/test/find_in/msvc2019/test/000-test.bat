
@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    set "PATH=%~dp0..\x64\Release; %PATH%"

    set "ePATH_ROOT=%~dp0..\..\..\..\..\..\..\.."

    set list=                          ^
        ePATH_ROOT\programs\x64\7-Zip; ^
        C:\Program Files\7-Zip;        ^
        ePATH_ROOT\programs\x86\7-Zip; ^
        C:\Program Files (x86)\7-Zip


    find_in --version
    find_in --help

    pushd "%~dp0"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%list%" "--F:*.exe" "--once"`
    ) do (
        @echo [result] %%a
    )
    popd 

exit /b 

rem ============================================================================
rem ============================================================================

