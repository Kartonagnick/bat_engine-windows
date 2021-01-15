@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [BUILD] %eARGUMENT%
    if not defined eARGUMENT              (goto :buildByCmake)
    if "%eARGUMENT%" == "cmake"           (goto :buildByCmake)
    if "%eARGUMENT%" == "cmake-makefiles" (goto :buildByCmake)
    @echo [ERROR] unknown: %eARGUMENT%
    goto :failed
:success
    @echo [BUILD] completed successfully
exit /b 0

:failed
    @echo [BUILD] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:buildByCmake
    call :buildByCmakeImpl
    if errorlevel 1 (goto failed)
    goto success
:buildByCmakeImpl
    setlocal
    call "%~dp0cmake\build.bat"
    if errorlevel 1 (exit /b)
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

