@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

set "eDIR_OWNER=%~dp0"
set "eDIR_SOLUTION=%~dp0find_in\msvc2019"

call "%~dp0..\..\runIDE.bat" 
if errorlevel 1 (
    @echo [ERROR] msvc not found
    @echo [FAILED]
    exit /b 1
)

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================

