@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] 'to_lower.bat'
@echo expected: '"hello world"'

call "%~dp0..\to_lower.bat" VARIABLE "HELLO WORLD"
if errorlevel 1 (@echo [FAILED] & exit /b 1)

if not defined VARIABLE (
    @echo result: empty
    @echo [FAILED] & exit /b 1
)

@echo result: '%VARIABLE%'

if not %VARIABLE% == "hello world" (
    @echo [FAILED] & exit /b 1
)

@echo [SUCCESS] 
exit /b 

rem ============================================================================
rem ============================================================================

