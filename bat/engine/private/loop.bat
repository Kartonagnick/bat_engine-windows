@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem call generate\%eACTION%-%COMPILER_TAG%.bat
rem ============================================================================
rem ============================================================================

:main
    set "eACTION=%~1"
    rem setlocal
    call :enumerateConfigurations
exit /b

rem ============================================================================
rem ============================================================================

:enumerateConfigurations
    set "enumerator=%eCONFIGURATIONS% "
:loopEnumerateConfiguration
    for /F "tokens=1* delims=; " %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :processConfiguration "%%a"
        if errorlevel 1 (exit /b 1) 
    )
    if defined enumerator (goto :loopEnumerateConfiguration)
exit /b

:processConfiguration
    rem setlocal
    set "THIS_CONFIGURATION=%~1"
    if defined eLOOP_NO_LOGO (goto :next)
    @echo.
    @echo [LOOP] --------------------------------- [%THIS_CONFIGURATION%]
:next

    for /F "tokens=1,2,3,4,5* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMPILER_TAG   %%a
        call :trim eBUILD_TYPE     %%b
        call :trim eADDRESS_MODEL  %%c
        call :trim eRUNTIME_CPP    %%d
        call :trim eADDITIONAL     %%e
    )
    set "THIS_CONFIGURATION="
    call "%~dp0expand.bat" "%eSUFFIX%" "eEXPANDED_SUFFIX"

    call "%eDIR_BAT_SCRIPTS%\tools\normalize.bat" ^
        eEXPANDED_SUFFIX "%eEXPANDED_SUFFIX%"

    rem @echo [eEXPANDED_SUFFIX] %eEXPANDED_SUFFIX%

    if defined eLOOP_ITERATOR (
        call "%eACTION%.bat"
        exit /b
    )

    set "checked=%eCOMPILER_TAG:msvc=%"
    if not "%checked%" == "%eCOMPILER_TAG%" (
        call :process "msvc"
        exit /b
    )
    set "checked=%eCOMPILER_TAG:mingw=%"
    if not "%checked%" == "%eCOMPILER_TAG%" (
        call :process "mingw"
        exit /b
    )
    @echo [ERROR] unknown compiler: '%eCOMPILER_TAG%'

exit /b 1

rem ============================================================================
rem ============================================================================

:debugViewConfiguration
    @echo   [eCOMPILER_TAG] .... '%eCOMPILER_TAG%'
    @echo   [eBUILD_TYPE] ...... '%eBUILD_TYPE%'
    @echo   [eADDRESS_MODEL] ... '%eADDRESS_MODEL%'
    @echo   [eRUNTIME_CPP] ..... '%eRUNTIME_CPP%'
    @echo   [eADDITIONAL] ...... '%eADDITIONAL%'
exit /b

rem ============================================================================
rem ============================================================================

:process
    rem    @echo   [%eACTION%-%~1.bat]
    rem    if defined eDEBUG (call :debugViewConfiguration)
    call "%~dp0%eACTION%-%~1.bat"
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
exit /b

rem ============================================================================
rem ============================================================================
