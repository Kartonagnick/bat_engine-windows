@echo off
call :checkParent
if errorlevel 1 (exit /b)

rem 1.   parse command
rem 1.1.   empty command ---> update
rem 2.   if command is 'version' ---> print version and exit
rem 2.   if command is 'update' ----> update
rem 2.   if command is 'initial' ---> initial
rem 3.   check command exists
rem 4.   load settings
rem 4.1    if settings no exist ---> create it
rem 5.   parse arguments
rem 6.   detect source directory
rem 7.   adjust arguments
rem 8.   call %command%.bat

rem ============================================================================
rem ============================================================================
:main
    set "eBAT_VERSION=0.9.0" 
    call :parseCommand "%~1"

    if "%eCOMMAND%" == "version" (
        @echo %eBAT_VERSION% 
        exit /b
    )
    call :viewVersion

    if "%eCOMMAND%" == "update"  (goto :update )
    if "%eCOMMAND%" == "initial" (goto :initial)

    if not exist "%~dp0private\%eCOMMAND%.bat" (
        @echo [ERROR] unknown command: '%eCOMMAND%'
        goto failed
    )

    if not defined eDEBUG (goto :mainSettings)
    @echo [WORKSPACE]
    @echo   '%eDIR_WORKSPACE%'

:mainSettings
    call "%~dp0private\settings.bat"
    if errorlevel 1 (goto failed)

    if not defined eDEBUG (goto :mainStage)
    @echo   command: %eCOMMAND%
    @echo [PARSE ARGUMENTS]
:mainStage
    call :parseArguments %*
    if errorlevel 1 (goto failed)

    call "%~dp0private\detect.bat"
    if errorlevel 1 (goto failed)

    call "%~dp0private\version.bat"
    if errorlevel 1 (goto failed)

    call :ajustParams 
    if errorlevel 1 (goto failed)

    call "%~dp0private\%eCOMMAND%.bat"
    if errorlevel 1 (goto failed)
:success
    @echo [ENGINE] completed successfully
exit /b 0

:failed
    @echo [ENGINE] finished with erros
exit /b 1

:viewVersion
    @echo [ENGINE] version %eBAT_VERSION%
exit /b

rem ............................................................................

:update
    call :updateEngine
    if errorlevel 1 (goto failed)
    goto success
:updateEngine
    call "%~dp0update.bat" 
    if errorlevel 1 (
        @echo [ERROR] 'update.bat' finished with errors
        exit /b 1
    )
exit /b

rem ............................................................................

:initial
    call :initialEngine
    if errorlevel 1 (goto failed)
    goto success
:initialEngine
    call "%~dp0initial.bat"
    if errorlevel 1 (
        @echo [ERROR] 'initial.bat' finished with errors
        exit /b 1
    )
exit /b

rem ............................................................................

:parseCommand
    if "%~1" == "" (set "eCOMMAND=update" & exit /b)

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

    if "%eDEBUG%" == "ON" (@echo   arg: e%key% = %val%)

    if "%key%" == "DEFINES" (
        endlocal & (set "args_[DEFINES]=%args_[DEFINES]%;%val%")
        exit /b   
    )

    if "%key%" == "SUFFIX" (
        endlocal & set "eSUFFIX=%val%"
    ) else (
        endlocal & set "args_[%key%]=%val%"
    )
exit /b

:parseArguments
    if "%~1" == "" exit /b
    call :parseArgument "%~1"
    shift
    goto :parseArguments
exit /b

rem ============================================================================
rem ============================================================================

:ajustParam
    rem @echo debug-ajust: [%~1]
    set "var=e%~1"
    call set "val=%%args_[%~1]%%"
    call "%~dp0private\expand.bat" "e%~1" "%val%"

    call set "val=%%e%~1%%"
    call :normalizePath "e%~1" "%val%"
    rem call set "val=%%e%~1%%"
    rem @echo (debug)...[arg][%~1][%val%]
exit /b 

:ajustOffParam
    set "args_[%~1]="
exit /b 

:ajustAllParams
    call "%~dp0private\expand.bat" "eNAME_PROJECT" "%eNAME_PROJECT%"
    call "%~dp0private\expand.bat" "eDIR_SOURCE"   "%eDIR_SOURCE%" 
    call "%~dp0private\expand.bat" "eDIR_PROJECT"  "%eDIR_PROJECT%" 
    call "%~dp0private\expand.bat" "eDIR_PRODUCT"  "%eDIR_PRODUCT%" 
    call "%~dp0private\expand.bat" "eDIR_BUILD"    "%eDIR_BUILD%"   
    call "%~dp0private\expand.bat" "eVERSION"      "%eVERSION%"   

    call :normalizePath eNAME_PROJECT  "%eNAME_PROJECT%"
    call :normalizePath eDIR_SOURCE    "%eDIR_SOURCE%"
    call :normalizePath eDIR_PROJECT   "%eDIR_PROJECT%"
    call :normalizePath eDIR_PRODUCT   "%eDIR_PRODUCT%"
    call :normalizePath eDIR_BUILD     "%eDIR_BUILD%"
    call :normalizePath eVERSION       "%eVERSION%"
    rem call :normalizePath eSUFFIX        "%eSUFFIX%"
exit /b

:ajustParams 
    for /F "usebackq tokens=2 delims=[]" %%a in (`set "args_[" 2^>nul`) do (
        call :ajustParam "%%~a" 
    )
    for /F "usebackq tokens=2 delims=[]" %%a in (`set "args_[" 2^>nul`) do (
        call :ajustOffParam "%%~a" 
    )
    call :ajustAllParams

    if not defined eNAME_PROJECT (@echo [ERROR] 'eNAME_PROJECT' not specified & exit /b 1)
    if not defined eDIR_SOURCE   (@echo [ERROR] 'eDIR_SOURCE' not specified & exit /b 1)
    rem if not defined eDIR_PROJECT  (@echo [WARNING] 'eDIR_PROJECT' not specified & exit /b 1)
    if not defined eDIR_PRODUCT  (@echo [ERROR] 'eDIR_PRODUCT' not specified & exit /b 1)
    if not defined eDIR_BUILD    (@echo [ERROR] 'eDIR_BUILD' not specified & exit /b 1)
    if not defined eSUFFIX       (@echo [WARNING] 'eSUFFIX' not specified)
    rem if not defined eVERSION  (@echo [WARNING] 'eVERSION' not specified & exit /b 1)

    if not defined eDEBUG (exit /b)

    @echo [AJUST PARAMS]
    @echo   [eNAME_PROJECT] ... %eNAME_PROJECT%
    @echo   [eDIR_SOURCE] ..... %eDIR_SOURCE%
rem @echo   [eDIR_PROJECT] .... %eDIR_PROJECT%
    @echo   [eDIR_PRODUCT] .... %eDIR_PRODUCT%
    @echo   [eDIR_BUILD] ...... %eDIR_BUILD%
    @echo   [eVERSION] ........ %eVERSION%
    @echo   [eSUFFIX] ......... %eSUFFIX%
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

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        cls & @echo. & @echo.
        set "eDIR_OWNER=%~dp0."
    )
    call :normalizePath eDIR_OWNER "%eDIR_OWNER%"
exit /b

rem ============================================================================
rem ============================================================================

