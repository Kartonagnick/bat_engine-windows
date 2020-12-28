@echo off
cls

@echo.
@echo.

rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\..\get_version.bat" 730
if errorlevel 1 (
    @echo [FAILED] mingw not found
    exit /b 1
)

@echo.
call :view32
call :view64

@echo [eINIT_COMPILER] ........ '%eINIT_COMPILER%'
@echo [eCOMPILER_TAG] ......... '%eCOMPILER_TAG%'
@echo [eGENERATOR] ............ '%eGENERATOR%'
@echo [eBOOST_TOOLSET] ........ '%eBOOST_TOOLSET%'
@echo.

@echo [SUCCESS]
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
