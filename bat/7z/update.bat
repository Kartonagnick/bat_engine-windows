@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "filename=%~1"
    if not defined filename (
        call :create "%~dp0_cache.bat"
    ) else (
        call :adding
    )
    if errorlevel 1 (exit /b)

    endlocal & set "eDIR_7Z=%eDIR_7Z%"
exit /b

rem ============================================================================
rem ============================================================================

:create
    set "filename=%~1"
    if not exist "%filename%\.." (mkdir "%filename%\.." >nul 2>nul)
    @echo. > "%filename%"
    if errorlevel 1 (
        @echo [ERROR] can not create: '%filename%'
        exit /b 1
    )
    call "%~dp0private\find.bat"
    if errorlevel 1 (
        @echo [ERROR] 'find' was failed
        exit /b 1
    )
    if defined eDIR_7Z (
        call :saveFile 
    ) else (
        call :saveNotFound 
    )
    if errorlevel 1 (
        @echo [ERROR] can not save: '%filename%'
    )
exit /b

rem ============================================================================
rem ============================================================================

:adding
    call "%~dp0private\find.bat"
    if errorlevel 1 (
        @echo [ERROR] 'find' was failed
        exit /b 1
    )
    if defined eDIR_7Z (
        @echo set "eDIR_7Z=%eDIR_7Z%" >> "%filename%"
    ) else (
        @echo rem '7z' not found >> "%filename%"
    )
    if errorlevel 1 (
        @echo [ERROR] can not save: '%filename%'
    )
exit /b

rem ============================================================================
rem ============================================================================

:saveSepparator
    @echo rem ............................................................................ >> "%filename%"
exit /b

:saveFile
    call :saveSepparator
    @echo. >> "%filename%"
    @echo set "eDIR_7Z=%eDIR_7Z%" >> "%filename%"
    @echo. >> "%filename%"
    call :saveSepparator
exit /b

:saveNotFound
    call :saveSepparator
    @echo. >> "%filename%"
    @echo rem '7z' not found >> "%filename%"
    @echo. >> "%filename%"
    call :saveSepparator
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if not defined eDIR_OWNER (
        @echo off
        cls
        @echo.
        @echo.
        @echo [UPDATE] 7z
    )
exit /b 0

rem ============================================================================
rem ============================================================================

