
@echo off
if defined MSVC_ALREADY_INITIALIZED (exit /b) 
set "MSVC_ALREADY_INITIALIZED=yes"
rem ============================================================================
rem ============================================================================

:main
    setlocal
    if not exist "%~dp0_cache.bat" (call "%~dp0update.bat")
    endlocal
    call "%~dp0_cache.bat"
exit /b 

rem ============================================================================
rem ============================================================================
