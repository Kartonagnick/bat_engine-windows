@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem 1.   check avialable 'find_in'
rem 2    if argument is 'all'  ---> runAllTest
rem 2.2    return OK
rem 3.   request configurations
rem 4.   recursieve loop "runTests.bat"

rem ============================================================================
rem ============================================================================
:main
    if defined eLOOP_ITERATOR (
        call :addConfiguration
        exit /b
    )
    @echo [RUN-TESTS] %eCOMMAND%: %eARGUMENT%

    call "%~dp0detect.bat"
    if errorlevel 1 (goto :failed)

    call :ajustParams
    if errorlevel 1 (goto :failed)

    call :checkAvialable
    if errorlevel 1 (
        @echo [ERROR] check 'cmd' directory: 
        @echo [ERROR] "%eDIR_WORKSPACE%\scripts\cmd"
        @echo [ERROR] 'find_in.exe' not found
        goto :failed
    )

    if "%eCONFIGURATIONS%" == "all" (
        set "eSTART=%eDIR_PRODUCT%"
        call :runAllTests
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if not defined eCONFIGURATIONS (
        set "eCONFIGURATIONS=%eARGUMENT%"
    )

    call :enumConfigurations
    if errorlevel 1 (goto :failed)
:success
    @echo [RUN-TESTS] completed successfully
exit /b 0

:failed
    @echo [RUN-TESTS] finished with erros
exit /b 1

:ajustParams 
    call :normalizePath eNAME_PROJECT  "%eNAME_PROJECT%"
    call :normalizePath eDIR_SOURCES   "%eDIR_SOURCES%"
    call :normalizePath eDIR_PROJECT   "%eDIR_PROJECT%"
    call :normalizePath eDIR_PRODUCT   "%eDIR_PRODUCT%"
    call :normalizePath eDIR_BUILD     "%eDIR_BUILD%"
    call :normalizePath eSUFFIX        "%eSUFFIX%"

    call "%~dp0expand.bat" "eNAME_PROJECT" "%eNAME_PROJECT%"
    call "%~dp0expand.bat" "eDIR_SOURCES"  "%eDIR_SOURCES%" 
    call "%~dp0expand.bat" "eDIR_PROJECT"  "%eDIR_PROJECT%" 
    call "%~dp0expand.bat" "eDIR_PRODUCT"  "%eDIR_PRODUCT%" 
    call "%~dp0expand.bat" "eDIR_BUILD"    "%eDIR_BUILD%"   
    if not defined eDEBUG (exit /b)

    @echo [AJUST PARAMS]
    @echo   [eNAME_PROJECT] ... %eNAME_PROJECT%
    @echo   [eDIR_SOURCES] .... %eDIR_SOURCES%
    @echo   [eDIR_PROJECT] .... %eDIR_PROJECT%
    @echo   [eDIR_PRODUCT] .... %eDIR_PRODUCT%
    @echo   [eDIR_BUILD] ...... %eDIR_BUILD%
    @echo   [eSUFFIX] ......... %eSUFFIX%
exit /b

rem ============================================================================
rem ============================================================================

:checkAvialable
    set "eDIR_BAT_CMD=%eDIR_WORKSPACE%\scripts\cmd"
    set "OLDPATH=%PATH%"
    set "PATH=%eDIR_BAT_CMD%;%PATH%"
    where "find_in.exe" >nul 2>nul
    if errorlevel 1 (set "PATH=%OLDPATH%")
exit /b

rem ============================================================================
rem ============================================================================

:enumConfigurations
    call "%~dp0configs.bat"
    if errorlevel 1 (exit /b)
    set "eLOOP_NO_LOGO=ON"
    set "eLOOP_ITERATOR=ON"
    call "%~dp0loop.bat" "%~dp0runTests" 
    call :runAllTests
exit /b

:addConfiguration
    if exist "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" (
        @echo [TESTS][+] "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"     
        set "eSTART=%eSTART%;%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%"
    ) else (
        @echo [TESTS][-] "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"     
    )
exit /b

rem ============================================================================
rem ============================================================================

rem no worked
:launch2
    if exist "%eDIR_WORKSPACE%\scripts\cmd\cmdlog.exe" (
        "%~1" 2>&1 | "cmdlog.exe" "--append" 
    ) else (
        "%~1" 2>&1 >> "%eLOGFILE%"
    )
exit /b

:launch
    "%~1" 2>&1 >> "%eLOGFILE%"
exit /b

:runAllTests
    @echo [eSTART] %eSTART%
    @echo [eEXCLUDE] %eEXCLUDE%
    @echo [eARGUMENT] %eARGUMENT%

    if exist "%eLOGFILE%" (
        del /F /Q "%eLOGFILE%" >nul 2>nul
    )
    type nul > nul

    @echo [========= test =========]    
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%eSTART%" "--ES:%eEXCLUDE%" "--F:%eARGUMENT%"`
    ) do (
        @echo [TEST] %%~a 
        @echo [TEST] %%~a >> "%eLOGFILE%"
        call :launch "%%~a"
        if errorlevel 1 (goto :testFailed)
    )
:testSuccess
    @echo [SUCCESS] >> "%eLOGFILE%"
    @echo [========= test =========]
exit /b

:testFailed
    @echo [ERROR] TEST FAILED >> "%eLOGFILE%"
    @echo [ERROR] TEST FAILED
    @echo [========= test =========]
exit /b /1

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
    set "eLOGFILE=%eDIR_OWNER%\cmdlog.txt"
exit /b

rem ============================================================================
rem ============================================================================

