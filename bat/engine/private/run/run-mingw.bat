@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    @echo [RUN] QtCreator

    set eCOMPILER_TAG=
    set eBUILD_TYPE=
    set eADDRESS_MODEL=

    if not defined eDIR_CMAKE_LISTS (call :detectCmakeProject)

    if not exist "%eDIR_CMAKE_LISTS%\CMakeLists.txt" (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LISTS' 
        @echo [ERROR] eDIR_CMAKE_LISTS: '%eDIR_CMAKE_LISTS%' 
        goto :failed
    )

    @echo [eDIR_BUILD] ... %eDIR_BUILD%
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

:normalizeDirCMakeLists
    set "eDIR_CMAKE_LISTS=%~dpfn1"
exit /b

:checkCMakeLists
    if exist "%~1\CMakeLists.txt" (
        call :normalizeDirCMakeLists "%~1"
        @echo     founded: %~1\CMakeLists.txt
        exit /b 0
    )
exit /b 1

:detectCmakeProject
    @echo [FIND] CMakeLists.txt ...
    ( 
        call :checkCMakeLists "%~dp0" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%\cmake" 
    ) || (
        call :checkCMakeLists "%eDIR_OWNER%\cmake" 
    )
exit /b

rem ============================================================================
rem ============================================================================
