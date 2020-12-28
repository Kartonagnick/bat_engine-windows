
@echo off
cls

@echo.
set "eDIR_OWNER=%~dp0"
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

if not defined eDIR_GIT (
    @echo [FAILED] 'eDIR_GIT' must be defined
    exit /b `
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

