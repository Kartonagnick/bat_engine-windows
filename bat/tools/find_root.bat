@echo off
if defined ePATH_ROOT (exit /b 0)

set "eROOT_SYMTHOMS=%~1"
if not defined eROOT_SYMTHOMS (
    set "eROOT_SYMTHOMS=3rd_party;docs;programs"
)

setlocal
call :findRoot
if errorlevel 1 (
    endlocal
    exit /b 1
)
endlocal & set "ePATH_ROOT=%ePATH_ROOT%"
exit /b

rem ============================================================================
rem ============================================================================

:findRoot
    set "DRIVE=%CD:~0,3%"
    pushd "%CD%"
:loopFindRoot
    call :checkSymptomsFindRoot
    if errorlevel 1 (
        if "%DRIVE%" == "%CD%" goto :failedFindRoot
        cd ..
        goto :loopFindRoot
    ) else (
        goto :successFindRoot
    )
exit /b

:successFindRoot
    set "ePATH_ROOT=%CD%"
    popd
exit /b 0 

:failedFindRoot
    popd
exit /b 1

rem ============================================================================
rem ============================================================================

:checkSymptomsFindRoot
    set "enumerator=%eROOT_SYMTHOMS%"
:loopCheckSymptoms
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        for /F "tokens=*" %%a in ("%%a") do (
            if not exist "%CD%\%%a" exit /b 1
        )
        set "enumerator=%%b"
    )
    if defined enumerator goto :loopCheckSymptoms
exit /b 

rem ============================================================================
rem ============================================================================
