
@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\..\init.bat"
if errorlevel 1 (
    @echo [TEST] FAILED
    exit /b 1
)

@echo [eDIR_QTCREATOR] '%eDIR_QTCREATOR%'

if not defined eDIR_QTCREATOR (
    @echo [FAILED] 'eDIR_QTCREATOR' must be defined
    exit /b `
)

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================
