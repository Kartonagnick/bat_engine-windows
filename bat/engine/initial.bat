@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================
:main
    setlocal
    set "eDIR_7Z=C:\Program Files\7-Zip"
    set "eDIR_GIT1=C:\Program Files\Git\bin"
    set "eDIR_GIT2=C:\Program Files\SmartGit\git\bin"
    set "PATH=%eDIR_7Z%;%eDIR_GIT1%;%eDIR_GIT2%;%PATH%"

    @echo [INITIAL] begin...
    @echo [WARNING] functionality closed for revision
    goto :failed

    call :normalizePath dir_root "%~dp0..\.."
    call :normalizePath eDIR_LOADED "%~dp0_cache"

    set "eDIR_COMMANDS=%dir_root%\cmd"
    set "eDIR_MINIMALIST=%dir_root%\cmake\minimalist"

    set "eDIR_BAT_GIT=%dir_root%\bat\git"
    set "eDIR_BAT_7Z=%dir_root%\bat\7z"

    @echo [eDIR_COMMANDS] ..... %eDIR_COMMANDS%
    @echo [eDIR_MINIMALIST] ... %eDIR_MINIMALIST%
    rem @echo [eDIR_BAT_GIT] ...... %eDIR_BAT_GIT%
    rem @echo [eDIR_BAT_7Z] ....... %eDIR_BAT_7Z%
    @echo [eDIR_LOADED] ....... %eDIR_LOADED%

    call "%eDIR_BAT_GIT%\init.bat"
    if errorlevel 1 (goto :failed)

    call "%eDIR_BAT_7Z%\init.bat"
    if errorlevel 1 (goto :failed)

    call :prepareDirClone
    if errorlevel 1 (goto :failed)

    call :cloneCommands
    if errorlevel 1 (goto :failed)

    call :cloneCmakeMinimalist
    if errorlevel 1 (goto :failed)

    call :installCmakeMinimalist
    if errorlevel 1 (goto :failed)

    call :installCommands
    if errorlevel 1 (goto :failed)

    call :updateEngine
    if errorlevel 1 (goto :failed)

:success
    @echo [INITIAL] completed successfully
exit /b 0

:failed
    @echo [INITIAL] finished with erros
exit /b 1

:cloneCommands
    @echo.
    git clone "--recursive" ^
        "https://github.com/Kartonagnick/cmd-windows.git" ^
        "%eDIR_LOADED%\cmd"
exit /b

:cloneCmakeMinimalist
    @echo.
    git clone "--recursive" ^
        "https://github.com/Kartonagnick/cmake-minimalist.git" ^
        "%eDIR_LOADED%\cmake-minimalist"
exit /b

:installCmakeMinimalist
    @echo.
    @echo --------------------------------------------------[Minuimalist]----
    set "from=%eDIR_LOADED%\cmake-minimalist\minimalist"
    set "to=%eDIR_MINIMALIST%"
    @echo [copy] minimalist
    @echo   from: %from%
    @echo   to:   %to%
    xcopy /y /s /e /i "%from%" "%to%"\ >nul 2>nul
    if errorlevel 1 (@echo [ERROR] 'xcopy' failed)
exit /b

:installCommands
    @echo.
    @echo --------------------------------------------------[Cmd]------------
    set "eDIR_ARCHIVE=%eDIR_LOADED%\cmd\archive"
    if not exist "%eDIR_ARCHIVE%" (
        @echo [ERROR] not found: 'eDIR_LOADED%\cmd\archive' 
        @echo [ERROR] "%eDIR_ARCHIVE%"
        exit /b 1
    )
    set "archiveName="
    pushd "%eDIR_ARCHIVE%"
    for /F %%a in ('dir /b /a:-d /o:d /t:c *.7z') do (
        set "archiveName=%%~a"
    )
    popd

    if not defined archiveName (
        @echo [ERROR] archive.7z not found
        @echo [ERROR] check: eDIR_LOADED%\cmd\archive
        @echo [ERROR] "%eDIR_ARCHIVE%"
        exit /b 1
    )

    set "archive=%eDIR_ARCHIVE%\%archiveName%"
    call :unpackArchive "%archive%" "%eDIR_COMMANDS%"
exit /b

:unpackArchive
    set "archiveName=%~1"
    set "destDirectory=%~2"
    7z.exe x -y -r "%archiveName%" -o"%destDirectory%"
exit /b 

:prepareDirClone
    if exist "%eDIR_LOADED%" (rd /S /Q "%eDIR_LOADED%")
    if errorlevel 1 (
        @echo [ERROR] can not remove 'eDIR_LOADED'
        @echo [ERROR] check: "%eDIR_LOADED%"
        exit /b 1
    )
exit /b

:updateEngine
    @echo.
    call "%~dp0update.bat"  
    if errorlevel 1 (
        @echo [ERROR] 'update.bat' finished with errors
        exit /b 1
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

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off & cls &  @echo. &  @echo.
        set "eDIR_OWNER=%~dp0"
    )
exit /b

rem ============================================================================
rem ============================================================================

