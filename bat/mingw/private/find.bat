
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
        set "eMINGW710_32=%eMINGW710_32%"
        
        set "eMINGW640_32=%eMINGW640_32%"
        set "eMINGW630_32=%eMINGW630_32%"
        set "eMINGW620_32=%eMINGW620_32%"
        set "eMINGW610_32=%eMINGW610_32%"
        
        set "eMINGW540_32=%eMINGW540_32%"
        set "eMINGW530_32=%eMINGW530_32%"
        set "eMINGW520_32=%eMINGW520_32%"
        set "eMINGW510_32=%eMINGW510_32%"
        
        set "eMINGW494_32=%eMINGW494_32%"
        set "eMINGW493_32=%eMINGW493_32%"
        set "eMINGW492_32=%eMINGW492_32%"
        set "eMINGW491_32=%eMINGW491_32%"
        set "eMINGW490_32=%eMINGW490_32%"
        
        set "eMINGW485_32=%eMINGW485_32%"
        set "eMINGW484_32=%eMINGW484_32%"
        set "eMINGW483_32=%eMINGW483_32%"
        set "eMINGW482_32=%eMINGW482_32%"
        set "eMINGW481_32=%eMINGW481_32%"

        set "eMINGW1020_64=%eMINGW1020_64%"
        set "eMINGW930_64=%eMINGW930_64%"
        set "eMINGW920_64=%eMINGW920_64%"
        set "eMINGW840_64=%eMINGW840_64%"
        set "eMINGW810_64=%eMINGW810_64%"
        set "eMINGW730_64=%eMINGW730_64%"
        set "eMINGW720_64=%eMINGW720_64%"
        set "eMINGW710_64=%eMINGW710_64%"
        
        set "eMINGW640_64=%eMINGW640_64%"
        set "eMINGW630_64=%eMINGW630_64%"
        set "eMINGW620_64=%eMINGW620_64%"
        set "eMINGW610_64=%eMINGW610_64%"
        
        set "eMINGW540_64=%eMINGW540_64%"
        set "eMINGW530_64=%eMINGW530_64%"
        set "eMINGW520_64=%eMINGW520_64%"
        set "eMINGW510_64=%eMINGW510_64%"

        set "eMINGW494_64=%eMINGW494_64%"
        set "eMINGW493_64=%eMINGW493_64%"
        set "eMINGW492_64=%eMINGW492_64%"
        set "eMINGW491_64=%eMINGW491_64%"
        set "eMINGW490_64=%eMINGW490_64%"
        
        set "eMINGW485_64=%eMINGW485_64%"
        set "eMINGW484_64=%eMINGW484_64%"
        set "eMINGW483_64=%eMINGW483_64%"
        set "eMINGW482_64=%eMINGW482_64%"
        set "eMINGW481_64=%eMINGW481_64%"
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
    call :normalizePath "%~dp0..\..\..\.."
exit /b

:normalizePath
    if defined eDIR_WORKSPACE (exit /b)
    set "eDIR_WORKSPACE=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================
