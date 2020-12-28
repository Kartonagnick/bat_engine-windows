
@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\find-000.bat"
if errorlevel 1 (
    @echo [FAILED]
    exit /b 1
)
@echo [eDIR_GIT] '%eDIR_GIT%'

if not defined eDIR_GIT (
    @echo [FAILED] 'eDIR_GIT' must be defined
    exit /b `
)

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================
