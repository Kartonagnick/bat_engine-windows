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
        set "BUILD_CONFIGURATIONS=%INCLUDE_CONFIGURATIONS%"
        set "INCLUDE_CONFIGURATIONS="
    )
    if "%BUILD_CONFIGURATIONS%" == "all" (
        set "BUILD_CONFIGURATIONS=%INCLUDE_CONFIGURATIONS%"
        set "INCLUDE_CONFIGURATIONS="
    )

    if not defined BUILD_CONFIGURATIONS (
        endlocal & set "%VARIABLE_RESULT%="
        exit /b
    )

    if not defined INCLUDE_CONFIGURATIONS (
        if not defined EXCLUDE_CONFIGURATIONS (
            endlocal & set "%VARIABLE_RESULT%=%BUILD_CONFIGURATIONS%"
            exit /b
        )
    )

    call :sortConfig BUILD_CONFIGURATIONS
    call :sortConfig EXCLUDE_CONFIGURATIONS

    call :substract substracted  ^
        "%BUILD_CONFIGURATIONS%" ^
        "%EXCLUDE_CONFIGURATIONS%"

    if not defined INCLUDE_CONFIGURATIONS (
        endlocal & set "%VARIABLE_RESULT%=%substracted%"
        exit /b
    )

    call :sortConfig INCLUDE_CONFIGURATIONS
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

:sortConfig
    if defined eSKIP_SORT (exit /b)

    setlocal
    set "RESULT_VARIABLE=%~1"
    call set "enumerator=%%%RESULT_VARIABLE%%%"
    if not defined enumerator (exit /b)
:loopSortConfig
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :applySort "%%a" 
    )
    if defined enumerator (goto :loopSortConfig)

    set result=
    for /F "tokens=2 delims=[]" %%a in ('set arr_[') do (
        call :applyDone "%%a" 
    )
    endlocal & set "%RESULT_VARIABLE%=%result%"
exit /b

:applySort
    call :trim val %~1
    for /F "tokens=1,2,3,4* delims=:" %%a in ("%val%") do (
        call :trim eCOMP %%a
        call :trim eBIT  %%b
        call :trim eTYPE %%c
        call :trim eCRT  %%d
    )
    set "val=%eCOMP%: %eBIT%: %eTYPE%: %eCRT%"
    set arr_[%val%]=dimmy
exit /b

:applyDone
    set "result=%~1;%result%"
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

:substract
    setlocal
    set "result="
    set "RESULT_VARIABLE=%~1"
    set "text=%~3"
    set "enumerator=%~2"
    if not defined enumerator (exit /b)
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
    if not defined enumerator (exit /b)
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

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b 0

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

