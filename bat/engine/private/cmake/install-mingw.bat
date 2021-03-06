@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal

    call "%~dp0build-mingw.bat"
    if errorlevel 1 (goto :failed)

    @echo [CMAKE-INSTALL-MINGW] started...

    if exist "%eDIR_OWNER%\cmake-mingw.bat" (
        call "%eDIR_OWNER%\cmake-mingw.bat" "install"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "mingw" "install"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\install.bat" (
        call "%eDIR_OWNER%\install.bat" "mingw" 
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call :install
    if errorlevel 1 (goto :failed)

:success
    endlocal & set "eUSERDATA=%eUSERDATA%"
    @echo [CMAKE-INSTALL-MINGW] completed successfully
exit /b

:failed
    endlocal & set "eUSERDATA=%eUSERDATA%"
    @echo [CMAKE-INSTALL-MINGW] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:install

    @echo [CMAKE INSTALL PROJECT FOR MINGW]
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
