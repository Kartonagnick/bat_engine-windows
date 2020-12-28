@echo off
cls

@echo.
@echo.

set "eCOMPILER=msvc"
set "eVERSION="
set "eBIT=64"
rem ============================================================================
rem ============================================================================

@echo [TEST] run...
call "%~dp0..\..\get_version.bat" "%eCOMPILER%%eVERSION%" "%eBIT%"
if errorlevel 1 (
    @echo [ERROR] msvc not found
    @echo [FAILED]
    exit /b 1
)

@echo.
call :viewLatest32
call :viewLatest64

@echo.
@echo RESULT OF TEST:
@echo.

@echo [eCOMPILER_TAG] .... '%eCOMPILER_TAG%'
@echo [eINIT_COMPILER] ... '%eINIT_COMPILER%'
@echo [eGENERATOR] ....... '%eGENERATOR%'
@echo [eBOOST_TOOLSET] ... '%eBOOST_TOOLSET%'
@echo.

@echo [TEST] done!
exit /b

rem ============================================================================
rem ============================================================================

:viewLatest32
    @echo [eMSVC_32_LAST] ....... 'msvc%eMSVC_32_LAST%'
    @echo [eMSVC_32_VERSIONS] ... '%eMSVC_32_VERSIONS%'
    @echo.
exit /b

:viewLatest64
    @echo [eMSVC_64_LAST] ....... 'msvc%eMSVC_64_LAST%'
    @echo [eMSVC_64_VERSIONS] ... '%eMSVC_64_VERSIONS%'
    @echo.
exit /b
