@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem 1.   check command`s argument
rem 1.1    if argument not support ---> error
rem 2.   request configurations
rem 3.   recursieve loop "clean.bat"

rem ============================================================================
rem ============================================================================
:main
    setlocal

    set eDIR_GIT1=C:\Program Files\Git\bin
    set eDIR_GIT2=C:\Program Files\SmartGit\git\bin
    set PATH=%eDIR_GIT1%;%eDIR_GIT2%;%PATH%

    @echo [INITIAL] begin...
    call :normalizeCommands "%~dp0..\..\..\commands"

    if exist "%eDIR_BAT_COMMANDS%" (
        @echo [INTIAL] no action required
        goto :success
    )

    call :normalizeGit "%~dp0..\..\git"
    if errorlevel 1 (goto :failed)

    call "%eDIR_BAT_GIT%\init.bat"
    if errorlevel 1 (goto :failed)

    git clone --recursive ^
        "https://github.com/Kartonagnick/experiment.git" ^
        "%eDIR_BAT_COMMANDS%"

    if errorlevel 1 (goto :failed)
:success
    @echo [INITIAL] completed successfully
exit /b 0

:failed
    @echo [INITIAL] finished with erros
exit /b 1

:normalizeCommands
    set "eDIR_BAT_COMMANDS=%~dpfn1"
exit /b

:normalizeGit
    set "eDIR_BAT_GIT=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

