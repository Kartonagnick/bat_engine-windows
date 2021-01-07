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

    call :toLower FIRST  %FIRST% 
    call :toLower SECOND %SECOND% 

    call :sort FIRST
    call :sort SECOND
    
    @echo [compare] ----------------------------x
    call "%viewVariables%" FIRST
    call "%viewVariables%" SECOND

    call :compare result "%FIRST%" "%SECOND%"
    @echo [compare] ----------------------------[%result%]
    if errorlevel 1   (goto :negative)
    if defined result (goto :negative)

:positive
    endlocal & set "%VARIABLE_RESULT%=true"
exit /b

:negative
    endlocal & set "%VARIABLE_RESULT%="
exit /b

rem ============================================================================
rem ============================================================================

:sort
    setlocal
    set "RESULT_VARIABLE=%~1"
    call set "enumerator=%%%RESULT_VARIABLE%%%"
    if not defined enumerator (exit /b)
:loopSort
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :applySort "%%a" 
    )
    if defined enumerator (goto :loopSort)

    set result=
    for /F "tokens=2 delims=[]" %%a in ('set arr_[') do (
        call :applyDone "%%a" 
    )
    endlocal & set "%RESULT_VARIABLE%=%result%"
exit /b

:applyConfig
    set "variable=%~1"
    set "THIS_CONFIGURATION=%~2"
    for /F "tokens=1,2,3,4* delims=:" %%a in ("%THIS_CONFIGURATION%") do (
        call :trim eCOMP %%a
        call :trim eBIT  %%b
        call :trim eTYPE %%c
        call :trim eCRT  %%d
    )
    set "%variable%=%eCOMP%:%eBIT%:%eTYPE%:%eCRT%"
exit /b

:applySort
    call :applyConfig val "%~1"
    set arr_[%val%]=dimmy
exit /b

:applyDone
    set "result=%~1;%result%"
exit /b

rem ============================================================================
rem ============================================================================
:compare
    set "variable=%~1"
    set "text=%~2"
    set "enumerator=%~3"
    if not defined variable (@echo [ERROR] variable 'result')
    set "%variable%="
:loopCompare
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        set "enumerator=%%b"
        call :checkCompare "%%a" 
        if errorlevel 1 (exit /b 1)
    )
    if defined enumerator (goto :loopCompare)
    call :normalizeFront %variable% "%text%"
exit /b
        
:checkCompare
    set "val=%~1"
    call set "check=%%text:%val%=%%"
    if "%check%" == "%text%" (exit /b 1)
    call set "text=%check%"
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

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b 0

rem ============================================================================
rem ============================================================================

