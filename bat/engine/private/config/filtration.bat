@echo off

rem ============================================================================
rem ============================================================================
:main
    setlocal
    set "result="
    set "VARIABLE_RESULT=%~1"
    set "BUILD_CONFIGURATIONS=%~2"
    set "INCLUDE_CONFIGURATIONS=%~3"
    set "EXCLUDE_CONFIGURATIONS=%~4"

    if not defined VARIABLE_RESULT (
        @echo [ERROR] variable 'VARIABLE_RESULT' not specified
        exit /b
    )

    call :extractVariable BUILD_CONFIGURATIONS
    call :extractVariable INCLUDE_CONFIGURATIONS
    call :extractVariable EXCLUDE_CONFIGURATIONS

    if not defined BUILD_CONFIGURATIONS (
        set "%VARIABLE_RESULT%="
        exit /b
    )

    if not defined INCLUDE_CONFIGURATIONS (
        if not defined EXCLUDE_CONFIGURATIONS (
            set "%VARIABLE_RESULT%=%BUILD_CONFIGURATIONS%"
            exit /b
        )
    )

    call :removeDuplicates BUILD_CONFIGURATIONS
    call :removeDuplicates EXCLUDE_CONFIGURATIONS

    call :substract substracted  ^
        "%BUILD_CONFIGURATIONS%" ^
        "%EXCLUDE_CONFIGURATIONS%"

    if not defined INCLUDE_CONFIGURATIONS (
        set "%VARIABLE_RESULT%=%substracted%"
        exit /b
    )

    call :removeDuplicates INCLUDE_CONFIGURATIONS
    call :intersection intersected ^
        "%substracted%"            ^
        "%INCLUDE_CONFIGURATIONS%"

    endlocal & set "%VARIABLE_RESULT%=%intersected%"
exit /b

:extractVariable
    call set "var=%%%~1%%"
    if defined %var% (
        call set "val=%%%var%%%"
    ) else (
        set "val="
    )
    set "%~1=%val%"
exit /b

rem ============================================================================
rem ============================================================================

:applyConfig
    setlocal
    set "variable=%~1"
    set "THIS_CONFIGURATION=%~2"
    for /F "tokens=1,2,3,4,5* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMPILER_TAG   %%a
        call :trim eBUILD_TYPE     %%b
        call :trim eADDRESS_MODEL  %%c
        call :trim eRUNTIME_CPP    %%d
        call :trim eADDITIONAL     %%e
    )
    rem set %variable%=%eCOMPILER_TAG%: %eBUILD_TYPE%: %eADDRESS_MODEL%: %eRUNTIME_CPP%: %eADDITIONAL%

    if not defined eCOMPILER_TAG  (set "eCOMPILER_TAG=all" )
    if not defined eBUILD_TYPE    (set "eBUILD_TYPE=all"   )
    if not defined eADDRESS_MODEL (set "eADDRESS_MODEL=all")
    if not defined eRUNTIME_CPP   (set "eRUNTIME_CPP=all"  )
    if not defined eADDITIONAL    (set "eADDITIONAL=none"  )

    call :toLower result ^
        %eCOMPILER_TAG%:%eBUILD_TYPE%:%eADDRESS_MODEL%:%eRUNTIME_CPP%:%eADDITIONAL%

    endlocal & set %variable%=%result%
exit /b

:removeDuplicates
    setlocal
    set "text="
    set "RESULT_VARIABLE=%~1"
    call set "enumerator=%%%RESULT_VARIABLE%%%"
:loopDuplicates
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :checkDuplicate "%%a" 
    )
    if defined enumerator (goto :loopDuplicates)
    call :normalizeFront result "%text%"
    endlocal & set %RESULT_VARIABLE%=%result%
exit /b

:checkDuplicate
    call :applyConfig value "%~1"
    @echo "%text%" | >nul find /c "%value%" || (
        set "text=%text%; %value%"
    )
exit /b 0

rem ============================================================================
rem ============================================================================
:substract
    setlocal
    set "result="
    set "RESULT_VARIABLE=%~1"
    set "text=%~3"
    set "enumerator=%~2"
:loopSubstract
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :applySubstract "%%a" 
    )
    if defined enumerator (goto :loopSubstract)
    call :normalizeFront result "%result%"
    endlocal & set "%RESULT_VARIABLE%=%result%"
exit /b

:applySubstract
    call :trim value %~1
    @echo "%text%" | >nul find /c "%value%" || (
        set "result=%result%; %value%"
    )
exit /b 0

rem ============================================================================
rem ============================================================================
:intersection
    setlocal
    set "result="
    set "RESULT_VARIABLE=%~1"
    set "text=%~2"
    set "enumerator=%~3"
:loopIntersection
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :applyIntersection "%%a" 
    )
    if defined enumerator (goto :loopIntersection)
    call :normalizeFront result "%result%"
    endlocal & set "%RESULT_VARIABLE%=%result%"
exit /b

:applyIntersection
    call :trim value %~1
    @echo "%text%" | >nul find /c "%value%" && (
        set "result=%result%; %value%"
    )
exit /b

rem ============================================================================
rem ============================================================================

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

:toLower
    setlocal
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not specified
        goto :failedToLower
    )
    if not defined value (goto :successToLower)
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:successToLower
    endlocal & set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
exit /b
:failedToLower
    endlocal & set "%VARIABLE_NAME%="
exit /b 1

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b 0

rem ============================================================================
rem ============================================================================

