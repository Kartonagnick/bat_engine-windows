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

:normalizeCMakeLists
    set "eDIR_CMAKE_LISTS=%~dpfn1"
exit /b

:checkCMakeLists
    if exist "%~1\CMakeLists.txt" (
        call :normalizeCMakeLists "%~1"
        @echo     founded: %~1\CMakeLists.txt
        exit /b 0
    )
exit /b 1

:findCMakeLists
    @echo [FIND] CMakeLists.txt ...
    ( 
        call :checkCMakeLists "%~dp0" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%\cmake" 
    )
exit /b

:genByCmake
    if not defined eDIR_CMAKE_LISTS (
        set "eDIR_CMAKE_LISTS=%eDIR_PROJECT%"
    )
    if not defined eDIR_CMAKE_LISTS (
        call :findCMakeLists
    )
    if not defined eDIR_CMAKE_LISTS (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LISTS' 
        @echo [ERROR] check 'eDIR_PROJECT' 
        @echo [ERROR] eDIR_PROJECT: '%eDIR_PROJECT%' 
        @echo [ERROR] eDIR_CMAKE_LISTS: '%eDIR_CMAKE_LISTS%' 
        exit /b 1
    )
    call "%~dp0configs.bat"
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

