
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
@echo [eDIR_7Z] '%eDIR_7Z%'

if not defined eDIR_7Z (
    @echo [FAILED] 'eDIR_7Z' must be defined
    exit /b `
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================
