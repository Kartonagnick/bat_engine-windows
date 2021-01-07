@echo off
if defined eDIR_SOURCES (exit /b) 
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [DETECTED] directory of sources

    call :findRoot eDIR_SOURCES ^
        "include;deploy"        ^
        "src;source;sources;project.root"
    if errorlevel 1 (goto :failed)

    if defined eNAME_PROJECT (goto :success) 

    for %%a in ("%eDIR_SOURCES%\.") do (
        set "eNAME_PROJECT=%%~na"
    ) 
:success
    @echo   source directory: %eDIR_SOURCES%
    endlocal & (
        set "eDIR_SOURCES=%eDIR_SOURCES%"
        set "eNAME_PROJECT=%eNAME_PROJECT%"
    )
exit /b 0

:failed
    @echo [ERROR] source directory not found
    @echo [ERROR] check: 'eDIR_SOURCES'
exit /b 1

rem ============================================================================
rem ============================================================================

:findRoot
    :: %~1 RESULT_VARIABLE
    :: %~2 SYMTOMS_1
    :: %~3 SYMTOMS_2
    :: %~4 SYMTOMS_3
    if defined %~1 (exit /b)

    setlocal

    set "RETVAL=%~1"
    set "SYMTOMS_1=%~2"
    set "SYMTOMS_2=%~3"
    set "SYMTOMS_3=%~4"

    set "DRIVE=%CD:~0,3%"
    pushd "%CD%"
:loopFindRoot
    set "founded="
    call :checkRootSymptoms "%SYMTOMS_1%"
    if not errorlevel 1 (
        call :checkRootSymptoms "%SYMTOMS_2%"
        if not errorlevel 1 (
            call :checkRootSymptoms "%SYMTOMS_3%"
            if not errorlevel 1 (set "founded=ON")
        )
    )
    if defined founded (goto :successFindRoot)

    if "%DRIVE%" == "%CD%" goto :failedFindRoot
    cd ..
    goto :loopFindRoot
exit /b

:successFindRoot
    endlocal & set "%RETVAL%=%CD%"
    popd
exit /b 0 

:failedFindRoot
    popd
exit /b 1

rem ============================================================================
rem ============================================================================

:checkRootSymptoms
    set "enumerator=%~1"
    if not defined enumerator (exit /b 0)
:loopRootSymptoms
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        for /F "tokens=*" %%a in ("%%a") do (
            if exist "%CD%\%%a" exit /b 0
        )
        set "enumerator=%%b"
    )
    if defined enumerator goto :loopRootSymptoms
exit /b 1

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    call :normalizeBatScripts "%~dp0..\.."
exit /b

:normalizeBatScripts
    if defined eDIR_BAT_SCRIPTS (exit /b)
    set "eDIR_BAT_SCRIPTS=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

