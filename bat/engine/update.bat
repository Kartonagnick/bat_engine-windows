@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================

:main
    setlocal
    @echo [UPDATE] start ...

    set "filename=%~1"
    if not defined filename (
rem        @echo [ENGINE] computer : %computername%
rem        @echo [ENGINE] user     : %username%
        set "filename=%~dp0_cache\settings_%computername%_%username%.bat"
    )

    @echo   settings_%computername%_%username%.bat ...

    call :initUpdate         || goto :failed
    call :saveProlog         || goto :failed
    call :saveGeneralPaths   || goto :failed
    call :scanDirectory "%eDIR_BAT_SCRIPTS%" || goto :failed
    call :makeDefault        || goto :failed
    call :saveDefault        || goto :failed
    call :saveDefaultProject || goto :failed
:success
    @echo [UPDATE] done!
    exit /b

:failed
    @echo [FAILED] 
exit /b 1

rem ............................................................................

:initUpdate
    call :findWorkspace
    if defined eDIR_WORKSPACE (
        set "eDIR_BAT_SCRIPTS=%eDIR_WORKSPACE%\scripts\bat"
    ) else (
        @echo [WARNING] path to 'WorkSpace' not found
        call :normalizePath eDIR_BAT_SCRIPTS "%~dp0.."
    )    
    set "eDIR_BAT_ENGINE=%eDIR_BAT_SCRIPTS%\engine"

    @echo [general]

    if defined eDIR_WORKSPACE (
        @echo   [eDIR_WORKSPACE] ..... %eDIR_WORKSPACE%
    )
    @echo   [eDIR_BAT_SCRIPTS] ... %eDIR_BAT_SCRIPTS%
    @echo   [eDIR_BAT_ENGINE] .... %eDIR_BAT_ENGINE%

exit /b 0

rem ............................................................................

:saveSepparator
    @echo rem ......................................................................... >> "%filename%"
exit /b

rem ............................................................................

:saveProlog
    if not exist "%filename%\.." (mkdir "%filename%\.." >nul 2>nul)
    @echo. > "%filename%"
    @echo @echo off > "%filename%"
    @echo if defined ENGINE_ALREADY_INITIALIZED (exit /b) >> "%filename%"
    @echo set "ENGINE_ALREADY_INITIALIZED=yes" >> "%filename%"
    if errorlevel 1 (@echo [ERROR] can not write: "%filename%")
exit /b

rem ............................................................................

:saveGeneralPaths
    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"

    if defined eDIR_WORKSPACE (
        @echo set "eDIR_WORKSPACE=%eDIR_WORKSPACE%" >> "%filename%"
    )
    @echo set "eDIR_BAT_SCRIPTS=%eDIR_BAT_SCRIPTS%" >> "%filename%"
    @echo set "eDIR_BAT_ENGINE=%eDIR_BAT_ENGINE%" >> "%filename%"
    if errorlevel 1 (@echo [ERROR] can not write: "%filename%")
exit /b

:makeDefault
    if defined ProgramFiles(x86) (
        set "eDEFAULT_ADDRESS_MODEL=64"
    ) else (
        set "eDEFAULT_ADDRESS_MODEL=32"
    )

    set "eDEFAULT_COMPILER="

    if defined ProgramFiles(x86) (
        if defined eMINGW_64_LAST (set "eDEFAULT_COMPILER=mingw%eMINGW_64_LAST%")
    ) else (
        if defined eMINGW_32_LAST (set "eDEFAULT_COMPILER=mingw%eMINGW_32_LAST%")
    )

    if defined ProgramFiles(x86) (
        if defined eMSVC_64_LAST (set "eDEFAULT_COMPILER=msvc%eMSVC_64_LAST%")
    ) else (
        if defined eMSVC_32_LAST (set "eDEFAULT_COMPILER=msvc%eMSVC_32_LAST%")
    )

    if not defined eDEFAULT_COMPILER (
        @echo [ERROR] compiler not found
        exit /b 1
    )
exit /b

rem ............................................................................

:saveDefault
    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"

    @echo set "eALL_COMPILERS=msvc mingw" >> "%filename%"

    if defined ProgramFiles(x86) (
        @echo set "eALL_ADDRESS_MODELS=64 32" >> "%filename%"
    ) else (
        @echo set "eALL_ADDRESS_MODELS=32" >> "%filename%"
    )

    @echo set "eALL_BUILD_TYPES=release debug" >> "%filename%"
    @echo set "eALL_RUNTIME_CPPS=dynamic static" >> "%filename%"

    if errorlevel 1 (@echo [ERROR] can not write: "%filename%")
exit /b

rem ............................................................................

:saveDefaultProject

    if defined eDIR_WORKSPACE (
        set "d_root={DIR_WORKSPACE}"
    ) else (
        set "d_root={DIR_OWNER}"
    )

    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"
    @echo set "eBUILD_ID=%%CI_PIPELINE_ID%%" >> "%filename%"

    @echo if defined eBUILD_ID ( >> "%filename%"
    @echo   set "eBUILD_ID=ID-%%eBUILD_ID%%" >> "%filename%"
    @echo ) >> "%filename%"
    @echo. >> "%filename%"

    call :saveSepparator
    @echo. >> "%filename%"

    @echo if not defined eDIR_BUILD ( >> "%filename%"
    @echo   set "eDIR_BUILD=%d_root%\_build\{NAME_PROJECT}\{VERSION}\{BUILD_ID}" >> "%filename%"
    @echo ) >> "%filename%"
    @echo. >> "%filename%"

    @echo if not defined eDIR_PRODUCT ( >> "%filename%"
    @echo   set "eDIR_PRODUCT=%d_root%\_products\{NAME_PROJECT}\{VERSION}\{BUILD_ID}" >> "%filename%"
    @echo ) >> "%filename%"
    @echo. >> "%filename%"

    @echo if not defined eSUFFIX ( >> "%filename%"
    @echo   set "eSUFFIX={COMPILER_TAG}-{BUILD_TYPE}-{ADDRESS_MODEL}-{RUNTIME_CPP}/{TARGET_TYPE}-{TARGET_NAME}" >> "%filename%"
    @echo ) >> "%filename%"
    @echo. >> "%filename%"

    @echo if not defined eCOMPILER_TAG  (set "eCOMPILER_TAG=msvc"  ) >> "%filename%"
    @echo if not defined eBUILD_TYPE    (set "eBUILD_TYPE=release" ) >> "%filename%"
    @echo if not defined eADDRESS_MODEL (set "eADDRESS_MODEL=64"   ) >> "%filename%"
    @echo if not defined eRUNTIME_CPP   (set "eRUNTIME_CPP=dynamic") >> "%filename%"
    @echo. >> "%filename%"

    call :saveSepparator

exit /b

rem ============================================================================
rem ============================================================================

:scanDirectory
    @echo [scan] '%~1'
    set "ePATH="
    for /D %%a  in ("%~1\*") do (
        call :updateTarget "%%~a"
    )

    if not defined ePATH (
        @echo [WARNING] 'ePATH' empty
        exit /b
    )
    set "ePATH=%ePATH:~0,-1%"
    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"
    @echo set "PATH=%ePATH%;%%PATH%%" >> "%filename%"
    if errorlevel 1 (@echo [ERROR] can not write: "%filename%")
    call :enumResult
exit /b

:enumResult
    set "enumerator=%items%"
:loopResult
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        for /F "tokens=*" %%a in ("%%a") do (
            @echo set "%%a_ALREADY_INITIALIZED=yes" >> "%filename%"
        )
        set "enumerator=%%b"
    )
    if defined enumerator goto :loopResult
exit /b 

rem ============================================================================
rem ============================================================================

:applyMingw
    set has=
    if defined eMINGW_32_LAST (set has=on)
    if defined eMINGW_64_LAST (set has=on)
    if defined has (set items=%items%;MINGW)
exit /b

:applyMsvc
    set has=
    if defined eMSVC_32_LAST (set has=on)
    if defined eMSVC_64_LAST (set has=on)
    if defined has (set items=%items%;MSVC)
exit /b

:updateTarget
    if "%~n1" == "samples"        (exit /b)
    if "%~n1" == "engine"         (exit /b)
    if not exist "%~1\update.bat" (exit /b)

    call :replace "%~1" "%eDIR_BAT_SCRIPTS%" "" relPath
    @echo   update: %relPath%

    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"

    if errorlevel 1 (
        @echo [ERROR] can not write: "%filename%"     
        exit /b    
    )

    call "%~1\update.bat" "%filename%"
    if errorlevel 1 ( 
        @echo [ERROR] error in: "%~1\update.bat"    
        exit /b 1    
    )

    if "%~n1" == "mingw" (
        call :applyMingw
        exit /b
    )

    if "%~n1" == "msvc" (
        call :applyMsvc
        exit /b
    )

    if defined eDIR_%~n1 (call :addToPath "%~n1")
exit /b

rem ============================================================================
rem ============================================================================

:addToPath
    setlocal
    call :toUpper "%~1" up
    set "var=eDIR_%up%"
    endlocal & (
        set "ePATH=%%%var%%%;%ePATH%"
        set items=%items%;%up%
    )
exit /b

rem ============================================================================
rem ============================================================================

:replace
    setlocal

    set "src=%~1"
    set "old=%~2\"
    set "new=%~3"
    set "var=%~4"

rem    @echo [src] '%src%'
rem    @echo [old] '%old%'
rem    @echo [new] '%new%'
rem    @echo [var] '%var%'

    set "text=%src%"
    call set "text=%%text:%old%=%new%%%"
    endlocal & set "%var%=%text%"
exit /b

rem ============================================================================
rem ============================================================================

:toUpper 
    setlocal
    set "VARIABLE_VALUE=%~1"
    set "VARIABLE_NAME=%~2"

    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        exit /b 1
    )
    if not defined VARIABLE_VALUE (
        call set "%VARIABLE_NAME%="
        exit /b
    )

    for %%j in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
                "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
                "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
    endlocal & call set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
exit /b

rem ============================================================================
rem ============================================================================

:findWorkspace
    if defined eDIR_WORKSPACE (exit /b)
    if not defined eWORKSPACE_SYMPTOMS (
        set "eWORKSPACE_SYMPTOMS=3rd_party;programs"
    ) 
    set "DRIVE=%CD:~0,3%"
    pushd "%CD%"
:loopFindWorkspace
    call :checkWorkspaceSymptoms
    if not errorlevel 1    (goto :findWorkspaceSuccess)
    if "%DRIVE%" == "%CD%" (goto :findWorkspaceFailed )
    cd ..
    goto :loopFindWorkspace
exit /b

:findWorkspaceSuccess
    set "eDIR_WORKSPACE=%CD%"
    popd
exit /b 

:findWorkspaceFailed
    popd
exit /b 1

rem ............................................................................

:checkWorkspaceSymptoms
    set "enumerator=%eWORKSPACE_SYMPTOMS%"
:loopWorkspaceSymptoms
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        for /F "tokens=*" %%a in ("%%a") do (
            if not exist "%CD%\%%a" exit /b 1
        )
        set "enumerator=%%b"
    )
    if defined enumerator goto :loopWorkspaceSymptoms
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

rem ============================================================================
rem ============================================================================

:checkParent
    if not defined eDIR_OWNER (
        @echo off & cls & @echo. & @echo.
        call :normalizePath eDIR_OWNER "%~dp0"
    )
exit /b 

rem ============================================================================
rem ============================================================================
