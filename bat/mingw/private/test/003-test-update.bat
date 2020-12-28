@echo off
cls
@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...
del /F /S /Q /A "%~dp0..\..\_cache.bat" >nul 2>nul

call "%~dp0..\..\update.bat"
if errorlevel 1 (
    @echo [FAILED] 'update.bat' finished with error
    exit /b 1
)

if not exist "%~dp0..\..\_cache.bat" (
    @echo [FAILED] '_cache.bat' must be exist
    exit /b 1
)

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================

