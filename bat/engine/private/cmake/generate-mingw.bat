@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [CMAKE GENERATE MAKEFILE FOR MINGW]

    call :init
    if errorlevel 1 (goto :failed)

    if exist "%eDIR_OWNER%\cmake-mingw.bat" (
        call "%eDIR_OWNER%\cmake-mingw.bat" "generate"
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "mingw" "generate"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call :generate
    if errorlevel 1 (goto :failed)

:success
    @echo [CMAKE] completed successfully
exit /b

:failed
    @echo [CMAKE] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:init
    call "%eDIR_BAT_SCRIPTS%\mingw\get_version.bat" ^
        "%eCOMPILER_TAG%" ^
        "%eADDRESS_MODEL%"

    if errorlevel 1 (
        @echo [ERROR] initialize 'mingw' failed
        exit /b 1
    )
    set "PATH=%eINIT_COMPILER%;%PATH%"
exit /b

:generate
    call :normalizePath "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 
    if not defined eDEBUG (goto :next)

    @echo   [eDIR_CMAKE_LIST] ... '%eDIR_CMAKE_LIST%'
    @echo   [eDIR_BUILD] ........ '%eDIR_BUILD%'
    @echo   [eGENERATOR] ........ '%eGENERATOR%'
    @echo.
    @echo   [eCOMPILER_TAG] ..... '%eCOMPILER_TAG%'
    @echo   [eBUILD_TYPE] ....... '%eBUILD_TYPE%'
    @echo   [eADDRESS_MODEL] .... '%eADDRESS_MODEL%'
    @echo   [eRUNTIME_CPP] ...... '%eRUNTIME_CPP%'
    @echo.
:next
    cmake.exe ^
        -H"%eDIR_CMAKE_LIST%" ^
        -B"%eDIR_BUILD%"      ^
        -G"%eGENERATOR%"      ^
        -D"CMAKE_BUILD_TYPE=%eBUILD_TYPE%"

    if errorlevel 1 (
        @echo [ERROR] 'cmake.exe' failed
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:normalizePath
    set "eDIR_BUILD=%~dpfn1"
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
