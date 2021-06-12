@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    if defined eVERSION (exit /b)
    if defined eDEBUG (@echo [DETECTED] version of project)

    call :loadProjectSettings
        if errorlevel 1 (goto :failed)

    call :detectFileVersion
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

:getVersionNum
    for /F "tokens=1,2,3 delims=. " %%a in ("%~2") do (
        set "%~1=%%~a.%%~b.%%~c"
    )
exit /b

:makeVersion
    set "matched="
    for /F "tokens=*" %%a in ('@echo %value% ^| findstr /rc:".*\..*\..*"') do (
        set "matched=ON"
    )
    if defined matched (
        if defined eDEBUG (@echo   analyse: "%value%")
        set "eVERSION=%value: =%"
    ) else (
        if defined eDEBUG (
            @echo [WARNING] not found: "%value%"
            @echo [WARNING] used version: 0.0.0"
        )
        set "eVERSION=0.0.0"
    )
exit /b

:viewError
    @echo [ERROR] can`t open file
    @echo [ERROR] "%eDIR_SOURCE%\project.root"
exit /b 1

:getVersionTag
    if defined %~1 exit /b
    for /F "tokens=1,2,3 delims= " %%a in ("%~2") do (
        set "%~1=%%~c"
    )
exit /b

:parseFileVersion
    if defined eVERSION (exit /b)
    if not defined file_version (
        @echo [WARNING] version`s file not found
        @echo [WARNING] used version: 0.0.0
        set "eVERSION=0.0.0"
        exit /b
    )
    call :normalizePath file_version "%file_version%"

    if not exist "%file_version%" (
        @echo [ERROR] not found: file_version
        @echo [ERROR] file_version: %file_version%
        exit /b 1
    )
    if not defined eDEBUG (goto :begin)
    @echo   parse: %file_version%
:begin
    set "major="
    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_MAJOR" "%file_version%"') do (
        call :getVersionTag major "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    set "minor="
    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_MINOR" "%file_version%"') do (
        call :getVersionTag minor "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    set "patch="
    for /F "tokens=*" %%a in ('findstr /rc:"#define .*_PATCH" "%file_version%"') do (
        call :getVersionTag patch "%%~a"
    )
    if errorlevel 1 (goto :viewError)

    set "eVERSION=ver-%major%.%minor%.%patch%"
exit /b

:checkFileVersion
    call :isAbsolute "is_absolute_path" "%value%"
    if defined is_absolute_path (
        if not exist "%value%" (
            @echo [ERROR] absolute path not exist
            @echo [ERROR] %value%
            exit /b 1
        )
        set "file_version=%value%"
        exit /b
    )
    if exist "%eDIR_SOURCE%\include\%eNAME_PROJECT%\%value%" (
        set "file_version=%eDIR_SOURCE%\include\%eNAME_PROJECT%\%value%"
        exit /b
    )
    if exist "%eDIR_SOURCE%\%value%" (
        set "file_version=%eDIR_SOURCE%\%value%"
        exit /b
    )

    set "matched="
    for /F "tokens=*" %%a in ('@echo %value% ^| findstr /rc:".*\..*\..*"') do (
        set "matched=ON"
    )

    if not defined matched (
        @echo [ERROR] relative path not found
        @echo [ERROR] relative path: %value%
        exit /b 1
    )

    set "eVERSION=%value: =%"
    if defined eDEBUG (@echo   detect: %eVERSION%)
exit /b

:checkFileExist
    if exist "%~1\%~2" (
        set "file_version=%~1\%~2"
        exit /b 0
    )
    if not defined eDEBUG (
        if defined file_version (exit /b 0)
        exit /b 1
    )
    if not defined file_version (
        @echo missed: %~1\%~2
        exit /b 1
    )
    @echo found: %~1\%~2
exit /b 0

:detectFileVersion
    set "file_version="
    if defined value (
        if defined eDEBUG (@echo checkFileVersion ...)
        call :checkFileVersion
        exit /b
    )

    if defined eDEBUG (@echo checkFileExist ...)

    set "dir=%eDIR_SOURCE%\include\%eNAME_PROJECT%"
    (call :checkFileExist "%dir%" "%eNAME_PROJECT%.ver") || (
     call :checkFileExist "%dir%" "%eNAME_PROJECT%_version.hpp") || (
     call :checkFileExist "%dir%" "version_%eNAME_PROJECT%.hpp") || (
     call :checkFileExist "%dir%" "%eNAME_PROJECT%.hpp") 
exit /b 0

:loadProjectSettings
    if not exist "%eDIR_SOURCE%\project.root" (exit /b)
    rem @echo [LOAD] project.root
    set "value="
    set "file=%eDIR_SOURCE%\project.root"
    for /F "tokens=*" %%a in ('findstr /pvrc:".*#.*" "%file%" ^| findstr /prc:"VERSION"') do (
        call :getValue "%%~a"
    )
    if errorlevel 1 (goto :viewError)
exit /b

:getValue
    for /F "tokens=1,2 delims==" %%a in ("%~1") do (
        call :trim value %%~b
    )
exit /b

rem ============================================================================
rem ============================================================================

:isAbsolute
    setlocal
    set "RETVAL=%~2"
    set "front_two=%RETVAL:~1,1%"
    if "%front_two%" == ":" (
        endlocal & set "%~1=1"
    ) else (
        endlocal & set "%~1="
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

