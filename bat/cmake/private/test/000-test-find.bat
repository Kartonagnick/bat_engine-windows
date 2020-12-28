
@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\find.bat"
if errorlevel 1 (
    @echo [FAILED]
    exit /b 1
)
@echo [eDIR_CMAKE] '%eDIR_CMAKE%'

if not defined eDIR_CMAKE (
    @echo [FAILED] 'eDIR_CMAKE' must be defined
    exit /b `
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================
