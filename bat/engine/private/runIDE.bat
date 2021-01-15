@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    @echo [RUN-IDE] %eARGUMENT%
    if "%eARGUMENT%" == "VisualStudio" (goto :runVisulStudio)
    if "%eARGUMENT%" == "QtCreator"    (goto :runQTCreator  )
    if "%eARGUMENT%" == "mingw"        (goto :runQTCreator  )
    @echo [ERROR] unknown: %eARGUMENT%
    goto :failed
:success
    @echo [RUN-IDE] completed successfully
exit /b 0

:failed
    @echo [RUN-IDE] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:runVisulStudio
    call :runVisulStudioImpl
    if errorlevel 1 (goto failed)
    goto success
:runVisulStudioImpl
    setlocal
    call "%~dp0runIDE\run-msvc.bat"
    if errorlevel 1 (exit /b)
exit /b

:runQTCreator
    call :runQTCreatorImpl
    if errorlevel 1 (goto failed)
    goto success
:runQTCreatorImpl
    setlocal
    call "%~dp0runIDE\run-mingw.bat"
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

