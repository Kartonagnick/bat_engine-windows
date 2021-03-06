@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

set "source=C:\project\hello world\ololo\.."
set "expected=C:\project\hello world"

@echo [TEST] 'normalize.bat'
@echo source: '%source%'
@echo expected: '%expected%'
set "result="

call "%~dp0..\normalize.bat" result "%source%"
if errorlevel 1 (@echo [FAILED] & exit /b 1)

@echo result: '%result%'

if not "%result%" == "%expected%" (
    @echo [FAILED] 
    exit /b 1
)

@echo [SUCCESS] & exit /b 0
rem ============================================================================
rem ============================================================================

