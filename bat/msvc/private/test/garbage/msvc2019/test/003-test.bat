
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
    rmdir /S /Q "Projects" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED] 'prepare' finished with errors
        exit /b 1
    )

    xcopy /E /I /H /O /X /Y "_Projects" "Projects" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED] 'prepare' finished with errors
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:clean
    set "PATH=%~dp0..\x64\Release; %PATH%"
    set m1=.git; .svn
    set m2=Release; release; release32; release64
    set m3=Debug; debug; debug32; debug64
    set m4=RelWithDebInfo; MinSizeRel
    set m5=*.suo; *.ncb; *.sdf; ipch; *.VC.db; *.aps
    set mask=%m1%; %m1%; %m2%; %m3%; %m4%; %m5%;
    garbage.exe "-start: %~dp0Projects" "--mask: %mask%" "--debug" 
exit /b

rem ============================================================================
rem ============================================================================

:checkResult
    pushd "%~dp0Projects"
    for /f "delims=" %%f in ('dir /b /a-d /s *.suo 2^>nul') do (
        call :checkValue "%%~f" "%%~xf"
    )
    popd
exit /b

:checkValue
    @echo [ERROR] %~1
    set "err=true"
exit /b

rem ============================================================================
rem ============================================================================

:done
    rmdir /S /Q "Projects" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED] 'rmdir Zoo' failed
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================
