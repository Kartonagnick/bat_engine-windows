@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] run...
call "%~dp0..\find-000.bat"
if errorlevel 1 (
    @echo [FAILED]
    exit /b 1
)

@echo.
@echo [eMINGW_32_VERSIONS] ... '%eMINGW_32_VERSIONS%'
@echo [eMINGW_32_LAST] ....... '%eMINGW_32_LAST%'

for %%a in (%eMINGW_32_VERSIONS%) do (
    call :viewVersion32 "%%~a"
)

@echo.
@echo [eMINGW_64_VERSIONS] ... '%eMINGW_64_VERSIONS%'
@echo [eMINGW_64_LAST] ....... '%eMINGW_64_LAST%'

for %%a in (%eMINGW_64_VERSIONS%) do (
    call :viewVersion64 "%%~a"
)

@echo.
@echo [TEST] done!

exit /b
rem ============================================================================
rem ============================================================================

:viewVersion64
    call set "val=%%eMINGW%~1_64%%"
    @echo [eMIGW%~1_64] %val%
exit /b

:viewVersion32
    call set "val=%%eMINGW%~1_32%%"
    @echo [eMIGW%~1_32] %val%
exit /b


rem ============================================================================
rem ============================================================================
