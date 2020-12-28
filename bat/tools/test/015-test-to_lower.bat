@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] 'to_lower.bat'
@echo expected: 'empty-result'

call "%~dp0..\to_lower.bat" VARIABLE
if errorlevel 1 (@echo [FAILED] & exit /b 1)

if defined VARIABLE (
    @echo result: %VARIABLE%
    @echo [FAILED] & exit /b 1
) else (
    @echo result: empty
)
@echo [SUCCESS] 
exit /b 

rem ============================================================================
rem ============================================================================

