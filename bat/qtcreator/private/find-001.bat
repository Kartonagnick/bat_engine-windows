@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    set "eDIR_QTCREATOR="
    setlocal
    set "suffix=Qt\Tools\QtCreator\bin"
    set "PATH=%eDIR_COMMANDS%;%PATH%"    
    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_QTCREATOR=%eDIR_QTCREATOR%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set dirs=                                   ^
        eDIR_WORKSPACE\programs\x64\%suffix%;   ^
        C:\Program Files\%suffix%;              ^
        eDIR_WORKSPACE\programs\x86\%suffix%;   ^
        C:\Program Files (x86)\%suffix%;        ^
        C:\%suffix%;                            ^
        D:\long\workspace\programs\x64\%suffix%

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:QT*" "--F:qtcreator.exe" "--once" "--dirnames"`
    ) do (
        set "eDIR_QTCREATOR=%%a"
    )
exit /b

:findProgram32
    set dirs=                                   ^
        eDIR_WORKSPACE\programs\x86\%suffix%;   ^
        C:\Program Files\%suffix%               ^
        C:\%suffix%;                            ^
        D:\long\workspace\programs\x86\%suffix%

    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%dirs%" "--S:QT*" "--F:qtcreator.exe" "--once" "--exe32" "--dirnames"`
    ) do (
        set "eDIR_QTCREATOR=%%a"
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

