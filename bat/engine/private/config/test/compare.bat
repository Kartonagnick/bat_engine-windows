@echo off
rem ============================================================================
rem ============================================================================
:main
    setlocal
    set "VARIABLE_RESULT=%~1"
    set "FIRST=%~2"
    set "SECOND=%~3"

    if not defined VARIABLE_RESULT (
        @echo [ERROR] variable 'VARIABLE_RESULT' not specified
        exit /b
    )

    if not defined FIRST (
        if not defined SECOND (goto :positive)
        goto :negative
    )

    call :removeDuplicates FIRST
    call :removeDuplicates SECOND

    call :compare result "%FIRST%" "%SECOND%"
    if defined result (goto :negative)

:positive
    endlocal & set "%VARIABLE_RESULT%=true"
exit /b

:negative
    endlocal & set "%VARIABLE_RESULT%="
exit /b

rem ============================================================================
rem ============================================================================

:applyConfig
    set "variable=%~1"
    set "THIS_CONFIGURATION=%~2"
    for /F "tokens=1,2,3,4,5* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMPILER_TAG   %%a
        call :trim eBUILD_TYPE     %%b
        call :trim eADDRESS_MODEL  %%c
        call :trim eRUNTIME_CPP    %%d
        call :trim eADDITIONAL     %%e
    )
    set %variable%=%eCOMPILER_TAG%:%eBUILD_TYPE%:%eADDRESS_MODEL%:%eRUNTIME_CPP%:%eADDITIONAL%

rem    if not defined CFG_COMPILER_TAG  (set "CFG_COMPILER_TAG=all" )
rem    if not defined CFG_BUILD_TYPE    (set "CFG_BUILD_TYPE=all"   )
rem    if not defined CFG_ADDRESS_MODEL (set "CFG_ADDRESS_MODEL=all")
rem    if not defined CFG_RUNTIME_CPP   (set "CFG_RUNTIME_CPP=all"  )
rem    if not defined CFG_ADDITIONAL    (set "CFG_ADDITIONAL=none"  )

rem    call :toLower %variable% ^
rem        %eCOMPILER_TAG%: %eBUILD_TYPE%: %eADDRESS_MODEL%: %eRUNTIME_CPP%: %eADDITIONAL%

exit /b

:removeDuplicates
    set "text="
    set "var=%~1"
    call set "enumerator=%%%var%%%"

    if not defined var (
        @echo [ERROR] variable 'var' not specified
        exit /b
    )

:loopDuplicates
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :checkDuplicate "%%a" 
    )
    if defined enumerator (goto :loopDuplicates)
    set "%var%=%text%"
exit /b

:checkDuplicate
    call :applyConfig value "%~1"
    @echo "%text%" | >nul find /c "%value%" || (
        set "text=%text%;%value%"
    )
exit /b

rem ============================================================================
rem ============================================================================
:compare
    set "result=%~1"
    set "text=%~2"
    set "enumerator=%~3"

    if not defined result (
        @echo [ERROR] variable 'result'
    )

:loopCompare
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :checkWith "%%a" 
    )
    if defined enumerator (goto :loopCompare)
    call :normalizeFront %result% "%text%"
exit /b

:checkWith
    set "val=%~1"
    @echo "%text%" | >nul find /c "%val%" && (
        call set "text=%%text:%val%=%%"
    )
exit /b 0

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
    set "value="
    set "VARIABLE_NAME="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "value=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not specified
        goto :failedToLower
    )
    if not defined value (goto :successToLower)
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "value=%%value:%%~j%%"
    )
:successToLower
    endlocal & set "%VARIABLE_NAME%=%value%"
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

