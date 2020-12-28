
@echo off
rem ============================================================================
rem ============================================================================

:test32bit

    :: %~1  path to checked executable
    :: %~2  name of result variable
  
    if not exist "%~1" (
        @echo [ERROR] not exist: '%~1'
        exit /b 1
    )
    if "%~2" == "" (
        @echo [ERROR] 'variable name' not specified
        exit /b 1
    )
    call "%~dp0init.bat"
    if errorlevel 1 (
        @echo [ERROR] 7z not found
        exit /b 1
    )

    set "%~2="
    for /f "usebackq tokens=1,2,3" %%a in (
        `7z.exe l "%~1" ^| findstr CPU`
    ) do (
        call set "%~2=%%c"
    )
exit /b 0

rem ============================================================================
rem ============================================================================
