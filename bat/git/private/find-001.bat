@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_GIT="
    set "PATH=%eDIR_COMMANDS%;%PATH%"    
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
    call :normalize eDIR_WORKSPACE "%~dp0..\..\..\.."

    if not defined eDIR_COMMANDS (
        if exist "%eDIR_WORKSPACE%\scripts\cmd" (
            set "eDIR_COMMANDS=%eDIR_WORKSPACE%\scripts\cmd"
        ) else (
            call :normalize eDIR_COMMANDS "%~dp0..\..\..\cmd"
        )
    )

    if not exist "%eDIR_COMMANDS%\find_in.exe" (
        @echo [ERROR] 'cmd\find_in' not found
        exit /b 1
    )
exit /b

:normalize
    if defined %~1 (exit /b)
    set "%~1=%~dpfn2"
exit /b

rem ============================================================================
rem ============================================================================

