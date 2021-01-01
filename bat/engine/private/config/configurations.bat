@echo off
rem ============================================================================
rem ============================================================================
:main
    if errorlevel 1 (
        @echo [ERROR] started with errors
        exit /b 1
    )
    call :pepareCompilersTags
    if errorlevel 1 (exit /b 1)

    setlocal
    set "RESULT_VARIABLE_NAME=%~1"
    set "INPUT_CONFIGURATIONS=%~2"

    if not defined RESULT_VARIABLE_NAME (
        @echo [ERROR] 'variable name' not specified
        exit /b 1
    )

    rem call :debugInputParams   
    call :trim INPUT_CONFIGURATIONS %INPUT_CONFIGURATIONS%
    if not defined INPUT_CONFIGURATIONS (set "INPUT_CONFIGURATIONS=all")

    set "OUTPUT_CONFIGURATIONS="
    call :enumerateConfigurations "%INPUT_CONFIGURATIONS%"

    if not defined OUTPUT_CONFIGURATIONS (
        @echo [WARNING] empty result
        endlocal & set "%RESULT_VARIABLE_NAME%="
        exit /b
    )

    set "front=%OUTPUT_CONFIGURATIONS:~0,1%"
    if "%front%" == ";" (set "OUTPUT_CONFIGURATIONS=%OUTPUT_CONFIGURATIONS:~1%")

    endlocal & set "%RESULT_VARIABLE_NAME%=%OUTPUT_CONFIGURATIONS%"
exit /b

rem ============================================================================
rem ============================================================================

:debugInputParams
    @echo.
    @echo [debug input params]
    @echo   [INPUT_CONFIGURATIONS] ... '%INPUT_CONFIGURATIONS%'
    @echo   [RESULT_VARIABLE_NAME] ... '%RESULT_VARIABLE_NAME%'
exit /b

rem ============================================================================
rem ============================================================================

:concatString
    rem %~1 variable
    rem %~2 prefix
    rem %~3 value
    if defined %~1 (
        call set "%~1=%%%~1%% %~2%~3"
    ) else (
        call set "%~1=%~2%~3"
    )
exit /b

:addPrefixTo
    rem %~1 prefix
    rem %~2 input name
    rem %~3 output name
    call set "conf_values=%%%~2%%"

    if not defined conf_values (exit /b)

    for %%a in (%conf_values%) do (set conf_prefix_[%%a]=dimmy)
    for /F "tokens=2 delims=[]" %%a in ('set conf_prefix_[') do (
        call :concatString %~3 "%~1" "%%~a"
    )
    for %%a in (%conf_values%) do (set conf_prefix_[%%a]=)
    set "conf_values="
exit /b

:pepareCompilersTags
    rem example:
    rem   input : 810 730
    rem   output: mingw810 mingw730

    if defined ALREADY_CONFIG_TAGS_PREPARED (exit /b) 
    set "ALREADY_CONFIG_TAGS_PREPARED=yes"

    set "ePATH_BAT_ENGINE_SETTINGS=%~dp0..\..\settings.bat"

    if not exist "%ePATH_BAT_ENGINE_SETTINGS%" (
        @echo [FATAL ERROR] not exist: '%ePATH_BAT_ENGINE_SETTINGS%'
        exit /b 1
    )

    call "%ePATH_BAT_ENGINE_SETTINGS%"
    if errorlevel 1 (
        @echo [FATAL ERROR] '%ePATH_BAT_ENGINE_SETTINGS%'
        exit /b 1
    )

    call :addPrefixTo "mingw" eMINGW_64_VERSIONS eMINGW_64_VERSIONS_TAGS 
    call :addPrefixTo "mingw" eMINGW_32_VERSIONS eMINGW_32_VERSIONS_TAGS
    call :addPrefixTo "msvc"  eMSVC_32_VERSIONS  eMSVC_32_VERSIONS_TAGS
    call :addPrefixTo "msvc"  eMSVC_64_VERSIONS  eMSVC_64_VERSIONS_TAGS

    call set "eMINGW_64_LAST_TAG=mingw%eMINGW_64_LAST%"
    call set "eMINGW_32_LAST_TAG=mingw%eMINGW_32_LAST%"

    call set "eMSVC_64_LAST_TAG=msvc%eMSVC_64_LAST%"
    call set "eMSVC_32_LAST_TAG=msvc%eMSVC_32_LAST%"
exit /b
    @echo.
    @echo [debug prepared tags]
    @echo   [eMINGW_64_VERSIONS_TAGS] ... %eMINGW_64_VERSIONS_TAGS%
    @echo   [eMINGW_32_VERSIONS_TAGS] ... %eMINGW_32_VERSIONS_TAGS%
    @echo   [eMSVC_32_VERSIONS_TAGS] .... %eMSVC_32_VERSIONS_TAGS%
    @echo   [eMSVC_64_VERSIONS_TAGS] .... %eMSVC_64_VERSIONS_TAGS%
    @echo.
    @echo   [eMSVC_64_LAST_TAG] ......... %eMSVC_64_LAST_TAG%
    @echo   [eMSVC_32_LAST_TAG] ......... %eMSVC_32_LAST_TAG%
    @echo.
    @echo   [eMINGW_64_LAST_TAG] ........ %eMINGW_64_LAST_TAG%
    @echo   [eMINGW_32_LAST_TAG] ........ %eMINGW_32_LAST_TAG%
    @echo.
exit /b

rem ============================================================================
rem ============================================================================

:enumerateConfigurations
    set "enumerator=%~1"
:loopEnumerateConfigurations
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :processConfiguration "%%a"
    )
    if defined enumerator (
        goto :loopEnumerateConfigurations
    )
exit /b

rem ============================================================================
rem ============================================================================

:prepareParam
    if defined %~1 ( 
        call :toLower %~1 %~2
    ) else (
        set "%~1=all" 
    )
exit /b

:processConfiguration

    call :trim THIS_CONFIGURATION %~1

    @echo     [configure] %THIS_CONFIGURATION%

    if not defined THIS_CONFIGURATION (
        @echo [WARNING] skip empty configuration
        exit /b
    )

    for /F "tokens=1,2,3,4,5* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim CFG_COMPILER_TAG     %%a
        call :trim CFG_BUILD_TYPE       %%b
        call :trim CFG_ADDRESS_MODEL    %%c
        call :trim CFG_RUNTIME_CPP      %%d
        call :trim CFG_ADDITIONAL       %%e
    )
    set "THIS_CONFIGURATION="

    call :prepareParam CFG_COMPILER_TAG  %CFG_COMPILER_TAG%
    call :prepareParam CFG_BUILD_TYPE    %CFG_BUILD_TYPE%
    call :prepareParam CFG_ADDRESS_MODEL %CFG_ADDRESS_MODEL%
    call :prepareParam CFG_RUNTIME_CPP   %CFG_RUNTIME_CPP%

    if not defined CFG_ADDITIONAL (set "CFG_ADDITIONAL=none")

rem    call :debugSourceParams
    call :makeCompilerList
    call :makeBuildTypelList
    call :makeAddressModelList
    call :makeRuntimeList

rem    call :debugResultParams
    call :runCompilerList

exit /b

:debugSourceParams
    @echo processConfiguration: '%CFG_COMPILER_TAG%' : '%CFG_BUILD_TYPE%' : '%CFG_ADDRESS_MODEL%' : '%CFG_RUNTIME_CPP%' : '%CFG_ADDITIONAL%'
exit /b

:debugResultParams
    @echo   [CFG_COMPILER_TAG] .... '%CFG_COMPILER_TAG%'
    @echo   [CFG_BUILD_TYPE] ...... '%CFG_BUILD_TYPE%'
    @echo   [CFG_ADDRESS_MODEL] ... '%CFG_ADDRESS_MODEL%'
    @echo   [CFG_RUNTIME_CPP] ..... '%CFG_RUNTIME_CPP%'
exit /b

rem ============================================================================
rem ============================================================================

:runCompilerList
    for %%a in (%CFG_COMPILER_TAG%) do (
        set "CUR_COMPILER=%%~a"
        call :runAddressModelList
    )
exit /b 0

:runAddressModelList
    for %%b in (%CFG_ADDRESS_MODEL%) do (
        type nul > nul
        set "CUR_ADDRESS_MODEL=%%~b"      
        call :checkAddressModel 
        if not errorlevel 1 (call :runBuildTypelList)
    )
exit /b 0

:runBuildTypelList
    for %%c in (%CFG_BUILD_TYPE%) do (
        set "CUR_BUILD_TYPE=%%~c"
        call :runRuntimeList
    )
exit /b 0

:runRuntimeList
    for %%d in (%CFG_RUNTIME_CPP%) do (
        set "CUR_RUNTIME_CPP=%%~d"      
        call :runFinalList 
    )
exit /b 0

:runFinalList
    set "line=%CUR_COMPILER%:%CUR_BUILD_TYPE%:%CUR_ADDRESS_MODEL%:%CUR_RUNTIME_CPP%:%CFG_ADDITIONAL%"
    set "OUTPUT_CONFIGURATIONS=%OUTPUT_CONFIGURATIONS%;%line%"
exit /b 0

rem ============================================================================
rem ============================================================================

:checkAddressModel
    set "checked=%CUR_COMPILER:mingw=%"
    if not "%checked%" == "%CUR_COMPILER%" (set "group=MINGW")

    set "checked=%CUR_COMPILER:msvc=%"
    if not "%checked%" == "%CUR_COMPILER%" (set "group=MSVC")

    if not defined group (goto :failedAddressModel)

    set "list=e%group%_%CUR_ADDRESS_MODEL%_VERSIONS_TAGS"
    call set "values=%%%list%%%"

rem    @echo check...           	
rem    @echo     '%CUR_COMPILER%' in: '%list%'
rem    @echo     tags: '%values%'

    if not defined %list% (goto :failedAddressModel)
    call set "checked=%%%list%:%CUR_COMPILER%=%%"
    if "%checked%" == "%values%" (goto :failedAddressModel)
exit /b 0
:failedAddressModel
    @echo [WARNING] not support: '%CUR_COMPILER%' : '%CUR_ADDRESS_MODEL%' 
exit /b 1

rem ============================================================================
rem ============================================================================

:makeCompilerTagList
    call set "checked=%%CFG_COMPILER_TAG:%~1=%%"
    if "%checked%" == "%CFG_COMPILER_TAG%" (
        set "CFG_COMPILER_TAG=%CFG_COMPILER_TAG% %~1"
    )
exit /b

:makeCompilerList
    set "complist="
    if "%CFG_COMPILER_TAG%" == "all" (
        set "complist=%eMSVC_32_VERSIONS_TAGS% %eMSVC_64_VERSIONS_TAGS% %eMINGW_32_VERSIONS_TAGS% %eMINGW_64_VERSIONS_TAGS%"
        goto :finalCompilerList
    )
    if "%CFG_COMPILER_TAG%" == "msvc-all" (
        set "complist=%eMSVC_32_VERSIONS_TAGS% %eMSVC_64_VERSIONS_TAGS%"
        goto :finalCompilerList
    )
    if "%CFG_COMPILER_TAG%" == "mingw-all" (
        set "complist=%eMINGW_32_VERSIONS_TAGS% %eMINGW_64_VERSIONS_TAGS%"
        goto :finalCompilerList
    )
    if "%CFG_COMPILER_TAG%" == "msvc" (
        set "complist=%eMSVC_32_LAST_TAG% %eMSVC_64_LAST_TAG%"
        goto :finalCompilerList
    )
    if "%CFG_COMPILER_TAG%" == "mingw" (
        set "complist=%eMINGW_32_LAST_TAG% %eMINGW_64_LAST_TAG%"
        goto :finalCompilerList
    )
    set "complist=%CFG_COMPILER_TAG%"
:finalCompilerList
    set "CFG_COMPILER_TAG= "
    for %%a in (%complist%) do (call :makeCompilerTagList "%%~a")

    set "front=%CFG_COMPILER_TAG:~0,1%"
    if "%front%" == " " (set "CFG_COMPILER_TAG=%CFG_COMPILER_TAG:~1%")
    set "front=%CFG_COMPILER_TAG:~0,1%"
    if "%front%" == " " (set "CFG_COMPILER_TAG=%CFG_COMPILER_TAG:~1%")

    set "complist="
    set "checked="
    set "front="

exit /b

:makeRuntimeList
    if "%CFG_RUNTIME_CPP%" == "all" (
        if defined eALL_RUNTIME_CPPS (
            set "CFG_RUNTIME_CPP=%eALL_RUNTIME_CPPS%"
        ) else (
            set "CFG_RUNTIME_CPP=dynamic static"
        )
    )
exit /b

:makeAddressModelList
    if "%CFG_ADDRESS_MODEL%" == "all" (
        if defined eALL_RUNTIME_CPPS (
            set "CFG_ADDRESS_MODEL=%eALL_ADDRESS_MODELS%"
        ) else (
            set "CFG_ADDRESS_MODEL=32 64"
        )
    )
exit /b

:makeBuildTypelList
    if "%CFG_BUILD_TYPE%" == "all" (
        if defined eALL_RUNTIME_CPPS (
            set "CFG_BUILD_TYPE=%eALL_BUILD_TYPES%"
        ) else (
            set "CFG_BUILD_TYPE=debug release"
        )
    )
exit /b

rem ============================================================================
rem ============================================================================

:toLower
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        goto :failedToLower
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        goto :successToLower
    )
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:successToLower
    set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b
:failedToLower
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b 1

rem ............................................................................

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b

rem ============================================================================
rem ============================================================================

