@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    if defined eLOOP_ITERATOR (
        call :addConfiguration
        exit /b
    )
    @echo [RUN-TESTS] %eARGUMENT%
    setlocal
    call :checkAvialable
    if errorlevel 1 (
        @echo [ERROR] check 'cmd' directory: 
        @echo [ERROR] "%eDIR_WORKSPACE%\scripts\cmd"
        @echo [ERROR] 'find_in.exe' not found
        goto :failed
    )
    if not defined eCONFIGURATIONS  (goto :runAllTests)
    if "%eCONFIGURATIONS%" == "all" (goto :runAllTests)

    call "%~dp0configs.bat"
    if errorlevel 1 (exit /b)
    set "eLOOP_ITERATOR=ON"
    call "%~dp0loop.bat" "%~dp0runTests" 
    call :runTests
:success
    @echo [RUN-TESTS] completed successfully
exit /b 0

:failed
    @echo [RUN-TESTS] finished with erros
exit /b 1

:runAllTests
    call :runAllTestsImpl
    if errorlevel 1 (goto failed)
    goto success
:runAllTestsImpl
    @echo [RUN-TESTS-ALL]
    set "eSTART=%eDIR_PRODUCT%"
    set "eSCAN=*"
    call :runTests
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

:addConfiguration
    if exist "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" (
        @echo [TESTS][+] "%eDIR_BUILD%\%eEXPANDED_SUFFIX%"     
        set "eSCAN=%eSCAN%;%eEXPANDED_SUFFIX%"
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

:addEntry
    rem @echo [ENTRY] %~1 
    set "enties=%enties%;%~1"
exit /b

:runTests
    setlocal

    rem @echo [eSTART] %eDIR_PRODUCT%
    rem @echo [eSCAN] %eSCAN%
    rem @echo [eEXCLUDE] %eEXCLUDE%
    rem @echo [eARGUMENT] %eARGUMENT%

    if exist "%eLOGFILE%" (del /F /Q "%eLOGFILE%" >nul 2>nul)
    type nul > nul

    set "enties="
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%eDIR_PRODUCT%" "--S:%eSCAN%" "--ES:%eEXCLUDE%" "--D:*%eNAME_PROJECT%"`
    ) do (
        call :addEntry "%%~a "
    )

    @echo [========= test =========]    
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%enties%" "--ES:%eEXCLUDE%" "--F:%eARGUMENT%"`
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

