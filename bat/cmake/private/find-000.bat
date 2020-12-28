@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_CMAKE="
    if not defined eDIR_WORKSPACE (set "eDIR_WORKSPACE=C:\_0_._0_")

    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_CMAKE=%eDIR_CMAKE%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x64\CMake\bin
    set PATH_ARRAY[2]=C:\Program Files\CMake\bin
    set PATH_ARRAY[3]=%eDIR_WORKSPACE%\programs\x86\CMake\bin
    set PATH_ARRAY[4]=C:\Program Files (x86)\CMake\bin
    set PATH_ARRAY[5]=...end...
    call :findProgram PATH_ARRAY eDIR_CMAKE cmake.exe
exit /b

:findProgram32
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x86\CMake\bin
    set PATH_ARRAY[2]=C:\Program Files\CMake\bin
    set PATH_ARRAY[3]=...end...
    call :findProgram PATH_ARRAY eDIR_CMAKE cmake.exe
exit /b

:findProgram
    set "index=1"
    set "arr=%~1"
    set "res=%~2"
    set "symptom=%~3"
:findProgramLoop
    call set "value=%%%arr%[%index%]%%"
    if "%value%" == "" (goto :findProgramLoopNext)
    if "%value%" == "...end..." exit /b
    if exist "%value%\%symptom%" (
        call set "%res%=%value%" 
        exit /b
    ) 
rem    @echo missing : "%value%\%symptom%"
:findProgramLoopNext
    set /a "index=%index%+1"
goto :findProgramLoop

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

