
@echo off
cls

@echo.
@echo.
set "eDIR_WORKSPACE=not_exist"
rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\..\init.bat"
if errorlevel 1 (
    @echo [TEST] FAILED
    exit /b 1
)
@echo [eDIR_CMAKE] '%eDIR_CMAKE%'

if not defined eDIR_CMAKE (
    @echo [FAILED] 'eDIR_CMAKE' must be defined
    exit /b `
)

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================
