@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem call %eACTION%-%COMPILER_TAG%.bat
rem ============================================================================
rem ============================================================================

:main
    set "eACTION=%~1"
    call :enumerateConfigurations
exit /b

rem ============================================================================
rem ============================================================================

:enumerateConfigurations
    set "enumerator=%eCONFIGURATIONS%"
:loopEnumerateConfiguration
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :processConfiguration "%%a"
        if errorlevel 1 (exit /b 1) 
    )
    if defined enumerator (goto :loopEnumerateConfiguration)
exit /b

:processConfiguration
    call :trim THIS_CONFIGURATION %~1
    for /F "tokens=1,2,3,4* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMPILER_TAG   %%a
        call :trim eADDRESS_MODEL  %%b
        call :trim eBUILD_TYPE     %%c
        call :trim eRUNTIME_CPP    %%d
    )
    call "%~dp0expand.bat" "eEXPANDED_SUFFIX" ^
        "%eSUFFIX%"

    call :normalizePath eEXPANDED_SUFFIX ^
        "%eEXPANDED_SUFFIX%"

    if defined eLOOP_ITERATOR (
        call "%eACTION%.bat" 
        exit /b
    )

    call :getGroup
    if errorlevel 1 (exit /b 1) 
    
    call :process "%eGROUP%"
exit /b 

rem ============================================================================
rem ============================================================================

:getGroupImpl
    call set "checked=%%eCOMPILER_TAG:%~1=%%"
    if not "%checked%" == "%eCOMPILER_TAG%" (
        set "eGROUP=%~1"
        exit /b 1
    )
exit /b 0

:getGroup
    set "eGROUP="
    for %%a in (%eALL_COMPILERS%) do (
        call :getGroupImpl "%%~a"
        if errorlevel 1 (exit /b 0) 
    )
   @echo [ERROR] unknown compiler: '%eCOMPILER_TAG%'
exit /b 1

rem ============================================================================
rem ============================================================================

:debugView
    @echo   [eCOMPILER_TAG] .... '%eCOMPILER_TAG%'
    @echo   [eBUILD_TYPE] ...... '%eBUILD_TYPE%'
    @echo   [eADDRESS_MODEL] ... '%eADDRESS_MODEL%'
    @echo   [eRUNTIME_CPP] ..... '%eRUNTIME_CPP%'
exit /b

rem ============================================================================
rem ============================================================================

:process
    @echo [%eACTION%-%~1.bat]
    rem if defined eDEBUG (call :debugView)
    call "%eACTION%-%~1.bat"
exit /b

rem ============================================================================
rem ============================================================================

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

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
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
    if not defined eALL_COMPILERS (
        @echo [ERROR] 'eALL_COMPILERS' not specified
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================
