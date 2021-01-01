@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem 1.   check command`s argument
rem 1.1    if argument not support ---> error
rem 2.   request configurations
rem 3.   loop "cmake\build-%eCOMPILER_TAG%"

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [BUILD] %eCOMMAND%: %eARGUMENT%

    if "%eARGUMENT%" == "cmake-makefiles" (
        call :buildByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if "%eARGUMENT%" == "cmake" (
        call :buildByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if not defined eARGUMENT (
        call :buildByCmake
        if errorlevel 1 (goto :failed)
        goto :success
    )
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
    call "%~dp0cmake\ajust.bat"
    if errorlevel 1 (exit /b)

    call "%~dp0loop.bat" "cmake\build" 
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

