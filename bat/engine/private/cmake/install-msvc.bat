@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [CMAKE-INSTALL-MSVC] started...
    if exist "%eDIR_OWNER%\cmake-msvc.bat" (
        call "%eDIR_OWNER%\cmake-msvc.bat" "install"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "msvc" "install"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call "%~dp0build-msvc.bat"
    if errorlevel 1 (goto :failed)

    call :install
    if errorlevel 1 (goto :failed)

:success
    @echo [CMAKE-INSTALL-MSVC] completed successfully
exit /b

:failed
    @echo [CMAKE-INSTALL-MSVC] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:install

    @echo [CMAKE INSTALL PROJECT FOR MSVC]
    @echo   [eDIR_PRODUCT] ....... '%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%'
    @echo   [eDIR_BUILD] ......... '%eDIR_BUILD%\%eEXPANDED_SUFFIX%'
    @echo   [eEXPANDED_SUFFIX] ... '%eEXPANDED_SUFFIX%'
    @echo   [eSUFFIX] ............ '%eSUFFIX%'
    @echo.
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
