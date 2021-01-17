@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    if defined eLOOP_ITERATOR (
        call :execConfiguration
        exit /b
    )
    set "eCUSTOM_BAT_FILE=%eARGUMENT%.bat"
    @echo [CUSTOM] %eCUSTOM_BAT_FILE%
    if not exist "%eCUSTOM_BAT_FILE%" (
        @echo [ERROR] not exist: %eCUSTOM_BAT_FILE%
        @echo [ERROR] check command: '--custom: eARGUMENT'
        goto :failed
    )

    if not defined eCONFIGURATIONS (set "eCONFIGURATIONS=all")

    call "%~dp0configs.bat"
    if errorlevel 1 (exit /b)
    set "eLOOP_ITERATOR=ON"
    call "%~dp0loop.bat" "%~dp0custom" 
    if errorlevel 1 (goto :failed)
:success
    @echo [CUSTOM] completed successfully
exit /b 0

:failed
    @echo [CUSTOM] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:getGroupImpl
    call set "checked=%%eCOMPILER_TAG:%~1=%%"
    if not "%checked%" == "%eCOMPILER_TAG%" (
        set "eGROUP=%~1"
        exit /b 1
    )
exit /b 0

:getGroup
    set "eGROUP="
    for %%a in (%eALL_COMPILERS%) do (
        call :getGroupImpl "%%~a"
        if errorlevel 1 (exit /b 0) 
    )
   @echo [ERROR] unknown compiler: '%eCOMPILER_TAG%'
exit /b 1

:execConfiguration
    call :getGroup
    if errorlevel 1 (exit /b 1) 
    call "%eCUSTOM_BAT_FILE%" "%eGROUP%"
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

