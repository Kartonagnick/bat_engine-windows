@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    if defined eLOOP_ITERATOR (
        call :cleanConfiguration
        exit /b
    )
    @echo [CLEAN] %eARGUMENT%

    if "%eARGUMENT%" == "all" (
        set "eCONFIGURATIONS=all"
        set "eARGUMENT="
    )

    if not defined eCONFIGURATIONS (set "eCONFIGURATIONS=all")
    if "%eCONFIGURATIONS%" == "all" (goto :cleanAll)

    call :cleanConfigurations
    if errorlevel 1 (goto :failed)
:success
    @echo [CLEAN] completed successfully
exit /b 0

:failed
    @echo [CLEAN] finished with erros
exit /b 1

:cleanAll
    call :cleanAllImpl
    if errorlevel 1 (goto failed)
    goto success
:cleanAllImpl
    if "%eARGUMENT%" == "build" (
        call :cleanDirectory "%eDIR_BUILD%"
        exit /b
    )
    if "%eARGUMENT%" == "product" (
        call :cleanDirectory "%eDIR_PRODUCT%"
        exit /b
    )
    (call :cleanDirectory "%eDIR_BUILD%") && (call :cleanDirectory "%eDIR_PRODUCT%")
exit /b

:cleanDirectory
    if not exist "%~1" (exit /b)
    @echo [CLEAN-ALL] %~1
    rd /S /Q "%~1"
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
    if "%eARGUMENT%" == "build" (
        call :cleanBuild
        exit /b
    )
    if "%eARGUMENT%" == "product" (
        call :cleanProduct
        exit /b
    )
    (call :cleanBuild) && (call :cleanProduct)
exit /b

:cleanBuild
    if exist "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" (
        @echo [CLEAN] "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
        rd /S /Q "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"
    ) else (
        @echo [CLEAN] no exist: "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
    )
exit /b

:cleanProduct
    if exist "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" (
        @echo [CLEAN] "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" 
        rd /S /Q "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%"
    ) else (
        @echo [CLEAN] no exist: "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" 
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
    if not defined eDIR_BUILD (
        @echo [ERROR] 'eDIR_BUILD' must be specified
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

