
@echo off
if defined QTCREATOR_ALREADY_INITIALIZED (exit /b) 
set "QTCREATOR_ALREADY_INITIALIZED=yes"

rem ============================================================================
rem ============================================================================

:main
    if not exist "%~dp0_cache.bat" (
        call "%~dp0update.bat" 
    ) else (
        call "%~dp0_cache.bat"
    )

    call :checkAvialable
    if not errorlevel 1 (goto :success)

    type nul > nul
    call "%~dp0update.bat"
    call :checkAvialable
    if not errorlevel 1 (goto :success)
    @echo [ERROR] 'qtcreator' not found
exit /b 1

:success
    endlocal & set "eDIR_QTCREATOR=%eDIR_QTCREATOR%" & set "PATH=%PATH%"
exit /b

rem ============================================================================
rem ============================================================================
 
:checkAvialable
    set "OLDPATH=%PATH%"
    set "PATH=%eDIR_QTCREATOR%;%PATH%"
    where "qtcreator.exe" >nul 2>nul
    if errorlevel 1 (set "PATH=%OLDPATH%")
exit /b

rem ============================================================================
rem ============================================================================

