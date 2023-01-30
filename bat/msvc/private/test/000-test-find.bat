
@echo off
cls

@echo.
@echo.
rem ============================================================================
rem ============================================================================

@echo [TEST] run...

call "%~dp0..\find.bat"
if errorlevel 1 (
    @echo [FAILED]
    exit /b 1
)

@echo.
@echo [variables]

call :checkVSCOMNTOOLS "VS170COMNTOOLS" "2022"
call :checkVSCOMNTOOLS "VS160COMNTOOLS" "2019"
call :checkVSCOMNTOOLS "VS150COMNTOOLS" "2017"
call :checkVSCOMNTOOLS "VS140COMNTOOLS" "2015"
call :checkVSCOMNTOOLS "VS120COMNTOOLS" "2013"
call :checkVSCOMNTOOLS "VS110COMNTOOLS" "2012"
call :checkVSCOMNTOOLS "VS100COMNTOOLS" "2010"
call :checkVSCOMNTOOLS "VS90COMNTOOLS"  "2008"

@echo.
@echo [eMSVC_32_VERSIONS] ... '%eMSVC_32_VERSIONS%'
@echo [eMSVC_64_VERSIONS] ... '%eMSVC_64_VERSIONS%'
@echo [eMSVC_32_LAST] ....... '%eMSVC_32_LAST%'
@echo [eMSVC_64_LAST] ....... '%eMSVC_64_LAST%'

@echo.
@echo [versions]
call :enumerate32
@echo.
call :enumerate64

@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

:viewValue
    call set "value=%%eMSVC%~1_%~2%%"
    @echo   [eMSVC%~1_%~2] ... %value%
exit /b

:enumerate32
    for %%i in (%eMSVC_32_VERSIONS%) do ( 
        call :viewValue "%%~i" "32"
    )
exit /b

:enumerate64
    for %%i in (%eMSVC_64_VERSIONS%) do ( 
        call :viewValue "%%~i" "64"
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkVSCOMNTOOLS
    rem %~1 - variable. example: VS160COMNTOOLS
    rem %~2 - version. example: 2019

    call set "value=%%%~1%%"

    if defined %~1 (@echo   [%~1][%~2] "%value%")
exit /b

rem ============================================================================
rem ============================================================================

