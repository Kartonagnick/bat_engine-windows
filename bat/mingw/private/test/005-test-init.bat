@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\..\init.bat"
if errorlevel 1 (
    @echo [ERROR] mingw not found
    @echo [FAILED]
    exit /b 1
)

@echo.
call :view32
call :view64

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================

:view32
    @echo [eMINGW_32_LAST] ....... '%eMINGW_32_LAST%'
    @echo [eMINGW_32_VERSIONS] ... '%eMINGW_32_VERSIONS%'
    @echo.
exit /b

:view64
    @echo [eMINGW_64_LAST] ....... '%eMINGW_64_LAST%'
    @echo [eMINGW_64_VERSIONS] ... '%eMINGW_64_VERSIONS%'
    @echo.
exit /b
