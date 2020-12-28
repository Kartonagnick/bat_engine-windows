
@echo off
if defined 7Z_ALREADY_INITIALIZED (exit /b) 
set "7Z_ALREADY_INITIALIZED=yes"
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
    @echo [ERROR] '7z' not found
exit /b 1

:success
    endlocal & set "eDIR_7Z=%eDIR_7Z%" & set "PATH=%PATH%"
exit /b

rem ============================================================================
rem ============================================================================
 
:checkAvialable
    set "OLDPATH=%PATH%"
    set "PATH=%eDIR_7Z%;%PATH%"
    where "7z.exe" >nul 2>nul
    if errorlevel 1 (set "PATH=%OLDPATH%")
exit /b

rem ============================================================================
rem ============================================================================
