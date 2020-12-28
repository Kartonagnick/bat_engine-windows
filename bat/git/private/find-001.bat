@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_GIT="
    set "PATH=%eDIR_COMMAND%;%PATH%"    
    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_GIT=%eDIR_GIT%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set dirs=                                           ^
        eDIR_WORKSPACE\programs\x64\Git\bin;            ^
        eDIR_WORKSPACE\programs\x64\SmartGit\git\bin;   ^
        D:\long\workspace\programs\x64\Git\bin          ^
        D:\long\workspace\programs\x64\SmartGit\git\bin ^
        C:\Program Files\Git\bin;                       ^
        C:\Program Files\SmartGit\git\bin;              ^
        eDIR_WORKSPACE\programs\x86\Git\bin;            ^
        eDIR_WORKSPACE\programs\x86\SmartGit\git\bin;   ^
        C:\Program Files (x86)\Git\bin;                 ^
        C:\Program Files (x86)\SmartGit\git\bin;

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:7-Zip*" "--F:git.exe" "--once" "--dirnames"`
    ) do (
        set "eDIR_GIT=%%a"
    )
exit /b

:findProgram32
    set dirs=                                         ^
        eDIR_WORKSPACE\programs\x86\Git\bin;          ^
        eDIR_WORKSPACE\programs\x86\SmartGit\git\bin; ^
        C:\Program Files\Git\bin                      ^
        C:\Program Files\SmartGit\git\bin;

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:bin*" "--F:git.exe" "--once" "--exe32" "--dirnames"`
    ) do (
        set "eDIR_GIT=%%a"
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

