@echo off
call :checkParent
if errorlevel 1 (exit /b)

rem 1.   if empty arguments ---> update
rem 2.   parse command
rem 2.1    if command is 'version' ---> print version and exit
rem 2.2    if command is 'update' ---> update
rem 3.   check command exists
rem 4.   load settings
rem 4.1    if settings no exist ---> update
rem 5.   parse arguments
rem 6.   call %command%.bat

rem ============================================================================
rem ============================================================================
:main
    set "eVERSION_BAT_ENGINE=0.0.9"

    if "%~1" == "" (
        call :viewVersion
        goto :update
    )

    call :parseCommand "%~1"

    if "%eCOMMAND%" == "version" (
        @echo %eVERSION_BAT_ENGINE%
        exit /b
    )
    call :viewVersion
    if "%eCOMMAND%" == "update"  (goto :update)
    if not exist "%~dp0private\%eCOMMAND%.bat" (
        @echo [ERRROR] unknown command: '%eCOMMAND%'
        goto failed
    )

    call "%~dp0settings.bat"
    if errorlevel 1 (goto failed)

    if "%eDEBUG%" == "ON" (@echo   command: %eCOMMAND%)

    if "%eDEBUG%" == "ON" (@echo [PARSE ARGUMENTS])
    call :parseArguments %*

    call "%~dp0private\%eCOMMAND%.bat"
    if errorlevel 1 (goto failed)

:success
    @echo [ENGINE] completed successfully
exit /b 0

:failed
    @echo [ENGINE] finished with erros
exit /b 1

:viewVersion
    @echo [ENGINE] version %eVERSION_BAT_ENGINE%
exit /b

:update
    call :updateEngine
    if errorlevel 1 (goto failed)
    goto success
:updateEngine
    call "%~dp0update.bat" "%main_settings%" 
    if errorlevel 1 (
        @echo [ERROR] 'update.bat' finished with errors
        exit /b 1
    )
exit /b

:parseCommand
    setlocal
    set "key="
    set "val="
    for /f "tokens=1* delims=:" %%a in (%*) do (
        set "key=%%~a"
        set "val=%%~b"
    )
    call :trimLeft key %key%
    call :trim     val %val%
    rem @echo [eCOMMAND ] %key%
    rem @echo [eARGUMENT] %val%
    endlocal & set "eCOMMAND=%key%" & set "eARGUMENT=%val%" 
exit /b

:parseArgument
    setlocal
    set "key="
    set "val="
    for /f "tokens=1* delims=: " %%a in (%*) do (
        set "key=%%~a"
        set "val=%%~b"
    )
    call :trimLeft key %key%
    call :toUpper  key %key%
    call :trim     val %val%

    if not "%key%" == "SUFFIX" (
        call "%~dp0private\expand.bat" "%val%" "val"
    )

    set need_normalize=
    if "%key%" == "DIR_PRODUCT" (set need_normalize=true)
    if "%key%" == "DIR_BUILD"   (set need_normalize=true)
    if "%key%" == "DIR_SOURCES" (set need_normalize=true)
    if "%key%" == "DIR_PROJECT" (set need_normalize=true)

    if defined need_normalize (
        call "%eDIR_BAT_SCRIPTS%\tools\normalize.bat" val "%val%"
    )

    if "%eDEBUG%" == "ON" (@echo   arg: e%key% = %val%)
    endlocal & call set "e%key%=%val%"
exit /b

:parseArguments
    if "%~1" == "" exit /b
    call :parseArgument "%~1"
    shift
    goto :parseArguments
exit /b

rem ============================================================================
rem ============================================================================

:toUpper 
    setlocal
    set "VARIABLE="
    set "VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE=%%a"
        set "VALUE=%%b"
    )

    if not defined VARIABLE (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        exit /b 1
    )
    if not defined VALUE (set "%VARIABLE%=" & exit /b)

    for %%j in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
                "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
                "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") do (
        call set "VALUE=%%VALUE:%%~j%%"
    )
    endlocal & set "%VARIABLE%=%VALUE%"
exit /b

rem ============================================================================
rem ============================================================================

:trimLeft
    setlocal
    set "VARIABLE="
    set "VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE=%%a"
        set "VALUE=%%b"
    )
:trimLeftNext
    set "first=%VALUE:~0,1%"
    if "%first%" == "-" (
        set "VALUE=%VALUE:~1%"
        goto :trimLeftNext
    )
    if "%first%" == " " (
        set "VALUE=%VALUE:~1%"
        goto :trimLeftNext
    )
    endlocal & set "%VARIABLE%=%VALUE%"
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
    if not defined eDIR_OWNER (
        cls
        @echo.
        @echo.
        set "eDIR_OWNER=%~dp0"
    )
exit /b

rem ============================================================================
rem ============================================================================

