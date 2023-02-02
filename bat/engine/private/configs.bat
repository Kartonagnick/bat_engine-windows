@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    if defined eDEBUG (@echo [CONFIGURATIONS])

    call :loadProjectSettings || goto :failed
    call :configurations      || goto :failed

    if not defined eDEBUG goto :success
    call :debugView eCONFIGURATIONS
:success
    if not defined eCONFIGURATIONS (@echo [CONFIGURATIONS] empty data)
    if defined eDEBUG (@echo [CONFIGURATIONS] completed successfully)
    endlocal & (set "eCONFIGURATIONS=%eCONFIGURATIONS%")
exit /b

:failed
    @echo [CONFIGURATIONS] finished with erros
exit /b 1  

rem ============================================================================
rem ============================================================================

:first
    set "eCONFIGURATIONS="
    call "%~dp0config\request.bat" ^
        "eINCLUDE_CONFIGURATIONS"  ^
        "%eINCLUDE_CONFIGURATIONS%"
exit /b

:second
    call "%~dp0config\request.bat" ^
        "eCONFIGURATIONS"          ^
        "%eCONFIGURATIONS%"
    if errorlevel 1 (exit /b 1)

    if not defined eINCLUDE_CONFIGURATIONS  (exit /b)
    if "%eINCLUDE_CONFIGURATIONS%" == "all" (
        set eINCLUDE_CONFIGURATIONS=
        exit /b
    )
    call "%~dp0config\request.bat" ^
        "eINCLUDE_CONFIGURATIONS"  ^
        "%eINCLUDE_CONFIGURATIONS%"
exit /b

:third
    set "eREQUEST_EXCLUDE_CONFIGURATIONS=ON"
    call "%~dp0config\request.bat" ^
        "eEXCLUDE_CONFIGURATIONS"  ^
        "%eEXCLUDE_CONFIGURATIONS%"
    set "eREQUEST_EXCLUDE_CONFIGURATIONS="
exit /b

:configurations
    setlocal

    if not defined eCONFIGURATIONS (
        call :first
    ) else (
        if "%eCONFIGURATIONS%" == "all" (
            call :first
        ) else (
            call :second
        )
    )
    if errorlevel 1 (exit /b 1)

    if defined eEXCLUDE_CONFIGURATIONS (
      call :third || exit /b 1
    )

    set "eSKIP_SORT=ON"
    call "%~dp0config\filtration.bat" ^
        "FILTERED_CONFIGURATIONS"     ^
        "eCONFIGURATIONS"             ^
        "eINCLUDE_CONFIGURATIONS"     ^
        "eEXCLUDE_CONFIGURATIONS"

    endlocal & set "eCONFIGURATIONS=%FILTERED_CONFIGURATIONS%"
exit /b

rem ============================================================================
rem ============================================================================

:debugView
    rem %~1  variable name
    setlocal
    @echo [%~1]
    if not defined %~1 (
        @echo -- 'no data' 
        exit /b
    )
    set index=0
    call set "enumerator=%%%~1%%"
:loopView
    set /a index=%index%+1
    for /F "tokens=1* delims=;" %%g in ("%enumerator%") do (
        for /F "tokens=*" %%g in ("%%g") do (
            @echo     %index%^) '%%g' 
        )
        set "enumerator=%%h"
    )
    if defined enumerator (goto :loopView)
    endlocal
exit /b 

rem ============================================================================
rem ============================================================================

:loadProjectSettings
    if not exist "%eDIR_SOURCE%\project.root" (exit /b)
    if defined eDEBUG (@echo [LOAD] project.root)
    set "file=%eDIR_SOURCE%\project.root"
    for /F "tokens=*" %%a in ('findstr /pvrc:".*#.*" "%file%" ^| findstr /prc:"INCLUDE_CONFIGURATIONS"') do (
        call :processLine "%%~a"
    )
    for /F "tokens=*" %%a in ('findstr /pvrc:".*#.*" "%file%" ^| findstr /prc:"EXCLUDE_CONFIGURATIONS"') do (
        call :processLine "%%~a"
    )
exit /b

:processLine
    rem @echo [line] %~1
    set "key="
    set "val="
    for /F "tokens=1,* delims=+= " %%a in ("%~1") do (
        set "key=e%%~a"
        set "val=%%~b"
    )
:processLine-1
    type nul > nul
   (@echo %~1 | findstr /rc:"=" 1>nul) || goto :processLine-2
    if defined %key% (
        rem @echo [%key%][+=][%val%]
        call set "%key%=%%%key%%%; %val%"
    ) else (
        rem @echo [%key%][=][%val%]
        set "%key%=%val%"
    )
    exit /b
:processLine-2
    type nul > nul
   (@echo %~1 | findstr /rc:"+=" 1>nul) || exit /b 0
    if defined %key% (
        rem @echo [%key%][+=][%val%]
        call set "%key%=%%%key%%%; %val%"
    ) else (
        rem @echo [%key%][=][%val%]
        set "%key%=%val%"
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

