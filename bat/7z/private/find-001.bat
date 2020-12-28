@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_7Z="
    set "PATH=%eDIR_COMMAND%;%PATH%"    
    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_7Z=%eDIR_7Z%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set dirs=                                ^
        eDIR_WORKSPACE\programs\x64\7-Zip;   ^
        C:\Program Files\7-Zip;              ^
        eDIR_WORKSPACE\programs\x86\7-Zip;   ^
        C:\Program Files (x86)\7-Zip;        ^
        D:\long\workspace\programs\x64\7-Zip

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:7-Zip*" "--F:7z.exe" "--once" "--dirnames"`
    ) do (
        set "eDIR_7Z=%%a"
    )
exit /b

:findProgram32
    set dirs=                          ^
        eDIR_WORKSPACE\programs\x86\7-Zip; ^
        C:\Program Files\7-Zip

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:7-Zip*" "--F:7z.exe" "--once" "--exe32" "--dirnames"`
    ) do (
        set "eDIR_7Z=%%a"
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_WORKSPACE (
        call :normalizePath "%~dp0..\..\..\.."
    )
    set "eDIR_COMMAND=%eDIR_WORKSPACE%\scripts\cmd"
    if not exist "%eDIR_COMMAND%\find_in.exe" (
        @echo [ERROR] 'find_in' not found
        exit /b 1
    )
exit /b

:normalizePath
    set "eDIR_WORKSPACE=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

