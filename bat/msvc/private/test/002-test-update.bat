@echo off
cls
@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

set "fname=%~dp0delme.txt"
del /F /S /Q /A "%fname%" >nul 2>nul

call "%~dp0..\..\update.bat" "%fname%"
if errorlevel 1 (
    @echo [FAILED] 
    exit /b 1
)

if not exist "%fname%" (
    @echo [FAILED] "%fname%" must be exist
    exit /b 1
)
@echo [TEST] done!
del /F /S /Q /A "%fname%" >nul 2>nul
exit /b

rem ============================================================================
rem ============================================================================

