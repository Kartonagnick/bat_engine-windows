@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [INSTALL] %eARGUMENT%
    if not defined eARGUMENT              (goto :installByCmake)
    if "%eARGUMENT%" == "cmake"           (goto :installByCmake)
    if "%eARGUMENT%" == "cmake-makefiles" (goto :installByCmake)
    @echo [ERROR] unknown: %eARGUMENT%
    goto :failed
:success
    @echo [INSTALL] completed successfully
exit /b 0

:failed
    @echo [INSTALL] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:installByCmake
    call :installByCmakeImpl
    if errorlevel 1 (goto failed)
    goto success
:installByCmakeImpl
    setlocal
    call "%~dp0cmake\install.bat"
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

