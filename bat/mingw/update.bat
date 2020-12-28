
@echo off
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "filename=%~1"
    if not defined filename (
        call :createFile "%~dp0_cache.bat"
        if errorlevel 1 (exit /b)
    )

    call "%~dp0private\find.bat"
    if errorlevel 1 (
        @echo [ERROR] 'find.bat' failed
        exit /b 1
    )

    call :saveInfo "x86" 32

    if defined ProgramFiles(x86) (
        @echo. >> "%filename%"
        call :saveSepparator
        @echo. >> "%filename%"
        call :saveInfo "x64" 64
    )

    endlocal & (
        set "eMINGW_32_VERSIONS=%eMINGW_32_VERSIONS%"
        set "eMINGW_64_VERSIONS=%eMINGW_64_VERSIONS%"
        set "eMINGW_32_LAST=%eMINGW_32_LAST%"     
        set "eMINGW_64_LAST=%eMINGW_64_LAST%"     
    ) 

exit /b 

:createFile
    set "filename=%~1"
    if not exist "%filename%\.." (mkdir "%filename%\.." >nul 2>nul)
    @echo. > "%filename%"
    if errorlevel 1 (
        @echo [ERROR] can not create: 
        @echo [ERROR] "%filename%"
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:saveInfo
    call set "versions=%%eMINGW_%~2_VERSIONS%%"
    call set "last=%%eMINGW_%~2_LAST%%"

    @echo set "eMINGW_%~2_VERSIONS=%versions%" >> "%filename%"
    @echo set "eMINGW_%~2_LAST=%last%" >> "%filename%"

    @echo. >> "%filename%"
    for %%a in (%versions%) do (call :saveMingwInit "%%~a" %~2)
exit /b

:saveSepparator
    @echo rem ............................................................................ >> "%filename%"
exit /b

:saveMingwInit
    call set "value=%%eMINGW%~1_%~2%%"
    @echo set "eMINGW%~1_%~2=%value%" >> "%filename%"
exit /b

rem ============================================================================
rem ============================================================================
