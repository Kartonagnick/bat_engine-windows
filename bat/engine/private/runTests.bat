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
    if errorlevel 1 (goto :failed)

    call :makeLogFile
    if errorlevel 1 (goto :failed)

    set eSCAN=
    set index=1
    if not defined eARGUMENT (set "eARGUMENT=*.exe")
    if not defined eCONFIGURATIONS  (goto :runAllTests)
    if "%eCONFIGURATIONS%" == "all" (goto :runAllTests)

    call "%~dp0configs.bat"
    if errorlevel 1 (exit /b)

    set "eLOOP_ITERATOR=ON"
    call "%~dp0loop.bat" "%~dp0runTests" 

    set title=test
    goto :runTests
:success
    @echo [RUN-TESTS] completed successfully
exit /b 0

:failed
    @echo [RUN-TESTS] finished with erros
exit /b 1

:addConfiguration
    if exist "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%" (
        @echo [TESTS][+] "%eDIR_PRODUCT%\%eEXPANDED_SUFFIX%"     
        set "eSCAN=%eSCAN%;*/%eEXPANDED_SUFFIX%/*"
    )
exit /b

rem ............................................................................

:runAllTests
    set title=test-all
:runTests
    @echo [========= %title% =========]    
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start:%eDIR_PRODUCT%" "--ES:%eEXCLUDE%" "--F:%eARGUMENT%" "--VF:%eSCAN%"`
    ) do (
        call :launch "%%~a"
        if errorlevel 1 (goto :testFailed)
    )
    @echo [SUCCESS] >> "%eLOGFILE%"
    @echo [========= %title% =========]
goto :success

:testFailed
    @echo [ERROR] TEST FAILED >> "%eLOGFILE%"
    @echo [ERROR] TEST FAILED
    @echo [========= %title% =========]
goto :failed

:launch
    @echo [TEST][%index%] %~1 
    @echo [TEST][%index%] %~1 >> "%eLOGFILE%"
    "%~1" 2>&1 >> "%eLOGFILE%"
    set /a index=index+1
exit /b

rem ============================================================================
rem ============================================================================

:makeLogFile
    if not exist "%eLOGFILE%" (exit /b)
    del /F /Q "%eLOGFILE%" >nul 2>nul
    if errorlevel 1 (
        @echo [ERROR] can`t delete file
        @echo [ERROR] "%eLOGFILE%"
    )
exit /b

:checkAvialable
    set "PATH=%eDIR_COMMANDS%;%PATH%"
    where "find_in.exe" >nul 2>nul
    if errorlevel 1 (
        @echo [ERROR] check 'cmd' directory: 
        @echo [ERROR] check 'eDIR_COMMANDS': 
        @echo [ERROR] 'find_in.exe' not found
    )
exit /b

rem ............................................................................

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

    if not defined eDIR_BAT_SCRIPTS (
        call :normalizePath eDIR_BAT_SCRIPTS "%~dp0..\.."
    )
    if not defined eDIR_BAT_ENGINE (
        set "eDIR_BAT_ENGINE=%eDIR_BAT_SCRIPTS%\engine"
    )
    if not defined eDIR_SCRIPTS (
        call :normalizePath eDIR_SCRIPTS "%eDIR_BAT_SCRIPTS%\.."
    )
    if not defined eDIR_COMMANDS (
        set "eDIR_COMMANDS=%eDIR_SCRIPTS%\cmd"
    )

    set "eLOGFILE=%eDIR_OWNER%\cmdlog.txt"
exit /b

rem ============================================================================
rem ============================================================================



