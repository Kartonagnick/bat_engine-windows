@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    setlocal
    if not exist "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" (
        @echo [ERROR] 'eDIR_BUILD\eEXPANDED_SUFFIX' not exist
        @echo [ERROR] not exist: '%eDIR_BUILD%\%eEXPANDED_SUFFIX%'
        exit 
    )

    @echo [RUN] Visual Studio...

    call "%eDIR_BAT_SCRIPTS%\tools\normalize.bat" ^
        eDIR_BUILD                                ^
        "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"

    @echo   eDIR_BUILD: %eDIR_BUILD%

    call "%eDIR_BAT_SCRIPTS%\msvc\runIDE.bat"
    if errorlevel 1 (goto :failed)
:success
    @echo [RUN] completed successfully
exit 

:failed
    @echo [RUN] finished with erros
exit

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


