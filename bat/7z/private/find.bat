@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_7Z="
    set index=0

    pushd "%~dp0"
    for /f "usebackq tokens=* delims=" %%a in (
        `dir /b /a-d /s "find-*.bat" 2^>nul` 
    ) do (
        call :addMethod "%%~na" 
    )
    popd 

    call :runAll

    endlocal & set "eDIR_7Z=%eDIR_7Z%"
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
        if not errorlevel 1 (
            if defined eDIR_7Z (exit /b)
        )
    )
    @echo [WARNING] 7z.exe not found
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

rem ============================================================================
rem ============================================================================

:normalizePath
    set "eDIR_WORKSPACE=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

