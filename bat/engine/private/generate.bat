@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [GENERATE] %eARGUMENT%
    if not defined eARGUMENT              (goto :genByCmake)
    if "%eARGUMENT%" == "cmake"           (goto :genByCmake)
    if "%eARGUMENT%" == "cmake-makefiles" (goto :genByCmake)
    @echo [ERROR] unknown: %eARGUMENT%
    goto :failed
:success
    @echo [GENERATE] completed successfully
exit /b 0

:failed
    @echo [GENERATE] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:genByCmake
    call :genByCmakeImpl
    if errorlevel 1 (goto failed)
    goto success
:genByCmakeImpl
    setlocal
    call "%~dp0cmake\generate.bat"
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

