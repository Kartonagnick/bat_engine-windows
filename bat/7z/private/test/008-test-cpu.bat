
@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

set "checkfile=C:\Program Files\7-Zip\7z.exe"

@echo [CHECK] %checkfile%

if not exist "%checkfile%" (
    @echo [CANCEL] not exist: "%checkfile%"
    exit /b
)

call "%~dp0..\..\cpu.bat" "%checkfile%" CHECKED
if errorlevel 1 (
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
