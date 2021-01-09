@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    @echo [RUN] QtCreator...

    call :initCmakeList
    if errorlevel 1 (goto :failed)

    setlocal

    set eCOMPILER_TAG=
    set eADDRESS_MODEL=
    set eBUILD_TYPE=

    if not defined eDIR_CMAKE_LIST (call :detectCmakeProject)

    if not exist "%eDIR_CMAKE_LIST%\CMakeLists.txt" (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LIST' 
        @echo [ERROR] "%eDIR_CMAKE_LIST%" 
        goto :failed
    )

    call "%eDIR_BAT_SCRIPTS%\qtcreator\runIDE.bat"
    if errorlevel 1 (goto :failed)
:success
    @echo [RUN] completed successfully
exit

:failed
    @echo [RUN] finished with erros
exit

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

:initCmakeList
    if not defined eDIR_CMAKE_LIST (call :findCMakeLists)
    if not defined eDIR_CMAKE_LIST (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LIST' 
        @echo [ERROR] "%eDIR_CMAKE_LIST%"
        exit /b 1
    )
exit /b

:normalizeCMakeLists
    set "eDIR_CMAKE_LIST=%~dpfn1"
exit /b

:checkCMakeLists
    if exist "%~1\CMakeLists.txt" (
        call :normalizeCMakeLists "%~1"
        @echo   founded: %~1\CMakeLists.txt
        exit /b 0
    )
exit /b 1

:findCMakeLists
    @echo [FIND] CMakeLists.txt ...
    ( 
        call :checkCMakeLists "%eDIR_OWNER%" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%\cmake" 
    ) || (
        call :checkCMakeLists "%eDIR_SOURCES%\deploy" 
    ) || (
        call :checkCMakeLists "%eDIR_SOURCES%\deploy\cmake" 
    )
exit /b

rem ============================================================================
rem ============================================================================
