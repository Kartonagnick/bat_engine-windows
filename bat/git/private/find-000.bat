@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "eDIR_GIT="
    if defined ProgramFiles(x86) (
        call :findProgram64
    ) else (
        call :findProgram32
    )
    endlocal & set "eDIR_GIT=%eDIR_GIT%"
exit /b 0

rem ============================================================================
rem ============================================================================

:findProgram64
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x64\Git\bin
    set PATH_ARRAY[2]=%eDIR_WORKSPACE%\programs\x64\SmartGit\git\bin
    set PATH_ARRAY[3]=C:\Program Files\Git\bin
    set PATH_ARRAY[4]=C:\Program Files\SmartGit\git\bin
    set PATH_ARRAY[5]=%eDIR_WORKSPACE%\programs\x86\Git\bin
    set PATH_ARRAY[6]=C:\Program Files (x86)\Git\bin
    set PATH_ARRAY[7]=%eDIR_WORKSPACE%\programs\x86\SmartGit\git\bin
    set PATH_ARRAY[8]=C:\Program Files (x86)\SmartGit\git\bin
    set PATH_ARRAY[9]=...end...
    call :findProgram PATH_ARRAY eDIR_GIT git.exe
exit /b

:findProgram32
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x86\Git\bin
    set PATH_ARRAY[2]=%eDIR_WORKSPACE%\programs\x86\SmartGit\git\bin
    set PATH_ARRAY[3]=C:\Program Files\Git\bin
    set PATH_ARRAY[4]=C:\Program Files\SmartGit\git\bin
    set PATH_ARRAY[5]=...end...
    call :findProgram PATH_ARRAY eDIR_GIT git.exe
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
    call :normalizePath "%~dp0..\..\..\.."
exit /b

:normalizePath
    if defined eDIR_WORKSPACE (exit /b)
    set "eDIR_WORKSPACE=%~dpfn1"
exit /b

rem ============================================================================
rem ============================================================================

