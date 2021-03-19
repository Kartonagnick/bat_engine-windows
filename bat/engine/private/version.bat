@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    setlocal
    if defined eDEBUG (@echo [DETECTED] version of project)
    if defined eVERSION (exit /b)

    call :loadProjectSettings
    if errorlevel 1 (goto :failed)

    call :parseFileVersion
    if errorlevel 1 (goto :failed)

:success
    endlocal & set "eVERSION=%eVERSION%"
    @echo   version: %eVERSION%
exit /b 0

:failed
    @echo [ERROR] can`t determine version of project
    @echo [ERROR] check: 'eDIR_SOURCE\project.root'
exit /b 1

:viewError
    @echo [ERROR] can`t open file
    @echo [ERROR] "%eDIR_SOURCE%\project.root"
exit /b 1

:getVersionNum
    for /F "tokens=1,2,3 delims=. " %%a in ("%~2") do (
        set "%~1=%%~a.%%~b.%%~c"
    )
exit /b

:makeVersion
    if defined eDEBUG (@echo   analyse: "%value%")
    set matched=
    for /F "tokens=*" %%a in ('@echo %value% ^| findstr /rc:".*\..*\..*"') do (
        set matched=ON
    )
    if defined matched (
        set "eVERSION=%value: =%"
    ) else (
        set "eVERSION=0.0.0"
    )
exit /b

:parseFileVersion
    if not defined value (exit /b)

    call :normalizePath file "%eDIR_SOURCE%\%value%"

    rem set "file=%eDIR_SOURCE%\%value%"
    if not exist "%file%" (
        if not exist "%eDIR_SOURCE%\include\%eNAME_PROJECT%\%value%" (
            call :makeVersion 
            exit /b
        )
        set "file=%eDIR_SOURCE%\include\%eNAME_PROJECT%\%value%"
    )

    if not defined eDEBUG (goto :begin)
    @echo   parse: %file%
:begin
    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_MAJOR" "%file%"') do (
        call :getVersionTag major "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_MINOR" "%file%"') do (
        call :getVersionTag minor "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_PATCH" "%file%"') do (
        call :getVersionTag patch "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    set "eVERSION=ver-%major%.%minor%.%patch%"
exit /b

:getVersionTag
    for /F "tokens=1,2,3 delims= " %%a in ("%~2") do (
        set "%~1=%%~c"
    )
exit /b

:loadProjectSettings
    if not exist "%eDIR_SOURCE%\project.root" (exit /b)
    rem @echo [LOAD] project.root
    set "val="
    set "file=%eDIR_SOURCE%\project.root"
    for /F "tokens=*" %%a in ('findstr /pvrc:".*#.*" "%file%" ^| findstr /prc:"VERSION"') do (
        call :getValue "%%~a"
    )
    if errorlevel 1 (goto :viewError)
exit /b

:getValue
    set "value="
    for /F "tokens=1,2 delims==" %%a in ("%~1") do (
        call :trim value %%~b
    )
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
    if not defined eDIR_SOURCE (
        @echo [ERROR] 'eDIR_SOURCE' must be specified
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

