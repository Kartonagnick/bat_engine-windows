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
    if defined eLOOP_ITERATOR (
        call :cleanConfiguration
        exit /b
    )
    @echo [CLEAN] %eCOMMAND%: %eARGUMENT%

    if "%eARGUMENT%" == "all" (
        call :cleanAll
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if "%eCONFIGURATIONS%" == "all" (
        call :cleanAll
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if not defined eCONFIGURATIONS (
        set "eCONFIGURATIONS=%eARGUMENT%"
    )

    call :cleanConfigurations
    if errorlevel 1 (goto :failed)
:success
    @echo [CLEAN%potfix%] completed successfully
exit /b 0

:failed
    @echo [CLEAN%potfix%] finished with erros
exit /b 1

:cleanAll
    set potfix=-ALL
    if exist "%eDIR_BUILD%" (
        @echo [CLEAN-ALL] "%eDIR_BUILD%" 
        rd /S /Q "%eDIR_BUILD%"
    )
exit /b

rem ============================================================================
rem ============================================================================

:cleanConfigurations
    call "%~dp0configs.bat"
    if errorlevel 1 (exit /b)
    set "eLOOP_ITERATOR=ON"
    call "%~dp0loop.bat" "%~dp0clean" 
exit /b

:cleanConfiguration
    if exist "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" (
        @echo [CLEAN] "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
        rd /S /Q "%eDIR_BUILD%"
    ) else (
        @echo [CLEAN] no exist: "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
    )
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

