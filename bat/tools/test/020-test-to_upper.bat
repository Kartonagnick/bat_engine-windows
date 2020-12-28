@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] 'to_upper.bat'
@echo expected: '"HELLO WORLD"'

call "%~dp0..\to_upper.bat" VARIABLE "hello world"
if errorlevel 1 (@echo [FAILED] & exit /b 1)

if not defined VARIABLE (
    @echo result: empty
    @echo [FAILED] & exit /b 1
)

@echo result: '%VARIABLE%'

if not %VARIABLE% == "HELLO WORLD" (
    @echo [FAILED] & exit /b 1
)

@echo [SUCCESS] 
exit /b 

rem ============================================================================
rem ============================================================================

