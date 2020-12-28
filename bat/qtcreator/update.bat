
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

    endlocal & set "eDIR_QTCREATOR=%eDIR_QTCREATOR%"
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
    if defined eDIR_QTCREATOR (
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
    if defined eDIR_QTCREATOR (
        @echo set "eDIR_QTCREATOR=%eDIR_QTCREATOR%" >> "%filename%"
    ) else (
        @echo rem 'QtCreator' not found >> "%filename%"
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
    @echo set "eDIR_QTCREATOR=%eDIR_QTCREATOR%" >> "%filename%"
    @echo. >> "%filename%"
    call :saveSepparator
exit /b

:saveNotFound
    call :saveSepparator
    @echo. >> "%filename%"
    @echo rem 'QtCreator' not found >> "%filename%"
    @echo. >> "%filename%"
    call :saveSepparator
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        cls
        @echo.
        @echo.
        @echo [UPDATE] QtCreator
    )
exit /b 0

rem ============================================================================
rem ============================================================================

