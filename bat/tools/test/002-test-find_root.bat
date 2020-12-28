@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

call "%~dp0..\find_root.bat"

if errorlevel 1 (
    @echo [ERROR] root directory not found
    @echo [ERROR] no symptoms detected: '%eROOT_SYMTHOMS%'
    @echo [FAILED]
    exit /b 1
)

@echo [ROOT] '%ePATH_ROOT%'
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

