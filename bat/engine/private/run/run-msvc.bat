@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [RUN] Visual Studio...
    call :processConfiguration "%eCONFIGURATIONS%"
    if errorlevel 1 (goto :failed)

    call "%eDIR_BAT_SCRIPTS%\msvc\runIDE.bat"
    if errorlevel 1 (goto :failed)
:success
    @echo [RUN] completed successfully
exit /b

:failed
    @echo [RUN] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:processConfiguration
    call :trim THIS_CONFIGURATION %~1
    for /F "tokens=1,2,3,4* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMPILER_TAG   %%a
        call :trim eADDRESS_MODEL  %%b
        call :trim eBUILD_TYPE     %%c
        call :trim eRUNTIME_CPP    %%d
    )

    if not defined eCOMPILER_TAG  (@echo [ERROR] 'eCOMPILER_TAG' must be specified  & exit /b 1)
    if not defined eADDRESS_MODEL (@echo [ERROR] 'eADDRESS_MODEL' must be specified & exit /b 1)
    if not defined eBUILD_TYPE    (@echo [ERROR] 'eBUILD_TYPE' must be specified    & exit /b 1)
    if not defined eRUNTIME_CPP   (@echo [ERROR] 'eRUNTIME_CPP' must be specified   & exit /b 1)

    if not defined eSUFFIX (@echo [WARNING] 'eSUFFIX' must be specified)

    call "%~dp0..\expand.bat" ^
        "eEXPANDED_SUFFIX"    ^
        "%eSUFFIX%"

    call :normalizePath eEXPANDED_SUFFIX ^
        "%eEXPANDED_SUFFIX%"

    if not exist "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" (
        @echo [ERROR] 'eDIR_BUILD\eEXPANDED_SUFFIX' not exist
        @echo [ERROR] not exist: "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"
        exit 
    )

    call :normalizePath eDIR_BUILD ^
        "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"

exit /b 

rem ============================================================================
rem ============================================================================

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b

rem ............................................................................

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
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


