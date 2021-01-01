@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem 1.   check command`s argument
rem 1.1    if argument not support ---> error
rem 2.   request configurations
rem 3.   loop "cmake\generate-%eCOMPILER_TAG%"

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [GENERATE] %eCOMMAND%: %eARGUMENT%

    if "%eARGUMENT%" == "cmake-makefiles" (
        call :genByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if "%eARGUMENT%" == "cmake" (
        call :genByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if not defined eARGUMENT (
        call :genByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
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
    call "%~dp0cmake\ajust.bat"
    if errorlevel 1 (exit /b)

    call "%~dp0loop.bat" "cmake\generate" 
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

