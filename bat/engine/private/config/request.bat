@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================
:main
    setlocal
    rem @echo [REQUEST CONFIGURATIONS]
    set "RESULT_VARIABLE_NAME=%~1"
    set "INPUT_CONFIGURATIONS=%~2"
    set "done="

    if not defined RESULT_VARIABLE_NAME (
        @echo [ERROR] 'variable name' not specified
        exit /b 1
    )

    if not defined INPUT_CONFIGURATIONS (
        call :requestAll
        if errorlevel 1 (goto :failed)
        goto :sort
    )

    call :toLower INPUT_CONFIGURATIONS %INPUT_CONFIGURATIONS%

    if "%INPUT_CONFIGURATIONS%" == "all" (
        call :requestAll
        if errorlevel 1 (goto :failed)
        goto :sort
    )

    call :enumerateConfigurations
    if errorlevel 1 (goto :failed)
    rem if defined done (goto :success)

:sort 
    call :sortConfigurations 
    call :normalizeLast result "%result%"

:success
    rem @echo [REQUEST CONFIGURATIONS] completed successfully
    endlocal & set "%RESULT_VARIABLE_NAME%=%result%"
exit /b

:failed
    @echo [REQUEST CONFIGURATIONS] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:sortConfigurations
    set "enumerator=%result%"
:loopSortConfigurations
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :applySort "%%a" 
    )
    if defined enumerator (goto :loopSortConfigurations)

    set result=
    for /F "tokens=2 delims=[]" %%a in ('set arr_[') do (
        call :applyDone "%%a" 
    )
exit /b

:applySort
    call :trim val %~1
    set arr_[%val%]=dimmy
exit /b

:applyDone
    set "result=%~1; %result%"
exit /b

rem ============================================================================
rem ============================================================================

:enumerateConfigurations
    set "enumerator=%INPUT_CONFIGURATIONS%"
:loopEnumerateConfigurations
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :processConfiguration "%%a"
        if errorlevel 1 (exit /b 1)
        if defined done (exit /b)
    )
    if defined enumerator (goto :loopEnumerateConfigurations)
exit /b

:processConfiguration
    call :trim THIS_CONFIGURATION %~1
    rem @echo     [configure] %THIS_CONFIGURATION%

    if not defined THIS_CONFIGURATION (
        @echo [WARNING] skip empty configuration
        exit /b
    )

    for /F "tokens=1,2,3,4* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMP %%a
        call :trim eBIT  %%b
        call :trim eTYPE %%c
        call :trim eCRT  %%d
    )
    if not defined eCOMP (set "eCOMP=all")
    if not defined eBIT  (set "eBIT=all" )
    if not defined eTYPE (set "eTYPE=all")
    if not defined eCRT  (set "eCRT=all" )

    if "%eCOMP%:%eBIT%:%eTYPE%:%eCRT%" == "all:all:all:all" (
        call :requestAll
        set "done=ON"
        exit /b
    )

    rem @echo [%eCOMP%][%eBIT%][%eTYPE%][%eCRT%]

    set "version=%eCOMP:mingw=%"
    if not "%version%" == "%eCOMP%" (
        set "group=mingw"
        goto :next
    )

    set "version=%eCOMP:msvc=%"
    if not "%version%" == "%eCOMP%" (set "group=msvc")

    rem @echo [eCOMP=%eCOMP%][group=%group%][version=%version%]
:next
    call :trimBegin version %version%

    if "%eBIT%" == "all" (
        set "bits=%eALL_ADDRESS_MODELS%"
    ) else (
        set "bits=%eBIT%"
        call :checkPressent "%eBIT%" "%eALL_ADDRESS_MODELS%"
        if errorlevel 1 (
            @echo [ERROR] unknown 'address-model' : %eBIT%
            exit /b 1
        )
    )

    if "%eTYPE%" == "all" (
        set "types=%eALL_BUILD_TYPES%"
    ) else (
        set "types=%eTYPE%"
        call :checkPressent "%eTYPE%" "%eALL_BUILD_TYPES%"
        if errorlevel 1 (
            @echo [ERROR] unknown 'build-type' : %eTYPE%
            exit /b 1
        )
    )

    if "%eCRT%" == "all" (
        set "crts=%eALL_RUNTIME_CPPS%"
    ) else (
        set "crts=%eCRT%"
        call :checkPressent "%eCRT%" "%eALL_RUNTIME_CPPS%"
        if errorlevel 1 (
            @echo [ERROR] unknown 'crt' : %eCRT%
            exit /b 1
        )
    )

    if "%eCOMP%" == "%group%" (
        rem @echo [LAST-%eCOMP%]
        for %%b in (%bits%) do (
            call :requestLastCompilers "%eCOMP%" "%%~b"
            if errorlevel 1 (exit /b 1)
        )
        goto :doneConfigs
    )

    if "%eCOMP%" == "all" (
        rem @echo [ALL-COMPILERS]
        for %%a in (%eALL_COMPILERS%) do (
            for %%b in (%bits%) do (
                call :requestCompilers "%%~a" "%%~b"
                if errorlevel 1 (exit /b 1)
            )
        )
        goto :doneConfigs
    )

    if "%eCOMP%" == "%group%-all" (
        rem @echo [ALL-%group%]
        for %%b in (%bits%) do (
            call :requestCompilers "%group%" "%%~b"
            if errorlevel 1 (exit /b 1)
        )
        goto :doneConfigs
    )
    if "%eCOMP%" == "%group%all" (
        rem @echo [ALL-%group%]
        for %%b in (%bits%) do (
            call :requestCompilers "%group%" "%%~b"
            if errorlevel 1 (exit /b 1)
        )
        goto :doneConfigs
    )

    rem @echo [concrete %group%-%version%]
    for %%b in (%bits%) do (
        call :requestCompilerVersion "%group%" "%version%" "%%~b"
        if errorlevel 1 (exit /b 1)
    )

:doneConfigs
    call :normalizeFront result "%result%"
exit /b

:checkPressent 
    setlocal
    set "vals=%~2"
    call set "check=%%vals:%~1=%%"
    if "%check%" == "%vals%" (exit /b 1)
exit /b 0

:checkCompiler
    rem %~1 group
    rem %~2 version
    rem %~3 bit
    call set "vers=%%e%~1_%~3_VERSIONS%%" 
    call :checkPressent "%~2" "%vers%"
    if errorlevel 1 (
        @echo [ERROR] compiler not found: %~1%~2: %~3 
        exit /b 1
    )
exit /b

:requestCompilerVersion
    rem %~1 group
    rem %~2 version
    rem %~3 bit

    call set "value=%%e%~1%~2_%~3%%" 
    rem @echo [value] %%e%~1%~2_%~3%%

    if not defined value (
        call :checkCompiler "%~1" "%~2" "%~3"
        if errorlevel 1 (exit /b)
    )

    for %%d in (%types%) do (
        for %%f in (%crts%) do (
            rem @echo %~1%%~c: %~2: %%d: %%f
            call :addCfg "%~1%~2: %~3: %%d: %%f"
        )
    )
exit /b

:requestLastCompilers
    rem %~1 compiler
    rem %~2 bit
    call set "vers=%%e%~1_%~2_LAST%%"
    goto :loopCompilers "%~1" "%~2"
exit /b

:requestCompilers
    rem %~1 compiler
    rem %~2 bit
    call set "vers=%%e%~1_%~2_VERSIONS%%" 
:loopCompilers
    for %%c in (%vers%) do (
        for %%d in (%types%) do (
            for %%f in (%crts%) do (
                rem @echo %~1%%~c: %~2: %%d: %%f
                call :addCfg "%~1%%c: %~2: %%d: %%f"
            )
        )
    )
exit /b

rem ============================================================================
rem ============================================================================

:addCfg
    set "result=%result%; %~1"
exit /b

:requestAllCompilers
    rem %~1 compiler
    rem %~2 bit
    call set "vers=%%e%~1_%~2_VERSIONS%%" 
    for %%c in (%vers%) do (
        for %%d in (%eALL_BUILD_TYPES%) do (
            for %%f in (%eALL_RUNTIME_CPPS%) do (
                rem @echo %~1%%c: %~2: %%d: %%f
                call :addCfg "%~1%%c: %~2: %%d: %%f"
            )
        )
    )
exit /b

:requestAll
    rem @echo [OPTIMIZATION] 'all'
    set "result="
    for %%a in (%eALL_COMPILERS%) do (
        for %%b in (%eALL_ADDRESS_MODELS%) do (
            call :requestAllCompilers "%%~a" "%%~b"
        )
    )
    call :normalizeFront result "%result%"
exit /b

rem ============================================================================
rem === [deprecated] ===========================================================

:removeDuplicates
    setlocal
    set "text="
    set "value="
    set "RESULT_VARIABLE=%~1"
    call set "enumerator=%%%RESULT_VARIABLE%%%"
    if not defined enumerator (exit /b)
:loopDuplicates
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :checkDuplicate "%%a" 
    )
    if defined enumerator (goto :loopDuplicates)
    call :normalizeFront result "%text%"
    endlocal & set "%RESULT_VARIABLE%=%result%"
exit /b

:checkDuplicate
    call :trim value %~1
    if not defined value (exit /b)

    set "text=%text%; %value%"

    if not defined enumerator (exit /b)
    call set "enumerator=%%enumerator:%value%=%%"
    rem @echo [enumerator] "%enumerator%"
exit /b

rem ============================================================================
rem ============================================================================

:toLower
    setlocal
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        goto :toLowerFailed
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        goto :toLowerSuccess
    )
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:toLowerSuccess
    endlocal & set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
exit /b
:toLowerFailed
    endlocal
exit /b 1

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

:normalizeLast
    setlocal
    set "RETVAL=%~2"

:removeLastChar
    set "last=%RETVAL:~-1%"

    if "%last%" == ";" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeLastChar
    )
    if "%last%" == " " (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeLastChar
    )
    endlocal & set "%~1=%RETVAL%"
exit /b

:normalizeFront
    setlocal
    set "RETVAL=%~2"
:removeFirstChar
    set "front=%RETVAL:~0,1%"
    if "%front%" == ";" (
        set "RETVAL=%RETVAL:~1%"
        goto :removeFirstChar
    )
    if "%front%" == " " (
        set "RETVAL=%RETVAL:~1%"
        goto :removeFirstChar
    )
    endlocal & set "%~1=%RETVAL%"
exit /b

:trimBegin
    setlocal
    set "RETVAL=%~2"
:removeFirstCharB
    set "front=%RETVAL:~0,1%"
    if "%front%" == "-" (
        set "RETVAL=%RETVAL:~1%"
        goto :removeFirstCharB
    )
    endlocal & set "%~1=%RETVAL%"
exit /b

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b

rem ============================================================================
rem ============================================================================

:init
    if defined ALREADY_REQUEST_PREPARED (exit /b) 
    set "ALREADY_REQUEST_PREPARED=yes"

    call :normalizePath eBAT_SETTINGS ^
        "%~dp0..\settings.bat"

    if not exist "%eBAT_SETTINGS%" (
        @echo [ERROR] not exist: 'eBAT_SETTINGS'
        @echo [ERROR] "%eBAT_SETTINGS%"
        exit /b 1
    )

    call "%eBAT_SETTINGS%"
    if errorlevel 1 (
        @echo [ERROR] eBAT_SETTINGS finished with error
        @echo [ERROR] "%eBAT_SETTINGS%"
        exit /b 1
    )

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
    call :init
exit /b

rem ============================================================================
rem ============================================================================

