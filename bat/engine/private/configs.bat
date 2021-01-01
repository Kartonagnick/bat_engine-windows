
@echo off
rem ============================================================================
rem ============================================================================

:main
    setlocal

    if exist "%eDIR_SOURCES%\project.root" (
        call :loadProjectSettings
        if errorlevel 1 (exit /b 1)
    )
    @echo [configure] eINCLUDE_CONFIGURATIONS...
    call "%~dp0config\configurations.bat" ^
        "eINCLUDE_CONFIGURATIONS"   ^
        "%INCLUDE_CONFIGURATIONS%" ^
        "support"

    @echo [configure] eEXCLUDE_CONFIGURATIONS...
    call "%~dp0config\configurations.bat" ^
        "eEXCLUDE_CONFIGURATIONS"   ^
        "%EXCLUDE_CONFIGURATIONS%" ^
        "support"

    @echo [configure] eCONFIGURATIONS...
    call "%~dp0config\configurations.bat" ^
        "eCONFIGURATIONS"   ^
        "%eCONFIGURATIONS%" ^
        "generate"

    if errorlevel 1 (
        @echo [FAILED] 'config\configurations.bat'
        exit /b 1
    )
    if "%eDEBUG%" == "ON" (
        call :debugConfigurationsView eINCLUDE_CONFIGURATIONS
        call :debugConfigurationsView eEXCLUDE_CONFIGURATIONS
        call :debugConfigurationsView eCONFIGURATIONS
    )

    call "%~dp0config\filtration.bat" ^
        "FILTERED_CONFIGURATIONS"     ^
        "eCONFIGURATIONS"             ^
        "eINCLUDE_CONFIGURATIONS"     ^
        "eEXCLUDE_CONFIGURATIONS"

    if "%eDEBUG%" == "ON" (
        call :debugConfigurationsView FILTERED_CONFIGURATIONS
    )

    endlocal & set "eCONFIGURATIONS=%FILTERED_CONFIGURATIONS%"
exit /b

:loadProjectSettings
    @echo [LOAD] project.root

    set INCLUDE_CONFIGURATIONS=
    for /F "tokens=*" %%a in ('findstr /rc:"INCLUDE_CONFIGURATIONS" "%eDIR_SOURCES%\project.root"') do (
        call :processLine "%%~a"
    )

    set EXCLUDE_CONFIGURATIONS=
    for /F "tokens=*" %%a in ('findstr /rc:"EXCLUDE_CONFIGURATIONS" "%eDIR_SOURCES%\project.root"') do (
        call :processLine "%%~a"
    )
    rem call :debugConfigurationsView "INCLUDE_CONFIGURATIONS"
    rem call :debugConfigurationsView "EXCLUDE_CONFIGURATIONS"
exit /b

:processLine
    rem @echo [line] %~1
    set "key="
    set "val="
    for /F "tokens=1,2 delims=+= " %%a in ("%~1") do (
        set "key=%%~a"
        set "val=%%~b"
    )

    type nul > nul
    @echo %~1 | findstr /rc:"+=" 1>nul
    if not errorlevel 1 (
        rem @echo [%key%][+=][%val%]
        if defined %key% (
            call set "%key%=%%%key%%%; %val%"
        ) else (
            set "%key%=%val%"
        )
        goto :next
    )

    type nul > nul
    @echo %~1 | findstr /rc:"=" 1>nul
    if not errorlevel 1 (
        rem @echo [%key%][=][%val%]
        set "%key%=%val%"
    )
:next
    type nul > nul
exit /b 0

rem ============================================================================
rem ============================================================================

:debugConfigurationsView
    rem %~1  variable name
    setlocal
    @echo [%~1]
    if not defined %~1 (
        @echo -- 'no data' 
        exit /b
    )
    set index=0
    call set "stringVariableValues=%%%~1%%"
:loopConfigurationsView
    set /a index=%index%+1
    for /F "tokens=1* delims=;" %%g in ("%stringVariableValues%") do (
        for /F "tokens=*" %%g in ("%%g") do (
            @echo     %index%^) '%%g' 
        )
        set "stringVariableValues=%%h"
    )
    if defined stringVariableValues (goto :loopConfigurationsView)
    endlocal
    @echo.
exit /b 

rem ============================================================================
rem ============================================================================

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b

rem ============================================================================
rem ============================================================================

