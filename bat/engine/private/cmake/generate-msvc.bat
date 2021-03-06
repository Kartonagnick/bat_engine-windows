@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [CMAKE GENERATE PROJECT FOR MSVC]
    call "%eDIR_BAT_SCRIPTS%\msvc\get_version.bat" ^
        "%eCOMPILER_TAG%" ^
        "%eADDRESS_MODEL%"
    if errorlevel 1 (goto :failed)

    if exist "%eDIR_OWNER%\cmake-msvc.bat" (
        call "%eDIR_OWNER%\cmake-msvc.bat" "generate"
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if exist "%eDIR_OWNER%\cmake.bat" (
        call "%eDIR_OWNER%\cmake.bat" "msvc" "generate"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if exist "%eDIR_OWNER%\generate.bat" (
        call "%eDIR_OWNER%\generate.bat" "msvc" 
        if errorlevel 1 (goto :failed)
        goto :success
    )

    call :generate
    if errorlevel 1 (goto :failed)

:success
    endlocal & set "eUSERDATA=%eUSERDATA%"
    @echo [CMAKE-GENERATE-MSVC] completed successfully
exit /b

:failed
    endlocal & set "eUSERDATA=%eUSERDATA%"
    @echo [CMAKE-GENERATE-MSVC] finished with erros
exit /b 1 

rem ============================================================================
rem ============================================================================

:generate
    call :normalizePath "%eDIR_BUILD%\%eEXPANDED_SUFFIX%" 

    if "%eADDRESS_MODEL%" == "64" (
        set "append=-A x64"
    ) else (
        set "append=-A Win32"
    )                            
    if not defined eDEBUG (goto :next)

    @echo   [eDIR_CMAKE_LIST] ... '%eDIR_CMAKE_LIST%'
    @echo   [eDIR_BUILD] ........ '%eDIR_BUILD%'
    @echo   [eGENERATOR] ........ '%eGENERATOR%'
    @echo.
    @echo   [eCOMPILER_TAG] ..... '%eCOMPILER_TAG%'
    @echo   [eADDRESS_MODEL] .... '%eADDRESS_MODEL%'
    @echo   [eBUILD_TYPE] ....... '%eBUILD_TYPE%'
    @echo   [eRUNTIME_CPP] ...... '%eRUNTIME_CPP%'
    @echo.
:next
    cmake.exe ^
        -H"%eDIR_CMAKE_LIST%" ^
        -B"%eDIR_BUILD%"      ^
        -G"%eGENERATOR%"      ^
        -D"CMAKE_BUILD_TYPE=%eBUILD_TYPE%" ^
        %append%

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
