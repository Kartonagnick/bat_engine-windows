
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

:createFile
    set "filename=%~1"
    if not exist "%filename%\.." (mkdir "%filename%\.." >nul 2>nul)
    @echo test > "%filename%"
    if errorlevel 1 (
        @echo [ERROR] can not create: '%filename%'
        exit /b 1
    )
exit /b

:createContent
    call :createFile "%~1\del.ololo"
    call :createFile "%~1\del.me"
    call :createFile "%~1\test.txt"
exit /b


rem ============================================================================
rem ============================================================================

:prepare
    rmdir /S /Q "111" >nul 2>nul
    call :createContent "111"
    call :createContent "111\222"
    call :createContent "111\333"
    call :createContent "111\444"
    call :createContent "111\333\555"
    if errorlevel 1 (
        @echo [FAILED] 'prepare' finished with errors
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:clean
    set "PATH=%~dp0..\x64\Release; %PATH%"
    garbage.exe "-start: %~dp0111" "--mask: *.txt; *.me"  "--debug" 
exit /b

rem ============================================================================
rem ============================================================================

:checkResult
    pushd "%~dp0111"
    for /f "delims=" %%f in ('dir /b /a-d /s *.*') do (
        call :checkValue "%%~f" "%%~xf"
    )
    popd 
exit /b

:checkValue
    if not "%~2" == ".ololo" (
        @echo [ERROR] %~1
        @echo [EXPECTED] .ololo
        set "err=true"
    )
exit /b

rem ============================================================================
rem ============================================================================

:done
    rmdir /S /Q "111" >nul 2>nul
    if errorlevel 1 (
        @echo [FAILED] 'rmdir 111' failed
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================
