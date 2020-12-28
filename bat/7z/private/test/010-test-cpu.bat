
@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

set "checkfile=not_exist"
@echo [CHECK] %checkfile%

call "%~dp0..\..\cpu.bat" "%checkfile%" CHECKED
if not errorlevel 1 (
    @echo [FAILED]
    exit /b 1
)


if "%CHECKED%" == "" (
    @echo RESULT OF TEST: unknown
) ELSE (
    @echo RESULT OF TEST: %CHECKED%
)

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================
