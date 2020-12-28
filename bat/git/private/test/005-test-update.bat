
@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] run...
del /F /S /Q /A "%~dp0delme.bat" >nul 2>nul

call "%~dp0..\..\update.bat" "%~dp0delme.bat"
if errorlevel 1 (
    @echo [FAILED] 'update.bat' finished with error
    exit /b 1
)

set "eDIR_GIT=" 
if not exist "%~dp0delme.bat" (
    @echo [FAILED] 'delme.bat' must be exist
    exit /b 1
)

call "%~dp0delme.bat"

@echo [eDIR_GIT] '%eDIR_GIT%'

if not defined eDIR_GIT (
    @echo [FAILED] 'eDIR_GIT' must be defined
    exit /b `
)

del /F /S /Q /A "%~dp0delme.bat" >nul 2>nul
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

