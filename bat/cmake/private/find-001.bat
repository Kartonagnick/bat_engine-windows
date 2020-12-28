@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_CMAKE="
    set "PATH=%eDIR_COMMAND%;%PATH%"    
    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_CMAKE=%eDIR_CMAKE%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set dirs=                                  ^
        eDIR_WORKSPACE\programs\x64\CMake\bin; ^
        C:\Program Files\CMake\bin;            ^
        eDIR_WORKSPACE\programs\x86\CMake\bin; ^
        C:\Program Files (x86)\CMake\bin;      ^
        D:\long\workspace\programs\x64\CMake

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:CMake*;bin" "--F:cmake.exe" "--once" "--dirnames"`
    ) do (
        set "eDIR_CMAKE=%%a"
    )
exit /b

:findProgram32
    set dirs=                              ^
        eDIR_WORKSPACE\programs\x86\CMake\bin; ^
        C:\Program Files\CMake\bin

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:CMake*;bin"  "--F:cmake.exe" "--once" "--exe32" "--dirnames"`
    ) do (
        set "eDIR_CMAKE=%%a"
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

