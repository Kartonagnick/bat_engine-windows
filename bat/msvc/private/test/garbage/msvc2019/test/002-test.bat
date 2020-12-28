
@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [TEST] begin...
 
    set "err="

    call :prepare
    if errorlevel 1 (exit /b 1)

    call :clean
    if errorlevel 1 (exit /b 1)

    call :checkResult
    if errorlevel 1 (exit /b 1)

    call :done
    if errorlevel 1 (exit /b 1)

    if defined err (
        @echo [FAILED]
        exit /b 1
    )
    @echo [TEST] PASSED
exit /b 


rem ============================================================================
rem ============================================================================

:prepare
    rmdir /S /Q "Zoo" >nul 2>nul
    xcopy /E /I /H /O /X /Y "_Zoo" "Zoo" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED-2] 'prepare' finished with errors
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:clean
    set "PATH=%~dp0..\x64\Release; %PATH%"
    garbage.exe "-start: %~dp0Zoo" "--mask: .git; *.svn" "--debug" 
exit /b

rem ============================================================================
rem ============================================================================

:checkResult
    pushd "%~dp0"
    for /f "delims=" %%f in ('dir /b /a-d /s .svn 2^>nul') do (
        call :checkValue "%%~f" "%%~xf"
    )
    popd
    if exist "%~dp0111\333" (set "err=true")
exit /b

:checkValue
    @echo [ERROR] %~1
    @echo [EXPECTED] .ololo
    set "err=true"
exit /b

rem ============================================================================
rem ============================================================================

:done
    rmdir /S /Q "Zoo" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED] 'rmdir Zoo' failed
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================
