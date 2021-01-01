@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    @echo [AJUST] started...

    call "%~dp0..\detect.bat"
    if errorlevel 1 (goto :failed)

    call :ajustParams 
    if errorlevel 1 (goto :failed)

    call :initCmakeLists
    if errorlevel 1 (goto :failed)

    call "%~dp0..\configs.bat"
    if errorlevel 1 (goto :failed)

:success
    @echo [AJUST] completed successfully
exit /b 0

:failed
    @echo [AJUST] finished with erros
exit /b 1  

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b

rem ============================================================================
rem ============================================================================

:ajustParams 
    call :normalizePath eNAME_PROJECT  "%eNAME_PROJECT%"
    call :normalizePath eDIR_SOURCES   "%eDIR_SOURCES%"
    call :normalizePath eDIR_PROJECT   "%eDIR_PROJECT%"
    call :normalizePath eDIR_PRODUCT   "%eDIR_PRODUCT%"
    call :normalizePath eDIR_BUILD     "%eDIR_BUILD%"
    call :normalizePath eSUFFIX        "%eSUFFIX%"

goto :next1
    @echo [NORMALIZED PARAMS]
    @echo   [eNAME_PROJECT] ... %eNAME_PROJECT%
    @echo   [eDIR_SOURCES] .... %eDIR_SOURCES%
    @echo   [eDIR_PROJECT] .... %eDIR_PROJECT%
    @echo   [eDIR_PRODUCT] .... %eDIR_PRODUCT%
    @echo   [eDIR_BUILD] ...... %eDIR_BUILD%
    @echo   [eSUFFIX] ......... %eSUFFIX%
:next1
    call "%~dp0..\expand.bat" "eNAME_PROJECT" "%eNAME_PROJECT%"
    call "%~dp0..\expand.bat" "eDIR_SOURCES"  "%eDIR_SOURCES%" 
    call "%~dp0..\expand.bat" "eDIR_PROJECT"  "%eDIR_PROJECT%" 
    call "%~dp0..\expand.bat" "eDIR_PRODUCT"  "%eDIR_PRODUCT%" 
    call "%~dp0..\expand.bat" "eDIR_BUILD"    "%eDIR_BUILD%"   
    if not defined eDEBUG (goto :next2)

    @echo [AJUST PARAMS]
    @echo   [eNAME_PROJECT] ... %eNAME_PROJECT%
    @echo   [eDIR_SOURCES] .... %eDIR_SOURCES%
    @echo   [eDIR_PROJECT] .... %eDIR_PROJECT%
    @echo   [eDIR_PRODUCT] .... %eDIR_PRODUCT%
    @echo   [eDIR_BUILD] ...... %eDIR_BUILD%
    @echo   [eSUFFIX] ......... %eSUFFIX%
:next2

exit /b

:initCmakeLists
    if not defined eDIR_CMAKE_LISTS (set "eDIR_CMAKE_LISTS=%eDIR_PROJECT%")
    if not defined eDIR_CMAKE_LISTS (call :findCMakeLists)
    if not defined eDIR_CMAKE_LISTS (
        @echo [ERROR] not found: 'CMakeLists.txt' 
        @echo [ERROR] check 'eDIR_CMAKE_LISTS' 
        @echo [ERROR] check 'eDIR_PROJECT' 
        @echo [ERROR] eDIR_PROJECT: '%eDIR_PROJECT%' 
        @echo [ERROR] eDIR_CMAKE_LISTS: '%eDIR_CMAKE_LISTS%' 
        exit /b 1
    )
exit /b

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
        call :checkCMakeLists "%~dp0." 
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
    call :normalizeBatScripts "%~dp0..\..\.."
exit /b

:normalizeBatScripts
    if defined eDIR_BAT_SCRIPTS (exit /b)
    set "eDIR_BAT_SCRIPTS=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

