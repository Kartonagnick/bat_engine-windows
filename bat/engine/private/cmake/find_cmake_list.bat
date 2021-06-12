@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    if not defined eDIR_CMAKE_LIST (call :findCMakeLists)
    if not defined eDIR_CMAKE_LIST (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LIST' 
        @echo [ERROR] "%eDIR_CMAKE_LIST%"
        exit /b 1
    )
    endlocal & set "eDIR_CMAKE_LIST=%eDIR_CMAKE_LIST%"
exit /b 

rem ============================================================================
rem ============================================================================

:normalizeCMakeLists
    set "eDIR_CMAKE_LIST=%~dpfn1"
exit /b

:checkCMakeLists
    if exist "%~1\CMakeLists.txt" (
        call :normalizeCMakeLists "%~1"
        call :foundCMakeLists "%~1"
        exit /b 0
    )
exit /b 1

:foundCMakeLists
    @echo   founded: %~1\CMakeLists.txt
exit /b

:findCMakeLists
    @echo [FIND] CMakeLists.txt ...
    ( 
        call :checkCMakeLists "%eDIR_SOURCE%" 
    ) || (
        call :checkCMakeLists "%eDIR_SOURCE%\deploy" 
    ) || (
        call :checkCMakeLists "%eDIR_SOURCE%\deploy\cmake" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%\cmake" 
    )
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
    if not defined eDIR_SOURCE (
        @echo [ERROR] 'eDIR_SOURCE' must be specified
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

