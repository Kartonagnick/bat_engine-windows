@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    @echo [CMAKE-GENERATE]
    call "%~dp0find_cmake_list.bat"
    if errorlevel 1 (goto :failed)

    call "%~dp0..\configs.bat"
    if errorlevel 1 (goto :failed)

    call "%~dp0..\loop.bat" "%~dp0generate" 
    if errorlevel 1 (goto :failed)
:success
    @echo [CMAKE-GENERATE] completed successfully
exit /b 0

:failed
    @echo [CMAKE-GENERATE] finished with erros
exit /b 1  

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
    if not defined eDIR_SOURCE (
        @echo [ERROR] 'eDIR_SOURCE' must be specified
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

