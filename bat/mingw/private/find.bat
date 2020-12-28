
@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal

    set index=0
    pushd "%~dp0"
    for /f "usebackq tokens=* delims=" %%a in (
        `dir /b /a-d /s "find-*.bat" 2^>nul` 
    ) do (
        call :addMethod "%%~na"
    )
    popd 

    call :runAll

    endlocal & (
        set "eMINGW_32_VERSIONS=%eMINGW_32_VERSIONS%"
        set "eMINGW_64_VERSIONS=%eMINGW_64_VERSIONS%"
        set "eMINGW_32_LAST=%eMINGW_32_LAST%"     
        set "eMINGW_64_LAST=%eMINGW_64_LAST%"     

        set "eMINGW1020_32=%eMINGW1020_32%"
        set "eMINGW930_32=%eMINGW930_32%"
        set "eMINGW920_32=%eMINGW920_32%"
        set "eMINGW840_32=%eMINGW840_32%"
        set "eMINGW810_32=%eMINGW810_32%"
        set "eMINGW730_32=%eMINGW730_32%"
        set "eMINGW720_32=%eMINGW720_32%"

        set "eMINGW1020_64=%eMINGW1020_64%"
        set "eMINGW930_64=%eMINGW930_64%"
        set "eMINGW920_64=%eMINGW920_64%"
        set "eMINGW840_64=%eMINGW840_64%"
        set "eMINGW810_64=%eMINGW810_64%"
        set "eMINGW730_64=%eMINGW730_64%"
        set "eMINGW720_64=%eMINGW720_64%"
    ) 

exit /b

rem ............................................................................

:addMethod
    set "array[%index%]=%~1"
    set /a "index=%index%+1"
exit /b

rem ............................................................................

:runAll
    set /a "index=%index%-1"
    for /l %%i in (%index%, -1, 0) do (
        call :run %%i
        if not errorlevel 1 (exit /b)
    )
exit /b

rem ............................................................................

:run
    type nul > nul
    call set "value=%%array[%~1]%%"
    rem @echo [run] %~dp0%value%.bat

    if exist "%~dp0%value%.bat" (
        call "%~dp0%value%.bat"
    ) else (
        @echo [WARNING] bat-file not exist:
        @echo [WARNING] "%~dp0%value%"
    )
    if errorlevel 1 (
        @echo [WARNING] '%value%' finished with errors
        exit /b
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_WORKSPACE (
        call :normalizePath "%~dp0..\..\..\.."
    )
exit /b

:normalizePath
    set "eDIR_WORKSPACE=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================
